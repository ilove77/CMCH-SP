USE [HealthResource]
GO

--- 程序名稱：getDrugDemandItems
--- 程序說明：取得藥局預估撥補清單
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/27
CREATE PROCEDURE [dbo].[getDrugDemandItems](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo        CHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @outStockTime1  DATETIME = JSON_VALUE(@params, '$.outStockTime1');
   DECLARE @outStockTime2  DATETIME = JSON_VALUE(@params, '$.outStockTime2');
   DECLARE @tranType       TINYINT  = 25; --交易類別 => 25: 消耗
   DECLARE @currentTime    DATETIME = GETDATE();

    WITH DrugStockItems AS (
        SELECT [StockNo]       = a.StockNo,
               [DrugCode]      = a.DrugCode,
               [SafetyQty]     = a.SafetyQty,
               [MaxQty]        = a.MaxQty,
               [TotalQty]      = a.TotalQty,
               [PackageQty]    = a.PackageQty,
               [UnarrivalQty]  = [fn].[getDrugOnWayQty](a.StockNo, a.DrugCode) + a.TotalQty,
               [TranQty]       = [fn].[getDrugTranQty](a.StockNo, a.DrugCode, @tranType, @outStockTime1, @outStockTime2),
               [DeliverQty]    = [fn].[getDrugDeliverQty](a.MaxQty, a.TotalQty, a.PackageQty),
               [StockUnitName] = [fn].[getUnitName](a.StockUnit)
          FROM [dbo].[DrugStockMt] AS a
         WHERE a.StockNo    = @stockNo
           AND a.TotalQty   < a.SafetyQty
           AND a.StartTime <= @currentTime
           AND a.EndTime   >= @currentTime
   )
   SELECT [stockNo]        = a.StockNo,
          [medCode]        = b.MedCode,
          [drugCode]       = a.DrugCode,
          [drugName]       = b.DrugName,
          [safetyQty]      = a.SafetyQty,
          [maxQty]         = a.MaxQty,
          [stockQty]       = a.TotalQty,
          [packageQty]     = a.PackageQty,
          [unarrivalQty]   = a.UnarrivalQty,
          [tranQty]        = a.TranQty,
          [deliverQty]     = a.DeliverQty,
          [stockUnitName]  = a.StockUnitName,
          [chargeUnitName] = [fn].[getUnitName](b.ChargeUnit)
     FROM [DrugStockItems]  AS a,
          [dbo].[DrugBasic] AS b
    WHERE a.TranQty     > 0
      AND a.DeliverQty  > 0
      AND a.SafetyQty  >= a.UnarrivalQty
      AND b.DrugCode    = a.DrugCode
      AND b.StartTime  <= @currentTime
      AND b.EndTime    >= @currentTime
      FOR JSON PATH
END
GO
      
DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P12",
   "outStockTime1": "2021-08-24 00:00:00",
   "outStockTime2": "2021-08-27 23:59:59"
}
';

EXEC [dbo].[getDrugDemandItems] @params
GO