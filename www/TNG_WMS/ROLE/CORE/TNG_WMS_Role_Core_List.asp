<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"
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
page_name = "TNG_WMS_Role_Core_List.asp?"
' =========================
' 검색 파라미터 (바라시명)
' =========================
Dim sch_name
sch_name = Trim(Request("sch_name"))
%>

<!-- 상단 / 좌측 메뉴 -->
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->

<div class="container-fluid mt-4">
<title>규칙 집합 관리</title>

    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">규칙 집합 관리</h5>
        <button class="btn btn-primary btn-sm"
                onclick="openRoleCoreInsert();">
            + 규칙 집합 등록
        </button>
    </div>

    <!-- 검색 -->
    <form method="get" class="row g-2 mb-3">
        <div class="col-md-3">
            <input type="text" name="sch_name" class="form-control"
                   placeholder="바라시 유형명"
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
sql = sql & " SELECT role_core_idx, bfwidx, no "
sql = sql & " FROM tk_wms_role_core "
sql = sql & " WHERE is_active = 1 "

If sch_name <> "" Then
    sql = sql & " AND ( "
    sql = sql & "     W.WHICHI_FIXName LIKE '%" & Replace(sch_name,"'","''") & "%' "
    sql = sql & "  OR W.WHICHI_AUTOName LIKE '%" & Replace(sch_name,"'","''") & "%' "
    sql = sql & " ) "
End If

sql = sql & " ORDER BY role_core_idx DESC "
'response.write "SQL : " &SQL& "<br>"
Rs.CursorLocation = 3   ' adUseClient
Rs.PageSize = pagesize
Rs.Open sql, DbCon, 1, 1

If Rs.PageCount > 0 Then
    If gotopage > Rs.PageCount Then gotopage = Rs.PageCount
    If gotopage < 1 Then gotopage = 1
    Rs.AbsolutePage = gotopage
End If
%>
<!--#include virtual="/TNG_WMS/Cache/Cache_whichitype.asp"-->
    <!-- 리스트 -->
    <table class="table table-bordered table-hover bg-white">
        <thead class="table-light">
            <tr>
                <th style="width:250px;">바라시 유형</th>
                <th>순서</th>
                <th style="width:160px;">관리</th>
            </tr>
        </thead>
        <tbody>

<%
If Not (Rs.BOF Or Rs.EOF) Then

    Dim i
    i = 0

    Do Until Rs.EOF Or i >= Rs.PageSize

        Dim role_core_idx, no, whichi_name, type_flag
        role_core_idx = Rs("role_core_idx")
        no = Rs("no")
        bfwidx = Rs("bfwidx")
        whichi_name = ""



        type_flag = ""

        If dictWhichi.Exists(CStr(bfwidx)) Then
            type_flag  = dictWhichi(CStr(bfwidx))(0)
            whichi_name = dictWhichi(CStr(bfwidx))(1)
        Else
            type_flag  = "?"
            whichi_name = "미정의"
        End If
%>
            <tr style="cursor:pointer;"
                onclick="goRoleDetail('<%=role_core_idx%>');">

                <td><%=whichi_name%></td>
                <td class="text-center"><%=no%></td>

                <td class="text-center">
                    <button class="btn btn-sm btn-outline-primary"
                            onclick="event.stopPropagation(); openRoleCoreUpdate(<%=role_core_idx%>);">
                        수정
                    </button>
                    <button class="btn btn-sm btn-outline-danger"
                            onclick="event.stopPropagation(); deleteRoleCore(<%=role_core_idx%>);">
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
                    등록된 규칙 집합이 없습니다.
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
function openRoleCoreInsert() {
    window.open(
        'TNG_WMS_Role_Core_Popup.asp',
        'roleCorePopup',
        'width=700,height=500,scrollbars=yes,resizable=yes'
    );
}

function openRoleCoreUpdate(role_core_idx) {
    window.open(
        'TNG_WMS_Role_Core_Popup.asp?role_core_idx=' + role_core_idx,
        'roleCorePopup',
        'width=700,height=500,scrollbars=yes,resizable=yes'
    );
}

function deleteRoleCore(role_core_idx) {
    if (!confirm('삭제하시겠습니까?')) return;
    location.href =
        'TNG_WMS_Role_Core_DB.asp?mode=delete&role_core_idx=' + role_core_idx;
}

function goRoleDetail(role_core_idx) {
    if (!role_core_idx) return;
    location.href =
        '/TNG_WMS/ROLE/DETALE/TNG_WMS_Role_Detail_List.asp?role_core_idx=' + role_core_idx;
}
</script>

</body>
</html>

<%
Rs.Close
Set Rs = Nothing
Call dbClose()
%>
