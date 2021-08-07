----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugSupply(Drug Supply)                                                     
--- 表格說明：藥品供應單
--- 編訂人員：孫培然                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/08/13                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
create table DrugSupply
(
 SupplyNo         int identity(1,1)             not null, -- 供應單號
 DemandNo         int                           not null, -- 需求單號
 SupplyQty        int                           not null, -- 供應總量
 SupplyUser       int default(0)                not null, -- 供應人員
 SupplyTime       datetime                      not null, -- 供應時間
 ReceiveUser      int default(0)                not null, -- 領取人員
 ReceiveTime      datetime                      not null, -- 領取時間
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間
 constraint DrugSupplyPKey primary key (SupplyNo)
)
create index DrugSupplyKey1 on DrugSupply(DemandNo);