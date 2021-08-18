USE [HealthResource]
GO

--- 程序名稱: getDrugDeliverQty
--- 程序說明: 取得藥品調撥(派送)量
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/18
CREATE FUNCTION [fn].[getDrugDeliverQty] (@maxQty INT, @totalQty INT, @packageQty INT)
RETURNS INT
AS BEGIN
   DECLARE @deliverQty INT = 0;

   IF @packageQty=0
      SET @packageQty = 1

   SET @deliverQty = FLOOR(@maxQty - @totalQty / @packageQty) * @packageQty

   RETURN @deliverQty
END