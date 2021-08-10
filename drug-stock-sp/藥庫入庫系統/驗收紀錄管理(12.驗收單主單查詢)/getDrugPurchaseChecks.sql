USE [HealthResource]
GO
--- 程序名稱：getDrugPurchaseChecks
--- 程序說明：取得藥品驗收資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/06/29
CREATE PROCEDURE [dbo].[getDrugPurchaseChecks](@params NVARCHAR(MAX))
AS BEGIN 
   DECLARE @orgNo           CHAR(10)    = JSON_VALUE(@params, '$.orgNo');
   DECLARE @purchaseNo      INT         = JSON_VALUE(@params, '$.purchaseNo');
   DECLARE @drugCode        INT         = JSON_VALUE(@params, '$.drugCode') ;
   DECLARE @medCode         CHAR(08)    = JSON_VALUE(@params, '$.medCode');
   DECLARE @stockNo         VARCHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @purchaseTime1   DATETIME    = [fn].[getDateMinTime](JSON_VALUE(@params, '$.purchaseDate1'));
   DECLARE @purchaseTime2   DATETIME    = [fn].[getDateMaxTime](JSON_VALUE(@params, '$.purchaseDate2'));
   DECLARE @purchaseStatus1 TINYINT     = 10;
   DECLARE @purchaseStatus2 TINYINT     = 69;
   
   SELECT b.PurchaseNo   AS [purchaseNo],  
          a.PurchaseTime AS [purchaseTime],        
          b.DemandQty    AS [demandQty],
          b.PurchaseQty  AS [purchaseQty],
          b.GiftQty      AS [giftQty],
          c.MedCode      AS [medCode],
          b.DrugCode     AS [drugCode],
          c.DrugName     AS [drugName],
          a.OrgNo        AS [orgNo],      
          b.CheckQty     AS [checkQty],
          [fn].[getUnitBasicName](b.unit)  AS [unitName],
          [fn].[getShortName](b.InStockNo) AS [stockName]
     FROM [dbo].[DrugPurchaseMt] AS a,
          [dbo].[DrugPurchaseDt] AS b,
          [dbo].[DrugBasic]      AS c
    WHERE a.PurchaseTime   BETWEEN  @purchaseTime1   AND @purchaseTime2
      AND a.PurchaseStatus BETWEEN  @purchaseStatus1 AND @purchaseStatus2
      AND a.PurchaseNo     = [fn].[numberFilter](@purchaseNo, a.PurchaseNo)
      AND a.OrgNo          = [fn].[stringFilter](@orgNo, a.OrgNo)
      AND b.PurchaseNo     = a.PurchaseNo
      AND b.DrugCode       = [fn].[numberFilter](@drugCode, b.DrugCode)     
      AND b.InStockNo      LIKE @stockNo
      AND c.MedCode        = [fn].[stringFilter](@medCode, c.MedCode)
      AND c.DrugCode       = b.DrugCode
      AND c.StartTime     <= a.PurchaseTime
      AND c.EndTime       >= a.PurchaseTime
    ORDER BY a.PurchaseNo
END
GO

DECLARE @params NVARCHAR(max) =
'
{
    "medCode": "",
    "drugCode": 0,
    "orgNo": "",
    "purchaseNo": 0,
    "purchaseDate1": "2021-06-21",
    "purchaseDate2": "2021-06-28",
    "stockNo": "1%"
}
'
EXEC [dbo].[getDrugPurchaseChecks] @params
GO
