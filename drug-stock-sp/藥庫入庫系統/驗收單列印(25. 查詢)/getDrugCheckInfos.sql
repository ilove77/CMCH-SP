USE [HealthResource]
GO

--- 程序名稱：getDrugCheckInfos
--- 程序說明：取得藥庫驗收單資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/06/25
CREATE PROCEDURE [dbo].[getDrugCheckInfos](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @branchNo    INT      = JSON_VALUE(@params, '$.branchNo');
   DECLARE @medCode     CHAR(08) = JSON_VALUE(@params, '$.medCode');
   DECLARE @purchaseNo  INT      = JSON_VALUE(@params, '$.purchaseNo');
   DECLARE @orgNo       CHAR(10) = JSON_VALUE(@params, '$.orgNo')
   DECLARE @checkTime1  DATETIME = [fn].[getDateMinTime](JSON_VALUE(@params, '$.checkDate1'));
   DECLARE @checkTime2  DATETIME = [fn].[getDateMaxTime](JSON_VALUE(@params, '$.checkDate2'));
   DECLARE @numberType  INT      = 10;
   
   SELECT a.CheckNo     AS [checkNo],
          c.PurchaseNo  AS [purchaseNo],
          a.CheckTime   AS [checkTime],
          f.MedCode     AS [medCode],
          f.DrugName    AS [drugName],
          a.CheckQty    AS [checkOty],
          a.InvoiceNo   AS [invoiceNo],
          d.InvoiceDate AS [invoiceDate],
          c.OrgNo       AS [orgNo],
          e.DisplayNo   AS [displayNo],
          [fn].[getOrgName](c.OrgNo)      AS [orgName],
          [fn].[getUnitBasicName](b.Unit) AS [unitName]
     FROM [dbo].[DrugChecking]   AS a,
          [dbo].[DrugPurchaseDt] AS b,
          [dbo].[DrugPurchaseMt] AS c,
          [dbo].[InvoiceRecord]  AS d,
          [dbo].[NumberMaping]   AS e,
          [dbo].[DrugBasic]      AS f
    WHERE a.CheckTime >= @checkTime1
      AND a.CheckTime <= @checkTime2
      AND a.PurchaseNo = [fn].[numberFilter](@purchaseNo, a.PurchaseNo)
      AND b.DrugCode   = a.DrugCode
      AND b.PurchaseNo = a.PurchaseNo
      AND c.PurchaseNo = a.PurchaseNo
      AND c.OrgNo      = [fn].[stringFilter](@orgNo, c.OrgNo)
      AND d.PurchaseNo = a.PurchaseNo
      AND d.InvoiceNo  = a.InvoiceNo
      AND e.SourceNo   = a.CheckNo
      AND e.NumberType = @numberType
      AND e.BranchNo   = @branchNo
      AND f.DrugCode   = a.DrugCode
      AND f.MedCode    = [fn].[stringFilter](@medCode, f.MedCode)
      AND f.StartTime <= a.CheckTime
      AND f.EndTime   >= a.CheckTime
    ORDER BY e.displayNo ASC
      FOR JSON PATH
END     
GO

DECLARE @params nvarchar(max) =
'
{
    "branchNo": 1,
    "checkDate1": "2021-06-11",
    "checkDate2": "2021-06-25",
    "medCode": "INS500",
    "orgNo": "007",
    "purchaseNo": 0,
}
'
EXEC [dbo].[getDrugCheckInfos] @params
GO