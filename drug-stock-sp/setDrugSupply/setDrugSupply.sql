USE [HealthResource]
GO

--- 程序名稱：setDrugSupply
--- 程序說明：設定藥品供應單
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/13
CREATE PROCEDURE [dbo].[setDrugSupply](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime    DATETIME       = GETDATE();
   DECLARE @errorSeverity INT;
   DECLARE @supplyNo      INT            = COALESCE(JSON_VALUE(@params, '$.supplyNo'), 0);
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'setDrugSupply';

   BEGIN TRY
         MERGE INTO [dbo].[DrugSupply] AS t
         USING ( SELECT *
                   FROM OPENJSON(@params)
                   WITH ( 
                          SupplyNo    INT      '$.supplyNo',
                          DemandNo    INT      '$.demandNo',
                          SupplyQty   INT      '$.supplyQty',   
                          SupplyUser  INT      '$.supplyUser ',
                          SupplyTime  DATETIME '$.supplyTime',
                          ReceiveUser INT      '$.receiveUser',
                          ReceiveTime DATETIME '$.receiveTime',      
                          SystemUser  INT      '$.systemUser'
                        )
                 ) AS s (
                          SupplyNo,   
                          DemandNo,   
                          SupplyQty,  
                          SupplyUser,  
                          SupplyTime,
                          ReceiveUser,
                          ReceiveTime,
                          SystemUser
                        ) 
              ON (t.SupplyNo = s.SupplyNo)    
         WHEN MATCHED THEN  
              UPDATE SET       
                     t.DemandNo    = ISNULL(s.DemandNo, t.DemandNo),     
                     t.SupplyQty   = ISNULL(s.SupplyQty, t.SupplyQty),          
                     t.SupplyUser  = ISNULL(s.SupplyUser, t.SupplyUser),    
                     t.SupplyTime  = ISNULL(s.SupplyTime, t.SupplyTime),     
                     t.ReceiveUser = ISNULL(s.ReceiveUser, t.ReceiveUser), 
                     t.ReceiveTime = ISNULL(s.ReceiveTime, t.ReceiveTime), 
                     t.SystemUser  = s.SystemUser, 
                     t.SystemTime  = @systemTime
         WHEN NOT MATCHED THEN
              INSERT (
                       DemandNo,    
                       SupplyQty,    
                       SupplyUser,    
                       SupplyTime,   
                       ReceiveUser, 
                       ReceiveTime, 
                       SystemUser,  
                       SystemTime
                     )
              VALUES (
                       s.DemandNo,   
                       s.SupplyQty,  
                       s.SupplyUser, 
                       s.SupplyTime, 
                       s.ReceiveUser,
                       s.ReceiveTime,
                       s.SystemUser, 
                       @systemTime
                     );
              IF (@supplyNo = 0) SET @supplyNo = @@IDENTITY;
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;  
         THROW;
   END CATCH

   RETURN @supplyNo
END
GO

DECLARE @params NVARCHAR(max) = 
'
{
    "tranNo": 726521,
    "demandNo": 616393,
    "supplyQty": 5000,
    "supplyUser": 37029,
    "supplyTime": "2021-08-13 08:06:26.000",
    "receiveUser": 0,
    "receiveTime": "2999-12-31 00:00:00.000",
    "systemUser": 37029,
    "systemTime": "2021-08-13 08:06:26.000"
}
';

EXEC [dbo].[setDrugSupply] @params
GO