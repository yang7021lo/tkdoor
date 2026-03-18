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

kidx=Request("kidx")
order_idx=Request("order_idx")

SQL="Insert into tk_korderSub (kidx, odrdate, odrstatus, midx, odridx) "
SQL=SQL&"Values ('"&kidx&"',getdate(),'1','"&C_midx&"','"&order_idx&"') "
'response.write (SQL)&"<br>"
'Response.end
dbCon.execute (SQL)

 


response.write "<script>location.replace('korder.asp?kidx="&kidx&"');</script>"

set Rs=Nothing
call dbClose()
%>
