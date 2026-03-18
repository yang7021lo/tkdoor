/*
================================================================================
001서버 단가 상태 진단 - 10% 중첩 인상 확인
================================================================================
DBeaver에서 tkd001 DB 선택 후 단계별로 실행
================================================================================
*/

-- ============================================================================
-- 1단계: 인상 이력 전체 확인 (몇 번 실행됐는지)
-- ============================================================================
SELECT
    adj_idx,
    adj_name,
    adj_rate,
    adj_type,
    is_executed,
    executed_at,
    affected_rows_t,
    affected_rows_al,
    backup_id,
    apply_date,
    created_at
FROM tkd001.dbo.tng_price_adjustment
ORDER BY adj_idx;


-- ============================================================================
-- 2단계: 백업 데이터 건수 확인 (백업별)
-- ============================================================================
SELECT 'tng_price_backup_t' as 테이블, backup_id, adj_idx, COUNT(*) as 건수
FROM tkd001.dbo.tng_price_backup_t
GROUP BY backup_id, adj_idx
UNION ALL
SELECT 'tng_price_backup_al', backup_id, adj_idx, COUNT(*)
FROM tkd001.dbo.tng_price_backup_al
GROUP BY backup_id, adj_idx;


-- ============================================================================
-- 3단계: AL 테이블 - 현재가 vs 백업가 비교 (TOP 30)
-- 차이가 있으면 롤백 안 된 것, 같으면 롤백 된 것
-- ============================================================================
SELECT TOP 30
    al.ualidx,
    al.SJB_IDX,
    al.fidx,
    b.price_bk as [백업_price_bk],
    al.price_bk as [현재_price_bk],
    CASE
        WHEN al.price_bk = b.price_bk THEN '동일 (롤백됨)'
        WHEN al.price_bk > b.price_bk THEN '현재가 높음 (인상 상태)'
        ELSE '현재가 낮음'
    END as 상태,
    CASE
        WHEN b.price_bk > 0 THEN CAST(ROUND((al.price_bk - b.price_bk) * 100.0 / b.price_bk, 2) AS VARCHAR) + '%'
        ELSE '-'
    END as 차이율
FROM tkd001.dbo.tng_unitprice_al al
INNER JOIN tkd001.dbo.tng_price_backup_al b ON al.ualidx = b.ualidx
WHERE b.price_bk > 0
ORDER BY al.ualidx;


-- ============================================================================
-- 4단계: T 테이블 - 현재가 vs 백업가 비교 (TOP 30)
-- ============================================================================
SELECT TOP 30
    t.uptidx,
    t.SJB_IDX,
    t.unittype_bfwidx,
    t.unittype_qtyco_idx,
    b.price as [백업_price],
    t.price as [현재_price],
    CASE
        WHEN t.price = b.price THEN '동일 (롤백됨)'
        WHEN t.price > b.price THEN '현재가 높음 (인상 상태)'
        ELSE '현재가 낮음'
    END as 상태,
    CASE
        WHEN b.price > 0 THEN CAST(ROUND((t.price - b.price) * 100.0 / b.price, 2) AS VARCHAR) + '%'
        ELSE '-'
    END as 차이율
FROM tkd001.dbo.tng_unitprice_t t
INNER JOIN tkd001.dbo.tng_price_backup_t b ON t.uptidx = b.uptidx
WHERE b.price > 0
ORDER BY t.uptidx;


-- ============================================================================
-- 5단계: 중첩 인상 확인 - 10% 두 번이면 21% 차이
-- AL 테이블 요약 통계
-- ============================================================================
SELECT
    COUNT(*) as 전체건수,
    SUM(CASE WHEN al.price_bk = b.price_bk THEN 1 ELSE 0 END) as [동일(롤백됨)],
    SUM(CASE WHEN al.price_bk > b.price_bk THEN 1 ELSE 0 END) as [현재가높음(인상상태)],
    AVG(CASE WHEN b.price_bk > 0 THEN (al.price_bk - b.price_bk) * 100.0 / b.price_bk END) as [평균차이율],
    MIN(CASE WHEN b.price_bk > 0 THEN (al.price_bk - b.price_bk) * 100.0 / b.price_bk END) as [최소차이율],
    MAX(CASE WHEN b.price_bk > 0 THEN (al.price_bk - b.price_bk) * 100.0 / b.price_bk END) as [최대차이율]
FROM tkd001.dbo.tng_unitprice_al al
INNER JOIN tkd001.dbo.tng_price_backup_al b ON al.ualidx = b.ualidx
WHERE b.price_bk > 0;


-- ============================================================================
-- 6단계: T 테이블 요약 통계
-- ============================================================================
SELECT
    COUNT(*) as 전체건수,
    SUM(CASE WHEN t.price = b.price THEN 1 ELSE 0 END) as [동일(롤백됨)],
    SUM(CASE WHEN t.price > b.price THEN 1 ELSE 0 END) as [현재가높음(인상상태)],
    AVG(CASE WHEN b.price > 0 THEN (t.price - b.price) * 100.0 / b.price END) as [평균차이율],
    MIN(CASE WHEN b.price > 0 THEN (t.price - b.price) * 100.0 / b.price END) as [최소차이율],
    MAX(CASE WHEN b.price > 0 THEN (t.price - b.price) * 100.0 / b.price END) as [최대차이율]
FROM tkd001.dbo.tng_unitprice_t t
INNER JOIN tkd001.dbo.tng_price_backup_t b ON t.uptidx = b.uptidx
WHERE b.price > 0;


-- ============================================================================
-- 7단계: 변경 이력 확인 (tng_price_history)
-- 롤백 포함 전체 이력
-- ============================================================================
SELECT TOP 20
    history_idx,
    adj_idx,
    adj_name,
    table_type,
    price_field,
    price_before,
    price_after,
    change_amount,
    CAST(change_rate AS VARCHAR) + '%' as 변동률,
    change_type,
    changed_at
FROM tkd001.dbo.tng_price_history
ORDER BY history_idx DESC;


-- ============================================================================
-- 8단계: AL 특정 가격 샘플 확인 (330000 기준)
-- 원래 330000 → 10% 1회 = 363000 → 10% 2회 = 399300
-- ============================================================================
SELECT
    al.ualidx,
    al.SJB_IDX,
    al.price_bk as 현재가,
    CASE
        WHEN al.price_bk = 330000 THEN '원래가격'
        WHEN al.price_bk = 363000 THEN '10% 1회 인상'
        WHEN al.price_bk = 399300 THEN '10% 2회 인상 (중첩!)'
        ELSE '기타'
    END as 판정
FROM tkd001.dbo.tng_unitprice_al al
WHERE al.price_bk IN (330000, 363000, 399300)
ORDER BY al.price_bk;
