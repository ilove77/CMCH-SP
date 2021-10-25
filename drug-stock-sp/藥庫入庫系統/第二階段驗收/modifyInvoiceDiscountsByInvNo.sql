USE [HealthResource]
GO

--- 程序名稱: modifyInvoiceDiscountsByInvNo
--- 程序說明: 修改InvoiceDiscounts表格
--- 編訂人員: 孫培然、林芳郁、蔡易志
--- 校閱人員: 孫培然
--- 修訂日期: 2021/10/25
CREATE PROCEDURE [dbo].[modifyInvoiceDiscountsByInvNo] (@params NVARCHAR(MAX))
AS BEGIN
   DECLARE @invoiceNo1      CHAR(10)       = JSON_VALUE(@params,'$.orginalInvNo');
   DECLARE @invoiceNo2      CHAR(10)       = JSON_VALUE(@params,'$.invoiceNo');
   DECLARE @checkNo         INT            = JSON_VALUE(@params,'$.checkNo');
   DECLARE @systemTime      VARCHAR(23)    = CONVERT(varchar, GETDATE(), 121);
   DECLARE @procedureName   VARCHAR(20)    = 'modifyInvoiceDiscountsByInvNo';
   DECLARE @errorSeverity   INT;
   DECLARE @errorMessage    NVARCHAR(4000);

   SET @params = JSON_MODIFY(@params, '$.systemTime', @systemTime);

   BEGIN TRY
         UPDATE t SET
                DiscountsDate  = ISNULL(s.DiscountsDate , t.DiscountsDate),
                DiscountsType  = ISNULL(s.DiscountsType , t.DiscountsType),
                InvoiceNo      = ISNULL(@invoiceNo2 , t.InvoiceNo),
                ItemType       = ISNULL(s.ItemType , t.ItemType),
                ItemCode       = ISNULL(s.ItemCode , t.ItemCode),
                Amount         = ISNULL(s.Amount , t.Amount),
                CheckNo        = ISNULL(s.CheckNo , t.CheckNo),
                SystemUser     = ISNULL(s.SystemUser , t.SystemUser),
                SystemTime     = ISNULL(s.SystemTime , t.SystemTime)
           FROM [dbo].[InvoiceDiscounts]  AS t,
           OPENJSON(@params)
           WITH (
                DiscountsDate DATE           '$.discountsDate',
                DiscountsType TINYINT        '$.discountsType',
                InvoiceNo     CHAR(10)       '$.invoiceNo',
                ItemType      TINYINT        '$.itemType',
                ItemCode      DECIMAL(11)    '$.itemCode',
                Amount        DECIMAL(10)    '$.amount',
                CheckNo       INT            '$.checkNo',
                SystemUser    INT            '$.systemUser',
                SystemTime    DATETIME       '$.systemTime'
                ) AS s
          WHERE t.InvoiceNo = @invoiceNo1 AND t.CheckNo = @checkNo
   END TRY
   BEGIN CATCH
         SELECT @errorSeverity = ERROR_SEVERITY(), @errorMessage = ERROR_MESSAGE();
         EXEC [dbo].[setErrorLog] @procedureName, @params, @errorSeverity, @errorMessage;
         THROW;
   END CATCH
END
GO