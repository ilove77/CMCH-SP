USE [HealthResource]
GO
/****** Object:  UserDefinedFunction [fn].[getDrugPurchaseQty]    Script Date: 2021/8/9 上午 09:42:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- 程序名稱: getDrugPurchaseQty
--- 程序說明: 取得藥品請領數量
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/08/06
CREATE FUNCTION [fn].[getDrugPurchaseQty] (@supplyStock CHAR(04),@purchaseType INT, @drugCode INT, @totalGrantQty INT, @purchaseQty INT, @packageQty INT, @demandTime1 DATETIME, @demandTime2 DATETIME)
RETURNS INT
AS BEGIN
   DECLARE @buyQty INT = 0;

   IF @purchaseType=5
     SET @buyQty = CEILING(@totalGrantQty / 25) * 10 / @packageQty * @packageQty
   
   IF @purchaseType=10 OR @purchaseType=11
      SET @buyQty = @purchaseQty 

   IF(@purchaseType=30) 
      SET @buyQty = (
             SELECT SUM(ISNULL(a.DemandQty,0))
               FROM [dbo].[DrugDemand]  AS a,
                    [dbo].[DrugStockMt] AS b
              WHERE a.SupplyStock = @supplyStock 
                AND a.DrugCode    = @drugCode 
                AND a.DemandTime  BETWEEN @demandTime1 AND @demandTime2
                AND a.DemandType  IN (40,45)
                AND b.StockNo     = a.DemandStock
                AND b.DrugCode    = a.DrugCode
                AND b.IsComplexIn = 1
          )

   RETURN @buyQty
END