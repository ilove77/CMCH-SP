SELECT stockNo        AS [StockNo],
          matCode        AS [MatCode],
          ISNULL([F1],0) AS [CheckQty],
          ISNULL([F2],0) AS [ReturnQty],
          ISNULL([F3],0) AS [ConsumeQty],
          ISNULL([F4],0) AS [SaleQty],
          ISNULL([F5],0) AS [IoQty],
          ISNULL([F6],0) AS [LossesOverQty],
          ISNULL([F7],0) AS [InitialQty],
          ISNULL([F1],0) + ISNULL([F2],0) AS [NetPurchasesQty],
          ISNULL([F1],0) + ISNULL([F2],0) + ISNULL([F3],0) + ISNULL([F4],0) + ISNULL([F5],0) + ISNULL([F6],0)+ ISNULL([F7],0) AS [ClosingQty]
     FROM(
          SELECT a.StockNo     AS [stockNo],
                 a.MatCode     AS [matCode],
                 a.totQty      AS [totQty],
                 [fn].[getGroupTranType](a.TranType) AS [GroupTranType]
            FROM [dbo].[MatTransMonth] AS a
           WHERE a.TranMonth = 202104
             AND a.TotQty    <> 0
             AND a.StockNo   LIKE '1P11' + '%'
             --AND a.StockNo   = [fn].[stringFilter]('', a.StockNo)
          ) AS MatTranMonth
     PIVOT (
             SUM(totQty) 
             FOR GroupTranType IN ([F1],[F2],[F3],[F4],[F5],[F6],[F7])
           ) AS MatGroupList