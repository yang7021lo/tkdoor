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

cidx="1"
mname=encodestr(Request("mname"))
mhp=request("mhp")

Randomize
scode=Int(Rnd() * 9999) + 1
 
if Len(scode)="1" then
    scode="000"&scode
elseif Len(scode)="2" then
    scode="00"&scode
elseif Len(scode)="3" then
    scode="0"&scode
end if



ascode=md5(scode)


response.write mname&"<br>"
response.write scode&"<br>"
response.write ascode&"<br>"
response.write mhp&"<br>"
'response.end

SQL="Insert into tk_member (mname, mhp, mwdate, cidx, mpw, mkakao) "
SQL=SQL&" values ('"&mname&"','"&mhp&"',getdate(),'"&cidx&"', '"&ascode&"', '0')"
'Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)
'response.end

SQL="Select midx From tk_member Where mhp='"&mhp&"' "
rs.open sql,dbcon,1,1,1
    midx=rs(0)
rs.close

'============
'알림톡 보내기 시작

telno=replace(mhp,"-","") 
telno="82"&Right(telno,10)

atid="tkdoor1"
atdeptcode="N6-3Q0-TV"
sch="04650d631a8daf41c3b4667282ff7b340acbc27a"
template_code="visit_001"
message_id=ymdhns



message=""&mname&"님의 인증코드는 "&scode&"입니다."
 

Private Sub Command2_Click()
    jsonData = " {""usercode"":"""&atid&""",""deptcode"":"""&atdeptcode&""", "
    jsonData = jsonData & " ""yellowid_key"":"""&sch&""", "
    jsonData = jsonData & " ""messages"":[ "
    jsonData = jsonData & " {""type"":""at"",""message_id"":"""&message_id&""", "
    jsonData = jsonData & " ""to"" :"""&telno&""", "
    jsonData = jsonData & " ""template_code"" :"""&template_code&""", "  
    jsonData = jsonData & " ""text"":"""&message&"""}"    
    jsonData = jsonData & " ]} "
   url = "https://api.surem.com/alimtalk/v1/json"
    Dim objXMLHttp
    Set objXMLHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    objXMLHttp.Open "POST", url, False
    objXMLHttp.SetRequestHeader "Content-Type", "application/json"
    objXMLHttp.Send jsonData
    retJSON = CStr(objXMLHttp.ResponseText)
    Set objXMLHttp = Nothing
'    MsgBox (retJSON)
 

End Sub


Call Command2_Click()  
'알림톡 보내기 끝
'============



Response.write "<script>alert('카카오톡으로 전송된 인증번호를 입력해 주세요."&scode&"');location.replace('mkakao.asp?midx="&midx&"');</script>"

 %>
 
 
 <%
  set Rs=Nothing
  call dbClose()
  %>