USE [HealthResource]
GO

--- 程序名稱：setDrugPurchaseMt
--- 程序說明：設定藥品採購主檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/09/09
CREATE PROCEDURE [dbo].[setDrugPurchaseMt](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime    DATETIME       = GETDATE();
   DECLARE @errorSeverity INT;
   DECLARE @purchaseNo    INT            = COALESCE(JSON_VALUE(@params, '$.purchaseNo'), 0);
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'setDrugPurchaseMt';

   BEGIN TRY
         MERGE INTO [dbo].[DrugPurchaseMt] AS t
         USING ( SELECT *
                   FROM OPENJSON(@params)       
                   WITH ( PurchaseNo     INT           '$.purchaseNo',
                          PurchaseStatus TINYINT       '$.purchaseStatus', 
                          PurchaseUser   INT           '$.purchaseUser',
                          OrgNo          CHAR(10)      '$.orgNo',
                          SendUser       INT           '$.sendUser',
                          Remark         NVARCHAR(255) '$.remark',   
                          SystemUser     INT           '$.systemUser',
                          PurchaseTime   DATETIME      '$.purchaseTime',
                          DeliveryTime   DATETIME      '$.deliveryTime',
                          ShipmentTime   DATETIME      '$.shipmentTime',
                          SendTime       DATETIME      '$.sendTime'
                        )
                 ) AS s (
                          PurchaseNo,
                          PurchaseStatus,
                          PurchaseUser,
                          OrgNo,
                          SendUser,
                          Remark,
                          SystemUser,
                          PurchaseTime,
                          DeliveryTime,
                          ShipmentTime,
                          SendTime
                        )
            ON (t.PurchaseNo = s.PurchaseNo)    
         WHEN MATCHED THEN 
              UPDATE SET 
                     t.PurchaseStatus = ISNULL(s.PurchaseStatus,  t.PurchaseStatus),
                     t.PurchaseTime   = ISNULL(s.purchaseTime, t.PurchaseTime), 
                     t.PurchaseUser   = ISNULL(s.PurchaseUser, t.PurchaseUser), 
                     t.DeliveryTime   = ISNULL(s.DeliveryTime, t.DeliveryTime), 
                     t.OrgNo          = ISNULL(s.OrgNo, t.OrgNo),        
                     t.ShipmentTime   = ISNULL(s.ShipmentTime, t.ShipmentTime), 
                     t.SendUser       = ISNULL(s.SendUser, t.SendUser),    
                     t.SendTime       = ISNULL(s.SendTime, t.SendTime),      
                     t.Remark         = ISNULL(s.Remark, t.Remark),       
                     t.SystemUser     = s.SystemUser, 
                     t.SystemTime     = @systemTime   
         WHEN NOT MATCHED THEN
              INSERT (
                       PurchaseStatus,
                       PurchaseTime, 
                       PurchaseUser,   
                       DeliveryTime, 
                       OrgNo,          
                       ShipmentTime,   
                       SendUser,      
                       SendTime,       
                       Remark, 
                       SystemUser,    
                       SystemTime     
                     )
              VALUES (
                       s.PurchaseStatus,
                       s.PurchaseTime, 
                       s.PurchaseUser, 
                       s.DeliveryTime,  
                       s.OrgNo,         
                       s.ShipmentTime,  
                       s.SendUser,       
                       s.SendTime, 
                       s.Remark, 
                       s.SystemUser,     
                       @systemTime 
                     );
                     IF (@purchaseNo = 0) SET @purchaseNo = @@IDENTITY
                     
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;
         THROW;
   END CATCH
   RETURN @purchaseNo
END 
GO

DECLARE @params NVARCHAR(MAX) = 
'
{
   "purchaseNo": 15378,    
   "purchaseStatus": 70,  
   "purchaseUser": 7071,   
   "orgNo": "072",         
   "sendUser": 7068,          
   "remark": "無",        
   "systemUser": 37029   
}
';

EXEC [dbo].[setDrugPurchaseMt] @params
GO