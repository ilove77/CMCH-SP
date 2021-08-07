----------------------------------------------------------------------------------------------------
--- 表格名稱：PurchaseBasic (Purchase Basic)
--- 表格說明：採購基本檔
--- 編訂人員：孫培然
--- 校閱人員：孫培然
--- 修訂日期：2020/11/23
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource; 
create table PurchaseBasic 
(
 ItemCode         decimal(11,4)                 not null, -- 項目代碼
                                                          ------------------------------------------
                                                          -- 項目類別20時:衛材代碼+小數點為規格代碼(4碼)
                                                          ------------------------------------------
 ItemType         tinyint                       not null, -- 項目類別
                                                          ------------------------------------------
                                                          -- 10:藥庫
                                                          -- 20:衛材
                                                          ------------------------------------------
 Represent        char(10)                      not null, -- 經銷商
 Manufactory      char(10)                      not null, -- 廠牌
 SupplierNo       char(10)                      not null, -- 供應商編號
 LicenseNo        nvarchar(60)                  not null, -- 衛生署許可證號
 LicenseNoDate    date                          not null, -- 許可證期限
 PayDeadline      tinyint                       not null, -- 付款期限(月)
 BuyRatio         tinyint default(1)            not null, -- 買入比率
 GiveRatio        tinyint default(0)            not null, -- 贈送比率
 DonatePrice      decimal(10,2)                 not null, -- 外捐金額
 CostPrice        decimal(10,3)                 not null, -- 成本金額
 ExpiryDate       date                          not null, -- 合約到期日
 WarnDate         date default('2999/12/31')    not null, -- 停用警告日
                                                          ------------------------------------------
                                                          -- 2999/12/31 為 Active
                                                          ------------------------------------------
 Remark           nvarchar(50)                      null, -- 備註說明
 StartTime        datetime                      not null, -- 開始時間
 EndTime          datetime                      not null  -- 截止時間
                  default ('2999/12/31 00:00')          , ------------------------------------------
                                                          -- 2999/12/31 00:00 為 Active
                                                          ------------------------------------------
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間
 
 constraint PurchaseBasicPKey primary key (ItemCode,ItemType,StartTime DESC)
)
create index PurchaseBasicKey1 on PurchaseBasic(Represent);
create index PurchaseBasicKey2 on PurchaseBasic(Manufactory);
create unique index PurchaseBasicKey3 on PurchaseBasic(ItemCode,ItemType,EndTime DESC);
create index PurchaseBasicKey4 on PurchaseBasic(ItemCode);

-- 備註：
-- 贈送量計算 = 購買數量 * 贈送比率 / (買入比率 + 贈送比率)
-- 付款期限 = 幾個月內要付款完成
-- 外捐金額 = 非折讓金額，處理方式為年後依照採買量請廠商至出納組繳捐款