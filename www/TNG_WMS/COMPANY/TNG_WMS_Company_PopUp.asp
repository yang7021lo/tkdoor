<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>

<!-- 공통 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

<%
Call dbOpen()

' =========================
' 파라미터
' =========================
Dim sch_name
sch_name = Trim(Request("sch_name"))

' =========================
' Recordset
' =========================
Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회사 선택</title>

<script>
function selectCompany(company_idx, company_name) {
    if (window.opener && !window.opener.closed) {
        if (window.opener.document.getElementById('company_idx')) {
            window.opener.document.getElementById('company_idx').value = company_idx;
        }
        if (window.opener.document.getElementById('company_name')) {
            window.opener.document.getElementById('company_name').value = company_name;
        }
    }
    window.close();
}
</script>
</head>

<body class="bg-light">

<div class="container-fluid p-4">

    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">🏢 회사 선택</h5>
        <button type="button"
                class="btn btn-outline-secondary btn-sm"
                onclick="window.close();">
            닫기
        </button>
    </div>

    <!-- 검색 -->
    <form method="get" class="row g-2 mb-3">
        <div class="col-8">
            <input type="text"
                   name="sch_name"
                   class="form-control"
                   placeholder="회사명 검색"
                   value="<%=sch_name%>">
        </div>
        <div class="col-4">
            <button class="btn btn-primary w-100">검색</button>
        </div>
    </form>

<%
' =========================
' SQL (회사 리스트)
' =========================
sql = ""
sql = sql & " SELECT company_idx, company_name "
sql = sql & " FROM tk_company "


If sch_name <> "" Then
    sql = sql & " AND company_name LIKE '%" & Replace(sch_name,"'","''") & "%' "
End If

sql = sql & " ORDER BY company_name "

Rs.Open sql, DbCon
%>

    <!-- 리스트 -->
    <table class="table table-bordered table-hover bg-white">
        <thead class="table-light">
            <tr>
                <th style="width:100px;">회사 IDX</th>
                <th>회사명</th>
                <th style="width:120px;">선택</th>
            </tr>
        </thead>
        <tbody>

<%
If Not (Rs.BOF Or Rs.EOF) Then
    Do Until Rs.EOF
%>
            <tr>
                <td class="text-center"><%=Rs("company_idx")%></td>
                <td><%=Rs("company_name")%></td>
                <td class="text-center">
                    <button type="button"
                            class="btn btn-sm btn-outline-primary"
                            onclick="selectCompany('<%=Rs("company_idx")%>','<%=Replace(Rs("company_name"),"'","\'")%>');">
                        선택
                    </button>
                </td>
            </tr>
<%
        Rs.MoveNext
    Loop
Else
%>
            <tr>
                <td colspan="3" class="text-center text-muted">
                    검색 결과가 없습니다.
                </td>
            </tr>
<%
End If
%>

        </tbody>
    </table>

</div>

</body>
</html>

<%
Rs.Close
Set Rs = Nothing
Call dbClose()
%>
