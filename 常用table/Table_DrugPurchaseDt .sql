----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugPurchaseDt (Drug Purchase Detail)                                                     
--- 表格說明：藥品採購明細檔
--- 編訂人員：孫培然                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/23                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
--drop table DrugPurchaseDt
create table DrugPurchaseDt
(
 PurchaseNo       int                           not null, -- 訂單編號
 DrugCode         int                           not null, -- 藥品代碼
 InStockNo        char(04)                      not null, -- 入庫名稱代碼
 DemandQty        int                           not null, -- 需求數量
 PurchaseQty      int                           not null, -- 採購數量
 GiftQty          int                           not null, -- 贈予數量
 CheckQty         int default(0)                not null, -- 驗收總量
 Unit             smallint                      not null, -- 訂單單位
 FollowTimes      tinyint default(0)            not null, -- 跟催次數
 IsDelay          bit default('false')          not null, -- 是否延遲交貨
 IsDirectlyIn     bit default('false')          not null, -- 是否直入單位庫 
 ClearUser        int                           not null, -- 結清停止人員
 ClearDate        date default('2999/12/31')    not null, -- 結清停止日期
 ClearReason      tinyint default(0)            not null, -- 結清停止原因
                                                          ----------------------------------------
                                                          --11：交貨公司換廠                     
                                                          --21：價格錯誤                         
                                                          --31：重出訂單                         
                                                          --41：交貨數量超過一半                 
                                                          --51：廠商庫存不足                     
                                                          --61：缺貨，先出部分(已先告知缺貨)     
                                                          ----------------------------------------
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間

 constraint DrugPurchaseDtPKey primary key (PurchaseNo ,DrugCode)
);
create index DrugPurchaseDtKey1 on DrugPurchaseDt(PurchaseNo);
create index DrugPurchaseDtKey2 on DrugPurchaseDt(InStockNo);