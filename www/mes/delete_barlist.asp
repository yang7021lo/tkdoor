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
smidxList = Request("deleteIds")
baridx = Request("baridx")

If  rsidx <> "" And rgoidx <> "" And baridx <> "" Then
    SQL = "DELETE FROM tk_stand WHERE  rgoidx='"&rgoidx&"' AND rsidx='"&rsidx&"' AND baridx='"&baridx&"' " 
    Dbcon.Execute(SQL)
End If


' 삭제 완료 후 리다이렉트
response.write "<script>alert('삭제가 완료되었습니다.');location.replace('pummok_door.asp?rgoidx="&rgoidx&"');</script>"
'Response.Write "<script>alert('삭제가 완료되었습니다.');"
'Response.Write "location.href='pummok_door.asp?rgoidx=" & rgoidx & "&rsidx=" & rsidx & "';</script>"

' DB 닫기
set Rs=Nothing
call dbClose()
%>
