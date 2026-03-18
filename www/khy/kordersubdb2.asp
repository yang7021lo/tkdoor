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
ksidx=Request("ksidx")
odrkkg=Request("odrkkg")
odrea=Request("odrea")

if odrkkg<>"" then
    SQL="Update tk_korderSub set odrkkg='"&odrkkg&"' where ksidx='"&ksidx&"' "
    'response.write (SQL)&"<br>"
    'Response.end
    dbCon.execute (SQL)
end if
if odrea<>"" then
    SQL="Update tk_korderSub set odrea='"&odrea&"' where ksidx='"&ksidx&"' "
    'response.write (SQL)&"<br>"
    'Response.end
    dbCon.execute (SQL)
end if
 


response.write "<script>location.replace('korder.asp?kidx="&kidx&"');</script>"

set Rs=Nothing
call dbClose()
%>
