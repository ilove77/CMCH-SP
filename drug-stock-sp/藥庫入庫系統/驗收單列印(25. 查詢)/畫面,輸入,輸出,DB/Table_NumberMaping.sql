----------------------------------------------------------------------------------------------------
--- 表格名稱：NumberMaping (Number Maping)
--- 表格說明：號碼對照檔
--- 編訂人員：王勇順
--- 校閱人員：孫培然
--- 設計日期：2017/07/21
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;

create table NumberMaping
( 
 BranchNo         tinyint                       not null, -- 院區代碼
 NumberType       tinyint                       not null, -- 號碼類別
 SourceNo         int                           not null, -- 來源編號
 DisplayNo        int                           not null, -- 呈現編號
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間

 constraint NumberMapingPKey primary key (SourceNo,NumberType,BranchNo,DisplayNo)
)
 create index NumberMapingKey1 on NumberMaping(BranchNo,NumberType,DisplayNo DESC);