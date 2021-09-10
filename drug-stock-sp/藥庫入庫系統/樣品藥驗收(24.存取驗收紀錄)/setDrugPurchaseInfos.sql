USE [HealthResource]
GO

--- 程序名稱：setDrugPurchaseInfos
--- 程序說明：建立多筆樣品藥採購資訊，並建驗收檔
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/09/10
ALTER PROCEDURE [dbo].[setDrugPurchaseInfos](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @value           NVARCHAR(MAX);
   DECLARE @tranCount       INT = @@TRANCOUNT;
   DECLARE @index           INT = 0;
   DECLARE @count           INT = [fn].JSON_COUNT(@params);   
   DECLARE @errorSeverity   INT;
   DECLARE @purchaseNo      INT;
   DECLARE @errorMessage    NVARCHAR(4000);
   DECLARE @procedureName   VARCHAR(30) = 'setDrugPurchaseInfos'; 

   -- BEGIN TRAN
   IF (@tranCount = 0) BEGIN TRAN;

   BEGIN TRY
         WHILE (@index < @count)
         BEGIN

           SET @value = [fn].JSON_ARRAY(@params, @index)           
           EXEC @purchaseNo = [dbo].[setDrugPurchaseInfo] @value
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
   RETURN @purchaseNo
END
GO

DECLARE @params NVARCHAR(MAX) = 
'
[
    {   
        "purchaseStatus": 70,
        "purchaseTime": "2021-09-10 09:11:18",
        "purchaseUser": 37029,
        "deliveryTime": "2021-09-10 09:11:18",   
        "orgNo": "8888",
        "shipmentTime": "2021-09-10 09:11:18",   
        "sendUser": 37029,  
        "sendTime": "2021-09-10 09:11:18",
        "drugCode":3678,
        "inStockNo": "1P11",
        "demandQty": 30,
        "purchaseQty": 30,
        "checkQty": 30,
        "giftQty": 0,
        "followTimes":0,
        "isDelay": false,
        "clearUser": 0,
        "clearDate": "2999-12-31",
        "clearReason": 0,
        "unit":60,
        "checkType":30,
        "checkTime": "2999-12-31 23:59:59",
        "checkUser":0,
        "payAmount":0,
        "payDate": "2022-01-10",
        "adjustAmount":0,
        "adjustRemark": "",
        "checkStatus":20,
        "acceptUser":37029,
        "acceptTime": "2021-09-10 09:11:18",
        "inStockTime": "2999-12-31 23:59:59",
        "oldPrice":4566,
        "newPrice":4566,
        "sendRemark": "",
        "debitReason": "",
        "lotNo":"11111",
        "expDate": "20210823",
        "invoiceNo": "",
        "invoiceDate":"",  
        "remark": "無",        
        "systemUser": 37029   
    },
    {
        "purchaseStatus": 70,
        "purchaseTime": "2021-09-10 09:11:18",
        "purchaseUser": 37029,
        "deliveryTime": "2021-09-10 09:11:18",   
        "orgNo": "8888",
        "shipmentTime": "2021-09-10 09:11:18",   
        "sendUser": 37029,  
        "sendTime": "2021-09-10 09:11:18",
        "drugCode":3678,
        "inStockNo": "1P11",
        "demandQty": 30,
        "purchaseQty": 30,
        "checkQty": 30,
        "giftQty": 0,
        "followTimes":0,
        "isDelay": false,
        "clearUser": 0,
        "clearDate": "2999-12-31",
        "clearReason": 0,
        "unit":60,
        "checkType":30,
        "checkTime": "2999-12-31 23:59:59",
        "checkUser":0,
        "payAmount":0,
        "payDate": "2022-01-10",
        "adjustAmount":0,
        "adjustRemark": "",
        "checkStatus":20,
        "acceptUser":37029,
        "acceptTime": "2021-09-10 09:11:18",
        "inStockTime": "2999-12-31 23:59:59",
        "oldPrice":4566,
        "newPrice":4566,
        "sendRemark": "",
        "debitReason": "",
        "lotNo":"11111",
        "expDate": "20210823",
        "invoiceNo": "",
        "invoiceDate":"",  
        "remark": "無",        
        "systemUser": 37029 
    }
]
';

EXEC [dbo].[setDrugPurchaseInfos] @params
GO
