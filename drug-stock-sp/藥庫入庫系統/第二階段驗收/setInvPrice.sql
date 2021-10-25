USE [HealthResource]
GO

--- 程序名稱：setInvPrice
--- 程序說明：計算發票金額
--- 編訂人員：林芳郁、蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/10/25
CREATE PROCEDURE [dbo].[setInvPrice](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @invoiceNo       CHAR(10)       = JSON_VALUE(@params,'$.invoiceNo');
   DECLARE @orginalInvNo    CHAR(10)       = JSON_VALUE(@params,'$.orginalInvNo');
   DECLARE @checkInvoiceNo  BIT            = JSON_VALUE(@params,'$.checkInvoiceNo');
   DECLARE @purchaseNo      INT            = JSON_VALUE(@params,'$.purchaseNo');
   DECLARE @checkNo         INT            = JSON_VALUE(@params,'$.checkNo');
   DECLARE @realPayAmount   INT            = 0;
   DECLARE @originPayAmount INT            = 0; 
   DECLARE @invoicePrice    DECIMAL(10,3);
   DECLARE @systemTime      VARCHAR(23)    = CONVERT(varchar, GETDATE(), 121);
   DECLARE @tranCount       INT            = @@TRANCOUNT;
   DECLARE @procedureName   VARCHAR(40)    = 'setInvPrice';
   DECLARE @errorSeverity   INT;
   DECLARE @errorMessage    NVARCHAR(4000);   
   
   BEGIN TRY
         IF (@tranCount = 0) BEGIN TRAN;
            
            SET @systemTime = JSON_MODIFY(@params, '$.systemTime', @systemTime);

            IF (@checkInvoiceNo = 1) BEGIN
                  --修改發票後，將已經沒有任何品項的發票刪除
                  SET @params = JSON_MODIFY(@params, '$.invoiceNo', @orginalInvNo);
                  EXEC [dbo].[removeInvoiceRecord] @params
                  EXEC [dbo].[removeInvoiceDiscounts] @params
            END

            -- 重新計算發票金額，並判斷更改後的發票是否存在，存在的話加上存在的金額，不存在的話加0
            SET @invoicePrice  = [fn].[getDrugPayAmount] (@purchaseNo,@invoiceNo);
            SET @realPayAmount = @invoicePrice - [fn].[getInvDiscountAmounts] (@checkNo,@invoiceNo);
            
            
            SET @originPayAmount = ISNULL(JSON_VALUE(JSON_QUERY([fn].[getInvoiceInfo](@invoiceNo)),'$.realPayAmount'),0);
            SET @params          = JSON_MODIFY(@params,'$.invoicePrice',@invoicePrice);
            SET @params          = JSON_MODIFY(@params,'$.realPayAmount',@realPayAmount+@originPayAmount);
            SET @params          = JSON_MODIFY(@params,'$.invoiceNo',@invoiceNo);
            EXEC [dbo].[setInvoiceRecord] @params

         IF (@tranCount = 0) COMMIT TRAN;
   END TRY
   BEGIN CATCH

         IF (@tranCount = 0) ROLLBACK TRAN;

         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;

         THROW;
   END CATCH
END