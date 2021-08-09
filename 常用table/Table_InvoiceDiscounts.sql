----------------------------------------------------------------------------------------------------
--- 表格名稱：InvoiceDiscounts (Invoice Discounts)
--- 表格說明：發票折讓檔
--- 編訂人員：孫培然
--- 校閱人員：孫培然
--- 設計日期：2015/01/07
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
CREATE TABLE InvoiceDiscounts
(
 DiscountsNo      INT IDENTITY(1,1)             NOT NULL, -- 折讓編號
 DiscountsDate    DATE                          NOT NULL, -- 折讓日期
 DiscountsType    TINYINT                       NOT NULL, -- 折讓類別
                                                          ------------------------------------------
                                                          -- 10:訂單
                                                          -- 20:價差
                                                          -- 30:捐贈
                                                          -- 40:退款
                                                          ------------------------------------------
 InvoiceNo        CHAR(10)                      NOT NULL, -- 發票號碼
 ItemType         TINYINT                       NOT NULL, -- 採購類別
                                                          ------------------------------------------
                                                          -- 10:藥庫
                                                          -- 20:衛材
                                                          ------------------------------------------
 ItemCode         DECIMAL(12,4)                 NOT NULL, -- 採購品項
 Amount           DECIMAL(10,3)                 NOT NULL, -- 折讓金額
 CheckNo          INT DEFAULT(0)                NOT NULL, -- 驗收編號
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間
 CONSTRAINT InvoiceDiscountsPKey PRIMARY KEY (DiscountsNo)
)
CREATE INDEX InvoiceDiscountsKey1 ON InvoiceDiscounts(InvoiceNo);
CREATE INDEX InvoiceDiscountsKey2 ON InvoiceDiscounts(ItemCode ,ItemType );