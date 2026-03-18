<%@ codepage="65001" language="vbscript" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
' DB 연결
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

' 요청값 가져오기
smidx = Request("smidx")
rgoidx = Request("rgoidx")
rsidx = Request("rsidx")

Response.write "smidx:"&smidx&"<br>"
Response.write "rgoidx:"&rgoidx&"<br>"
Response.write "rsidx:"&rsidx&"<br>"

' 삭제 SQL 실행
If  rsidx <> "" And rgoidx <> "" Then
    SQL = "DELETE FROM tk_material WHERE smidx='"&smidx&"' " 
    'response.write(SQL)&"<br>"
    Dbcon.Execute(SQL)
End If

' 삭제 완료 후 리다이렉트
response.write "<script>location.replace('pummok_door.asp?rgoidx="&rgoidx&"&rsidx="&rsidx&"');</script>"


' DB 닫기
set Rs=Nothing
call dbClose()
%>
