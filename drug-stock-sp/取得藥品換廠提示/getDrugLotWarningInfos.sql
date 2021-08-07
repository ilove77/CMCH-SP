USE [HealthResource]
GO

CREATE PROCEDURE [dbo].[getDrugLotWaring](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @medCode      CHAR(08) = JSON_VALUE(@params, '$.medCode')
   DECLARE @currentTime  DATETIME = GETDATE()

   SELECT a.StockNo    AS [stockNo],
          b.MedCode    AS [medCode],
          a.LotNo      AS [lotNo],
          b.DrugName   AS [drugName],
          a.StartDate  AS [startDate],
          a.EndDate    AS [endDate], 
          a.Remark     AS [remark],
          [fn].[getDepartShortName] (a.StockNo) AS [stockName]
     FROM DrugLotWarning  AS a,
          DrugBasic       AS b
    WHERE a.StartDate <= @currentTime
      AND a.EndDate   >= @currentTime
      AND b.DrugCode  =  a.DrugCode
      AND b.StartTime <= @currentTime
      AND b.EndTime   >= @currentTime
      AND b.MedCode   = [fn].[stringFilter] (@medCode, b.MedCode)
      AND a.LotNo     = ''
END

GO
DECLARE @params NVARCHAR(MAX) =
'
{
"medCode": "ISMOFL2",
}
'
EXEC [dbo].[getDrugLotWaring] @params