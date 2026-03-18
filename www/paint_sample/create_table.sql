-- ============================================================
-- tk_paint_sample 테이블 생성 (페인트 샘플지급 이력)
-- DBeaver 실행용 (GO 사용 금지)
-- ============================================================

-- 테이블 존재 여부 확인 후 생성
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tk_paint_sample')
BEGIN
  CREATE TABLE dbo.tk_paint_sample (
    psidx        INT           NOT NULL,
    pidx         INT           NOT NULL,
    sample_type  INT           DEFAULT 1,
    sjidx        INT           NULL,
    company_name NVARCHAR(100) NULL,
    recipient    NVARCHAR(50)  NULL,
    qty          INT           DEFAULT 1,
    sample_date  DATETIME      DEFAULT GETDATE(),
    memo         NVARCHAR(200) NULL,
    psmidx       INT           NULL,
    pswdate      DATETIME      NULL,
    psemidx      INT           NULL,
    psewdate     DATETIME      NULL,
    CONSTRAINT PK_tk_paint_sample PRIMARY KEY (psidx)
  );
  PRINT 'tk_paint_sample 테이블 생성 완료';
END;
ELSE
BEGIN
  PRINT 'tk_paint_sample 테이블 이미 존재';
END;
