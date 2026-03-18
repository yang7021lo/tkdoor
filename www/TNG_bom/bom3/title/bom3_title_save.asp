<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->

<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

Dim master_id, title_name, is_sub, is_common, type_id, density
Dim sql, RsID, new_title_id
Dim masterSql, typeSql

master_id  = Trim(Request("master_id"))
title_name = Trim(Request("title_name"))
is_sub     = Trim(Request("is_sub"))
is_common  = Trim(Request("is_common"))
type_id    = Trim(Request("type_id"))
density    = Trim(Request("density"))

If is_sub <> "1" Then is_sub = 0 Else is_sub = 1
If is_common <> "1" Then is_common = 0 Else is_common = 1

' 1) title은 항상 필수
If title_name = "" Then
    Response.Write "INVALID_TITLE"
    Response.End
End If

' 2) master: 둘 다 0일 때만 필수
If is_sub = 0 And is_common = 0 Then
    If (master_id = "") Or (Not IsNumeric(master_id)) Then
        Response.Write "INVALID_MASTER"
        Response.End
    End If
    masterSql = CStr(CLng(master_id))
Else
    masterSql = "NULL"
End If

' 3) type: SUB가 아닐 때만 필수 (공통 포함)
If is_sub = 0 Then
    If (type_id = "") Or (Not IsNumeric(type_id)) Then
        Response.Write "INVALID_TYPE"
        Response.End
    End If
    typeSql = CStr(CLng(type_id))
Else
    typeSql = "NULL"
End If

If density = "" Then density = ""

' ===============================
' INSERT
' ===============================
sql = _
"INSERT INTO bom3_list_title (master_id, title_name, is_sub, is_common, type_id, density) VALUES (" & _
"  " & masterSql & ", " & _
"  N'" & Replace(title_name,"'","''") & "', " & _
"  " & is_sub & ", " & _
"  " & is_common & ", " & _
"  " & typeSql & ", " & _
"  N'" & Replace(density,"'","''") & "'" & _
")"

On Error Resume Next
Dbcon.Execute sql

If Err.Number <> 0 Then
    Response.Write "DB_ERROR"
    Err.Clear
    Response.End
End If
On Error GoTo 0

Set RsID = Server.CreateObject("ADODB.Recordset")
RsID.Open "SELECT CAST(SCOPE_IDENTITY() AS INT) AS new_id", Dbcon

If RsID.EOF Then
    Response.Write "ID_FETCH_ERROR"
    Response.End
End If

new_title_id = CLng(RsID("new_id"))
RsID.Close
Set RsID = Nothing

If is_sub = 1 Then
    Response.Write "OK_SUB"
Else
    Response.Write "OK"
End If

call DbClose()
%>
