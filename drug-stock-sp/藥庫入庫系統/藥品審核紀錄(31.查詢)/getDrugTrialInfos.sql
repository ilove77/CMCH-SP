USE [HealthResource]
GO
--- 程序名稱：getDrugTrialInfos
--- 程序說明：取得藥品查核資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/01

CREATE PROCEDURE [dbo].[getDrugTrialInfos](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @trialDate1 DATE        = JSON_VALUE(@params, '$.trialDate1');
   DECLARE @trialDate2 DATE        = JSON_VALUE(@params, '$.trialDate2');
   DECLARE @stockNo    VARCHAR(04) = JSON_VALUE(@params, '$.stockNo');
   DECLARE @medCode    CHAR(08)    = JSON_VALUE(@params, '$.medCode');

   SELECT d.MedCode      AS [medCode],
          d.GenericName1 AS [drugName],
          d.BrandName1   AS [brandName],
          a.TrialDate    AS [trialDate],
          b.BatchNo      AS [batchNo],
          c.ExpDate      AS [expDate],
          a.IsLicense    AS [isLicense],
          a.IsExterior   AS [isExterior],
          a.IsLotNo      AS [isLotNo],
          a.IsEffect     AS [isEffect],
          a.IsCoA        AS [isCoA],
          a.Remark       AS [remark],
          [fn].[getEmpName](a.TrialUser) AS [trialUser]
     FROM [dbo].[DrugTrialRecord] AS a,
          [dbo].[DrugChecking]    AS b,
          [dbo].[DrugBatch]       AS c,
          [dbo].[DrugBasic]       AS d
    WHERE a.TrialDate  BETWEEN @trialDate1 AND @trialDate2
      AND b.CheckNo    = a.CheckNo
      AND b.InStockNo  LIKE @stockNo
      AND c.BatchNo    = b.BatchNo
      AND d.DrugCode   = b.DrugCode
      AND d.StartTime <= a.TrialDate
      AND d.EndTime   >= a.TrialDate
      AND d.MedCode    = [fn].stringFilter(@medCode, d.MedCode)
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(MAX) = 
'
{
    "trialDate1": "2021-06-21",
    "trialDate2": "2021-07-01",
    "stockNo": "1%",
    "medCode": ""
}
';

EXEC [dbo].[getDrugTrialInfos] @params
GO