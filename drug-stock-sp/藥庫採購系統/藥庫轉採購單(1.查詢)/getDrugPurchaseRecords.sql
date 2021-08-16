USE [HealthResource]
GO

--- 程序名稱：getDrugPurchaseRecords
--- 程序說明：取得藥庫採購資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/30
CREATE PROCEDURE [dbo].[getDrugPurchaseRecords](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo            CHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @orgNo              CHAR(10) = JSON_VALUE(@params, '$.orgNo');
   DECLARE @drugCode           INT      = JSON_VALUE(@params, '$.drugCode');
   DECLARE @lastMonth          INT      = [fn].[getLastMonth](JSON_VALUE(@params, '$.currentDate'));
   DECLARE @itemType           TINYINT  = 10; 
   DECLARE @currentTime        DATETIME = GETDATE();

    SELECT [medCode]               = b.MedCode,
           [genericName]           = b.GenericName1,
           [drugCode]              = b.DrugCode,
           [totalQty]              = a.TotalQty,
           [safetyQty]             = a.SafetyQty,
           [packageQty]            = a.PackageQty,
           [purchaseDays]          = a.PurchaseDays,
           [buyQty]                = [fn].[getDrugBuyQty](a.PurchaseType, [fn].[getDrugStockMonthQty]('DrugStock', a.StockNo, b.drugCode, @lastMonth),a.PurchaseQty, a.PackageQty),
           [onWayQty]              = [fn].[getDrugOnWayQty](a.StockNo, b.DrugCode),                   
           [unitName]              = [fn].[getUnitBasicName](b.ChargeUnit),                           
           [stockTotalQty]         = [fn].[getDrugStockTotalQty]('DrugStock', a.StockNo, b.DrugCode), 
           [stockMonthQty]         = [fn].[getDrugStockMonthQty]('DrugStock', a.SupplyStock, b.drugCode, @lastMonth)  
      FROM DrugStockMt   AS a,
           DrugBasic     AS b,
           PurchaseBasic AS c
     WHERE a.StockNo    = @stockNo
       AND a.DrugCode   = [fn].[numberFilter](@drugCode, a.DrugCode)   
       AND a.StartTime <= @currentTime
       AND a.EndTime   >= @currentTime
       AND b.DrugCode   = a.DrugCode
       AND b.StartTime <= @currentTime
       AND b.EndTime   >= @currentTime
       AND c.ItemCode   = a.DrugCode
       AND c.ItemType   = @itemType
       AND c.Represent  = [fn].[stringFilter](@orgNo, c.Represent)
       AND c.StartTime <= @currentTime
       AND c.EndTime   >= @currentTime
       ORDER BY b.MedCode
       FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P11",
   "orgNo": "",
   "medCode": "IATTTEST",
   "currentDate": "2021-08-09"
}
';

EXEC [dbo].[getDrugPurchaseRecords] @params
GO