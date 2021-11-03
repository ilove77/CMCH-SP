USE [HealthCare]
GO

--- 程序名稱: getStockBulidInfos
--- 程序說明: 取得棟別查詢資訊
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/11/02
CREATE PROCEDURE [dbo].[getStockBulidInfos] (@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @departNo VARCHAR(04) = JSON_VALUE(@params,'$.departNo');
   DECLARE @builder  CHAR(01)    = JSON_VALUE(@params,'$.builder');

   SELECT [departNo]   = a.DepartNo,
          [departName] = a.ShortName
     FROM [dbo].[department] AS a
    WHERE a.DepartNo LIKE @departNo 
      AND a.Builder  = @builder
      FOR JSON PATH
END
GO

-- EXEC PROCEDURE
DECLARE @params NVARCHAR(MAX) =
'
{
 "departNo"  : "1%",
 "builder" : "C"
}
'

EXEC [dbo].[getStockBulidInfos] @params
GO