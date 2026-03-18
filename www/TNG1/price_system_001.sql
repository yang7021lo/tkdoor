/*
================================================================================
도어 단가 자동 인상 시스템 v2.0 - 001서버 통합 설치 스크립트
================================================================================
작성일: 2026-02-09
데이터베이스: tkd001 (001서버)
주의: DBeaver용 - GO 사용하지 않음
================================================================================
*/

-- ============================================================================
-- 1단계: tng_price_adjustment (인상 이력/예약 테이블)
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tng_price_adjustment')
BEGIN
    CREATE TABLE tkd001.dbo.tng_price_adjustment (
        adj_idx INT IDENTITY(1,1) NOT NULL,
        adj_name NVARCHAR(100) NOT NULL,
        adj_rate DECIMAL(5,2) NOT NULL,
        adj_type VARCHAR(20) NOT NULL,
        target_bfwidx INT NULL,
        target_qtyco INT NULL,
        target_fidx INT NULL,
        target_sjb_idx INT NULL,
        apply_date DATETIME NOT NULL DEFAULT GETDATE(),
        created_by INT NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        remarks NVARCHAR(500) NULL,
        is_executed BIT NOT NULL DEFAULT 0,
        executed_at DATETIME NULL,
        executed_by INT NULL,
        affected_rows_t INT NULL,
        affected_rows_al INT NULL,
        backup_id NVARCHAR(50) NULL,
        CONSTRAINT PK_tng_price_adjustment PRIMARY KEY (adj_idx),
        CONSTRAINT CK_adj_type CHECK (adj_type IN ('ALL','MANUAL','AUTO','AL')),
        CONSTRAINT CK_adj_rate CHECK (adj_rate BETWEEN -50.00 AND 100.00)
    );
    PRINT '>> tng_price_adjustment 생성 완료';
END;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_price_adj_apply')
    CREATE INDEX IX_price_adj_apply ON tkd001.dbo.tng_price_adjustment(apply_date, is_executed);

-- ============================================================================
-- 2단계: tng_price_backup_t (백업 - 수동/자동)
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tng_price_backup_t')
BEGIN
    CREATE TABLE tkd001.dbo.tng_price_backup_t (
        backup_idx INT IDENTITY(1,1) PRIMARY KEY,
        backup_id NVARCHAR(50) NOT NULL,
        backup_date DATETIME NOT NULL DEFAULT GETDATE(),
        adj_idx INT NULL,
        uptidx INT,
        SJB_IDX INT,
        unittype_bfwidx INT,
        unittype_qtyco_idx INT,
        price INT
    );
    CREATE INDEX IX_backup_t_id ON tkd001.dbo.tng_price_backup_t(backup_id);
    PRINT '>> tng_price_backup_t 생성 완료';
END;

-- ============================================================================
-- 3단계: tng_price_backup_al (백업 - 알루미늄)
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tng_price_backup_al')
BEGIN
    CREATE TABLE tkd001.dbo.tng_price_backup_al (
        backup_idx INT IDENTITY(1,1) PRIMARY KEY,
        backup_id NVARCHAR(50) NOT NULL,
        backup_date DATETIME NOT NULL DEFAULT GETDATE(),
        adj_idx INT NULL,
        ualidx INT,
        SJB_IDX INT,
        fidx INT,
        price_bk INT,
        price_etl INT
    );
    CREATE INDEX IX_backup_al_id ON tkd001.dbo.tng_price_backup_al(backup_id);
    PRINT '>> tng_price_backup_al 생성 완료';
END;

