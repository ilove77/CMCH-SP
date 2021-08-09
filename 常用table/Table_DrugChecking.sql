----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugChecking (Drug Checking)                                                         
--- 表格說明：驗收紀錄檔
--- 編訂人員：孫培然                                                                            
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/23                                                                         
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
drop table DrugChecking
create table DrugChecking
(
 CheckNo          int identity(1,1)             not null, -- 驗收編號
 PurchaseNo       int                           not null, -- 訂單編號
                                                          ------------------------------------------
                                                          -- 訂單編號 = 0 表示 <贈品訂單>       
                                                          ------------------------------------------
 CheckType        tinyint                       not null, -- 驗收類別
                                                          ------------------------------------------
                                                          -- 10：訂單驗收                       
                                                          -- 20：贈品驗收                       
                                                          -- 30：樣品驗收                       
                                                          -- 40：寄賣驗收                       
                                                          ------------------------------------------
 DrugCode         int                           not null, -- 藥品代碼
 CheckUser        int                           not null, -- 驗收人員
 CheckTime        datetime                      not null, -- 驗收時間
 CheckQty         int                           not null, -- 驗收數量
 InvoiceNo        char(10)                      not null, -- 發票號碼
 PayDate          date                          not null, -- 應付日期
 PayAmount        decimal(10,3)                 not null, -- 應付金額
 AdjustAmount     decimal(10,3)                 not null, -- 調整金額
 OldPrice         decimal(9,3)                  not null, -- 原始單價
 NewPrice         decimal(9,3)                  not null, -- 調整單價
 BatchNo          int                           not null, -- 品項批號
 CheckStatus      tinyint                       not null, -- 驗收狀態
                                                          ------------------------------------------
                                                          -- 10：匯入                          
                                                          -- 20：驗收                          
                                                          -- 30：過帳入庫                      
                                                          -- 40：採購核對                      
                                                          -- 80：刪除                          
                                                          ------------------------------------------
 AcceptUser       int                           not null, -- 接受人員
 AcceptTime       datetime                      not null, -- 接受時間
 InStockNo        char(04)                      not null, -- 入庫代碼
 InStockTime      datetime                      not null  -- 入庫時間
                  default ('2999/12/31 00:00')          , ------------------------------------------
                                                          -- 2999/12/31 00:00 為 未訂單入庫過帳  
                                                          ------------------------------------------
 AdjustRemark     nvarchar(200)                 not null, -- 調整備註
 DebitReason      nvarchar(200)                 not null, -- 扣款原因
 SendRemark       nvarchar(50)                  not null, -- 傳送說明
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間

 constraint DrugCheckingPKey primary key (CheckNo)
);
create index DrugCheckingKey1 on DrugChecking(PurchaseNo);
create index DrugCheckingKey2 on DrugChecking(InStockNo , DrugCode);
create index DrugCheckingKey3 on DrugChecking(DrugCode);
create index DrugCheckingKey4 on DrugChecking(InvoiceNo);
create index DrugCheckingKey5 on DrugChecking(CheckTime,CheckStatus);
create index DrugCheckingKey6 on DrugChecking(PayDate,CheckStatus);