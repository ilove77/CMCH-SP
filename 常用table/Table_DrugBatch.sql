----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugBatch (Drug Batch))                                                            
--- 表格說明：藥品批號紀錄檔
--- 編訂人員：孫培然                                                                            
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/23                                                                         
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
drop table DrugBatch
CREATE TABLE DrugBatch
(
 BatchNo          INT IDENTITY(1,1)             NOT NULL, -- 批號流水號
 DrugCode         INT                           NOT NULL, -- 藥品代碼
 LotNo            CHAR(20)                      NOT NULL, -- 品項批號
 ExpDate          DATE                          NOT NULL, -- 有效期間
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間

 CONSTRAINT DrugBatchPKey PRIMARY KEY (BatchNo)
);
CREATE INDEX DrugBatchKey1 ON DrugBatch(LotNo);
CREATE INDEX DrugBatchKey2 ON DrugBatch(DrugCode);

