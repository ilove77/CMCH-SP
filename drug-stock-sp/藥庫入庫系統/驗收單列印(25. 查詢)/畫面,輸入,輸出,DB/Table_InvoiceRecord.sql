----------------------------------------------------------------------------------------------------
--- 表格名稱：InvoiceRecord (Invoice Record)
--- 表格說明：發票基本檔
--- 編訂人員：孫培然
--- 校閱人員：孫培然
--- 設計日期：2015/01/07
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
create table InvoiceRecord
(
 InvoiceNo        char(10)                      not null, -- 發票號碼
 InvoiceDate      date                          not null, -- 發票日期
 TaxType          tinyint                       not null, -- 營業稅別
                                                          ------------------------------------------
                                                          -- 10: 應稅
                                                          -- 20: 未稅
                                                          -- 30: 免稅
                                                          ------------------------------------------
 InvoicePrice     decimal(10,3)                 not null, -- 發票總金額
 InvoiceStatus    tinyint default(10)           not null, -- 發票狀態
 InvoiceType      tinyint default(10)           not null, -- 發票類別
                                                          ------------------------------------------
                                                          -- 10: 紙本發票
                                                          -- 20: 電子發票
                                                          -- 30: 收據證明
                                                          -- 100:贈品/樣品
                                                          ------------------------------------------
 AdjustPrice      decimal(10,3)                 not null, -- 調整金額
 RealPayAmount    int                           not null, -- 實付總金額
 PurchaseNo       int                           not null, -- 訂單編號
 VoucherNo        char(12) default('')          not null, -- 傳票號碼
 PayDate          date  default ('2999/12/31')  not null, -- 付款日期
                                                          ------------------------------------------
                                                          -- 2999/12/31 為 未付款
                                                          ------------------------------------------
 TranStatus       tinyint default(10)           not null, -- 最近異動狀態
                                                          ------------------------------------------
                                                          -- 10 :發票登錄
                                                          -- 20 :發票驗收
                                                          -- 30 :採購核對完成
                                                          -- 31 :採購主管審核
                                                          -- 32 :採購主管核對完成
                                                          -- 35 :會計暫存
                                                          -- 37 :會計核對完成(轉入舊系統中)
                                                          -- 40 :會計核對完成
                                                          -- 60 :確認登錄(產生傳票)
                                                          -- 70 :會計已過帳(已付款)
                                                          -- 80 :發票作廢
                                                          ------------------------------------------
 Remark           nvarchar(50)                      null, -- 備註說明
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間
 constraint InvoiceRecordPKey primary key (InvoiceNo)
)
create index InvoiceRecordKey1 on InvoiceRecord(PurchaseNo);