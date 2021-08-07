----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugBasic (Drug Basic)                                                            
--- 表格說明：藥品基本檔
--- 編訂人員：孫培然                                                                            
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/10                                                                         
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthResource; 
--drop table DrugBasic;
CREATE TABLE DrugBasic 
(
 DrugCode         INT                           NOT NULL, -- 藥品代碼
                                                          ------------------------------------------
                                                          -- 自行編碼，取最大號+1  
                                                          ------------------------------------------
 NhiCode          CHAR(12)                      NOT NULL, -- 健保藥品碼
 DrugName         NVARCHAR(100)                 NOT NULL, -- 院內藥品名
 BrandName1       VARCHAR(100)                  NOT NULL, -- 商品名(英文)
 BrandName2       NVARCHAR(100)                 NOT NULL, -- 商品名(中文)
 GenericName1     VARCHAR(100)                  NOT NULL, -- 學名(英文)
 GenericName2     NVARCHAR(100)                 NOT NULL, -- 學名(中文)
 Dosage           DECIMAL(7,2)                  NOT NULL, -- 劑量
 UsageNo          SMALLINT                      NOT NULL, -- 頻率代號
 UsedTimeNo       SMALLINT                      NOT NULL, -- 使用時間點
                                                          ------------------------------------------
                                                          -- 10:  AC                              
                                                          ------------------------------------------
                                                          -- AC(x) (x代表飯前小時數), 如下所示   
                                                          --   11:  AC1 -- 代表飯前1小時          
                                                          --   12:  AC2 -- 代表飯前2小時          
                                                          --   13:  AC3 -- 代表飯前3小時          
                                                          -- 以此類推                             
                                                          ------------------------------------------
                                                          --  20:  PC                              
                                                          ------------------------------------------
                                                          -- PC(x) (x代表飯後小時數), 如下所示   
                                                          --   11:  AC1 -- 代表飯後1小時          
                                                          --   12:  AC2 -- 代表飯後2小時          
                                                          --   13:  AC3 -- 代表飯後3小時          
                                                          -- 以此類推                             
                                                          ------------------------------------------
 WayNo            SMALLINT                      NOT NULL, -- 途徑代號
 DosageForms      TINYINT                       NOT NULL, -- 劑型 (參考DrugOption)
 DrugType         SMALLINT                      NOT NULL, -- 藥品分類
                                                          ------------------------------------------
                                                          --  11: 常備                              
                                                          --  21: 臨採(非專案)                      
                                                          --  31: 臨採(專案)                     
                                                          --  41: 准常備                          
                                                          --  51: 樣品藥                          
                                                          --  61: 臨床試驗用藥                      
                                                          --  71: 寄庫                              
                                                          --  81: 製劑                              
                                                          --  91: 代發                              
                                                          -- 101: 食品                              
                                                          ------------------------------------------
 InvType          TINYINT                       NOT NULL, -- 藥庫分類
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
 PurchaseType      TINYINT                      NOT NULL, -- 採購單分類
                                                          ------------------------------------------
                                                          --  5: (上月消耗/25(一個月=25天))*12天 
                                                          -- 10: 藥庫庫存加藥局庫存小於安全存量      
                                                          -- 11: 藥庫庫存加在途量小於安全存量      
                                                          -- 13: 需要時採購                        
                                                          -- 15: (1月內慢籤量/3)+1月以上領取>未領
                                                          -- 20: 自動撥補轉採購單                 
                                                          -- 80: 停止採購                          
                                                          ------------------------------------------
 ControlDrug       TINYINT                      NOT NULL, -- 管控藥註記
                                                          ------------------------------------------
                                                          --  0: 一般藥品                        
                                                          -- 11: 一級管制藥                      
                                                          -- 12: 二級管制藥                      
                                                          -- 13: 三級管制藥                      
                                                          -- 14: 四級管制藥                      
                                                          -- 19: 本院管制藥                      
                                                          -- 41: 化療藥 (針劑)                   
                                                          -- 42: 化療藥 (口服)                   
                                                          -- 61: 抗生素 (6A)                     
                                                          -- 62: 抗生素 (6E)                     
                                                          -- 63: 抗生素 (6F)                      
                                                          -- 64: 抗生素 (6G)                      
                                                          -- 65: 抗生素 (6H)                      
                                                          -- 66: 抗生素 (6I)                      
                                                          -- 67: 抗生素 (6K)                      
                                                          -- 68: 抗生素 (6M)                      
                                                          -- 69: 抗生素 (6N)                       
                                                          ------------------------------------------
 HighAlert         TINYINT                      NOT NULL, -- 高警訊藥品
                                                          ------------------------------------------
                                                          -- 0: 非高警訊藥品                     
                                                          -- 1: 高警訊藥品                       
                                                          -- 2: 化療注射劑                       
                                                          -- 3: 兒童專用藥                       
                                                          ------------------------------------------
 Pregnancy         NVARCHAR(10)                 NOT NULL, -- 懷孕分級
 PHValue1          DECIMAL(4,1)                 NOT NULL, -- 藥品酸鹼值(PH)起
 PHValue2          DECIMAL(4,1)                 NOT NULL, -- 藥品酸鹼值(PH)迄
 StorageNo         NVARCHAR(7)                  NOT NULL, -- 儲位號碼
 Ingredients       VARCHAR(30)                  NOT NULL, -- 成分含量 (ex:24mg/ml)
 IngredUnit        SMALLINT                     NOT NULL, -- 成分單位
 VolumeUnit        SMALLINT                     NOT NULL, -- 容量單位
 DosegeUnit        SMALLINT                     NOT NULL, -- 劑量單位
 ChargeUnit        SMALLINT                     NOT NULL, -- 計價單位
 IVRatio           DECIMAL(12,3)                NOT NULL, -- 成份/容量單位比值
 VCRatio           DECIMAL(9,3)                 NOT NULL, -- 容量/計價單位比值
 DCRatio           DECIMAL(9,3)                 NOT NULL, -- 劑量/計價單位比值
 CapacityRatio     DECIMAL(12,3) DEFAULT(0)     NOT NULL, -- 容量比值(mL) 
 VolumeRatio       DECIMAL(12,3) DEFAULT(0)     NOT NULL, -- 容積比值(mg) 
 CarryCondition    TINYINT                      NOT NULL, -- 進位條件
                                                          ------------------------------------------
                                                          -- 10: 絕對進位              　　      
                                                          -- 20: 四捨五入                    　      
                                                          -- 30: 小數第1位後　絕對進位           
                                                          -- 40: 小數第1位後　四捨五入           
                                                          ------------------------------------------
 DDD               DECIMAL(10,2) DEFAULT(0)     NOT NULL, -- 定義每日劑量 (Define Daily Dose)
 DDDUnit           SMALLINT                     NOT NULL, -- 定義每日劑量單位  
 IsAccumulation    BIT                          NOT NULL, -- 是否可以累積量 (true/false)
 ExpireHour        TINYINT DEFAULT(0)           NOT NULL, -- 開封後有效時數 (小時)
                                                          ------------------------------------------
                                                          -- = 0: 無限制                         
                                                          -- > 0: 限定小時內有效                 
                                                          ------------------------------------------
 IsOpdOrder        BIT DEFAULT('TRUE')          NOT NULL, -- 是否門診用藥  
 IsEmgOrder        BIT DEFAULT('TRUE')          NOT NULL, -- 是否急診用藥 
 IsAdmOrder        BIT DEFAULT('TRUE')          NOT NULL, -- 是否住院用藥
 IsCtOrder         BIT DEFAULT('FALSE')         NOT NULL, -- 是否化療可以開立
 IsRefillOrder     BIT DEFAULT('TRUE')          NOT NULL, -- 是否開立連續處方
 IsInfusion        BIT DEFAULT('FALSE')         NOT NULL, -- 是否流速管控                              
 IsUseRules        BIT DEFAULT('FALSE')         NOT NULL, -- 是否使用規範  
 IsPriorReview     BIT DEFAULT('FALSE')         NOT NULL, -- 是否事前審查
 IsLASA            BIT DEFAULT('FALSE')         NOT NULL, -- 是否LASA
 IsDoubleCheck     BIT DEFAULT('FALSE')         NOT NULL, -- 是否須雙重核對
 IsMulti           BIT DEFAULT('FALSE')         NOT NULL, -- 是否多次使用
 IsHighPrice       BIT DEFAULT('FALSE')         NOT NULL, -- 是否高價藥
 IsColdDrug        BIT DEFAULT('FALSE')         NOT NULL, -- 是否冷藏藥
 IsKCL             BIT DEFAULT('FALSE')         NOT NULL, -- 是否KCL藥品
 IsUB              BIT DEFAULT('FALSE')         NOT NULL, -- 是否大瓶點滴
 IsPackageInserts  BIT DEFAULT('FALSE')         NOT NULL, -- 是否藥品仿單
 IsMill            BIT DEFAULT('FALSE')         NOT NULL, -- 是否可以磨粉
 IsHalf            BIT DEFAULT('FALSE')         NOT NULL, -- 是否可以剝半
 IsConcentration   BIT DEFAULT('FALSE')         NOT NULL, -- 高濃度
 IsEasyToFall      BIT DEFAULT('FALSE')         NOT NULL, -- 易跌倒
 IsNuReturn        BIT DEFAULT('FALSE')         NOT NULL, -- 是否護理執行可退
 IsMultiExpand     BIT DEFAULT('FALSE')         NOT NULL, -- 是否多次展開
 PumpType          TINYINT                      NOT NULL, -- 幫補類別
                                                          ------------------------------------------
                                                          --  0: 無                              
                                                          -- 10: 幫浦                              
                                                          -- 20: CVC/幫浦                        
                                                          ------------------------------------------
 TranUser          INT                          NOT NULL, -- 最近異動人員 
 TranTime          DATETIME                     NOT NULL, -- 最近異動時間
 TranStatus        TINYINT DEFAULT(10)          NOT NULL, -- 最近異動狀態  
                                                          ------------------------------------------
                                                          --  5: 待醫事室確認                    
                                                          -- 10: 啟用                            
                                                          -- 40: 限定連續處方箋使用              
                                                          -- 60: 缺藥                            
                                                          -- 80: 停用                            
                                                          ------------------------------------------
 StopReason        TINYINT                      NOT NULL, -- 停用原因
                                                          ------------------------------------------
                                                          --   1: 停產                           
                                                          --   2: 許可證屆效期                   
                                                          --   3: 搭配儀器停用                   
                                                          -- 199: 其他                           
                                                          ------------------------------------------
 StartTime         DATETIME                     NOT NULL, -- 開始時間
 EndTime           DATETIME                     NOT NULL  -- 截止時間
                   DEFAULT ('2999/12/31 00:00')         , ------------------------------------------
                                                          -- 2999/12/31 00:00 為 Active          
                                                          ------------------------------------------
 Remark            NVARCHAR(50)                     NULL, -- 備註說明
 SystemUser        INT                          NOT NULL, -- 系統異動人員 
 SystemTime        DATETIME                     NOT NULL, -- 系統異動時間
 
 CONSTRAINT DrugBasicPKey PRIMARY KEY (DrugCode,StartTime)
)
CREATE UNIQUE INDEX DrugBasicKey1 ON DrugBasic(DrugCode,EndTime);
CREATE        INDEX DrugBasicKey2 ON DrugBasic(NhiCode);
CREATE        INDEX DrugBasicKey3 ON DrugBasic(BarCode);
