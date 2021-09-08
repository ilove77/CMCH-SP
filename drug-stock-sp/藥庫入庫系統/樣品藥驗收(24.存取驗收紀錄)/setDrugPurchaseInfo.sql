USE [HealthResource]
GO

--- 程序名稱：setDrugPurchaseInfo
--- 程序說明：設定單筆藥品採購資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/09/08
CREATE PROCEDURE [dbo].[setDrugPurchaseInfo](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(50)     = 'setDrugPurchaseInfo';
   DECLARE @tranCount      INT             = @@TRANCOUNT;
   
   BEGIN TRY
         IF (@tranCount = 0) BEGIN TRAN; 

         EXEC [dbo].[setDrugPurchaseMt] @params 

         EXEC [dbo].[setDrugPurchaseDt] @params       

         IF (@tranCount = 0) COMMIT TRAN;
         
   END TRY
   BEGIN CATCH 
         IF (@tranCount = 0) ROLLBACK TRAN;

         SELECT @errorSeverity  = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity , @errorMessage;

         THROW;
   END CATCH
  
END
