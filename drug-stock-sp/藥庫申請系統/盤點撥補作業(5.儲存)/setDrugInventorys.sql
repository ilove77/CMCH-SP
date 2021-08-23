USE [HealthResource]
GO

--- 程序名稱：setDrugInventorys
--- 程序說明：設定藥品盤點撥補資訊(多筆)
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/23
CREATE PROCEDURE [dbo].[setDrugInventorys](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @value          NVARCHAR(MAX);
   DECLARE @index          INT = 0;
   DECLARE @count          INT = [fn].JSON_COUNT(@params);
   DECLARE @tranCount      INT = @@TRANCOUNT;
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20) = 'setDrugInventorys';

   IF (@tranCount = 0) BEGIN TRAN;
   
   BEGIN TRY
         WHILE(@index < @count)
         BEGIN

            SET @value = [fn].JSON_ARRAY(@params, @index)
            EXEC [dbo].[setDrugInventory] @value
            SET @index = @index + 1
         END


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
            "chargeUnit": 70,
            "contactExt": 2608, 
            "demandQty": 10,
            "demandStock": "1A8D",
            "drugCode": 3678,
            "inventoryQty": 10,
            "maxQty": 300,
            "unarrivalQty": 4,
            "packageQty": 1,
            "remark": "資訊室測試",
            "safetyQty": 200,
            "totalQty": 30,
            "systemUser": 37029,

            "demandNo": 0,
            "demandType": 40,
            "demandTime": "2021-08-23 00:00:00",
            "supplyQty": 0,
            "demandUnit": 70,
            "tranStatus": 10,
            "stopReason": 0,
            "purchaseNo": 0,
            "auditUser": 0,
            "checkTime": "2999-12-31 00:00:00",
            "auditTime": "2999-12-31 00:00:00",
            "supplyStock": "1P11",

            "stockNo": "1A8D",
            "adjustQty": -20,
            "batchNo": 0,
            "stockQty": -20,
            "defaultSystemUser": 999999,

            "tranType": 200,
            "inStockNo": "1A8D",
            "inStockUser": 37029,
            "inStockTime": "2021-08-23 00:00:00"
      },
      {
            "chargeUnit": 80,
            "contactExt": 2608, 
            "demandQty": 10,
            "demandStock": "1P11",
            "drugCode": 3678,
            "inventoryQty": 10,
            "maxQty": 300,
            "unarrivalQty": 4,
            "packageQty": 1,
            "remark": "資訊室測試",
            "safetyQty": 200,
            "totalQty": 30,
            "systemUser": 37029,

            "demandNo": 0,
            "demandType": 40,
            "demandTime": "2021-08-23 00:00:00",
            "supplyQty": 0,
            "demandUnit": 70,
            "tranStatus": 10,
            "stopReason": 0,
            "purchaseNo": 0,
            "auditUser": 0,
            "checkTime": "2999-12-31 00:00:00",
            "auditTime": "2999-12-31 00:00:00",
            "supplyStock": "1P11",

            "stockNo": "1P11",
            "adjustQty": -20,
            "batchNo": 0,
            "stockQty": -20,
            "defaultSystemUser": 999999,

            "tranType": 200,
            "inStockNo": "1A8D",
            "inStockUser": 37029,
            "inStockTime": "2021-08-23 00:00:00"
      }
]
';

EXEC [dbo].[setDrugInventorys] @params
GO