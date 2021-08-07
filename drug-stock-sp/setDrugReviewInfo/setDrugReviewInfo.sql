USE [HealthResource]
GO

--- 程序名稱: setDrugReviewInfo
--- 程序說明: 儲存藥品審核作業
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/05
CREATE PROCEDURE [dbo].[setDrugReviewInfo](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20)     = 'setDrugReviewInfo';
   DECLARE @tranCount      INT             = @@TRANCOUNT;

   IF (@tranCount = 0) BEGIN TRAN;
   
   BEGIN TRY
         
         EXEC [dbo].[setDrugTrialRecord] @params
         EXEC [dbo].[setDrugStockMt] @params

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
   "stockNo": "1P11",
   "drugCode": 6,
   "keepType": 1,
   "checkNo": 1,
   "isEffect": 1,
   "isExterior": 0,
   "isLicense": 1,
   "isLotNo": 0,
   "isCoA": 0,
   "remark": "",
   "trialUser": 37029,
   "systemUser": 37029
}
';

EXEC [dbo].[setDrugReviewInfo] @params
GO