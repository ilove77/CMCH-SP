USE [HealthResource]
GO

--- 程序名稱: setDrugInventory 
--- 程序說明: 設定藥品盤點撥補資訊(單筆)
--- 編訂人員：孫培然
--- 校閱人員：孫培然
--- 修訂日期：2021/08/23
CREATE PROCEDURE [dbo].[setDrugInventory](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @tranCount     INT      = @@TRANCOUNT;
   DECLARE @demandStock   CHAR(04) = JSON_VALUE(@params, '$.demandStock');
   DECLARE @drugCode      INT      = JSON_VALUE(@params, '$.drugCode');
   DECLARE @adjustQty     INT      = JSON_VALUE(@params, '$.adjustQty '); -- 調整量 => 調撥數量 - 庫存量
   DECLARE @stockQty      INT      = JSON_VALUE(@params, '$.stockQty ');
   DECLARE @inventoryQty  INT      = JSON_VALUE(@params, '$.inventoryQty');
   DECLARE @newBatchNo    INT      = 0;
   DECLARE @batchInfos    NVARCHAR(MAX);
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(20) = 'setDrugInventory';

   -- BEGIN TRAN
   IF (@tranCount = 0) BEGIN TRAN;

   BEGIN TRY
         PRINT '判斷盤點撥補量是否大於0 ?';
         PRINT @inventoryQty;
         IF @inventoryQty > 0 
         BEGIN 
            PRINT '設定藥品需求單';
            EXEC [dbo].[setDrugDemand] @params
         END

         IF @adjustQty != 0
         BEGIN
            SET @params = JSON_Modify(@params, '$.totalQty', '$.inventoryQty');	
            EXEC @batchInfos = [fn].[getInStockDrugBatchInfos] @demandStock, @drugCode
            PRINT '判斷取得入庫藥品批號有無資料?';
            IF [fn].[JSON_COUNT] (@batchInfos) = 0
            BEGIN
                EXEC [dbo].[setDrugStockMt] @params
                EXEC [dbo].[addDrugTranRecord] @params
                SET @params = JSON_Modify(@params, '$.systemUser', '$.defaultSystemUser');
                EXEC [dbo].[setDrugStockDt] @params
            END

            ELSE 
            BEGIN
                PRINT '抓最新的批號資料'
                EXEC @batchInfos = [fn].[JSON_ARRAY] @batchInfos, 0	
                SET @newBatchNo = JSON_VALUE(@batchInfos, '$.batchNo');
                SET @params = JSON_MODIFY(@params, '$.batchNo', @newBatchNo);
                SET @stockQty = @stockQty + @adjustQty;
                SET @params = JSON_MODIFY(@params, '$.stockQty', @stockQty);
                EXEC [dbo].[setDrugStockDt] @params
                EXEC [dbo].[setDrugStockMt] @params
                EXEC [dbo].[addDrugTranRecord] @params
            END
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

    "adjustQty": -20,
    "batchNo": 0,
    "stockQty": -20,
    "defaultSystemUser": 999999,

    "tranType": 200,
    "inStockNo": "1A8D",
    "inStockUser": 37029,
    "inStockTime": "2021-08-23 00:00:00"
}
'

EXEC [dbo].[setDrugInventory] @params
GO