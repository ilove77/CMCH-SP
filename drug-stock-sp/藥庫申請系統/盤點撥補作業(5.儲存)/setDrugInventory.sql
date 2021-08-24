USE [HealthResource]
GO

--- 程序名稱: setDrugInventory 
--- 程序說明: 設定藥品盤點撥補資訊(單筆)
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/23
ALTER PROCEDURE [dbo].[setDrugInventory](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @tranCount         INT      = @@TRANCOUNT;
   DECLARE @demandStock       CHAR(04) = JSON_VALUE(@params, '$.demandStock');
   DECLARE @drugCode          INT      = JSON_VALUE(@params, '$.drugCode');
   DECLARE @adjustQty         INT      = JSON_VALUE(@params, '$.adjustQty'); -- 調整量 => 調撥數量 - 庫存量
   DECLARE @demandQty         INT      = JSON_VALUE(@params, '$.demandQty');
   DECLARE @newBatchNo        INT      = 0;
   DECLARE @errorSeverity     INT;
   DECLARE @errorMessage      NVARCHAR(4000);
   DECLARE @procedureName     VARCHAR(20) = 'setDrugInventory';

   BEGIN TRY
         -- BEGIN TRAN
         IF (@tranCount = 0) BEGIN TRAN;

         -- 檢查需求量 > 0 是否添加到需求單
         IF @demandQty > 0 BEGIN
            EXEC [dbo].[setDrugDemand] @params
         END
         
         -- 判斷盤點量跟現有庫存量是否相同
         IF @adjustQty != 0 BEGIN

            -- 取得最新一筆批號寫入資料
            EXEC @newBatchNo = [fn].[getDrugBatchNo] @demandStock, @drugCode
            SET @params = JSON_MODIFY(@params, '$.batchNo', @newBatchNo);

            EXEC [dbo].[addDrugTranRecord] @params
            EXEC [dbo].[setDrugStockDt] @params
            EXEC [dbo].[modifyDrugStockMtQty] @params

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
        "inventoryQty": 20,
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
        "adjustQty": -10,
        "batchNo": 0,
        "stockQty": -10,
        "defaultSystemUser": 999999,

        "tranType": 200,
        "inStockNo": "1A8D",
        "inStockUser": 37029,
        "inStockTime": "2021-08-23 00:00:00"
}
'

EXEC [dbo].[setDrugInventory] @params
GO