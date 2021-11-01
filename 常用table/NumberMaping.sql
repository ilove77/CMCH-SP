----------------------------------------------------------------------------------------------------
--- 表格名稱：NumberMaping (Number Maping)
--- 表格說明：號碼對照檔
--- 編訂人員：王勇順
--- 校閱人員：孫培然
--- 設計日期：2017/07/21
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;

CREATE TABLE NumberMaping
( 
 BranchNo         TINYINT                       NOT NULL, -- 院區代碼
 NumberType       TINYINT                       NOT NULL, -- 號碼類別
 SourceNo         INT                           NOT NULL, -- 來源編號
 DisplayNo        INT                           NOT NULL, -- 呈現編號
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間

 CONSTRAINT NumberMapingPKey PRIMARY KEY (SourceNo,NumberType,BranchNo,DisplayNo)
)
 CREATE INDEX NumberMapingKey1 ON NumberMaping(BranchNo,NumberType,DisplayNo DESC);