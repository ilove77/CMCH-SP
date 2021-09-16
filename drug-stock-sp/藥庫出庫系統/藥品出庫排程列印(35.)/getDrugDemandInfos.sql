USE [HealthResource]
GO

--- 程序名稱：getDrugDemandInfos
--- 程序說明：取得藥品需求資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/06/30
CREATE PROCEDURE [dbo].[getDrugDemandInfos](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @demandTime1   DATETIME = [fn].[getDateMinTime](JSON_VALUE(@params, '$.demandDate1'));
   DECLARE @demandTime2   DATETIME = [fn].[getDateMaxTime](JSON_VALUE(@params, '$.demandDate2'));
   DECLARE @demandStock   CHAR(04) = JSON_VALUE(@params, '$.demandStock');
   DECLARE @supplyStock   CHAR(04) = JSON_VALUE(@params, '$.supplyStock');
   DECLARE @medCode       CHAR(08) = JSON_VALUE(@params, '$.medCode');
   DECLARE @tranStatus    TINYINT  = 10;

   SELECT a.DemandNo    AS [demandNo],
          b.StockNo     AS [stockNo],
          c.MedCode     AS [medCode],
          b.DrugCode    AS [drugCode],
          c.BrandName1  AS [drugName],
          a.ContactExt  AS [contactExt],
          a.DemandStock AS [demandStock],
          a.DemandType  AS [demandType],
          a.DemandTime  AS [demandTime],
          a.CheckTime   AS [checkTime],
          b.DrugType    AS [drugType],
          a.SupplyQty   AS [supplyQty],
          b.TotalQty    AS [totalQty],
          a.DemandQty   AS [demandQty],
          [fn].[getDepartShortName](b.StockNo)            AS [demandStockName],
          [fn].[getEmpName](a.DemandUser)                 AS [demandUserName],
          [fn].[getDrugBatchLotNo](b.StockNo, b.DrugCode) AS [lotNo]
     FROM DrugDemand  AS a, 
          DrugStockMt AS b, 
          DrugBasic   AS c
    WHERE a.DemandTime  BETWEEN @demandTime1 AND @demandTime2
      AND a.SupplyStock = @supplyStock
      AND a.TranStatus  = @tranStatus
      AND b.StockNo     = a.DemandStock
      AND b.DrugCode    = a.DrugCode
      AND b.StockNo     = [fn].[stringFilter](@demandStock, b.StockNo)
      AND c.DrugCode    = a.DrugCode
      AND c.StartTime  <= a.CheckTime
      AND c.EndTime    >= a.CheckTime
      AND c.MedCode     = [fn].[stringFilter](@medCode, c.MedCode)
    ORDER BY a.CheckTime DESC 
      FOR JSON PATH
      
END
GO
DECLARE @params NVARCHAR(max) =
'
{
    "demandDate1": "2021-09-01",
    "demandDate2": "2021-09-30",
    "demandStock": "1NDC",
    "medCode": "",
    "supplyStock": "1P11",
    "tranStatus": 10
}
'
EXEC [dbo].[getDrugDemandInfos] @params
GO