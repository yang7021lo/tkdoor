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
order_dept = encodestr(Request("order_dept"))
order_name = encodestr(Request("order_name"))
order_length = encodestr(Request("order_length"))
order_type = encodestr(Request("order_type"))
kg_m = encodestr(Request("kg_m"))



' SQL문 작성
SQL = "INSERT INTO tk_khyorder (order_name, order_length, order_type, order_date, kg_m, order_status, order_dept) " & _
      " VALUES ('" & order_name & "', '" & order_length & "', '" & order_type & "', getdate(), " & kg_m & ", '1', '" & order_dept & "')"

' SQL 확인용 출력 (주석 해제하면 실행 전에 SQL 확인 가능)
' Response.Write SQL & "<br>"

Dbcon.Execute SQL

Response.Write "<script>alert('자재 등록이 완료 되었습니다.'); location.replace('/khy/khorder.asp');</script>"

set Rs = Nothing
call dbClose()
%>
