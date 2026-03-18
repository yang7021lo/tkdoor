<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!-- 공통 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

<%
' =========================
' DB OPEN
' =========================
Call dbOpen()
%>

<!--직원 캐시 (dbOpen 이후!)-->
<!--#include virtual="/TNG_WMS/Cache/Cache_member.asp"-->
<%
' =========================
' 파라미터
' =========================
Dim role_team_idx
role_team_member_idx = Trim(Request("role_team_member_idx"))
role_team_idx = Trim(Request("role_team_idx"))
rcompany_idx = Trim(Request("company_idx"))
rmode = Trim(Request("mode"))

' =========================
' 페이지 모드 텍스트 
' =========================
Dim pageModeText
If role_team_idx <> "" Then
    pageModeText = "수정"
Else
    pageModeText = "등록"
End If

' =========================
' Recordset
' =========================
Dim Rs, sql, RsTeam
Set Rs = Server.CreateObject("ADODB.Recordset")
Set RsTeam = Server.CreateObject("ADODB.Recordset")



' =========================
' 수정 모드 데이터 로드
' =========================
If role_team_member_idx <> "" And IsNumeric(role_team_member_idx) Then

    sql = ""
    sql = sql & " SELECT "
    sql = sql & "     role_team_member_idx, "
    sql = sql & "     role_team_position, "
    sql = sql & "     memidx "
    sql = sql & " FROM tk_wms_role_team_member  "
    sql = sql & " WHERE role_team_member_idx = " & CLng(role_team_member_idx)

    RsTeam.Open sql, DbCon

    If Not RsTeam.EOF Then
        role_team_member_idx =  RsTeam("role_team_member_idx")
        role_team_position = RsTeam("role_team_position")
        memidx      = RsTeam("memidx")
        
    End If

    RsTeam.Close
End If

        If dictMember.Exists(CStr(memidx)) Then
            mname = dictMember(CStr(memidx))
        End If

%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>직원 <%=pageModeText%></title>

<script>
function openMemberPopup(company_idx) {
    window.open(
        'TNG_Member_Popup.asp?company_idx=' + company_idx,
        'memberPopup',
        'width=900,height=650,scrollbars=yes,resizable=yes'
    );
}
</script>
</head>

<body class="bg-light">

<div class="container-fluid p-4">

    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">직원 <%=pageModeText%></h5>
        <button type="button"
                class="btn btn-outline-secondary btn-sm"
                onclick="window.close();">
            닫기
        </button>
    </div>

    <!-- 폼 -->
    <form method="post" action="TNG_WMS_Team_Member_DB.asp">

        <input type="hidden" name="role_team_idx" value="<%=role_team_idx%>">
        <input type="hidden" name="is_popup" value="1">
        <input type="hidden" name="midx" id="midx" value="">
        <input type="hidden" name="mode" value="<%=rmode%>">
        <input type="hidden" name="role_team_member_idx" value="<%=role_team_member_idx%>">
        


        <%
   
        %>
        <!-- 회사 (캐시 + 팝업 선택) -->
        <div class="mb-3">
            <label class="form-label fw-semibold">직원 이름</label>

            <input type="hidden"
                   name="company_idx"
                   id="company_idx"
                   value="<%=rcompany_idx%>">

            <div class="d-flex gap-2">
                <input type="text"
                       id="mname"
                       class="form-control"
                       value="<%=mname%>"
                       placeholder="직원을 선택하세요"
                       readonly>

                <button type="button"
                        class="btn btn-outline-secondary"
                        onclick="openMemberPopup('<%=rcompany_idx%>');">
                    선택
                </button>
            </div>
        </div>

        <!-- 팀명 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">담당 포지션</label>
            <input type="text"
                   name="role_team_position"
                   class="form-control"
                   required
                   value="<%=role_team_position%>">
        </div>

        <!-- 버튼 -->
        <div class="d-flex justify-content-end gap-2">
            <button type="submit" class="btn btn-primary">
                저장
            </button>
            <button type="button"
                    class="btn btn-secondary"
                    onclick="window.close();">
                취소
            </button>
        </div>

    </form>

</div>

</body>
</html>

<%
Set Rs = Nothing
Call dbClose()
%>
