USE [HealthResource]
GO

--- 程序名稱: modifyDrugPurchaseDtQty
--- 程序說明: 更新DrugPurchaseDt驗收數量
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/07/07
CREATE PROCEDURE [dbo].[modifyDrugPurchaseDtQty] (@params NVARCHAR(MAX))
AS BEGIN

   DECLARE @purchaseNo      INT             = JSON_VALUE(@params, '$.purchaseNo');
   DECLARE @drugCode        INT             = JSON_VALUE(@params, '$.drugCode');
   DECLARE @checkQty        INT             = JSON_VALUE(@params, '$.checkQty');
   DECLARE @systemUser      INT             = JSON_VALUE(@params, '$.systemUser');
   DECLARE @systemTime      DATETIME        = GETDATE();
   DECLARE @errorSeverity   INT;
   DECLARE @errorMessage    NVARCHAR(4000);
   DECLARE @procedureName   VARCHAR(50)     = 'modifyDrugPurchaseDtQty';

   BEGIN TRY
         UPDATE [dbo].[DrugPurchaseDt]
            SET CheckQty   = @checkQty,
                SystemUser = @systemUser,
                SystemTime = @systemTime
          WHERE PurchaseNo = @purchaseNo
            AND DrugCode   = @drugCode
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(),@errorMessage  = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;
         THROW;
   END CATCH
END
GO

DECLARE @params NVARCHAR(MAX) = 
'
{
   "purchaseNo": 1171,
   "drugCode": 728,
   "checkQty": 100,
   "systemUser": 22342
}
';

EXEC [dbo].[modifyDrugPurchaseDtQty] @params
GO
