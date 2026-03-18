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
<link rel="stylesheet" href="/TNG_WMS/BOM_WMS/TNG_WMS_Bom.css">
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
Dim sch_no
sch_no = Trim(Request("sch_no"))
%>

<!-- 상단 / 좌측 메뉴 -->
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->

<div class="container-fluid mt-4">
<title>기계설비</title>
    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">🧾 기계설비 </h5>
        <button class="btn btn-primary btn-sm"
                onclick="openBomWmsPopup();">
            + 기계 등록
        </button>
    </div>

    <!-- 검색 -->
    <form method="get" class="row g-2 mb-3">
        <div class="col-md-3">
            <input type="text" name="sch_no" class="form-control"
                   placeholder="기계 번호"
                   value="<%=sch_no%>">
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
sql = sql & " SELECT "
sql = sql & "   A.bw_idx, A.bw_no, A.bw_price, "
sql = sql & "   A.stock_idx, A.material_id, A.wdate, "
sql = sql & "   B.material_name "
sql = sql & " FROM tk_bom_wms A "
sql = sql & " LEFT JOIN bom2_material B "
sql = sql & "   ON A.material_id = B.material_id "
sql = sql & " WHERE A.is_active = 1 "

If sch_no <> "" Then
    sql = sql & " AND A.bw_no LIKE '%" & Replace(sch_no,"'","''") & "%' "
End If

sql = sql & " ORDER BY A.bw_idx DESC "

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

    <!-- 리스트 -->
    <table class="table table-bordered table-hover bg-white">
        <thead class="table-light">
            <tr>
                <th style="width:120px;">기계번호</th>
                <th>기계명</th>
                <th style="width:100px;">재고번호</th>
                <th style="width:130px;">기계금액</th>
                <th style="width:120px;">등록일</th>
                <th style="width:120px;">관리</th>
            </tr>
        </thead>
        <tbody>

<%
If Not (Rs.BOF Or Rs.EOF) Then

    Dim i
    i = 0

    Do Until Rs.EOF Or i >= Rs.PageSize

        bw_idx   = Rs("bw_idx")
        bw_no    = Rs("bw_no")
        stock_idx = Rs("stock_idx")
        material_name = Rs("material_name")
        bw_price = Rs("bw_price")
        wdate    = Rs("wdate")
%>
            <tr>
                <td><%=bw_no%></td>
                <td><%=material_name%></td>
                <td class="text-center"><%=stock_idx%></td>
                <td class="text-end">
                    <strong><%=FormatNumber(bw_price,0)%></strong>
                </td>
                <td><%=Left(CStr(wdate),10)%></td>
                <td class="text-center">
                    <button class="btn btn-sm btn-outline-primary"
                            onclick="openBomWmsPopup(<%=bw_idx%>);">
                        수정
                    </button>
                    <button class="btn btn-sm btn-outline-danger"
                            onclick="openBomWmsDelete(<%=bw_idx%>);">
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
                <td colspan="6" class="text-center text-muted">
                    등록된 감가상각 정보가 없습니다.
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
function openBomWmsPopup(bw_idx) {
    var url = 'TNG_WMS_BOM_Popup.asp';
    if (bw_idx) url += '?bw_idx=' + bw_idx;

    window.open(
        url,
        'bomwmsPopup',
        'width=700,height=650,scrollbars=yes,resizable=yes'
    );
}

function openBomWmsDelete(bw_idx) {
    if (!confirm('해당 감가상각 정보를 삭제하시겠습니까?')) return;
    location.href = 'TNG_WMS_BOM_DB.asp?mode=delete&bw_idx=' + bw_idx;
}
</script>

</body>
</html>

<%
Rs.Close
Set Rs = Nothing
call dbClose()
%>
