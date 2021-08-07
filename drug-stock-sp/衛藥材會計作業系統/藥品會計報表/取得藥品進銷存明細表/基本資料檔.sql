USE [HealthResource]
GO

--- 程序名稱：getDrugReviewInfos
--- 程序說明：取得藥品審核明細
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/07
--CREATE PROCEDURE [dbo].[getDrugReviewInfos](@params NVARCHAR(MAX))
--AS BEGIN
DECLARE @params NVARCHAR(MAX) =
'
{
    "branchCode": "1",
	"stockNo":"",
	"stockMonth":"202105"
}
'
   --DECLARE @checkNo  INT      = JSON_VALUE(@params,'$.checkNo');
   --DECLARE @stockNo  CHAR(04) = JSON_VALUE(@params,'$.stockNo');
   --DECLARE @medCode  CHAR(08) = JSON_VALUE(@params,'$.medCode');
   --DECLARE @itemType TINYINT  = 10;

SELECT  DISTINCT b.MedCode, 
                 b.DrugName,
				 b.DrugCode, 
                 a.StockNo, 
				 a.StockUnit,
				 a.StockRatio,
				 a.PurchaseQty,
				 [fn].[getOptionName](a.InvType, 'DrugBasic', 'InvType') AS [InvTypeName],
				 [fn].[getOptionName](a.DrugType, 'DrugBasic', 'DrugType') AS [DrugTypeName],
				 [fn].[getDepartShortName](a.StockNo) AS [StockName],
				 [fn].[getUnitName](a.StockUnit) AS [StockUnitName],
				 [fn].[getUnitName](a.StockUnit) AS [RatioUnitName]
FROM DrugStockMt a,
	 DrugBasic b,
     fn.getMatStockQtyYX(@params) c
	 --MatTransDay d
WHERE a.StockNo LIKE '1P11%'
  AND b.DrugCode = a.DrugCode
  AND b.StartTime <= GETDATE()
  AND b.EndTime >= GETDATE()
  AND c.StockNo = a.StockNo
  AND c.MatCode = a.DrugCode
  --AND d.StockNo = a.StockNo
 -- AND d.MatCode = c.MatCode
  --AND d.TranDate BETWEEN '2021-05-01' AND '2021-05-31'
--END
--GO



--EXEC [dbo].[getDrugReviewInfos] @params
--GO

