USE [HealthResource]
GO

--- 程序名稱: removeDrugCheckInfo
--- 程序說明: 刪除藥品驗收紀錄總檔
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/07/07
ALTER PROCEDURE [dbo].[removeDrugCheckInfo](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20) = 'removeDrugCheckInfo';
   DECLARE @tranCount      INT         = @@TRANCOUNT;

   BEGIN TRY

         IF (@tranCount = 0) BEGIN TRAN;

         EXEC [dbo].[removeDrugChecking] @params

         --設定systemUser
         SET @params = JSON_MODIFY(@params, '$.systemUser', @newSystemUser);
         EXEC [dbo].[setDrugPurchaseDt] @params

         EXEC [dbo].[removeInvoiceRecord] @params
         
         EXEC [dbo].[removeInvoiceDiscount] @params

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
  "checkNo": 471122,
  "systemUser": 22342,
  "purchaseNo": 1171,
  "drugCode": 728,
  "inStockNo": "1P11",
  "demandQty": 600,
  "purchaseQty": 600,
  "giftQty": 0,
  "checkQty": 110,
  "unit": 80,
  "followTimes": 0,
  "isDelay": 0,
  "clearUser": 0,
  "clearDate": "2999-12-31",
  "clearReason": 0,
  "invoiceNo": "PM53010951",
  "discountsType": 10
},
{
  "checkNo": 471123,
  "systemUser": 22342,
  "purchaseNo": 1171,
  "drugCode": 728,
  "inStockNo": "1P11",
  "demandQty": 600,
  "purchaseQty": 600,
  "giftQty": 0,
  "checkQty": 110,
  "unit": 80,
  "followTimes": 0,
  "isDelay": 0,
  "clearUser": 0,
  "clearDate": "2999-12-31",
  "clearReason": 0,
  "invoiceNo": "PM53010951",
  "discountsType": 10
}
]
';

EXEC [dbo].[removeDrugCheckInfo] @params
GO