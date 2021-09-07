USE [HealthResource]
GO

--- 程序名稱：getDrugPurchaseRecords
--- 程序說明：取得藥庫採購資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/09/07
CREATE PROCEDURE [dbo].[getDrugPurchaseRecords](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo      CHAR(04)    = JSON_VALUE(@params, '$.stockNo');
   DECLARE @orgNo        CHAR(10)    = JSON_VALUE(@params, '$.orgNo');
   DECLARE @drugCode     INT         = JSON_VALUE(@params, '$.drugCode');
   DECLARE @medCode      VARCHAR(10) = JSON_VALUE(@params, '$.medCode');
   DECLARE @purchaseType TINYINT     = JSON_VALUE(@params, '$.purchaseType');
   DECLARE @lastMonth    INT         = [fn].[getLastMonth](JSON_VALUE(@params, '$.currentDate'));
   DECLARE @itemType     TINYINT     = 10; --項目類別 => 10: 藥庫
   DECLARE @currentTime  DATETIME    = GETDATE();

   SELECT [stockNo]       = a.StockNo,
          [medCode]       = c.MedCode,
          [drugName]      = c.GenericName1,
          [drugCode]      = c.DrugCode,
          [totalQty]      = a.TotalQty,
          [safetyQty]     = a.SafetyQty,
          [packageQty]    = a.PackageQty,
          [purchaseType]  = a.PurchaseType,
          [purchaseDays]  = a.PurchaseDays,
          [buyQty]        = a.PurchaseQty,
          [warnDate]      = b.WarnDate,
          [onWayQty]      = [fn].[getDrugOnWayQty](a.StockNo, a.DrugCode),                   
          [unitName]      = [fn].[getUnitBasicName](c.ChargeUnit),
          [stockTotalQty] = [fn].[getDrugStockTotalQty]('DrugStock', a.StockNo, a.DrugCode),
          [stockMonthQty] = [fn].[getDrugStockMonthQty]('DrugStock', a.StockNo, a.DrugCode, @lastMonth)  
     FROM [dbo].[DrugStockMt]   AS a,
          [dbo].[PurchaseBasic] AS b,
          [dbo].[DrugBasic]     AS c        
    WHERE a.StockNo      = @stockNo
      AND a.DrugCode     = [fn].[numberFilter](@drugCode, a.DrugCode)
      AND a.PurchaseType = @purchaseType   
      AND a.StartTime   <= @currentTime
      AND a.EndTime     >= @currentTime
      AND b.ItemCode     = a.DrugCode
      AND b.ItemType     = @itemType
      AND b.Represent    = [fn].[stringFilter](@orgNo, b.Represent)
      AND b.StartTime   <= @currentTime
      AND b.EndTime     >= @currentTime
      AND c.DrugCode     = a.DrugCode
      AND c.MedCode      LIKE [fn].[stringFilter](@medCode, c.MedCode)   
      AND c.StartTime   <= @currentTime
      AND c.EndTime     >= @currentTime
    ORDER BY c.MedCode
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P11",
   "orgNo": "",
   "drugCode": "",
   "medCode": "C%",
   "purchaseType": 80,
   "currentDate": "2021-09-01"
}
';

EXEC [dbo].[getDrugPurchaseRecords] @params
GO