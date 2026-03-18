<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!-- DB 연결 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 

<%
' ========== 데이터베이스 연결 ==========
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

' 요청 값 받기
kidx = Request("kidx")

' ========== SQL 실행 (주문 정보 조회) ==========
SQL = " Select A.kidx, A.kcidx, B.cname, A.kmidx, C.mname, A.midx, D.mname, " 
SQL = SQL & " Convert(varchar(10),A.kwdate,121), Convert(varchar(10),A.kidate,121), Convert(varchar(10),A.krdate,121), A.kstatus, C.mhp "
SQL = SQL & " From tk_korder A "
SQL = SQL & " Join tk_customer B On A.kcidx=B.cidx "
SQL = SQL & " Join tk_member C On A.kmidx=C.midx "
SQL = SQL & " Join tk_member D On A.midx=D.midx "
SQL = SQL & " Where A.kidx='" & kidx & "' "

Rs.open SQL, dbcon
If Not (Rs.EOF Or Rs.BOF) Then
    kidx = Rs(0)
    kcidx = Rs(1)
    cname = Rs(2)
    kmidx = Rs(3)
    fmname = Rs(4)
    midx = Rs(5)
    smname = Rs(6)
    kwdate = Rs(7)
    kidate = Rs(8)
    krdate = Rs(9)
    kstatus = Rs(10)
    fmhp = Rs(11)

    ' 주문 상태 변환
    Select Case kstatus
        Case "0"
            kstatus_text = "발주중"
        Case "1"
            kstatus_text = "납품처확인"
        Case "2"
            kstatus_text = "입고완료"
    End Select
End If
Rs.Close

' ========== SMS 발송 준비 ==========
recipient_number = "+821062995190" ' 수신자 전화번호 (고정)
recipient_number = Replace(recipient_number, "-", "") ' 하이픈 제거

' Surem API 정보
usercode = "tkdoor1"
deptcode = "N6-3Q0-TV"
api_key = "04650d631a8daf41c3b4667282ff7b340acbc27a"
message_id = Year(Now) & Month(Now) & Day(Now) & Hour(Now) & Minute(Now) & Second(Now)

' 발신자 번호 설정
sender_number = "+821062995190" ' 등록된 발신 번호 입력

' SMS 내용 설정
sms_message = kwdate & " 자재 주문 요청드립니다.\n담당자 : " & smname & " 드림"

' ========== SMS 전송 ==========
Function SendSMS()
    Dim smsJson, smsUrl, objXMLHttp, smsResponse

    ' SMS JSON 데이터 생성
    smsJson = " {""usercode""atid""" & usercode & """, ""deptcode"":""" & deptcode & """, "
    smsJson = smsJson & """yellowid_key"":""" & api_key & """, "
    smsJson = smsJson & """messages"":[ "
    smsJson = smsJson & "{""type"":""sms"", ""message_id"":""" & message_id & """, "
    smsJson = smsJson & """to"":""" & recipient_number & """, "
    smsJson = smsJson & """from"":""" & sender_number & """, "
    smsJson = smsJson & """text"":""" & sms_message & """} ] }"
    
    ' SMS 전송 URL
    smsUrl = "https://api.surem.com/sms/v1/json"

    ' API 요청 (POST 방식)
    Set objXMLHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    objXMLHttp.Open "POST", smsUrl, False
    objXMLHttp.SetRequestHeader "Content-Type", "application/json"
    objXMLHttp.Send smsJson
    smsResponse = CStr(objXMLHttp.ResponseText)
    Set objXMLHttp = Nothing

    ' 결과 반환
    SendSMS = smsResponse
End Function

' SMS 전송 실행
smsResult = SendSMS()

' ========== 사용자 알림 ==========
Response.Write "<script>alert('SMS가 전송되었습니다. 결과: " & smsResult & "'); location.replace('korderlist.asp?kidx=" & kidx & "');</script>"

Set Rs = Nothing
Call dbClose()
%>
