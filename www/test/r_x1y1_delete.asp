<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

id = Request("id")
id_1 = Request("id_1")

' 입력값 검증
If id = "" OR id_1 = "" Then
    Response.Write "<script>alert('잘못된 요청입니다.');history.back();</script>"
    Response.End
End If

' 데이터 삭제
sql = "DELETE FROM TNG_SJst2_rect WHERE id = '" & id & "' AND id_1 = " & id_1
Dbcon.Execute sql

response.write "<script>location.replace('r_x1y1.asp?id=" & id & "');</script>"
call dbClose()
%>
