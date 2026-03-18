<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!-- DB / 공통 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link rel="icon" type="image/x-icon"
      href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
<%
Call dbOpen()

' =========================
' 파라미터
' =========================
Dim role_core_idx
role_core_idx = Trim(Request("role_core_idx"))

If role_core_idx = "" Or Not IsNumeric(role_core_idx) Then
    Response.Write "<script>alert('잘못된 접근입니다.'); history.back();</script>"
    Response.End
End If

' =========================
' 공용 Recordset
' =========================
Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

' =========================
' 페이징 변수
' =========================
Dim gotopage, pagesize
gotopage = Request("gotopage")
If gotopage = "" Or Not IsNumeric(gotopage) Then gotopage = 1
gotopage = CInt(gotopage)

pagesize = 10
%>

<!-- 상단 / 좌측 메뉴 -->
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->

<div class="container-fluid mt-4">
<title>규칙 순서 관리</title>

    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">
            규칙 순서 관리 (Core ID : <%=role_core_idx%>)
        </h5>
        <button class="btn btn-primary btn-sm"
                onclick="openDetailInsert(<%=role_core_idx%>);">
            + 순서 추가
        </button>
    </div>

<%
' =========================
' SQL
' =========================
sql = ""
sql = sql & " SELECT "
sql = sql & "     role_detail_idx, "
sql = sql & "     step, "
sql = sql & "     is_finish, "
sql = sql & "     is_active "
sql = sql & " FROM tk_wms_role_detail "
sql = sql & " WHERE role_core_idx = " & role_core_idx
sql = sql & " ORDER BY step ASC, role_detail_idx ASC "

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
                <th style="width:120px;">순서(step)</th>
                <th style="width:160px;">단계 구분</th>
                <th style="width:120px;">사용 여부</th>
                <th style="width:180px;">관리</th>
            </tr>
        </thead>
        <tbody>

<%
If Not (Rs.BOF Or Rs.EOF) Then

    Dim i
    i = 0

    Do Until Rs.EOF Or i >= Rs.PageSize

        Dim role_detail_idx, step, is_finish, is_active
        Dim finish_txt, active_txt, row_class

        role_detail_idx = Rs("role_detail_idx")
        step      = Rs("step")
        is_finish = Rs("is_finish")
        is_active = Rs("is_active")

        row_class = ""

        If is_active = 0 Then
            active_txt = "미사용"
            row_class = "table-secondary"
        Else
            active_txt = "사용"
        End If

        If is_finish = 1 Then
            finish_txt = "완료 단계"
        Else
            finish_txt = "진행 단계"
        End If
%>
            <tr class="<%=row_class%>">
                <td class="text-center fw-bold"><%=step%></td>
                <td class="text-center"><%=finish_txt%></td>
                <td class="text-center"><%=active_txt%></td>
                <td class="text-center">
                    <button class="btn btn-sm btn-outline-primary"
                            onclick="openDetailUpdate(<%=role_detail_idx%>, <%=role_core_idx%>);">
                        수정
                    </button>
                    <button class="btn btn-sm btn-outline-danger"
                            onclick="deleteDetail(<%=role_detail_idx%>, <%=role_core_idx%>);">
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
                    등록된 순서(step)가 없습니다.
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
function openDetailInsert(role_core_idx) {
    window.open(
        'TNG_WMS_Role_Detail_Popup.asp?role_core_idx=' + role_core_idx,
        'detailPopup',
        'width=600,height=500,scrollbars=yes,resizable=yes'
    );
}

function openDetailUpdate(role_detail_idx, role_core_idx) {
    window.open(
        'TNG_WMS_Role_Detail_Popup.asp?role_detail_idx=' + role_detail_idx +
        '&role_core_idx=' + role_core_idx,
        'detailPopup',
        'width=600,height=500,scrollbars=yes,resizable=yes'
    );
}

function deleteDetail(role_detail_idx, role_core_idx) {
    if (!confirm('해당 순서를 삭제하시겠습니까?')) return;
    location.href =
        'TNG_WMS_Role_Detail_DB.asp?mode=delete'
        + '&role_detail_idx=' + role_detail_idx
        + '&role_core_idx=' + role_core_idx;
}
</script>

</body>
</html>

<%
Rs.Close
Set Rs = Nothing
Call dbClose()
%>
