----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugStockDt (Drug Stock Detail)                                                     
--- 表格說明：藥品庫存量檔
--- 編訂人員：孫培然                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2016/01/20                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
create table DrugStockDt  
(
 StockNo          char(04)                      not null, -- 庫別編碼
 DrugCode         int                           not null, -- 藥品代碼 
 BatchNo          int                           not null, -- 品項批號
 StockQty         int                           not null, -- 庫存量
 SystemUser       int                           not null, -- 系統異動人員 
 SystemTime       datetime                      not null, -- 系統異動時間 

 constraint DrugStockDtPKey primary key (StockNo,BatchNo,DrugCode)
)