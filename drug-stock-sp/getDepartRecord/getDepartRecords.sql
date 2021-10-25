USE [HealthCare]
GO

--- 程序名稱：getDepartRecords
--- 程序說明：依 棟別 取得部門代號及部門名稱
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/10/06
CREATE PROCEDURE [dbo].[getDepartRecords](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @levelNo       CHAR(14) = JSON_VALUE(@params, '$.levelNo');
   DECLARE @matStockLevel TINYINT  = JSON_VALUE(@params, '$.matStockLevel');
   DECLARE @building      CHAR(01) = JSON_VALUE(@params, '$.building');
   
   WITH DepartItems AS (
        SELECT [BranchNo] = a.BranchNo
          FROM [dbo].[Department] AS a
         WHERE a.LevelNo       = @levelNo
           AND a.MatStockLevel = @matStockLevel 
       
   )
   SELECT [departNo]  = b.DepartNo,
          [shortName] = b.ShortName
     FROM DepartItems        AS a,
          [dbo].[Department] AS b   
    WHERE b.BranchNo = a.BranchNo
      AND b.Building = @building
      AND SUBSTRING(b.DepartNo,1,1) = '1'
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "levelNo": "L",
   "matStockLevel": 1,
   "building": "C"
}
';

EXEC [dbo].[getDepartRecords] @params
GO