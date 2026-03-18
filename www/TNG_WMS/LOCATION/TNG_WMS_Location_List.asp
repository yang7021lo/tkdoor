<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!-- 공통 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link rel="icon" type="image/x-icon"
      href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
<script type="text/javascript">
function openLocationPopup(params) {
    try {
        params = params || {};

        var url = 'TNG_WMS_Location_Popup.asp';
        var q = [];

        for (var k in params) {
            if (params.hasOwnProperty(k)) {
                if (params[k] !== undefined && params[k] !== "") {
                    q.push(k + '=' + encodeURIComponent(params[k]));
                }
            }
        }

        if (q.length > 0) {
            url += '?' + q.join('&');
        }

        console.log("popup url:", url);

        var w = window.open(
            url,
            'locPopup',
            'width=600,height=650,scrollbars=yes,resizable=yes'
        );

        if (!w) {
            alert("팝업이 차단되었습니다. 브라우저 팝업 차단을 해제하세요.");
        }
    } catch (e) {
        console.error(e);
        alert("openLocationPopup 오류: " + e.message);
    }
}
</script>

<%
Call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Set RsLoc = Server.CreateObject("ADODB.Recordset")
' =====================================================
' 검색 파라미터
' =====================================================
Dim sch_name
sch_name = Trim(Request("sch_name"))

' =====================================================
' Warehouse / Location 집계 SQL
' =====================================================
Dim SQL, RsLoc


SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & "  W.wh_idx, "
SQL = SQL & "  W.wh_idx, "
SQL = SQL & "  W.wh_name, "
SQL = SQL & "  L.loc_code, "
SQL = SQL & "  L.zone, L.rack, L.shelf, L.bin, "
SQL = SQL & "  COUNT(L.stock_sub_idx) AS lot_cnt, "
SQL = SQL & "  SUM(ISNULL(L.amount,0)) AS total_amount, "
SQL = SQL & "  ISNULL(L.use_yn,1) AS use_yn "
SQL = SQL & "FROM tk_wms_stock_loc L "
SQL = SQL & "JOIN tk_wms_warehouse W ON L.wh_idx = W.wh_idx "
SQL = SQL & "WHERE 1=1 "
SQL = SQL & " AND L.is_active = 1 "

' ✅ 사용 로케이션만 필터링
SQL = SQL & " AND ISNULL(L.use_yn,1) = 1 "

If sch_name <> "" Then
    SQL = SQL & " AND W.wh_name LIKE '%" & sch_name & "%'"
End If

SQL = SQL & "GROUP BY "
SQL = SQL & "  W.wh_idx, W.wh_name, "
SQL = SQL & "  L.loc_code, "
SQL = SQL & "  L.zone, L.rack, L.shelf, L.bin, "
SQL = SQL & "  ISNULL(L.use_yn,1) "

SQL = SQL & "ORDER BY "
SQL = SQL & "  W.wh_name, "
SQL = SQL & "  L.zone, L.rack, L.shelf, L.bin "
'response.Write SQL & "<br/>"
RsLoc.Open SQL, DbCon
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>창고 위치 현황</title>


<style>
body { background:#f4f6f9; font-size:14px; }
.table th, .table td { vertical-align: middle; }
.badge-lot { background:#0d6efd; }
.badge-qty { background:#198754; }
.loc-code { font-weight:600; color:#212529; }
</style>
</head>

<body>

<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->

<div class="container-fluid mt-4">

    <h5 class="fw-bold mb-3">🏬 창고 위치 현황 </h5>


    <!-- 🔍 검색 -->
   <div class="d-flex justify-content-between align-items-end mb-3">

        <!-- 왼쪽: 검색 -->
        <form method="get" class="d-flex gap-2">
            <input type="text" name="sch_name" class="form-control"
                placeholder="이름" style="width:200px;">
            <button class="btn btn-primary">검색</button>
        </form>

        <!-- 오른쪽: 등록 -->
        <button type="button"
                class="btn btn-primary"
                onclick="openLocationPopup('');">
            + 위치 등록
        </button>

    </div>

    

    <!-- 📋 리스트 -->
    <table class="table table-bordered table-hover bg-white">
        <thead class="table-light">
        <tr>
            <th>창고</th>
            <th>Loc Code</th>

            <th class="text-center">LOT 수</th>
            <th class="text-end">총 수량</th>
            <th>상세</th>
        </tr>
        </thead>
        <tbody>
        <%
        If RsLoc.EOF Then
        %>
            <tr>
                <td colspan="9" class="text-center text-muted">
                    데이터가 없습니다.
                </td>
            </tr>
        <%
        Else
            Do Until RsLoc.EOF
            wh_idx = RsLoc("wh_idx")
            loc_code = RsLoc("loc_code")
        %>
            <tr>
                <td><%=RsLoc("wh_name")%></td>
                <td class="loc-code"><%=loc_code%></td>
  
                <td class="text-center">
                    <span class="badge badge-lot">
                        <%=RsLoc("lot_cnt")%> LOT
                    </span>
                </td>
                <td class="text-end">
                    <span class="badge badge-qty">
                        <%=RsLoc("total_amount")%>
                    </span>
                </td>
                <td class="text-center">
                    <button type="button"
                        class="btn btn-sm btn-outline-primary"
                        onclick="openLocationPopup({wh_idx: '<%=wh_idx%>', mode: 'update', loc_code: '<%=loc_code%>'});">
                    상세
                </button>
                </td>
            </tr>
        <%
                RsLoc.MoveNext
            Loop
        End If
        %>
        </tbody>
    </table>

</div>
</body>
</html>

<%
If IsObject(RsLoc) Then
    If RsLoc.State = 1 Then RsLoc.Close
    Set RsLoc = Nothing
End If
%>
