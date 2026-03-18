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
hingecode=encodestr(Request("hingecode"))
hingeshorten=encodestr(Request("hingeshorten"))
hingename=Request("hingename")
hingecenter=encodestr(Request("hingecenter"))
hingePi=Request("hingePi")
hingeprice=Request("hingeprice")
hingestatus=Request("hingestatus")
qtype=Request("qtype")


Response.write hingecode&"<br>"
Response.write hingeshorten&"<br>"
Response.write hingename&"<br>"
Response.write hingecenter&"<br>"
Response.write hingePi&"<br>"
Response.write hingeprice&"<br>"
Response.write hingestatus&"<br>"
Response.write qtype&"<br>"




'Response.end

SQL="Insert into tk_hinge ( hingecode, hingeshorten, hingename,hingecenter,hingePi, hingeprice,hingestatus, hingemidx, hingewdate ,hingeemidx, hingeewdate,qtype,atype) "
SQL=SQL&" Values (  '"&hingecode&"', '"&hingeshorten&"', '"&hingename&"', '"&hingecenter&"', '"&hingePi&"', '"&hingeprice&"', 1 "
SQL=SQL&" ,'"&hingemidx&"', getdate(), '"&hingeemidx&"', getdate(), '"&qtype&"', '"&atype&"'  ) "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)

response.write "<script>alert('입력이 완료되었습니다.');location.replace('hinge_item.asp');</script>"

%>


<%
set Rs=Nothing
call dbClose()
%>