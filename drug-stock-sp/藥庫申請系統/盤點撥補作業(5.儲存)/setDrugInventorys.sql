USE [HealthResource]
GO

--- 程序名稱：setDrugInventorys
--- 程序說明：設定藥品盤點撥補資訊(多筆)
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/20
CREATE PROCEDURE [dbo].[setDrugInventorys](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @value          NVARCHAR(MAX);
   DECLARE @index          INT = 0;
   DECLARE @count          INT = [fn].JSON_COUNT(@params);
   DECLARE @tranCount      INT = @@TRANCOUNT;
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(20) = 'setDrugInventorys';

   IF (@tranCount = 0) BEGIN TRAN;
   
   BEGIN TRY
         WHILE(@index < @count)
		 BEGIN

         SET @value = [fn].JSON_ARRAY(@params, @index)
         EXEC [dbo].[setDrugInventory] @value
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
        //前端傳來的
	   "chargeUnit": 70,
	   "contactExt": 2608, 
	   "demandQty": 10,
	   "demandStock": "1A8D",
	   "drugCode": 3678,
	   "inventoryQty": 10,
	   "maxQty": 300,
	   "unarrivalQty": 4,
	   "packageQty": 1,
	   "remark": "資訊室測試",
	   "safetyQty": 200,
	   "totalQty": 30,
	   "supplyStock": "",
	   "systemUser": 37029,

       //這裡是model加的資料
       "drugDemands": 
	}
]
';

EXEC [dbo].[setDrugInventorys] @params
GO