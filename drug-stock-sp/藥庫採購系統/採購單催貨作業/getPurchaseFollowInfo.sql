USE [HealthResource]
GO

--- 程序名稱: getPurchaseFollowInfo
--- 程序說明: 取得 getPurchaseFollow 資訊
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/07/13
CREATE FUNCTION [fn].[getPurchaseFollowInfo] (@purchaseNo INT, @itemCode INT, @itemType TINYINT)
RETURNS NVARCHAR(MAX)
AS BEGIN 
   DECLARE @result NVARCHAR(MAX) = '';
 
   SELECT @result = ( 
       SELECT a.FollowNo   AS [followNo],
              a.ItemType   AS [itemType],
              a.PurchaseNo AS [purchaseNo],
              a.ItemCode   AS [itemCode],
              a.FollowTime AS [followTime],
              a.FollowUser AS [followUser]
         FROM [dbo].[PurchaseFollow] a
        WHERE a.PurchaseNo = @purchaseNo
          AND a.ItemCode   = @itemCode
          AND a.ItemType   = @itemType
          FOR JSON PATH
   )
   RETURN @result 
END
