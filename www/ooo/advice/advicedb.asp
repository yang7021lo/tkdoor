
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
%>

<%


	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function 


acheorigubun = encodestr(Request("acheorigubun"))
aform = encodestr(Request("aform"))
agubun = encodestr(Request("agubun"))
aclaim = encodestr(Request("aclaim"))
aname = encodestr(Request("aname"))
acidx = encodestr(Request("acidx"))
adetails = encodestr(Request("adetails"))
acheoriname = encodestr(Request("acheoriname"))

acheorimemo = encodestr(Request("acheorimemo"))

if acheorigubun="1" and acheoriname="" then
    acheoriname=c_midx
end if

'Response.write acheorigubun&"<br>"
'Response.write aform&"<br>"
'Response.write agubun&"<br>"
'Response.write aclaim&"<br>"
'Response.write aname&"<br>"
'Response.write adate&"<br>"
'Response.write adetails&"<br>"
'Response.write acheoriname&"<br>"
'Response.write acheoridate&"<br>"
'Response.write acheorimemo&"<br>"
'Response.end


SQL="insert into Tk_advice (acidx, acheorigubun, aform, agubun, aclaim, aname, adate, adetails, acheoriname, acheoridate, acheorimemo )"
SQL=SQL& "Values ('"&acidx&"', '"&acheorigubun&"', '"&aform&"', '"&agubun&"', '"&aclaim&"', '"&c_midx&"', getdate(), '"&adetails&"', '"&acheoriname&"', getdate(), '"&acheorimemo&"')"
'Response.Write SQL
'Response.end
Dbcon.Execute(SQL)

response.write "<script>alert('저장되었습니다.');opener.location.replace('advicelist.asp?cidx="&acidx&"');window.close();</script>"



set Rs=Nothing
call dbClose()
%>
