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

   WITH DrugStock AS (
        SELECT [StockNo]      = a.StockNo,
               [DrugCode]     = a.DrugCode,   
               [SafetyQty]    = a.SafetyQty,
               [UnarrivalQty] = [fn].[getDrugOnWayQty](a.StockNo, a.DrugCode) + a.TotalQty,
               [ConsumeQty]   = [fn].[getDrugConsumeDemandQty](a.StockNo, a.DrugCode, @demandType),
               [DeliverQty]   = [fn].[getDrugDeliverQty](a.MaxQty, a.TotalQty, a.PackageQty) 
          FROM [dbo].[DrugStockMt] AS a
         WHERE a.StockNo    = @stockNo
           AND a.StartTime <= @currentTime
           AND a.EndTime   >= @currentTime       
   )
   SELECT [stockNo]        = a.StockNo,   
          [medCode]        = c.MedCode,             
          [drugCode]       = a.DrugCode,
          [drugName]       = c.DrugName,
          [safetyQty]      = a.SafetyQty, 
          [maxQty]         = b.MaxQty, 
          [stockQty]       = b.totalQty,
          [packageQty]     = b.PackageQty,
          [consumeQty]     = a.ConsumeQty,
          [deliverQty]     = a.DeliverQty,
          [chargeUnitName] = [fn].[getUnitName](c.ChargeUnit),
          [stockUnitName]  = [fn].[getUnitName](b.StockUnit)
     FROM [DrugStock]         AS a,
          [dbo].[DrugStockMt] AS b,
          [dbo].[DrugBasic]   AS c
    WHERE a.ConsumeQty  < 0
      AND a.DeliverQty  > 0
      AND b.StockNo     = a.StockNo
      AND b.DrugCode    = a.DrugCode
      AND b.SafetyQty  >= a.UnarrivalQty 
      AND b.TotalQty    < a.SafetyQty  
      AND b.StartTime  <= @currentTime
      AND b.EndTime    >= @currentTime
      AND c.DrugCode    = a.DrugCode
      AND c.StartTime  <= @currentTime
      AND c.EndTime    >= @currentTime
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