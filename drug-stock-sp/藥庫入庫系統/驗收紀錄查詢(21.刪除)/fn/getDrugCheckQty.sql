USE [HealthResource]
GO

--- 程序名稱: getDrugCheckQty
--- 程序說明: 取得藥品驗收量
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/11/2
CREATE FUNCTION [fn].[getDrugCheckQty] (@purchaseNo INT, @drugCode INT)
RETURNS INT
AS BEGIN 
   DECLARE @checkQty INT = 0;

   SELECT @checkQty = SUM(ISNULL(a.CheckQty, 0))
     FROM [dbo].[DrugPurchaseDt] AS a
    WHERE a.PurchaseNo = @purchaseNo
      AND a.DrugCode   = @drugCode
     
   RETURN ISNULL(@checkQty, 0)
END