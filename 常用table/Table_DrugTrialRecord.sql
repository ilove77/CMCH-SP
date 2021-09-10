----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugTrialRecord (Drug Trial Record)                                                     
--- 表格說明：藥品查核紀錄檔
--- 編訂人員：林穎祥                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2017/10/03                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
CREATE TABLE DrugTrialRecord
(
 CheckNo          INT                           NOT NULL, -- 驗收單號
 TrialDate        DATE                          NOT NULL, -- 查核時間
 TrialUser        INT                           NOT NULL, -- 查核人員
 IsLicense        BIT DEFAULT('FALSE')          NOT NULL, -- 許可證是否正確
 IsExterior       BIT DEFAULT('FALSE')          NOT NULL, -- 外觀是否變更
 IsLotNo          BIT DEFAULT('FALSE')          NOT NULL, -- 批號是否正確
 IsEffect         BIT DEFAULT('FALSE')          NOT NULL, -- 效期是否正確
 IsCoA            BIT DEFAULT('FALSE')          NOT NULL, -- 是否提供品質報告書  
 Remark           NVARCHAR(255)                 NOT NULL, -- 備註說明
 SystemUser       INT                           NOT NULL, -- 系統異動人員 
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間 

 CONSTRAINT DrugTrialRecordPKey PRIMARY KEY (CheckNo)
);
 CREATE INDEX DrugTrialRecordPKey1 ON DrugTrialRecord(TrialDate DESC,CheckNo);
