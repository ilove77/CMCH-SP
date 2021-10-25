USE [HealthResource]
GO

--- 程序名稱: getInvoiceRecordInfo
--- 程序說明: 取得getInvoiceRecord 資訊
--- 編訂人員: 駱彥丞、蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/10/25
CREATE FUNCTION [fn].[getInvoiceInfo] (@invoiceNo CHAR(10))
RETURNS NVARCHAR(MAX)
AS BEGIN 
   DECLARE @result NVARCHAR(MAX) = '';
 
   SELECT @result = ( 
       SELECT [invoiceDate]   = a.InvoiceDate,
              [payDate]       = a.PayDate,
              [tranStatus]    = a.TranStatus,
              [realPayAmount] = a.RealPayAmount
         FROM [dbo].[InvoiceRecord] AS a
        WHERE a.InvoiceNo = @invoiceNo
          FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
   )
   RETURN @result 
END