USE [HealthResource]
GO
--- 程序名稱：getInvoiceDiscounts
--- 程序說明：依發票-取得折讓資料
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/09/14
CREATE PROCEDURE [dbo].[getInvoiceDiscounts](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @invoiceNo     CHAR(10)      = JSON_VALUE(@params, '$.invoiceNo');
   DECLARE @itemType      TINYINT       = JSON_VALUE(@params, '$.itemType');   
   DECLARE @discountsType TINYINT       = JSON_VALUE(@params, '$.discountsType');
   DECLARE @itemCode      DECIMAL(12,4) = JSON_VALUE(@params, '$.itemCode');
   DECLARE @checkNo       INT           = JSON_VALUE(@params, '$.checkNo');

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
     FROM [dbo].[InvoiceDiscounts] AS a
    WHERE a.InvoiceNo     = @invoiceNo
      AND a.ItemType      = @itemType
      AND a.DiscountsType = [fn].[numberFilter] (@discountsType, a.DiscountsType)
      AND a.ItemCode      = [fn].[numberFilter] (@itemCode, a.ItemCode)
      AND a.CheckNo       = [fn].[numberFilter] (@checkNo, a.CheckNo)
      FOR JSON PATH

END
GO

--- EXEC PROCEDURE
DECLARE @params NVARCHAR(MAX) = 
'
{
  "invoiceNo": "CF47834118",
  "itemType" : 10,
  "discountsType": 10,
  "itemCode": 2979.00
}
'
EXEC [dbo].[getInvoiceDiscounts] @params
GO
