USE [HealthResource]
GO

--- 程序名稱：addDrugTranRecord
--- 程序說明：新增藥品交易記錄檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/23
ALTER PROCEDURE [dbo].[addDrugTranRecord](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @tranNo         INT;
   DECLARE @systemTime     DATETIME    = GETDATE();
   DECLARE @defaultTime    DATETIME    = '2999-12-31 00:00';
   DECLARE @procedureName  VARCHAR(20) = 'addDrugTranRecord';
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
 
   BEGIN TRY
         INSERT INTO [dbo].[DrugTranRecord]
               (
               TranType,     
               DrugCode,  
               StockQty, 
               DemandNo,                                                
               InStockNo,    
               InStockUser,  
               InStockTime,  
               OutStockNo,   
               OutStockUser, 
               OutStockTime, 
               BatchNo,      
               SystemUser,   
               SystemTime    
               )
         SELECT [TranType]     = a.TranType,   
                [DrugCode]     = a.DrugCode, 
                [StockQty]     = a.StockQty,                                   
                [DemandNo]     = ISNULL(a.DemandNo,0),  
                [InStockNo]    = ISNULL(a.InStockNo,'0'),  
                [InStockUser]  = ISNULL(a.InStockUser,0),  
                [InStockTime]  = ISNULL(a.InStockTime,@defaultTime),  
                [OutStockNo]   = ISNULL(a.OutStockNo,'0'),  
                [OutStockUser] = ISNULL(a.OutStockUser,0),  
                [OutStockTime] = ISNULL(a.OutStockTime,@defaultTime),  
                [BatchNo]      = ISNULL(a.BatchNo,0),  
                [SystemUser]   = a.SystemUser,    
                [SystemTime]   = @systemTime                                              
           FROM OPENJSON(@params)
           WITH (
                TranType     TINYINT  '$.tranType',    
                DrugCode     INT      '$.drugCode',          
                StockQty     INT      '$.stockQty',
                DemandNo     INT      '$.demandNo',   
                InStockNo    CHAR(04) '$.inStockNo',   
                InStockUser  INT      '$.inStockUser', 
                InStockTime  DATETIME '$.inStockTime', 
                OutStockNo   CHAR(04) '$.outStockNo',  
                OutStockUser INT      '$.outStockUser',
                OutStockTime DATETIME '$.outStockTime',
                BatchNo      INT      '$.batchNo',
                SystemUser   INT      '$.systemUser'
                ) AS a
         
         SET @tranNo = @@IDENTITY;              
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;

         THROW;
   END CATCH
   RETURN @tranNo;
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
  "tranType": 27,
  "drugCode": 3678,
  "stockQty": 2,
  "demandNo": 0,
  "inStockNo": "1231",
  "inStockUser": 1111,
  "inStockTime": "2021-07-28 12:00",
  "outStockNo": "111",
  "outStockUser": 1111,
  "outStockTime": "2021-07-28 12:00",
  "batchNo": 0,
  "systemUser": 37029
}
'
;

EXEC [dbo].[addDrugTranRecord] @params
GO