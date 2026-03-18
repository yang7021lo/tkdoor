<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
If c_midx = "" Then
    Response.Write "{""ok"":false,""msg"":""login""}"
    Response.End
End If

call dbOpen()

Dim sjidx, rs, cgaddr, cname
sjidx = Trim(Request("sjidx") & "")

If sjidx = "" Or Not IsNumeric(sjidx) Then
    Response.Write "{""ok"":false,""msg"":""invalid sjidx""}"
    call dbClose()
    Response.End
End If

cgaddr = ""
cname = ""

Set rs = DbCon.Execute( _
    "SELECT ISNULL(s.cgaddr,'') AS cgaddr, ISNULL(c.cname,'') AS cname " & _
    "FROM tng_sja s LEFT JOIN tk_customer c ON c.cidx = s.sjcidx " & _
    "WHERE s.sjidx = " & CLng(sjidx))

If Not rs.EOF Then
    cgaddr = rs("cgaddr") & ""
    cname = rs("cname") & ""
End If
rs.Close
Set rs = Nothing

Response.Write "{""ok"":true,""cgaddr"":""" & Replace(cgaddr, """", "\""") & """,""cname"":""" & Replace(cname, """", "\""") & """}"

call dbClose()
%>
