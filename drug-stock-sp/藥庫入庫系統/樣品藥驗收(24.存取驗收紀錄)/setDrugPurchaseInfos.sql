USE [HealthResource]
GO

--- 程序名稱：setDrugPurchaseInfos
--- 程序說明：設定多筆藥品採購資訊
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/09/08

CREATE PROCEDURE [dbo].[setDrugPurchaseInfos](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @value           NVARCHAR(MAX);
   DECLARE @tranCount       INT = @@TRANCOUNT;
   DECLARE @index           INT = 0;
   DECLARE @count           INT = [fn].JSON_COUNT(@params);   
   DECLARE @errorSeverity   INT;
   DECLARE @errorMessage    NVARCHAR(4000);
   DECLARE @procedureName   VARCHAR(30) = 'setDrugPurchaseInfos'; 

   -- BEGIN TRAN
   IF (@tranCount = 0) BEGIN TRAN;

   BEGIN TRY
         WHILE (@index < @count)
         BEGIN

           SET @value = [fn].JSON_ARRAY(@params, @index)           
           EXEC [dbo].[setDrugPurchaseInfo] @value
           SET @index = @index + 1; 
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
