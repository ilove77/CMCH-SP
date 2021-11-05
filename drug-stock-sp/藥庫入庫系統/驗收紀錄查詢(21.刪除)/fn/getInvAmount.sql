USE [HealthResource]
GO

--- 程序名稱: getInvPayAmount
--- 程序說明: 依 invoiceNo 和 discountsType 取得 折讓金額
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/11/05
CREATE FUNCTION [fn].[getInvAmount] (@invoiceNo CHAR(10), @discountsType TINYINT)
RETURNS DECIMAL(10,3) 
AS BEGIN 
   DECLARE @amount DECIMAL(10,3);
        
   SELECT @amount = SUM(ISNULL(a.Amount,0))
     FROM [dbo].[InvoiceDiscounts] AS a
    WHERE a.InvoiceNo     = @invoiceNo
      AND a.DiscountsType = @discountsType   

   RETURN ISNULL(@amount,0)
END