----------------------------------------------------------------------------------------------------
--- 表格名稱：PurchaseBasic (Purchase Basic)
--- 表格說明：採購基本檔
--- 編訂人員：孫培然
--- 校閱人員：孫培然
--- 修訂日期：2020/11/23
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource; 
CREATE TABLE PurchaseBasic 
(
 ItemCode         DECIMAL(12,4)                 NOT NULL, -- 項目代碼
                                                          ------------------------------------------
                                                          -- 項目類別20時:衛材代碼+小數點為規格代碼(4碼)
                                                          ------------------------------------------
 ItemType         TINYINT                       NOT NULL, -- 項目類別
                                                          ------------------------------------------
                                                          -- 10:藥庫
                                                          -- 20:衛材
                                                          ------------------------------------------
 Represent        CHAR(10)                      NOT NULL, -- 經銷商
 Manufactory      CHAR(10)                      NOT NULL, -- 廠牌
 SupplierNo       CHAR(10)                      NOT NULL, -- 供應商編號
 LicenseNo        NVARCHAR(60)                  NOT NULL, -- 衛生署許可證號
 LicenseNoDate    DATE                          NOT NULL, -- 許可證期限
 PayDeadline      TINYINT                       NOT NULL, -- 付款期限(月)
 BuyRatio         TINYINT DEFAULT(1)            NOT NULL, -- 買入比率
 GiveRatio        TINYINT DEFAULT(0)            NOT NULL, -- 贈送比率
 DonatePrice      DECIMAL(10,2)                 NOT NULL, -- 外捐金額
 CostPrice        DECIMAL(10,3)                 NOT NULL, -- 成本金額
 ExpiryDate       DATE                          NOT NULL, -- 合約到期日
 WarnDate         DATE DEFAULT('2999/12/31')    NOT NULL, -- 停用警告日
                                                          ------------------------------------------
                                                          -- 2999/12/31 為 Active
                                                          ------------------------------------------
 Remark           NVARCHAR(50)                      NULL, -- 備註說明
 StartTime        DATETIME                      NOT NULL, -- 開始時間
 EndTime          DATETIME                      NOT NULL  -- 截止時間
                  DEFAULT ('2999/12/31 00:00')          , ------------------------------------------
                                                          -- 2999/12/31 00:00 為 Active
                                                          ------------------------------------------
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間
 
 CONSTRAINT PurchaseBasicPKey PRIMARY KEY (ItemCode,ItemType,StartTime DESC)
)
CREATE INDEX PurchaseBasicKey1 ON PurchaseBasic(Represent);
CREATE INDEX PurchaseBasicKey2 ON PurchaseBasic(Manufactory);
CREATE UNIQUE INDEX PurchaseBasicKey3 ON PurchaseBasic(ItemCode,ItemType,EndTime DESC);
CREATE INDEX PurchaseBasicKey4 ON PurchaseBasic(ItemCode);

-- 備註：
-- 贈送量計算 = 購買數量 * 贈送比率 / (買入比率 + 贈送比率)
-- 付款期限 = 幾個月內要付款完成
-- 外捐金額 = 非折讓金額，處理方式為年後依照採買量請廠商至出納組繳捐款