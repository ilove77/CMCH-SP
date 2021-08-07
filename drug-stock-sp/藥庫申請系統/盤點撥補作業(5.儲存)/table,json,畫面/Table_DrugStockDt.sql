----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugStockDt (Drug Stock Detail)                                                     
--- 表格說明：藥品庫存量檔
--- 編訂人員：孫培然                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2016/01/20                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
CREATE TABLE DrugStockDt  
(
 StockNo          CHAR(04)                      NOT NULL, -- 庫別編碼
 DrugCode         INT                           NOT NULL, -- 藥品代碼 
 BatchNo          INT                           NOT NULL, -- 品項批號
 StockQty         INT                           NOT NULL, -- 庫存量
 SystemUser       INT                           NOT NULL, -- 系統異動人員 
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間 

 CONSTRAINT DrugStockDtPKey PRIMARY KEY (StockNo,BatchNo,DrugCode)
)