----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugScheduleMt (Drug Schedule Master)                                                     
--- 表格說明：藥品排程主檔
--- 編訂人員：孫培然, 陳友申                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/10/22                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource; 
drop table DrugScheduleMt
CREATE TABLE DrugScheduleMt
(
 ScheduleNo       INT IDENTITY(1,1)             NOT NULL, -- 排程編號
 ScheduleName     NVARCHAR(30)                  NOT NULL, -- 排程名稱  
 SupplyStock      CHAR(04)                      NOT NULL, -- 供應庫別
 SeqNo            TINYINT                       NOT NULL, -- 優先順序
                                                          ------------------------------------------
                                                          --10：因應假日自動撥補              
                                                          --20：因應平日自動撥補              
                                                          --100：單位大瓶點滴自動撥補         
                                                          --101：藥局自動撥補                 
                                                          ------------------------------------------ 
 WeekCycle        binary(1)                     NOT NULL, -- 週期
                                                          ------------------------------------------
                                                          --二進位方式                          
                                                          ------------------------------------------
                                                          --0000001: 代表星期一, 以此類推         
                                                          ------------------------------------------
 StartDate        DATE                          NOT NULL, -- 開始日期
 EndTime          DATE DEFAULT('2999/12/31')    NOT NULL, -- 截止日期
 SystemUser       INT                           NOT NULL, -- 系統異動人員 
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間 
 
 CONSTRAINT DrugScheduleMtPKey PRIMARY KEY(ScheduleNo)
);


