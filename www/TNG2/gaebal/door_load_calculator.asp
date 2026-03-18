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
Set Rs = Server.CreateObject("ADODB.Recordset")

projectname="도어 하중 계산기"
listgubun="one"
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title><%=projectname%></title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/split.js/1.6.5/split.min.js"></script>
    <style>
        .calc-container * { margin: 0; padding: 0; box-sizing: border-box; }
        .calc-container {
            font-family: 'Malgun Gothic', sans-serif;
            background: #1a1a2e;
            color: #eee;
            min-height: calc(100vh - 60px);
        }

        .split { display: flex; height: calc(100vh - 70px); }
        .gutter {
            background-color: #0f3460;
            background-repeat: no-repeat;
            background-position: 50%;
        }
        .gutter.gutter-horizontal {
            cursor: col-resize;
            background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAeCAYAAADkftS9AAAAIklEQVQoU2M4c+bMfwY8QFJSkhFOYRwjjCGBwF3kPAAOkxcDASJCcwAAAABJRU5ErkJggg==');
        }
        .gutter:hover { background-color: #00d4ff; }
        
        .panel-left, .panel-right {
            height: calc(100vh - 70px);
            overflow-y: auto;
            padding: 20px;
        }
        .panel-left { background: #16213e; }
        .panel-right { background: #1a1a2e; }
        
        h1 { color: #00d4ff; margin-bottom: 20px; font-size: 1.3em; text-align: center; }
        h2 { color: #00d4ff; margin-bottom: 15px; font-size: 1.1em; }
        
        .section {
            background: #0f3460;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .section-title {
            font-size: 0.95em;
            color: #ffd93d;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid #1a4a7a;
        }
        
        .input-row {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .input-row label {
            width: 100px;
            font-size: 0.85em;
            color: #aaa;
        }
        .input-row input[type="number"],
        .input-row select {
            flex: 1;
            background: #16213e;
            border: 1px solid #1a4a7a;
            color: #fff;
            padding: 8px 10px;
            border-radius: 5px;
            font-size: 0.95em;
            text-align: right;
        }
        .input-row select { text-align: left; }
        .input-row input:focus, .input-row select:focus {
            outline: none;
            border-color: #00d4ff;
        }
        .input-row .unit {
            margin-left: 8px;
            color: #888;
            width: 35px;
            font-size: 0.85em;
        }
        
        .door-preview {
            display: flex;
            justify-content: center;
            padding: 10px 0;
        }
        .door-svg { max-width: 100%; height: auto; }
        
        .result-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin-bottom: 10px;
        }
        .result-grid.three-col {
            grid-template-columns: 1fr 1fr 1fr;
        }
        .result-item {
            background: #16213e;
            padding: 10px;
            border-radius: 6px;
        }
        .result-item .label {
            font-size: 0.7em;
            color: #888;
        }
        .result-item .value {
            font-size: 1em;
            color: #fff;
            margin-top: 3px;
        }
        .result-item.highlight {
            border: 1px solid #f472b6;
            background: rgba(244, 114, 182, 0.1);
        }
        .result-item.highlight .value {
            color: #f472b6;
        }
        .result-item.safe {
            border: 1px solid #4ade80;
            background: rgba(74, 222, 128, 0.1);
        }
        .result-item.safe .value {
            color: #4ade80;
        }
        .result-item.danger {
            border: 1px solid #f87171;
            background: rgba(248, 113, 113, 0.1);
        }
        .result-item.danger .value {
            color: #f87171;
        }
        
        .load-card {
            background: #16213e;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 10px;
        }
        .load-card.load-a { border-left: 4px solid #4ade80; }
        .load-card.load-b { border-left: 4px solid #60a5fa; }
        .load-card.load-c { border-left: 4px solid #f472b6; }
        
        .load-label { font-size: 0.8em; color: #aaa; }
        .load-value {
            font-size: 1.3em;
            font-weight: bold;
            color: #fff;
            margin: 5px 0;
        }
        .load-desc { font-size: 0.7em; color: #666; }
        
        .status-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.7em;
            margin-left: 8px;
        }
        .status-safe { background: #166534; color: #4ade80; }
        .status-warn { background: #854d0e; color: #fbbf24; }
        .status-danger { background: #991b1b; color: #f87171; }
        
        .safety-summary {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }
        .safety-card {
            text-align: center;
            padding: 12px 8px;
            border-radius: 8px;
        }
        .safety-card.safe { background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; }
        .safety-card.warn { background: rgba(251, 191, 36, 0.15); border: 1px solid #fbbf24; }
        .safety-card.danger { background: rgba(248, 113, 113, 0.15); border: 1px solid #f87171; }
        .safety-card .icon { font-size: 1.6em; }
        .safety-card .title { font-size: 0.75em; color: #aaa; margin: 5px 0; }
        .safety-card .ratio { font-size: 1.1em; font-weight: bold; }
        
        .chart-section {
            background: #16213e;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .chart-title {
            font-size: 0.85em;
            color: #00d4ff;
            margin-bottom: 10px;
            text-align: center;
        }
        .chart-wrapper { height: 200px; position: relative; }
        
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 15px;
        }
        
        .base-info {
            background: rgba(0, 212, 255, 0.1);
            border: 1px solid #0f3460;
            padding: 10px;
            border-radius: 6px;
            font-size: 0.8em;
            color: #00d4ff;
            margin-bottom: 15px;
        }
        
        .formula-box {
            background: #0a0a1a;
            border: 1px dashed #333;
            padding: 10px;
            border-radius: 6px;
            font-size: 0.75em;
            color: #888;
            margin-top: 10px;
            font-family: monospace;
            line-height: 1.6;
        }
        .formula-box .em { color: #f472b6; }
        .formula-box .safe { color: #4ade80; }
        .formula-box .warn { color: #fbbf24; }
        
        .warning-banner {
            background: rgba(248, 113, 113, 0.2);
            border: 2px solid #f87171;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 15px;
            text-align: center;
            display: none;
        }
        .warning-banner.show { display: block; }
        .warning-banner .icon { font-size: 1.5em; }
        .warning-banner .text { color: #f87171; font-weight: bold; margin-top: 5px; }
        .warning-banner .detail { color: #fca5a5; font-size: 0.85em; margin-top: 5px; }
    </style>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left1.asp"-->

<div id="layoutSidenav_content">
<main>
<div class="container-fluid px-0 py-0">
<div class="calc-container">
    <div class="split">
        <!-- 좌측 패널: 입력 -->
        <div id="left" class="panel-left">
            <h1>🚪 도어 수직하중 계산기</h1>
            
            <!-- 1차: 도어 외경 -->
            <div class="section">
                <div class="section-title">📐 1차: 도어 외경</div>
                <div class="input-row">
                    <label>가로 (W)</label>
                    <input type="number" id="doorWidth" value="900" min="500" max="3000" step="10">
                    <span class="unit">mm</span>
                </div>
                <div class="input-row">
                    <label>세로 (H)</label>
                    <input type="number" id="doorHeight" value="2100" min="1000" max="4000" step="10">
                    <span class="unit">mm</span>
                </div>
            </div>
            
            <!-- 2차: 힌지 센터 -->
            <div class="section">
                <div class="section-title">🔩 2차: 플로어 힌지</div>
                <div class="input-row">
                    <label>힌지 센터</label>
                    <input type="number" id="hingeCenter" value="40" min="0" max="200" step="5">
                    <span class="unit">mm</span>
                </div>
                <div style="font-size: 0.7em; color: #666; margin-top: 5px;">
                    ※ 도어 좌측 끝 → 힌지 중심 거리
                </div>
            </div>
            
            <!-- 3차: 프레임 바 규격 -->
            <div class="section">
                <div class="section-title">📏 3차: 프레임 바</div>
                <div class="input-row">
                    <label>세로바 (좌우)</label>
                    <input type="number" id="barVertical" value="50" min="20" max="200" step="5">
                    <span class="unit">mm</span>
                </div>
                <div class="input-row">
                    <label>가로바 (상하)</label>
                    <input type="number" id="barHorizontal" value="90" min="20" max="200" step="5">
                    <span class="unit">mm</span>
                </div>
            </div>
            
            <!-- 4차: 유리 두께 -->
            <div class="section">
                <div class="section-title">🪟 4차: 유리</div>
                <div class="input-row">
                    <label>유리 두께</label>
                    <select id="glassThickness">
                        <option value="8">8T (8mm)</option>
                        <option value="10">10T (10mm)</option>
                        <option value="12" selected>12T (12mm)</option>
                        <option value="15">15T (15mm)</option>
                    </select>
                </div>
            </div>
            
            <!-- 절단 치수 -->
            <div class="section">
                <div class="section-title">✂️ 절단 치수</div>
                <div class="result-grid">
                    <div class="result-item">
                        <div class="label">세로바 × 2</div>
                        <div class="value" id="cutVertical">2100mm</div>
                    </div>
                    <div class="result-item">
                        <div class="label">가로바 × 2</div>
                        <div class="value" id="cutHorizontal">860mm</div>
                    </div>
                    <div class="result-item">
                        <div class="label">유리 가로</div>
                        <div class="value" id="cutGlassW">820mm</div>
                    </div>
                    <div class="result-item">
                        <div class="label">유리 세로</div>
                        <div class="value" id="cutGlassH">1940mm</div>
                    </div>
                </div>
            </div>
            
            <!-- 도어 미리보기 -->
            <div class="section">
                <div class="section-title">🖼️ 구조도 (닫힌 상태)</div>
                <div class="door-preview">
                    <svg id="doorPreview" class="door-svg" viewBox="0 0 220 450"></svg>
                </div>
            </div>
        </div>
        
        <!-- 우측 패널: 결과 -->
        <div id="right" class="panel-right">
            <h2>📊 계산 결과</h2>
            
            <div class="base-info">
                📌 <strong>기준:</strong> 1000×2200, 세로바50, 가로바90, 유리12T, 힌지40mm = 100%
            </div>
            
            <!-- 경고 배너 -->
            <div id="warningBanner" class="warning-banner">
                <div class="icon">⚠️</div>
                <div class="text" id="warningText">브릿지 구간 발생!</div>
                <div class="detail" id="warningDetail">힌지가 유리 밖에 위치 → 피스 결합부 하중 집중</div>
            </div>
            
            <!-- 안전도 요약 -->
            <div class="safety-summary">
                <div id="safetySummaryA" class="safety-card safe">
                    <div class="icon">🟢</div>
                    <div class="title">총 자중</div>
                    <div class="ratio" id="ratioA">100%</div>
                </div>
                <div id="safetySummaryB" class="safety-card safe">
                    <div class="icon">🟢</div>
                    <div class="title">모멘트</div>
                    <div class="ratio" id="ratioB">100%</div>
                </div>
                <div id="safetySummaryC" class="safety-card safe">
                    <div class="icon">🟢</div>
                    <div class="title">⚡ 처짐지수</div>
                    <div class="ratio" id="ratioC">100%</div>
                </div>
            </div>
            
            <!-- 핵심 수치 -->
            <div class="section">
                <div class="section-title">🎯 핵심 수치</div>
                <div class="result-grid three-col">
                    <div class="result-item">
                        <div class="label">유리 무게</div>
                        <div class="value" id="infoGlassWeight">48.9 kg</div>
                    </div>
                    <div class="result-item">
                        <div class="label">유리 좌측끝</div>
                        <div class="value" id="infoGlassLeft">40 mm</div>
                    </div>
                    <div class="result-item" id="bridgeItem">
                        <div class="label">브릿지 구간 ⚡</div>
                        <div class="value" id="infoBridge">0 mm</div>
                    </div>
                    <div class="result-item">
                        <div class="label">유리 중심</div>
                        <div class="value" id="infoGlassCenter">450 mm</div>
                    </div>
                    <div class="result-item highlight">
                        <div class="label">모멘트 암</div>
                        <div class="value" id="infoMomentArm">410 mm</div>
                    </div>
                    <div class="result-item">
                        <div class="label">위험 계수</div>
                        <div class="value" id="infoDangerFactor">1.00</div>
                    </div>
                </div>
                <div class="formula-box">
                    <span class="safe">유리좌측끝</span> = 세로바 - 10 (매립)<br>
                    <span class="warn">브릿지</span> = max(0, 유리좌측끝 - 힌지) → <span class="warn">양수면 위험!</span><br>
                    <span class="em">모멘트암</span> = 유리중심 - 힌지 = 도어가로/2 - 힌지<br>
                    <span class="em">처짐지수</span> = 유리무게 × 모멘트암 × 위험계수 / I
                </div>
            </div>
            
            <!-- 3대 하중 -->
            <div class="section">
                <div class="section-title">⚡ 3대 하중 지표</div>
                <div class="load-card load-a">
                    <div class="load-label">⚖️ 하중 A (총 자중)</div>
                    <div class="load-value">
                        <span id="loadA">61.2</span> kg
                        <span id="statusA" class="status-badge status-safe">안전</span>
                    </div>
                    <div class="load-desc">힌지 허용 하중 기준</div>
                </div>
                <div class="load-card load-b">
                    <div class="load-label">🔄 하중 B (모멘트)</div>
                    <div class="load-value">
                        <span id="loadB">246</span> N·m
                        <span id="statusB" class="status-badge status-safe">안전</span>
                    </div>
                    <div class="load-desc">= 유리무게 × 9.8 × 모멘트암</div>
                </div>
                <div class="load-card load-c">
                    <div class="load-label">📉 하중 C (처짐 지수) ⭐</div>
                    <div class="load-value">
                        <span id="loadC">1.85e4</span>
                        <span id="statusC" class="status-badge status-safe">안전</span>
                    </div>
                    <div class="load-desc">= 모멘트 × 위험계수 / I (클수록 위험, 프레임 변형)</div>
                </div>
            </div>
            
            <!-- 그래프 -->
            <div class="charts-grid">
                <div class="chart-section">
                    <div class="chart-title">📈 도어 가로 vs 처짐지수</div>
                    <div class="chart-wrapper">
                        <canvas id="chartWidth"></canvas>
                    </div>
                </div>
                <div class="chart-section">
                    <div class="chart-title">📈 세로바 크기 vs 브릿지/처짐</div>
                    <div class="chart-wrapper">
                        <canvas id="chartBarV"></canvas>
                    </div>
                </div>
                <div class="chart-section">
                    <div class="chart-title">📈 도어 크기별 종합 비교</div>
                    <div class="chart-wrapper">
                        <canvas id="chartSize"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // ========================================
        // Split.js 초기화
        // ========================================
        Split(['#left', '#right'], {
            sizes: [28, 72],
            minSize: [260, 400],
            gutterSize: 8,
            cursor: 'col-resize'
        });

        // ========================================
        // 상수
        // ========================================
        const GLASS_DENSITY = 2500;
        const ALUMINUM_DENSITY = 2700;
        const GRAVITY = 9.8;
        const GLASS_EMBED = 10;
        const BAR_OVERLAP = 20;
        const DOOR_DEPTH = 40;

        let BASE_LOAD_A, BASE_LOAD_B, BASE_LOAD_C;
        let chartWidth, chartBarV, chartSize;

        // ========================================
        // 계산 함수
        // ========================================
        
        function calculate(doorW, doorH, hingeCenter, barV, barH, glassT) {
            const cutVertical = doorH;
            const cutHorizontal = doorW - BAR_OVERLAP * 2;
            
            const glassW = doorW - (barV * 2) + (GLASS_EMBED * 2);
            const glassH = doorH - (barH * 2) + (GLASS_EMBED * 2);
            
            const glassLeft = barV - GLASS_EMBED;
            const glassCenter = doorW / 2;
            
            const bridge = Math.max(0, glassLeft - hingeCenter);
            const momentArm = glassCenter - hingeCenter;
            
            const glassWeight = (glassW / 1000) * (glassH / 1000) * (glassT / 1000) * GLASS_DENSITY;
            
            const wallThick = 2;
            const areaOuter = (barV / 1000) * (barH / 1000);
            const areaInner = ((barV - wallThick*2) / 1000) * ((barH - wallThick*2) / 1000);
            const barArea = Math.max(0, areaOuter - areaInner);
            const lengthV = cutVertical * 2 / 1000;
            const lengthH = cutHorizontal * 2 / 1000;
            const frameWeight = (lengthV + lengthH) * barArea * ALUMINUM_DENSITY;
            
            const totalWeight = glassWeight + frameWeight;
            const loadA = totalWeight;
            const loadB = glassWeight * GRAVITY * (momentArm / 1000);
            
            const dangerFactor = 1 + (bridge / 10) * 0.1;
            
            const depth = DOOR_DEPTH / 1000;
            const height = barH / 1000;
            const I = (depth * Math.pow(height, 3)) / 12;
            
            const loadC = (loadB * dangerFactor) / I;
            
            return {
                cutVertical, cutHorizontal, glassW, glassH,
                glassLeft, glassCenter, bridge, momentArm,
                glassWeight, frameWeight, totalWeight,
                loadA, loadB, loadC, dangerFactor, I
            };
        }

        function calculateBase() {
            const r = calculate(1000, 2200, 40, 50, 90, 12);
            BASE_LOAD_A = r.loadA;
            BASE_LOAD_B = r.loadB;
            BASE_LOAD_C = r.loadC;
        }

        function getStatus(ratio) {
            if (ratio <= 100) return { status: 'safe', text: '안전', icon: '🟢' };
            if (ratio <= 150) return { status: 'warn', text: '주의', icon: '🟡' };
            return { status: 'danger', text: '위험', icon: '🔴' };
        }

        function fmt(n, d) {
            d = d === undefined ? 1 : d;
            return n.toLocaleString('ko-KR', { minimumFractionDigits: d, maximumFractionDigits: d });
        }

        // ========================================
        // UI 업데이트
        // ========================================
        
        function updateUI() {
            var doorW = parseInt(document.getElementById('doorWidth').value) || 900;
            var doorH = parseInt(document.getElementById('doorHeight').value) || 2100;
            var hingeCenter = parseInt(document.getElementById('hingeCenter').value) || 40;
            var barV = parseInt(document.getElementById('barVertical').value) || 50;
            var barH = parseInt(document.getElementById('barHorizontal').value) || 90;
            var glassT = parseInt(document.getElementById('glassThickness').value) || 12;

            var r = calculate(doorW, doorH, hingeCenter, barV, barH, glassT);

            document.getElementById('cutVertical').textContent = r.cutVertical + 'mm';
            document.getElementById('cutHorizontal').textContent = r.cutHorizontal + 'mm';
            document.getElementById('cutGlassW').textContent = r.glassW + 'mm';
            document.getElementById('cutGlassH').textContent = r.glassH + 'mm';

            document.getElementById('infoGlassWeight').textContent = fmt(r.glassWeight) + ' kg';
            document.getElementById('infoGlassLeft').textContent = r.glassLeft + ' mm';
            document.getElementById('infoBridge').textContent = r.bridge + ' mm';
            document.getElementById('infoGlassCenter').textContent = r.glassCenter + ' mm';
            document.getElementById('infoMomentArm').textContent = r.momentArm + ' mm';
            document.getElementById('infoDangerFactor').textContent = r.dangerFactor.toFixed(2);

            var bridgeItem = document.getElementById('bridgeItem');
            bridgeItem.className = r.bridge > 0 ? 'result-item danger' : 'result-item safe';

            var warningBanner = document.getElementById('warningBanner');
            if (r.bridge > 0) {
                warningBanner.classList.add('show');
                document.getElementById('warningText').textContent = '브릿지 ' + r.bridge + 'mm 발생!';
                document.getElementById('warningDetail').textContent = 
                    '힌지(' + hingeCenter + 'mm)가 유리좌측끝(' + r.glassLeft + 'mm)보다 안쪽 → 피스 결합부에 하중 집중';
            } else {
                warningBanner.classList.remove('show');
            }

            document.getElementById('loadA').textContent = fmt(r.loadA);
            document.getElementById('loadB').textContent = fmt(r.loadB, 0);
            document.getElementById('loadC').textContent = r.loadC.toFixed(0);

            var ratioA = (r.loadA / BASE_LOAD_A) * 100;
            var ratioB = (r.loadB / BASE_LOAD_B) * 100;
            var ratioC = (r.loadC / BASE_LOAD_C) * 100;

            var statusA = getStatus(ratioA);
            var statusB = getStatus(ratioB);
            var statusC = getStatus(ratioC);

            document.getElementById('statusA').textContent = statusA.text;
            document.getElementById('statusA').className = 'status-badge status-' + statusA.status;
            document.getElementById('statusB').textContent = statusB.text;
            document.getElementById('statusB').className = 'status-badge status-' + statusB.status;
            document.getElementById('statusC').textContent = statusC.text;
            document.getElementById('statusC').className = 'status-badge status-' + statusC.status;

            updateSafetyCard('safetySummaryA', 'ratioA', statusA, ratioA);
            updateSafetyCard('safetySummaryB', 'ratioB', statusB, ratioB);
            updateSafetyCard('safetySummaryC', 'ratioC', statusC, ratioC);

            updateDoorPreview(doorW, doorH, barV, barH, hingeCenter, r);
            updateCharts(doorW, doorH, hingeCenter, barV, barH, glassT);
        }

        function updateSafetyCard(cardId, ratioId, status, ratio) {
            var card = document.getElementById(cardId);
            card.className = 'safety-card ' + status.status;
            card.querySelector('.icon').textContent = status.icon;
            document.getElementById(ratioId).textContent = fmt(ratio, 0) + '%';
        }

        function updateDoorPreview(doorW, doorH, barV, barH, hingeCenter, r) {
            var svg = document.getElementById('doorPreview');
            
            var svgW = 220, svgH = 450, pad = 25;
            var ratio = doorW / doorH;
            var rW, rH;
            
            if (ratio > (svgW - pad*2) / (svgH - pad*2 - 80)) {
                rW = svgW - pad * 2;
                rH = rW / ratio;
            } else {
                rH = svgH - pad * 2 - 80;
                rW = rH * ratio;
            }
            
            var x = (svgW - rW) / 2;
            var y = pad;
            
            var barVR = barV / doorW;
            var barHR = barH / doorH;
            var hingeR = hingeCenter / doorW;
            var glassLeftR = r.glassLeft / doorW;
            var centerR = 0.5;
            
            var fV = rW * barVR;
            var fH = rH * barHR;
            var hX = x + rW * hingeR;
            var gL = x + rW * glassLeftR;
            var cX = x + rW * centerR;
            
            var ratioC = (r.loadC / BASE_LOAD_C);
            var skewAngle = Math.min(5, ratioC * 0.5);
            
            var bridgeMarkup = '';
            if (r.bridge > 0) {
                bridgeMarkup = '<line x1="' + hX + '" y1="' + (y+rH+45) + '" x2="' + gL + '" y2="' + (y+rH+45) + '" stroke="#f87171" stroke-width="4"/>' +
                    '<text x="' + ((hX+gL)/2) + '" y="' + (y+rH+58) + '" fill="#f87171" font-size="10" text-anchor="middle" font-weight="bold">브릿지 ' + r.bridge + 'mm</text>';
            } else {
                bridgeMarkup = '<text x="' + ((hX+gL)/2) + '" y="' + (y+rH+45) + '" fill="#4ade80" font-size="9" text-anchor="middle">힌지가 유리 안 ✓</text>';
            }
            
            svg.innerHTML = 
                '<defs>' +
                    '<marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">' +
                        '<polygon points="0 0, 10 3.5, 0 7" fill="#f472b6"/>' +
                    '</marker>' +
                '</defs>' +
                
                '<line x1="' + x + '" y1="' + (y-10) + '" x2="' + (x+rW) + '" y2="' + (y-10) + '" stroke="#888" stroke-width="1"/>' +
                '<text x="' + (x+rW/2) + '" y="' + (y-15) + '" fill="#00d4ff" font-size="11" text-anchor="middle">' + doorW + '</text>' +
                
                '<line x1="' + (x+rW+10) + '" y1="' + y + '" x2="' + (x+rW+10) + '" y2="' + (y+rH) + '" stroke="#888" stroke-width="1"/>' +
                '<text x="' + (x+rW+25) + '" y="' + (y+rH/2) + '" fill="#00d4ff" font-size="11" text-anchor="middle" transform="rotate(90,' + (x+rW+25) + ',' + (y+rH/2) + ')">' + doorH + '</text>' +
                
                '<g transform="skewX(' + skewAngle + ')">' +
                    '<rect x="' + x + '" y="' + y + '" width="' + rW + '" height="' + rH + '" fill="#1e3a5f" stroke="#60a5fa" stroke-width="2"/>' +
                    '<rect x="' + x + '" y="' + y + '" width="' + fV + '" height="' + rH + '" fill="#2563eb" stroke="#3b82f6" stroke-width="1"/>' +
                    '<rect x="' + (x+rW-fV) + '" y="' + y + '" width="' + fV + '" height="' + rH + '" fill="#2563eb" stroke="#3b82f6" stroke-width="1"/>' +
                    '<rect x="' + (x+fV*0.4) + '" y="' + y + '" width="' + (rW-fV*0.8) + '" height="' + fH + '" fill="#1d4ed8" stroke="#2563eb" stroke-width="1"/>' +
                    '<rect x="' + (x+fV*0.4) + '" y="' + (y+rH-fH) + '" width="' + (rW-fV*0.8) + '" height="' + fH + '" fill="#1d4ed8" stroke="#2563eb" stroke-width="1"/>' +
                    '<rect x="' + gL + '" y="' + (y+fH-4) + '" width="' + (rW-gL*2+x*2-fV) + '" height="' + (rH-fH*2+8) + '" fill="#0ea5e9" fill-opacity="0.3" stroke="#38bdf8" stroke-width="1"/>' +
                '</g>' +
                
                '<circle cx="' + hX + '" cy="' + (y+rH+25) + '" r="14" fill="#1a1a2e" stroke="#fbbf24" stroke-width="2"/>' +
                '<circle cx="' + hX + '" cy="' + (y+rH+25) + '" r="5" fill="#fbbf24"/>' +
                '<line x1="' + hX + '" y1="' + (y+rH) + '" x2="' + hX + '" y2="' + (y+rH+40) + '" stroke="#fbbf24" stroke-width="1" stroke-dasharray="3,2"/>' +
                
                '<line x1="' + gL + '" y1="' + (y+rH+5) + '" x2="' + gL + '" y2="' + (y+rH+20) + '" stroke="#38bdf8" stroke-width="2"/>' +
                '<text x="' + gL + '" y="' + (y+rH+30) + '" fill="#38bdf8" font-size="8" text-anchor="middle">유리끝</text>' +
                
                bridgeMarkup +
                
                '<line x1="' + x + '" y1="' + (y+rH+70) + '" x2="' + hX + '" y2="' + (y+rH+70) + '" stroke="#fbbf24" stroke-width="1"/>' +
                '<text x="' + ((x+hX)/2) + '" y="' + (y+rH+82) + '" fill="#fbbf24" font-size="10" text-anchor="middle">' + hingeCenter + 'mm</text>' +
                
                '<line x1="' + hX + '" y1="' + (y+rH/2) + '" x2="' + cX + '" y2="' + (y+rH/2) + '" stroke="#f472b6" stroke-width="2" marker-end="url(#arrowhead)"/>' +
                '<text x="' + ((hX+cX)/2) + '" y="' + (y+rH/2-8) + '" fill="#f472b6" font-size="10" text-anchor="middle">' + r.momentArm + 'mm</text>' +
                
                '<circle cx="' + cX + '" cy="' + (y+rH/2) + '" r="4" fill="#38bdf8"/>' +
                '<text x="' + cX + '" y="' + (y+rH/2+15) + '" fill="#38bdf8" font-size="8" text-anchor="middle">중심</text>' +
                
                '<path d="M' + (x+rW-15) + ' ' + (y+rH-30) + ' Q' + (x+rW) + ' ' + (y+rH-15) + ' ' + (x+rW+10) + ' ' + (y+rH+5) + '" stroke="#f472b6" stroke-width="2" fill="none" stroke-dasharray="4,2"/>' +
                '<text x="' + (x+rW+5) + '" y="' + (y+rH+20) + '" fill="#f472b6" font-size="9" transform="rotate(45,' + (x+rW+5) + ',' + (y+rH+20) + ')">처짐↘</text>' +
                
                '<text x="' + (x+fV/2) + '" y="' + (y+rH/2) + '" fill="#60a5fa" font-size="8" text-anchor="middle" transform="rotate(-90,' + (x+fV/2) + ',' + (y+rH/2) + ')">' + barV + '</text>' +
                '<text x="' + (x+rW/2) + '" y="' + (y+fH/2+3) + '" fill="#93c5fd" font-size="8" text-anchor="middle">' + barH + '</text>';
        }

        // ========================================
        // 그래프
        // ========================================
        
        function updateCharts(doorW, doorH, hingeCenter, barV, barH, glassT) {
            var widths = [800, 900, 1000, 1100, 1200, 1300, 1400, 1500];
            var loadCsByWidth = widths.map(function(w) {
                var r = calculate(w, doorH, hingeCenter, barV, barH, glassT);
                return (r.loadC / BASE_LOAD_C) * 100;
            });
            updateWidthChart(widths, loadCsByWidth, doorW);
            
            var barVs = [30, 40, 50, 60, 80, 100];
            var dataBarV = barVs.map(function(bv) {
                var r = calculate(doorW, doorH, hingeCenter, bv, barH, glassT);
                return {
                    bridge: r.bridge,
                    loadC: (r.loadC / BASE_LOAD_C) * 100
                };
            });
            updateBarVChart(barVs, dataBarV, barV);
            
            var sizes = [
                { w: 900, h: 2100, label: '900×2100' },
                { w: 1000, h: 2200, label: '1000×2200' },
                { w: 1100, h: 2400, label: '1100×2400' },
                { w: 1200, h: 2700, label: '1200×2700' },
                { w: 1500, h: 3000, label: '1500×3000' }
            ];
            var sizeData = sizes.map(function(s) {
                var r = calculate(s.w, s.h, hingeCenter, barV, barH, glassT);
                return {
                    loadA: (r.loadA / BASE_LOAD_A) * 100,
                    loadB: (r.loadB / BASE_LOAD_B) * 100,
                    loadC: (r.loadC / BASE_LOAD_C) * 100
                };
            });
            updateSizeChart(sizes.map(function(s) { return s.label; }), sizeData);
        }

        function updateWidthChart(labels, data, currentValue) {
            var ctx = document.getElementById('chartWidth').getContext('2d');
            var colors = labels.map(function(l) {
                return l === currentValue ? 'rgba(244,114,182,0.9)' : 'rgba(244,114,182,0.4)';
            });
            
            if (chartWidth) {
                chartWidth.data.labels = labels.map(function(l) { return l + ''; });
                chartWidth.data.datasets[0].data = data;
                chartWidth.data.datasets[0].backgroundColor = colors;
                chartWidth.update();
            } else {
                chartWidth = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels.map(function(l) { return l + ''; }),
                        datasets: [{
                            label: '처짐지수 %',
                            data: data,
                            backgroundColor: colors,
                            borderColor: 'rgba(244,114,182,1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.1)' }, ticks: { color: '#888', callback: function(v) { return v + '%'; } } },
                            x: { grid: { display: false }, ticks: { color: '#888', font: { size: 9 } }, title: { display: true, text: '도어 가로 (mm)', color: '#666' } }
                        }
                    }
                });
            }
        }

        function updateBarVChart(labels, data, currentValue) {
            var ctx = document.getElementById('chartBarV').getContext('2d');
            var colors = labels.map(function(l) {
                return l === currentValue ? 'rgba(244,114,182,0.9)' : 'rgba(244,114,182,0.4)';
            });
            
            if (chartBarV) {
                chartBarV.data.labels = labels.map(function(l) { return l + 'mm'; });
                chartBarV.data.datasets[0].data = data.map(function(d) { return d.loadC; });
                chartBarV.data.datasets[1].data = data.map(function(d) { return d.bridge; });
                chartBarV.data.datasets[0].backgroundColor = colors;
                chartBarV.update();
            } else {
                chartBarV = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels.map(function(l) { return l + 'mm'; }),
                        datasets: [
                            {
                                label: '처짐지수 %',
                                data: data.map(function(d) { return d.loadC; }),
                                backgroundColor: colors,
                                borderColor: 'rgba(244,114,182,1)',
                                borderWidth: 1,
                                yAxisID: 'y'
                            },
                            {
                                label: '브릿지 mm',
                                data: data.map(function(d) { return d.bridge; }),
                                type: 'line',
                                borderColor: '#f87171',
                                backgroundColor: 'rgba(248,113,113,0.3)',
                                borderWidth: 2,
                                pointRadius: 4,
                                yAxisID: 'y1'
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { labels: { color: '#888', boxWidth: 12 } } },
                        scales: {
                            y: { 
                                beginAtZero: true, 
                                position: 'left',
                                grid: { color: 'rgba(255,255,255,0.1)' }, 
                                ticks: { color: '#f472b6', callback: function(v) { return v + '%'; } },
                                title: { display: true, text: '처짐지수', color: '#f472b6' }
                            },
                            y1: { 
                                beginAtZero: true, 
                                position: 'right',
                                grid: { display: false }, 
                                ticks: { color: '#f87171' },
                                title: { display: true, text: '브릿지(mm)', color: '#f87171' }
                            },
                            x: { grid: { display: false }, ticks: { color: '#888' }, title: { display: true, text: '세로바 크기', color: '#666' } }
                        }
                    }
                });
            }
        }

        function updateSizeChart(labels, data) {
            var ctx = document.getElementById('chartSize').getContext('2d');
            
            if (chartSize) {
                chartSize.data.labels = labels;
                chartSize.data.datasets[0].data = data.map(function(d) { return d.loadA; });
                chartSize.data.datasets[1].data = data.map(function(d) { return d.loadB; });
                chartSize.data.datasets[2].data = data.map(function(d) { return d.loadC; });
                chartSize.update();
            } else {
                chartSize = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [
                            { label: '총자중', data: data.map(function(d) { return d.loadA; }), borderColor: '#4ade80', tension: 0.3, pointRadius: 4 },
                            { label: '모멘트', data: data.map(function(d) { return d.loadB; }), borderColor: '#60a5fa', tension: 0.3, pointRadius: 4 },
                            { label: '처짐', data: data.map(function(d) { return d.loadC; }), borderColor: '#f472b6', tension: 0.3, pointRadius: 4, borderWidth: 3 }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { labels: { color: '#888', boxWidth: 12 } } },
                        scales: {
                            y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.1)' }, ticks: { color: '#888', callback: function(v) { return v + '%'; } } },
                            x: { grid: { display: false }, ticks: { color: '#888', font: { size: 9 } } }
                        }
                    }
                });
            }
        }

        // ========================================
        // 이벤트
        // ========================================
        document.addEventListener('DOMContentLoaded', function() {
            calculateBase();
            updateUI();
            
            ['doorWidth', 'doorHeight', 'hingeCenter', 'barVertical', 'barHorizontal', 'glassThickness'].forEach(function(id) {
                document.getElementById(id).addEventListener('input', updateUI);
                document.getElementById(id).addEventListener('change', updateUI);
            });
        });
    </script>
</div>
</div>
</main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="/js/scripts.js"></script>
</body>
</html>
<%
Set Rs = Nothing
call dbClose()
%>
