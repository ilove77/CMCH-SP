
USE [healthResource]
GO

--- 程序名稱: setRESTfulLog
--- 程序說明: 新增RESTfulLog表格
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/10/04
CREATE PROCEDURE [dbo].[setRESTfulLog] (@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @requestUrl      NVARCHAR(255)  = JSON_VALUE(@params,'$.requestUrl');
   DECLARE @systemTime      VARCHAR(23)    = CONVERT(varchar, GETDATE(), 121);
   DECLARE @procedureName   VARCHAR(20)    = 'setRESTfulLog';
   DECLARE @errorSeverity   INT;
   DECLARE @errorMessage    NVARCHAR(4000);

   SET @params = JSON_MODIFY(@params, '$.systemTime', @systemTime);

   BEGIN TRY
         MERGE INTO [dbo].[RESTfulLog] AS t
         USING ( SELECT *
                   FROM OPENJSON(@params)
                   WITH (
                        RequestUrl NVARCHAR(255)  '$.requestUrl',
                        Params     NVARCHAR(MAX)  '$.params',
                        SystemUser INT            '$.systemUser',
                        SystemTime DATETIME       '$.systemTime'
                        )
               ) AS s (
                      RequestUrl,
                      Params,
                      SystemUser,
                      SystemTime
                      )
            ON (t.RequestUrl = @requestUrl AND t.SystemTime = @systemTime)
          WHEN MATCHED THEN
               UPDATE SET
                      RequestUrl  = ISNULL(s.RequestUrl , t.RequestUrl),
                      Params      = ISNULL(s.Params , t.Params),
                      SystemUser  = ISNULL(s.SystemUser , t.SystemUser),
                      SystemTime  = ISNULL(s.SystemTime , t.SystemTime)
          WHEN NOT MATCHED THEN
               INSERT (
                      RequestUrl,
                      Params,
                      SystemUser,
                      SystemTime
                      )
               VALUES (
                      s.RequestUrl,
                      s.Params,
                      s.SystemUser,
                      s.SystemTime
                      );
         
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;
         THROW;
   END CATCH
   
END

GO
-- EXEC PROCEDURE
DECLARE @params NVARCHAR(MAX) =
'
{
 "requestUrl" : "[Setting]DrugStockBulidingList1C",
 "params"     : "[{\"BranchCode\":1,\"Building\":\"C\",\"StockNos\":[{\"DepartNo\":\"1144\",\"DepartName\":\"立夫血析室\"}]}]",
 "systemUser" : 999999,
 "systemTime" : "2021-10-04 14:37:42.000"
}
'
EXEC [dbo].[setRESTfulLog] @params
GO