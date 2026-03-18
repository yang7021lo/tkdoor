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
call dbOpen()

' =========================
' 공용 Recordset
' =========================
Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")
role_team_idx = Request("role_team_idx")
company_idx = Request("company_idx")
' =========================
' 페이징 변수 (paging.asp 계약)
' =========================
Dim gotopage, pagesize
gotopage = Request("gotopage")
If gotopage = "" Or Not IsNumeric(gotopage) Then gotopage = 1
gotopage = CInt(gotopage)

pagesize = 10

' =========================
' 검색 파라미터 (팀명)
' =========================
Dim sch_name
sch_name = Trim(Request("sch_name"))

sql = "select  role_team_name from tk_wms_role_team where is_active=1 AND role_team_idx=" & Request("role_team_idx")
Rs.Open sql, DbCon, 1, 1
If Not (Rs.BOF Or Rs.EOF) Then
    role_team_name = Rs("role_team_name")
End If
Rs.Close
%>

<!-- 상단 / 좌측 메뉴 -->
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->
<!--직원 캐시 (dbOpen 이후!)-->
<!--#include virtual="/TNG_WMS/Cache/Cache_member.asp"-->
<div class="container-fluid mt-4">
<title>맴버 관리</title>

    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0"><%=role_team_name%> 맴버 관리</h5>
        <button class="btn btn-primary btn-sm"
                onclick="openMemberInsert(<%=role_team_idx%>, <%=company_idx%>);">
            + 맴버 등록
        </button>
    </div>

    <!-- 검색 -->
    <form method="get" class="row g-2 mb-3">
        <div class="col-md-3">
            <input type="text" name="sch_name" class="form-control"
                   placeholder="이름"
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
sql = sql & " SELECT role_team_member_idx, memidx, role_team_position "
sql = sql & " FROM tk_wms_role_team_member "
sql = sql & " WHERE role_team_idx = " & role_team_idx

If sch_name <> "" Then
    sql = sql & " AND T.role_team_name LIKE '%" & Replace(sch_name,"'","''") & "%' "
End If

sql = sql & " ORDER BY role_team_member_idx DESC "

'response.Write "sql:" & sql & "<br>"
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

                <th>팀원 이름</th>
                <th>담당 업무</th>
                <th style="width:160px;">관리</th>
            </tr>
        </thead>
        <tbody>

<%
If Not (Rs.BOF Or Rs.EOF) Then

    Dim i
    i = 0

    Do Until Rs.EOF Or i >= Rs.PageSize

        Dim role_team_member_idx, memidx, role_team_position, mname
        role_team_member_idx = Rs("role_team_member_idx")
        memidx = Rs("memidx")
        role_team_position = Rs("role_team_position")



        If dictMember.Exists(CStr(memidx)) Then
            mname = dictMember(CStr(memidx))
        End If
%>
            <tr>

                <td style="cursor:pointer; background-color:#f8f9fa;" onclick="goTeamMember('<%=role_team_idx%>');"><%=mname%></td>
                <td><%=role_team_position%></td>

                <td class="text-center">
                    <button class="btn btn-sm btn-outline-primary"
                            onclick="openMemberUpdate(<%=role_team_member_idx%>, '<%=memidx%>', <%=company_idx%>, <%=role_team_idx%>);">
                        수정
                    </button>
                    <button class="btn btn-sm btn-outline-danger"
                            onclick="deleteMember(<%=role_team_member_idx%>);">
                        삭제
                    </button>
                </td>
            </tr>

            <form id="memberPopupForm"
                method="post"
                action="TNG_WMS_Team_Member_Popup.asp"
                target="teamPopup">
                <input type="hidden" name="mode" id="f_mode">
                <input type="hidden" name="role_team_member_idx" id="f_role_team_member_idx">
                <input type="hidden" name="memidx" id="f_memidx">
                <input type="hidden" name="company_idx" id="f_company_idx">
                <input type="hidden" name="role_team_idx" id="f_role_team_idx">
            </form>
<%
        Rs.MoveNext
        i = i + 1
    Loop

Else
%>
            <tr>
                <td colspan="5" class="text-center text-muted">
                    등록된 맴버가 없습니다.
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
function openMemberInsert(role_team_idx ,company_idx) {
    var url = 'TNG_WMS_Team_Member_Popup.asp';
    if (role_team_idx) url += '?role_team_idx=' + role_team_idx  + '&company_idx=' + company_idx;

    window.open(
        url,
        'teamPopup',
        'width=700,height=600,scrollbars=yes,resizable=yes'
    );
}

function openMemberUpdate(role_team_member_idx, memidx, company_idx, role_team_idx) {

    document.getElementById('f_mode').value = 'update';
    document.getElementById('f_role_team_member_idx').value = role_team_member_idx;
    document.getElementById('f_memidx').value = memidx;
    document.getElementById('f_company_idx').value = company_idx;
    document.getElementById('f_role_team_idx').value = role_team_idx;

    window.open('', 'teamPopup',
        'width=700,height=600,scrollbars=yes,resizable=yes');

    document.getElementById('memberPopupForm').submit();
}


function deleteMember(role_team_member_idx) {
    if (!confirm('삭제하시겠습니까??')) return;
    location.href =
        'TNG_WMS_Team_Member_DB.asp?mode=delete&role_team_member_idx=' + role_team_member_idx;
}

function goTeamMember(role_team_idx) {
    if (!role_team_idx) return;
    location.href = '/TNG_WMS/TEAM/TEAM_MEMBER/TNG_WMS_Team_Member_List.asp?role_team_idx=' + role_team_idx;
}
</script>

</body>
</html>

<%
Rs.Close
Set Rs = Nothing
call dbClose()
%>
