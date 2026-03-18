<%@ codepage="65001" language="vbscript"%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
Response.ContentType = "application/json"
call DbOpen()

Dim rs, arr
Set rs = Dbcon.Execute("SELECT origin_type_no, origin_name FROM bom2_origin_type")

Response.Write "["
Do While Not rs.EOF
  Response.Write "{""id"":" & rs("origin_type_no") & _
                 ",""name"":""" & Replace(rs("origin_name"),"""","\""") & """}"
  rs.MoveNext
  If Not rs.EOF Then Response.Write ","
Loop
Response.Write "]"

rs.Close
Set rs = Nothing
call DbClose()
%>