-- ============================================================================
-- 4단계: tng_price_history (가격 변동 이력)
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tng_price_history')
BEGIN
    CREATE TABLE tkd001.dbo.tng_price_history (
        history_idx INT IDENTITY(1,1) PRIMARY KEY,
        adj_idx INT NULL,
        adj_name NVARCHAR(100) NULL,
        table_type CHAR(1) NOT NULL,
        record_idx INT NOT NULL,
        SJB_IDX INT NULL,
        unittype_bfwidx INT NULL,
        unittype_qtyco_idx INT NULL,
        fidx INT NULL,
        price_field VARCHAR(20) NOT NULL,
        price_before INT NOT NULL,
        price_after INT NOT NULL,
        change_amount INT NOT NULL,
        change_rate DECIMAL(8,4) NULL,
        changed_at DATETIME NOT NULL DEFAULT GETDATE(),
        changed_by INT NULL,
        change_type VARCHAR(20) NOT NULL DEFAULT 'AUTO_ADJUST'
    );
    CREATE INDEX IX_history_adj ON tkd001.dbo.tng_price_history(adj_idx);
    CREATE INDEX IX_history_sjb ON tkd001.dbo.tng_price_history(SJB_IDX);
    CREATE INDEX IX_history_date ON tkd001.dbo.tng_price_history(changed_at);
    CREATE INDEX IX_history_record ON tkd001.dbo.tng_price_history(table_type, record_idx);
    PRINT '>> tng_price_history 생성 완료';
END;


-- ============================================================================
-- 5단계: sp_ApplyPriceAdjustment_v2 (단가 인상 실행 + 이력 기록)
-- ============================================================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_ApplyPriceAdjustment_v2')
    DROP PROCEDURE dbo.sp_ApplyPriceAdjustment_v2;

