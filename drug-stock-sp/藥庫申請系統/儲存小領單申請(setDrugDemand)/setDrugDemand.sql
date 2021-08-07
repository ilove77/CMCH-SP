USE [HealthResource]
GO

--- 程序名稱：setDrugDemand
--- 程序說明：設定藥品需求單
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/01
CREATE PROCEDURE [dbo].[setDrugDemand](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime    DATETIME       = GETDATE();
   DECLARE @procedureName VARCHAR(30)    = 'setDrugDemand';
   DECLARE @errorSeverity INT;
   DECLARE @demandNo      INT            = COALESCE(JSON_VALUE(@params, '$.demandNo'), 0);
   DECLARE @errorMessage  NVARCHAR(4000);
   
   BEGIN TRY
         MERGE INTO [dbo].[DrugDemand] AS t
         USING ( SELECT *
                   FROM OPENJSON(@params)
                   WITH ( 
                          DemandNo    INT           '$.demandNo',   
                          DrugCode    INT           '$.drugCode',
                          DemandType  TINYINT       '$.demandType',   
                          DemandStock CHAR(04)      '$.demandStock',
                          DemandUser  INT           '$.systemUser', 
                          DemandTime  DATETIME      '$.demandTime', 
                          DemandQty   INT           '$.demandQty', 
                          DemandUnit  SMALLINT      '$.demandUnit', 
                          SupplyStock CHAR(04)      '$.supplyStock',
                          SupplyQty   INT           '$.supplyQty', 
                          TranStatus  TINYINT       '$.tranStatus', 
                          StopReason  TINYINT       '$.stopReason', 
                          ContactExt  SMALLINT      '$.contactExt', 
                          CheckTime   DATETIME      '$.checkTime', 
                          SystemUser  INT           '$.systemUser', 
                          PurchaseNo  INT           '$.purchaseNo',
                          AuditUser   INT           '$.auditUser', 
                          AuditTime   DATETIME      '$.auditTime', 
                          Remark      NVARCHAR(500) '$.remark'
                        )
               ) AS s   (
                          DemandNo, 
                          DrugCode, 
                          DemandType, 
                          DemandStock, 
                          DemandUser, 
                          DemandTime, 
                          DemandQty, 
                          DemandUnit, 
                          SupplyStock, 
                          SupplyQty, 
                          TranStatus, 
                          StopReason, 
                          ContactExt, 
                          CheckTime,  
                          SystemUser, 
                          PurchaseNo, 
                          AuditUser, 
                          AuditTime, 
                          Remark
                        )
            ON (t.DemandNo = s.DemandNo)    
         WHEN MATCHED THEN	  
              UPDATE SET  
                     t.DrugCode    =  ISNULL(s.DrugCode, t.DrugCode),     
                     t.DemandType  =  ISNULL(s.DemandType, t.DemandType), 
                     t.DemandStock =  ISNULL(s.DemandStock, t.DemandStock),      
                     t.DemandUser  =  ISNULL(s.DemandUser, t.DemandUser), 
                     t.DemandTime  =  ISNULL(s.DemandTime, t.DemandTime),   
                     t.DemandQty   =  ISNULL(s.DemandQty, t.DemandQty),  
                     t.DemandUnit  =  ISNULL(s.DemandUnit, t.DemandUnit), 
                     t.SupplyStock =  ISNULL(s.SupplyStock, t.SupplyStock),
                     t.SupplyQty   =  ISNULL(s.SupplyQty, t.SupplyQty),  
                     t.TranStatus  =  ISNULL(s.TranStatus, t.TranStatus), 
                     t.StopReason  =  ISNULL(s.StopReason, t.StopReason), 
                     t.ContactExt  =  ISNULL(s.ContactExt, t.ContactExt), 
                     t.CheckTime   =  ISNULL(s.CheckTime, t.CheckTime),  
                     t.PurchaseNo  =  ISNULL(s.PurchaseNo, t.PurchaseNo),
                     t.AuditUser   =  ISNULL(s.AuditUser, t.AuditUser),
                     t.AuditTime   =  ISNULL(s.AuditTime, t.AuditTime),
                     t.Remark      =  ISNULL(s.Remark, t.Remark),
                     t.SystemUser  =  s.SystemUser,
                     t.SystemTime  =  @systemTime
         WHEN NOT MATCHED THEN
              INSERT (
                       DrugCode, 
                       DemandType, 
                       DemandStock, 
                       DemandUser, 
                       DemandTime, 
                       DemandQty, 
                       DemandUnit, 
                       SupplyStock, 
                       SupplyQty, 
                       TranStatus, 
                       StopReason,
                       ContactExt, 
                       CheckTime, 
                       PurchaseNo, 
                       AuditUser, 
                       AuditTime, 
                       Remark, 
                       SystemUser,
                       SystemTime
                     )
              VALUES (
                       s.DrugCode, 
                       s.DemandType,
                       s.DemandStock, 
                       s.DemandUser, 
                       s.DemandTime,
                       s.DemandQty, 
                       s.DemandUnit, 
                       s.SupplyStock, 
                       s.SupplyQty, 
                       s.TranStatus, 
                       s.StopReason,
                       s.ContactExt, 
                       s.CheckTime,               
                       s.PurchaseNo, 
                       s.AuditUser, 
                       s.AuditTime, 
                       s.Remark,
                       s.SystemUser,  
                       @systemTime
                     );
         IF (@demandNo = 0) SET @demandNo = SCOPE_IDENTITY ();

   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;

         THROW;
   END CATCH
   RETURN @demandNo
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
  "checkTime": "2021-07-28T18:14:06",
  "contactExt": 2615,
  "demandNo": 77899,
  "demandQty": 1,
  "demandStock": "1P11",
  "demandStockName": "西藥管理組",
  "demandTime": "2021-07-26T15:20:31",
  "demandType": 50,
  "demandTypeName": "退庫",
  "demandUnit": 60,
  "demandUnitName": "Amp",
  "demandUser": 36813,
  "drugCode": 3678,
  "drugName": "Antivenin  t1",
  "drugType": 10,
  "medCode": "IATTTEST",
  "stopReason": 5,
  "supplyQty": 1,
  "supplyStock": "1A8D",
  "supplyStockName": "行政資訊組",
  "systemUser": 36813,
  "tranStatus": 80,
  "tranStatusName": "申請中"
}
';

EXEC [dbo].[setDrugDemand] @params
GO
