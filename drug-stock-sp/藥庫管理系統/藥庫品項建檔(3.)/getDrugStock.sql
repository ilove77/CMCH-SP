USE [HealthResource]
GO

--- 程序名稱: getDrugStock
--- 程序說明: 取得藥品庫存檔
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/07/19
CREATE PROCEDURE [dbo].[getDrugStock](@params NVARCHAR(MAX))
AS BEGIN 
   DECLARE @stockNo  CHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @drugCode INT      = JSON_VALUE(@params, '$.drugCode');

   SELECT [stockNo]       = a.StockNo,
          [drugCode]      = a.DrugCode,
          [stockUnit]     = a.StockUnit,
          [stockRatio]    = a.StockRatio,
          [packageQty]    = a.PackageQty,
          [purchaseDays]  = a.PurchaseDays,
          [warnDays]      = a.WarnDays,
          [purchaseQty]   = a.PurchaseQty,
          [reorderPoint]  = a.ReorderPoint,
          [safetyQty]     = a.SafetyQty,
          [totalQty]      = a.TotalQty,
          [maxQty]        = a.MaxQty,
          [supplyType]    = a.SupplyType,
          [drugType]      = a.DrugType,
          [keepType]      = a.KeepType,
          [purchaseType]  = a.PurchaseType,
          [invType]       = a.InvType,
          [storageNo]     = a.StorageNo,
          [supplyStock]   = a.SupplyStock,
          [isComplexIn]   = a.IsComplexIn,
          [isInvList]     = a.IsInvList,
          [startTime]     = a.StartTime,
          [endTime]       = a.EndTime,
          [lastTime]      = a.LastTime,
          [lastQty]       = a.LastQty,
          [monthTime]     = a.MonthTime,
          [monthQty]      = a.MonthQty,
          [invTime]       = a.InvTime,
          [invQty]        = a.InvQty,
          [systemUser]    = a.SystemUser,
          [systemTime]    = a.SystemTime,
          [onWayQty]      = [fn].[getDrugOnWayQty](a.stockNo, a.DrugCode),
          [stockTotalQty] = [fn].[getDrugStockTotalQty]('drugStock', a.StockNo, a.DrugCode)
     FROM [dbo].[DrugStockMt] AS a
    WHERE a.StockNo  = @stockNo
      AND a.DrugCode = @drugCode
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P11",
   "drugCode": 3678
}
';

EXEC [dbo].[getDrugStock] @params
GO
