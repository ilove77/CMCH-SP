USE [HealthResource]
GO

--- 程序名稱：setDrugStockDt
--- 程序說明：設定藥品庫存量檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/06
CREATE PROCEDURE [dbo].[setDrugStockDt](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime    DATETIME       = GETDATE();
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'setDrugStockDt';

   BEGIN TRY
         MERGE INTO [dbo].[drugStockDt] AS t
         USING ( 
                 SELECT *
                   FROM OPENJSON(@params)          
                   WITH ( 
                          StockNo    CHAR(04) '$.stockNo',             
                          DrugCode   INT      '$.drugCode',
                          BatchNo    INT      '$.batchNo',   
                          StockQty   INT      '$.stockQty',
                          SystemUser INT      '$.systemUser'
                        )
                 ) AS s (
                          StockNo,
                          DrugCode, 
                          BatchNo, 
                          StockQty, 
                          SystemUser
                        )    
            ON (t.StockNo = s.StockNo AND t.DrugCode = s.DrugCode AND t.BatchNo = s.BatchNo)    
         WHEN MATCHED THEN 
              UPDATE SET   
                     t.StockQty   = ISNULL(s.StockQty, t.StockQty),
                     t.SystemUser = s.SystemUser,
                     t.SystemTime = @systemTime
         WHEN NOT MATCHED THEN
              INSERT (
                       StockNo, 
                       DrugCode, 
                       BatchNo, 
                       StockQty, 
                       SystemUser, 
                       SystemTime
                     )
              VALUES (
                       s.StockNo, 
                       s.DrugCode, 
                       s.BatchNo, 
                       s.StockQty, 
                       s.SystemUser, 
                       @systemTime
                     );

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
   "stockNo": 1009,  
   "drugCode": 503,
   "batchNo": 26925,  
   "stockQty": 70,
   "systemUser": 999999
}
';

EXEC [dbo].[setDrugStockDt] @params
GO