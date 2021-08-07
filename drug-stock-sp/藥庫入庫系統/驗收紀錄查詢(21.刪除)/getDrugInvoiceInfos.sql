USE [HealthResource]
GO

--- 程序名稱：getDrugInvoiceInfos
--- 程序說明：依 InvoiceNo 判斷取得發票項目
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/05
CREATE PROCEDURE [dbo].[getDrugInvoiceInfos](@params NVARCHAR(MAX))
AS BEGIN

   SELECT [checkNo]      = a.CheckNo,    
          [purchaseNo]   = a.PurchaseNo, 
          [checkType]    = a.CheckType,
          [drugCode]     = a.DrugCode,    
          [checkUser]    = a.CheckUser,   
          [checkTime]    = a.CheckTime,  
          [checkQty]     = a.CheckQty, 
          [invoiceNo]    = a.InvoiceNo,
          [payDate]      = a.PayDate,     
          [payAmount]    = a.PayAmount,   
          [adjustAmount] = a.AdjustAmount,
          [oldPrice]     = a.OldPrice,    
          [newPrice]     = a.NewPrice,    
          [batchNo]      = a.BatchNo,     
          [checkStatus]  = a.CheckStatus, 
          [acceptUser]   = a.AcceptUser,  
          [acceptTime]   = a.AcceptTime,  
          [inStockNo]    = a.InStockNo,   
          [inStockTime]  = a.InStockTime, 
          [adjustRemark] = a.AdjustRemark,
          [debitReason]  = a.DebitReason, 
          [sendRemark]   = a.SendRemark,  
          [systemUser]   = a.SystemUser,  
          [systemTime]   = a.SystemTime  
     FROM DrugChecking AS a
    WHERE a.InvoiceNo IN (SELECT VALUE FROM OPENJSON(@params, '$.invoiceNos'))
      FOR JSON PATH
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "invoiceNos": ["CF61876535","CF61876534"]
}
';

EXEC [dbo].[getDrugInvoiceInfos] @params
GO