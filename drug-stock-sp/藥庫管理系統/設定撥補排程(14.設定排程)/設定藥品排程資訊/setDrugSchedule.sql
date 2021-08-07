USE [HealthResource]
GO

--- 程序名稱: setDrugSchedule
--- 程序說明: 設定藥品排程資訊
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/07/08
CREATE PROCEDURE [dbo].[setDrugSchedule](@params NVARCHAR(MAX))
AS BEGIN

   DECLARE @scheduleNo     INT;
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20)     = 'setDrugSchedule';
   DECLARE @tranCount      INT             = @@TRANCOUNT;

   BEGIN TRY
         IF (@tranCount = 0) BEGIN TRAN;

         EXEC @scheduleNo = [dbo].[setDrugScheduleMt] @params;
          SET @params = JSON_MODIFY(@params, '$.scheduleNo', @scheduleNo);
         EXEC [dbo].[setDrugScheduleDt] @params;

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
   "scheduleName": "1P11 - 西藥管理組",
   "supplyStock": "1P11",
   "seqNo": 10,
   "weekCycle": "",
   "startDate": "2021-07-08",
   "endDate": "2021-07-16",
   "systemUser": 37029,
   "stockNo": "1P11"
}
';

EXEC [dbo].[setDrugSchedule] @params
GO