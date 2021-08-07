USE [HealthResource]
GO

-- - 程序名稱: setDrugStockInfo
-- - 程序說明: 設定藥庫品項資訊
-- - 編訂人員: 蔡易志
-- - 校閱人員: 孫培然
-- - 修訂日期: 2021/07/06
CREATE PROCEDURE [dbo].[setDrugStockInfo](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20)      = 'setDrugStockInfo';
   DECLARE @tranCount      INT              = @@TRANCOUNT;

   BEGIN TRY

         IF (@tranCount = 0) BEGIN TRAN;

         EXEC [dbo].[setDrugStockMt] @params
         EXEC [dbo].[setPurchaseBasic] @params

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
  "drugCode": 3678,
  "startTime": "2021-07-02 00:00:00.000",
  "endTime": "2021-01-01 00:00:00.000",
  "totalQty": 6037,
  "safetyQty": 4,
  "maxQty": 10000,
  "reorderPoint": 10000,
  "warnDays": 6,
  "purchaseDays": 12,
  "purchaseQty": 0,
  "stockUnit": "",
  "stockRatio": 100,
  "packageQty": 1,
  "isInvList": 1,
  "lastTime": "2020-05-07 14:13:47",
  "lastQty": 0,
  "monthTime": "2999-12-31",
  "monthQty": 0,
  "invTime": "2999-12-31",
  "invQty": 0,
  "supplyStock": "",
  "supplyType": 10,
  "purchaseType": 10,
  "drugType": 11,
  "keepType": -1,
  "invType": 25,
  "systemUser": 36670,
  "isComplexIn": 0,
  "storageNo": "AAAAA,AAA,AAAA",
  "itemCode": 3678,
  "itemType": 10, 
  "represent": "",
  "manufactory": "",
  "supplierNo": "" ,
  "licenseNo": "",
  "licenseNoDate": "2999-12-31",
  "payDeadline": 0,
  "buyRatio": 0,
  "giveRatio": 0,
  "donatePrice": 0,
  "costPrice": 0,
  "expiryDate": "2999-12-31", 
  "warnDate": "2999-12-31",
  "remark": "",
  "startTime": "1911-01-01",
  "endTime": "2999-12-31"
}
';

EXEC [dbo].[setDrugStockInfo] @params
GO