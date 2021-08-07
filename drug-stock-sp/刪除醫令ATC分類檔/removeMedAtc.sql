USE [HealthCare]
GO

--- 程序名稱：removeMedAtc
--- 程序說明：刪除醫令ATC分類檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/16
CREATE PROCEDURE [dbo].[removeMedAtc](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @procedureName VARCHAR(30) = 'removeMedAtc';
   DECLARE @medCode       CHAR(08)    = JSON_VALUE(@params, '$.medCode')
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);

   BEGIN TRY

         DELETE FROM [dbo].[MedAtc]
          WHERE MedCode = @medCode

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
 "medCode": "IATTTEST"
}
';

EXEC [dbo].[removeMedAtc] @params
GO