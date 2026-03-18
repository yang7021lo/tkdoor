<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->

<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' 파라미터
' ===============================
Dim list_title_id, sub_name

If IsNumeric(Request("list_title_id")) Then
    list_title_id = CLng(Request("list_title_id"))
Else
    Response.Write "INVALID_LIST_TITLE"
    Response.End
End If

sub_name = Trim(Request("sub_name") & "")
If sub_name = "" Then
    Response.Write "EMPTY_SUB_NAME"
    Response.End
End If

sub_name = Replace(sub_name, "'", "''")

' ===============================
' list_title 유효성
' ===============================
Dim RsCheck
Set RsCheck = Server.CreateObject("ADODB.Recordset")

RsCheck.Open _
"SELECT list_title_id FROM bom3_list_title " & _
"WHERE list_title_id=" & list_title_id & _
" AND is_active=1", Dbcon

If RsCheck.EOF Then
    Response.Write "TITLE_NOT_FOUND"
    Response.End
End If

RsCheck.Close
Set RsCheck = Nothing

' ===============================
' 중복 체크
' ===============================
Set RsCheck = Server.CreateObject("ADODB.Recordset")

RsCheck.Open _
"SELECT title_sub_id FROM bom3_list_title_sub " & _
"WHERE list_title_id=" & list_title_id & _
" AND sub_name='" & sub_name & "'" & _
" AND is_active=1", Dbcon

If Not RsCheck.EOF Then
    Response.Write "DUPLICATE"
    Response.End
End If

RsCheck.Close
Set RsCheck = Nothing

' ===============================
' INSERT
' ===============================
Dbcon.Execute _
"INSERT INTO bom3_list_title_sub (" & _
" list_title_id, sub_name, is_active, wdate" & _
") VALUES (" & _
list_title_id & ", '" & sub_name & "', 1, GETDATE()" & _
")"

' ===============================
' 완료 → 팝업으로 돌아감
' ===============================
Response.Redirect "bom3_title_sub_manage.asp?list_title_id=" & list_title_id

call DbClose()
%>