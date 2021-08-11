USE [HealthResource]
GO

--- 程序名稱: getDrugPurchaseQty
--- 程序說明: 取得藥品購買量(訂單量)
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/11
CREATE FUNCTION [fn].[getDrugPurchaseQty] (@purchaseNo INT, @drugCode INT)
RETURNS INT
AS BEGIN 
   DECLARE @purchaseQty  INT     = 0;
   DECLARE @checkType    TINYINT = 10; --驗收類別 => 10: 訂單驗收
   DECLARE @checkStatus1 TINYINT = 10; --驗收狀態 => 10: 匯入
   DECLARE @checkStatus2 TINYINT = 30; --驗收狀態 => 30: 過帳入庫

   SELECT @purchaseQty = SUM(ISNULL(a.CheckQty, 0))
     FROM [dbo].[DrugChecking] AS a
    WHERE a.PurchaseNo  = @purchaseNo
      AND a.DrugCode    = @drugCode
      AND a.CheckType   = @checkType
      AND a.CheckStatus BETWEEN @checkStatus1 AND @checkStatus2
   RETURN @purchaseQty
END

