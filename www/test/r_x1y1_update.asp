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
width = Request("width")
height = Request("height")
a_value = Request("a_value")
b_value = Request("b_value")

' 입력값 검증 (NULL 방지)
If id = "" OR id_1 = "" Then
    Response.Write "<script>alert('잘못된 요청입니다.');history.back();</script>"
    Response.End
End If

If width = "" OR IsNull(width) Then width = 100
If height = "" OR IsNull(height) Then height = 100
If a_value = "" OR IsNull(a_value) Then a_value = 50
If b_value = "" OR IsNull(b_value) Then b_value = 50

' 기존 데이터 업데이트
sql = "UPDATE TNG_SJst2_rect SET width = " & width & ", height = " & height & ", a_value = " & a_value & ", b_value = " & b_value & _
      " WHERE id = '" & id & "' AND id_1 = " & id_1
Dbcon.Execute sql

response.write "<script>location.replace('r_x1y1.asp?id=" & id & "');</script>"
call dbClose()
%>

