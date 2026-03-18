<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

' =========================
' 파라미터
' =========================
Dim role_team_idx, midx, role_team_position, is_popup

mode               = Trim(Request("mode"))
role_team_idx        = Trim(Request("role_team_idx"))
role_team_member_idx = Trim(Request("role_team_member_idx"))
midx                 = Trim(Request("midx"))
role_team_position   = Trim(Request("role_team_position"))
is_popup              = Trim(Request("is_popup"))

cmidx = C_midx
cmeidx = C_midx
' response.write "mode : " &mode& "<br>"
' response.write "role_team_idx: " & role_team_idx & "<br>"
' response.write "midx: " & midx & "<br>"
' response.write "role_team_position: " & role_team_position & "<br>"
' response.write "is_popup: " & is_popup & "<br>"

' response.end
' =========================
' 필수값 체크
' =========================
If mode <> "delete" Then
    If role_team_idx = "" Or midx = "" Then
        Response.Write "<script>alert('팀 또는 직원이 선택되지 않았습니다.'); history.back();</script>"
        Response.End
    End If
End If


' =========================
' 중복 체크 (같은 팀에 같은 직원)
' =========================
Dim RsChk, sql
Set RsChk = Server.CreateObject("ADODB.Recordset")

sql = ""
sql = sql & " SELECT role_team_member_idx "
sql = sql & " FROM tk_wms_role_team_member "
sql = sql & " WHERE role_team_idx = " & role_team_idx
sql = sql & "   AND memidx = " & midx
response.write "SQL : " &SQL& "<br>"
RsChk.Open sql, DbCon, 1, 1

If Not RsChk.EOF Then
    RsChk.Close
    Set RsChk = Nothing

    Response.Write "<script>alert('이미 팀에 등록된 직원입니다.'); history.back();</script>"
    Response.End
End If

RsChk.Close
Set RsChk = Nothing

' ----------------------------
' DELETE
' ----------------------------
If mode = "delete" And role_team_member_idx <> "" Then

    sql = ""
    sql = sql & " UPDATE tk_wms_role_team_member SET "
    sql = sql & "     is_active = 0, "
    sql = sql & "     meidx = " & cmeidx & ", "
    sql = sql & "     udate = GETDATE() "
    sql = sql & " WHERE role_team_member_idx = " & role_team_member_idx

' ----------------------------
' INSERT
' ----------------------------
ElseIf mode = "update" Then

    sql = ""
    sql = sql & " UPDATE tk_wms_role_team_member SET "
    sql = sql & "     memidx = " & midx & ", "
    sql = sql & "     role_team_position = '" & role_team_position & "', "
    sql = sql & "     meidx = " & cmeidx & ", "
    sql = sql & "     udate = GETDATE() "
    sql = sql & " WHERE role_team_member_idx = " & role_team_member_idx

' ----------------------------
' UPDATE
' ----------------------------
Else


    sql = ""
    sql = sql & " INSERT INTO tk_wms_role_team_member ("
    sql = sql & "     role_team_idx, "
    sql = sql & "     memidx, "
    sql = sql & "     role_team_position, "
    sql = sql & "     midx, "
    sql = sql & "     meidx, "
    sql = sql & "     udate, "
    sql = sql & "     wdate "
    sql = sql & " ) VALUES ("
    sql = sql & "     " & role_team_idx & ", "
    sql = sql & "     " & midx & ", "
    sql = sql & "     '" & role_team_position & "', "
    sql = sql & "     " & cmidx & ", "
    sql = sql & "     " & cmeidx & ", "
    sql = sql & "     GETDATE(), "
    sql = sql & "     GETDATE() "
    sql = sql & " )"

End If
 
response.write "SQL : " &sql& "<br>"
DbCon.Execute sql
call dbClose()
' =========================
' 종료 처리
' =========================
If is_popup = "1" Then
%>
    <script>
        if (window.opener && !window.opener.closed) {
            window.opener.location.reload();
        }
        window.close();
    </script>
<%
Else
    Response.Redirect "TNG_WMS_Team_Member_List.asp"
End If

Call dbClose()
%>
