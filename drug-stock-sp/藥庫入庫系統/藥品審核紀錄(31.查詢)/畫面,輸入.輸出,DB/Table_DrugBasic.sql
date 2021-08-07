----------------------------------------------------------------------------------------------------
--- 表格名稱：DrugBasic (Drug Basic)                                                            
--- 表格說明：藥品基本檔
--- 編訂人員：孫培然                                                                            
--- 校閱人員：孫培然                                                                             
--- 設計日期：2015/07/10                                                                         
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource; 
--drop table DrugBasic;
create table DrugBasic 
(
 DrugCode         int                           not null, -- 藥品代碼
                                                          ------------------------------------------
                                                          -- 自行編碼，取最大號+1  
                                                          ------------------------------------------
 MedCode          char(08)                      not null, -- 醫令代碼                                                       
 NhiCode          char(12)                      not null, -- 健保藥品碼
 DrugName         nvarchar(100)                 not null, -- 院內藥品名
 BrandName1       varchar(100)                  not null, -- 商品名(英文)
 BrandName2       nvarchar(100)                 not null, -- 商品名(中文)
 GenericName1     varchar(100)                  not null, -- 學名(英文)
 GenericName2     nvarchar(100)                 not null, -- 學名(中文)
 Dosage           decimal(7,2)                  not null, -- 劑量
 UsageNo          smallint                      not null, -- 頻率代號
 UsedTimeNo       smallint                      not null, -- 使用時間點
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
 WayNo            smallint                      not null, -- 途徑代號
 DosageForms      tinyint                       not null, -- 劑型 (參考DrugOption)
 DrugType         smallint                      not null, -- 藥品分類
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
 InvType          tinyint                       not null, -- 藥庫分類
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
 PurchaseType      tinyint                      not null, -- 採購單分類
                                                          ------------------------------------------
                                                          --  5: (上月消耗/25(一個月=25天))*12天 
                                                          -- 10: 藥庫庫存加藥局庫存小於安全存量      
                                                          -- 11: 藥庫庫存加在途量小於安全存量      
                                                          -- 13: 需要時採購                        
                                                          -- 15: (1月內慢籤量/3)+1月以上領取>未領
                                                          -- 20: 自動撥補轉採購單                 
                                                          -- 80: 停止採購                          
                                                          ------------------------------------------
 ControlDrug       tinyint                      not null, -- 管控藥註記
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
 HighAlert         tinyint                      not null, -- 高警訊藥品
                                                          ------------------------------------------
                                                          -- 0: 非高警訊藥品                     
                                                          -- 1: 高警訊藥品                       
                                                          -- 2: 化療注射劑                       
                                                          -- 3: 兒童專用藥                       
                                                          ------------------------------------------
 Pregnancy         nvarchar(10)                 not null, -- 懷孕分級
 PHValue1          decimal(4,1)                 not null, -- 藥品酸鹼值(PH)起
 PHValue2          decimal(4,1)                 not null, -- 藥品酸鹼值(PH)迄
 StorageNo         nvarchar(7)                  not null, -- 儲位號碼
 Ingredients       varchar(30)                  not null, -- 成分含量 (ex:24mg/ml)
 IngredUnit        smallint                     not null, -- 成分單位
 VolumeUnit        smallint                     not null, -- 容量單位
 DosegeUnit        smallint                     not null, -- 劑量單位
 ChargeUnit        smallint                     not null, -- 計價單位
 IVRatio           decimal(12,3)                not null, -- 成份/容量單位比值
 VCRatio           decimal(9,3)                 not null, -- 容量/計價單位比值
 DCRatio           decimal(9,3)                 not null, -- 劑量/計價單位比值
 CapacityRatio     decimal(12,3) default(0)     not null, -- 容量比值(mL) 
 VolumeRatio       decimal(12,3) default(0)     not null, -- 容積比值(mg) 
 CarryCondition    tinyint                      not null, -- 進位條件
                                                          ------------------------------------------
                                                          -- 10: 絕對進位              　　      
                                                          -- 20: 四捨五入                    　      
                                                          -- 30: 小數第1位後　絕對進位           
                                                          -- 40: 小數第1位後　四捨五入           
                                                          ------------------------------------------
 DDD               decimal(10,2) default(0)     not null, -- 定義每日劑量 (Define Daily Dose)
 DDDUnit           smallint                     not null, -- 定義每日劑量單位  
 IsAccumulation    bit                          not null, -- 是否可以累積量 (true/false)
 ExpireHour        tinyint default(0)           not null, -- 開封後有效時數 (小時)
                                                          ------------------------------------------
                                                          -- = 0: 無限制                         
                                                          -- > 0: 限定小時內有效                 
                                                          ------------------------------------------
 IsOpdOrder        bit default('true')          not null, -- 是否門診用藥  
 IsEmgOrder        bit default('true')          not null, -- 是否急診用藥 
 IsAdmOrder        bit default('true')          not null, -- 是否住院用藥
 IsCtOrder         bit default('false')         not null, -- 是否化療可以開立
 IsRefillOrder     bit default('true')          not null, -- 是否開立連續處方
 IsInfusion        bit default('false')         not null, -- 是否流速管控                              
 IsUseRules        bit default('false')         not null, -- 是否使用規範  
 IsPriorReview     bit default('false')         not null, -- 是否事前審查
 IsLASA            bit default('false')         not null, -- 是否LASA
 IsDoubleCheck     bit default('false')         not null, -- 是否須雙重核對
 IsMulti           bit default('false')         not null, -- 是否多次使用
 IsHighPrice       bit default('false')         not null, -- 是否高價藥
 IsColdDrug        bit default('false')         not null, -- 是否冷藏藥
 IsKCL             bit default('false')         not null, -- 是否KCL藥品
 IsUB              bit default('false')         not null, -- 是否大瓶點滴
 IsPackageInserts  bit default('false')         not null, -- 是否藥品仿單
 IsMill            bit default('false')         not null, -- 是否可以磨粉
 IsHalf            bit default('false')         not null, -- 是否可以剝半
 IsConcentration   bit default('false')         not null, -- 高濃度
 IsEasyToFall      bit default('false')         not null, -- 易跌倒
 IsNuReturn        bit default('false')         not null, -- 是否護理執行可退
 IsMultiExpand     bit default('false')         not null, -- 是否多次展開
 PumpType          tinyint                      not null, -- 幫補類別
                                                          ------------------------------------------
                                                          --  0: 無                              
                                                          -- 10: 幫浦                              
                                                          -- 20: CVC/幫浦                        
                                                          ------------------------------------------
 TranUser          int                          not null, -- 最近異動人員 
 TranTime          datetime                     not null, -- 最近異動時間
 TranStatus        tinyint default(10)          not null, -- 最近異動狀態  
                                                          ------------------------------------------
                                                          --  5: 待醫事室確認                    
                                                          -- 10: 啟用                            
                                                          -- 40: 限定連續處方箋使用              
                                                          -- 60: 缺藥                            
                                                          -- 80: 停用                            
                                                          ------------------------------------------
 StopReason        tinyint                      not null, -- 停用原因
                                                          ------------------------------------------
                                                          --   1: 停產                           
                                                          --   2: 許可證屆效期                   
                                                          --   3: 搭配儀器停用                   
                                                          -- 199: 其他                           
                                                          ------------------------------------------
 StartTime         datetime                     not null, -- 開始時間
 EndTime           datetime                     not null  -- 截止時間
                   default ('2999/12/31 00:00')         , ------------------------------------------
                                                          -- 2999/12/31 00:00 為 Active          
                                                          ------------------------------------------
 Remark            nvarchar(50)                     null, -- 備註說明
 SystemUser        int                          not null, -- 系統異動人員 
 SystemTime        datetime                     not null, -- 系統異動時間
 
 constraint DrugBasicPKey primary key (DrugCode,StartTime)
)
create unique index DrugBasicKey1 on DrugBasic(DrugCode,EndTime);
create        index DrugBasicKey2 on DrugBasic(NhiCode);
create        index DrugBasicKey3 on DrugBasic(BarCode);
