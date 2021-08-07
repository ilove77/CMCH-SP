USE [HealthResource]
GO

--- 程序名稱：getDrugChecking
--- 程序說明：取得藥品驗收紀錄檔
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/04
CREATE PROCEDURE [dbo].[getDrugChecking](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @checkNo INT = JSON_VALUE(@params, '$.checkNo');

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
    WHERE a.CheckNo = @checkNo
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
   "checkNo": 1499
}
';

EXEC [dbo].[getDrugChecking] @params
GO