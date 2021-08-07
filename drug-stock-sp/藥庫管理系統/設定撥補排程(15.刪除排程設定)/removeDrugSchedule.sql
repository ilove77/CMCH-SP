USE [HealthResource]
GO

--- 程序名稱: removeDrugScheduleInfo
--- 程序說明: 刪除藥品排程資訊
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/07/08
CREATE PROCEDURE [dbo].[removeDrugScheduleInfo](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20)     = 'removeDrugScheduleInfo';
   DECLARE @tranCount      INT             = @@TRANCOUNT;

   BEGIN TRY
         IF (@tranCount = 0) BEGIN TRAN;

         EXEC [dbo].[removeDrugScheduleMt] @params;
         EXEC [dbo].[removeDrugScheduleDt] @params;

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
  "scheduleNo": 62,
  "seqNo": 1,
  "stockNo": "1A80"
}
';

EXEC [dbo].[removeDrugScheduleInfo] @params
GO