----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugPurchaseDt (Drug Purchase Detail)                                                     
--- 表格說明：藥品採購明細檔
--- 編訂人員：孫培然                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/23                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
--drop table DrugPurchaseDt
CREATE TABLE DrugPurchaseDt
(
 PurchaseNo       INT                           NOT NULL, -- 訂單編號
 DrugCode         INT                           NOT NULL, -- 藥品代碼
 InStockNo        CHAR(04)                      NOT NULL, -- 入庫名稱代碼
 DemandQty        INT                           NOT NULL, -- 需求數量
 PurchaseQty      INT                           NOT NULL, -- 採購數量
 GiftQty          INT                           NOT NULL, -- 贈予數量
 CheckQty         INT DEFAULT(0)                NOT NULL, -- 驗收總量
 Unit             SMALLINT                      NOT NULL, -- 訂單單位
 FollowTimes      TINYINT DEFAULT(0)            NOT NULL, -- 跟催次數
 IsDelay          BIT DEFAULT('FALSE')          NOT NULL, -- 是否延遲交貨
 IsDirectlyIn     BIT DEFAULT('FALSE')          NOT NULL, -- 是否直入單位庫 
 ClearUser        INT                           NOT NULL, -- 結清停止人員
 ClearDate        DATE DEFAULT('2999/12/31')    NOT NULL, -- 結清停止日期
 ClearReason      TINYINT DEFAULT(0)            NOT NULL, -- 結清停止原因
                                                          ----------------------------------------
                                                          --11：交貨公司換廠                     
                                                          --21：價格錯誤                         
                                                          --31：重出訂單                         
                                                          --41：交貨數量超過一半                 
                                                          --51：廠商庫存不足                     
                                                          --61：缺貨，先出部分(已先告知缺貨)     
                                                          ----------------------------------------
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間

 CONSTRAINT DrugPurchaseDtPKey PRIMARY KEY (PurchaseNo ,DrugCode)
);
CREATE INDEX DrugPurchaseDtKey1 ON DrugPurchaseDt(PurchaseNo);
CREATE INDEX DrugPurchaseDtKey2 ON DrugPurchaseDt(InStockNo);