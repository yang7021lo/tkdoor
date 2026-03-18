<%@ codepage="65001" Language="vbscript" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
%>

<!-- DB -->
<!--#include virtual="/inc/dbcon.asp"-->

<title>이벤트 로그 대시보드 (udate 기준)</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    font-size: 13px;
    margin: 20px;
}

.chart-row {
    display: flex;
    flex-wrap: wrap;
    gap: 30px;
    margin-bottom: 30px;
}

.chart-box {
    width: 360px;
}

.log-table {
    width: 100%;
    border-collapse: collapse;
}

.log-table th {
    background: #f3f4f6;
    padding: 8px;
    border-bottom: 1px solid #e5e7eb;
}

.log-table td {
    padding: 8px;
    border-bottom: 1px solid #e5e7eb;
}

.log-info  { border-left: 4px solid #3b82f6; }
.log-warn  { border-left: 4px solid #f59e0b; }
.log-error { border-left: 4px solid #ef4444; }

.badge {
    font-size: 11px;
    padding: 2px 6px;
    border-radius: 4px;
    font-weight: 600;
}

.badge-info  { background:#dbeafe; color:#1e40af; }
.badge-warn  { background:#fef3c7; color:#92400e; }
.badge-error { background:#fee2e2; color:#991b1b; }
</style>
</head>

<body>

<%
' =====================================================
' 날짜 조건 (udate 기준)
' =====================================================
Dim sdate, edate
sdate = Request("sdate")
edate = Request("edate")

If sdate = "" Then sdate = Date()
If edate = "" Then edate = Date()

' =====================================================
' 초기화
' =====================================================
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

Dim cntInfo, cntWarn, cntError
cntInfo = 0 : cntWarn = 0 : cntError = 0

Set dictBidx = Server.CreateObject("Scripting.Dictionary")  ' 품목 합계
Set dictMat  = Server.CreateObject("Scripting.Dictionary")  ' Material CNT
Set dictDate = Server.CreateObject("Scripting.Dictionary")  ' 날짜 CNT
%>

<h2>이벤트 로그 대시보드 (수정일 기준)</h2>

<form method="get" style="margin-bottom:20px;">
    시작일 <input type="date" name="sdate" value="<%=sdate%>">
    종료일 <input type="date" name="edate" value="<%=edate%>">
    <button type="submit">조회</button>
</form>

<div class="chart-row">
    <div class="chart-box"><canvas id="chartStatus"></canvas></div>
    <div class="chart-box"><canvas id="chartBidx"></canvas></div>
    <div class="chart-box"><canvas id="chartMaterial"></canvas></div>
    <div class="chart-box"><canvas id="chartDate"></canvas></div>
</div>

<table class="log-table">
<thead>
<tr>
    <th>#</th>
    <th>상태</th>
    <th>이벤트</th>
    <th>품목</th>
    <th>수량</th>
    <th>Material ID</th>
    <th>수정일</th>
</tr>
</thead>
<tbody>

<%
' =====================================================
' udate 기준 조회
' =====================================================
sql = ""
sql = sql & "SELECT use_log_id, event_log, bidx, use_amount, material_id, udate "
sql = sql & "FROM use_log "
sql = sql & "WHERE active = 1 "
sql = sql & "AND udate BETWEEN '" & sdate & "' AND '" & edate & "' "
sql = sql & "ORDER BY use_log_id DESC"

Rs.Open sql, dbCon, 1, 1

Do While Not Rs.EOF

    use_log_id = Rs("use_log_id")
    event_log  = Rs("event_log")
    bidx       = Rs("bidx")
    qty        = CLng(Rs("use_amount"))
    mat        = Rs("material_id")
    rdate      = Rs("udate")

    ' ===== 상태 판별 =====
    rowClass = "log-info"
    badge    = "INFO"
    cntInfo  = cntInfo + 1

    If InStr(event_log, "실패") > 0 Or InStr(UCase(event_log), "ERROR") > 0 Then
        rowClass = "log-error"
        badge    = "ERROR"
        cntInfo  = cntInfo - 1
        cntError = cntError + 1

    ElseIf InStr(event_log, "주의") > 0 Or InStr(UCase(event_log), "WARN") > 0 Then
        rowClass = "log-warn"
        badge    = "WARN"
        cntInfo  = cntInfo - 1
        cntWarn  = cntWarn + 1
    End If

    ' ===== 품목 합계 (SUM) =====
    If Not dictBidx.Exists(bidx) Then
        dictBidx.Add bidx, 0
    End If
    dictBidx(bidx) = dictBidx(bidx) + qty

    ' ===== Material CNT (행 기준) =====
    If Not dictMat.Exists(mat) Then
        dictMat.Add mat, 0
    End If
    dictMat(mat) = dictMat(mat) + 1

    ' ===== 날짜 CNT (행 기준) =====
    If Not dictDate.Exists(rdate) Then
        dictDate.Add rdate, 0
    End If
    dictDate(rdate) = dictDate(rdate) + 1
%>

<tr class="<%=rowClass%>">
    <td><%=use_log_id%></td>
    <td><span class="badge badge-<%=LCase(badge)%>"><%=badge%></span></td>
    <td><%=event_log%></td>
    <td><%=bidx%></td>
    <td><%=qty%></td>
    <td><%=mat%></td>
    <td><%=rdate%></td>
</tr>

<%
    Rs.MoveNext
Loop

Rs.Close
call dbClose()
%>
</tbody>
</table>

<%
' =====================================================
' Dictionary → JS 변환 (루프 완전히 종료 후)
' =====================================================
Function ToJS(dict)
    Dim k, lbl, dat
    lbl = "" : dat = ""
    For Each k In dict.Keys
        lbl = lbl & "'" & k & "',"
        dat = dat & dict(k) & ","
    Next
    If lbl <> "" Then
        lbl = Left(lbl, Len(lbl) - 1)
        dat = Left(dat, Len(dat) - 1)
    End If
    ToJS = Array(lbl, dat)
End Function

arrB = ToJS(dictBidx)
arrM = ToJS(dictMat)
arrD = ToJS(dictDate)
%>

<script>
// 상태별
new Chart(chartStatus,{
    type:'bar',
    data:{
        labels:['INFO','WARN','ERROR'],
        datasets:[{data:[<%=cntInfo%>,<%=cntWarn%>,<%=cntError%>]}]
    },
    options:{plugins:{title:{display:true,text:'상태별 로그'}}}
});

// 품목 도넛 (SUM)
new Chart(chartBidx,{
    type:'doughnut',
    data:{
        labels:[<%=arrB(0)%>],
        datasets:[{data:[<%=arrB(1)%>]}]
    },
    options:{plugins:{title:{display:true,text:'품목별 수량'}}}
});

// Material 도넛 (CNT)
new Chart(chartMaterial,{
    type:'doughnut',
    data:{
        labels:[<%=arrM(0)%>],
        datasets:[{data:[<%=arrM(1)%>]}]
    },
    options:{plugins:{title:{display:true,text:'Material ID 등장 횟수'}}}
});

// 날짜별 CNT
new Chart(chartDate,{
    type:'line',
    data:{
        labels:[<%=arrD(0)%>],
        datasets:[{data:[<%=arrD(1)%>],fill:false}]
    },
    options:{plugins:{title:{display:true,text:'수정일 기준 로그 발생 건수'}}}
});
</script>

</body>
</html>
