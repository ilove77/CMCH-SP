USE [HealthResource]
GO

--- 程序名稱：getDrugDemandRecords
--- 程序說明：取得藥庫需求資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/09/07
CREATE PROCEDURE [dbo].[getDrugDemandRecords](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo     CHAR(04)    = JSON_VALUE(@params, '$.stockNo');
   DECLARE @orgNo       CHAR(10)    = JSON_VALUE(@params, '$.orgNo');
   DECLARE @drugCode    INT         = JSON_VALUE(@params, '$.drugCode');
   DECLARE @medCode     VARCHAR(10) = JSON_VALUE(@params, '$.medCode');
   DECLARE @demandTime1 DATETIME    = JSON_VALUE(@params, '$.demandTime1');
   DECLARE @demandTime2 DATETIME    = JSON_VALUE(@params, '$.demandTime2');
   DECLARE @lastMonth   INT         = [fn].[getLastMonth](JSON_VALUE(@params, '$.currentDate'));
   DECLARE @tranStatus  TINYINT     = 10; --申請狀態 => 10: 申請中
   DECLARE @itemType    TINYINT     = 10; --項目類別 => 10: 藥庫
   DECLARE @isComplexIn BIT         = 1;  --是否廠商協助直入 => 1: 直入
  
   SELECT [stockNo]         = a.DemandStock,
          [medCode]         = d.MedCode,
          [drugCode]        = a.DrugCode,     
          [drugName]        = d.GenericName1, 
          [safetyQty]       = b.SafetyQty,     
          [packageQty]      = b.PackageQty,   
          [buyQty]          = a.DemandQty,
          [warnDate]        = c.WarnDate,
          [remark]          = a.Remark,
          [purchaseDays]    = b.PurchaseDays,
          [onWayQty]        = [fn].[getDrugOnWayQty](a.SupplyStock, a.DrugCode),
          [stockTotalQty]   = [fn].[getDrugStockTotalQty]('DrugStock', a.SupplyStock, a.DrugCode),
          [stockMonthQty]   = [fn].[getDrugStockMonthQty]('DrugStock', a.SupplyStock, a.DrugCode, @lastMonth),   
          [unitName]        = [fn].[getUnitBasicName](d.ChargeUnit),    
          [demandStockName] = [fn].[getDepartShortName](a.DemandStock) 
     FROM [dbo].[DrugDemand]    AS a,
          [dbo].[DrugStockMt]   AS b,
          [dbo].[PurchaseBasic] AS c,
          [dbo].[DrugBasic]     AS d
    WHERE a.SupplyStock = @stockNo
      AND a.TranStatus  = @tranStatus
      AND a.DrugCode    = [fn].[numberFilter](@drugCode, a.DrugCode)
      AND a.DemandType  IN (SELECT VALUE FROM OPENJSON(@params, '$.demandTypes'))
      AND a.DemandTime  BETWEEN @demandTime1 AND @demandTime2
      AND b.StockNo     = a.DemandStock
      AND b.DrugCode    = a.DrugCode
      AND b.IsComplexIn = @isComplexIn
      AND b.StartTime  <= a.DemandTime
      AND b.EndTime    >= a.DemandTime
      AND c.ItemCode    = a.DrugCode
      AND c.ItemType    = @itemType
      AND c.Represent   = [fn].[stringFilter](@orgNo, c.Represent)
      AND c.StartTime  <= a.DemandTime
      AND c.EndTime    >= a.DemandTime
      AND d.DrugCode    = a.DrugCode
      AND d.MedCode     LIKE [fn].[stringFilter](@medCode, d.MedCode)   
      AND d.StartTime  <= a.DemandTime
      AND d.EndTime    >= a.DemandTime
    ORDER BY d.MedCode
      FOR JSON PATH     
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P11",
   "orgNo": "",
   "drugCode": 0,
   "medCode": "C%",
   "demandTypes": [40,45],
   "currentDate": "2021-09-01",
   "demandTime1": "2021-06-01 10:21:00",
   "demandTime2": "2021-09-01 10:21:00"
}
';

EXEC [dbo].[getDrugDemandRecords] @params
GO
