
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

rcidx=encodestr(Request("cidx"))
rcname=encodestr(Request("cname"))
rcaddr1=encodestr(Request("caddr1"))
rcaddr2=encodestr(Request("caddr2"))
rcpost=encodestr(Request("cpost"))
rcmidx=encodestr(Request("cmidx"))
rcdidx=encodestr(Request("cdidx"))
rcwdate=encodestr(Request("cwdate"))
rcnumber=encodestr(Request("cnumber"))
rcnick=encodestr(Request("cnick"))
rctkidx=encodestr(Request("ctkidx"))
rcstatus=encodestr(Request("cstatus"))
rcbuy=encodestr(Request("cbuy"))
rcsales=encodestr(Request("csales"))
rcceo=encodestr(Request("cceo"))
rctype=encodestr(Request("ctype"))
rcitem=encodestr(Request("citem"))
rcemail1=encodestr(Request("cemail1"))
rcgubun=encodestr(Request("cgubun"))
rcmove=encodestr(Request("cmove"))
rcbran=encodestr(Request("cbran"))
rcdlevel=encodestr(Request("cdlevel"))
rcflevel=encodestr(Request("cflevel"))
rcalevel=encodestr(Request("calevel"))
rcslevel=encodestr(Request("cslevel"))
rcsylevel=encodestr(Request("csylevel"))
rcmemo=encodestr(Request("cmemo"))
rcfile=encodestr(Request("cfile"))
rctel=encodestr(Request("ctel"))
rcfax=encodestr(Request("cfax"))
rctel2=encodestr(Request("ctel2"))



rcwdate=left(rcwdate,10)&" "&FormatDateTime(rcwdate,4)

  SQL="Select * From tk_customer where cnumber='"&rcnumber&"' "
  Rs.open SQL,Dbcon
  if (Rs.EOF or Rs.BOF ) then

  SQL="Insert into tk_customer (pcidx, cname, caddr1, caddr2, cpost, cmidx, cdidx, cwdate, cnumber, cnick, ctkidx, cstatus, cbuy, csales, cceo, ctype, citem, cemail1 , cgubun, cmove, cbran, cdlevel, cflevel, calevel, cslevel, csylevel, cmemo, cfile, ctel, cfax, ctel2) "
  SQL=SQL&" values ("&rcidx&",'"&rcname&"', '"&rcaddr1&"', '"&rcaddr2&"', '"&rcpost&"', '"&rcmidx&"', '"&rcdidx&"', '"&rcwdate&"', '"&rcnumber&"', '"&rcnick&"', '"&rctkidx&"', '"&rcstatus&"', '"&rcbuy&"', '"&rcsales&"', '"&rcceo&"', '"&rctype&"', '"&rcitem&"', '"&rcemail1&"', '"&rcgubun&"', '"&rcmove&"', '"&rcbran&"', '"&rcdlevel&"', '"&rcflevel&"', '"&rcalevel&"', '"&rcslevel&"', '"&rcsylevel&"', '"&rcmemo&"', '"&rcfile&"', '"&rctel&"', '"&rcfax&"', '"&rctel2&"')"
  Response.write (SQL)&"<br>"
  'Dbcon.Execute (SQL) 
  else
  SQL=" Update tk_customer set pcidx="&rcidx&" Where cnumber='"&rcnumber&"' "
  Response.write (SQL)&"<br>"
  'Dbcon.Execute (SQL) 
  End if
  Rs.Close
set Rs=Nothing
set Rs1=Nothing
call dbClose()

response.write "<script>window.close();</script>"
%>
