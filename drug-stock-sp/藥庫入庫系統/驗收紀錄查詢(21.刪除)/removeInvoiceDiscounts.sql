USE [HealthResource]
GO

--- 程序名稱：removeInvoiceDiscounts
--- 程序說明：刪除發票折讓檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/04
CREATE PROCEDURE [dbo].[removeInvoiceDiscounts](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @invoiceNo     CHAR(10)       = JSON_VALUE(@params, '$.invoiceNo');
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'removeInvoiceDiscounts';

   BEGIN TRY
         DELETE [dbo].[InvoiceDiscounts]
          WHERE InvoiceNo = @invoiceNo
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
   "invoiceNo": "CF47834118"  
}
'; 

EXEC [dbo].[removeInvoiceDiscounts] @params
GO