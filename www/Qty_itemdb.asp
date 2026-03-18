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


QTYIDX=Request("QTYIDX")
QTYCODE=Request("QTYCODE")
QTYNAME=Request("QTYNAME")
QTYSTATUS=Request("QTYSTATUS")
QTYPAINT=Request("QTYPAINT")
QTYmidx=Request("QTYmidx")
qtyprice=Request("qtyprice")

response.write "QTYIDX : "&QTYIDX&"<br>"
response.write "QTYCODE : "&QTYCODE&"<br>"
response.write "QTYNAME : "&QTYNAME&"<br>"
response.write "QTYSTATUS : "&QTYSTATUS&"<br>"
response.write "QTYPAINT : "&QTYPAINT&"<br>"
response.write "QTYmidx : "&QTYmidx&"<br>"
response.write "qtyprice : "&qtyprice&"<br>"

SQL="update tk_qty set QTYCODE='"&QTYCODE&"', QTYNAME='"&QTYNAME&"', QTYSTATUS='"&QTYSTATUS&"', QTYPAINT='"&QTYPAINT&"', QTYmidx='"&QTYmidx&"', qtyprice='"&qtyprice&"' where QTYIDX='"&QTYIDX&"' "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)

response.write "<script>location.replace('Qty_item.asp?rQTYIDX="&QTYIDX&"');</script>"

set Rs=Nothing
call dbClose()
%>
