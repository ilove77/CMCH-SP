USE [HealthResource]
GO

--- 程序名稱：getDrugPurchaseDt
--- 程序說明：取得藥品採購明細檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/04
CREATE PROCEDURE [dbo].[getDrugPurchaseDt](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @purchaseNo INT = JSON_VALUE(@params, '$.purchaseNo');
   DECLARE @drugCode   INT = JSON_VALUE(@params, '$.drugCode');

   SELECT [purchaseNo]   = a.PurchaseNo,    
          [drugCode]     = a.DrugCode, 
          [inStockNo]    = a.InStockNo,
          [demandQty]    = a.DemandQty,     
          [purchaseQty]  = a.PurchaseQty,
          [giftQty]      = a.GiftQty,
          [checkQty]     = a.CheckQty,
          [unit]         = a.Unit,   
          [followTimes]  = a.FollowTimes,  
          [isDelay]      = a.IsDelay,
          [isDirectlyIn] = a.IsDirectlyIn,  
          [clearUser]    = a.ClearUser,
          [clearDate]    = a.ClearDate,     
          [clearReason]  = a.ClearReason,   
          [systemUser]   = a.SystemUser,
          [systemTime]   = a.SystemTime
     FROM DrugPurchaseDt AS a
    WHERE a.PurchaseNo = @purchaseNo
      AND a.DrugCode   = @drugCode
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "purchaseNo": 1499,
   "drugCode": 3678
}
';

EXEC [dbo].[getDrugPurchaseDt] @params
GO