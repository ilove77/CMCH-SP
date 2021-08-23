USE [HealthResource]
GO

--- 程序名稱: getDrugTranRecord
--- 程序說明: 取得DrugTranRecord表格資料
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/23
CREATE PROCEDURE [dbo].[getDrugTranRecord] (@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @tranNo INT = JSON_VALUE(@params,'$.tranNo');

   SELECT [tranNo]       = a.TranNo,
          [demandNo]     = a.DemandNo,
          [tranType]     = a.TranType,
          [matCode]      = a.MatCode,
          [inStockNo]    = a.InStockNo,
          [inStockUser]  = a.InStockUser,
          [inStockTime]  = a.InStockTime,
          [outStockNo]   = a.OutStockNo,
          [outStockUser] = a.OutStockUser,
          [outStockTime] = a.OutStockTime,
          [stockQty]     = a.StockQty,
          [batchNo]      = a.BatchNo,
          [systemUser]   = a.SystemUser,
          [systemTime]   = a.SystemTime
     FROM [dbo].[MatTranRecord] AS a
    WHERE a.TranNo = @tranNo
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
  "tranNo": 1,
}
'
;

EXEC [dbo].[getDrugTranRecord] @params
GO