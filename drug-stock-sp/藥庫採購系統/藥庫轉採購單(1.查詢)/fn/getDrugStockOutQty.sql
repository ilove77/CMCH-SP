USE [HealthResource]
GO

--- 程序名稱：getDrugStockOutQty
--- 程序說明：取得藥品全院出庫量
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/07/30
CREATE FUNCTION [fn].[getDrugStockOutQty] (@tableName VARCHAR(20), @stockNo CHAR(04), @drugCode INT, @outStockTime1 DATETIME, @outStockTime2 DATETIME)
RETURNS INT
AS BEGIN
   DECLARE @grantQty INT = 0;
   DECLARE @tranType INT = 25; --交易類別 => 25: 消耗

   SELECT @grantQty = SUM(ISNULL(b.Qty, 0)) 
     FROM [dbo].[OptionItem] AS a,
          [dbo].[DrugTrans]  AS b
    WHERE a.TableName     = @tableName
      AND a.FieldName     = @stockNo
      AND b.OutStockNo    = a.OptionName
      AND b.DrugCode      = @drugCode
      AND b.TranType      = @tranType
      AND b.OutStockTime >= @outStockTime1
      AND b.OutStockTime <= @outStockTime2
   RETURN @grantQty
END
   
