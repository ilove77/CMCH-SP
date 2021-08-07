----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugTrans (Drug Transaction)                                                     
--- 表格說明：藥品庫存交易
--- 編訂人員：孫培然                                                                           
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/20                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
drop table DrugTrans  
CREATE TABLE DrugTrans  
(
 TranNo           INT IDENTITY(1,1)             NOT NULL, -- 交易編號 
 DemandNo         INT                           NOT NULL, -- 需求單號
 TranType         TINYINT                       NOT NULL, -- 交易類別
                                                          ------------------------------------------
                                                          -- 10: 期初入帳                        
                                                          -- 15: 新品入帳                        
                                                          -- 20: 訂單驗收                        
                                                          -- 21: 贈品驗收                        
                                                          -- 22: 樣品驗收                        
                                                          -- 23: 寄賣驗收                        
                                                          -- 25: 消耗                            
                                                          -- 30: 寄庫                            
                                                          -- 35: (採購)退貨                      
                                                          -- 36: (贈品)退貨                      
                                                          -- 37: (樣品)退貨                      
                                                          -- 38: (寄賣)退貨                      
                                                          -- 40: 廠商換入                        
                                                          -- 45: 廠商換出-滯品                   
                                                          -- 50: 廠商換出-不良品                 
                                                          -- 55: 樣品藥                          
                                                          -- 60: 臨床試驗用藥                    
                                                          -- 65: 研究計劃用入庫                  
                                                          -- 70: 製劑出庫                        
                                                          -- 80: 報廢或破損                      
                                                          -- 81: 退藥破損                        
                                                          --------------------------------------
                                                          --異動原因                            
                                                          --------------------------------------
                                                          --175: 撥補                           
                                                          --180: 調撥                         
                                                          --185: 移轉                         
                                                          --190: 請領                         
                                                          --191: 小領                         
                                                          --192: 藥局封裝送護理站             
                                                          --195: 退領                         
                                                          --196: 護理執行退領                 
                                                          --200: 盤點調整                     
                                                          --205: 借貨退回                     
                                                          --210: 不良品退回                   
                                                          --215: 不適用退回                   
                                                          --220: 請領錯誤退回                 
                                                          --225: 用量減少退回                 
                                                          ------------------------------------------
 DrugCode         INT                           NOT NULL, -- 藥品代碼
 InStockNo        CHAR(04)                      NOT NULL, -- 入庫庫存編號
 InStockUser      INT DEFAULT(0)                NOT NULL, -- 入庫經手人員
 InStockTime      DATETIME                      NOT NULL  -- 入庫經手時間
                  DEFAULT ('2999/12/31 00:00')          , ------------------------------------------
                                                          --2999/12/31 00:00 為 Active          
                                                          ------------------------------------------
 OutStockNo       CHAR(04)                      NOT NULL, -- 出庫庫存編號
 OutStockUser     INT DEFAULT(0)                NOT NULL, -- 出庫經手人員
 OutStockTime     DATETIME                      NOT NULL  -- 出庫經手時間
                  DEFAULT ('2999/12/31 00:00')          , ------------------------------------------
                                                          --2999/12/31 00:00 為 Active          
                                                          ------------------------------------------
 Qty              INT                           NOT NULL, -- 出入庫數量
 BatchNo          INT                           NOT NULL, -- 品項批號
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間

 CONSTRAINT DrugTransPKey PRIMARY KEY(TranNo)
)
CREATE INDEX DrugTransKey1 ON  DrugTrans(InStockNo,Qty)
CREATE INDEX DrugTransKey2 ON  DrugTrans(OutStockNo,Qty); 
CREATE INDEX DrugTransKey3 ON  DrugTrans(InStockNo,DrugCode); 
CREATE INDEX DrugTransKey4 ON  DrugTrans(OutStockNo,DrugCode); 
CREATE INDEX DrugTransKey5 ON  DrugTrans(DemandNo);
CREATE INDEX DrugTransKey6 ON  DrugTrans(InStockTime,InStockNo,Qty)   include(TranType,DrugCode);
CREATE INDEX DrugTransKey7 ON  DrugTrans(OutStockTime,OutStockNo,Qty) include(TranType,DrugCode); 