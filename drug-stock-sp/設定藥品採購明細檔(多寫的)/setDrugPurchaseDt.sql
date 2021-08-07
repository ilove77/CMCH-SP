USE [HealthResource]
GO

--- 程序名稱：setDrugPurchaseDt
--- 程序說明：設定藥品採購明細檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/05

CREATE PROCEDURE [dbo].[setDrugPurchaseDt](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime    DATETIME       = GETDATE();
   DECLARE @errorSeverity INT;
   DECLARE @purchaseNo    BIGINT         = 0;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'setDrugPurchaseDt';

   BEGIN TRY
         MERGE INTO [dbo].[DrugPurchaseDt] AS a
         USING ( SELECT *
                   FROM OPENJSON(@params)       
                   WITH ( PurchaseNo     INT           '$.purchaseNo',
                          PurchaseStatus TINYINT       '$.purchaseStatus', 
                          PurchaseUser   INT           '$.purchaseUser',
                          OrgNo          CHAR(10)      '$.orgNo',
                          SendUser       INT           '$.sendUser',
                          Remark         NVARCHAR(255) '$.remark',   
                          SystemUser     INT           '$.systemUser'
                        )
               ) AS b (PurchaseNo, PurchaseStatus, PurchaseUser, OrgNo, SendUser, Remark, SystemUser)
            ON (a.PurchaseNo = b.PurchaseNo)    
         WHEN MATCHED THEN	  
              UPDATE SET 
                     a.PurchaseStatus = b.PurchaseStatus,
                     a.PurchaseTime   = @systemTime,  
                     a.PurchaseUser   = b.PurchaseUser,  
                     a.DeliveryTime   = @systemTime,  
                     a.OrgNo          = b.OrgNo,         
                     a.ShipmentTime   = @systemTime,  
                     a.SendUser       = b.SendUser,      
                     a.SendTime       = @systemTime,      
                     a.Remark         = b.Remark,        
                     a.SystemUser     = b.SystemUser, 
                     a.SystemTime     = @SystemTime   
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
                      b.PurchaseStatus,
                      @systemTime, 
                      b.PurchaseUser, 
                      @systemTime,  
                      b.OrgNo,         
                      @systemTime,  
                      b.SendUser,       
                      @systemTime, 
                      b.Remark, 
                      b.SystemUser,     
                      @systemTime 
                     );
                     IF (@purchaseNo = 0) SET @purchaseNo = SCOPE_IDENTITY ();
                     
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
   "purchaseNo": 0,    
   "purchaseStatus": 70,  
   "purchaseUser": 7071,   
   "orgNo": "072",         
   "sendUser": 7068,          
   "remark": "無",        
   "systemUser": 7068   
}
';

EXEC [dbo].[setDrugPurchaseMt] @params
GO