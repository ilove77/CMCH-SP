USE [HealthResource]
GO

--- 程序名稱：removeInvoiceRecord
--- 程序說明：刪除發票基本檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/04
CREATE PROCEDURE [dbo].[removeInvoiceRecord](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @invoiceNo     CHAR(10)       = JSON_VALUE(@params, '$.invoiceNo');
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'removeInvoiceRecord';

   BEGIN TRY
         DELETE [dbo].[InvoiceRecord]
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
   "invoiceNo": "0000000004"  
}
'; 

EXEC [dbo].[removeInvoiceRecord] @params
GO