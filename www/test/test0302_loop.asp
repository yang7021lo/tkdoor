<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()  
Set Rs = Server.CreateObject("ADODB.Recordset")

SQL=" select greem_idx, GREEM_O_TYPE From TNG_GREEM where greem_idx<='216' Order by greem_idx asc "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF

  greem_idx=Rs(0)
  GREEM_O_TYPE=Rs(1)

i=i+1
j = i mod 7
if j = 0 then 
  i = 1
end if

'response.write i&"<br>"

SQL=" Update  TNG_GREEM set GREEM_O_TYPE='"&i&"' Where greem_idx='"&greem_idx&"' "
Dbcon.Execute sql
Response.write (SQL)&"<br>"

Rs.movenext
Loop
End if
Rs.close






call dbClose()
%>
