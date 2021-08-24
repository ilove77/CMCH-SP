USE [HealthResource]
GO

--- 程序名稱: getDrugBatchNo
--- 程序說明: 取得最新一筆藥品品項批號
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/24
CREATE FUNCTION [fn].[getDrugBatchNo](@stockNo CHAR(04), @drugCode INT)
RETURNS INT
AS BEGIN
   DECLARE @batchNo INT = 0;

   SELECT TOP 1
          @batchNo = a.BatchNo
     FROM [dbo].[DrugStockDt] a
     LEFT JOIN [dbo].[DrugBatch] b ON a.DrugCode = b.DrugCode AND a.BatchNo = b.BatchNo
    WHERE a.StockNo  = @stockNo
      AND a.DrugCode = @drugCode
    ORDER BY b.ExpDate DESC
   RETURN @batchNo
END
GO
