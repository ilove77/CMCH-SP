USE [HealthResource]
GO

--- 程序名稱：setDrugCheckInfos
--- 程序說明：設定藥品驗收紀錄檔(多筆)
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/20
CREATE PROCEDURE [dbo].[setDrugCheckInfos](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @value          NVARCHAR(MAX);
   DECLARE @index          INT = 0;
   DECLARE @count          INT = [fn].JSON_COUNT(@params);
   DECLARE @tranCount      INT = @@TRANCOUNT;
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20) = 'setDrugCheckInfos';

   IF (@tranCount = 0) BEGIN TRAN;
   
   BEGIN TRY
         WHILE(@index < @count)
         BEGIN

           SET @value = [fn].JSON_ARRAY(@params, @index)
           EXEC [dbo].[setDrugCheckInfo] @value
           SET @index = @index + 1
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
[
    {
       "checkNo": 26184,
       "purchaseNo": 998, 
       "drugCode": 7702,
       "checkQty": 30,
       "systemUser": 37029
    }
]
';

EXEC [dbo].[setDrugCheckInfos] @params
GO