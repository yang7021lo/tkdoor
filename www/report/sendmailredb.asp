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

snidx=Request("snidx")

'response.write snidx
'response.end


SQL=" Select mtitle, mmaintext from tk_reportsend Where snidx='"&snidx&"' "
Rs.open Sql,Dbcon
    mtitle=Rs(0)
    mmaintext=Rs(1)
Rs.Close

SQL=" Insert into tk_reportsend (mtitle, mmaintext, snmidx, snsendstatus) Values ('"&mtitle&"', '"&mmaintext&"', '"&c_midx&"', '1')"
Dbcon.Execute (SQL)

SQL=" Select Max(snidx) from tk_reportsend "
Rs.open Sql,Dbcon
    ssnidx=Rs(0)
Rs.Close


SQL=" Select A.cname, B.cidx, B.snsidx "
SQL=SQL&" From tk_customer A "
SQL=SQL&" Join tk_reportsendcorpSub B on B.cidx=A.cidx where snidx='"&snidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 

Do while not Rs.EOF
cname=Rs(0)
cidx=Rs(1)
snsidx=Rs(2)

SQL=" Insert into tk_reportsendcorpSub (cidx, snidx) Values ('"&cidx&"', '"&ssnidx&"')"
Dbcon.Execute (SQL)

Rs.movenext
Loop
End if
Rs.close


SQL=" SELECT A.cidx, A.memail from tk_emailselect A Where A.snidx='"&snidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 

Do while not Rs.EOF
ccidx=Rs(0)
memail=Rs(1)

SQL=" Insert into tk_emailselect (cidx, memail, snidx) Values ('"&ccidx&"', '"&memail&"', '"&ssnidx&"') "
Dbcon.Execute (SQL)

Rs.movenext
Loop
End if
Rs.close


SQL=" Select ridx From tk_reportsendsub where snidx='"&snidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 

Do while not Rs.EOF
ridx=Rs(0)

SQL=" Insert into tk_reportsendsub (ridx, snidx) Values ('"&ridx&"', '"&ssnidx&"') "
Dbcon.Execute (SQL)

Rs.movenext
Loop
End if
Rs.close


SQL=" Select rgidx From tk_reportsendgsub where snidx='"&snidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 

Do while not Rs.EOF
rgidx=Rs(0)

SQL=" Insert into tk_reportsendgsub (rgidx, snidx) Values ('"&rgidx&"', '"&ssnidx&"') "
Dbcon.Execute (SQL)

Rs.movenext
Loop
End if
Rs.close


SQL=" Select efname from tk_emailatfile Where snidx='"&snidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 

Do while not Rs.EOF
efname=Rs(0)

SQL=" Insert into tk_emailatfile (efname, snidx) Values ('"&efname&"', '"&ssnidx&"') "
Dbcon.Execute (SQL)

Rs.movenext
Loop
End if
Rs.close

response.write "<script>location.replace('sendmailre.asp?snidx="&ssnidx&"');</script>"

set Rs=Nothing
call dbClose()

%>


