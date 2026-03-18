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
Call dbOpen()

' =========================
' 파라미터
' =========================
Dim role_team_idx
role_team_idx = Trim(Request("role_team_idx"))

If role_team_idx = "" Or Not IsNumeric(role_team_idx) Then
    Response.Write "<script>alert('잘못된 접근입니다.');history.back();</script>"
    Response.End
End If

' =========================
' 팀명 조회
' =========================
Dim teamName, sql, RsTeam
teamName = ""

Set RsTeam = Server.CreateObject("ADODB.Recordset")

sql = ""
sql = sql & " SELECT role_team_name "
sql = sql & " FROM tk_wms_role_team "
sql = sql & " WHERE role_team_idx = " & CLng(role_team_idx)

RsTeam.Open sql, DbCon

If Not RsTeam.EOF Then
    teamName = RsTeam("role_team_name")
End If

RsTeam.Close
Set RsTeam = Nothing
%>

<!-- 상단 / 좌측 -->
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->

<div class="container-fluid mt-4">

    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h5 class="fw-bold mb-0">👥 <%=teamName%> - 팀원 목록</h5>
            <div class="text-muted">해당 팀에 소속된 구성원</div>
        </div>
    </div>

<%
' =========================
' 팀원 목록 조회
' =========================
Dim RsMember
Set RsMember = Server.CreateObject("ADODB.Recordset")

sql = ""
sql = sql & " SELECT "
sql = sql & "   M.role_team_member_id, "
sql = sql & "   M.role_team_position, "
sql = sql & "   U.midx, "
sql = sql & "   U.mname, "
sql = sql & "   U.mid "
sql = sql & " FROM tk_wms_role_team_member M "
sql = sql & " INNER JOIN tk_member U "
sql = sql & "   ON M.midx = U.midx "
sql = sql & " WHERE M.role_team_idx = " & CLng(role_team_idx)
sql = sql & " ORDER BY U.mname ASC "

RsMember.Open sql, DbCon
%>

    <!-- 리스트 -->
    <div class="card">
        <div class="table-responsive">
            <table class="table table-bordered table-hover mb-0 bg-white">
                <thead class="table-light">
                    <tr>
                        <th style="width:80px;">IDX</th>
                        <th style="width:120px;">아이디</th>
                        <th style="width:150px;">이름</th>
                        <th>담당 업무 / 직무</th>
                    </tr>
                </thead>
                <tbody>

<%
If Not (RsMember.BOF Or RsMember.EOF) Then

    Do Until RsMember.EOF
%>
                    <tr>
                        <td class="text-center"><%=RsMember("role_team_member_id")%></td>
                        <td><%=RsMember("mid")%></td>
                        <td class="fw-semibold"><%=RsMember("mname")%></td>
                        <td><%=RsMember("role_team_position")%></td>
                    </tr>
<%
        RsMember.MoveNext
    Loop

Else
%>
                    <tr>
                        <td colspan="4" class="text-center text-muted py-4">
                            등록된 팀원이 없습니다.
                        </td>
                    </tr>
<%
End If
%>

                </tbody>
            </table>
        </div>
    </div>

</div>

<%
RsMember.Close
Set RsMember = Nothing
Call dbClose()
%>
