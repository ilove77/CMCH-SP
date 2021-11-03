USE [HealthResource]
GO

--- 程序名稱：getDrugReviewInfo
--- 程序說明：取得藥品審核明細
--- 編訂人員：蔡晁玄、蔡易志
--- 校閱人員：孫培然
--- 修訂日期：2021/11/03
CREATE PROCEDURE [dbo].[getDrugReviewInfo](@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @checkNo     INT       = JSON_VALUE(@params,'$.checkNo');
   DECLARE @medCode     CHAR(08)  = JSON_VALUE(@params,'$.medCode');
   DECLARE @stockNo     CHAR(04)  = JSON_VALUE(@params,'$.stockNo');
   DECLARE @checkTime   DATETIME2 = JSON_VALUE(@params,'$.checkTime');
   DECLARE @itemType    TINYINT   = 10;

   SELECT [checkNo]    = a.CheckNo,     
          [checkTime]  = a.CheckTime,   
          [totalQty]   = b.TotalQty,    
          [drugCode]   = b.DrugCode,    
          [keepType]   = b.KeepType,    
          [lotNo]      = c.LotNo,       
          [expDate]    = c.ExpDate,     
          [licenseNo]  = d.LicenseNo,   
          [inStockNo]  = a.InStockNo,   
          [medCode]    = e.MedCode,        
          [drugName]   = e.DrugName,    
          [brandName1] = e.BrandName1,  
          [isCoA]      = f.IsCoA,       
          [isEffect]   = f.IsEffect,    
          [isExterior] = f.IsExterior,  
          [isLicense]  = f.IsLicense,   
          [isLotNo]    = f.IsLotNo,     
          [remark]     = f.Remark,      
          [trialUser]  = f.TrialUser,   
          [systemUser] = f.SystemUser  
     FROM [dbo].[DrugChecking]  AS a,
          [dbo].[DrugStockMt]   AS b,
          [dbo].[DrugBatch]     AS c,
          [dbo].[PurchaseBasic] AS d,
          [dbo].[DrugBasic]     AS e
     LEFT JOIN [dbo].[DrugTrialRecord] AS f ON f.CheckNo = @checkNo
    WHERE a.CheckNo    = @checkNo
      AND b.StockNo    = @stockNo
      AND b.DrugCode   = a.DrugCode
      AND c.BatchNo    = a.BatchNo
      AND c.DrugCode   = a.DrugCode
      AND d.ItemCode   = a.DrugCode
      AND d.StartTime <= @checkTime
      AND d.EndTime   >= @checkTime
      AND d.ItemType   = @itemType
      AND e.MedCode    = @medCode
      AND e.StartTime <= @checkTime
      AND e.EndTime   >= @checkTime
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

DECLARE @params NVARCHAR(MAX) =
'
{
"medCode":"TMETHOT",
"stockNo":"1P11",
"checkNo":26105,
"checkTime":"2016-11-29 16:17:12.277"
}
'

EXEC [dbo].[getDrugReviewInfo] @params
GO