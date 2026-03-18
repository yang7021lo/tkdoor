<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

rSJB_IDX = Request("SJB_IDX")
rSJB_TYPE_NAME = Request("SJB_TYPE_NAME")
rSJB_barlist = Request("SJB_barlist")

If rSJB_IDX = "" Or IsNull(rSJB_IDX) Then rSJB_IDX = "0"

call dbClose()
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>자동 프레임 단가 - <%=rSJB_TYPE_NAME%> <%=rSJB_barlist%></title>
    
    <!-- Tabulator CSS -->
    <link href="https://unpkg.com/tabulator-tables@5.5.0/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            padding: 15px;
            background: #ffffff;
        }
        .header-info {
            background: #333333;
            color: white;
            padding: 15px 20px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .header-info h4 { margin: 0; font-size: 24px; }
        .header-info small { opacity: 1; font-size: 18px; font-weight: bold; }

        #price-table {
            background: white;
            border: 2px solid #333;
        }

        /* Tabulator 셀 스타일 - 글씨 크게 */
        .tabulator-cell {
            font-size: 16px !important;
            padding: 8px 10px !important;
        }
        .tabulator-col-title {
            font-weight: bold !important;
            font-size: 15px !important;
            background: #f0f0f0 !important;
            color: #000 !important;
            overflow: visible !important;
            white-space: nowrap !important;
            text-overflow: clip !important;
        }
        .tabulator .tabulator-header .tabulator-col {
            min-width: fit-content !important;
        }

        /* 행 헤더 (바 종류) */
        .row-header {
            background: #f5f5f5 !important;
            font-weight: bold !important;
            font-size: 15px !important;
        }

        /* 수정된 셀 */
        .cell-modified {
            background: #e0e0e0 !important;
        }

        /* 저장 완료 셀 */
        .cell-saved {
            background: #c8c8c8 !important;
            transition: background 0.3s;
        }

        /* 연동 저장된 셀 */
        .cell-linked {
            background: #d0d0d0 !important;
            transition: background 0.3s;
        }

        /* 로딩 오버레이 */
        .loading-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(255,255,255,0.9);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }
        .loading-overlay.show { display: flex; }

        .status-bar {
            margin-top: 10px;
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 14px;
        }
        .status-bar.success { background: #e0e0e0; color: #000; }
        .status-bar.error { background: #333; color: #fff; }
        .status-bar.info { background: #f5f5f5; color: #333; }

        /* 연동 안내 */
        .link-info {
            background: #f5f5f5;
            border-left: 6px solid #333;
            padding: 15px 20px;
            margin-bottom: 15px;
            font-size: 18px;
            font-weight: bold;
            color: #000;
            border-radius: 0 4px 4px 0;
        }
        .link-info strong { color: #000; font-size: 20px; }
    </style>
</head>
<body>

<!-- 로딩 오버레이 -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="spinner-border text-success" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<!-- 헤더 -->
<div class="header-info">
    <h4><%=rSJB_TYPE_NAME%> - <%=rSJB_barlist%></h4>
    <small>자동 프레임 단가표 (셀 클릭 → 수정 → Enter 저장)</small>
</div>

<!-- 연동 안내 -->
<div class="link-info">
    <strong>🔗 자동 연동:</strong>
    갈바 → 지급판(80%) | 
    블랙H/L → 바이브, 헤어1.5 | 
    중간소대 → 픽스하바 | 
    가로남마 → 자동&픽스바
</div>

<!-- 버튼 영역 -->
<div class="mb-2 d-flex gap-2">
    <button class="btn btn-success btn-sm" onclick="loadData()">
        <i class="fas fa-sync-alt"></i> 새로고침
    </button>
    <button class="btn btn-primary btn-sm" onclick="saveAllModified()">
        <i class="fas fa-save"></i> 변경사항 모두 저장
    </button>
    <button class="btn btn-secondary btn-sm" onclick="window.close()">
        <i class="fas fa-times"></i> 닫기
    </button>
    <span class="ms-auto text-muted" id="modifiedCount"></span>
</div>

<!-- Tabulator 테이블 -->
<div id="price-table"></div>

<!-- 상태바 -->
<div class="status-bar info" id="statusBar">데이터 로딩 중...</div>

<!-- Tabulator JS -->
<script src="https://unpkg.com/tabulator-tables@5.5.0/dist/js/tabulator.min.js"></script>
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js"></script>

<script>
// ============================================================
// 전역 변수
// ============================================================
const SJB_IDX = "<%=rSJB_IDX%>";
const SJB_TYPE_NAME = "<%=rSJB_TYPE_NAME%>";
const SJB_barlist = "<%=rSJB_barlist%>";
const FRAME_TYPE = "auto"; // 자동

let table = null;
let bfwidxList = [];    // 바 종류 목록
let qtycoList = [];     // 재질 종류 목록
let priceData = [];     // 가격 데이터
let modifiedCells = {}; // 수정된 셀 추적

// 연동 규칙 정의
const LINK_RULES = {
    // qtyco_idx 기반 연동
    qtyco: {
        3: [{ target_qtyco: 8, ratio: 0.8 }],           // 갈바(3) → 지급판(8) 80%
        4: [{ target_qtyco: 6, ratio: 1 }, { target_qtyco: 11, ratio: 1 }]  // 블랙H/L(4) → 바이브(6), 헤어1.5(11)
    },
    // bfwidx 기반 연동
    bfwidx: {
        4: [{ target_bfwidx: 6, ratio: 1 }],  // 중간소대(4) → 픽스하바(6)
        3: [{ target_bfwidx: 5, ratio: 1 }]   // 가로남마(3) → 자동&픽스바(5)
    }
};

// ============================================================
// 초기화
// ============================================================
document.addEventListener('DOMContentLoaded', async function() {
    showLoading(true);
    
    try {
        // 1. 바 종류 목록 조회
        bfwidxList = await fetchAPI('get_bfwidx_list', { frame_type: FRAME_TYPE });
        
        // 2. 재질 종류 목록 조회
        qtycoList = await fetchAPI('get_qtyco_list', {});
        
        // 3. 가격 데이터 조회
        priceData = await fetchAPI('get_prices', {});
        
        // 4. 테이블 생성
        createTable();
        
        setStatus('데이터 로딩 완료 (' + priceData.length + '건)', 'success');
    } catch (err) {
        setStatus('오류: ' + err.message, 'error');
    }
    
    showLoading(false);
});

// ============================================================
// API 호출
// ============================================================
async function fetchAPI(action, params = {}) {
    const url = new URL('unittype_api.asp', window.location.href);
    url.searchParams.set('action', action);
    url.searchParams.set('SJB_IDX', SJB_IDX);
    
    for (const [key, value] of Object.entries(params)) {
        url.searchParams.set(key, value);
    }
    
    const response = await fetch(url);
    if (!response.ok) throw new Error('서버 오류');
    return response.json();
}

async function savePrice(uptidx, bfwidx, qtyco_idx, price, useAutoLink = true) {
    const params = new URLSearchParams();
    params.set('action', useAutoLink ? 'save_price_auto' : 'save_price');
    params.set('SJB_IDX', SJB_IDX);
    params.set('uptidx', uptidx || 0);
    params.set('bfwidx', bfwidx);
    params.set('qtyco_idx', qtyco_idx);
    params.set('price', price);
    
    const response = await fetch('unittype_api.asp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
    });
    
    return response.json();
}

// ============================================================
// 테이블 생성
// ============================================================
function createTable() {
    // 컬럼 정의: [바종류명] + [각 재질별 컬럼]
    const columns = [
        {
            title: "바 종류",
            field: "bfwidx_name",
            frozen: true,
            minWidth: 120,
            cssClass: "row-header",
            headerSort: false
        }
    ];
    
    // 재질별 컬럼 추가 (정렬순서대로)
    qtycoList.sort((a, b) => a.id - b.id).forEach(qtyco => {
        columns.push({
            title: qtyco.name,
            field: "price_" + qtyco.id,
            minWidth: 90,
            hozAlign: "right",
            headerSort: false,
            editor: "number",
            editorParams: {
                min: 0,
                step: 1
            },
            formatter: function(cell) {
                const val = cell.getValue();
                if (val === null || val === undefined || val === 0) return "-";
                return Number(val).toLocaleString();
            },
            cellEdited: function(cell) {
                onCellEdited(cell);
            }
        });
    });
    
    // 테이블 데이터 생성
    const tableData = bfwidxList.sort((a, b) => a.id - b.id).map(bfw => {
        const row = {
            bfwidx: bfw.id,
            bfwidx_name: bfw.name
        };
        
        qtycoList.forEach(qtyco => {
            const priceInfo = priceData.find(p => 
                p.bfwidx == bfw.id && p.qtyco_idx == qtyco.id
            );
            
            row["price_" + qtyco.id] = priceInfo ? priceInfo.price : 0;
            row["uptidx_" + qtyco.id] = priceInfo ? priceInfo.uptidx : 0;
        });
        
        return row;
    });
    
    // Tabulator 생성
    table = new Tabulator("#price-table", {
        data: tableData,
        layout: "fitData",
        height: "auto",
        columns: columns
    });
}

// ============================================================
// 셀 편집 이벤트
// ============================================================
function onCellEdited(cell) {
    const field = cell.getField();
    const qtyco_idx = parseInt(field.replace("price_", ""));
    const row = cell.getRow().getData();
    const bfwidx = parseInt(row.bfwidx);
    const uptidx = row["uptidx_" + qtyco_idx] || 0;
    const newValue = cell.getValue() || 0;
    
    // 수정된 셀 추적
    const key = bfwidx + "_" + qtyco_idx;
    modifiedCells[key] = {
        uptidx: uptidx,
        bfwidx: bfwidx,
        qtyco_idx: qtyco_idx,
        price: newValue,
        cell: cell
    };
    
    // 셀 스타일 변경
    cell.getElement().classList.add('cell-modified');
    
    // 수정 개수 표시
    updateModifiedCount();
    
    // 자동 저장 + 연동 처리
    autoSaveWithLink(key, bfwidx, qtyco_idx, newValue);
}

// ============================================================
// 자동 저장 (연동 포함)
// ============================================================
async function autoSaveWithLink(key, bfwidx, qtyco_idx, price) {
    const data = modifiedCells[key];
    if (!data) return;
    
    try {
        // 서버에서 연동 처리 (save_price_auto)
        const result = await savePrice(data.uptidx, bfwidx, qtyco_idx, price, true);
        
        if (result.success) {
            // 저장 완료 스타일
            data.cell.getElement().classList.remove('cell-modified');
            data.cell.getElement().classList.add('cell-saved');
            
            setTimeout(() => {
                data.cell.getElement().classList.remove('cell-saved');
            }, 1500);
            
            // 추적에서 제거
            delete modifiedCells[key];
            updateModifiedCount();
            
            // 연동된 셀 UI 업데이트
            await updateLinkedCells(bfwidx, qtyco_idx, price);
            
            setStatus('저장 완료 (연동 포함)', 'success');
        } else {
            setStatus('저장 실패: ' + (result.error || '알 수 없는 오류'), 'error');
        }
    } catch (err) {
        setStatus('저장 오류: ' + err.message, 'error');
    }
}

// ============================================================
// 연동된 셀 UI 업데이트
// ============================================================
async function updateLinkedCells(bfwidx, qtyco_idx, price) {
    // 데이터 다시 로드해서 연동된 값 반영
    priceData = await fetchAPI('get_prices', {});
    
    // qtyco 연동 규칙 체크
    if (LINK_RULES.qtyco[qtyco_idx]) {
        LINK_RULES.qtyco[qtyco_idx].forEach(rule => {
            const linkedPrice = Math.round(price * rule.ratio);
            updateCellUI(bfwidx, rule.target_qtyco, linkedPrice);
        });
    }
    
    // bfwidx 연동 규칙 체크
    if (LINK_RULES.bfwidx[bfwidx]) {
        LINK_RULES.bfwidx[bfwidx].forEach(rule => {
            const linkedPrice = Math.round(price * rule.ratio);
            updateCellUI(rule.target_bfwidx, qtyco_idx, linkedPrice);
        });
    }
}

function updateCellUI(bfwidx, qtyco_idx, newPrice) {
    const rows = table.getRows();
    rows.forEach(row => {
        const rowData = row.getData();
        if (rowData.bfwidx == bfwidx) {
            const field = "price_" + qtyco_idx;
            row.update({ [field]: newPrice });
            
            // 연동 표시
            const cell = row.getCell(field);
            if (cell) {
                cell.getElement().classList.add('cell-linked');
                setTimeout(() => {
                    cell.getElement().classList.remove('cell-linked');
                }, 2000);
            }
        }
    });
}

// ============================================================
// 전체 저장
// ============================================================
async function saveAllModified() {
    const keys = Object.keys(modifiedCells);
    if (keys.length === 0) {
        setStatus('변경된 항목이 없습니다.', 'info');
        return;
    }

    showLoading(true);
    let successCount = 0;

    for (const key of keys) {
        const data = modifiedCells[key];
        if (data) {
            await autoSaveWithLink(key, data.bfwidx, data.qtyco_idx, data.price);
            successCount++;
        }
    }

    showLoading(false);
    setStatus(successCount + '건 저장 완료', 'success');
}

// ============================================================
// 데이터 새로고침
// ============================================================
async function loadData() {
    showLoading(true);
    modifiedCells = {};
    
    try {
        priceData = await fetchAPI('get_prices', {});
        
        const tableData = bfwidxList.sort((a, b) => a.id - b.id).map(bfw => {
            const row = {
                bfwidx: bfw.id,
                bfwidx_name: bfw.name
            };
            
            qtycoList.forEach(qtyco => {
                const priceInfo = priceData.find(p => 
                    p.bfwidx == bfw.id && p.qtyco_idx == qtyco.id
                );
                
                row["price_" + qtyco.id] = priceInfo ? priceInfo.price : 0;
                row["uptidx_" + qtyco.id] = priceInfo ? priceInfo.uptidx : 0;
            });
            
            return row;
        });
        
        table.setData(tableData);
        updateModifiedCount();
        setStatus('새로고침 완료 (' + priceData.length + '건)', 'success');
    } catch (err) {
        setStatus('새로고침 오류: ' + err.message, 'error');
    }
    
    showLoading(false);
}

// ============================================================
// UI 헬퍼
// ============================================================
function showLoading(show) {
    document.getElementById('loadingOverlay').classList.toggle('show', show);
}

function setStatus(msg, type) {
    const bar = document.getElementById('statusBar');
    bar.textContent = msg;
    bar.className = 'status-bar ' + type;
}

function updateModifiedCount() {
    const count = Object.keys(modifiedCells).length;
    document.getElementById('modifiedCount').textContent = 
        count > 0 ? '⚠️ 미저장 ' + count + '건' : '';
}
</script>

</body>
</html>
