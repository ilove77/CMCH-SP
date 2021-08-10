----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugBarCode(Drug BarCode)                                                   
--- 表格說明：藥品基本檔
--- 編訂人員：孫培然                                                                            
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/10                                                                         
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource;
--drop table DrugBarCode 
CREATE TABLE DrugBarCode 
(
 DrugCode         INT                           NOT NULL, -- 藥品代碼
 BarCode          NVARCHAR(50)                  NOT NULL, -- 國際條碼編號
 BarType          TINYINT                       NOT NULL, -- 條碼註記
                                                          ------------------------------------------
                                                          -- 10 : 內包裝                        
                                                          -- 20 : 中包裝                        
                                                          -- 30 : 外包裝                        
                                                          ------------------------------------------
 SystemUser       INT                           NOT NULL, -- 系統異動人員 
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間
 
 CONSTRAINT DrugBarCodePKey PRIMARY KEY (DrugCode,BarType)
)
CREATE INDEX DrugBarCodeKey1 ON DrugBarCode(DrugCode); 
