USE [HealthResource]
GO

--- 程序名稱: setDrugStockInit
--- 程序說明: 設定藥品期初品項
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/07/06
CREATE PROCEDURE [dbo].[setDrugStockInit](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20)      = 'setDrugStockInit';
   DECLARE @tranCount      INT              = @@TRANCOUNT;

   BEGIN TRY

         IF (@tranCount = 0) BEGIN TRAN;

         EXEC [dbo].[setDrugStockMt] @params
         EXEC [dbo].[setDrugStockDt] @params

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
{
  "stockNo": "1P11",
  "drugCode": 10335,
  "stockUnit": "180",
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
  "storageNo": "",  
  "supplyStock": "1P11",
  "isComplexIn": 0, 
  "isInvList": 0,  
  "startTime": "2020-09-22 18:00:53.000",   
  "endTime": "2999-12-31 00:00:00.000",        
  "lastTime": "2999-12-31 00:00:00.000",    
  "lastQty":  0,   
  "monthTime": "2999-12-31 00:00:00.000",  
  "monthQty": 0,   
  "invTime": "2999-12-31 00:00:00.000",     
  "invQty": 0,       
  "systemUser": 7068, 
  "batchNo": 0,
  "stockQty": 0  
}
';

EXEC [dbo].[setDrugStockInit] @params
GO