USE [HealthResource]
GO

--- 程序名稱：getDrugStockInQty
--- 程序說明：取得藥品全院入庫量
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/30
ALTER FUNCTION [fn].[getDrugStockInQty] (@tableName VARCHAR(20), @stockNo CHAR(04), @drugCode INT, @inStockTime1 DATETIME, @inStockTime2 DATETIME)
RETURNS INT
AS BEGIN
   DECLARE @grantQty INT = 0;
   DECLARE @tranType INT = 25; --交易類別 => 25: 消耗

   SELECT @grantQty = SUM(ISNULL(b.Qty, 0)) 
     FROM [dbo].[OptionItem] AS a,
          [dbo].[DrugTrans]  AS b
    WHERE a.TableName    = @tableName
      AND a.FieldName    = @stockNo
      AND b.InStockNo    = a.OptionName
      AND b.DrugCode     = @drugCode
      AND b.TranType     = @tranType
      AND b.InStockTime >= @inStockTime1
      AND b.InStockTime <= @inStockTime2
   RETURN @grantQty
END