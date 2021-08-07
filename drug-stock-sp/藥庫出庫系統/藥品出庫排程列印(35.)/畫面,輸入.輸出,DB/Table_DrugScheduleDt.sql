----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugScheduleDt (Drug Schedule Detail)                                                     
--- 表格說明：藥品排程明細檔
--- 編訂人員：孫培然, 陳友申                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/10/22                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource; 
drop table DrugScheduleDt
create table DrugScheduleDt
(
 ScheduleNo       int                           not null, -- 排程編號
 SeqNo            tinyint                       not null, -- 優先順序
 StockNo          char(04)                      not null, -- 庫別
 SystemUser       int                           not null, -- 系統異動人員 
 SystemTime       datetime                      not null, -- 系統異動時間 
 
 constraint DrugScheduleDtPKey primary key(ScheduleNo,SeqNo,StockNo)
);    