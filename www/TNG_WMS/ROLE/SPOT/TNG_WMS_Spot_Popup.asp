<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!-- DB / 공통 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

Dim Rs, SQL
Set Rs = Server.CreateObject("ADODB.Recordset")

' =========================
' 파라미터
' =========================
Dim spot_idx, mode
spot_idx = Trim(Request("spot_idx"))

mode = "insert"
If spot_idx <> "" And IsNumeric(spot_idx) Then mode = "update"

' =========================
' 기본값
' =========================
Dim spot_name, addr, addr_detail
Dim addr_lat, addr_long
Dim status, is_active

spot_name   = ""
addr        = ""
addr_detail = ""
addr_lat    = ""
addr_long   = ""
status      = 1
is_active   = 1

' =========================
' 수정모드 데이터 로드
' =========================
If mode = "update" Then
    SQL = ""
    SQL = SQL & " SELECT spot_name, addr, addr_detail, "
    SQL = SQL & "        addr_lat, addr_long, status, is_active "
    SQL = SQL & " FROM tk_wms_role_spot "
    SQL = SQL & " WHERE spot_idx = " & spot_idx

    Rs.Open SQL, DbCon, 1, 1
    If Not Rs.EOF Then
        spot_name   = Rs("spot_name")
        addr        = Rs("addr")
        addr_detail = Rs("addr_detail")
        addr_lat    = Rs("addr_lat")
        addr_long   = Rs("addr_long")
        status      = Rs("status")
        is_active   = Rs("is_active")
    End If
    Rs.Close
End If

' =========================
' 타이틀
' =========================
Dim pageTitle
If mode = "insert" Then
    pageTitle = "Spot 등록"
Else
    pageTitle = "Spot 수정"
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%=pageTitle%></title>

<link href="/css/styles.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#f4f6f9; font-size:14px; }
.card { border-radius:14px; }
</style>
</head>

<body>
<div class="container p-4">

<form method="post" action="TNG_WMS_Role_Spot_DB.asp">
<input type="hidden" name="mode" value="<%=mode%>">
<input type="hidden" name="spot_idx" value="<%=spot_idx%>">

<!-- 주소 / 좌표 (HIDDEN) -->
<input type="hidden" name="addr" value="<%=addr%>">
<input type="hidden" name="addr_detail" value="<%=addr_detail%>">
<input type="hidden" name="addr_lat" value="<%=addr_lat%>">
<input type="hidden" name="addr_long" value="<%=addr_long%>">

<div class="card shadow-sm">
<div class="card-body">

<h5 class="fw-bold mb-4"><%=pageTitle%></h5>

<!-- Spot 명 -->
<div class="mb-3">
    <label class="form-label fw-bold">Spot 명</label>
    <input type="text" name="spot_name" class="form-control"
           value="<%=spot_name%>" required>
</div>

<!-- 상태 -->
<div class="mb-3">
    <label class="form-label fw-bold">운영 상태</label>
    <select name="status" class="form-select">
        <option value="1" <% If status = 1 Then Response.Write "selected" %>>운영</option>
        <option value="0" <% If status = 0 Then Response.Write "selected" %>>대기</option>
    </select>
</div>

<!-- 활성 -->
<div class="mb-4">
    <label class="form-label fw-bold">활성 여부</label>
    <select name="is_active" class="form-select">
        <option value="1" <% If is_active = 1 Then Response.Write "selected" %>>사용</option>
        <option value="0" <% If is_active = 0 Then Response.Write "selected" %>>미사용</option>
    </select>
</div>

<!-- 버튼 -->
<div class="d-flex justify-content-end gap-2">
    <button type="submit" class="btn btn-primary">저장</button>
    <button type="button" class="btn btn-secondary" onclick="window.close();">
        닫기
    </button>
</div>

</div>
</div>

</form>

</div>
</body>
</html>

<%
Set Rs = Nothing
Call dbClose()
%>
