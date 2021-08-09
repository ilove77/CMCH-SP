USE [HealthResource]
GO
--- 程序名稱：getInvoiceDiscounts
--- 程序說明：依發票-取得折讓資料
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/09
CREATE PROCEDURE [dbo].[getInvoiceDiscounts](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @invoiceNo     CHAR(10) = JSON_VALUE(@params, '$.invoiceNo');
   DECLARE @itemType      TINYINT  = JSON_VALUE(@params, '$.itemType');   
   DECLARE @discountsType TINYINT  = JSON_VALUE(@params, '$.discountsType'); 

   SELECT [discountsNo]   = a.DiscountsNo,
          [invoiceNo]     = a.InvoiceNo,
          [discountsType] = a.DiscountsType,
          [checkNo]       = a.CheckNo, 
          [itemType]      = a.ItemType, 
          [itemCode]      = a.ItemCode,
          [amount]        = a.Amount, 
          [discountsDate] = a.DiscountsDate,
          [systemUser]    = a.SystemUser,
          [systemTime]    = a.SystemTime
     FROM InvoiceDiscounts a
    WHERE a.InvoiceNo     = @invoiceNo
      AND a.ItemType      = @itemType
      AND a.DiscountsType = @discountsType
      FOR JSON PATH
END
GO;
--- EXEC PROCEDURE
DECLARE @params NVARCHAR(MAX) = 
'
{
  "invoiceNo": "NW49079881",
  "itemType" : 20,
  "discountsType": 10
}
'
EXEC [dbo].[getInvoiceDiscounts] @params
GO
