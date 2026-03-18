<%@ Language="VBScript" CodePage="65001" %>
<%
Response.Charset="utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
Call dbOpen()

Function Nz(v)
    If IsNull(v) Then Nz = "" Else Nz = Trim(CStr(v))
End Function
Function JsonEsc(s)
    s = Nz(s)
    s = Replace(s, "\", "\\")
    s = Replace(s, """", "\""")
    s = Replace(s, vbCrLf, "\n")
    s = Replace(s, vbCr, "\n")
    s = Replace(s, vbLf, "\n")
    JsonEsc = s
End Function

Dim wms_idx
wms_idx = CLng(0 & Request("wms_idx"))

Dim Rs, SQL
Set Rs = Server.CreateObject("ADODB.Recordset")

SQL = ""
SQL = SQL & "SELECT cargo_rect, frame_name "
SQL = SQL & "FROM tk_wms_cargo "
SQL = SQL & "WHERE wms_idx = " & wms_idx & " "
SQL = SQL & "ORDER BY cargo_idx"

Rs.Open SQL, DbCon

Response.Write "["
Do Until Rs.EOF
    Response.Write "{""frame_name"":""" & JsonEsc(Rs("frame_name")) & """,""cargo_rect"":""" & JsonEsc(Rs("cargo_rect")) & """}"
    Rs.MoveNext
    If Not Rs.EOF Then Response.Write ","
Loop
Response.Write "]"

Rs.Close
Set Rs = Nothing
%>
