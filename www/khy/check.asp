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
 
SQL="update tk_korder set krdate=getdate(), kstatus=2, rmidx='"&C_midx&"' Where kidx='"&kidx&"' "
'Response.write (SQL)&"<br><br>"
Dbcon.Execute (SQL)


response.write "<script>location.replace('korderlist.asp?kidx="&kidx&"');</script>"

set Rs=Nothing
call dbClose()
%>
