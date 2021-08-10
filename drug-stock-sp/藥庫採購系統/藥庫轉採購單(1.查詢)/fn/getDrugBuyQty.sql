USE [HealthResource]
GO

--- 程序名稱: getDrugBuyQty
--- 程序說明: 取得藥品採購量
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/10
CREATE FUNCTION [fn].[getDrugBuyQty] (@purchaseType INT, @tranQty INT, @purchaseQty INT, @packageQty INT)
RETURNS INT
AS BEGIN
   DECLARE @buyQty INT = 0;

   IF @packageQty=0
      SET @packageQty = 1

   IF @purchaseType=5
      SET @buyQty = CEILING(CEILING((@tranQty * -1) / 25) * 10 / @packageQty) * @packageQty
   
   IF @purchaseType=10 OR @purchaseType=11
      SET @buyQty = @purchaseQty 

   RETURN @buyQty
END