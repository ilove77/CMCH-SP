USE [HealthResource]
GO
DECLARE @params NVARCHAR(max) =
'
{
    "demandETime": "2021-06-30",
    "demandSTime": "2021-01-01",
    "demandStockNo": "1NDC",
    "medCode": "",
    "supplyStockNo": "1P11",
    "tranStatus": 10
}
'
--CREATE PROCEDURE [dbo].[getDrugPurchaseChecks](@params NVARCHAR(MAX))
--AS BEGIN
DECLARE @demandDate1     DATE          = [fn].[getDateMinTime](JSON_VALUE(@params, '$.demandSTime'));
DECLARE @demandDate2     DATE          = JSON_VALUE(@params, '$.demandETime');
DECLARE @demandStockNo   CHAR(04) = JSON_VALUE(@params, '$.demandStockNo');
DECLARE @supplyStockNo   CHAR(04) = JSON_VALUE(@params, '$.supplyStockNo'); --一定要輸入庫別
DECLARE @tranStatus      TINYINT  = JSON_VALUE(@params, '$.tranStatus');
DECLARE @medCode         CHAR(08) = JSON_VALUE(@params, '$.medCode');     
SELECT           a.DemandNo  AS  [demandNo],
                 a.DemandStock AS [demandStock],
                 a.DemandTime  AS [demandTime],
				 a.ContactExt  AS [contactExt],
				 a.CheckTime   AS [checkTime],
				 a.DemandType  AS [demandType],
                 b.StockNo     AS [stockNo],
				 c.MedCode     AS [MedCode],
                 b.DrugCode    AS [drugCode],
                 c.DrugName    AS [drugName],
                 c.DrugType    AS [drugType],
				 a.SupplyQty   AS [supplyQty],
			     b.TotalQty    AS [totalQty],
				 a.DemandQty   AS [demandQty],
				 a.SupplyStock,
				 [fn].[getDepartShortName](b.StockNo) AS [demandStockName],
				 [fn].[getEmpName](a.DemandUser) AS [demandUserName],
				 [fn].[getDrugBatchLotNo](b.StockNo, b.DrugCode) AS [lotNo]
FROM     DrugDemand        AS a, 
         DrugStockMt       AS b, 
		 DrugBasic         AS c
WHERE a.DemandTime BETWEEN  @demandDate1 AND @demandDate2   
AND   a.DemandStock = b.StockNo
--AND a.SupplyStock = @supplyStockNo
AND   a.DrugCode    = b.DrugCode
AND   a.TranStatus  = @tranStatus
AND   b.StockNo     = [fn].[stringFilter](@demandStockNo, b.StockNo)
AND   c.StartTime <= a.CheckTime
AND   c.EndTime   >= a.CheckTime  
AND   c.DrugCode    = a.DrugCode
AND   c.MedCode = [fn].[stringFilter](@medCode,c.MedCode)
