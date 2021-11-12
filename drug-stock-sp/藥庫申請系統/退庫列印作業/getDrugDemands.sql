USE [HealthResource]
GO

--- 程序名稱：getDrugDemands
--- 程序說明：取得藥品需求單資料
--- 編訂人員：廖翌辰、蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/11/12
CREATE PROCEDURE [dbo].[getDrugDemands] (@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @demandStock CHAR(04)      = JSON_VALUE(@params,'$.demandStock');
   DECLARE @supplyStock CHAR(04)      = JSON_VALUE(@params,'$.supplyStock');
   DECLARE @medCode     CHAR(08)      = JSON_VALUE(@params,'$.medCode');
   DECLARE @drugName    NVARCHAR(100) = JSON_VALUE(@params,'$.drugName');
   DECLARE @tranStatus  TINYINT       = JSON_VALUE(@params,'$.tranStatus');
   DECLARE @demandTime1 DATETIME      = [fn].[getDateMinTime](JSON_VALUE(@params,'$.demandDate1'));
   DECLARE @demandTime2 DATETIME      = [fn].[getDateMaxTime](JSON_VALUE(@params,'$.demandDate2'));
   DECLARE @demandUser  INT           = JSON_VALUE(@params,'$.demandUser');

   SELECT [demandTime]      = a.DemandTime,
          [demandNo]        = a.DemandNo,
          [purchaseNo]      = a.PurchaseNo,
          [demandType]      = a.DemandType,
          [medCode]         = c.MedCode,
          [drugCode]        = a.DrugCode,
          [drugName]        = c.DrugName,
          [tranStatus]      = a.TranStatus,
          [demandQty]       = a.DemandQty,
          [demandStock]     = a.DemandStock,
          [supplyStock]     = a.SupplyStock,
          [demandUser]      = a.DemandUser,
          [demandUnit]      = a.DemandUnit,
          [checkTime]       = a.CheckTime,
          [contactExt]      = a.ContactExt,
          [drugType]        = b.DrugType,
          [totalQty]        = b.TotalQty,
          [remark]          = a.Remark,
          [demandUserName]  = [fn].[getEmpName](a.DemandUser),
          [demandStockName] = [fn].[getDepartShortName](a.DemandStock),
          [supplyStockName] = [fn].[getDepartShortName](a.SupplyStock),
          [demandUnitName]  = [fn].[getUnitBasicName](a.DemandUnit),
          [supplyQty]       = [fn].[getDrugSupplyQty](a.DemandNo),
          [lotNo]           = [fn].[getDrugBatchLotNo](a.SupplyStock, a.DrugCode),
          [drugBatchInfos]  = JSON_QUERY([fn].[getDrugBatchInfos](a.SupplyStock, a.DrugCode, c.MedCode)),
          [demandTypeName]  = [fn].[getOptionName](a.DemandType, 'DrugDemand', 'DemandType'),
          [tranStatusName]  = [fn].[getOptionName](a.TranStatus, 'DrugDemand', 'TranStatus'),
          [drugTypeName]    = [fn].[getOptionName](b.DrugType, 'DrugBasic','DrugType'),
          [demandStockBuilding] = [fn].[getDepartBuilder](a.DemandStock),
          [storageNo]           = [fn].[getDrugStorageNo](a.SupplyStock, a.DrugCode)
     FROM [dbo].[DrugDemand]  AS a,
          [dbo].[DrugStockMt] AS b,
          [dbo].[DrugBasic]   AS c
    WHERE a.DemandTime  BETWEEN @demandTime1 AND @demandTime2
      AND a.DemandType  IN (SELECT VALUE FROM OPENJSON(@params, '$.demandTypes'))
      AND a.TranStatus  = [fn].[numberFilter](@tranStatus, a.TranStatus)
      AND a.DemandStock = [fn].[stringFilter](@demandStock, a.DemandStock)
      AND a.SupplyStock = [fn].[stringFilter](@supplyStock, a.SupplyStock)
      AND a.DemandUser  = [fn].[numberFilter](@demandUser, a.DemandUser)
      AND b.DrugCode    = a.DrugCode
      AND b.StockNo     = a.SupplyStock
      AND c.DrugCode    = a.DrugCode
      AND c.MedCode     = [fn].[stringFilter](@medCode, c.MedCode)
      AND c.DrugName    = [fn].[stringFilter](@drugName, c.DrugName)
      AND c.StartTime  <= a.demandTime
      AND c.EndTime    >= a.demandTime
    ORDER BY a.DemandTime DESC, c.MedCode
      FOR JSON PATH
END


GO
--- EXEC PROCEDURE
DECLARE @params NVARCHAR(MAX) =
'
{
    "demandStock": "",
    "supplyStock": "",
    "medCode": "",
    "drugName": "",
    "demandDate1": "2021-01-01",
    "demandDate2": "2999-12-31",
    "demandTypes": [45],
    "demandUser": 21599,
    "tranStatus": 18
}
'

EXEC [dbo].[getDrugDemands] @params
GO