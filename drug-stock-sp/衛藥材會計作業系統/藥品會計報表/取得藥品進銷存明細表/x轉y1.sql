 SELECT a.StockNo     AS [stockNo],
                 a.MatCode     AS [matCode],
                 a.totQty      AS [totQty],
                 [fn].[getGroupTranType](a.TranType) AS [GroupTranType]
            FROM [dbo].[MatTransMonth] AS a
           WHERE a.TranMonth = 202104
             AND a.TotQty    <> 0
             AND a.StockNo   LIKE '1' + '%'
             AND a.StockNo   = [fn].[stringFilter]('', a.StockNo)
