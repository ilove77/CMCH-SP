USE [HealthResource]
GO

--- 程序名稱：getDrugOutStockQty
--- 程序說明：取得藥品出庫量
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/30
CREATE FUNCTION [fn].[getDrugStockOutQty] (@tableName VARCHAR(20), @stockNo CHAR(04), @drugCode INT, @outStockMonth INT)
RETURNS INT
AS BEGIN
   DECLARE @outStockQty INT = 0;
   DECLARE @tranType    INT = 25; --交易類別 => 25: 消耗

   SELECT @outStockQty = SUM(ISNULL(b.TotQty, 0))
     FROM [dbo].[OptionItem]    AS a,
          [dbo].[DrugTranMonth] AS b
    WHERE a.TableName = @tableName
      AND a.FieldName = @stockNo
      AND b.StockNo   = a.OptionName
      AND b.DrugCode  = @drugCode
      AND b.TranType  = @tranType
      AND b.TranMonth = @outStockMonth
      AND b.TotQty    < 0

   RETURN @outStockQty 
END