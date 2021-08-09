----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugDemand (Drug Demand)                                                         
--- 表格說明：藥品需求單
--- 編訂人員：孫培然                                                                            
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/08/13                                                                         
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
drop table DrugDemand
CREATE TABLE DrugDemand
(
 DemandNo         INT IDENTITY(1,1)             NOT NULL, -- 需求單號
 PurchaseNo       INT DEFAULT(0)                NOT NULL, -- 採購編號
 DrugCode         INT                           NOT NULL, -- 藥品代碼
 DemandType       TINYINT                       NOT NULL, -- 需求類別
                                                          ------------------------------------------
                                                          --10：撥補                              
                                                          --20：調撥                              
                                                          --30：移轉                              
                                                          --40：請領 
                                                          --45: 小領                                                                         
                                                          --50：退領                              
                                                          --60：自動撥補                          
                                                         ------------------------------------------
 DemandStock      CHAR(04)                      NOT NULL, -- 需求庫別代碼
 DemandUser       INT DEFAULT(0)                NOT NULL, -- 需求人員
 DemandTime       DATETIME                      NOT NULL, -- 需求時間
 DemandQty        INT                           NOT NULL, -- 需求數量
 DemandUnit       SMALLINT                      NOT NULL, -- 需求單位
 SupplyStock      CHAR(04)                      NOT NULL, -- 供應庫別代碼
 SupplyQty        INT                           NOT NULL, -- 實際供應總量
 TranStatus       TINYINT                       NOT NULL, -- 申請狀態
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
 StopReason       TINYINT                       NOT NULL, -- 停用原因
                                                          ------------------------------------------
                                                          --  1： 廠商停產                      
                                                          --  2： 停止採購                      
                                                          --199： 其他                          
                                                          ------------------------------------------
 ContactExt       SMALLINT DEFAULT(0)           NOT NULL, -- 聯絡分機 
 CheckTime        DATETIME                      NOT NULL  -- 核對時間 
                  DEFAULT ('2999/12/31 00:00:00')       , ------------------------------------------
                                                          --2999/12/31 00:00:00 為未核對出庫    
                                                          ------------------------------------------
 AuditUser        INT DEFAULT(0)                NOT NULL, -- 審核人員
 AuditTime        DATETIME                      NOT NULL  -- 審核時間 
                  DEFAULT ('2999/12/31 00:00:00')       , ------------------------------------------
                                                          --2999/12/31 00:00:00 為 尚未核示     
                                                          ------------------------------------------
 Remark            NVARCHAR(500) DEFAULT('')    NOT NULL, -- 備註說明
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間

 CONSTRAINT DrugDemandPKey PRIMARY KEY (DemandNo)
);
CREATE INDEX DrugDemandKey1 ON DrugDemand(DemandTime,DrugCode);
CREATE INDEX DrugDemandKey2 ON DrugDemand(DemandStock,DemandTime,DemandType);
CREATE INDEX DrugDemandKey3 ON DrugDemand(SupplyStock,DemandTime,DemandType); 
CREATE INDEX DrugDemandKey4 ON DrugDemand(CheckTime,DemandStock);

-- 備註:
-- 核對出庫條碼為DrugDemandKey4, 為需求單位+核對時間(Ex: 1N1C-yyyymmddHHMMSS)
