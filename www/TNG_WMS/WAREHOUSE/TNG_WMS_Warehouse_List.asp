<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link rel="icon" type="image/x-icon"
      href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

<%
call dbOpen()

' =========================
' 공용 Recordset (중요)
' =========================
Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

' =========================
' 페이징 변수 (paging.asp 계약)
' =========================
Dim gotopage, pagesize
gotopage = Request("gotopage")
If gotopage = "" Or Not IsNumeric(gotopage) Then gotopage = 1
gotopage = CInt(gotopage)

pagesize = 10

' =========================
' 검색 파라미터
' =========================
Dim sch_name
sch_name = Trim(Request("sch_name"))
%>

<!-- 상단 / 좌측 메뉴 (Rs 이미 존재) -->
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->
<title>창고 관리</title>
<div class="container-fluid mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">🏬 창고 관리</h5>
        <button class="btn btn-primary btn-sm"
                onclick="openWhPopup();">
            + 창고 등록
        </button>
    </div>

    <!-- 검색 -->
    <form method="get" class="row g-2 mb-3">
        <div class="col-md-3">
            <input type="text" name="sch_name" class="form-control"
                   placeholder="창고명"
                   value="<%=sch_name%>">
        </div>
        <div class="col-md-2">
            <button class="btn btn-primary w-100">검색</button>
        </div>
    </form>

<%
' =========================
' SQL
' =========================
sql = ""
sql = sql & " SELECT wh_idx, wh_name, wh_addr, wh_addr_detail "
sql = sql & " FROM tk_wms_warehouse "
sql = sql & " WHERE is_active = 1 "

If sch_name <> "" Then
    sql = sql & " AND wh_name LIKE '%" & Replace(sch_name,"'","''") & "%' "
End If

sql = sql & " ORDER BY wh_idx DESC "

' =========================
' Recordset 페이징 설정
' =========================
Rs.CursorLocation = 3   ' adUseClient
Rs.PageSize = pagesize
Rs.Open sql, DbCon, 1, 1

If Rs.PageCount > 0 Then
    If gotopage > Rs.PageCount Then gotopage = Rs.PageCount
    If gotopage < 1 Then gotopage = 1
    Rs.AbsolutePage = gotopage
End If
%>

    <table class="table table-bordered table-hover bg-white">
        <thead class="table-light">
            <tr>
                <th>창고명</th>
                <th>주소</th>
                <th>상세주소</th>
                <th style="width:120px;">관리</th>
            </tr>
        </thead>
        <tbody>

<%
If Not (Rs.BOF Or Rs.EOF) Then

    Dim i
    i = 0

    Do Until Rs.EOF Or i >= Rs.PageSize
%>
            <tr>
                <td><%=Rs("wh_name")%></td>
                <td><%=Rs("wh_addr")%></td>
                <td><%=Rs("wh_addr_detail")%></td>
                <td class="text-center">
                    <button class="btn btn-sm btn-outline-primary"
                            onclick="openWhPopup(<%=Rs("wh_idx")%>);">
                        수정
                    </button>
                    <button class="btn btn-sm btn-outline-danger"
                            onclick="openWhDelete(<%=Rs("wh_idx")%>);">
                        삭제
                    </button>
                </td>
            </tr>
<%
        Rs.MoveNext
        i = i + 1
    Loop

Else
%>
            <tr>
                <td colspan="4" class="text-center text-muted">
                    데이터가 없습니다.
                </td>
            </tr>
<%
End If
%>

        </tbody>
    </table>

    <!-- 페이징 -->
    <!--#include virtual="/inc/paging.asp"-->

</div>

<script>
function openWhPopup(wh_idx) {
    var url = 'TNG_WMS_Warehouse_Popup.asp';
    if (wh_idx) url += '?wh_idx=' + wh_idx;
    window.open(url, 'whPopup', 'width=700,height=650,scrollbars=yes');
}

function openWhDelete(wh_idx) {
    if (!confirm('삭제하시겠습니까?')) return;
    location.href = 'TNG_WMS_Warehouse_DB.asp?mode=delete&wh_idx=' + wh_idx;
}
</script>

</body>
</html>

<%
Rs.Close
Set Rs = Nothing
call dbClose()
%>
