<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
sjidx=Request("sjidx")
cidx=Request("cidx")
puidx=Request("puidx")
pfidx=Request("pfidx")

'response.write (sjidx)
'response.write (cidx)
'response.write (puidx)
'response.write (pfidx)
'response.end

call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

if puidx<>"undefined" then
  SQL="Update tk_picupload set pustatus='0' Where puidx='"&puidx&"' "
  DbCon.Execute(SQL)
end if

if pfidx<>"undefined" then
  SQL=" Update tk_picfiles set pfstatus='0' Where pfidx='"&pfidx&"' "
  DbCon.Execute(SQL)
end if

response.write "<script>location.replace('TNG1_B_datalist.asp?cidx="&cidx&"&sjidx="&sjidx&"');</script>"

set Rs=Nothing
call dbClose()

%>


