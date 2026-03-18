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
rftype=encodestr(Request("rftype"))
rfidx=request("rfidx")
clickacfidx=Request("clickacfidx")
clickaacfidx=Request("clickaacfidx")

'Response.write ridx&"<br>"
'Response.write rftype&"<br>"
'Response.write rfidx&"<br>"
'Response.end
SQL="Delete tk_reportsub Where ridx='"&ridx&"' and rftype='"&rftype&"' "
Dbcon.Execute (SQL)

SQL=" Insert into tk_reportsub (ridx, rftype, rfidx) "
SQL=SQL&" Values ('"&ridx&"', '"&rftype&"', '"&rfidx&"') "

'Response.write (SQL)&"<br>"
'Response.end
Dbcon.Execute (SQL)

Response.Write "<script>opener.location.replace('remain2.asp?ridx="&ridx&"&clickacfidx="&clickacfidx&"&clickaacfidx="&clickaacfidx&"');window.close();</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>

