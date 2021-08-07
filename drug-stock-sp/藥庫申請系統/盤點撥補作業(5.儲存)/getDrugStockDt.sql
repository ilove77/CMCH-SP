USE [HealthResource]
GO

----- 程序名稱：getDrugStockDt
----- 程序說明：取得藥品庫存量檔
----- 編訂人員：蔡易志
----- 校閱人員：孫培然
----- 修訂日期：2021/07/27
CREATE PROCEDURE [dbo].[getDrugStockDt](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo  CHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @drugCode INT      = JSON_VALUE(@params, '$.drugCode');
   DECLARE @BatchNo  INT      = JSON_VALUE(@params, '$.batchNo');

   SELECT [stockNo]    = a.StockNo,     
          [drugCode]   = a.DrugCode,    
          [batchNo]    = a.BatchNo,     
          [stockQty]   = a.StockQty,    
          [systemUser] = a.SystemUser,  
          [systemTime] = a.SystemTime  
     FROM DrugStockDt AS a
    WHERE a.StockNo  = @stockNo
      AND a.DrugCode = @drugCode
      AND a.BatchNo  = @BatchNo
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

DECLARE @params NVARCHAR(max) =
'
{
    "stockNo": "1P11",
    "drugCode": 8,
    "batchNo": 143560
}
';

EXEC [dbo].[getDrugStockDt] @params
GO