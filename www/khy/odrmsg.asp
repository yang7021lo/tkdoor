
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

kidx=Request("kidx")

SQL=" Select A.kidx, A.kcidx, B.cname, A.kmidx, C.mname, A.midx, D.mname, Convert(varchar(10),A.kwdate,121), Convert(varchar(10),A.kidate,121), Convert(varchar(10),A.krdate,121), A.kstatus, C.mhp "
SQL=SQL&" From tk_korder A "
SQL=SQL&" Join tk_customer B On A.kcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.kmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Where A.kidx='"&kidx&"' "
'response.write (SQL)
Rs.open Sql,dbcon
if not (Rs.EOF or Rs.BOF ) then
    kidx=Rs(0)
    kcidx=Rs(1)
    cname=Rs(2)
    kmidx=Rs(3)
    fmname=Rs(4)
    midx=Rs(5)
    smname=Rs(6)
    kwdate=Rs(7)
    kidate=Rs(8)
    krdate=Rs(9)
    kstatus=Rs(10)
    fmhp=Rs(11)

select case kstatus
    case "0"
        kstatus_text="발주중"
    case "1"
        kstatus_text="납품처확인"
    case "2"
        kstatus_text="입고완료"
end select
end if
Rs.close



'============
'알림톡 보내기 시작

'fmhp="010-6299-5190"
telno=replace(fmhp,"-","") 
telno="82"&Right(telno,10)

atid="tkdoor1"
atdeptcode="N6-3Q0-TV"
sch="04650d631a8daf41c3b4667282ff7b340acbc27a"
template_code="odr002"
message_id=ymdhns


message=""&kwdate&" 자재 주문 요청드립니다.\n주문내역을 아래 버튼을 눌러 확인해 주세요.\n담당자 : "&smname&"드림"



Private Sub Command2_Click()
    jsonData = " {""usercode"":"""&atid&""",""deptcode"":"""&atdeptcode&""", "
    jsonData = jsonData & " ""yellowid_key"":"""&sch&""", "
    jsonData = jsonData & " ""messages"":[ "
    jsonData = jsonData & " {""type"":""at"",""message_id"":"""&message_id&""", "
    jsonData = jsonData & " ""to"" :"""&telno&""", "
    jsonData = jsonData & " ""template_code"" :"""&template_code&""", "  
    jsonData = jsonData & " ""text"":"""&message&""","
    jsonData = jsonData & " ""button_set"":{"
    jsonData = jsonData & " ""button_type"":""WL"","
    jsonData = jsonData & " ""button_name"":""내역보기"","
    jsonData = jsonData & " ""button_url"":""https://tkdoor.co.kr/khy/odrlist.asp?kidx="&kidx&"""}}"  
    jsonData = jsonData & " ]} "
   url = "https://api.surem.com/alimtalk/v1/json"
    Dim objXMLHttp
    Set objXMLHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    objXMLHttp.Open "POST", url, False
    objXMLHttp.SetRequestHeader "Content-Type", "application/json"
    objXMLHttp.Send jsonData
    retJSON = CStr(objXMLHttp.ResponseText)
    Set objXMLHttp = Nothing

'Response.write jsonData&"<br><br>"
End Sub

 
Call Command2_Click()  

'알림톡 보내기 끝
'============
Response.Write "<script>alert('발주서가 전송되었습니다.'); location.replace('korderlist.asp?kidx="&kidx&"');</script>"



set Rs=Nothing
call dbClose()
%>
