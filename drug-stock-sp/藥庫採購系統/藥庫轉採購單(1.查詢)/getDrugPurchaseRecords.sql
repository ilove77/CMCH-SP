USE [HealthResource]
GO

--- 程序名稱：getDrugPurchaseRecords
--- 程序說明：取得藥庫採購資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/31
CREATE PROCEDURE [dbo].[getDrugPurchaseRecords](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo            CHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @orgNo              CHAR(10) = JSON_VALUE(@params, '$.orgNo');
   DECLARE @drugCode           INT      = JSON_VALUE(@params, '$.drugCode');
   DECLARE @purchaseType       TINYINT  = JSON_VALUE(@params, '$.purchaseType');
   DECLARE @lastMonth          INT      = [fn].[getLastMonth](JSON_VALUE(@params, '$.currentDate'));
   DECLARE @itemType           TINYINT  = 10; --項目類別 => 10: 藥庫
   DECLARE @currentTime        DATETIME = GETDATE();

   SELECT [stockNo]       = a.StockNo,
          [medCode]       = b.MedCode,
          [drugName]      = b.GenericName1,
          [drugCode]      = b.DrugCode,
          [totalQty]      = a.TotalQty,
          [safetyQty]     = a.SafetyQty,
          [packageQty]    = a.PackageQty,
          [purchaseDays]  = a.PurchaseDays,
          [buyQty]        = a.purchaseQty,
          [warnDate]      = c.WarnDate,
          [onWayQty]      = [fn].[getDrugOnWayQty](a.StockNo, b.DrugCode),                   
          [unitName]      = [fn].[getUnitBasicName](b.ChargeUnit),                           
          [stockTotalQty] = [fn].[getDrugStockTotalQty]('DrugStock', a.StockNo, a.DrugCode), 
          [stockMonthQty] = [fn].[getDrugStockMonthQty]('DrugStock', a.StockNo, a.drugCode, @lastMonth)  
     FROM [dbo].[DrugStockMt]   AS a,
          [dbo].[DrugBasic]     AS b,
          [dbo].[PurchaseBasic] AS c
     WHERE a.StockNo      = @stockNo
       AND a.DrugCode     = [fn].[numberFilter](@drugCode, a.DrugCode)
       AND a.PurchaseType = @purchaseType   
       AND a.StartTime   <= @currentTime
       AND a.EndTime     >= @currentTime
       AND b.DrugCode     = a.DrugCode   
       AND b.StartTime   <= @currentTime
       AND b.EndTime     >= @currentTime
       AND c.ItemCode     = a.DrugCode
       AND c.ItemType     = @itemType
       AND c.Represent    = [fn].[stringFilter](@orgNo, c.Represent)
       AND c.StartTime   <= @currentTime
       AND c.EndTime     >= @currentTime
       ORDER BY b.MedCode
       FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P11",
   "orgNo": "",
   "drugCode": "3678",
   "purchaseType": 5,
   "currentDate": "2021-09-01"
}
';

EXEC [dbo].[getDrugPurchaseRecords] @params
GO