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

ridx=request("ridx")
rsidx=request("rsidx")
clickacfidx=Request("clickacfidx")
clickaacfidx=Request("clickaacfidx")

'Response.write ridx&"<br>"
'Response.write rsidx&"<br>"
'Response.end

SQL=" Delete From tk_reportsub Where rsidx='"&rsidx&"' "

'Response.write (SQL)&"<br>"
'Response.end
Dbcon.Execute (SQL)

Response.Write "<script>opener.location.replace('remain2.asp?ridx="&ridx&"&clickacfidx="&clickacfidx&"&clickaacfidx="&clickaacfidx&"');window.close();</script>"

set Rs=Nothing
call dbClose()
%>

