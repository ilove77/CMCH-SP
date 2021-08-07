USE [HealthResource]
GO

--- 程序名稱：getDrugDemandRecords
--- 程序說明：取得藥庫需求資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/30
CREATE PROCEDURE [dbo].[getDrugDemandRecords](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo            CHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @orgNo              CHAR(10) = JSON_VALUE(@params, '$.orgNo');
   DECLARE @medCode            CHAR(08) = JSON_VALUE(@params, '$.medCode');
   DECLARE @isComplexIn        BIT      = JSON_VALUE(@params, '$.isComplexIn');
   DECLARE @lastMonthStartTime DATETIME = JSON_VALUE(@params, '$.lastMonthStartTime');
   DECLARE @lastMonthEndTime   DATETIME = JSON_VALUE(@params, '$.lastMonthEndTime');
   DECLARE @tranStatus         TINYINT  = 10;
   DECLARE @itemType           TINYINT  = 10; 
  
    SELECT [medCode]               = c.MedCode,     
           [genericName]           = c.GenericName1, 
           [totalQty]              = b.TotalQty,
           [safetyQty]             = b.SafetyQty,     
           [packageQty]            = b.PackageQty,   
           [buyQty]                = b.PurchaseQty,  
           [demandQty]             = a.DemandQty, 
           [onWayQty]              = [fn].[getDrugOnWayQty](b.StockNo, c.DrugCode),   
           [unitName]              = [fn].[getUnitBasicName](c.ChargeUnit),           
           [demandStockName]       = [fn].[getDepartShortName](a.DemandStock), 
           [hospitalQty]           = [fn].[getDrugStockTotalQty]('DrugStock', b.StockNo, c.DrugCode), 
           [totalInStockGrantQty]  = [fn].[getDrugBranchInStockGrantQty]('DrugStock', b.stockNo, c.drugCode, @lastMonthStartTime, @lastMonthEndTime),  
           [totalOutStockGrantQty] = [fn].[getDrugBranchOutStockGrantQty]('DrugStock', b.stockNo, c.drugCode, @lastMonthStartTime, @lastMonthEndTime) 
      FROM DrugDemand    AS a,
           DrugStockMt   AS b,
           DrugBasic     AS c,
           PurchaseBasic AS d
     WHERE a.SupplyStock = @stockNo
       AND a.TranStatus  = @tranStatus
       AND a.DemandType  IN (SELECT VALUE FROM OPENJSON(@params, '$.demandTypes'))
       AND b.StockNo     = a.DemandStock
       AND b.DrugCode    = a.DrugCode 
       AND b.IsComplexIn = @isComplexIn
       AND b.StartTime  <= a.CheckTime
       AND b.EndTime    >= a.CheckTime
       AND c.DrugCode    = a.DrugCode
       AND c.StartTime  <= a.CheckTime
       AND c.EndTime    >= a.CheckTime
       AND c.MedCode     = [fn].[stringFilter](@medCode, c.MedCode)
       AND d.ItemCode    = a.DrugCode
       AND d.ItemType    = @itemType
       AND d.Represent   = [fn].[stringFilter](@orgNo, d.Represent)
       AND d.StartTime  <= a.CheckTime
       AND d.EndTime    >= a.CheckTime
     ORDER BY c.MedCode
       FOR JSON PATH     
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "stockNo": "1P11",
   "orgNo": "",
   "medCode": "",
   "demandTypes": [40,45],
   "isComplexIn": 1,
   "lastMonthStartTime": "2021-07-01 00:00:00",
   "lastMonthEndTime": "2021-07-31 00:00:00"
}
';

EXEC [dbo].[getDrugDemandRecords] @params
GO