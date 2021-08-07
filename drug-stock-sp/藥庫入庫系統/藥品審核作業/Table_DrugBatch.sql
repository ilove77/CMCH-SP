----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugBatch (Drug Batch))                                                            
--- 表格說明：藥品批號紀錄檔
--- 編訂人員：孫培然                                                                            
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/23                                                                         
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
drop table DrugBatch
create table DrugBatch
(
 BatchNo          int identity(1,1)             not null, -- 批號流水號
 DrugCode         int                           not null, -- 藥品代碼
 LotNo            char(20)                      not null, -- 品項批號
 ExpDate          date                          not null, -- 有效期間
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間

 constraint DrugBatchPKey primary key (BatchNo)
);
create index DrugBatchKey1 on DrugBatch(LotNo);
create index DrugBatchKey2 on DrugBatch(DrugCode);

