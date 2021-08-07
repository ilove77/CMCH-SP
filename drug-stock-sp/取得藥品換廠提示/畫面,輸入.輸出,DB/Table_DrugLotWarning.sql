----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugLotWarning (Drug Lot Warning)                                                     
--- 表格說明：藥品批號異動提示檔
--- 編訂人員：林穎祥                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2017/11/13                                                    
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
create table DrugLotWarning
(
 StockNo          char(04)                       not null, -- 庫別編碼
 DrugCode         int                            not null, -- 藥品代碼 
 LotNo            char(20)                       not null, -- 品項批號
 StartDate        date                           not null, -- 警示開始日期
 EndDate          date                           not null, -- 警示結束日期
 Remark           nvarchar(255)                          , -- 備註說明
 SystemUser       int                            not null, -- 系統異動人員
 SystemTime       datetime                       not null, -- 系統異動時間

 constraint DrugLotWarningPKey primary key (StartDate DESC,LotNo,StockNo)
);

