




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

kcidx=Request("kcidx")
kmidx=Request("kmidx")

SQL="Insert into tk_korder (kcidx, kmidx, kwdate, midx, kstatus) "
SQL=SQL&" Values ('"&kcidx&"','"&kmidx&"',getdate(),'"&c_midx&"',0) "
response.write (SQL)&"<br>"
dbCon.execute (SQL)

SQL="select max(kidx) from tk_korder "
Rs.open sql,Dbcon
    kidx=Rs(0)
Rs.close

 
response.write "<script>alert;location.replace('korder.asp?kidx="&kidx&"');</script>"

set Rs=Nothing
call dbClose()
%>
