
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
Set Rs1 = Server.CreateObject("ADODB.Recordset")


rmidx=encodestr(Request("midx"))
rmname=encodestr(Request("mname"))
rmpos=encodestr(Request("mpos"))
rmtel=encodestr(Request("mtel"))
rmhp=encodestr(Request("mhp"))
rmfax=encodestr(Request("mfax"))
rmemail=encodestr(Request("memail"))
rmwdate=encodestr(Request("mwdate"))
rcidx=encodestr(Request("cidx"))
rmpw=encodestr(Request("mpw"))
rmkakao=encodestr(Request("mkakao"))
rumidx=encodestr(Request("umidx"))
rudate=encodestr(Request("udate"))
rorderring=encodestr(Request("orderring"))

rmwdate=left(rmwdate,10)&" "&FormatDateTime(rmwdate,4)
rudate=left(rudate,10)&" "&FormatDateTime(rudate,4)

if rcidx="1" then rcidx="2" end if 

SQL="select cidx from tk_customer  where pcidx='"&rcidx&"' "
    Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  ncidx=Rs(0)
  if rmhp<>"010-9690-8322" and rmhp<>"010-2727-9398" and rmhp<>"010-6646-8322" and rmhp<>"010-2028-8626" and rmhp<>"010-2788-5694" and rmhp<>"010-7743-2696" and rmhp<>"010-5662-7980" and rmhp<>"010-9017-5731" and rmhp<>"010-4332-2411"  then 

    SQL="Insert into tk_member (pmidx, mname, mpos, mtel, mhp, mfax, memail, mwdate, cidx, mpw, mkakao,umidx, udate,  orderring) "
    SQL=SQL&" values ("&rmidx&",'"&rmname&"', '"&rmpos&"', '"&rmtel&"', '"&rmhp&"', '"&rmfax&"', '"&rmemail&"', '"&rmwdate&"', '"&ncidx&"', '"&rmpw&"', '"&rmkakao&"', '"&rumidx&"', '"&rudate&"', '"&rorderring&"')"
    Response.write (SQL)&"<br>"
    'Dbcon.Execute (SQL) 
  else
    SQL="UPdate tk_member set pmidx='"&rmidx&"', cidx='"&ncidx&"' where mhp='"&rmhp&"' "
    Response.write (SQL)&"<br>"
    'Dbcon.Execute (SQL) 
  End if 
end if
Rs.Close

set Rs=Nothing
set Rs1=Nothing
call dbClose()

response.write "<script>window.close();</script>"
%>
