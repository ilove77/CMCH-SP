----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugTrialRecord (Drug Trial Record)                                                     
--- 表格說明：藥品查核紀錄檔
--- 編訂人員：林穎祥                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2017/10/03                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
create table DrugTrialRecord
(
 CheckNo          int                           not null, -- 驗收單號
 TrialDate        date                          not null, -- 查核時間
 TrialUser        int                           not null, -- 查核人員
 IsLicense        bit default('false')          not null, -- 許可證是否正確
 IsExterior       bit default('false')          not null, -- 外觀是否變更
 IsLotNo          bit default('false')          not null, -- 批號是否正確
 IsEffect         bit default('false')          not null, -- 效期是否正確
 Remark           nvarchar(255)                 not null, -- 備註說明
 SystemUser       int                           not null, -- 系統異動人員 
 SystemTime       datetime                      not null, -- 系統異動時間 

 constraint DrugTrialRecordPKey primary key (CheckNo)
);
 create index DrugTrialRecordPKey1 on DrugTrialRecord(TrialDate DESC,CheckNo);
