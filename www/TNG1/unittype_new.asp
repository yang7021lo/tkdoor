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
    <title>수동 프레임 단가 - <%=rSJB_TYPE_NAME%> <%=rSJB_barlist%></title>
    
    <!-- Tabulator CSS -->
    <link href="https://unpkg.com/tabulator-tables@5.5.0/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- AutoNumeric (숫자 포맷) -->
    <script src="https://cdn.jsdelivr.net/npm/autonumeric@4.8.1/dist/autoNumeric.min.js"></script>
    
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
    </style>
</head>
<body>

<!-- 로딩 오버레이 -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<!-- 헤더 -->
<div class="header-info">
    <h4><%=rSJB_TYPE_NAME%> - <%=rSJB_barlist%></h4>
    <small>수동 프레임 단가표 (셀 클릭 → 수정 → Enter 저장)</small>
</div>

<!-- 버튼 영역 -->
<div class="mb-2 d-flex gap-2">
    <button class="btn btn-primary btn-sm" onclick="loadData()">
        <i class="fas fa-sync-alt"></i> 새로고침
    </button>
    <button class="btn btn-success btn-sm" onclick="saveAllModified()">
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
const FRAME_TYPE = "manual"; // 수동

let table = null;
let bfwidxList = [];    // 바 종류 목록
let qtycoList = [];     // 재질 종류 목록
let priceData = [];     // 가격 데이터
let modifiedCells = {}; // 수정된 셀 추적

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

async function savePrice(uptidx, bfwidx, qtyco_idx, price) {
    const params = new URLSearchParams();
    params.set('action', 'save_price');
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
    
    // 테이블 데이터 생성 (바 종류별 행)
    const tableData = bfwidxList.sort((a, b) => a.id - b.id).map(bfw => {
        const row = {
            bfwidx: bfw.id,
            bfwidx_name: bfw.name
        };
        
        // 각 재질별 가격 매핑
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
    const qtyco_idx = field.replace("price_", "");
    const row = cell.getRow().getData();
    const bfwidx = row.bfwidx;
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
    
    // 자동 저장 (Enter 시)
    autoSave(key);
}

// ============================================================
// 자동 저장
// ============================================================
async function autoSave(key) {
    const data = modifiedCells[key];
    if (!data) return;
    
    try {
        const result = await savePrice(data.uptidx, data.bfwidx, data.qtyco_idx, data.price);
        
        if (result.success) {
            // 새 uptidx 업데이트
            if (result.action === 'insert' && result.uptidx) {
                const row = data.cell.getRow();
                row.update({ ["uptidx_" + data.qtyco_idx]: result.uptidx });
            }
            
            // 저장 완료 스타일
            data.cell.getElement().classList.remove('cell-modified');
            data.cell.getElement().classList.add('cell-saved');
            
            setTimeout(() => {
                data.cell.getElement().classList.remove('cell-saved');
            }, 1500);
            
            // 추적에서 제거
            delete modifiedCells[key];
            updateModifiedCount();
            
            setStatus('저장 완료: ' + bfwidxList.find(b => b.id == data.bfwidx)?.name + ' / ' + 
                      qtycoList.find(q => q.id == data.qtyco_idx)?.name, 'success');
        } else {
            setStatus('저장 실패: ' + (result.error || '알 수 없는 오류'), 'error');
        }
    } catch (err) {
        setStatus('저장 오류: ' + err.message, 'error');
    }
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
        await autoSave(key);
        successCount++;
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
        
        // 테이블 데이터 업데이트
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
