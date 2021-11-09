USE [HealthResource]
GO

--- 程序名稱: getDrugStorageNo
--- 程序說明: 取得藥品儲位號
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/11/09
CREATE FUNCTION [fn].[getDrugStorageNo] (@stockNo CHAR(04), @drugCode INT)
RETURNS VARCHAR(30)
AS BEGIN 
   DECLARE @storageNo VARCHAR(30) = '';

   SELECT @storageNo = StorageNo
     FROM [dbo].[DrugStockMt]
    WHERE StockNo  = @stockNo
      AND DrugCode = @drugCode

   RETURN @storageNo
END