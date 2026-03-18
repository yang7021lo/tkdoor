<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>절곡 마스터 그리드</title>

    <!-- Tabulator CSS -->
    <link href="https://unpkg.com/tabulator-tables@5.5.2/dist/css/tabulator.min.css" rel="stylesheet">
    <!-- Bootstrap CSS (버튼 스타일용) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Malgun Gothic', sans-serif;
            padding: 20px;
            background-color: #f5f5f5;
        }

        .header {
            background: linear-gradient(135deg, #555f8aff 0%, #2e0808ff 100%);
            color: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .header h1 { font-size: 24pt; margin-bottom: 10px; }

        .toolbar {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .toolbar input[type="text"] {
            padding: 8px 15px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14pt;
            min-width: 250px;
        }
        .toolbar button {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14pt;
            font-weight: bold;
            transition: all 0.3s;
        }
        .btn-primary { background-color: #667eea; color: white; }
        .btn-success { background-color: #48bb78; color: white; }
        .btn-info { background-color: #4299e1; color: white; }
        .btn-danger { background-color: #f56565; color: white; }
        .btn-print { background-color: #805ad5; color: white; }

        .stats { display: flex; gap: 15px; margin-left: auto; }
        .stat-box { padding: 8px 15px; border-radius: 5px; font-weight: bold; font-size: 14pt; }
        .stat-total { background-color: #e6f2ff; color: #1e40af; }
        .stat-missing { background-color: #fee; color: #dc2626; }

        #julgok-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .tabulator { font-size: 14pt; border: none; }
        .tabulator-header { background-color: #f8fafc; border-bottom: 2px solid #e2e8f0; }
        .tabulator-row:hover { background-color: #e0e7ff !important; }
        .tabulator-row.tabulator-selected { background-color: #dbeafe !important; }
        .tabulator-cell { padding: 6px 4px; vertical-align: middle; }

        .julgok-wrapper { display: flex; flex-direction: column; gap: 5px; min-width: 400px; }
        .julgok-row1 { display: flex; gap: 3px; align-items: center; flex-wrap: wrap; }
        .julgok-row1 .btn-sm { font-size: 12pt; padding: 2px 6px; }

        .julgok-row1 .btn-svg-view {
            cursor: pointer; font-size: 12pt; padding: 2px 8px; margin-left: 4px;
            background: #f3f4f6; border: 1px solid #d1d5db; border-radius: 3px; color: #374151;
        }
        .julgok-row1 .btn-svg-view:hover { background: #e5e7eb; }

        .status-ok { background-color: #d1fae5; color: #047857; padding: 3px 8px; border-radius: 3px; font-size: 14pt; }
        .status-missing { background-color: #fee2e2; color: #dc2626; padding: 3px 8px; border-radius: 3px; font-size: 14pt; }

        .image-preview { width: 40px; height: 40px; object-fit: cover; border-radius: 4px; border: 2px solid #e5e7eb; }
        .loading { text-align: center; padding: 20px; font-size: 14pt; color: #666; }

        /* SVG 팝업 */
        .svg-popup-overlay {
            display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.4); z-index: 9999; justify-content: center; align-items: center;
        }
        .svg-popup-overlay.active { display: flex; }
        .svg-popup-box {
            background: white; border-radius: 10px; padding: 20px;
            min-width: 500px; max-width: 80vw; box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .svg-popup-box .popup-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .svg-popup-box .popup-header h3 { margin: 0; font-size: 14pt; }
        .svg-popup-box .popup-close { cursor: pointer; font-size: 18pt; border: none; background: none; color: #6b7280; }
        .svg-popup-box .popup-svg-area {
            width: 100%; min-height: 150px; border: 1px solid #e5e7eb;
            background-color: #fafafa; border-radius: 6px;
        }
        .svg-popup-box .popup-svg-area svg { width: 100%; height: 100%; }

        /* 인쇄 스타일 - A3 가로, 4건/페이지 (2x2) */
        @page { size: A3 landscape; margin: 5mm; }
        @media print {
            body { padding: 0; background: white; margin: 0; }
            .header, .toolbar, .svg-popup-overlay, #julgok-table, #loading { display: none !important; }
            #print-area { display: block !important; }
            .print-page {
                display: grid;
                grid-template-columns: 1fr 1fr;
                grid-template-rows: 1fr 1fr;
                gap: 5mm;
                width: 100%;
                height: 277mm; /* A3 가로 높이 - 마진 */
                page-break-after: always;
            }
            .print-page:last-child { page-break-after: auto; }
            .print-item {
                border: 1px solid #999;
                padding: 8px;
                overflow: hidden;
                display: flex;
                flex-direction: column;
            }
            .print-item .print-top {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 3px;
            }
            .print-item .print-title { font-size: 11pt; font-weight: bold; }
            .print-item .print-ch-sh {
                display: flex;
                flex-direction: column;
                gap: 4px;
                align-items: flex-end;
            }
            .print-item .print-ch-sh .ch,
            .print-item .print-ch-sh .sh {
                font-size: 14pt;
                font-weight: bold;
                border: 2px solid #333;
                padding: 3px 8px;
                min-width: 180px;
                display: flex;
            }
            .print-item .print-ch-sh .ch .label,
            .print-item .print-ch-sh .sh .label {
                min-width: 50px;
                text-align: left;
            }
            .print-item .print-ch-sh .ch .value,
            .print-item .print-ch-sh .sh .value {
                flex: 1;
                border-left: 1px solid #333;
                padding-left: 8px;
                min-width: 100px;
            }
            .print-item .print-ch-sh .ch { color: #1d4ed8; }
            .print-item .print-ch-sh .sh { color: #b91c1c; }
            .print-item .print-buttons { margin-bottom: 4px; }
            .print-item .print-buttons .btn { font-size: 14pt; padding: 2px 8px; font-weight: bold; }
            .print-item .print-body {
                display: flex;
                gap: 8px;
                align-items: center;
                flex: 1;
            }
            .print-item .print-left {
                width: 50%;
                height: 100%;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .print-item .print-left img {
                max-width: 100%;
                max-height: 100%;
                object-fit: contain;
                border: 1px solid #ccc;
            }
            .print-item .print-right {
                width: 50%;
                height: 100%;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .print-item .print-right svg {
                border: 1px solid #ddd;
                background: #fafafa;
                width: 100%;
                height: 100%;
            }
        }
        #print-area { display: none; }
    </style>
</head>
<body>
    <div class="header">
        <h1>절곡 마스터 그리드 - 채널/샤링 일괄 관리</h1>
        <p>채널/샤링값 누락 확인</p>
    </div>

    <div class="toolbar">
        <input type="text" id="search-input" placeholder="검색: 절곡명, 순번 등...">
        <button class="btn-primary" onclick="filterMissingChannel()">채널 누락</button>
        <button class="btn-primary" onclick="filterMissingShearing()">샤링 누락</button>
        <button class="btn-info" onclick="clearFilters()">전체 보기</button>
        <div class="stats">
            <div class="stat-box stat-total">전체: <span id="stat-total">0</span></div>
            <div class="stat-box stat-missing">누락: <span id="stat-missing">0</span></div>
        </div>
    </div>

    <div class="toolbar">
        <button class="btn-info" onclick="exportToExcel()">엑셀 다운로드</button>
        <button class="btn-print" onclick="printSelected()">선택 인쇄</button>
        <button class="btn-print" onclick="printSvgAll()" style="background:#6b21a8;">필터 전체 인쇄</button>
        <button class="btn-info" onclick="selectAll()" style="background:#3b82f6;">전체 선택</button>
        <button class="btn-info" onclick="deselectAll()" style="background:#94a3b8;">선택 해제</button>
        <span id="sel-count" style="font-size:9pt; color:#4338ca; font-weight:bold;">선택: 0건</span>
    </div>

    <div id="loading" class="loading">데이터 로딩 중...</div>
    <div id="julgok-table" style="display: none;"></div>
    <div id="print-area"></div>

    <!-- SVG 팝업 -->
    <div class="svg-popup-overlay" id="svg-popup">
        <div class="svg-popup-box">
            <div class="popup-header">
                <h3 id="svg-popup-title">절곡도면</h3>
                <button class="popup-close" onclick="closeSvgPopup()">&times;</button>
            </div>
            <div class="popup-svg-area" id="svg-popup-content"></div>
        </div>
    </div>

    <!-- Tabulator JS -->
    <script src="https://unpkg.com/tabulator-tables@5.5.2/dist/js/tabulator.min.js"></script>

    <script>
        var table;
        var allData = [];

        window.onload = function() {
            fetch('TNG1_JULGOK_GET_LIST.asp')
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    allData = data;
                    initTable(data);
                })
                .catch(function(error) {
                    document.getElementById('loading').innerHTML = '데이터 로드 실패: ' + error;
                });
        };

        // SVG HTML 생성 함수 (공용)
        function buildSvgHtml(subs, height) {
            if (!subs || subs.length === 0) return '';
            var svg = '<svg width="100%" height="' + (height || 200) + '" fill="none" stroke="#000000" stroke-width="1">';
            subs.forEach(function(s) {
                svg += '<line x1="' + s.x1 + '" y1="' + s.y1 + '" x2="' + s.x2 + '" y2="' + s.y2 + '" />';
                svg += '<text x="' + s.tx + '" y="' + s.ty + '" fill="#000000" font-size="10" ';
                svg += 'font-family="Roboto Thin, sans-serif" font-weight="100" opacity="0.8" text-anchor="middle">';
                svg += s.t + '</text>';
            });
            svg += '</svg>';
            return svg;
        }

        // 버튼 HTML 생성 함수 (공용)
        function buildButtonsHtml(subs) {
            if (!subs || subs.length === 0) return '';
            var html = '';
            subs.forEach(function(s) {
                html += '<button type="button" class="btn btn-' + s.bc + ' btn-sm">' + s.ac + '</button>';
            });
            return html;
        }

        function initTable(data) {
            document.getElementById('loading').style.display = 'none';
            document.getElementById('julgok-table').style.display = 'block';

            table = new Tabulator("#julgok-table", {
                data: data,
                layout: "fitDataStretch",
                height: "calc(100vh - 280px)",
                pagination: false,
                movableColumns: true,
                resizableColumns: true,

                selectable: true,

                columns: [
                    {
                        formatter: "rowSelection", titleFormatter: "rowSelection",
                        width: 40, frozen: true, hozAlign: "center",
                        headerSort: false, cellClick: function(e, cell) { updateSelCount(); }
                    },
                    {
                        title: "No", width: 50, frozen: true, hozAlign: "center",
                        formatter: "rownum"
                    },
                    {
                        title: "순번", field: "baidx", minWidth: 80, frozen: true,
                        headerFilter: "list",
                        headerFilterParams: { valuesLookup: true, sort: "asc" },
                        headerFilterPlaceholder: "전체"
                    },
                    {
                        title: "bfidx", field: "bfidx", minWidth: 80,
                        headerFilter: "list",
                        headerFilterParams: { valuesLookup: true, sort: "asc" },
                        headerFilterPlaceholder: "전체"
                    },
                    {
                        title: "절곡명", field: "baname", minWidth: 150, editor: "input",
                        cellEdited: function(cell) { saveCellToDb(cell); },
                        headerFilter: "list",
                        headerFilterParams: { valuesLookup: true, sort: "asc" },
                        headerFilterPlaceholder: "전체"
                    },
                    { title: "품명", field: "pummok", minWidth: 180 },
                    {
                        title: "규격", field: "gyugyuk", minWidth: 120,
                        formatter: function(cell) {
                            var v = cell.getValue();
                            return '<span style="color:#2563eb; text-decoration:underline; cursor:pointer;">' + (v || '') + '</span>';
                        },
                        cellClick: function(e, cell) {
                            var d = cell.getRow().getData();
                            if (d.sjb_idx && d.bfidx) {
                                window.open('/TNG1/TNG1_JULGOK_PUMMOK_LIST1.asp?sjb_idx=' + d.sjb_idx + '&bfidx=' + d.bfidx, 'pummok', 'width=1400,height=900,scrollbars=yes,resizable=yes');
                            } else {
                                alert('sjb_idx 또는 bfidx 정보가 없습니다.');
                            }
                        }
                    },
                    {
                        title: "이미지", field: "image", minWidth: 70,
                        formatter: function(cell) {
                            var v = cell.getValue();
                            if (v && v != "") return '<img src="/img/frame/bfimg/' + v + '" class="image-preview">';
                            return '';
                        }
                    },
                    {
                        title: "절곡도면", field: "subs", minWidth: 500,
                        formatter: function(cell) {
                            var subs = cell.getValue();
                            var baidx = cell.getRow().getData().baidx;
                            if (!subs || subs.length === 0) return '<span style="color:#aaa;">없음</span>';

                            var html = '<div class="julgok-row1">';
                            html += buildButtonsHtml(subs);
                            html += '<span class="btn-svg-view" onclick="openSvgPopup(' + baidx + ')">도면</span>';
                            html += '</div>';
                            return html;
                        }
                    },
                    {
                        title: "채널", field: "bachannel", minWidth: 100, editor: "input",
                        formatter: function(cell) {
                            var v = cell.getValue();
                            if (!v || v == "" || v == "0") return '<span style="color: red;">미배치</span>';
                            return v;
                        },
                        cellEdited: function(cell) { saveCellToDb(cell); }
                    },
                    {
                        title: "샤링값", field: "sharing_size", minWidth: 100, editor: "input",
                        formatter: function(cell) {
                            var v = cell.getValue();
                            if (!v || v == 0 || v == "") return '<span style="color: orange;">미입력</span>';
                            return v;
                        },
                        cellEdited: function(cell) { saveCellToDb(cell); }
                    },
                    {
                        title: "삭제", width: 50, minWidth: 50, maxWidth: 50, hozAlign: "center", resizable: false, headerSort: false, vertAlign: "middle", widthGrow: 0, widthShrink: 0,
                        formatter: function() {
                            return '<button type="button" class="btn btn-danger btn-sm" style="padding:1px 4px;font-size:11px;">삭제</button>';
                        },
                        cellClick: function(e, cell) {
                            var row = cell.getRow();
                            var d = row.getData();
                            deleteRow(row, d.baidx, d.baname);
                        }
                    }
                ]
            });

            table.on("tableBuilt", function() { updateStats(); });
            table.on("rowSelectionChanged", function() { updateSelCount(); });
        }

        // 선택 카운트
        function updateSelCount() {
            var cnt = table.getSelectedRows().length;
            document.getElementById('sel-count').textContent = '선택: ' + cnt + '건';
        }

        // 전체 선택 / 해제
        function selectAll() {
            table.getRows("active").forEach(function(row) { row.select(); });
            updateSelCount();
        }
        function deselectAll() {
            table.deselectRow();
            updateSelCount();
        }

        // 선택된 행만 인쇄
        function printSelected() {
            var selected = table.getSelectedData();
            if (selected.length === 0) { alert('인쇄할 항목을 선택하세요.'); return; }
            doPrint(selected);
        }

        // SVG 팝업
        function openSvgPopup(baidx) {
            var row = allData.find(function(r) { return r.baidx == baidx; });
            if (!row || !row.subs) return;

            document.getElementById('svg-popup-title').textContent = '절곡도면 - [' + baidx + '] ' + (row.baname || '');
            document.getElementById('svg-popup-content').innerHTML = buildSvgHtml(row.subs, 200);
            document.getElementById('svg-popup').classList.add('active');
        }

        function closeSvgPopup() {
            document.getElementById('svg-popup').classList.remove('active');
            document.getElementById('svg-popup-content').innerHTML = '';
        }

        document.getElementById('svg-popup').addEventListener('click', function(e) {
            if (e.target === this) closeSvgPopup();
        });

        // 필터된 전체 인쇄
        function printSvgAll() {
            var filtered = table ? table.getData("active") : allData;
            doPrint(filtered);
        }

        // 공통 인쇄 함수
        function doPrint(dataArr) {
            var printArea = document.getElementById('print-area');
            var items = [];
            dataArr.forEach(function(row) {
                if (row.subs && row.subs.length > 0) items.push(row);
            });
            if (items.length === 0) { alert('인쇄할 도면이 없습니다.'); return; }

            var html = '';
            for (var i = 0; i < items.length; i++) {
                if (i % 4 === 0) html += '<div class="print-page">';

                var row = items[i];
                html += '<div class="print-item">';
                var chVal = (row.bachannel && row.bachannel != '' && row.bachannel != '0') ? row.bachannel : '-';
                var shVal = (row.sharing_size && row.sharing_size != 0) ? row.sharing_size : '-';
                html += '<div class="print-top">';
                html += '<div class="print-title">[' + row.baidx + '] ' + (row.baname || '') + ' | ' + (row.pummok || '') + ' | ' + (row.gyugyuk || '') + '</div>';
                html += '<div class="print-ch-sh"><div class="ch"><span class="label">CH:</span><span class="value">' + chVal + '</span></div><div class="sh"><span class="label">샤링:</span><span class="value">' + shVal + '</span></div></div>';
                html += '</div>';
                html += '<div class="print-buttons">' + buildButtonsHtml(row.subs) + '</div>';
                html += '<div class="print-body">';
                html += '<div class="print-left">';
                if (row.image && row.image != '') {
                    html += '<img src="/img/frame/bfimg/' + row.image + '">';
                }
                html += '</div>';
                html += '<div class="print-right">' + buildSvgHtml(row.subs, 300) + '</div>';
                html += '</div></div>';

                if (i % 4 === 3 || i === items.length - 1) html += '</div>';
            }

            printArea.innerHTML = html;
            printArea.style.display = 'block';
            window.print();
            printArea.style.display = 'none';
        }

        // 검색
        document.getElementById("search-input").addEventListener("keyup", function() {
            table.setFilter([
                [{field: "baname", type: "like", value: this.value}],
                [{field: "baidx", type: "like", value: this.value}]
            ], "or");
        });

        function filterMissingChannel() {
            table.setFilter(function(data) { return !data.bachannel || data.bachannel == "" || data.bachannel == "0"; });
        }
        function filterMissingShearing() {
            table.setFilter(function(data) { return !data.sharing_size || data.sharing_size == 0 || data.sharing_size == ""; });
        }
        function clearFilters() { table.clearFilter(); }

        function updateStats() {
            var data = table.getData();
            var total = data.length;
            var missing = data.filter(function(row) {
                return (!row.bachannel || row.bachannel == "" || row.bachannel == "0") || (!row.sharing_size || row.sharing_size == 0 || row.sharing_size == "");
            }).length;
            document.getElementById("stat-total").textContent = total;
            document.getElementById("stat-missing").textContent = missing;
        }

        // 셀 편집 → 엔터 → 즉시 DB 저장
        function saveCellToDb(cell) {
            var d = cell.getRow().getData();
            fetch('TNG1_JULGOK_UPDATE_SINGLE.asp?baidx=' + d.baidx +
                  '&bachannel=' + encodeURIComponent(d.bachannel || '') +
                  '&baname=' + encodeURIComponent(d.baname || '') +
                  '&sharing_size=' + encodeURIComponent(d.sharing_size || 0))
                .then(function(r) { return r.json(); })
                .then(function(result) {
                    if (result.success) {
                        cell.getElement().style.backgroundColor = '#d1fae5';
                        setTimeout(function() { cell.getElement().style.backgroundColor = ''; }, 1000);
                    } else {
                        alert('저장 실패');
                    }
                })
                .catch(function() { alert('저장 오류'); });
        }

        function deleteRow(row, baidx, baname) {
            if (!confirm("[" + baidx + "] " + (baname || "") + "\n이 절곡 데이터를 삭제하시겠습니까?")) return;
            fetch('TNG1_JULGOK_DELETE.asp?baidx=' + baidx)
                .then(function(r) { return r.json(); })
                .then(function(result) {
                    if (result.success) { row.delete(); updateStats(); }
                    else alert("삭제 실패: " + (result.error || ""));
                })
                .catch(function(error) { alert("삭제 오류: " + error); });
        }

        function exportToExcel() {
            table.download("xlsx", "절곡마스터_" + new Date().toISOString().slice(0,10) + ".xlsx");
        }
    </script>
</body>
</html>
