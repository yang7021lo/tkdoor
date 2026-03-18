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
function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function 
    
snidx=Request("snidx")
amemail=encodestr(Request("amemail"))
sendadd=encodestr(Request("sendadd"))
mtitle=encodestr(Request("mtitle"))
mmaintext=encodestr(Request("mmaintext"))

    if mmaintext<>"" then mmaintext=replace(mmaintext,chr(13) & chr(10),"<br>") 

response.write snidx&"<br>"
response.write amemail&"<br>"
response.write sendadd&"<br>"
response.write mtitle&"<br>"
response.write mmaintext&"<br>"

ecount = 1

'response.end

call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

SQL=" Select C.rfile from tk_reportsend A "
SQL=SQL&" Join tk_reportsendsub B On B.snidx=A.snidx "
SQL=SQL&" Join tk_report C On C.ridx=B.ridx "
SQL=SQL&"Where A.snidx='"&snidx&"' "
Rs.open Sql,Dbcon,1,1,1

if not (Rs.EOF or Rs.BOF ) then
i=1
for j=i to Rs.RecordCount

rfile=Rs(0)

report= rfile&report

i=i+1
Rs.MoveNext
Next
End If
Rs.close

SQL=" Select C.rgfile from tk_reportsend A "
SQL=SQL&" Join tk_reportsendgsub B On B.snidx=A.snidx "
SQL=SQL&" Join tk_reportg C On C.rgidx=B.rgidx "
SQL=SQL&"Where A.snidx='"&snidx&"'"
Rs.open Sql,Dbcon,1,1,1

if not (Rs.EOF or Rs.BOF ) then
k=1
for l=k to Rs.RecordCount

rgfile=Rs(0)

reportg= rgfile&reportg

k=k+1
Rs.MoveNext
Next
End If
Rs.close

SQL=" Select efname from tk_emailatfile Where snidx='"&snidx&"'"
Rs.open Sql,Dbcon,1,1,1

if not (Rs.EOF or Rs.BOF ) then
k=1
for l=k to Rs.RecordCount

efname=Rs(0)

filename= efname&filename

k=k+1
Rs.MoveNext
Next
End If
Rs.close

SQL=" Update tk_reportsend set mtitle='"&mtitle&"',  mmaintext='"&mmaintext&"', sncemail1='"&amemail&"', snmemail='"&sendadd&"', filename='"&filename&"', report='"&report&"', reportg='"&reportg&"', snsendstatus='0' "
SQL=SQL&" Where snidx='"&snidx&"' "
Dbcon.Execute (SQL)

set Rs=Nothing
call dbClose()

%>
