<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>

<!-- DB / 공통 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link href="/css/styles.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<%
Call dbOpen()

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

Dim role_core_idx, bfwidx, no
Dim page_title, mode

role_core_idx = Trim(Request("role_core_idx"))
bfwidx = ""
no = ""

If role_core_idx = "" Then
    page_title = "규칙 집합 등록"
    mode = "insert"
Else
    page_title = "규칙 집합 수정"
    mode = "update"

    sql = ""
    sql = sql & " SELECT role_core_idx, bfwidx, no "
    sql = sql & " FROM tk_wms_role_core "
    sql = sql & " WHERE role_core_idx = " & role_core_idx

    Rs.Open sql, DbCon, 1, 1
    If Not (Rs.BOF Or Rs.EOF) Then
        bfwidx = Rs("bfwidx")
        no = Rs("no")
    End If
    Rs.Close
End If
%>
<!--#include virtual="/TNG_WMS/Cache/Cache_whichitype.asp"-->
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%=page_title%></title>
</head>

<body class="p-4">

<h5 class="mb-4 fw-bold"><%=page_title%></h5>

<form method="post" action="TNG_WMS_Role_Core_DB.asp">

<input type="hidden" name="mode" value="<%=mode%>">
<input type="hidden" name="is_popup" value="1">
<input type="hidden" name="role_core_idx" value="<%=role_core_idx%>">

<!-- 바라시 유형 -->
<div class="mb-3">
    <label class="form-label fw-semibold">바라시 유형</label>
    <select name="bfwidx" class="form-select" required>
        <option value="">선택하세요</option>
<%


For Each k In dictWhichi.Keys

    opt_value = k
    opt_name  = "[" & dictWhichi(k)(0) & "] " & dictWhichi(k)(1)

    selected_txt = ""
    If CStr(opt_value) = CStr(bfwidx) Then
        selected_txt = "selected"
    End If
%>
        <option value="<%=opt_value%>" <%=selected_txt%>>
            <%=opt_name%>
        </option>
<%
Next
%>
    </select>
</div>



<!-- 정렬 순서 -->
<div class="mb-4">
    <label class="form-label fw-semibold">정렬 순서</label>
    <input type="number"
           name="no"
           class="form-control"
           value="<%=no%>"
           required>
</div>

<div class="d-flex justify-content-end gap-2">
    <button type="submit" class="btn btn-primary">저장</button>
    <button type="button"
            class="btn btn-secondary"
            onclick="window.close();">
        취소
    </button>
</div>

</form>

</body>
</html>

<%
Set Rs = Nothing
Call dbClose()
%>
