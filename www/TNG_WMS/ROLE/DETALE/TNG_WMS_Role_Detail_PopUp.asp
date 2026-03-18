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

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

' =========================
' 파라미터
' =========================
Dim role_detail_idx, role_core_idx
Dim step, is_finish, is_active
Dim mode, page_title

role_detail_idx = Trim(Request("role_detail_idx"))
role_core_idx   = Trim(Request("role_core_idx"))

step = ""
is_finish = "0"
is_active = "1"

If role_core_idx = "" Or Not IsNumeric(role_core_idx) Then
    Response.Write "<script>alert('잘못된 접근입니다.'); window.close();</script>"
    Response.End
End If

' =========================
' 수정 모드
' =========================
If role_detail_idx <> "" Then
    mode = "update"
    page_title = "순서 수정"

    sql = ""
    sql = sql & " SELECT step, is_finish, is_active "
    sql = sql & " FROM tk_wms_role_detail "
    sql = sql & " WHERE role_detail_idx = " & role_detail_idx

    Rs.Open sql, DbCon, 1, 1
    If Not (Rs.BOF Or Rs.EOF) Then
        step      = Rs("step")
        is_finish = Rs("is_finish")
        is_active = Rs("is_active")
    End If
    Rs.Close
Else
    mode = "insert"
    page_title = "순서 추가"
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%=page_title%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="p-4">

<h5 class="fw-bold mb-4"><%=page_title%></h5>

<form method="post" action="TNG_WMS_Role_Detail_DB.asp">

<input type="hidden" name="mode" value="<%=mode%>">
<input type="hidden" name="role_detail_idx" value="<%=role_detail_idx%>">
<input type="hidden" name="role_core_idx" value="<%=role_core_idx%>">
<input type="hidden" name="is_popup" value="1">

<!-- 순서 -->
<div class="mb-3">
    <label class="form-label fw-semibold">순서(step)</label>
    <input type="number"
           name="step"
           class="form-control"
           value="<%=step%>"
           required>
</div>

<!-- 완료 단계 -->
<div class="mb-3">
    <label class="form-label fw-semibold">단계 구분</label>
    <select name="is_finish" class="form-select">
        <option value="0" <% If is_finish="0" Then Response.Write("selected") End If %>>진행 단계</option>
        <option value="1" <% If is_finish="1" Then Response.Write("selected") End If %>>완료 단계</option>
    </select>
</div>


<div class="d-flex justify-content-end gap-2">
    <button type="submit" class="btn btn-primary">저장</button>
    <button type="button" class="btn btn-secondary" onclick="window.close();">
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
