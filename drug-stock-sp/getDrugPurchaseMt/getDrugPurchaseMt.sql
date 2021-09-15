USE [HealthResource]
GO

--- 程序名稱：getDrugPurchaseMt
--- 程序說明：取得藥品採購主檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/09/15
CREATE PROCEDURE [dbo].[getDrugPurchaseMt](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @purchaseNo INT = JSON_VALUE(@params, '$.purchaseNo');

   SELECT [purchaseNo]     = a.PurchaseNo,
          [purchaseUser]   = a.PurchaseUser,
          [purchaseTime]   = a.PurchaseTime,
          [deliveryTime]   = a.DeliveryTime,
          [orgNo]          = a.OrgNo, 
          [shipmentTime]   = a.ShipmentTime,
          [purchaseStatus] = a.PurchaseStatus,
          [sendUser]       = a.SendUser,
          [sendTime]       = a.SendTime,
          [remark]         = a.Remark,
          [systemUser]     = a.SystemUser,
          [systemTime]     = a.SystemTime
     FROM [dbo].[DrugPurchaseMt] AS a
    WHERE a.PurchaseNo = @purchaseNo
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

DECLARE @params NVARCHAR(MAX) = 
'
{
   "purchaseNo": 10245,
} 
';

EXEC [dbo].[getDrugPurchaseMt] @params
GO