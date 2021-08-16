USE [HealthResource]
GO
--- 程序名稱：getDrugReviewList
--- 程序說明：取得藥品審核清單
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/06/28
CREATE PROCEDURE [dbo].[getDrugReviewList](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @checkTime1   DATETIME     = [fn].[getDateMinTime](JSON_VALUE(@params,'$.checkDate'));
   DECLARE @checkTime2   DATETIME     = [fn].[getDateMaxTime](JSON_VALUE(@params,'$.checkDate'));
   DECLARE @inStockNo    VARCHAR(04)  = JSON_VALUE(@params, '$.inStockNo');
   DECLARE @checkStatus1 TINYINT      = 30;
   DECLARE @checkStatus2 TINYINT      = 79;

   SELECT [inStockNo]     = a.InStockNo,
          [checkNo]       = a.CheckNo,
          [checkTime]     = a.CheckTime,
          [medCode]       = b.MedCode,
          [drugName]      = b.GenericName1,
          [highAlert]     = [fn].[getDrugHighAlert](b.MedCode,a.CheckTime),
          [drugTrialDate] = [fn].[getDrugTrialDate](a.CheckNo)
     FROM [dbo].[DrugChecking] AS a,
          [dbo].[DrugBasic]    AS b
    WHERE a.InStockNo   LIKE    @inStockNo
      AND a.CheckTime   BETWEEN @checkTime1   AND @checkTime2
      AND a.CheckStatus BETWEEN @checkStatus1 AND @checkStatus2
      AND b.DrugCode    = a.DrugCode   
      AND b.StartTime  <= a.CheckTime
      AND b.EndTime    >= a.CheckTime
    ORDER BY b.HighAlert DESC, a.CheckTime
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(max) =
'
{
    "checkDate": "2021-08-16",
    "inStockNo": "1%"
}
'

EXEC [dbo].[getDrugReviewList] @params
GO