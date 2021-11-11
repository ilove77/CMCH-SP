USE [HealthResource]
GO

--- 程序名稱：getDrugOutStockInfos
--- 程序說明：取得藥品出庫列印資料
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/11/11
CREATE PROCEDURE [dbo].[getDrugOutStockInfos](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @demandStock CHAR(04)  = JSON_VALUE(@params, '$.demandStock');
   DECLARE @supplyStock CHAR(04)  = JSON_VALUE(@params, '$.supplyStock');
   DECLARE @medCode     CHAR(08)  = JSON_VALUE(@params, '$.medCode');
   DECLARE @demandTime1 DATETIME  = [fn].[getDateMinTime](JSON_VALUE(@params, '$.demandDate1'));
   DECLARE @demandTime2 DATETIME  = [fn].[getDateMaxTime](JSON_VALUE(@params, '$.demandDate2'));
   DECLARE @currentTime DATETIME  = GETDATE();

   SELECT [demandNo]            = a.DemandNo,
          [demandType]          = a.DemandType,
          [medCode]             = c.MedCode,
          [drugCode]            = a.DrugCode,
          [drugName]            = c.DrugName,
          [genericName2]        = c.GenericName2,
          [brandName1]          = c.BrandName1,
          [tranStatus]          = a.TranStatus,
          [demandQty]           = a.DemandQty,
          [demandStock]         = a.DemandStock,
          [supplyStock]         = a.SupplyStock,
          [demandUser]          = a.DemandUser,
          [demandUnit]          = a.DemandUnit,
          [demandTime]          = a.DemandTime,
          [checkTime]           = a.CheckTime,
          [contactExt]          = a.ContactExt,
          [drugType]            = b.DrugType,
          [isComplexIn]         = b.IsComplexIn, 
          [remark]              = a.Remark,
          [totalQty]            = [fn].[getDrugTotalQty](a.SupplyStock, a.DrugCode),
          [demandUserName]      = [fn].[getEmpName](a.DemandUser),
          [demandStockName]     = [fn].[getDepartShortName](a.DemandStock),
          [supplyStockName]     = [fn].[getDepartShortName](a.SupplyStock),
          [unitName]            = [fn].[getUnitBasicName](a.DemandUnit),
          [supplyQty]           = [fn].[getDrugSupplyQty](a.DemandNo),
          [lotNo]               = [fn].[getDrugBatchLotNo](a.SupplyStock, b.DrugCode),
          [drugBatchInfos]      = JSON_QUERY([fn].[getDrugBatchInfos](a.SupplyStock, b.DrugCode, c.MedCode)),
          [demandTypeName]      = [fn].[getOptionName](a.DemandType, 'DrugDemand', 'DemandType'),
          [tranStatusName]      = [fn].[getOptionName](a.TranStatus, 'DrugDemand', 'TranStatus'),
          [drugTypeName]        = [fn].[getOptionName](b.DrugType, 'DrugBasic','DrugType'),
          [demandStockBuliding] = [fn].[getDepartBuilder](a.DemandStock),
          [storageNo]           = [fn].[getDrugStorageNo](a.SupplyStock, a.DrugCode)
     FROM [dbo].[DrugDemand]  AS a,
          [dbo].[DrugStockMt] AS b,
          [dbo].[DrugBasic]   AS c
    WHERE a.DemandTime  BETWEEN @demandTime1 AND @demandTime2
      AND a.DemandType  IN (SELECT VALUE FROM OPENJSON(@params, '$.demandTypes'))
      AND a.TranStatus  IN (SELECT VALUE FROM OPENJSON(@params, '$.tranStatus'))
      AND a.DemandStock = [fn].[stringFilter](@demandStock, a.DemandStock)
      AND a.SupplyStock = [fn].[stringFilter](@supplyStock, a.SupplyStock)
      AND a.StopReason  = 0
      AND a.TranStatus  NOT IN (80,81)
      AND b.DrugCode    = a.DrugCode
      AND b.StockNo     = a.DemandStock
      AND b.DrugType    IN (SELECT VALUE FROM OPENJSON(@params, '$.drugTypes'))
      AND b.IsComplexIn = 0
      AND c.DrugCode    = a.DrugCode
      AND c.MedCode     = [fn].[stringFilter](@medCode, c.MedCode)
      AND c.StartTime  <= a.DemandTime
      AND c.EndTime    >= a.DemandTime
    ORDER BY a.DemandNo
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
    "demandStock": "1N9A",
    "supplyStock": "1P11",
    "medCode": "LH2O2-3",
    "demandDate1": "2021-06-16",
    "demandDate2": "2021-10-29",
    "demandTypes": [40,45],
    "drugTypes": [110,111,112],
    "tranStatus": [10,18]
}
'

EXEC [dbo].[getDrugOutStockInfos] @params
GO