USE [HealthResource]
GO

--- 程序名稱：setDrugTrialRecord
--- 程序說明：設定藥品審核紀錄
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/02

CREATE PROCEDURE [dbo].[setDrugTrialRecord](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime    DATETIME       = GETDATE();
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'setDrugTrialRecord';

   BEGIN TRY
         MERGE INTO [dbo].[DrugTrialRecord] AS a
         USING ( SELECT *
                   FROM OPENJSON(@params)          
                   WITH ( CheckNo    INT           '$.checkNo',
                          IsEffect   BIT           '$.isEffect',
                          IsExterior BIT           '$.isExterior',
                          IsLicense  BIT           '$.isLicense',
                          IsLotNo    BIT           '$.isLotNo',
                          IsCoA      BIT           '$.isCoA',
                          Remark     NVARCHAR(255) '$.remark',
                          SystemUser INT           '$.systemUser',
                          TrialUser  INT           '$.trialUser '
                        )
               ) AS b (CheckNo, IsEffect, IsExterior, IsLicense, IsLotNo, IsCoA, Remark, SystemUser, TrialUser) 
            ON (a.CheckNo = b.CheckNo)    
         WHEN MATCHED THEN 
              UPDATE SET  
                     a.TrialDate  = @systemTime, 
                     a.IsEffect   = b.IsEffect,  
                     a.IsExterior = b.IsExterior,
                     a.IsLicense  = b.IsLicense, 
                     a.IsLotNo    = b.IsLotNo,   
                     a.IsCoA      = b.IsCoA,     
                     a.Remark     = b.Remark,     
                     a.SystemUser = b.SystemUser,
                     a.TrialUser  = b.TrialUser, 
                     a.SystemTime = @systemTime
         
         WHEN NOT MATCHED THEN
              INSERT (
                      CheckNo,   
                      TrialDate, 
                      IsEffect,   
                      IsExterior,
                      IsLicense,  
                      IsLotNo,    
                      IsCoA,     
                      Remark,     
                      SystemUser,
                      TrialUser, 
                      SystemTime
                     )
              VALUES (
                      b.CheckNo,  
                      @systemTime, 
                      b.IsEffect,  
                      b.IsExterior,
                      b.IsLicense,  
                      b.IsLotNo,   
                      b.IsCoA,       
                      b.Remark,    
                      b.SystemUser,
                      b.TrialUser,   
                      @SystemTime
                     );

   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;
         THROW;
   END CATCH
END
GO

DECLARE @params NVARCHAR(MAX) = 
'
{
   "checkNo": 3679,
   "isEffect": 0,
   "isExterior": 1,
   "isLicense": 1,
   "isLotNo": 1,
   "isCoA": 1,
   "remark": "",
   "systemUser": 36078,
   "trialUser": 36078
} 
';

EXEC [dbo].[setDrugTrialRecord] @params
GO