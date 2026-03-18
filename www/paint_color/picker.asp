<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
If c_midx = "" Then
    Response.Write "<script>alert('login 먼저해주세요');window.close();</script>"
    Response.End
End If

Dim pk_sjidx, pk_pidx
pk_sjidx = Trim(Request("sjidx") & "")
pk_pidx = Trim(Request("pidx") & "")
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>페인트 선택</title>
    <link rel="stylesheet" href="/paint_color/picker.css">
</head>
<body>

<!-- 헤더 -->
<div class="pk-header">
    <h1>PAINT PICKER</h1>
    <button type="button" onclick="window.open('/paint_color/index.asp');"
        style="margin-left:auto;margin-right:8px;padding:4px 12px;background:#ff6b35;color:#fff;border:none;border-radius:4px;cursor:pointer;font-size:13px;">색상등록</button>
    <button type="button" onclick="window.open('/paint_sample/index.asp?sjidx=<%=pk_sjidx%>&pidx=<%=pk_pidx%>');"
        style="margin-right:8px;padding:4px 12px;background:#059669;color:#fff;border:none;border-radius:4px;cursor:pointer;font-size:13px;">샘플지급</button>
    <button class="pk-close" id="pkClose" title="닫기">&times;</button>
</div>

<div class="pk-body">
    <!-- 검색 바 -->
    <div class="pk-search-bar">
        <!-- 검색 입력 -->
        <div class="pk-search-row">
            <input type="text" class="pk-search-input" id="pkSearch" placeholder="페인트명, 코드, 브랜드 검색 (초성도 가능: ㄱㅎ)" autofocus>
            <span class="pk-badge-chosung" id="pkBadgeChosung">초성검색</span>
        </div>

        <!-- 색상 그룹 -->
        <div class="pk-color-groups">
            <label>색상:</label>
            <div class="pk-cg-btn" data-group="nocolor" title="미지정"></div>
            <div class="pk-cg-btn" data-group="black" title="블랙"></div>
            <div class="pk-cg-btn" data-group="darkgray" title="다크그레이"></div>
            <div class="pk-cg-btn" data-group="silver" title="실버"></div>
            <div class="pk-cg-btn" data-group="lightgray" title="라이트그레이"></div>
            <div class="pk-cg-btn" data-group="ivory" title="아이보리"></div>
            <div class="pk-cg-btn" data-group="brown" title="브라운"></div>
            <div class="pk-cg-btn" data-group="red" title="레드"></div>
            <div class="pk-cg-btn" data-group="orange" title="오렌지"></div>
            <div class="pk-cg-btn" data-group="yellow" title="옐로우"></div>
            <div class="pk-cg-btn" data-group="green" title="그린"></div>
            <div class="pk-cg-btn" data-group="blue" title="블루"></div>
            <div class="pk-cg-btn" data-group="navy" title="네이비"></div>
            <div class="pk-cg-btn" data-group="purple" title="퍼플"></div>
        </div>

        <!-- 필터 -->
        <div class="pk-filter-row">
            <label>브랜드:</label>
            <select id="pkBrand"><option value="0">전체</option></select>
            <label style="margin-left:8px">코트:</label>
            <select id="pkCoat">
                <option value="-1">전체</option>
                <option value="0">❌</option>
                <option value="1">기본(2코트)</option>
                <option value="2">필수(3코트)</option>
            </select>
            <div style="margin-left:auto"></div>
            <!-- 비슷한색 -->
            <label>비슷한색:</label>
            <input type="color" class="pk-color-picker" id="pkColorPicker" value="#000000">
            <input type="text" class="pk-hex-input" id="pkHexInput" value="#000000" maxlength="7" placeholder="#FF5500">
            <button class="pk-btn-similar" id="pkBtnSimilar">비슷한색 검색</button>
            <button class="pk-btn-reset" id="pkBtnReset">초기화</button>
        </div>
    </div>

    <!-- 결과 -->
    <div class="pk-result-area">
        <div class="pk-result-info" id="pkResultInfo"></div>
        <div id="pkResultList">
            <div class="pk-loading">로딩중...</div>
        </div>
    </div>

    <!-- 페이지네이션 -->
    <div class="pk-pager" id="pkPager"></div>
</div>

<script src="/paint_color/picker.js"></script>
</body>
</html>
