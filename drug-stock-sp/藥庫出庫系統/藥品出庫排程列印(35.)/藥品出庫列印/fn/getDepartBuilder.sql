USE [HealthResource]
GO

--- 程序名稱: getDepartBuilder
--- 程序說明: 取得部門棟別
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/11/09
CREATE FUNCTION [fn].[getDepartBuilder] (@departNo CHAR(04))
RETURNS CHAR(01)
AS BEGIN 
   DECLARE @builder CHAR(01) = '';

   SELECT @builder = Builder
     FROM [HealthCare].[dbo].[Department]
    WHERE DepartNo = @departNo

   RETURN @builder
END