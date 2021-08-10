USE [HealthResource]
GO

--- 程序名稱：getDrugStockMonthQty
--- 程序說明：取得藥品全院月消耗量(批價量)
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/10
CREATE FUNCTION [fn].[getDrugStockMonthQty] (@tableName VARCHAR(20), @stockNo CHAR(04), @drugCode INT, @tranMonth INT)
RETURNS INT
AS BEGIN
   DECLARE @monthQty INT = 0;
   DECLARE @tranType INT = 25; --交易類別 => 25: 消耗

   SELECT @monthQty = SUM(ISNULL(b.TotQty,0))
     FROM [dbo].[OptionItem]    AS a,
          [dbo].[DrugTranMonth] AS b
    WHERE a.TableName = @tableName
      AND a.FieldName = @stockNo
      AND b.StockNo   = a.OptionName
      AND b.DrugCode  = @drugCode
      AND b.TranType  = @tranType
      AND b.TranMonth = @tranMonth
   RETURN @monthQty
END