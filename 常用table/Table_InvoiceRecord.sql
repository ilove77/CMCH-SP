----------------------------------------------------------------------------------------------------
--- 表格名稱：InvoiceRecord (Invoice Record)
--- 表格說明：發票基本檔
--- 編訂人員：孫培然
--- 校閱人員：孫培然
--- 設計日期：2015/01/07
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
CREATE TABLE InvoiceRecord
(
 InvoiceNo        CHAR(10)                      NOT NULL, -- 發票號碼
 InvoiceDate      DATE                          NOT NULL, -- 發票日期
 TaxType          TINYINT                       NOT NULL, -- 營業稅別
                                                          ------------------------------------------
                                                          -- 10: 應稅
                                                          -- 20: 未稅
                                                          -- 30: 免稅
                                                          ------------------------------------------
 InvoicePrice     DECIMAL(10,3)                 NOT NULL, -- 發票總金額
 InvoiceStatus    TINYINT DEFAULT(10)           NOT NULL, -- 發票狀態
 InvoiceType      TINYINT DEFAULT(10)           NOT NULL, -- 發票類別
                                                          ------------------------------------------
                                                          -- 10: 紙本發票
                                                          -- 20: 電子發票
                                                          -- 30: 收據證明
                                                          -- 100:贈品/樣品
                                                          ------------------------------------------
 AdjustPrice      DECIMAL(10,3)                 NOT NULL, -- 調整金額
 RealPayAmount    INT                           NOT NULL, -- 實付總金額
 PurchaseNo       INT                           NOT NULL, -- 訂單編號
 VoucherNo        CHAR(12) DEFAULT('')          NOT NULL, -- 傳票號碼
 PayDate          DATE  DEFAULT ('2999/12/31')  NOT NULL, -- 付款日期
                                                          ------------------------------------------
                                                          -- 2999/12/31 為 未付款
                                                          ------------------------------------------
 TranStatus       TINYINT DEFAULT(10)           NOT NULL, -- 最近異動狀態
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
 Remark           NVARCHAR(50)                      NULL, -- 備註說明
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間
 CONSTRAINT InvoiceRecordPKey PRIMARY KEY (InvoiceNo)
)
CREATE INDEX InvoiceRecordKey1 ON InvoiceRecord(PurchaseNo);