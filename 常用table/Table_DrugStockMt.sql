----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugStockMt (Drug Stock Master)                                                     
--- 表格說明：藥品庫存檔
--- 編訂人員：孫培然                                                                           
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/20 
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
CREATE TABLE DrugStockMt  
(
 StockNo          CHAR(04)                      NOT NULL, -- 庫別編碼
 DrugCode         INT                           NOT NULL, -- 藥品代碼 
 StockUnit        SMALLINT                      NOT NULL, -- 庫存單位
 StockRatio       SMALLINT                      NOT NULL, -- 庫存轉換比 
 PackageQty       INT DEFAULT(1)                NOT NULL, -- 最小採購量
 PurchaseDays     TINYINT DEFAULT(7)            NOT NULL, -- 訂購基數(天)
 WarnDays         TINYINT                       NOT NULL, -- 預警天數 / 藥局品項N值天數
 PurchaseQty      INT                           NOT NULL, -- 每基數訂購量
 ReorderPoint     INT                           NOT NULL, -- 訂購點
 SafetyQty        INT                           NOT NULL, -- 安全量
 TotalQty         INT                           NOT NULL, -- 庫存總量(Dt 每筆的總和)          
 MaxQty           INT                           NOT NULL, -- 最高存量(請購上限量=最高存量-庫存量)
 SupplyType       TINYINT                       NOT NULL, -- 供應方式
                                                          ------------------------------------------
                                                          -- 10: 自動撥補                        
                                                          -- 20: 消耗請領                        
                                                          ------------------------------------------
 DrugType         SMALLINT DEFAULT(0)           NOT NULL, -- 藥品分類
                                                          ------------------------------------------
                                                          -- 10: 庫備(大瓶點滴)               
                                                          -- 11: 常備                         
                                                          -- 21: 臨採(非專案)                 
                                                          -- 31: 臨採(專案)                   
                                                          -- 41: 准常備                       
                                                          -- 51: 樣品藥                       
                                                          -- 61: 臨床試驗用藥                 
                                                          -- 71: 寄庫                         
                                                          -- 81: 製劑                         
                                                          -- 91: 代發                         
                                                          --101: 食品                         
                                                          --110: 不計價                        
                                                          --111: 不計價(庫備)                  
                                                          --112: 不計價(常備)                  
                                                          ------------------------------------------
 KeepType         SMALLINT DEFAULT(30)          NOT NULL, -- 保存方式
                                                          ------------------------------------------
                                                          -- 30: 零下30℃以下                   
                                                          -- -1: 冷凍                          
                                                          --  8: 2~8度C                        
                                                          -- 25: 25℃以下                       
                                                          -- 30: 30℃以下                       
                                                          ------------------------------------------
 PurchaseType     TINYINT DEFAULT(0)            NOT NULL, -- 採購單分類
                                                          ------------------------------------------
                                                          --  5: (上月消耗/25(一個月=25天))*12天
                                                          -- 10: 藥庫庫存加藥局庫存小於安全存量 
                                                          -- 11: 藥庫庫存加在途量小於安全存量   
                                                          -- 13: 需要時採購                     
                                                          -- 15: (1月內慢籤量/3)+1月以上領取>未領
                                                          -- 20: 自動撥補轉採購單  
                                                          -- 30: 直入庫              
                                                          -- 80: 停止採購                        
                                                          ------------------------------------------ 
 InvType          TINYINT DEFAULT(0)            NOT NULL, -- 藥庫分類
                                                          ------------------------------------------
                                                          -- 10: 進口藥品                  
                                                          -- 15: 進口臨採藥品              
                                                          -- 20: 進口臨採藥品(不計價)      
                                                          -- 25: 國產                      
                                                          -- 30: 國產臨採                  
                                                          -- 35: 透析室透析品項            
                                                          -- 40: 公費品項                  
                                                          -- 45: 臨床試驗藥品(報表不列印)  
                                                          -- 50: 毒物科品項                
                                                          -- 55: 氣體                      
                                                          -- 60: 核醫品項                  
                                                          ------------------------------------------
 StorageNo        VARCHAR(30)                   NOT NULL, -- 儲位號碼
                                                            ------------------------------------------
                                                          -- 多筆以逗號隔開                     
                                                          ------------------------------------------
 SupplyStock      CHAR(04)                      NOT NULL, -- 供應庫別
 IsComplexIn      BIT DEFAULT('FALSE')          NOT NULL, -- 是否廠商協助直入
 IsInvList        BIT DEFAULT('TRUE')           NOT NULL, -- 是否盤點列出(true/false)
 StartTime        DATETIME                      NOT NULL, -- 起初時間
 EndTime          DATETIME                      NOT NULL  -- 停用時間
                  DEFAULT ('2999/12/31 00:00')          , ------------------------------------------
                                                          --2999/12/31 00:00 為 Active          
                                                          ------------------------------------------
 LastTime         DATETIME                      NOT NULL, -- 最近結清時間
 LastQty          INT                           NOT NULL, -- 最近結清數量
 MonthTime        DATETIME                      NOT NULL, -- 最近月結時間(最近消耗時間)
 MonthQty         INT                           NOT NULL, -- 最近月結數量(未滿轉換比剩餘消耗量)
 InvTime          DATETIME                      NOT NULL, -- 最近盤點時間
 InvQty           INT                           NOT NULL, -- 最近盤點數量
 SystemUser       INT                           NOT NULL, -- 系統異動人員 
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間 

 CONSTRAINT DrugStockMtPKey PRIMARY KEY (StockNo,DrugCode)
)
CREATE UNIQUE INDEX DrugStockMtKey1 ON DrugStockMt(DrugCode,StockNo);
 

 

--
--
-- 備註：
-- 耗用量標準差=每周定期計算前連續14天平均出庫量標準差
-- 安全存量=安全係數*√最長交貨期*耗用量標準差
-- 平均耗用量=每週定期計算前連續30天平均出庫量
-- 訂購點=安全存量+平均耗用量*最長交貨期
