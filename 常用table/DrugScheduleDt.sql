----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugScheduleDt (Drug Schedule Detail)                                                     
--- 表格說明：藥品排程明細檔
--- 編訂人員：孫培然, 陳友申                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/10/22                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource; 
drop table DrugScheduleDt
CREATE TABLE DrugScheduleDt
(
 ScheduleNo       INT                           NOT NULL, -- 排程編號
 SeqNo            TINYINT                       NOT NULL, -- 優先順序
 StockNo          CHAR(04)                      NOT NULL, -- 庫別
 SystemUser       INT                           NOT NULL, -- 系統異動人員 
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間 
 
 CONSTRAINT DrugScheduleDtPKey PRIMARY KEY(ScheduleNo,SeqNo,StockNo)
);    