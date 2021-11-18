USE [HealthResource]
GO

--- 程序名稱：getDrugDemandDispences
--- 程序說明：取得藥品撥補需求單
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/11/18
CREATE PROCEDURE [dbo].[getDrugDemandDispences](@params NVARCHAR(MAX))
AS BEGIN

   DECLARE @demandStock CHAR(04)  = JSON_VALUE(@params, '$.demandStock');
   DECLARE @supplyStock CHAR(04)  = JSON_VALUE(@params, '$.supplyStock');
   DECLARE @medCode     CHAR(08)  = JSON_VALUE(@params, '$.medCode');
   DECLARE @demandTime1 DATETIME  = [fn].[getDateMinTime](JSON_VALUE(@params, '$.demandDate1'));
   DECLARE @demandTime2 DATETIME  = [fn].[getDateMaxTime](JSON_VALUE(@params, '$.demandDate2'));
   DECLARE @currentTime DATETIME  = GETDATE();

   WITH ScheduleItems AS (
        SELECT [StockNo] = a.StockNo
          FROM [dbo].[DrugScheduleDt] AS a,
               [dbo].[DrugScheduleMt] AS b
         WHERE a.ScheduleNo IN (SELECT VALUE FROM OPENJSON(@params, '$.scheduleNos'))
           AND b.ScheduleNo = a.ScheduleNo
           AND b.StartDate <= @currentTime
           AND b.EndTime   >= @currentTime
         GROUP BY a.StockNo  
   )

   SELECT [demandNo]            = b.DemandNo,
          [demandType]          = b.DemandType,
          [medCode]             = d.MedCode,
          [drugCode]            = b.DrugCode,
          [drugName]            = d.DrugName,
          [genericName2]        = d.GenericName2,
          [brandName1]          = d.BrandName1,
          [tranStatus]          = b.TranStatus,
          [demandQty]           = b.DemandQty,
          [demandStock]         = b.DemandStock,
          [supplyStock]         = b.SupplyStock,
          [demandUser]          = b.DemandUser,
          [demandUnit]          = b.DemandUnit,
          [demandTime]          = b.DemandTime,
          [checkTime]           = b.CheckTime,
          [contactExt]          = b.ContactExt,
          [drugType]            = c.DrugType,
          [totalQty]            = c.TotalQty,
          [packageQty]          = c.PackageQty,
          [isComplexIn]         = c.IsComplexIn, 
          [remark]              = b.Remark,
          [demandUserName]      = [fn].[getEmpName](b.DemandUser),
          [demandStockName]     = [fn].[getDepartShortName](b.DemandStock),
          [supplyStockName]     = [fn].[getDepartShortName](b.SupplyStock),
          [demandUnitName]      = [fn].[getUnitBasicName](b.DemandUnit),
          [supplyQty]           = [fn].[getDrugSupplyQty](b.DemandNo),
          [lotNo]               = [fn].[getDrugBatchLotNo](b.SupplyStock, b.DrugCode),
          [drugBatchInfos]      = JSON_QUERY([fn].[getDrugBatchInfos](b.SupplyStock, b.DrugCode, d.MedCode)),
          [demandTypeName]      = [fn].[getOptionName](b.DemandType, 'DrugDemand', 'DemandType'),
          [tranStatusName]      = [fn].[getOptionName](b.TranStatus, 'DrugDemand', 'TranStatus'),
          [drugTypeName]        = [fn].[getOptionName](c.DrugType, 'DrugBasic','DrugType'),
          [demandStockBuilding] = [fn].[getDepartBuilder](b.DemandStock),
          [storageNo]           = [fn].[getDrugStorageNo](b.SupplyStock, b.DrugCode)
     FROM ScheduleItems       AS a,
          [dbo].[DrugDemand]  AS b,
          [dbo].[DrugStockMt] AS c,
          [dbo].[DrugBasic]   AS d
    WHERE b.DemandStock = a.StockNo
      AND b.DemandTime  BETWEEN @demandTime1 AND @demandTime2
      AND b.DemandType  IN (SELECT VALUE FROM OPENJSON(@params, '$.demandTypes'))
      AND b.TranStatus  IN (SELECT VALUE FROM OPENJSON(@params, '$.tranStatus'))
      AND b.DemandStock = [fn].[stringFilter](@demandStock, b.DemandStock)
      AND b.SupplyStock = [fn].[stringFilter](@supplyStock, b.SupplyStock)
      AND b.StopReason  = 0
      AND b.TranStatus  NOT IN (80,81)
      AND c.DrugCode    = b.DrugCode
      AND c.StockNo     = b.DemandStock
      AND c.IsComplexIn = 0
      AND d.DrugCode    = b.DrugCode
      AND d.MedCode     = [fn].[stringFilter](@medCode, d.MedCode)
      AND d.StartTime  <= b.DemandTime
      AND d.EndTime    >= b.DemandTime
    ORDER BY b.DemandTime DESC, d.MedCode
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
    "demandStock": "1P50",
    "supplyStock": "1P11",
    "medCode": "",
    "demandDate1": "2021-06-16",
    "demandDate2": "2021-09-18",
    "demandTypes": [60],
    "scheduleNos": [25,47,49,50,58,64,69,70,71],
    "tranStatus": [10,18]
}
'

EXEC [dbo].[getDrugDemandDispences] @params
GO
