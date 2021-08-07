----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugTrans (Drug Transaction)                                                     
--- 表格說明：藥品庫存交易
--- 編訂人員：孫培然                                                                           
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/20                                                     
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
drop table DrugTrans  
create table DrugTrans  
(
 TranNo           int identity(1,1)             not null, -- 交易編號 
 DemandNo         int                           not null, -- 需求單號
 TranType         tinyint                       not null, -- 交易類別
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
 DrugCode         int                           not null, -- 藥品代碼
 InStockNo        char(04)                      not null, -- 入庫庫存編號
 InStockUser      int default(0)                not null, -- 入庫經手人員
 InStockTime      datetime                      not null  -- 入庫經手時間
                  default ('2999/12/31 00:00')          , ------------------------------------------
                                                          --2999/12/31 00:00 為 Active          
                                                          ------------------------------------------
 OutStockNo       char(04)                      not null, -- 出庫庫存編號
 OutStockUser     int default(0)                not null, -- 出庫經手人員
 OutStockTime     datetime                      not null  -- 出庫經手時間
                  default ('2999/12/31 00:00')          , ------------------------------------------
                                                          --2999/12/31 00:00 為 Active          
                                                          ------------------------------------------
 Qty              int                           not null, -- 出入庫數量
 BatchNo          int                           not null, -- 品項批號
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間

 constraint DrugTransPKey primary key(TranNo)
)
create index DrugTransKey1 on  DrugTrans(InStockNo,Qty)
create index DrugTransKey2 on  DrugTrans(OutStockNo,Qty); 
create index DrugTransKey3 on  DrugTrans(InStockNo,DrugCode); 
create index DrugTransKey4 on  DrugTrans(OutStockNo,DrugCode); 
create index DrugTransKey5 on  DrugTrans(DemandNo);
create index DrugTransKey6 on  DrugTrans(InStockTime,InStockNo,Qty)   include(TranType,DrugCode);
create index DrugTransKey7 on  DrugTrans(OutStockTime,OutStockNo,Qty) include(TranType,DrugCode); 