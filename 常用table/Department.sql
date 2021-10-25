----------------------------------------------------------------------------------------------------
--- 表格名稱：Department (Department)
--- 表格說明：責任中心檔
--- 編訂人員：孫培然
--- 校閱人員：孫培然
--- 修訂日期：2014/10/15
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
USE HealthCare;

CREATE TABLE Department
(
 DepartNo         CHAR(04)                      NOT NULL, -- 責任中心代號
 LevelNo          CHAR(14)                      NOT NULL, -- 層級編碼
 BranchNo         TINYINT                       NOT NULL, -- 院區代碼
 ChineseName      NVARCHAR(30)                  NOT NULL, -- 中文名稱
 EnglishName      VARCHAR(70)                   NOT NULL, -- 英文名稱
 ShortName        NVARCHAR(10)                  NOT NULL, -- 單位簡稱
 DepartType       TINYINT DEFAULT(0)            NOT NULL, -- 部門分類
                                                          ------------------------------------------
                                                          -- 11: 高層
                                                          -- 22: 體系院所 (分院)
                                                          -- 51: 醫療部門 -- 西醫
                                                          -- 52: 醫療部門 -- 中醫
                                                          -- 53: 醫療部門 -- 牙醫
                                                          -- 61: 醫技部門
                                                          -- 62: 護理部門
                                                          -- 71: 行政部門
                                                          -- 81: 研究部門
                                                          -- 91: 整合研發中心
                                                          ------------------------------------------
 IsCostCenter     BIT                           NOT NULL, -- 是否成本中心
 LocationDesc     NVARCHAR(20) DEFAULT (' ')    NOT NULL, -- 位置說明
 DrugStockLevel   TINYINT                       NOT NULL, -- 藥庫層級
 MatStockLevel    TINYINT                       NOT NULL, -- 資材庫層級
 UpperDepartNo    CHAR(04)                      NOT NULL, -- 上層單位
 StockNo          CHAR(04)                      NOT NULL, -- 庫存單位
 HealthType       TINYINT DEFAULT(0)            NOT NULL, -- 健檢類別
                                                          ------------------------------------------
                                                          -- 0: 普通健檢
                                                          -- 1: 司機健檢
                                                          -- 2: 輻防健檢
                                                          -- 3: 供膳健檢
                                                          -- 4: 透析健檢
                                                          ------------------------------------------
 StartDate        DATE                          NOT NULL, -- 生效日期
 EndDate          DATE                          NOT NULL  -- 截止日期
                  DEFAULT ('2999/12/31')                , ------------------------------------------
                                                          -- 2999/12/31 為 Active
                                                          ------------------------------------------
 Remark           NVARCHAR(100) DEFAULT (' ')   NOT NULL, -- 備註說明
 SystemUser       INT                           NOT NULL, -- 系統異動人員
 SystemTime       DATETIME                      NOT NULL, -- 系統異動時間

 CONSTRAINT DepartmentPKey PRIMARY KEY(DepartNo,StartDate)
);
 CREATE INDEX DepartmentKey1 ON Department(UpperDepartNo);
 CREATE INDEX DepartmentKey2 ON Department(HealthType,DepartNo,EndDate);
 CREATE INDEX DepartmentKey3 ON Department(LevelNo);


 --表格異動時,請更新以下Views
 --HealthChart.Department
 --HealthEducation.Department
 --HealthResource.Department