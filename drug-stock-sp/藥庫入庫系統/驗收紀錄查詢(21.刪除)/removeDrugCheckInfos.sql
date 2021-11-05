USE [HealthResource]
GO

--- 程序名稱：removeDrugCheckInfos
--- 程序說明：刪除多筆藥品驗收紀錄
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/11/05
CREATE PROCEDURE [dbo].[removeDrugCheckInfos](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @value           NVARCHAR(MAX);
   DECLARE @tranCount       INT = @@TRANCOUNT;
   DECLARE @index           INT = 0;
   DECLARE @count           INT = [fn].JSON_COUNT(@params);   
   DECLARE @errorSeverity   INT;
   DECLARE @errorMessage    NVARCHAR(4000);
   DECLARE @procedureName   VARCHAR(30) = 'removeDrugCheckInfos'; 

   -- BEGIN TRAN
   IF (@tranCount = 0) BEGIN TRAN;

   BEGIN TRY
         WHILE (@index < @count)
         BEGIN
           SET @value = [fn].JSON_ARRAY(@params, @index)
           EXEC [dbo].[removeDrugCheckInfo] @value
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
GO

DECLARE @params NVARCHAR(MAX) =
'
[
      {
            "batchNo": 131406,
            "checkNo": 469008,
            "checkQty": 90,
            "checkTime": "2021-07-07 08:59:58",
            "checkType": 10,
            "disPlayNo": 0,
            "drugCode": 3287,
            "drugName": "【美平】 Meropenem Trihydrate 250mg/Vial",
            "expDate": "2024-02-29",
            "invoiceDate": "20210707",
            "invoiceNo": "UZ82838407",
            "lotNo": "2097C",
            "medCode": "IMEROPE ",
            "orginalExpDate": "2024-02-29",
            "orginalInvNo": "PM53010951",
            "orginalLotNo": "2097C",
            "purchaseNo": 348607,
            "purchaseQty": 3000,
            "stockNo": "1P11",
            "systemUser": 37029,
            "unit": 70,
            "invoiceType": 10,
            "newSystemUser": 999999,
            "purchaseStatus": 60,
            "systemTime": "2021-11-04 14:40:00",
            "checkStatus": 80
      },
      {
            "batchNo": 131406,
            "checkNo": 471661,
            "checkQty": 24,
            "checkTime": "2021-07-07 08:59:58",
            "checkType": 10,
            "disPlayNo": 0,
            "drugCode": 824,
            "drugName": "潔用酒精 75%",
            "expDate": "2024-02-29",
            "invoiceDate": "20210707",
            "invoiceNo": "UZ82838407",
            "lotNo": "2097C",
            "medCode": "IMEROPE ",
            "orginalExpDate": "2024-02-29",
            "orginalInvNo": "PM53010951",
            "orginalLotNo": "2097C",
            "purchaseNo": 348991,
            "purchaseQty": 3000,
            "stockNo": "1P11",
            "systemUser": 37029,
            "unit": 70,
            "invoiceType": 10,
            "newSystemUser": 999999,
            "purchaseStatus": 60,
            "systemTime": "2021-11-04 14:40:00",
            "checkStatus": 80
      }
]
'
EXEC [dbo].[setDrugCheckProcedures] @params
GO
