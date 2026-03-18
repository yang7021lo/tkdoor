<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

Dim wms_idx, mode, Rs, SQL, cur_wms_type
wms_idx = Trim(Request("wms_idx"))
mode    = Trim(Request("mode"))
cur_wms_type = Trim(Request("wms_type"))

Set Rs = Server.CreateObject("ADODB.Recordset")


' ===============================
' 저장 처리
' ===============================
If mode = "save" Then

    Dim new_wms_type
    new_wms_type = Trim(Request.Form("wms_type"))

    If cur_wms_type <> "" And wms_idx <> "" Then
        SQL = ""
        SQL = SQL & "UPDATE tk_wms_meta SET "
        SQL = SQL & " wms_type = " & CLng(new_wms_type) & " "
        SQL = SQL & "WHERE wms_idx = " & wms_idx

        DbCon.Execute SQL
    End If
%>
<script>
        // 1. 대시보드 새로고침
    if (window.opener && window.opener.opener && !window.opener.opener.closed) {
        window.opener.opener.location.reload();
    }

    // 2. 버튼 3개 페이지 닫기
    if (window.opener && !window.opener.closed) {
        window.opener.close();
    }

    // 3. 현재 페이지 닫기
    window.close();
</script>
<%
    Response.End
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>출고 유형 변경</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background:#f4f6f9; font-size:14px; }
</style>
</head>

<body>
<div class="container p-3">

<h5 class="mb-3">출고 유형 변경</h5>

<form method="post">
<input type="hidden" name="mode" value="save">
<input type="hidden" name="wms_idx" value="<%=wms_idx%>">

<div class="mb-3">
<label class="form-label">출고 유형</label>
<select name="wms_type" class="form-select" required>

<option value="">선택하세요</option>

<option value="1"  <%If cur_wms_type=1  Then Response.Write "selected"%>>화물</option>
<option value="2"  <%If cur_wms_type=2  Then Response.Write "selected"%>>낮1배달_신두영(인천,고양)</option>
<option value="3"  <%If cur_wms_type=3  Then Response.Write "selected"%>>낮2배달_최민성(경기)</option>
<option value="4"  <%If cur_wms_type=4  Then Response.Write "selected"%>>밤1배달_윤성호(수원,천안,능력)</option>
<option value="5"  <%If cur_wms_type=5  Then Response.Write "selected"%>>밤2배달_김정호(하남)</option>
<option value="6"  <%If cur_wms_type=6  Then Response.Write "selected"%>>대구창고</option>
<option value="7"  <%If cur_wms_type=7  Then Response.Write "selected"%>>대전창고</option>
<option value="8"  <%If cur_wms_type=8  Then Response.Write "selected"%>>부산창고</option>
<option value="9"  <%If cur_wms_type=9  Then Response.Write "selected"%>>양산창고</option>
<option value="10" <%If cur_wms_type=10 Then Response.Write "selected"%>>익산창고</option>
<option value="11" <%If cur_wms_type=11 Then Response.Write "selected"%>>원주창고</option>
<option value="12" <%If cur_wms_type=12 Then Response.Write "selected"%>>제주창고</option>
<option value="13" <%If cur_wms_type=13 Then Response.Write "selected"%>>용차</option>
<option value="14" <%If cur_wms_type=14 Then Response.Write "selected"%>>방문</option>
<option value="15" <%If cur_wms_type=15 Then Response.Write "selected"%>>1공장</option>
<option value="16" <%If cur_wms_type=16 Then Response.Write "selected"%>>인천항</option>
<option value="17" <%If cur_wms_type=17 Then Response.Write "selected"%>>제주화물</option>
<option value="18" <%If cur_wms_type=18 Then Response.Write "selected"%>>제주택배</option>
<option value="19" <%If cur_wms_type=19 Then Response.Write "selected"%>>택배</option>

</select>
</div>

<div class="text-end">
<button type="submit" class="btn btn-primary">저장</button>
<button type="button" class="btn btn-secondary" onclick="window.close()">취소</button>
</div>

</form>
</div>
</body>
</html>
