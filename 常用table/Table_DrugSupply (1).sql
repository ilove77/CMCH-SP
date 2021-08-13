----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugSupply(Drug Supply)                                                     
--- 表格說明：藥品供應單
--- 編訂人員：孫培然                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/08/13                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
CREATE TABLE DrugSupply
(
 SupplyNo         INT IDENTITY(1,1)             NOT NULL, -- 供應單號
 DemandNo         INT                           NOT NULL, -- 需求單號
 SupplyQty        INT                           NOT NULL, -- 供應總量
 SupplyUser       INT DEFAULT(0)                NOT NULL, -- 供應人員
 SupplyTime       DATETIME                      NOT NULL, -- 供應時間
 ReceiveUser      INT DEFAULT(0)                NOT NULL, -- 領取人員
 ReceiveTime      DATETIME                      NOT NULL, -- 領取時間
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間
 CONSTRAINT DrugSupplyPKey PRIMARY KEY (SupplyNo)
)
CREATE INDEX DrugSupplyKey1 ON DrugSupply(DemandNo);