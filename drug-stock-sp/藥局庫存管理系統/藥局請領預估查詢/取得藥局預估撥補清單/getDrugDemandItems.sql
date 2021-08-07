USE [HealthResource]
GO

--- 程序名稱：getDrugDemandItems
--- 程序說明：取得藥局預估撥補清單
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/13
CREATE PROCEDURE [dbo].[getDrugDemandItems](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo     CHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @grantTime   DATETIME = JSON_VALUE(@params, '$.grantTime');
   DECLARE @currentTime DATETIME = GETDATE();

    SELECT b.MedCode    AS [medCode],
           b.DrugName   AS [drugName],
           a.SafetyQty  AS [safetyQty],
           a.MaxQty     AS [maxQty],
           a.totalQty   AS [stockQty],
           a.PackageQty AS [packageQty],
           [fn].[getUnitName](b.ChargeUnit)              AS [chargeUnitName],
           [fn].[getUnitName](a.StockUnit)               AS [stockUnitName],
           [fn].[getDrugOnWayQty](a.StockNo, a.DrugCode) AS [onWayQty],
           [fn].[getDrugGrantQty](a.StockNo, a.DrugCode, @outStockTime1, @outStockTime2) AS [grantQty]
      FROM DrugStockMt AS a,
           DrugBasic   AS b
     WHERE a.StockNo    = @stockNo
       AND a.StartTime <= @currentTime
       AND a.EndTime   >= @currentTime
       AND b.DrugCode   = a.DrugCode
       AND b.StartTime <= @currentTime
       AND b.EndTime   >= @currentTime
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P12",
   "outStockTime1": "2021-07-10 00:00:00.000",
   "outStockTime2": "2021-07-13 00:00:00.000"
}
';

EXEC [dbo].[getDrugDemandItems] @params
GO