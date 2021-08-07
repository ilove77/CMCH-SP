----------------------------------------------------------------------------------------------------
--- 表格名稱：OptionItem (Option Item)  
--- 表格說明：選項名稱檔
--- 編訂人員：孫培然
--- 校閱人員：孫培然
--- 設計日期：2015/07/10
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;

create table OptionItem
(
 TableName        varchar(20)                   not null, -- 表格名稱
 FieldName        varchar(30)                   not null, -- 欄位名稱
 OptionNo         tinyint                       not null, -- 選項代號
 OptionName       nvarchar(50)                  not null, -- 選項名稱
 SystemUser       int                           not null, -- 最後異動人員
 SystemTime       datetime                      not null, -- 最後異動時間

 constraint OptionItemPKey primary key(TableName,FieldName,OptionNo)
);