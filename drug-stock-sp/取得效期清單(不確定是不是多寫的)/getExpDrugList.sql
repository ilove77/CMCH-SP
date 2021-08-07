USE [HealthResource]
GO

--- 程序名稱：getExpDrugList
--- 程序說明：取得藥品效期清單
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/06

CREATE PROCEDURE [dbo].[getExpDrugList](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo      CHAR(04) = JSON_VALUE(@params,'$.stockNo');
   DECLARE @startDate    DATE     = JSON_VALUE(@params,'$.startDate');
   DECLARE @endDate      DATE     = JSON_VALUE(@params,'$.endDate');
   DECLARE @checkStatus1 TINYINT  = 30; 
   DECLARE @checkStatus2 TINYINT  = 79; 

   SELECT c.MedCode   AS [medCode], 
          a.DrugCode  AS [drugCode],
          c.DrugName  AS [drugName],
          a.CheckQty  AS [checkQty],
          a.CheckTime AS [checkTime],
          b.LotNo     AS [lotNo],
          b.ExpDate   AS [expDate]
     FROM [dbo].[DrugChecking] AS a,
          [dbo].[DrugBatch]    AS b,
          [dbo].[DrugBasic]    AS c
    WHERE a.InStockNo   = @stockNo
      AND a.CheckStatus BETWEEN @checkStatus1 AND @checkStatus2
      AND b.BatchNo     = a.BatchNo
      AND b.DrugCode    = a.DrugCode
      AND b.ExpDate     BETWEEN @startDate AND @endDate
      AND c.DrugCode    = b.DrugCode
      AND c.StartTime  <= a.CheckTime
      AND c.EndTime    >= a.CheckTime
END
GO

DECLARE @params NVARCHAR(MAX) = 
'
{ 
  "stockNo": "1P11",
  "startDate": "2021-07-01",
  "endDate": "2021-07-06",
}
';
EXEC [dbo].[getExpDrugList] @params
GO