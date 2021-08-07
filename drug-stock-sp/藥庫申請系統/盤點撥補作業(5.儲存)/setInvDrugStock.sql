USE [HealthResource]
GO

--- 程序名稱: setInvDrugStock
--- 程序說明: 設定藥品盤點撥補資訊
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/07/08
CREATE PROCEDURE [dbo].[setInvDrugStock](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20)     = 'setInvDrugStock';
   DECLARE @tranCount      INT             = @@TRANCOUNT;

   BEGIN TRY
         IF (@tranCount = 0) BEGIN TRAN;

         EXEC [dbo].[setDrugStockMt] @params
         EXEC [dbo].[setDrugDemand] @params

         IF (@tranCount = 0) COMMIT TRAN;
   END TRY
   BEGIN CATCH
         IF (@tranCount = 0) ROLLBACK TRAN;

         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;

         THROW;
   END CATCH
END
GO

DECLARE @params NVARCHAR(MAX) = 
'
[ 
    {
        "stockNo": "1P11",
        "drugCode": 10335,
        "stockUnit": 180,
        "stockRatio": 1, 
        "packageQty": 1,
        "purchaseDays": 1,
        "warnDays": 1,   
        "purchaseQty": 0,  
        "reorderPoint": 20,
        "safetyQty": 0,   
        "totalQty": 0,    
        "maxQty": 20,      
        "supplyType": 0,      
        "drugType": 0,    
        "keepType": 0,    
        "purchaseType": 13,  
        "invType": 0,     
        "storageNo": "54564",  
        "supplyStock": "",
        "isComplexIn": 0, 
        "isInvList": 0,  
        "startTime": "2020-09-22",   
        "endTime": "2999-12-31",        
        "lastTime": "2999-12-31",    
        "lastQty": 0,   
        "monthTime": "2999-12-31",  
        "monthQty": 0,   
        "invTime": "2999-12-31",     
        "invQty": 0,       
        "systemUser": 7068, 
        "demandNo": 1234,
        "purchaseNo": 0,
        "demandType": 40,
        "demandStock": "1P11",
        "demandUser": 7068,
        "demandTime": "2021-07-08",
        "demandQty": 20,
        "demandUnit": 180,
        "supplyStock": "",   
        "supplyQty": 20,    
        "tranStatus": 10,   
        "stopReason": 1,    
        "contactExt": 2609,    
        "checkTime": "2999-12-31",     
        "auditUser": 37028,     
        "auditTime": "2999-12-31",        
        "remark": ""
    },
    {
        "stockNo": "1P11",
        "drugCode": 10775,
        "stockUnit": 200,
        "stockRatio": 1, 
        "packageQty": 1,
        "purchaseDays": 1,
        "warnDays": 1,   
        "purchaseQty": 0,  
        "reorderPoint": 25,
        "safetyQty": 0,   
        "totalQty": 0,    
        "maxQty": 30,      
        "supplyType": 0,      
        "drugType": 0,    
        "keepType": 0,    
        "purchaseType": 1,  
        "invType": 0,     
        "storageNo": "545",  
        "supplyStock": "",
        "isComplexIn": 0, 
        "isInvList": 0,  
        "startTime": "2020-09-22",   
        "endTime": "2999-12-31",        
        "lastTime": "2999-12-31",    
        "lastQty": 0,   
        "monthTime": "2999-12-31",  
        "monthQty": 0,   
        "invTime": "2999-12-31",     
        "invQty": 0,       
        "systemUser": 7058, 
        "demandNo": 12378,
        "purchaseNo": 0,
        "demandType": 40,
        "demandStock": "1P11",
        "demandUser": 7058,
        "demandTime": "2021-07-10",
        "demandQty": 20,
        "demandUnit": 180,
        "supplyStock": "",   
        "supplyQty": 20,    
        "tranStatus": 10,   
        "stopReason": 1,    
        "contactExt": 2609,    
        "checkTime": "2999-12-31",     
        "auditUser": 37048,     
        "auditTime": "2999-12-31",        
        "remark": ""
    }
]
';

EXEC [dbo].[setInvDrugStock] @params
GO