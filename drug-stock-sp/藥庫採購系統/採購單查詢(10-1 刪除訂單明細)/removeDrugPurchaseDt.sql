USE [HealthResource]
GO

--- 程序名稱：刪除藥品採購明細檔
--- 程序說明：removeDrugPurchaseDt
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/30
CREATE PROCEDURE [dbo].[removeDrugPurchaseDt](@params NVARCHAR(MAX))
AS BEGIN   
   DECLARE @purchaseNo     INT            = JSON_VALUE(@params, '$.purchaseNo');
   DECLARE @drugCode       INT            = JSON_VALUE(@params, '$.drugCode');
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(30)    = 'removeDrugPurchaseDt';

   BEGIN TRY
         DELETE [dbo].[DrugPurchaseDt]
          WHERE PurchaseNo = @purchaseNo
            AND DrugCode   = @drugCode
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;

         THROW;
   END CATCH
END
GO

DECLARE @params NVARCHAR(max) = 
'{
    "purchaseNo": 1222,
    "drugCode": 3193
}
'

EXEC [dbo].[removeDrugPurchaseDt] @params
GO