USE [HealthResource]
GO

--- 程序名稱：setDrugStockMt
--- 程序說明：設定藥品庫存檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/05

CREATE PROCEDURE [dbo].[setDrugStockMt](@params NVARCHAR(MAX))
AS BEGIN

   DECLARE @systemTime    DATETIME       = GETDATE();
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'setDrugStockMt';

   BEGIN TRY
         MERGE INTO [dbo].[drugStockMt] AS a
         USING ( SELECT *
                   FROM OPENJSON(@params)          
                   WITH ( StockNo      CHAR(04)    '$.stockNo',             
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
                          SupplyStock  CHAR(04)	   '$.supplyStock',
                          IsComplexIn  BIT         '$.isComplexIn',
                          IsInvList    BIT         '$.isInvList',
                          StartTime    DATETIME    '$.startTime',
                          EndTime      DATETIME    '$.endTime',
                          LastTime     DATETIME    '$.lastTime',
                          LastQty      INT         '$.lastQty',
                          MonthTime    DATETIME	   '$.monthTime',
                          MonthQty     INT         '$.monthQty',
                          InvTime      DATETIME    '$.invTime',
                          InvQty       INT         '$.invQty',
                          SystemUser   INT         '$.systemUser'
                        )
               ) AS b (
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
            ON (a.StockNo = b.StockNo AND a.DrugCode = b.DrugCode)    
         WHEN MATCHED THEN 
              UPDATE SET  
                     a.StockUnit    = b.StockUnit,   
                     a.StockRatio   = b.StockRatio,  
                     a.PackageQty   = b.PackageQty,  
                     a.PurchaseDays = b.PurchaseDays,
                     a.WarnDays     = b.WarnDays,    
                     a.PurchaseQty  = b.PurchaseQty, 
                     a.ReorderPoint = b.ReorderPoint,
                     a.SafetyQty    = b.SafetyQty,   
                     a.TotalQty     = b.TotalQty,    
                     a.MaxQty       = b.MaxQty,      
                     a.SupplyType   = b.SupplyType,  
                     a.DrugType     = b.DrugType,    
                     a.KeepType     = b.KeepType,    
                     a.PurchaseType = b.PurchaseType,
                     a.InvType      = b.InvType,     
                     a.StorageNo    = b.StorageNo,   
                     a.SupplyStock  = b.SupplyStock, 
                     a.IsComplexIn  = b.IsComplexIn, 
                     a.IsInvList    = b.IsInvList,   
                     a.StartTime    = b.StartTime,   
                     a.EndTime      = b.EndTime,     
                     a.LastTime     = b.LastTime,    
                     a.LastQty      = b.LastQty,     
                     a.MonthTime    = b.MonthTime,   
                     a.MonthQty     = b.MonthQty,    
                     a.InvTime      = b.InvTime,     
                     a.InvQty       = b.InvQty,      
                     a.SystemUser   = b.SystemUser,  
                     a.SystemTime   = @systemTime

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
                      b.StockNo,     
                      b.DrugCode,    
                      b.StockUnit,   
                      b.StockRatio,  
                      b.PackageQty,  
                      b.PurchaseDays,
                      b.WarnDays,    
                      b.PurchaseQty, 
                      b.ReorderPoint,
                      b.SafetyQty,   
                      b.TotalQty,    
                      b.MaxQty,      
                      b.SupplyType,  
                      b.DrugType,    
                      b.KeepType,    
                      b.PurchaseType,
                      b.InvType,     
                      b.StorageNo,   
                      b.SupplyStock, 
                      b.IsComplexIn, 
                      b.IsInvList,   
                      b.StartTime,  
                      b.EndTime,     
                      b.LastTime,    
                      b.LastQty,     
                      b.MonthTime,   
                      b.MonthQty,    
                      b.InvTime,     
                      b.InvQty,      
                      b.SystemUser,
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
   "drugCode": 3678, 
   "stockUnit": 70,   
   "stockRatio": 1,  
   "packageQty": 0, 
   "purchaseDays": 12,
   "warnDays": 0,    
   "purchaseQty": 0, 
   "reorderPoint": 20,
   "safetyQty": 0,   
   "totalQty": 0 ,    
   "maxQty": 20,      
   "supplyType": 10,  
   "drugType": 11,    
   "keepType": 25 ,   
   "purchaseType": 10,
   "invType": 25,     
   "storageNo": "",   
   "supplyStock": "", 
   "isComplexIn": 0, 
   "isInvList": 1,   
   "startTime": "1997-07-02 00:00:00.000",  
   "endTime": "2999-12-31 00:00:00.000",     
   "lastTime": "2999-12-31 00:00:00.000",    
   "lastQty": 0,     
   "monthTime": "2999-12-31 00:00:00.000",   
   "monthQty": 0,    
   "invTime": "2999-12-31 00:00:00.000",     
   "invQty": 0,      
   "systemUser": 28775
}
';

EXEC [dbo].[setDrugStockMt] @params
GO