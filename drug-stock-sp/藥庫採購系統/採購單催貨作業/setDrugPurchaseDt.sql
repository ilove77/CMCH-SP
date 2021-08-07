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
         MERGE INTO [dbo].[DrugPurchaseDt] AS a
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
               ) AS b (
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
            ON (a.PurchaseNo = b.PurchaseNo AND a.DrugCode = b.DrugCode)    
         WHEN MATCHED THEN  
              UPDATE SET 
                     a.InStockNo    = b.InStockNo,   
                     a.DemandQty    = b.DemandQty,     
                     a.PurchaseQty  = b.PurchaseQty, 
                     a.GiftQty      = b.GiftQty,       
                     a.CheckQty     = b.CheckQty,    
                     a.Unit         = b.Unit,          
                     a.FollowTimes  = b.FollowTimes,    
                     a.IsDelay      = b.IsDelay,       
                     a.IsDirectlyIn = b.IsDirectlyIn,
                     a.ClearUser    = b.ClearUser,   
                     a.ClearDate    = b.ClearDate,   
                     a.ClearReason  = b.ClearReason, 
                     a.SystemUser   = b.SystemUser,
                     a.SystemTime   = @SystemTime       
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
                      b.PurchaseNo,  
                      b.DrugCode,    
                      b.InStockNo,   
                      b.DemandQty,   
                      b.PurchaseQty, 
                      b.GiftQty,     
                      b.CheckQty,     
                      b.Unit,        
                      b.FollowTimes, 
                      b.IsDelay,      
                      b.IsDirectlyIn,
                      b.ClearUser,   
                      b.ClearDate,   
                      b.ClearReason, 
                      b.SystemUser,
                      @systemTime  
                     );                 
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;
         THROW;
   END CATCH
END

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
