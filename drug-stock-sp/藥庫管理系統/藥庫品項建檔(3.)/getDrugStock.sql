USE [HealthResource]
GO

--- 程序名稱: getDrugStock
--- 程序說明: 取得藥品庫存檔
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/07/19
ALTER PROCEDURE [dbo].[getDrugStock](@params NVARCHAR(MAX))
AS BEGIN 
   DECLARE @stockNo  CHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @drugCode INT      = JSON_VALUE(@params, '$.drugCode');

   SELECT a.StockNo      AS [stockNo],
          a.DrugCode     AS [drugCode],
          a.StockUnit    AS [stockUnit],
          a.StockRatio   AS [stockRatio],
          a.PackageQty   AS [packageQty],
          a.PurchaseDays AS [purchaseDays],
          a.WarnDays     AS [warnDays],
          a.PurchaseQty  AS [purchaseQty],
          a.ReorderPoint AS [reorderPoint],
          a.SafetyQty    AS [safetyQty],
          a.TotalQty     AS [totalQty],
          a.MaxQty       AS [maxQty],
          a.SupplyType   AS [supplyType],
          a.DrugType     AS [drugType],
          a.KeepType     AS [keepType],
          a.PurchaseType AS [purchaseType],
          a.InvType      AS [invType],
          a.StorageNo    AS [storageNo],
          a.SupplyStock  AS [supplyStock],
          a.IsComplexIn  AS [isComplexIn],
          a.IsInvList    AS [isInvList],
          a.StartTime    AS [startTime],
          a.EndTime      AS [endTime],
          a.LastTime     AS [lastTime],
          a.LastQty      AS [lastQty],
          a.MonthTime    AS [monthTime],
          a.MonthQty     AS [monthQty],
          a.InvTime      AS [invTime],
          a.InvQty       AS [invQty],
          a.SystemUser   AS [systemUser],
          a.SystemTime   AS [systemTime]
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
