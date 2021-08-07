----------------------------------------------------------------------------------------------------
--- 表格名稱：PurchaseFollow (Purchase Follow)
--- 表格說明：採購跟催紀錄檔
--- 編訂人員：王勇順
--- 校閱人員：孫培然
--- 設計日期：2017/07/05
---.5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95..100
use HealthResource;
create table PurchaseFollow
(
 FollowNo         int identity(1,1)             not null, -- 跟催編號
 ItemType         tinyint                       not null, -- 項目類別
                                                          ------------------------------------------
                                                          -- 10:藥庫
                                                          -- 20:衛材
                                                          ------------------------------------------
 PurchaseNo       int                           not null, -- 訂單編號
 ItemCode         int                           not null, -- 項目編號
 FollowTime       datetime                      not null, -- 跟催時間
 FollowUser       int                           not null, -- 跟催人員
 SystemUser       int                           not null, -- 系統異動人員
 SystemTime       datetime                      not null, -- 系統異動時間

 constraint PurchaseFollowPKey  primary key (FollowNo)
);
create index PurchaseFollowKey1 on PurchaseFollow(PurchaseNo,ItemType,ItemCode);