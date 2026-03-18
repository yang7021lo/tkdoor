<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
    call dbOpen()
    Set Rs = Server.CreateObject ("ADODB.Recordset")

ridx=Request("ridx")
ftype=encodestr(Request("ftype"))
fname=request("rrfname")
clickacfidx=Request("clickacfidx")
clickaacfidx=Request("clickaacfidx")

'Response.write ftype&"<br>"
'Response.write fname&"<br>"
'Response.end

SQL=" Insert into tk_reportm (fname, ftype, fstatus, fmidx, fdate) "
SQL=SQL&" Values ('"&fname&"', '"&ftype&"', '1', '"&c_midx&"', getdate()) "

'Response.write (SQL)&"<br>"
'Response.end
Dbcon.Execute (SQL)

Response.Write "<script>location.replace('shr.asp?ridx="&ridx&"&ftype="&ftype&"&clickacfidx="&clickacfidx&"&clickaacfidx="&clickaacfidx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>

