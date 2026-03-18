<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
%>
<% 

rcidx=Request("cidx")
sujudate=encodestr(Request("sujudate"))
sjnumber=encodestr(Request("sjnumber"))
sjaddress=encodestr(Request("sjaddress"))
sjchulgo=encodestr(Request("sjchulgo"))
sjchulgodate=encodestr(Request("sjchulgodate"))
sjqty=encodestr(Request("sjqty"))
sjtatus="0"


SQL="select max(sjaidx)+1 from tk_sujua "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
rsjaidx=Rs(0)
end if 
rs.close  

Response.write "sjaidx;"&rsjaidx&"<br>"
Response.write "cidx;"&rcidx&"<br>"
Response.write "sujudate;"&sujudate&"<br>"
Response.write "sjnumber;"&sjnumber&"<br>"
Response.write "sjaddress;"&sjaddress&"<br>"
Response.write "sjchulgo;"&sjchulgo&"<br>"
Response.write "sjchulgodate;"&sjchulgodate&"<br>"
Response.write "sjqty;"&sjqty&"<br>"

'response.end


SQL="Insert into tk_sujua ( sjaidx,cidx, sjaddress, sjnumber, sjtatus, sjqty, sujudate, sjchulgo, sjchulgodate, sjamidx, sjamdate, sjameidx, sjamedate ) "
SQL=SQL&" Values ( '"&rsjaidx&"','"&rcidx&"', '"&sjaddress&"', '"&sjnumber&"', '"&sjtatus&"', '"&sjqty&"','"&sujudate&"' "
SQL=SQL&" ,'"&sjchulgo&"','"&sjchulgodate&"','"&C_midx&"',getdate(),'"&C_midx&"',getdate() ) "
Response.write (SQL)&"<br>"
'response.end
Dbcon.Execute (SQL)

response.write "<script>location.replace('sujuin.asp?cidx="&rcidx&"&sjaidx="&rsjaidx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>