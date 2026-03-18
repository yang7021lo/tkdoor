/*
================================================================================
001서버 3회 중첩 인상 롤백 - ADJ_1 백업으로 원래 가격 복원
================================================================================
DBeaver에서 tkd001 DB 선택 후 실행
실행 전 반드시 1단계로 먼저 확인!
================================================================================
*/

-- ============================================================================
-- 1단계: 롤백 전 확인 (먼저 실행해서 상태 확인)
-- ============================================================================

-- ADJ_1 백업 vs 현재가 비교 (AL)
SELECT TOP 10
    al.ualidx,
    b.price_bk as [원래가(백업)],
    al.price_bk as [현재가],
    CAST(ROUND((al.price_bk - b.price_bk) * 100.0 / b.price_bk, 2) AS VARCHAR) + '%' as 차이율
FROM tkd001.dbo.tng_unitprice_al al
INNER JOIN tkd001.dbo.tng_price_backup_al b ON al.ualidx = b.ualidx
WHERE b.backup_id = 'ADJ_1_20260209_123040' AND b.price_bk > 0;

-- ADJ_1 백업 vs 현재가 비교 (T)
SELECT TOP 10
    t.uptidx,
    b.price as [원래가(백업)],
    t.price as [현재가],
    CAST(ROUND((t.price - b.price) * 100.0 / b.price, 2) AS VARCHAR) + '%' as 차이율
FROM tkd001.dbo.tng_unitprice_t t
INNER JOIN tkd001.dbo.tng_price_backup_t b ON t.uptidx = b.uptidx
WHERE b.backup_id = 'ADJ_1_20260209_123040' AND b.price > 0;


-- ============================================================================
-- 2단계: T 테이블 원래 가격으로 복원 (ADJ_1 백업 사용)
-- ============================================================================

UPDATE t
SET t.price = b.price
FROM tkd001.dbo.tng_unitprice_t t
INNER JOIN tkd001.dbo.tng_price_backup_t b ON t.uptidx = b.uptidx
WHERE b.backup_id = 'ADJ_1_20260209_123040';
-- 결과: 699건 예상


-- ============================================================================
-- 3단계: AL 테이블 원래 가격으로 복원 (ADJ_1 백업 사용)
-- ============================================================================

UPDATE al
SET al.price_bk = b.price_bk,
    al.price_etl = b.price_etl
FROM tkd001.dbo.tng_unitprice_al al
INNER JOIN tkd001.dbo.tng_price_backup_al b ON al.ualidx = b.ualidx
WHERE b.backup_id = 'ADJ_1_20260209_123040';
-- 결과: 360건 예상


-- ============================================================================
-- 4단계: 인상 이력 상태 초기화 (3개 모두)
-- ============================================================================

UPDATE tkd001.dbo.tng_price_adjustment
SET is_executed = 0, executed_at = NULL,
    affected_rows_t = NULL, affected_rows_al = NULL
WHERE adj_idx IN (1, 2, 3);


-- ============================================================================
-- 5단계: 복원 확인
-- ============================================================================

-- AL 현재가 확인 (330000 복원됐는지)
SELECT TOP 10 ualidx, SJB_IDX, fidx, price_bk, price_etl
FROM tkd001.dbo.tng_unitprice_al
WHERE price_bk > 0
ORDER BY ualidx;

-- T 현재가 확인
SELECT TOP 10 uptidx, SJB_IDX, unittype_bfwidx, unittype_qtyco_idx, price
FROM tkd001.dbo.tng_unitprice_t
WHERE price > 0
ORDER BY uptidx;

-- 인상 이력 상태 확인
SELECT adj_idx, adj_name, is_executed, backup_id
FROM tkd001.dbo.tng_price_adjustment
ORDER BY adj_idx;


-- ============================================================================
-- 6단계: 중복 예약 삭제 (adj_idx 2, 3 삭제하고 1만 남기기)
-- 확인 후 실행!
-- ============================================================================

/*
DELETE FROM tkd001.dbo.tng_price_adjustment WHERE adj_idx IN (2, 3);
DELETE FROM tkd001.dbo.tng_price_backup_t WHERE adj_idx IN (2, 3);
DELETE FROM tkd001.dbo.tng_price_backup_al WHERE adj_idx IN (2, 3);
*/
