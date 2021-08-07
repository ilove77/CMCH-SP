select  top 1 b.* from  DrugDemand b

where  b.DemandTime <= getdate() AND b.DemandStock = '1P1A'  and DemandType = 60 AND DemandTime < GETDATE() order by DemandTime desc

 select sum(qty) from DrugTrans a where a.TranType = 25 and a.DrugCode = 3451 ANd a.OutStockTime Between '2021-07-10' AND '2021-07-13'  AND a.OutStockNo = '1P1A' 