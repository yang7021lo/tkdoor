
<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

rgidx=Request("rgidx")
ridx=Request("ridx")
SearchWord=Request("SearchWord")

SQL="insert into tk_reportgSub (rgidx, ridx, rgsmidx, rgsdate)  "
SQL=SQL&" Values ('"&rgidx&"', '"&ridx&"', '"&C_midx&"', getdate()) "
Dbcon.Execute (SQL)


response.write "<script>opener.location.replace('remaingroup.asp');location.replace('remaingropview.asp?rgidx="&rgidx&"&SearchWord="&SearchWord&"');</script>"


set Rs=Nothing
call dbClose()
%>
