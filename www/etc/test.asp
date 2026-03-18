
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

SQL="select  kyidx, kycode, kyshorten, kyname, kystatus, kymidx from tk_key1 order by kyidx asc"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
    kyidx=Rs(0)
    kycode=Rs(1)
    kyshorten=Rs(2)
    kyname=Rs(3)
    kystatus=Rs(4)
    kymidx=Rs(5)


    SQL=" insert into tk_key (kycode, kyshorten, kyname, kystatus, kymidx) "
    SQL=SQL&" values ('"&kycode&"', '"&kyshorten&"', '"&kyname&"', '"&kystatus&"', '"&kymidx&"') "
    'Response.write (SQL)&"<br>"
    'DbCon.Execute (SQL)



Rs.movenext
Loop
End if
Rs.close
set Rs=Nothing
call dbClose()
%>
