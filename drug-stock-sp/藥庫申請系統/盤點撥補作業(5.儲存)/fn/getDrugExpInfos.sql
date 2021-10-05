USE [HealthResource]
GO

--- 程序名稱: getDrugExpInfos
--- 程序說明: 取得藥品最新一筆效期資料
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/23
CREATE FUNCTION [fn].[getDrugExpInfos](@stockNo CHAR(04), @drugCode INT)
RETURNS NVARCHAR(MAX)
AS BEGIN
   DECLARE @ NVARCHAR(MAX);
   

     
       SELECT [stockNo]  = a.StockNo,  
              [drugCode] = a.DrugCode,
              [batchNo]  = a.BatchNo,  
              [lotNo]    = b.LotNo,   
              [expDate]  = b.ExpDate,   
              [stockQty] = a.StockQty 
         FROM [dbo].[DrugStockDt] a
         LEFT JOIN [dbo].[DrugBatch] b ON a.DrugCode = b.DrugCode AND a.BatchNo = b.BatchNo
        WHERE a.StockNo  = @demandStock
          AND a.DrugCode = @drugCode
        ORDER BY b.ExpDate DESC
          FOR JSON PATH
     
   RETURN @expInfos
END
GO