USE [HealthResource]
GO

--- 程序名稱: getDrugPurchaseQty
--- 程序說明: 取得藥品採購量
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/10
CREATE FUNCTION [fn].[getDrugPurchaseQty] (@purchaseType INT, @totalQty INT, @purchaseQty INT, @packageQty INT)
RETURNS INT
AS BEGIN
   DECLARE @buyQty INT = 0;

   IF @purchaseType=5
     SET @buyQty = CEILING(CEILING(@totalQty / 25) * 10 / @packageQty) * @packageQty
   
   IF @purchaseType=10 OR @purchaseType=11
      SET @buyQty = @purchaseQty 

   RETURN @buyQty
END