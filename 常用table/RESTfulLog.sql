----------------------------------------------------------------------------------------------------
--- 表格名稱：RESTfulLog  (RESTful Log)
--- 表格說明：RESTful交易紀錄
--- 編訂人員：王勇順
--- 校閱人員：孫培然
--- 設計日期：2017/11/10
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
CREATE TABLE RESTfulLog
(
 RequestUrl       VARCHAR(255)                  NOT NULL, -- 請求網址
 Params           NVARCHAR(MAX)                         , -- 請求參數(json)
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間

 CONSTRAINT RESTfulLogPKey PRIMARY KEY (SystemTime DESC,RequestUrl)
);