USE [HealthCare]
GO

--- 程序名稱: setDepartment
--- 程序說明: 設定Department表格
--- 編訂人員: 蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/11/08
CREATE PROCEDURE [dbo].[setDepartment] (@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @systemTime      VARCHAR(23)    = CONVERT(VARCHAR, GETDATE(), 121);
   DECLARE @procedureName   VARCHAR(20)    = 'setDepartment';
   DECLARE @errorSeverity   INT;
   DECLARE @errorMessage    NVARCHAR(4000);

   BEGIN TRY
         MERGE INTO [dbo].[department] AS t
         USING ( SELECT *
                   FROM OPENJSON(@params)
                   WITH ( DepartNo       CHAR(04)       '$.departNo',
                          LevelNo        CHAR(14)       '$.levelNo',
                          BranchNo       TINYINT        '$.branchNo',
                          ChineseName    NVARCHAR(30)   '$.chineseName',
                          EnglishName    NVARCHAR(70)   '$.englishName',
                          ShortName      NVARCHAR(10)   '$.shortName',
                          DepartType     TINYINT        '$.departType',
                          IsCostCenter   BIT            '$.isCostCenter',
                          LocationDesc   NVARCHAR(20)   '$.locationDesc',
                          DrugStockLevel TINYINT        '$.drugStockLevel',
                          MatStockLevel  TINYINT        '$.matStockLevel',
                          UpperDepartNo  CHAR(04)       '$.upperDepartNo',
                          StockNo        CHAR(04)       '$.stockNo',
                          HealthType     TINYINT        '$.healthType',
                          StartDate      DATE           '$.startDate',
                          EndDate        DATE           '$.endDate',
                          Remark         NVARCHAR(100)  '$.remark',
                          SystemUser     INT            '$.systemUser',
                          SystemTime     DATETIME       '$.systemTime',
                          Builder        CHAR(01)       '$.builder'
                        )
                 ) AS s (
                          DepartNo,
                          LevelNo,
                          BranchNo,
                          ChineseName,
                          EnglishName,
                          ShortName,
                          DepartType,
                          IsCostCenter,
                          LocationDesc,
                          DrugStockLevel,
                          MatStockLevel,
                          UpperDepartNo,
                          StockNo,
                          HealthType,
                          StartDate,
                          EndDate,
                          Remark,
                          SystemUser,
                          SystemTime,
                          Builder
                        )
            ON (t.DepartNo = s.DepartNo AND t.StartDate = s.StartDate)
          WHEN MATCHED THEN
               UPDATE SET
                      LevelNo         = ISNULL(s.LevelNo , t.LevelNo),
                      BranchNo        = ISNULL(s.BranchNo , t.BranchNo),
                      ChineseName     = ISNULL(s.ChineseName , t.ChineseName),
                      EnglishName     = ISNULL(s.EnglishName , t.EnglishName),
                      ShortName       = ISNULL(s.ShortName , t.ShortName),
                      DepartType      = ISNULL(s.DepartType , t.DepartType),
                      IsCostCenter    = ISNULL(s.IsCostCenter , t.IsCostCenter),
                      LocationDesc    = ISNULL(s.LocationDesc , t.LocationDesc),
                      DrugStockLevel  = ISNULL(s.DrugStockLevel , t.DrugStockLevel),
                      MatStockLevel   = ISNULL(s.MatStockLevel , t.MatStockLevel),
                      UpperDepartNo   = ISNULL(s.UpperDepartNo , t.UpperDepartNo),
                      StockNo         = ISNULL(s.StockNo , t.StockNo),
                      HealthType      = ISNULL(s.HealthType , t.HealthType),
                      EndDate         = ISNULL(s.EndDate , t.EndDate),
                      Remark          = ISNULL(s.Remark , t.Remark),
                      Builder         = ISNULL(s.Builder , t.Builder),
                      SystemUser      = s.SystemUser,
                      SystemTime      = @systemTime
          WHEN NOT MATCHED THEN
               INSERT (
                        DepartNo,
                        LevelNo,
                        BranchNo,
                        Builder,
                        ChineseName,
                        EnglishName,
                        ShortName,
                        DepartType,
                        IsCostCenter,
                        LocationDesc,
                        DrugStockLevel,
                        MatStockLevel,
                        UpperDepartNo,
                        StockNo,
                        HealthType,
                        StartDate,
                        EndDate,
                        Remark,
                        SystemUser,
                        SystemTime
                      )
               VALUES (
                        s.DepartNo,
                        s.LevelNo,
                        s.BranchNo,
                        s.Builder,
                        s.ChineseName,
                        s.EnglishName,
                        s.ShortName,
                        s.DepartType,
                        s.IsCostCenter,
                        s.LocationDesc,
                        s.DrugStockLevel,
                        s.MatStockLevel,
                        s.UpperDepartNo,
                        s.StockNo,
                        s.HealthType,
                        s.StartDate,
                        s.EndDate,
                        s.Remark,
                        s.SystemUser,
                        @systemTime
                      );
         
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;
         THROW;
   END CATCH
   
END
GO

-- EXEC PROCEDURE
DECLARE @params NVARCHAR(MAX) =
'
{
 "departNo"       : "0001",
 "shortName"      : "空調組",
 "startDate"      : "1911-01-01",
 "systemUser"     : "37029",
 "builder"        : "H"
}
'
EXEC [dbo].[setDepartment] @params
GO