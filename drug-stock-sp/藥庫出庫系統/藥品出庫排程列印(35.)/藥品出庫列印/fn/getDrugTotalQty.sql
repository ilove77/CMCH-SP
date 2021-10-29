USE [HealthResource]
GO

--- 程序名稱: getDrugTotalQty
--- 程序說明: 取得藥品庫存量
--- 編訂人員: 蔡易志          
--- 校閱人員：孫培然
--- 修訂日期：2021/10/29
CREATE FUNCTION [fn].[getDrugTotalQty] (@stockNo CHAR(04), @drugCode INT)
RETURNS INT
AS BEGIN 
   DECLARE @totalQty INT = 0;
 
   SELECT @totalQty = a.TotalQty   
     FROM [dbo].[DrugStockMt] AS a
    WHERE a.StockNo  = @stockNo
      AND a.DrugCode = @drugCode
   RETURN @totalQty
END