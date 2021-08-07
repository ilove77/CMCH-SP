----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugDemand (Drug Demand)                                                         
--- 表格說明：藥品需求單
--- 編訂人員：孫培然                                                                            
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/08/13                                                                         
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
drop table DrugDemand
create table DrugDemand
(
 DemandNo         int identity(1,1)             not null, -- 需求單號
 PurchaseNo       int default(0)                not null, -- 採購編號
 DrugCode         int                           not null, -- 藥品代碼
 DemandType       tinyint                       not null, -- 需求類別
                                                          ------------------------------------------
                                                          --10：撥補                              
                                                          --20：調撥                              
                                                          --30：移轉                              
                                                          --40：請領                              
                                                          --50：退領                              
                                                          --60：自動撥補                          
                                                         ------------------------------------------
 DemandStock      char(04)                      not null, -- 需求庫別代碼
 DemandUser       int default(0)                not null, -- 需求人員
 DemandTime       datetime                      not null, -- 需求時間
 DemandQty        int                           not null, -- 需求數量
 DemandUnit       smallint                      not null, -- 需求單位
 SupplyStock      char(04)                      not null, -- 供應庫別代碼
 SupplyQty        int                           not null, -- 實際供應總量
 TranStatus       tinyint                       not null, -- 申請狀態
                                                           -----------------------------------------
                                                          --10：申請中                          
                                                          --15：自動撥補轉單                    
                                                          --18：撥補中                          
                                                          --20：已供應                          
                                                          --25：自動撥補供應                    
                                                          --60：轉待查                          
                                                          --70：轉採購                          
                                                          --80：刪除                            
                                                          --81：停止撥補                        
                                                          ------------------------------------------
 StopReason       tinyint                       not null, -- 停用原因
                                                          ------------------------------------------
                                                          --  1： 廠商停產                      
                                                          --  2： 停止採購                      
                                                          --199： 其他                          
                                                          ------------------------------------------
 ContactExt       smallint default(0)           not null, -- 聯絡分機 
 CheckTime        datetime                      not null  -- 核對時間 
                  default ('2999/12/31 00:00:00')       , ------------------------------------------
                                                          --2999/12/31 00:00:00 為未核對出庫    
                                                          ------------------------------------------
 AuditUser        int default(0)                not null, -- 審核人員
 AuditTime        datetime                      not null  -- 審核時間 
                  default ('2999/12/31 00:00:00')       , ------------------------------------------
                                                          --2999/12/31 00:00:00 為 尚未核示     
                                                          ------------------------------------------
 Remark            nvarchar(500) default('')    not null, -- 備註說明
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間

 constraint DrugDemandPKey primary key (DemandNo)
);
create index DrugDemandKey1 on DrugDemand(DemandTime,DrugCode);
create index DrugDemandKey2 on DrugDemand(DemandStock,DemandTime,DemandType);
create index DrugDemandKey3 on DrugDemand(SupplyStock,DemandTime,DemandType); 
create index DrugDemandKey4 on DrugDemand(CheckTime,DemandStock);

-- 備註:
-- 核對出庫條碼為DrugDemandKey4, 為需求單位+核對時間(Ex: 1N1C-yyyymmddHHMMSS)
