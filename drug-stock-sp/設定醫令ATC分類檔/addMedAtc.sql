USE [HealthCare]
GO

--- 程序名稱：addMedAtc
--- 程序說明：設定醫令ATC分類檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/16
CREATE PROCEDURE [dbo].[addMedAtc](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime     DATETIME         = GETDATE();
   DECLARE @errorSeverity  INT;
   DECLARE @errorMessage   NVARCHAR(4000);
   DECLARE @procedureName  VARCHAR(50)      = 'addMedAtc';

   BEGIN TRY
         INSERT INTO [dbo].[MedAtc] (
                MedCode,
                SeqNo,
                AtcCode,
                SystemUser,
                SystemTime)
         SELECT b.MedCode    AS [medCode],
                b.SeqNo      AS [seqNo],
                b.AtcCode    AS [atcCode],
                b.SystemUser AS [systemUser],
                @systemTime  AS [systemTime]
           FROM OPENJSON(@params)
           WITH (MedCode    CHAR(08) '$.medCode',
                 SeqNo      TINYINT  '$.seqNo',
                 AtcCode    CHAR(10) '$.atcCode',
                 SystemUser INT      '$.systemUser'
                ) AS b
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
   "seqNo": 2,
   "atcCode": "test1234",
   "medCode": "XYZ69089",
   "systemUser": 37029
}
';

EXEC [dbo].[addMedAtc] @params
GO