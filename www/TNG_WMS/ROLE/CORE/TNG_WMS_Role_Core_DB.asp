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
Dim mode, role_core_idx, bfwidx, no, is_popup
Dim cmidx, cmeidx

mode          = Trim(Request("mode"))
role_core_idx = Trim(Request("role_core_idx"))
bfwidx        = Trim(Request("bfwidx"))
no            = Trim(Request("no"))
is_popup      = Trim(Request("is_popup"))

cmidx  = C_midx
cmeidx = C_midx

' response.write "mode :" &mode& "<br>"
' response.write "role_core_idx :" &role_core_idx& "<br>"
' response.write "bfwidx :" &bfwidx& "<br>"
' response.write "no :" &no& "<br>"
' response.write "is_popup :" &is_popup& "<br>"
' response.end
' =========================
' 필수값 체크
' =========================
If mode <> "delete" Then
    If bfwidx = "" Or no = "" Then
        Response.Write "<script>alert('바라시 유형 또는 순서가 입력되지 않았습니다.'); history.back();</script>"
        Response.End
    End If
End If

' =========================
' 중복 체크
' 같은 바라시 유형(bfwidx) 중복 방지
' =========================
If mode <> "delete" Then

    Dim RsChk, sql
    Set RsChk = Server.CreateObject("ADODB.Recordset")

    sql = ""
    sql = sql & " SELECT role_core_idx "
    sql = sql & " FROM tk_wms_role_core "
    sql = sql & " WHERE bfwidx = " & bfwidx
    sql = sql & "   AND is_active = 1 "

    If mode = "update" Then
        sql = sql & " AND role_core_idx <> " & role_core_idx
    End If

    RsChk.Open sql, DbCon, 1, 1

    If Not RsChk.EOF Then
        RsChk.Close
        Set RsChk = Nothing

        Response.Write "<script>alert('이미 등록된 바라시 유형 규칙입니다.'); history.back();</script>"
        Response.End
    End If

    RsChk.Close
    Set RsChk = Nothing
End If

' ----------------------------
' DELETE (논리삭제)
' ----------------------------
If mode = "delete" And role_core_idx <> "" Then

    sql = ""
    sql = sql & " UPDATE tk_wms_role_core SET "
    sql = sql & "     is_active = 0, "
    sql = sql & "     meidx = " & cmeidx & ", "
    sql = sql & "     udate = GETDATE() "
    sql = sql & " WHERE role_core_idx = " & role_core_idx

' ----------------------------
' UPDATE
' ----------------------------
ElseIf mode = "update" Then

    sql = ""
    sql = sql & " UPDATE tk_wms_role_core SET "
    sql = sql & "     bfwidx = " & bfwidx & ", "
    sql = sql & "     no = " & no & ", "
    sql = sql & "     meidx = " & cmeidx & ", "
    sql = sql & "     udate = GETDATE() "
    sql = sql & " WHERE role_core_idx = " & role_core_idx

' ----------------------------
' INSERT
' ----------------------------
ElseIf mode = "insert" Then

    sql = ""
    sql = sql & " INSERT INTO tk_wms_role_core ( "
    sql = sql & "     bfwidx, "
    sql = sql & "     no, "
    sql = sql & "     midx, "
    sql = sql & "     meidx, "
    sql = sql & "     wdate "
    sql = sql & " ) VALUES ( "
    sql = sql & "     " & bfwidx & ", "
    sql = sql & "     " & no & ", "
    sql = sql & "     " & cmidx & ", "
    sql = sql & "     " & cmeidx & ", "
    sql = sql & "     GETDATE() "
    sql = sql & " )"

End If

'response.write "SQL : " & sql & "<br>"
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
    Response.Redirect "TNG_WMS_Role_Core_List.asp"
End If
%>
