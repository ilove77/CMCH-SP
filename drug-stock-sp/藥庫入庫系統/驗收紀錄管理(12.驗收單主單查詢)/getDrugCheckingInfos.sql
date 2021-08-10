USE [HealthResource]
GO

--- 程序名稱：getDrugCheckingInfos
--- 程序說明：取得藥品驗收資訊
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/10
CREATE PROCEDURE [dbo].[getDrugCheckingInfos](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @purchaseNo  INT     = JSON_VALUE(@params, '$.purchaseNo');
   DECLARE @drugCode    INT     = JSON_VALUE(@params, '$.drugCode');
   DECLARE @checkStatus TINYINT = JSON_VALUE(@params, '$.checkStatus');

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
    WHERE a.PurchaseNo  = @purchaseNo
      AND a.DrugCode    = @drugCode
      AND a.CheckStatus = @checkStatus 
      FOR JSON PATH
END
GO

 DECLARE @params nvarchar(max) =
'
{
    "purchaseNo": 272590,
    "drugCode": 4015,
    "checkStatus": 10
}
'

EXEC [dbo].[getDrugCheckingInfos] @params
GO