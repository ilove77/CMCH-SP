USE [HealthResource]
GO

--- 程序名稱：getDrugDemand
--- 程序說明：取得藥庫需求單
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/04
CREATE PROCEDURE [dbo].[getDrugDemand](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @demandNo   INT = JSON_VALUE(@params, '$.demandNo');
   DECLARE @purchaseNo INT = JSON_VALUE(@params, '$.purchaseNo');
   
   SELECT [demandNo]    = a.DemandNo,
          [purchaseNo]  = a.PurchaseNo,
          [drugCode]    = a.DrugCode,
          [demandType]  = a.DemandType,
          [demandStock] = a.DemandStock,
          [demandUser]  = a.DemandUser,
          [demandTime]  = a.DemandTime,
          [demandQty]   = a.DemandQty,
          [demandUnit]  = a.DemandUnit,
          [supplyStock] = a.SupplyStock,
          [supplyQty]   = a.SupplyQty,
          [tranStatus]  = a.TranStatus,
          [stopReason]  = a.StopReason,
          [contactExt]  = a.ContactExt,
          [checkTime]   = a.CheckTime,
          [systemUser]  = a.SystemUser,
          [systemTime]  = a.SystemTime,
          [auditUser]   = a.AuditUser,
          [auditTime]   = a.AuditTime,
          [remark]      = a.Remark
     FROM [dbo].[DrugDemand] AS a
    WHERE a.DemandNo   = [fn].[numberFilter](@demandNo, a.DemandNo)
      AND a.PurchaseNo = [fn].[numberFilter](@purchaseNo, a.PurchaseNo)
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "demandNo": 10540,
   "purchaseNo": 0
}
';

EXEC [dbo].[getDrugDemand] @params
GO