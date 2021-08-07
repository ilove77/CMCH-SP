----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugPurchaseMt (Drug Purchase Master)                                                     
--- 表格說明：藥品採購主檔
--- 編訂人員：孫培然                                                                          
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/23                                                                    
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
drop table DrugPurchaseMt
create table DrugPurchaseMt
(
 PurchaseNo       int identity(1,1)             not null, -- 採購編號
 PurchaseUser     int                           not null, -- 採購人員
 PurchaseTime     datetime                      not null, -- 採購時間
 DeliveryTime     datetime                      not null, -- 預計收貨時間
 OrgNo            char(10)                      not null, -- 廠商代碼
 ShipmentTime     datetime                      not null  -- 出貨時間 
                  default ('2999/12/31 00:00')          , ------------------------------------------
                                                          --2999/12/31 00:00 為 訂單未出貨      
                                                          ------------------------------------------
 PurchaseStatus   tinyint                       not null, -- 採購狀態
                                                          ------------------------------------------
                                                          --10: 轉採購                           
                                                          --19: (新竹)已下單欲轉入廠商系統      
                                                          --20: 已下單(新竹)已轉入廠商系統                         
                                                          --30: 已收單                          
                                                          --50: 已出貨                          
                                                          --60: 已驗收                           
                                                          --70: 已入庫                           
                                                          --80: 刪除                             
                                                          --81: 停止驗收                         
                                                          ------------------------------------------
 SendUser         int default(0)                not null, -- 採購送出人員
 SendTime         datetime                      not null  -- 採購送出時間 
                  default ('2999/12/31 00:00')          , ------------------------------------------
                                                          --2999/12/31 00:00 為 訂單未出        
                                                          ------------------------------------------
 Remark           nvarchar(255)                 not null, -- 備註說明
 SystemUser       int                           not null, -- 系統異動人員 
 SystemTime       datetime                      not null, -- 系統異動時間 

 constraint DrugPurchaseMtPKey primary key (PurchaseNo)
);
create index DrugPurchaseMtKey1 on DrugPurchaseMt(OrgNo);
create index DrugPurchaseMtKey2 on DrugPurchaseMt(DeliveryTime);
create index DrugPurchaseMtKey3 on DrugPurchaseMt(ShipmentTime);

