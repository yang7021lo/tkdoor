<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!-- DB / 공통 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

<%
Call dbOpen()

' =========================
' 페이징
' =========================
Dim gotopage, pagesize
gotopage = Request("gotopage")
If gotopage = "" Or Not IsNumeric(gotopage) Then gotopage = 1
gotopage = CInt(gotopage)

pagesize = 12   ' 카드형이라 줄임

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")
%>

<!-- 상단 / 좌측 메뉴 -->
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->

<style>
/* ================= 카드형 Spot 스타일 ================= */
.spot-card {
    background: #ffffff;
    border: 1px solid #d9dee5;
    border-radius: 14px;
    padding: 16px;
    height: 100%;
    box-shadow: 0 4px 14px rgba(0,0,0,.05);
    transition: transform .15s ease, box-shadow .15s ease;
}
.spot-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 22px rgba(0,0,0,.08);
}
.spot-card.inactive {
    opacity: .45;
}
.spot-title {
    font-size: 16px;
    font-weight: 800;
}
.spot-addr {
    font-size: 13px;
    color: #374151;
}
.spot-coord {
    font-size: 12px;
    color: #6b7280;
}
</style>

<div class="container-fluid mt-4">
<title>Spot 관리</title>

    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">Spot 관리</h5>
        <button class="btn btn-primary btn-sm"
                onclick="openSpotInsert();">
            + Spot 등록
        </button>
    </div>

<%
' =========================
' SQL
' =========================
sql = ""
sql = sql & " SELECT "
sql = sql & "     spot_idx, spot_name, "
sql = sql & "     addr, addr_detail, "
sql = sql & "     addr_lat, addr_long, "
sql = sql & "     status, is_active, wdate "
sql = sql & " FROM tk_wms_role_spot "
sql = sql & " ORDER BY spot_idx DESC "

Rs.CursorLocation = 3
Rs.PageSize = pagesize
Rs.Open sql, DbCon, 1, 1

If Rs.PageCount > 0 Then
    If gotopage > Rs.PageCount Then gotopage = Rs.PageCount
    If gotopage < 1 Then gotopage = 1
    Rs.AbsolutePage = gotopage
End If
%>

    <!-- 카드형 리스트 -->
    <div class="row g-3">

<%
If Not (Rs.BOF Or Rs.EOF) Then

    Dim i
    i = 0

    Do Until Rs.EOF Or i >= Rs.PageSize

        Dim spot_idx, spot_name
        Dim addr, addr_detail
        Dim addr_lat, addr_long
        Dim status, is_active, wdate
        Dim status_txt, status_cls, card_cls

        spot_idx    = Rs("spot_idx")
        spot_name   = Rs("spot_name")
        addr        = Rs("addr")
        addr_detail = Rs("addr_detail")
        addr_lat    = Rs("addr_lat")
        addr_long   = Rs("addr_long")
        status      = Rs("status")
        is_active   = Rs("is_active")
        wdate       = Rs("wdate")

        status_txt = "대기"
        status_cls = "bg-secondary"
        If status = 1 Then
            status_txt = "운영"
            status_cls = "bg-success"
        End If

        card_cls = ""
        If is_active = 0 Then card_cls = "inactive"
%>

        <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12">
            <div class="spot-card <%=card_cls%>">

                <!-- 상단 -->
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <div class="spot-title"><%=spot_name%></div>
                    <span class="badge <%=status_cls%>"><%=status_txt%></span>
                </div>

                <!-- 주소 -->
                <div class="spot-addr mb-2">
                    <%=addr%><br>
                    <span class="text-muted"><%=addr_detail%></span>
                </div>

                <!-- 좌표 -->
                <div class="spot-coord mb-3">
                    LAT : <%=addr_lat%><br>
                    LNG : <%=addr_long%>
                </div>

                <!-- 하단 버튼 -->
                <div class="d-flex justify-content-end gap-2">
                    <button class="btn btn-sm btn-outline-primary"
                            onclick="openSpotUpdate(<%=spot_idx%>);">
                        수정
                    </button>
                    <button class="btn btn-sm btn-outline-danger"
                            onclick="deleteSpot(<%=spot_idx%>);">
                        삭제
                    </button>
                </div>

            </div>
        </div>

<%
        Rs.MoveNext
        i = i + 1
    Loop

Else
%>
        <div class="col-12 text-center text-muted">
            등록된 Spot 정보가 없습니다.
        </div>
<%
End If
%>

    </div>

    <!-- 페이징 -->
    <div class="mt-4">
        <!--#include virtual="/inc/paging.asp"-->
    </div>

</div>

<script>
function openSpotInsert() {
    window.open(
        'TNG_WMS_Spot_Popup.asp',
        'SpotPopup',
        'width=700,height=650,scrollbars=yes,resizable=yes'
    );
}

function openSpotUpdate(spot_idx) {
    window.open(
        'TNG_WMS_Spot_Popup.asp?spot_idx=' + spot_idx,
        'SpotPopup',
        'width=700,height=650,scrollbars=yes,resizable=yes'
    );
}

function deleteSpot(spot_idx) {
    if (!confirm('해당 Spot을 삭제하시겠습니까?')) return;
    location.href =
        'TNG_WMS_Spot_DB.asp?mode=delete&spot_idx=' + spot_idx;
}
</script>

</body>
</html>

<%
Rs.Close
Set Rs = Nothing
Call dbClose()
%>
