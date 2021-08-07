----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugChecking (Drug Checking)                                                         
--- 表格說明：驗收紀錄檔
--- 編訂人員：孫培然                                                                            
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/23                                                                         
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
drop table DrugChecking
CREATE TABLE DrugChecking
(
 CheckNo          INT IDENTITY(1,1)             NOT NULL, -- 驗收編號
 PurchaseNo       INT                           NOT NULL, -- 訂單編號
                                                          ------------------------------------------
                                                          -- 訂單編號 = 0 表示 <贈品訂單>       
                                                          ------------------------------------------
 CheckType        TINYINT                       NOT NULL, -- 驗收類別
                                                          ------------------------------------------
                                                          -- 10：訂單驗收                       
                                                          -- 20：贈品驗收                       
                                                          -- 30：樣品驗收                       
                                                          -- 40：寄賣驗收                       
                                                          ------------------------------------------
 DrugCode         INT                           NOT NULL, -- 藥品代碼
 CheckUser        INT                           NOT NULL, -- 驗收人員
 CheckTime        DATETIME                      NOT NULL, -- 驗收時間
 CheckQty         INT                           NOT NULL, -- 驗收數量
 InvoiceNo        CHAR(10)                      NOT NULL, -- 發票號碼
 PayDate          DATE                          NOT NULL, -- 應付日期
 PayAmount        DECIMAL(10,3)                 NOT NULL, -- 應付金額
 AdjustAmount     DECIMAL(10,3)                 NOT NULL, -- 調整金額
 OldPrice         DECIMAL(9,3)                  NOT NULL, -- 原始單價
 NewPrice         DECIMAL(9,3)                  NOT NULL, -- 調整單價
 BatchNo          INT                           NOT NULL, -- 品項批號
 CheckStatus      TINYINT                       NOT NULL, -- 驗收狀態
                                                          ------------------------------------------
                                                          -- 10：匯入                          
                                                          -- 20：驗收                          
                                                          -- 30：過帳入庫                      
                                                          -- 40：採購核對                      
                                                          -- 80：刪除                          
                                                          ------------------------------------------
 AcceptUser       INT                           NOT NULL, -- 接受人員
 AcceptTime       DATETIME                      NOT NULL, -- 接受時間
 InStockNo        CHAR(04)                      NOT NULL, -- 入庫代碼
 InStockTime      DATETIME                      NOT NULL  -- 入庫時間
                  DEFAULT ('2999/12/31 00:00')          , ------------------------------------------
                                                          -- 2999/12/31 00:00 為 未訂單入庫過帳  
                                                          ------------------------------------------
 AdjustRemark     NVARCHAR(200)                 NOT NULL, -- 調整備註
 DebitReason      NVARCHAR(200)                 NOT NULL, -- 扣款原因
 SendRemark       NVARCHAR(50)                  NOT NULL, -- 傳送說明
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間

 CONSTRAINT DrugCheckingPKey PRIMARY KEY (CheckNo)
);
CREATE INDEX DrugCheckingKey1 ON DrugChecking(PurchaseNo);
CREATE INDEX DrugCheckingKey2 ON DrugChecking(InStockNo , DrugCode);
CREATE INDEX DrugCheckingKey3 ON DrugChecking(DrugCode);
CREATE INDEX DrugCheckingKey4 ON DrugChecking(InvoiceNo);
CREATE INDEX DrugCheckingKey5 ON DrugChecking(CheckTime,CheckStatus);
CREATE INDEX DrugCheckingKey6 ON DrugChecking(PayDate,CheckStatus);