/*
================================================================================
단가 인상 시스템 패치 - 롤백 & 스케줄러 결과 반환 수정
================================================================================
DB: tkd001 (DBeaver용 - GO 없음)
날짜: 2026-02-09
수정: sp_RollbackPriceAdjustment, sp_ExecuteScheduledAdjustments_v2
================================================================================
*/


-- ============================================================================
-- 1. sp_RollbackPriceAdjustment 패치
--    - 백업 존재 확인 강화
--    - 결과 SELECT 반환 추가
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
    DECLARE @backup_count_t INT = 0;
    DECLARE @backup_count_al INT = 0;

    -- 백업 데이터 존재 확인
    SELECT @backup_count_t = COUNT(*) FROM tkd001.dbo.tng_price_backup_t WHERE backup_id = @backup_id;
    SELECT @backup_count_al = COUNT(*) FROM tkd001.dbo.tng_price_backup_al WHERE backup_id = @backup_id;

    IF @backup_count_t = 0 AND @backup_count_al = 0
    BEGIN
        RAISERROR(N''백업 데이터가 없습니다 (backup_id: %s)'', 16, 1, @backup_id);
        RETURN;
    END

    -- adj_idx 찾기
    IF @backup_count_t > 0
        SELECT TOP 1 @adj_idx = adj_idx FROM tkd001.dbo.tng_price_backup_t WHERE backup_id = @backup_id;
    ELSE
        SELECT TOP 1 @adj_idx = adj_idx FROM tkd001.dbo.tng_price_backup_al WHERE backup_id = @backup_id;

    SELECT @adj_name = adj_name FROM tkd001.dbo.tng_price_adjustment WHERE adj_idx = @adj_idx;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- T 테이블 롤백
        IF @backup_count_t > 0
        BEGIN
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
        END

        -- AL 테이블 롤백
        IF @backup_count_al > 0
        BEGIN
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
        END

        -- 상태 되돌리기
        UPDATE tkd001.dbo.tng_price_adjustment
        SET is_executed = 0, executed_at = NULL,
            affected_rows_t = NULL, affected_rows_al = NULL
        WHERE backup_id = @backup_id;

        COMMIT TRANSACTION;

        -- 결과 반환
        SELECT ''SUCCESS'' as result,
               @count_t as rolled_back_t,
               @count_al as rolled_back_al,
               @adj_name as adj_name,
               @backup_count_t as backup_count_t,
               @backup_count_al as backup_count_al;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(N''롤백 실패: %s'', 16, 1, @err);
    END CATCH
END';

PRINT '>> sp_RollbackPriceAdjustment 패치 완료';


-- ============================================================================
-- 2. sp_ExecuteScheduledAdjustments_v2 패치
--    - 실행 결과/실패 건수 반환
--    - 대기 건수 확인 추가
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
    DECLARE @fail_count INT = 0;
    DECLARE @fail_msg NVARCHAR(4000) = N'''';
    DECLARE @pending INT = 0;

    -- 대기 건수 확인
    SELECT @pending = COUNT(*)
    FROM tkd001.dbo.tng_price_adjustment
    WHERE is_executed = 0 AND apply_date <= GETDATE();

    IF @pending = 0
    BEGIN
        SELECT 0 as executed_count, 0 as fail_count, 0 as pending_count,
               N''대기 중인 예약이 없습니다'' as message;
        RETURN;
    END

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
            SET @fail_count = @fail_count + 1;
            IF LEN(@fail_msg) < 3000
                SET @fail_msg = @fail_msg + @adj_name + N'': '' + ERROR_MESSAGE() + N'' | '';
        END CATCH

        FETCH NEXT FROM cur INTO @adj_idx, @adj_name;
    END

    CLOSE cur;
    DEALLOCATE cur;

    -- 결과 반환
    SELECT @count as executed_count,
           @fail_count as fail_count,
           @pending as pending_count,
           CASE
               WHEN @fail_count = 0 AND @count > 0 THEN N''성공: '' + CAST(@count AS NVARCHAR) + N''건 자동실행 완료''
               WHEN @fail_count > 0 THEN N''성공: '' + CAST(@count AS NVARCHAR) + N''건, 실패: '' + CAST(@fail_count AS NVARCHAR) + N''건 - '' + @fail_msg
               ELSE N''처리 완료''
           END as message;
END';

PRINT '>> sp_ExecuteScheduledAdjustments_v2 패치 완료';

PRINT '================================================';
PRINT '패치 완료! 두 프로시저가 업데이트되었습니다.';
PRINT '================================================';
