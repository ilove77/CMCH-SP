USE [HealthResource]
GO

--- 程序名稱：removeInvoiceDiscounts
--- 程序說明：刪除發票折讓檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/11/05
CREATE PROCEDURE [dbo].[removeInvoiceDiscounts](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @checkNo       INT       = JSON_VALUE(@params, '$.checkNo');
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'removeInvoiceDiscounts';

   BEGIN TRY
         DELETE [dbo].[InvoiceDiscounts]
          WHERE CheckNo = @checkNo
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
   "checkNo": 1499
}
'; 

EXEC [dbo].[removeInvoiceDiscounts] @params
GO