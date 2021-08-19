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
   DECLARE @demandType  TINYINT  = 60; --需求類別 => 60: 自動撥補
   DECLARE @currentTime DATETIME = GETDATE();

   SELECT [stockNo]        = a.StockNo,   
          [medCode]        = b.MedCode,             
          [drugCode]       = b.DrugCode,
          [drugName]       = b.DrugName,
          [safetyQty]      = a.SafetyQty, 
          [maxQty]         = a.MaxQty, 
          [stockQty]       = a.totalQty,
          [packageQty]     = a.PackageQty,
          [chargeUnitName] = [fn].[getUnitName](b.ChargeUnit),
          [stockUnitName]  = [fn].[getUnitName](a.StockUnit),
          [unarrivalQty]   = [fn].[getDrugOnWayQty](a.StockNo, a.DrugCode),
          [consumeQty]     = [fn].[getDrugConsumeDemandQty](a.StockNo, a.DrugCode, @demandType) 
     FROM [dbo].[DrugStockMt] AS a,
          [dbo].[DrugBasic]   AS b
    WHERE a.StockNo    = @stockNo
      AND a.TotalQty   < a.SafetyQty
      AND a.SafetyQty >= [fn].[getDrugOnWayQty](a.StockNo, a.DrugCode) + a.TotalQty
      AND a.StartTime <= @currentTime
      AND a.EndTime   >= @currentTime
      AND b.DrugCode   = a.DrugCode
      AND b.StartTime <= @currentTime
      AND b.EndTime   >= @currentTime
      AND [fn].[getDrugConsumeDemandQty](a.StockNo, a.DrugCode, 60)   <> 0  
      AND [fn].[getDrugDeliverQty](a.MaxQty, a.TotalQty, a.PackageQty) > 0
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P1A"
}
';

EXEC [dbo].[getDrugDemandItems] @params
GO