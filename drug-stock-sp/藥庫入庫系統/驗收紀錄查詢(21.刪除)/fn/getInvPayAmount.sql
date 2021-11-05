USE [HealthResource]
GO

--- 程序名稱: getInvPayAmount
--- 程序說明: 依 InvoiceNo 取得發票應付金額
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/11/05
CREATE FUNCTION [fn].[getInvPayAmount] (@invoiceNo CHAR(10))
RETURNS DECIMAL(10,3) 
AS BEGIN 
   DECLARE @payAmount DECIMAL(10,3);
        
   SELECT @payAmount = SUM(ISNULL(a.PayAmount,0))
     FROM [dbo].[DrugChecking] AS a
    WHERE a.InvoiceNo    = @invoiceNo
      AND a.CheckStatus != 80   
  
   RETURN ISNULL(@payAmount,0)
END