USE [HealthResource]
GO

--- 程序名稱：setDrugPurchaseDt
--- 程序說明：設定藥品採購明細檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/12
CREATE PROCEDURE [dbo].[setDrugPurchaseDt](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime    DATETIME       = GETDATE();
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'setDrugPurchaseDt';

   BEGIN TRY
         MERGE INTO [dbo].[DrugPurchaseDt] AS t
         USING ( SELECT *
                   FROM OPENJSON(@params)       
                   WITH ( PurchaseNo   INT      '$.purchaseNo',
                          DrugCode     INT      '$.drugCode',
                          InStockNo    CHAR(04) '$.inStockNo',
                          DemandQty    INT      '$.demandQty',
                          PurchaseQty  INT      '$.purchaseQty',
                          GiftQty      INT      '$.giftQty',  
                          CheckQty     INT      '$.checkQty',
                          Unit         SMALLINT '$.unit',        
                          FollowTimes  TINYINT  '$.followTimes', 
                          IsDelay      BIT      '$.isDelay',     
                          IsDirectlyIn BIT      '$.isDirectlyIn',
                          ClearUser    INT      '$.clearUser',   
                          ClearDate    DATE     '$.clearDate',   
                          ClearReason  TINYINT  '$.clearReason', 
                          SystemUser   INT      '$.systemUser'    
                        )
                 ) AS s (
                          PurchaseNo, 
                          DrugCode, 
                          InStockNo, 
                          DemandQty, 
                          PurchaseQty, 
                          GiftQty, 
                          CheckQty, 
                          Unit, 
                          FollowTimes, 
                          IsDelay, 
                          IsDirectlyIn, 
                          ClearUser, 
                          ClearDate, 
                          ClearReason, 
                          SystemUser
                        )  
            ON (t.PurchaseNo = s.PurchaseNo AND t.DrugCode = s.DrugCode)    
         WHEN MATCHED THEN  
              UPDATE SET 
                    t.InStockNo    = ISNULL(s.InStockNo, t.InStockNo),      
                    t.DemandQty    = ISNULL(s.DemandQty, t.DemandQty),     
                    t.PurchaseQty  = ISNULL(s.PurchaseQty, t.PurchaseQty), 
                    t.GiftQty      = ISNULL(s.GiftQty, t.GiftQty),       
                    t.CheckQty     = ISNULL(s.CheckQty, t.CheckQty),    
                    t.Unit         = ISNULL(s.Unit, t.Unit),          
                    t.FollowTimes  = ISNULL(s.FollowTimes, t.FollowTimes),    
                    t.IsDelay      = ISNULL(s.IsDelay, t.IsDelay),       
                    t.IsDirectlyIn = ISNULL(s.IsDirectlyIn, t.IsDirectlyIn),
                    t.ClearUser    = ISNULL(s.ClearUser, t.ClearUser),   
                    t.ClearDate    = ISNULL(s.ClearDate, t.ClearDate),   
                    t.ClearReason  = ISNULL(s.ClearReason, t.ClearReason), 
                    t.SystemUser   = s.SystemUser,
                    t.SystemTime   = @SystemTime       
         WHEN NOT MATCHED THEN
              INSERT (
                       PurchaseNo,  
                       DrugCode,   
                       InStockNo,   
                       DemandQty,   
                       PurchaseQty, 
                       GiftQty,     
                       CheckQty,    
                       Unit,        
                       FollowTimes, 
                       IsDelay,     
                       IsDirectlyIn,
                       ClearUser,   
                       ClearDate,   
                       ClearReason, 
                       SystemUser,
                       SystemTime  
                     )
              VALUES (
                       s.PurchaseNo,  
                       s.DrugCode,    
                       s.InStockNo,   
                       s.DemandQty,   
                       s.PurchaseQty, 
                       s.GiftQty,     
                       s.CheckQty,     
                       s.Unit,        
                       s.FollowTimes, 
                       s.IsDelay,      
                       s.IsDirectlyIn,
                       s.ClearUser,   
                       s.ClearDate,   
                       s.ClearReason, 
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
   "purchaseNo": 998,  
   "drugCode": 7702,
   "inStockNo": "1P11",  
   "demandQty": 50,
   "purchaseQty": 1,
   "giftQty": 30,  
   "checkQty": 40,
   "unit": 101,      
   "followTimes": 30,
   "isDelay": 1,   
   "isDirectlyIn": 0,
   "clearUser": 1024, 
   "clearDate": "2020-04-20", 
   "clearReason": 104,
   "systemUser": 37028 
}
'; 

EXEC [dbo].[setDrugPurchaseDt] @params
GO
