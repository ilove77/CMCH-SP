USE [HealthResource]
GO

----- 程序名稱：getDrugKeywords
----- 程序說明：取得關鍵字藥品清單
----- 編訂人員：蔡易志
----- 校閱人員：孫培然
----- 修訂日期：2021/07/27
CREATE PROCEDURE [dbo].[getDrugKeywords](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @stockNo      CHAR(04)     = JSON_VALUE(@params, '$.stockNo');
   DECLARE @medCode      VARCHAR(104) = JSON_VALUE(@params, '$.medCode');
   DECLARE @currentTime  DATETIME     = GETDATE()

   SELECT b.DrugCode AS [drugCode],
          b.MedCode  AS [medCode],
          b.DrugName AS [drugName]
     FROM DrugStockMt AS a, 
          DrugBasic   AS b
    WHERE a.StockNo      = @stockNo
      AND b.DrugCode     = a.DrugCode
      AND b.StartTime   >= @currentTime
      AND b.EndTime     <= @currentTime 
      AND (b.MedCode     LIKE [fn].[stringFilter](@medCode, b.MedCode)
       OR b.DrugName     LIKE [fn].[stringFilter](@medCode, b.DrugName)
       OR b.BrandName1   LIKE [fn].[stringFilter](@medCode, b.BrandName1)
       OR b.BrandName2   LIKE [fn].[stringFilter](@medCode, b.BrandName2)
       OR b.GenericName1 LIKE [fn].[stringFilter](@medCode, b.GenericName1)
       OR b.GenericName2 LIKE [fn].[stringFilter](@medCode, b.GenericName2))
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(max) =
'
{
    "stockNo": "1P11",
    "medCode": "%tac%"
}
'

EXEC [dbo].[getDrugKeywords] @params
GO
