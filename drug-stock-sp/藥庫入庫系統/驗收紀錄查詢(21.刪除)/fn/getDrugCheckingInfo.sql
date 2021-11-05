USE [HealthResource]
GO

--- 程序名稱: getDrugCheckingInfo
--- 程序說明: 依 InvoiceNo 取得 DrugChecking 資訊
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/11/05
CREATE FUNCTION [fn].[getDrugCheckingInfo] (@checkNo INT, @invoiceNo CHAR(10))
RETURNS NVARCHAR(MAX)
AS BEGIN 
   DECLARE @checkingInfo  NVARCHAR(MAX) = '';

   SELECT @checkingInfo = 
        (
            SELECT TOP 1
                   [checkNo]    = a.CheckNo,
                   [purchaseNo] = a.PurchaseNo,
                   [drugCode]   = a.DrugCode,
                   [invoiceNo]  = a.InvoiceNo
              FROM [dbo].[DrugChecking] AS a
             WHERE a.CheckNo   != @checkNo
               AND a.InvoiceNo  = @invoiceNo
               FOR JSON PATH, WITHOUT_ARRAY_WRAPPER 
        )
   RETURN @checkingInfo
END
GO
-- EXEC Function
SELECT [fn].[getDrugCheckingInfo] (1577,'CF61876535')