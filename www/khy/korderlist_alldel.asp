<%@ codepage="65001" language="vbscript" %>
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


kidx=Request("kidx")

' 자재목록 삭제
SQL="delete from tk_kordersub where kidx='"&kidx&"' "
Dbcon.Execute(SQL)

'주문 목록 삭제
SQL="delete  from tk_korder where kidx='"&kidx&"' "
Dbcon.Execute(SQL)


' 삭제 후 알림 및 페이지 이동
Response.Write "<script>alert('모든 항목이 삭제되었습니다.'); location.replace('korderlistm.asp');</script>"

call dbClose()
%>