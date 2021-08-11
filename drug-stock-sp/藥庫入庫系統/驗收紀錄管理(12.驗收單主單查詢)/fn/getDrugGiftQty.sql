USE [HealthResource]
GO

--- 程序名稱: getDrugGiftQty
--- 程序說明: 取得藥品贈品量
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/11
CREATE FUNCTION [fn].[getDrugGiftQty] (@purchaseNo INT, @drugCode INT)
RETURNS INT
AS BEGIN 
   DECLARE @giftQty      INT     = 0;
   DECLARE @checkType1   TINYINT = 20; --驗收類別 => 20: 贈品驗收
   DECLARE @checkType2   TINYINT = 30; --驗收類別 => 30: 樣品驗收
   DECLARE @checkStatus1 TINYINT = 10; --驗收狀態 => 10: 匯入
   DECLARE @checkStatus2 TINYINT = 30; --驗收狀態 => 30: 過帳入庫

   SELECT @giftQty = SUM(ISNULL(a.CheckQty, 0))
     FROM [dbo].[DrugChecking] AS a
    WHERE a.PurchaseNo  = @purchaseNo
      AND a.DrugCode    = @drugCode
      AND a.CheckType   BETWEEN @checkType1   AND @checkType2
      AND a.CheckStatus BETWEEN @checkStatus1 AND @checkStatus2
   RETURN @giftQty
END

