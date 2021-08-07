USE [HealthResource]
GO

--- 程序名稱：setDrugStockMt
--- 程序說明：設定藥品庫存檔
--- 編訂人員：陳睿穎
--- 校閱人員：孫培然
--- 修訂日期：2021/06/23
CREATE PROCEDURE [dbo].[setDrugStockMt](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime    DATETIME    = GETDATE();
   DECLARE @procedureName VARCHAR(20) = 'setDrugStockMt';
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);

   BEGIN TRY
         MERGE INTO [dbo].[DrugStockMt] AS t
         USING ( SELECT *
                   FROM OPENJSON(@params)
                   WITH ( 
                          StockNo      CHAR(4)     '$.stockNo',
                          DrugCode     INT         '$.drugCode',
                          StockUnit    SMALLINT    '$.stockUnit',
                          StockRatio   SMALLINT    '$.stockRatio',
                          PackageQty   INT         '$.packageQty',
                          PurchaseDays TINYINT     '$.purchaseDays',
                          WarnDays     TINYINT     '$.warnDays',
                          PurchaseQty  INT         '$.purchaseQty',
                          ReorderPoint INT         '$.reorderPoint',
                          SafetyQty    INT         '$.safetyQty',
                          TotalQty     INT         '$.totalQty',
                          MaxQty       INT         '$.maxQty',
                          SupplyType   TINYINT     '$.supplyType',
                          DrugType     SMALLINT    '$.drugType',
                          KeepType     SMALLINT    '$.keepType',
                          PurchaseType TINYINT     '$.purchaseType',
                          InvType      TINYINT     '$.invType',
                          StorageNo    VARCHAR(30) '$.storageNo',
                          SupplyStock  CHAR(4)     '$.supplyStock',
                          IsComplexIn  BIT         '$.isComplexIn',
                          IsInvList    BIT         '$.isInvList',
                          StartTime    DATETIME    '$.startTime',
                          EndTime      DATETIME    '$.endTime',
                          LastTime     DATETIME    '$.lastTime',
                          LastQty      INT         '$.lastQty',
                          MonthTime    DATETIME    '$.monthTime',
                          MonthQty     INT         '$.monthQty',
                          InvTime      DATETIME    '$.invTime',
                          InvQty       INT         '$.invQty',
                          SystemUser   INT         '$.systemUser'
                        )
                 ) AS s (
                          StockNo,
                          DrugCode,
                          StockUnit,
                          StockRatio,
                          PackageQty,
                          PurchaseDays,
                          WarnDays,
                          PurchaseQty,
                          ReorderPoint,
                          SafetyQty,
                          TotalQty,
                          MaxQty,
                          SupplyType,
                          DrugType,
                          KeepType,
                          PurchaseType,
                          InvType,
                          StorageNo,
                          SupplyStock,
                          IsComplexIn,
                          IsInvList,
                          StartTime,
                          EndTime,
                          LastTime,
                          LastQty,
                          MonthTime,
                          MonthQty,
                          InvTime,
                          InvQty,
                          SystemUser
                        )
              ON (t.StockNo = s.StockNo AND t.DrugCode = s.DrugCode)
         WHEN MATCHED THEN
              UPDATE SET
                     t.StockUnit    = ISNULL(s.StockUnit, t.StockUnit), 
                     t.StockRatio   = ISNULL(s.StockRatio, t.StockRatio),
                     t.PackageQty   = ISNULL(s.PackageQty, t.PackageQty),
                     t.PurchaseDays = ISNULL(s.PurchaseDays, t.PurchaseDays),
                     t.WarnDays     = ISNULL(s.WarnDays, t.WarnDays),
                     t.PurchaseQty  = ISNULL(s.PurchaseQty, t.PurchaseQty),
                     t.ReorderPoint = ISNULL(s.ReorderPoint, t.ReorderPoint), 
                     t.SafetyQty    = ISNULL(s.SafetyQty, t.SafetyQty),
                     t.TotalQty     = ISNULL(s.TotalQty, t.TotalQty),
                     t.MaxQty       = ISNULL(s.MaxQty, t.MaxQty ),
                     t.SupplyType   = ISNULL(s.SupplyType, t.SupplyType),
                     t.DrugType     = ISNULL(s.DrugType, t.DrugType),
                     t.KeepType     = ISNULL(s.KeepType, t.KeepType),
                     t.PurchaseType = ISNULL(s.PurchaseType, t.PurchaseType),
                     t.InvType      = ISNULL(s.InvType, t.InvType),
                     t.StorageNo    = ISNULL(s.StorageNo, t.StorageNo),
                     t.SupplyStock  = ISNULL(s.SupplyStock, t.SupplyStock),
                     t.IsComplexIn  = ISNULL(s.IsComplexIn, t.IsComplexIn),
                     t.IsInvList    = ISNULL(s.IsInvList, t.IsInvList),
                     t.StartTime    = ISNULL(s.StartTime, t.StartTime),
                     t.EndTime      = ISNULL(s.EndTime, t.EndTime),
                     t.LastTime     = ISNULL(s.LastTime, t.LastTime),
                     t.LastQty      = ISNULL(s.LastQty, t.LastQty),
                     t.MonthTime    = ISNULL(s.MonthTime, t.MonthTime),
                     t.MonthQty     = ISNULL(s.MonthQty, t.MonthQty), 
                     t.InvTime      = ISNULL(s.InvTime, t.InvTime),
                     t.InvQty       = ISNULL(s.InvQty, t.InvQty),
                     t.SystemUser   = s.SystemUser,
                     t.SystemTime   = @systemTime
         WHEN NOT MATCHED THEN
              INSERT (
                       StockNo,
                       DrugCode,
                       StockUnit,
                       StockRatio,
                       PackageQty,
                       PurchaseDays,
                       WarnDays,
                       PurchaseQty,
                       ReorderPoint,
                       SafetyQty,
                       TotalQty,
                       MaxQty,
                       SupplyType,
                       DrugType,
                       KeepType,
                       PurchaseType,
                       InvType,
                       StorageNo,
                       SupplyStock,
                       IsComplexIn,
                       IsInvList,
                       StartTime,
                       EndTime,
                       LastTime,
                       LastQty,
                       MonthTime,
                       MonthQty,
                       InvTime,
                       InvQty,
                       SystemUser,
                       SystemTime
                     )
              VALUES (
                       s.StockNo,
                       s.DrugCode,
                       s.StockUnit,
                       s.StockRatio,
                       s.PackageQty,
                       s.PurchaseDays,
                       s.WarnDays,
                       s.PurchaseQty,
                       s.ReorderPoint,
                       s.SafetyQty,
                       s.TotalQty,
                       s.MaxQty,
                       s.SupplyType,
                       s.DrugType,
                       s.KeepType,
                       s.PurchaseType,
                       s.InvType,
                       s.StorageNo,
                       s.SupplyStock,
                       s.IsComplexIn,
                       s.IsInvList,
                       s.StartTime,
                       s.EndTime,
                       s.LastTime,
                       s.LastQty,
                       s.MonthTime,
                       s.MonthQty,
                       s.InvTime,
                       s.InvQty,
                       s.SystemUser,
                       @systemTime
                     );
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;
         THROW;
   END CATCH
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P11",
   "drugCode": 6,
   "keepType": 1,
   "systemUser": 37029
}
';

EXEC [dbo].[setDrugStockMt] @params
GO