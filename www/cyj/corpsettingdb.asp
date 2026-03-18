<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")


cidx=request("cidx")
c_midx=request("C_midx")

cgubun=encodestr(request("cgubun"))

cdlevel=encodestr(request("cdlevel"))
cflevel=encodestr(request("cflevel"))
calevel=encodestr(request("calevel"))
cslevel=encodestr(request("cslevel"))
csylevel=encodestr(request("csylevel"))
gotopage=request("gotopage")











    SQL=" Update tk_customer set cgubun='"&cgubun&"', cdlevel='"&cdlevel&"', cflevel='"&cflevel&"', calevel='"&calevel&"' "
    SQL=SQL&" , cslevel='"&cslevel&"', csylevel='"&csylevel&"', cudtidx='"&C_midx&"', cudtdate=getdate() "
    SQL=SQL&" Where cidx='"&cidx&"' "


Response.write (SQL)&"<br>"
'Response.end
Dbcon.Execute (SQL) 


Response.write "<script>location.replace('corpsetting.asp?gotopage="&gotopage&"');</script>"

set Rs=Nothing
call dbClose()
%> 