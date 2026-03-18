/*
================================================================================
001서버 (tkd001) 단가 인상 상태 진단 + 롤백
================================================================================
DBeaver에서 tkd001 DB 선택 후 단계별로 실행하세요
================================================================================
*/

-- ============================================================================
-- 1단계: 현재 테이블 존재 여부 확인
-- ============================================================================

SELECT 'tng_price_adjustment' as 테이블명, COUNT(*) as 존재여부 FROM sys.tables WHERE name = 'tng_price_adjustment'
UNION ALL
SELECT 'tng_price_backup_t', COUNT(*) FROM sys.tables WHERE name = 'tng_price_backup_t'
UNION ALL
SELECT 'tng_price_backup_al', COUNT(*) FROM sys.tables WHERE name = 'tng_price_backup_al'
UNION ALL
SELECT 'tng_price_history', COUNT(*) FROM sys.tables WHERE name = 'tng_price_history';


-- ============================================================================
-- 2단계: 인상 이력 확인 (tng_price_adjustment가 있을 경우)
-- ============================================================================

-- 실행된 인상 내역
SELECT * FROM tkd001.dbo.tng_price_adjustment ORDER BY adj_idx DESC;


-- ============================================================================
-- 3단계: 백업 데이터 확인
-- ============================================================================

-- tng_price_backup_t 백업 건수
SELECT backup_id, adj_idx, COUNT(*) as 건수
FROM tkd001.dbo.tng_price_backup_t
GROUP BY backup_id, adj_idx;

-- tng_price_backup_al 백업 건수
SELECT backup_id, adj_idx, COUNT(*) as 건수
FROM tkd001.dbo.tng_price_backup_al
GROUP BY backup_id, adj_idx;


-- ============================================================================
-- 4단계: 백업 데이터로 롤백 (backup_id 확인 후 아래 실행)
-- ============================================================================
-- ※ 위 3단계에서 나온 backup_id를 아래에 넣으세요

/*
-- tng_unitprice_t 롤백
UPDATE t
SET t.price = b.price
FROM tkd001.dbo.tng_unitprice_t t
INNER JOIN tkd001.dbo.tng_price_backup_t b ON t.uptidx = b.uptidx
WHERE b.backup_id = 'ADJ_여기에_백업ID_입력';

-- tng_unitprice_al 롤백
UPDATE al
SET al.price_bk = b.price_bk,
    al.price_etl = b.price_etl
FROM tkd001.dbo.tng_unitprice_al al
INNER JOIN tkd001.dbo.tng_price_backup_al b ON al.ualidx = b.ualidx
WHERE b.backup_id = 'ADJ_여기에_백업ID_입력';

-- 인상 상태 되돌리기
UPDATE tkd001.dbo.tng_price_adjustment
SET is_executed = 0, executed_at = NULL,
    affected_rows_t = NULL, affected_rows_al = NULL
WHERE backup_id = 'ADJ_여기에_백업ID_입력';
*/


-- ============================================================================
-- 5단계: 백업 데이터가 없을 경우 - 수동 확인
-- 어떤 컬럼이 인상됐는지 확인
-- ============================================================================

-- tng_unitprice_t에서 price가 0이 아닌 레코드 샘플 (현재 가격 확인)
SELECT TOP 20 uptidx, SJB_IDX, unittype_bfwidx, unittype_qtyco_idx, price
FROM tkd001.dbo.tng_unitprice_t
WHERE price > 0
ORDER BY uptidx;

-- tng_unitprice_al에서 현재 가격 확인
SELECT TOP 20 ualidx, SJB_IDX, fidx, price_bk, price_etl
FROM tkd001.dbo.tng_unitprice_al
WHERE price_bk > 0
ORDER BY ualidx;
