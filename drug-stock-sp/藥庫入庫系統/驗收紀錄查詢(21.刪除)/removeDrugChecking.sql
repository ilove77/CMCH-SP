USE [HealthResource]
GO

--- 程序名稱：刪除藥品驗收紀錄
--- 程序說明：removeDrugChecking
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/07
CREATE PROCEDURE [dbo].[removeDrugChecking](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @checkNo        INT            = JSON_VALUE(@params,'$.checkNo');
   DECLARE @systemUser     INT            = JSON_VALUE(@params,'$.systemUser');
   DECLARE @checkStatus    TINYINT        = 80; --驗收狀態 => 80: 刪除
   DECLARE @currentTime    DATETIME       = GETDATE();
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(30)    = 'removeDrugChecking';

   BEGIN TRY
         UPDATE [dbo].[DrugChecking]
            SET CheckStatus = @checkStatus,
                SystemUser  = @systemUser,
                SystemTime  = @currentTime
          WHERE CheckNo     = @checkNo
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;
         THROW;
   END CATCH
END

DECLARE @params NVARCHAR(MAX) = 
'
{
   "checkNo": 1499,
   "systemUser": 22342,
}
';

EXEC [dbo].[removeDrugChecking] @params
GO
