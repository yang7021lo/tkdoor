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
Dim mode, role_detail_idx, role_core_idx
Dim step, is_finish, is_active, is_popup
Dim cmidx, cmeidx

mode            = Trim(Request("mode"))
role_detail_idx = Trim(Request("role_detail_idx"))
role_core_idx   = Trim(Request("role_core_idx"))
step            = Trim(Request("step"))
is_finish       = Trim(Request("is_finish"))
is_popup        = Trim(Request("is_popup"))



cmidx  = C_midx
cmeidx = C_midx

' response.write "mode : " &mode& "<br>"
' response.write "role_detail_idx : " &role_detail_idx& "<br>"
' response.write "role_core_idx : " &role_core_idx& "<br>"
' response.write "step : " &step& "<br>"
' response.write "is_finish : " &is_finish& "<br>"
' response.write "is_popup : " &is_popup& "<br>"

' response.end
' =========================
' 필수값 체크
' =========================
If mode <> "delete" Then
    If role_core_idx = "" Or step = "" Then
        Response.Write "<script>alert('필수 값이 누락되었습니다.'); history.back();</script>"
        Response.End
    End If
End If

' =========================
' DELETE
' -------------------------
If mode = "delete" And role_detail_idx <> "" Then

    sql = ""
    sql = sql & " UPDATE tk_wms_role_detail SET "
    sql = sql & "     is_active = 0, "
    sql = sql & "     meidx = " & cmeidx & ", "
    sql = sql & "     udate = GETDATE() "
    sql = sql & " WHERE role_detail_idx = " & role_detail_idx

' =========================
' UPDATE
' -------------------------
ElseIf mode = "update" Then

    sql = ""
    sql = sql & " UPDATE tk_wms_role_detail SET "
    sql = sql & "     step = " & step & ", "
    sql = sql & "     is_finish = " & is_finish & ", "
    sql = sql & "     meidx = " & cmeidx & ", "
    sql = sql & "     udate = GETDATE() "
    sql = sql & " WHERE role_detail_idx = " & role_detail_idx

' =========================
' INSERT
' -------------------------
ElseIf mode = "insert" Then

    sql = ""
    sql = sql & " INSERT INTO tk_wms_role_detail ( "
    sql = sql & "     role_core_idx, "
    sql = sql & "     step, "
    sql = sql & "     is_finish, "
    sql = sql & "     midx, "
    sql = sql & "     meidx, "
    sql = sql & "     wdate "
    sql = sql & " ) VALUES ( "
    sql = sql & "     " & role_core_idx & ", "
    sql = sql & "     " & step & ", "
    sql = sql & "     " & is_finish & ", "
    sql = sql & "     " & cmidx & ", "
    sql = sql & "     " & cmeidx & ", "
    sql = sql & "     GETDATE() "
    sql = sql & " )"

End If

DbCon.Execute sql
Call dbClose()

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
    Response.Redirect "TNG_WMS_Role_Detail_List.asp?role_core_idx=" & role_core_idx
End If
%>
