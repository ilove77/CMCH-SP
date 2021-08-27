USE [HealthResource]
GO

--- 程序名稱: getDrugTranQty
--- 程序說明: 取得藥品交易量
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/27
CREATE FUNCTION [fn].[getDrugTranQty] (@outStockNo CHAR(04), @drugCode INT, @tranType TINYINT, @outStockTime1 DATETIME, @outStockTime2 DATETIME)
RETURNS INT
AS BEGIN 
   DECLARE @tranQty INT = 0;

   SELECT @tranQty = SUM(ISNULL(a.StockQty, 0))
     FROM [dbo].[DrugTranRecord] AS a
    WHERE a.OutStockNo   = @outStockNo
      AND a.DrugCode     = @drugCode
      AND a.TranType     = @tranType
      AND a.OutStockTime BETWEEN @outStockTime1 AND @outStockTime2
   
   RETURN ISNULL(@tranQty, 0)
END