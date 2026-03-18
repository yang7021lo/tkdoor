<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

Dim company_idx, sch_word
company_idx = Trim(Request("company_idx"))
sch_word    = Trim(Request("sch_word"))

If company_idx = "" Then
    Response.Write "<script>alert('company_idx가 없습니다.'); window.close();</script>"
    Response.End
End If

Dim Rs, SQL
Set Rs = Server.CreateObject("ADODB.Recordset")

SQL = ""
SQL = SQL & " SELECT midx, mname, memail, mtel, mpos "
SQL = SQL & " FROM tk_member "
SQL = SQL & " WHERE cidx = " & CLng(company_idx)

If sch_word <> "" Then
    SQL = SQL & " AND ( "
    SQL = SQL & "       mname LIKE '%" & Replace(sch_word,"'","''") & "%' "
    SQL = SQL & "    OR mid   LIKE '%" & Replace(sch_word,"'","''") & "%' "
    SQL = SQL & "    OR email LIKE '%" & Replace(sch_word,"'","''") & "%' "
    SQL = SQL & " ) "
End If

SQL = SQL & " ORDER BY mname ASC "

Rs.Open SQL, DbCon
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회사별 멤버 선택</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#f4f6f9; font-size:14px; }
.table thead th { background:#f1f3f5; }
.cursor-pointer { cursor:pointer; }
</style>

<script>
function selectMember(midx, mname) {
    if (window.opener && !window.opener.closed) {
        // 🔹 부모창에서 사용하는 필드명에 맞게 조정
        if (window.opener.document.getElementById('midx')) {
            window.opener.document.getElementById('midx').value = midx;
        }
        if (window.opener.document.getElementById('mname')) {
            window.opener.document.getElementById('mname').value = mname;
        }
    }
    window.close();
}
</script>
</head>

<body>
<div class="container-fluid p-4">

<h5 class="mb-3 fw-bold">회사 멤버 목록</h5>

<form method="get" class="row g-2 mb-3">
    <input type="hidden" name="company_idx" value="<%=company_idx%>">
    <div class="col-md-4">
        <input type="text" name="sch_word" value="<%=sch_word%>" class="form-control" placeholder="이름 / 아이디 / 이메일 검색">
    </div>
    <div class="col-md-2">
        <button class="btn btn-primary w-100">검색</button>
    </div>
</form>

<div class="table-responsive">
<table class="table table-bordered table-hover align-middle">
    <thead class="text-center">
        <tr>
            <th style="width:60px;">선택</th>
            <th>이름</th>
            <th>전화번호</th>
            <th>직급</th>
        </tr>
    </thead>
    <tbody>
    <%
    If Rs.EOF Then
    %>
        <tr>
            <td colspan="6" class="text-center text-muted">등록된 멤버가 없습니다.</td>
        </tr>
    <%
    Else
        Do Until Rs.EOF
    %>
        <tr>
            <td class="text-center">
                <button type="button"
                        class="btn btn-sm btn-success"
                        onclick="selectMember('<%=Rs("midx")%>','<%=Rs("mname")%>')">
                    선택
                </button>
            </td>
            <td><%=Rs("mname")%></td>
            <td><%=Rs("mtel")%></td>
            <td><%=Rs("mpos")%></td>
        </tr>
    <%
            Rs.MoveNext
        Loop
    End If
    %>
    </tbody>
</table>
</div>

<div class="text-end mt-3">
    <button class="btn btn-secondary" onclick="window.close()">닫기</button>
</div>

</div>
</body>
</html>

<%
Rs.Close
Set Rs = Nothing
Call dbClose()
%>
