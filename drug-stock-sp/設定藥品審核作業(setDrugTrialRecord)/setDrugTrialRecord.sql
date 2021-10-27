USE [HealthResource]
GO

--- 程序名稱：setDrugTrialRecord
--- 程序說明：設定藥品審核紀錄
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/10/27
CREATE PROCEDURE [dbo].[setDrugTrialRecord](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime    DATETIME       = GETDATE();
   DECLARE @errorSeverity INT;
   DECLARE @errorMessage  NVARCHAR(4000);
   DECLARE @procedureName VARCHAR(30)    = 'setDrugTrialRecord';

   BEGIN TRY
         MERGE INTO [dbo].[DrugTrialRecord] AS t
         USING ( SELECT *
                   FROM OPENJSON(@params)          
                   WITH ( CheckNo    INT           '$.checkNo',
                          TrialDate  DATE          '$.trialDate',
                          IsEffect   BIT           '$.isEffect',
                          IsExterior BIT           '$.isExterior',
                          IsLicense  BIT           '$.isLicense',
                          IsLotNo    BIT           '$.isLotNo',
                          IsCoA      BIT           '$.isCoA',
                          Remark     NVARCHAR(255) '$.remark',
                          SystemUser INT           '$.systemUser',
                          TrialUser  INT           '$.trialUser '
                        )
               ) AS s (CheckNo, TrialDate, IsEffect, IsExterior, IsLicense, IsLotNo, IsCoA, Remark, SystemUser, TrialUser) 
            ON (t.CheckNo = s.CheckNo)    
         WHEN MATCHED THEN 
              UPDATE SET  
                     t.TrialDate  = ISNULL(s.TrialDate, t.TrialDate), 
                     t.IsEffect   = ISNULL(s.IsEffect, t.IsEffect),  
                     t.IsExterior = ISNULL(s.IsExterior, t.IsExterior),
                     t.IsLicense  = ISNULL(s.IsLicense, t.IsLicense),
                     t.IsLotNo    = ISNULL(s.IsLotNo, t.IsLotNo),  
                     t.IsCoA      = ISNULL(s.IsCoA, t.IsCoA),    
                     t.Remark     = ISNULL(s.Remark, t.Remark),     
                     t.TrialUser  = ISNULL(s.TrialUser, t.TrialUser),
                     t.SystemUser = s.SystemUser, 
                     t.SystemTime = @systemTime
         
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
                      TrialUser,
                      SystemUser, 
                      SystemTime
                     )
              VALUES (
                      s.CheckNo,  
                      s.TrialDate, 
                      s.IsEffect,  
                      s.IsExterior,
                      s.IsLicense,  
                      s.IsLotNo,   
                      s.IsCoA,       
                      s.Remark,    
                      s.TrialUser,
                      s.SystemUser,   
                      @systemTime
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
   "trialDate": "2021-10-27",
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