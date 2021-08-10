USE [HealthResource]
GO

--- 程序名稱: getDrugPurchaseQty
--- 程序說明: 取得藥品採購量
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/06
CREATE FUNCTION [fn].[getDrugPurchaseQty] (@supplyStock CHAR(04),@purchaseType INT, @drugCode INT, @totalGrantQty INT, @purchaseQty INT, @packageQty INT, @demandTime1 DATETIME, @demandTime2 DATETIME)
RETURNS INT
AS BEGIN
   DECLARE @buyQty INT = 0;

   IF @purchaseType=5
     SET @buyQty = CEILING(@totalGrantQty / 25) * 10 / @packageQty * @packageQty
   
   IF @purchaseType=10 OR @purchaseType=11
      SET @buyQty = @purchaseQty 

   RETURN @buyQty
END