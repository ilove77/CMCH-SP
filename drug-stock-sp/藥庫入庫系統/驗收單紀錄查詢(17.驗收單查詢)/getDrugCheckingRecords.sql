USE [HealthResource]
GO

--- 程序名稱：getDrugCheckingRecords
--- 程序說明：取得驗收紀錄資料
--- 編訂人員：蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/08/05
CREATE PROCEDURE [dbo].[getDrugCheckingRecords](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @inStockNo    VARCHAR(04) = JSON_VALUE(@params, '$.inStockNo');
   DECLARE @medCode      CHAR(08)    = JSON_VALUE(@params, '$.medCode');
   DECLARE @lotNo        CHAR(20)    = JSON_VALUE(@params, '$.lotNo');
   DECLARE @purchaseNo   INT         = JSON_VALUE(@params, '$.purchaseNo');
   DECLARE @checkStatus1 INT         = JSON_VALUE(@params, '$.checkStatus1'); 
   DECLARE @checkStatus2 INT         = JSON_VALUE(@params, '$.checkStatus2'); 
   DECLARE @checkTime1   DATETIME    = [fn].[getDateMinTime](JSON_VALUE(@params, '$.checkDate1'));
   DECLARE @checkTime2   DATETIME    = [fn].[getDateMaxTime](JSON_VALUE(@params, '$.checkDate2'));
   
   WITH CheckItems AS (
        SELECT [CheckNo]    = a.CheckNo,
               [PurchaseNo] = a.PurchaseNo,
               [CheckTime]  = a.AcceptTime,
               [DrugCode]   = b.DrugCode,
               [MedCode]    = b.MedCode,
               [DrugName]   = b.DrugName,
               [BatchNo]    = a.BatchNo,
               [InStockNo]  = a.InStockNo,
               [AcceptTime] = a.AcceptTime,
               [CheckType]  = a.CheckType,
               [CheckQty]   = a.CheckQty,
               [InvoiceNo]  = a.InvoiceNo     
          FROM DrugChecking AS a,
               DrugBasic    AS b  
         WHERE a.InStockNo   LIKE @inStockNo
           AND a.PurchaseNo  = [fn].[numberFilter](@purchaseNo, a.PurchaseNo)
           AND a.CheckStatus BETWEEN @checkStatus1 AND @checkStatus2
           AND a.AcceptTime  BETWEEN @checkTime1   AND @checkTime2
           AND b.DrugCode    = a.DrugCode
           AND b.MedCode     = [fn].[stringFilter](@medCode, b.MedCode)
           AND b.StartTime  <= a.CheckTime
           AND b.EndTime    >= a.CheckTime             
   )
   SELECT [checkNo]       = a.CheckNo,
          [purchaseNo]    = a.PurchaseNo,
          [stockName]     = [fn].[getShortName](a.InStockNo),
          [checkTime]     = a.AcceptTime,
          [drugCode]      = a.DrugCode,
          [medCode]       = a.MedCode,
          [drugName]      = a.DrugName,
          [checkQty]      = a.CheckQty,
          [checkTypeName] = [fn].[getOptionName](a.CheckType, 'DrugCheck', 'CheckType'),
          [unitName]      = [fn].[getUnitBasicName](b.Unit),
          [lotNo]         = c.LotNo,
          [expDate]       = c.ExpDate,
          [invoiceNo]     = a.InvoiceNo,   
          [invoiceDate]   = d.InvoiceDate
     FROM CheckItems          AS a    
     LEFT JOIN DrugPurchaseDt AS b ON a.PurchaseNo = b.purchaseNo AND a.DrugCode = b.DrugCode
     LEFT JOIN DrugBatch      AS c ON a.BatchNo    = c.BatchNo
     LEFT JOIN InvoiceRecord  AS d ON a.InvoiceNo  = d.InvoiceNo 
    WHERE b.DrugCode = a.DrugCode  
      AND c.BatchNo  = a.BatchNo
      AND c.LotNo    = [fn].[stringFilter](@lotNo, c.LotNo)
    ORDER BY a.AcceptTime, a.InvoiceNo
      FOR JSON PATH
END
GO

 DECLARE @params NVARCHAR(MAX) =
'
{
   "inStockNo":"1%",
   "medCode": "",
   "lotNo": "",
   "purchaseNo": 0,
   "checkDate1": "2021-08-01",
   "checkDate2": "2021-08-05",
   "checkStatus1": 30,
   "checkStatus2": 79
}
';

EXEC [dbo].[getDrugCheckingRecords] @params
GO