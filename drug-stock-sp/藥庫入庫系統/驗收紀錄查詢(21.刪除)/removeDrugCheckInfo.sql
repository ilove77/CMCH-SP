USE [HealthResource]
GO

--- 程序名稱: removeDrugCheckInfo
--- 程序說明: 刪除藥品驗收紀錄總檔
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/11/05
CREATE PROCEDURE [dbo].[removeDrugCheckInfo](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @tranCount      INT           = @@TRANCOUNT;
   DECLARE @checkNo        INT           = JSON_VALUE(@params, '$.checkNo');
   DECLARE @purchaseNo     INT           = JSON_VALUE(@params, '$.purchaseNo');
   DECLARE @drugCode       INT           = JSON_VALUE(@params, '$.drugCode');
   DECLARE @checkQty       INT           = JSON_VALUE(@params, '$.checkQty');
   DECLARE @invoiceNo      CHAR(10)      = JSON_VALUE(@params, '$.invoiceNo');
   DECLARE @newSystemUser  INT           = JSON_VALUE(@params, '$.newSystemUser');
   DECLARE @newCheckQty    INT           = 0;
   DECLARE @checkingInfo   NVARCHAR(MAX) = '';
   DECLARE @invoiceInfo    NVARCHAR(MAX) = '';
   DECLARE @tranStatus     TINYINT       = 0;
   DECLARE @discountsType  TINYINT       = 10; --採購類別 => 10: 訂單
   DECLARE @realPayAmount  INT           = 0;
   DECLARE @payAmount      DECIMAL(10,3);
   DECLARE @amount         DECIMAL(10,3);
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20) = 'removeDrugCheckInfo';
   
   BEGIN TRY
         IF (@tranCount = 0) BEGIN TRAN;

         EXEC [dbo].[setDrugChecking] @params

         -- 判斷驗收多少驗收量
         SET @newCheckQty = [fn].[getDrugCheckQty](@purchaseNo, @drugCode)
         SET @checkQty = @newCheckQty - @checkQty
         SET @params = JSON_MODIFY(@params, '$.checkQty', @checkQty)

         EXEC [dbo].[setDrugPurchaseDt] @params
         EXEC [dbo].[setDrugPurchaseMt] @params
         EXEC [dbo].[removeInvoiceDiscounts] @params

         --判斷驗收檔是否還有其他品項，NULL 代表沒其他品項了，可以刪除
         SET @checkingInfo = [fn].[getDrugCheckingInfo](@checkNo, @invoiceNo)
         IF(@checkingInfo IS NULL) BEGIN

            --判斷發票採購已核對，已核對就不能刪除發票
            SET @tranStatus  = JSON_VALUE(JSON_QUERY([fn].[getInvoiceStatus](@invoiceNo)),'$.tranStatus')
            IF(@tranStatus <= 20) BEGIN
            EXEC [dbo].[removeInvoiceRecord] @params    
            END
         END

         -- 判斷發票檔有無發票號碼， 因重新計算發票金額
         SET @invoiceInfo = [fn].[getInvoiceInfo](@invoiceNo)
         IF(@invoiceInfo IS NOT NULL) BEGIN

            --設定發票基本檔金額
            SET @payAmount = [fn].[getInvPayAmount](@invoiceNo)
            SET @amount    = [fn].[getInvAmount](@invoiceNo, @discountsType)

            --應付金額 - 折讓金額
            SET @realPayAmount = @payAmount - @amount
            SET @params = JSON_MODIFY(@params, '$.realPayAmount', @realPayAmount)
            SET @params = JSON_MODIFY(@params, '$.systemUser', @newSystemUser)

            EXEC [dbo].[setInvoiceRecord] @params
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
  "batchNo": 131406,
  "checkNo": 469008,
  "checkQty": 90,
  "checkTime": "2021-07-07 08:59:58",
  "checkType": 10,
  "disPlayNo": 0,
  "drugCode": 3287,
  "drugName": "【美平】 Meropenem Trihydrate 250mg/Vial",
  "expDate": "2024-02-29",
  "invoiceDate": "20210707",
  "invoiceNo": "UZ82838407",
  "lotNo": "2097C",
  "medCode": "IMEROPE ",
  "orginalExpDate": "2024-02-29",
  "orginalInvNo": "PM53010951",
  "orginalLotNo": "2097C",
  "purchaseNo": 348607,
  "purchaseQty": 3000,
  "stockNo": "1P11",
  "systemUser": 37029,
  "unit": 70,
  "invoiceType": 10,
  "newSystemUser": 999999,
  "purchaseStatus": 60,
  "systemTime": "2021-11-04 14:40:00",
  "checkStatus": 80
}
'

EXEC [dbo].[removeDrugCheckInfo] @params
GO