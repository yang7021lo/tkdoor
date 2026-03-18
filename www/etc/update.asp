
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

SQL="select  QTYIDX, qtype from tk_qty order by QTYIDX asc"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
QTYIDX=Rs(0)
qtype=Rs(1)


'if QTYPAINT="오은숙" then 
    'QTYPAINT=1
'else if QTYPAINT="이양희" then
    'QTYPAINT=2
'else
    'QTYPAINT=3
'end if

'Response.write "<tr>"
'Response.write "<td>" & qtype & "</td>"    

SQL="Update tk_qty set qtype=' 1 ' Where QTYIDX='"&QTYIDX&"' "

    'SQL=" insert into tk_qty (qtype) "
    'SQL=SQL&" values ( '1') "
     Response.write "<td>" & qtype & "</td>"        
    'Response.write (SQL)&"<br>"
    'DbCon.Execute (SQL)


Rs.movenext
Loop
End if
Rs.close
set Rs=Nothing
call dbClose()
%>
