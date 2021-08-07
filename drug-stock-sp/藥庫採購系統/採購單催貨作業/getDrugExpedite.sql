USE [HealthResource]
GO

--- 程序名稱：getDrugExpedite
--- 程序說明：取得藥品催貨資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/13
CREATE PROCEDURE [dbo].[getDrugExpedite](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @purchaseNo  INT      = JSON_VALUE(@params, '$.purchaseNo');
   DECLARE @drugcode    INT      = JSON_VALUE(@params, '$.drugCode');
   DECLARE @currentTime DATETIME = GETDATE();
   DECLARE @itemType    TINYINT  = 10;

    SELECT a.PurchaseNo   AS [purchaseNo],
           a.InStockNo    AS [inStockNo],
           c.MedCode      AS [medCode],
           c.GenericName1 AS [productName],
           b.OrgNo        AS [orgNo],
           b.PurchaseTime AS [purchaseTime],
           b.DeliveryTime AS [deliveryTime],
           a.DemandQty    AS [demandQty],
           a.PurchaseQty  AS [purchaseQty],
           a.GiftQty      AS [giftQty],
           b.Remark       AS [remark],
           a.followTimes  AS [followTimes],
           [fn].[getUnitBasicName](a.Unit)        AS [unitBasicName],
           JSON_QUERY([fn].[getOrgInfo](b.OrgNo)) AS [orgInfo],
           JSON_QUERY([fn].[getPurchaseFollowInfo](a.purhaseNo, a.drugcode, @itemType)) AS [purchaseFollowInfo]
      FROM DrugPurchaseDt AS a,
           DrugPurchaseMt AS b,
           DrugBasic      AS c
     WHERE a.PurchaseNo = @purchaseNo
       AND a.DrugCode   = @drugcode
       AND b.PurchaseNo = a.PurchaseNo
       AND c.DrugCode   = @drugcode
       AND c.StartTime <= @currentTime
       AND c.EndTime   >= @currentTime
       FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

DECLARE @params NVARCHAR(MAX) = 
'
{
   "purchaseNo": 348046,  
   "drugCode": 7702, 
}
';

EXEC [dbo].[getDrugExpedite] @params
GO