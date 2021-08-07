USE [HealthResource]
GO

--- 程序名稱: removeDrugbatch
--- 程序說明: 刪除藥品批號紀錄檔
--- 編訂人員: 蔡易志                      
--- 校閱人員: 孫培然                       
--- 修訂日期: 2021/07/08
CREATE PROCEDURE [dbo].[removeDrugBatch](@params NVARCHAR(MAX))
AS BEGIN 
   DECLARE @batchNo        INT            = JSON_VALUE(@params, '$.batchNo');
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(30)    = 'removeDrugBatch';

   BEGIN TRY
           DELETE [dbo].[DrugBatch]
            WHERE BatchNo = @batchNo
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
  "batchNo": 50491
}
';

EXEC [dbo].[removeDrugBatch] @params
GO