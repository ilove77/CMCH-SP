DECLARE @params NVARCHAR(MAX) =
'
{
	"stockNo":"1P1B",
}
'
   --DECLARE @checkNo  INT      = JSON_VALUE(@params,'$.checkNo');
   --DECLARE @stockNo  CHAR(04) = JSON_VALUE(@params,'$.stockNo');
   --DECLARE @medCode  CHAR(08) = JSON_VALUE(@params,'$.medCode');
   DECLARE @currentTime DATETIME = GETDATE()
   --DECLARE @itemType TINYINT  = 10;
SELECT  top 1000
b.MedCode,
b.DrugCode,
b.DrugName,
a.SafetyQty,
a.MaxQty,
a.totalQty AS [stockQty],
a.PackageQty,
[fn].[getUnitName](b.ChargeUnit) AS [chargeUnitName],
[fn].[getDrugGrantQtys](a.StockNo, a.DrugCode, @currentTime) AS [grantQty],
[fn].[getDrugOnWayQty](a.StockNo, a.DrugCode),
--subsidizedQty 箇璸挤干计秖
--grantQty у基计
--у基虫
[fn].[getUnitName](a.StockUnit) AS [StockUnitName]
FROM DrugStockMt a,
     DrugBasic b
WHERE 1 = 1
  AND a.StockNo = '1P12'
  AND a.StartTime <= GETDATE()
  AND a.EndTime   >= GETDATE()
  AND b.DrugCode = a.DrugCode
  AND b.StartTime < GETDATE()
  AND b.EndTime > GETDATE()
  --AND b.MedCode = 'IAMIN10'
  AND a.MaxQty >= 0
  AND a.TotalQty < a.SafetyQty
  AND [fn].[getDrugOnWayQty](a.StockNo,a.DrugCode) + a.TotalQty <= a.SafetyQty
  AND a.PackageQty > 0
  AND FLOOR((a.MaxQty - a.TotalQty) / a.packageQty) * a.PackageQty > 0 















