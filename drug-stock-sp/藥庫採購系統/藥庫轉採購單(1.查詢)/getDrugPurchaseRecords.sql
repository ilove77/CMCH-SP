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
   DECLARE @medCode            CHAR(08) = JSON_VALUE(@params, '$.medCode');
   DECLARE @lastMonthStartTime DATETIME = JSON_VALUE(@params, '$.lastMonthStartTime');
   DECLARE @lastMonthEndTime   DATETIME = JSON_VALUE(@params, '$.lastMonthEndTime');
   DECLARE @itemType           TINYINT  = 10; 
   DECLARE @currentTime        DATETIME = GETDATE();

    SELECT [medCode]               = b.MedCode,
           [genericName]           = b.GenericName1,
           [drugCode]              = b.DrugCode,
           [totalQty]              = a.TotalQty,
           [safetyQty]             = a.SafetyQty,
           [packageQty]            = a.PackageQty,
           [buyQty]                = a.PurchaseQty,
           [onWayQty]              = [fn].[getDrugOnWayQty](a.StockNo, b.DrugCode),                   
           [unitName]              = [fn].[getUnitBasicName](b.ChargeUnit),                           
           [hospitalQty]           = [fn].[getDrugStockTotalQty]('DrugStock', a.StockNo, b.DrugCode), 
           [totalInStockGrantQty]  = [fn].[getDrugBranchInStockGrantQty]('DrugStock', a.stockNo, b.drugCode, @lastMonthStartTime, @lastMonthEndTime), 
           [totalOutStockGrantQty] = [fn].[getDrugBranchOutStockGrantQty]('DrugStock', a.stockNo, b.drugCode, @lastMonthStartTime, @lastMonthEndTime)
      FROM DrugStockMt   AS a,
           DrugBasic     AS b,
           PurchaseBasic AS c
     WHERE a.StockNo    = @stockNo   
       AND a.StartTime <= @currentTime
       AND a.EndTime   >= @currentTime
       AND b.DrugCode   = a.DrugCode
       AND b.StartTime <= @currentTime
       AND b.EndTime   >= @currentTime
       AND b.MedCode    = [fn].[stringFilter](@medCode, b.MedCode)
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
   "lastMonthStartTime": "2021-06-01 00:00:00.000",
   "lastMonthEndTime": "2021-06-30 00:00:00.000"
}
';

EXEC [dbo].[getDrugPurchaseRecords] @params
GO