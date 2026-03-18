<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
Response.ContentType = "application/json"

Function JsonSafe(val)
    Dim s
    s = val & ""
    s = Replace(s, "\", "\\")
    s = Replace(s, """", "\""")
    s = Replace(s, vbCrLf, "\n")
    s = Replace(s, vbCr, "\n")
    s = Replace(s, vbLf, "\n")
    s = Replace(s, vbTab, "\t")
    s = Replace(s, Chr(8), "")
    s = Replace(s, Chr(12), "")
    JsonSafe = s
End Function
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

bfidx = Request("bfidx")

If bfidx = "" Then
    Response.Write "{""error"": ""bfidx is required""}"
    Response.End
End If

SQL = "SELECT set_name_FIX, set_name_AUTO, xsize, ysize, bfimg1, bfimg2, bfimg3, sjb_idx "
SQL = SQL & "FROM tk_barasiF WHERE bfidx = '" & bfidx & "'"

Rs.Open SQL, Dbcon, 1, 1

If Rs.EOF Then
    Response.Write "{""error"": ""bfidx not found""}"
    Rs.Close
    call dbClose()
    Response.End
End If

Dim pummokName
If Rs("set_name_FIX") <> "" Then
    pummokName = Rs("set_name_FIX")
ElseIf Rs("set_name_AUTO") <> "" Then
    pummokName = Rs("set_name_AUTO")
Else
    pummokName = ""
End If

Dim mainImage
mainImage = ""
If Rs("bfimg1") <> "" Then
    mainImage = Rs("bfimg1")
ElseIf Rs("bfimg2") <> "" Then
    mainImage = Rs("bfimg2")
ElseIf Rs("bfimg3") <> "" Then
    mainImage = Rs("bfimg3")
End If

Dim gyugyuk
gyugyuk = Rs("xsize") & " X " & Rs("ysize")

Dim sjb_idx_val
sjb_idx_val = Rs("sjb_idx")

Rs.Close

Response.Write "{"
Response.Write """bfidx"": " & bfidx & ", "
Response.Write """pummok"": """ & JsonSafe(pummokName) & """, "
Response.Write """gyugyuk"": """ & JsonSafe(gyugyuk) & """, "
Response.Write """image"": """ & JsonSafe(mainImage) & """, "
Response.Write """sjb_idx"": """ & JsonSafe(sjb_idx_val) & """"
Response.Write "}"

Set Rs = Nothing
call dbClose()
%>
