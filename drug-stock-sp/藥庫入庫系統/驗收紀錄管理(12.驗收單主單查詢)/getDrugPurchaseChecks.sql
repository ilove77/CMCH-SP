USE [HealthResource]
GO

--- 程序名稱：getDrugPurchaseChecks
--- 程序說明：取得藥品採購驗收資訊
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
   
   SELECT [purchaseNo]     = a.PurchaseNo,     
          [purchaseTime]   = b.PurchaseTime,      
          [remQty]         = a.DemandQty,    
          [purchaseQty]    = a.PurchaseQty,   
          [giftQty]        = a.GiftQty,
          [checkQty]       = a.CheckQty,       
          [medCode]        = c.MedCode,      
          [drugCode]       = a.DrugCode,      
          [drugName]       = c.DrugName,      
          [orgNo]          = b.OrgNo,
          [deliveryTime]   = b.DeliveryTime,
          [orgName]        = [fn].[getOrgName](b.orgNo),              
          [unitName]       = [fn].[getUnitBasicName](a.unit),
          [stockName]      = [fn].[getShortName](a.InStockNo),
          [remPurchaseQty] = [fn].[getDrugPurchaseQty](a.PurchaseNo, a.DrugCode),
          [remGiftQty]     = [fn].[getDrugGiftQty](a.PurchaseNo, a.DrugCode)
     FROM [dbo].[DrugPurchaseDt] AS a,
          [dbo].[DrugPurchaseMt] AS b,
          [dbo].[DrugBasic]      AS c
    WHERE a.InStockNo      LIKE @stockNo
      AND a.DrugCode       = [fn].[numberFilter](@drugCode, a.DrugCode)
      AND a.PurchaseNo     = [fn].[numberFilter](@purchaseNo, a.PurchaseNo) 
      AND b.PurchaseNo     = a.PurchaseNo
      AND b.PurchaseTime   BETWEEN  @purchaseTime1   AND @purchaseTime2
      AND b.PurchaseStatus BETWEEN  @purchaseStatus1 AND @purchaseStatus2 
      AND b.OrgNo          = [fn].[stringFilter](@orgNo, b.OrgNo)
      AND c.DrugCode       = a.DrugCode
      AND c.StartTime     <= b.PurchaseTime
      AND c.EndTime       >= b.PurchaseTime
      AND c.MedCode        = [fn].[stringFilter](@medCode, c.MedCode)
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(max) =
'
{
    "medCode": "",
    "drugCode": 0,
    "orgNo": "",
    "purchaseNo": 0,
    "purchaseDate1": "2021-08-10",
    "purchaseDate2": "2021-08-17",
    "stockNo": "1%"
}
'

EXEC [dbo].[getDrugPurchaseChecks] @params
GO
