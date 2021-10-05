USE [HealthResource]
GO

--- 程序名稱: getDrugExpList
--- 程序說明: 取得藥品效期資料
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/24
CREATE PROCEDURE [dbo].[getDrugExpList](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo  CHAR(04) = JSON_VALUE(@params, '$.demandStock');
   DECLARE @drugCode INT      = JSON_VALUE(@params, '$.drugCode');
   
   SELECT [stockNo]  = a.StockNo,  
          [drugCode] = a.DrugCode, 
          [batchNo]  = a.BatchNo,  
          [lotNo]    = b.LotNo,    
          [expDate]  = b.ExpDate,  
          [stockQty] = a.StockQty 
     FROM DrugStockDt a
     LEFT JOIN DrugBatch b ON b.DrugCode = a.DrugCode AND b.BatchNo = a.BatchNo
    WHERE a.StockNo  = @stockNo
      AND a.DrugCode = @drugCode
    ORDER BY b.ExpDate DESC
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(max) =
'
{
    "demandStock": "1P11",
    "drugCode": 8
}
';

EXEC [dbo].[getDrugExpList] @params
GO