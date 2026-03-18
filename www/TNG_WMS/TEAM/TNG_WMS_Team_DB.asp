<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!-- 공통 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%
' =========================
' DB OPEN
' =========================
Call dbOpen()

' =========================
' 파라미터
' =========================
Dim mode
Dim role_team_idx
Dim role_team_name
Dim company_idx
Dim is_active
Dim is_popup

mode           = LCase(Trim(Request("mode")))
role_team_idx  = Trim(Request("role_team_idx"))
role_team_name = Trim(Request("role_team_name"))
company_idx    = Trim(Request("company_idx"))
is_active      = Trim(Request("is_active"))
is_popup       = Trim(Request("is_popup"))

midx  = c_midx   ' 로그인 사용자
meidx = c_midx

If mode = "" Then
    If role_team_idx <> "" Then
        mode = "update"
    Else
        mode = "insert"
    End If
End If

If is_active = "" Then is_active = "1"

' =========================
' 기본 검증
' =========================
If mode <> "delete" Then

    If role_team_name = "" Then
        Response.Write "<script>alert('팀명을 입력하세요.');history.back();</script>"
        Response.End
    End If

    If company_idx = "" Or Not IsNumeric(company_idx) Then
        Response.Write "<script>alert('회사를 선택하세요.');history.back();</script>"
        Response.End
    End If

    If is_active <> "0" And is_active <> "1" Then
        is_active = "1"
    End If

End If

' =========================
' SQL
' =========================
Dim sql

Select Case mode

    ' -------------------------
    ' INSERT
    ' -------------------------
    Case "insert"

        sql = ""
        sql = sql & " INSERT INTO tk_wms_role_team ( "
        sql = sql & "   role_team_name, company_idx, midx, meidx,wdate,udate "
        sql = sql & " ) VALUES ( "
        sql = sql & "   '" & Replace(role_team_name,"'","''") & "', "
        sql = sql & "   " & CLng(company_idx) & ", "
        sql = sql & "   '" & midx & "', "
        sql = sql & "   '" & meidx & "', "
        sql = sql & "   GETDATE(), "
        sql = sql & "   GETDATE() "
        sql = sql & " ) "

        DbCon.Execute sql

    ' -------------------------
    ' UPDATE
    ' -------------------------
    Case "update"

        If role_team_idx = "" Or Not IsNumeric(role_team_idx) Then
            Response.Write "<script>alert('잘못된 접근입니다.');</script>"
            Response.End
        End If

        sql = ""
        sql = sql & " UPDATE tk_wms_role_team SET "
        sql = sql & "   role_team_name = '" & Replace(role_team_name,"'","''") & "', "
        sql = sql & "   company_idx    = " & CLng(company_idx) & ", "
        sql = sql & "   is_active      = " & CLng(is_active) & " "
        sql = sql & " WHERE role_team_idx = " & CLng(role_team_idx)

        DbCon.Execute sql

    ' -------------------------
    ' DELETE (비활성)
    ' -------------------------
    Case "delete"

        If role_team_idx = "" Or Not IsNumeric(role_team_idx) Then
            Response.Write "<script>alert('잘못된 접근입니다.');</script>"
            Response.End
        End If

        sql = ""
        sql = sql & " UPDATE tk_wms_role_team "
        sql = sql & " SET is_active = 0 "
        sql = sql & " WHERE role_team_idx = " & CLng(role_team_idx)

        DbCon.Execute sql

    Case Else
        Response.Write "<script>alert('처리할 수 없는 요청입니다.');</script>"
        Response.End

End Select

' =========================
' 회사 캐시 초기화
' =========================
Application.Lock
Application("dictCompany") = Empty
Application.UnLock

' =========================
' 팝업 / 일반 페이지 분기
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
    Response.Redirect "TNG_WMS_Team_List.asp"
End If
%>

<%
Call dbClose()
%>
