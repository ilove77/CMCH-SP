----------------------------------------------------------------------------------------------------
--- 表格名稱：InvoiceDiscounts (Invoice Discounts)
--- 表格說明：發票折讓檔
--- 編訂人員：孫培然
--- 校閱人員：孫培然
--- 設計日期：2015/01/07
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
create table InvoiceDiscounts
(
 DiscountsNo      int identity(1,1)             not null, -- 折讓編號
 DiscountsDate    date                          not null, -- 折讓日期
 DiscountsType    tinyint                       not null, -- 折讓類別
                                                          ------------------------------------------
                                                          -- 10:訂單
                                                          -- 20:價差
                                                          -- 30:捐贈
                                                          -- 40:退款
                                                          ------------------------------------------
 InvoiceNo        char(10)                      not null, -- 發票號碼
 ItemType         tinyint                       not null, -- 採購類別
                                                          ------------------------------------------
                                                          -- 10:藥庫
                                                          -- 20:衛材
                                                          ------------------------------------------
 ItemCode         decimal(11,4)                 not null, -- 採購品項
 Amount           decimal(10,3)                 not null, -- 折讓金額
 CheckNo          int default(0)                not null, -- 驗收編號
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間
 constraint InvoiceDiscountsPKey primary key (DiscountsNo)
)
create index InvoiceDiscountsKey1 on InvoiceDiscounts(InvoiceNo);
create index InvoiceDiscountsKey2 on InvoiceDiscounts(ItemCode ,ItemType );