EXEC sp_executesql N'
CREATE PROCEDURE dbo.sp_ApplyPriceAdjustment_v2
    @adj_idx INT,
    @executed_by INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @adj_rate DECIMAL(5,2);
    DECLARE @adj_type VARCHAR(20);
    DECLARE @target_bfwidx INT;
    DECLARE @target_qtyco INT;
    DECLARE @target_fidx INT;
    DECLARE @target_sjb_idx INT;
    DECLARE @adj_name NVARCHAR(100);
    DECLARE @affected_t INT = 0;
    DECLARE @affected_al INT = 0;
    DECLARE @backup_id NVARCHAR(50);

    SELECT
        @adj_rate = adj_rate,
        @adj_type = adj_type,
        @target_bfwidx = target_bfwidx,
        @target_qtyco = target_qtyco,
        @target_fidx = target_fidx,
        @target_sjb_idx = target_sjb_idx,
        @adj_name = adj_name
    FROM tkd001.dbo.tng_price_adjustment
    WHERE adj_idx = @adj_idx AND is_executed = 0;

    IF @adj_rate IS NULL
    BEGIN
        RAISERROR(''해당 인상 이력이 없거나 이미 실행됨 (adj_idx=%d)'', 16, 1, @adj_idx);
        RETURN;
    END

    SET @backup_id = ''ADJ_'' + CAST(@adj_idx AS VARCHAR) + ''_'' +
                     CONVERT(VARCHAR, GETDATE(), 112) + ''_'' +
                     REPLACE(CONVERT(VARCHAR, GETDATE(), 108), '':'', '''');

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @adj_type IN (''ALL'', ''MANUAL'', ''AUTO'')
        BEGIN
            -- STEP 1: 백업
            INSERT INTO tkd001.dbo.tng_price_backup_t
                (backup_id, adj_idx, uptidx, SJB_IDX, unittype_bfwidx, unittype_qtyco_idx, price)
            SELECT
                @backup_id, @adj_idx,
                t.uptidx, t.SJB_IDX, t.unittype_bfwidx, t.unittype_qtyco_idx, t.price
            FROM tkd001.dbo.tng_unitprice_t t
            INNER JOIN tkd001.dbo.TNG_SJB s ON t.SJB_IDX = s.SJB_IDX
            WHERE
                (
                    (@adj_type = ''ALL'') OR
                    (@adj_type = ''MANUAL'' AND s.SJB_FA = 1) OR
                    (@adj_type = ''AUTO'' AND s.SJB_FA = 2)
                )
                AND (s.pcent = 1 OR s.pcent IS NULL OR s.pcent = 0)
                AND (@target_bfwidx IS NULL OR t.unittype_bfwidx = @target_bfwidx)
                AND (@target_qtyco IS NULL OR t.unittype_qtyco_idx = @target_qtyco)
                AND (@target_sjb_idx IS NULL OR t.SJB_IDX = @target_sjb_idx);

            -- STEP 2: 이력 기록
            INSERT INTO tkd001.dbo.tng_price_history
                (adj_idx, adj_name, table_type, record_idx, SJB_IDX,
                 unittype_bfwidx, unittype_qtyco_idx, price_field,
                 price_before, price_after, change_amount, change_rate,
                 changed_by, change_type)
            SELECT
                @adj_idx, @adj_name, ''T'', t.uptidx, t.SJB_IDX,
                t.unittype_bfwidx, t.unittype_qtyco_idx, ''price'',
                t.price,
                CAST(t.price * (1 + @adj_rate / 100.0) AS INT),
                CAST(t.price * (1 + @adj_rate / 100.0) AS INT) - t.price,
                @adj_rate, @executed_by, ''AUTO_ADJUST''
            FROM tkd001.dbo.tng_unitprice_t t
            INNER JOIN tkd001.dbo.TNG_SJB s ON t.SJB_IDX = s.SJB_IDX
            WHERE
                (
                    (@adj_type = ''ALL'') OR
                    (@adj_type = ''MANUAL'' AND s.SJB_FA = 1) OR
                    (@adj_type = ''AUTO'' AND s.SJB_FA = 2)
                )
                AND (s.pcent = 1 OR s.pcent IS NULL OR s.pcent = 0)
                AND (@target_bfwidx IS NULL OR t.unittype_bfwidx = @target_bfwidx)
                AND (@target_qtyco IS NULL OR t.unittype_qtyco_idx = @target_qtyco)
                AND (@target_sjb_idx IS NULL OR t.SJB_IDX = @target_sjb_idx)
                AND t.price > 0;

            -- STEP 3: 기준가 인상
            UPDATE t
            SET t.price = CAST(t.price * (1 + @adj_rate / 100.0) AS INT)
            FROM tkd001.dbo.tng_unitprice_t t
            INNER JOIN tkd001.dbo.TNG_SJB s ON t.SJB_IDX = s.SJB_IDX
            WHERE
                (
                    (@adj_type = ''ALL'') OR
                    (@adj_type = ''MANUAL'' AND s.SJB_FA = 1) OR
                    (@adj_type = ''AUTO'' AND s.SJB_FA = 2)
                )
                AND (s.pcent = 1 OR s.pcent IS NULL OR s.pcent = 0)
                AND (@target_bfwidx IS NULL OR t.unittype_bfwidx = @target_bfwidx)
                AND (@target_qtyco IS NULL OR t.unittype_qtyco_idx = @target_qtyco)
                AND (@target_sjb_idx IS NULL OR t.SJB_IDX = @target_sjb_idx);

            SET @affected_t = @@ROWCOUNT;

            -- STEP 4: pcent 배율 연동
            UPDATE t
            SET t.price = CAST(base.price * s.pcent AS INT)
            FROM tkd001.dbo.tng_unitprice_t t
            INNER JOIN tkd001.dbo.TNG_SJB s ON t.SJB_IDX = s.SJB_IDX
            INNER JOIN tkd001.dbo.TNG_SJB base_s ON s.SJB_TYPE_NO = base_s.SJB_TYPE_NO
                AND RIGHT(s.SJB_barlist, 3) = RIGHT(base_s.SJB_barlist, 3)
                AND base_s.pcent = 1
            INNER JOIN tkd001.dbo.tng_unitprice_t base ON base.SJB_IDX = base_s.SJB_IDX
                AND t.unittype_bfwidx = base.unittype_bfwidx
                AND t.unittype_qtyco_idx = base.unittype_qtyco_idx
            WHERE
                (
                    (@adj_type = ''ALL'') OR
                    (@adj_type = ''MANUAL'' AND s.SJB_FA = 1) OR
                    (@adj_type = ''AUTO'' AND s.SJB_FA = 2)
                )
                AND s.pcent > 1
                AND (@target_bfwidx IS NULL OR t.unittype_bfwidx = @target_bfwidx)
                AND (@target_qtyco IS NULL OR t.unittype_qtyco_idx = @target_qtyco);
        END

        IF @adj_type IN (''ALL'', ''AL'')
        BEGIN
            INSERT INTO tkd001.dbo.tng_price_backup_al
                (backup_id, adj_idx, ualidx, SJB_IDX, fidx, price_bk, price_etl)
            SELECT
                @backup_id, @adj_idx,
                ualidx, SJB_IDX, fidx, price_bk, price_etl
            FROM tkd001.dbo.tng_unitprice_al
            WHERE (@target_fidx IS NULL OR fidx = @target_fidx)
              AND (@target_sjb_idx IS NULL OR SJB_IDX = @target_sjb_idx);

            INSERT INTO tkd001.dbo.tng_price_history
                (adj_idx, adj_name, table_type, record_idx, SJB_IDX,
                 fidx, price_field,
                 price_before, price_after, change_amount, change_rate,
                 changed_by, change_type)
            SELECT
                @adj_idx, @adj_name, ''A'', ualidx, SJB_IDX,
                fidx, ''price_bk'',
                price_bk,
                CAST(price_bk * (1 + @adj_rate / 100.0) AS INT),
                CAST(price_bk * (1 + @adj_rate / 100.0) AS INT) - price_bk,
                @adj_rate, @executed_by, ''AUTO_ADJUST''
            FROM tkd001.dbo.tng_unitprice_al
            WHERE (@target_fidx IS NULL OR fidx = @target_fidx)
              AND (@target_sjb_idx IS NULL OR SJB_IDX = @target_sjb_idx)
              AND price_bk > 0;

            INSERT INTO tkd001.dbo.tng_price_history
                (adj_idx, adj_name, table_type, record_idx, SJB_IDX,
                 fidx, price_field,
                 price_before, price_after, change_amount, change_rate,
                 changed_by, change_type)
            SELECT
                @adj_idx, @adj_name, ''A'', ualidx, SJB_IDX,
                fidx, ''price_etl'',
                price_etl,
                CAST(price_etl * (1 + @adj_rate / 100.0) AS INT),
                CAST(price_etl * (1 + @adj_rate / 100.0) AS INT) - price_etl,
                @adj_rate, @executed_by, ''AUTO_ADJUST''
            FROM tkd001.dbo.tng_unitprice_al
            WHERE (@target_fidx IS NULL OR fidx = @target_fidx)
              AND (@target_sjb_idx IS NULL OR SJB_IDX = @target_sjb_idx)
              AND price_etl > 0;

            UPDATE tkd001.dbo.tng_unitprice_al
            SET
                price_bk = CAST(price_bk * (1 + @adj_rate / 100.0) AS INT),
                price_etl = CAST(price_etl * (1 + @adj_rate / 100.0) AS INT)
            WHERE (@target_fidx IS NULL OR fidx = @target_fidx)
              AND (@target_sjb_idx IS NULL OR SJB_IDX = @target_sjb_idx);

            SET @affected_al = @@ROWCOUNT;
        END

        UPDATE tkd001.dbo.tng_price_adjustment
        SET
            is_executed = 1,
            executed_at = GETDATE(),
            executed_by = @executed_by,
            affected_rows_t = @affected_t,
            affected_rows_al = @affected_al,
            backup_id = @backup_id
        WHERE adj_idx = @adj_idx;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(''단가 인상 실패: %s'', 16, 1, @err);
    END CATCH
END';

PRINT '>> sp_ApplyPriceAdjustment_v2 생성 완료';


-- ============================================================================
-- 6단계: sp_GetPriceHistory (가격 변동 이력 조회)
-- ============================================================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetPriceHistory')
    DROP PROCEDURE dbo.sp_GetPriceHistory;

EXEC sp_executesql N'
CREATE PROCEDURE dbo.sp_GetPriceHistory
    @SJB_IDX INT = NULL,
    @days INT = 365,
    @table_type CHAR(1) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        h.history_idx,
        h.changed_at as 변경일시,
        h.adj_name as 인상명,
        h.table_type as 테이블,
        CASE h.table_type WHEN ''T'' THEN N''수동/자동'' WHEN ''A'' THEN N''알루미늄'' END as 구분,
        h.SJB_IDX,
        s.SJB_barlist as 규격,
        h.unittype_bfwidx as 바타입,
        h.unittype_qtyco_idx as 재질,
        h.fidx as 프레임타입,
        h.price_field as 가격필드,
        h.price_before as 변경전,
        h.price_after as 변경후,
        h.change_amount as 변동액,
        CAST(h.change_rate AS VARCHAR) + ''%'' as 변동률,
        h.change_type as 변경유형
    FROM tkd001.dbo.tng_price_history h
    LEFT JOIN tkd001.dbo.TNG_SJB s ON h.SJB_IDX = s.SJB_IDX
    WHERE
        (@SJB_IDX IS NULL OR h.SJB_IDX = @SJB_IDX)
        AND h.changed_at >= DATEADD(DAY, -@days, GETDATE())
        AND (@table_type IS NULL OR h.table_type = @table_type)
    ORDER BY h.changed_at DESC, h.history_idx DESC;
END';

PRINT '>> sp_GetPriceHistory 생성 완료';


-- ============================================================================
-- 7단계: sp_GetPriceHistorySummary (설계도별 이력 요약)
-- ============================================================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetPriceHistorySummary')
    DROP PROCEDURE dbo.sp_GetPriceHistorySummary;

EXEC sp_executesql N'
CREATE PROCEDURE dbo.sp_GetPriceHistorySummary
    @SJB_IDX INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        s.SJB_IDX,
        s.SJB_barlist as 규격,
        t.SJB_TYPE_NAME as 품명,
        CASE s.SJB_FA WHEN 1 THEN N''수동'' WHEN 2 THEN N''자동'' END as 프레임타입,
        s.pcent as 배율
    FROM tkd001.dbo.TNG_SJB s
    LEFT JOIN tkd001.dbo.tng_sjbtype t ON s.SJB_TYPE_NO = t.SJB_TYPE_NO
    WHERE s.SJB_IDX = @SJB_IDX;

    SELECT
        adj_name as 인상명,
        MIN(changed_at) as 적용일,
        change_rate as 인상률,
        COUNT(*) as 변경건수,
        SUM(change_amount) as 총변동액
    FROM tkd001.dbo.tng_price_history
    WHERE SJB_IDX = @SJB_IDX
    GROUP BY adj_idx, adj_name, change_rate
    ORDER BY MIN(changed_at) DESC;

    SELECT TOP 10
        changed_at as 변경일시,
        price_field as 필드,
        price_before as 변경전,
        price_after as 변경후,
        CAST(change_rate AS VARCHAR) + ''%'' as 변동률
    FROM tkd001.dbo.tng_price_history
    WHERE SJB_IDX = @SJB_IDX
    ORDER BY changed_at DESC;
END';

PRINT '>> sp_GetPriceHistorySummary 생성 완료';


-- ============================================================================
-- 8단계: sp_RollbackPriceAdjustment (롤백 + 이력 기록)
-- ============================================================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RollbackPriceAdjustment')
    DROP PROCEDURE dbo.sp_RollbackPriceAdjustment;

EXEC sp_executesql N'
CREATE PROCEDURE dbo.sp_RollbackPriceAdjustment
    @backup_id NVARCHAR(50),
    @executed_by INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @count_t INT = 0;
    DECLARE @count_al INT = 0;
    DECLARE @adj_idx INT;
    DECLARE @adj_name NVARCHAR(100);

    SELECT TOP 1 @adj_idx = adj_idx
    FROM tkd001.dbo.tng_price_backup_t
    WHERE backup_id = @backup_id;

    IF @adj_idx IS NULL
    BEGIN
        SELECT TOP 1 @adj_idx = adj_idx
        FROM tkd001.dbo.tng_price_backup_al
        WHERE backup_id = @backup_id;
    END

    IF @adj_idx IS NULL
    BEGIN
        RAISERROR(''백업을 찾을 수 없습니다: %s'', 16, 1, @backup_id);
        RETURN;
    END

    SELECT @adj_name = adj_name FROM tkd001.dbo.tng_price_adjustment WHERE adj_idx = @adj_idx;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO tkd001.dbo.tng_price_history
            (adj_idx, adj_name, table_type, record_idx, SJB_IDX,
             unittype_bfwidx, unittype_qtyco_idx, price_field,
             price_before, price_after, change_amount, change_rate,
             changed_by, change_type)
        SELECT
            @adj_idx,
            @adj_name + N'' (롤백)'',
            ''T'',
            t.uptidx,
            t.SJB_IDX,
            t.unittype_bfwidx,
            t.unittype_qtyco_idx,
            ''price'',
            t.price,
            b.price,
            b.price - t.price,
            CASE WHEN t.price > 0 THEN CAST((b.price - t.price) * 100.0 / t.price AS DECIMAL(8,4)) ELSE 0 END,
            @executed_by,
            ''ROLLBACK''
        FROM tkd001.dbo.tng_unitprice_t t
        INNER JOIN tkd001.dbo.tng_price_backup_t b ON t.uptidx = b.uptidx
        WHERE b.backup_id = @backup_id;

        UPDATE t
        SET t.price = b.price
        FROM tkd001.dbo.tng_unitprice_t t
        INNER JOIN tkd001.dbo.tng_price_backup_t b ON t.uptidx = b.uptidx
        WHERE b.backup_id = @backup_id;

        SET @count_t = @@ROWCOUNT;

        INSERT INTO tkd001.dbo.tng_price_history
            (adj_idx, adj_name, table_type, record_idx, SJB_IDX,
             fidx, price_field,
             price_before, price_after, change_amount, change_rate,
             changed_by, change_type)
        SELECT
            @adj_idx,
            @adj_name + N'' (롤백)'',
            ''A'',
            al.ualidx,
            al.SJB_IDX,
            al.fidx,
            ''price_bk'',
            al.price_bk,
            b.price_bk,
            b.price_bk - al.price_bk,
            CASE WHEN al.price_bk > 0 THEN CAST((b.price_bk - al.price_bk) * 100.0 / al.price_bk AS DECIMAL(8,4)) ELSE 0 END,
            @executed_by,
            ''ROLLBACK''
        FROM tkd001.dbo.tng_unitprice_al al
        INNER JOIN tkd001.dbo.tng_price_backup_al b ON al.ualidx = b.ualidx
        WHERE b.backup_id = @backup_id;

        UPDATE al
        SET al.price_bk = b.price_bk,
            al.price_etl = b.price_etl
        FROM tkd001.dbo.tng_unitprice_al al
        INNER JOIN tkd001.dbo.tng_price_backup_al b ON al.ualidx = b.ualidx
        WHERE b.backup_id = @backup_id;

        SET @count_al = @@ROWCOUNT;

        UPDATE tkd001.dbo.tng_price_adjustment
        SET is_executed = 0, executed_at = NULL,
            affected_rows_t = NULL, affected_rows_al = NULL
        WHERE backup_id = @backup_id;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(''롤백 실패: %s'', 16, 1, @err);
    END CATCH
END';

PRINT '>> sp_RollbackPriceAdjustment 생성 완료';


-- ============================================================================
-- 9단계: sp_ExecuteScheduledAdjustments_v2 (스케줄러)
-- ============================================================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_ExecuteScheduledAdjustments_v2')
    DROP PROCEDURE dbo.sp_ExecuteScheduledAdjustments_v2;

EXEC sp_executesql N'
CREATE PROCEDURE dbo.sp_ExecuteScheduledAdjustments_v2
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @adj_idx INT;
    DECLARE @adj_name NVARCHAR(100);
    DECLARE @count INT = 0;

    DECLARE cur CURSOR FOR
    SELECT adj_idx, adj_name
    FROM tkd001.dbo.tng_price_adjustment
    WHERE is_executed = 0 AND apply_date <= GETDATE()
    ORDER BY apply_date;

    OPEN cur;
    FETCH NEXT FROM cur INTO @adj_idx, @adj_name;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            EXEC tkd001.dbo.sp_ApplyPriceAdjustment_v2 @adj_idx;
            SET @count = @count + 1;
        END TRY
        BEGIN CATCH
            PRINT ''Failed: '' + ERROR_MESSAGE();
        END CATCH

        FETCH NEXT FROM cur INTO @adj_idx, @adj_name;
    END

    CLOSE cur;
    DEALLOCATE cur;
END';

PRINT '>> sp_ExecuteScheduledAdjustments_v2 생성 완료';


-- ============================================================================
-- 10단계: sp_PreviewPriceAdjustment (미리보기)
-- ============================================================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_PreviewPriceAdjustment')
    DROP PROCEDURE dbo.sp_PreviewPriceAdjustment;

EXEC sp_executesql N'
CREATE PROCEDURE dbo.sp_PreviewPriceAdjustment
    @adj_rate DECIMAL(5,2),
    @adj_type VARCHAR(20) = ''ALL'',
    @target_bfwidx INT = NULL,
    @target_qtyco INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 10
        N''수동/자동'' as 구분,
        s.SJB_TYPE_NO,
        s.SJB_barlist,
        CASE s.SJB_FA WHEN 1 THEN N''수동'' WHEN 2 THEN N''자동'' END as 프레임타입,
        t.unittype_bfwidx,
        t.unittype_qtyco_idx,
        t.price as 현재가,
        CAST(t.price * (1 + @adj_rate / 100.0) AS INT) as 인상후,
        s.pcent
    FROM tkd001.dbo.tng_unitprice_t t
    INNER JOIN tkd001.dbo.TNG_SJB s ON t.SJB_IDX = s.SJB_IDX
    WHERE
        (
            (@adj_type = ''ALL'') OR
            (@adj_type = ''MANUAL'' AND s.SJB_FA = 1) OR
            (@adj_type = ''AUTO'' AND s.SJB_FA = 2)
        )
        AND (s.pcent = 1 OR s.pcent IS NULL)
        AND (@target_bfwidx IS NULL OR t.unittype_bfwidx = @target_bfwidx)
        AND (@target_qtyco IS NULL OR t.unittype_qtyco_idx = @target_qtyco)
        AND t.price > 0
    ORDER BY s.SJB_TYPE_NO, t.unittype_bfwidx;

    SELECT
        @adj_type as 인상대상,
        COUNT(*) as 영향받는_행수,
        SUM(t.price) as 현재_총액,
        SUM(CAST(t.price * (1 + @adj_rate / 100.0) AS INT)) as 인상후_총액
    FROM tkd001.dbo.tng_unitprice_t t
    INNER JOIN tkd001.dbo.TNG_SJB s ON t.SJB_IDX = s.SJB_IDX
    WHERE
        (
            (@adj_type = ''ALL'') OR
            (@adj_type = ''MANUAL'' AND s.SJB_FA = 1) OR
            (@adj_type = ''AUTO'' AND s.SJB_FA = 2)
        )
        AND (s.pcent = 1 OR s.pcent IS NULL)
        AND (@target_bfwidx IS NULL OR t.unittype_bfwidx = @target_bfwidx)
        AND (@target_qtyco IS NULL OR t.unittype_qtyco_idx = @target_qtyco);
END';

PRINT '>> sp_PreviewPriceAdjustment 생성 완료';

PRINT '================================================';
PRINT '001서버 단가 인상 시스템 v2.0 설치 완료!';
PRINT '================================================';
