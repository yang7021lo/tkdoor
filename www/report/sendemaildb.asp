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
function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function 
    
snidx=Request("snidx")
popup=Request("popup")
amemail=encodestr(Request("amemail"))
sendadd=encodestr(Request("sendadd"))
mtitle=encodestr(Request("mtitle"))
mmaintext=encodestr(Request("mmaintext"))

    if mmaintext<>"" then mmaintext=replace(mmaintext,chr(13) & chr(10),"<br>") 

response.write snidx&"<br>"
response.write amemail&"<br>"
response.write sendadd&"<br>"
response.write mtitle&"<br>"
response.write mmaintext&"<br>"

ecount = 1

'response.end

call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

SQL=" Select C.rfile from tk_reportsend A "
SQL=SQL&" Join tk_reportsendsub B On B.snidx=A.snidx "
SQL=SQL&" Join tk_report C On C.ridx=B.ridx "
SQL=SQL&"Where A.snidx='"&snidx&"' "
Rs.open Sql,Dbcon,1,1,1

if not (Rs.EOF or Rs.BOF ) then
i=1
for j=i to Rs.RecordCount

rfile=Rs(0)

report= rfile&report

i=i+1
Rs.MoveNext
Next
End If
Rs.close

SQL=" Select C.rgfile from tk_reportsend A "
SQL=SQL&" Join tk_reportsendgsub B On B.snidx=A.snidx "
SQL=SQL&" Join tk_reportg C On C.rgidx=B.rgidx "
SQL=SQL&"Where A.snidx='"&snidx&"'"
Rs.open Sql,Dbcon,1,1,1

if not (Rs.EOF or Rs.BOF ) then
k=1
for l=k to Rs.RecordCount

rgfile=Rs(0)

reportg= rgfile&reportg

k=k+1
Rs.MoveNext
Next
End If
Rs.close

SQL=" Select efname from tk_emailatfile Where snidx='"&snidx&"'"
Rs.open Sql,Dbcon,1,1,1

if not (Rs.EOF or Rs.BOF ) then
k=1
for l=k to Rs.RecordCount

efname=Rs(0)

filename= efname&filename

k=k+1
Rs.MoveNext
Next
End If
Rs.close

SQL=" Update tk_reportsend set sndate=getdate(), mtitle='"&mtitle&"',  mmaintext='"&mmaintext&"', sncemail1='"&amemail&"', snmemail='"&sendadd&"', filename='"&filename&"', report='"&report&"', reportg='"&reportg&"', snsendstatus='1' "
SQL=SQL&" Where snidx='"&snidx&"' "
Dbcon.Execute (SQL)

set Rs=Nothing
call dbClose()

'response.end

' Create CDO.Message object
Set reportemail = Server.CreateObject("CDO.Message")

' Set email configuration (for SMTP server)

With reportemail.Configuration.Fields
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 ' cdoSendUsingPort
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1 ' Basic authentication
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "tkdoor0516@gmail.com"
    .Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "cqbx ljmy hdge ufus"
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    .Update
End With

' Set mail fields

    reportemail.To = amemail                              '받는 메일 주소
    reportemail.From = "tkdoor0516@gmail.com"                                       '보내는 메일 주소
    reportemail.Subject = mtitle                                    '메일 제목                      
    reportemail.HTMLBody = mmaintext&"<br><br><a href='http://tkdoor.co.kr/report/sendmaildownload.asp?snidx="&snidx&"&ecount="&ecount&" '>다운로드</a>"
                        

                        
    'reportemail.CreateHTMLBody                                     '링크
    
    reportemail.Send 

' Clean up
Set reportemail = Nothing

if popup<>"" then
Response.Write "<script>alert('메일이 발송되었습니다.');location.replace('totalreport.asp?');</script>"
else
Response.Write "<script>alert('메일이 발송되었습니다.');opener.location.replace('totalreport.asp?');window.close();</script>"
end if
%>


<!--
"<table class=""CUBES_container_full"" align=""center"" border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td style=""padding:20px 10px;"" bgcolor=""#f2f2f2"">" & _
                       " <table class=""CUBES_100 CUBES_box""" & _
                       " style=""margin:0 auto; border:1px solid #eeeeee; box-shadow: 0px 0px 5px 3px #eeeeee; border-radius:15px; background-color:#ffffff; min-width:740px"" align=""center"" border=""0"" cellpadding=""0"" cellspacing=""0"" width=""740"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td class=""CUBES_100 CUBES_content"" align=""center"" valign=""top"" width=""740"">" & _
                       " <table class=""CUBES_desktop"" style=""margin:0 auto"" border=""0"" cellpadding=""0"" cellspacing=""0"" width=""740"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td height=""46""></td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " <table class=""CUBES_100"" style=""margin:0 auto"" border=""0"" cellpadding=""0"" cellspacing=""0"" width=""604"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td style=""padding-bottom:85px"" class=""cubes_stack cubes_logo"" align=""left"" valign=""top""><img alt=""CUBES"" style=""display:block; margin:0; border:0"" width=""100px"" src=""http://tkd001.cafe24.com/taekwang_logo.svg""></td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " <table class=""CUBES_100"" style=""margin:0 auto"" border=""0"" cellpadding=""0"" cellspacing=""0"" width=""600"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td class=""cubes_stack"" valign=""top"" align=""left"">" & _
                       " <table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td style=""padding-bottom:14px;"" class=""CUBES_app_txt"" align=""left"">" & _
                       " <div style=""font-family:Helvetica Neue, Helvetica, Lucida Grande, Lucida Sans, Lucida Sans Unicode, Arial, sans-serif; color:#444444; font-size:14px; line-height:1.32em;"">" & _
                       " <h1>안녕하세요,</h1>요청하신 시험성적서가 준비되어 이메일에 첨부해 드렸습니다.<br><br>" & _
                       " <div style=""padding:30px 56px; background-color:#1e1e23; border-radius:1rem;"">" & _
                       " <table width=""100%"" style=""background-color:#1e1e23;"" border=""0"" cellspacing=""0"" cellpadding=""0"">" & _
                       " <tbody>" & _
                       " <a href=""http://tkd001.cafe24.com/report/sendmaildownload.asp?snidx=" & snidx & """ style=""color:#3a9aed; text-decoration:none;"">" & _
                       " <tr>" & _
                       " <td align=""center"">" & _
                       " <img alt=""CUBES"" width=""80px"" src=""https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/PDF_file_icon.svg/1667px-PDF_file_icon.svg.png"">" & _
                       " </td>" & _
                       " </tr>" & _
                       " <tr>" & _
                       " <td style=""font-size:48px; line-height:52px; font-family:Arial, sans-serif; color:#3a9aed; font-weight:bold; text-align:center;"">" & _
                       " <a href=""http://tkd001.cafe24.com/report/sendmaildownload.asp?snidx=" & snidx & """ style=""color:#3a9aed; text-decoration:none;"">" & _
                       " 다운로드" & _
                       " </a>" & _
                       " </td>" & _
                       " </tr>" & _
                       " <a></a>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " </div><br><br>파일이 열리지 않거나 내용 확인에 어려움이 있으실 경우, 아래 링크를 통해서도 확인하실 수 있습니다. " & _
                       " <br>" & _
                       " <a rel=""noopener noreferrer"" target=""_blank"" style=""color:#517189"" class=""CUBES-link"" href=""http://tkd001.cafe24.com/report/sendmaildownload.asp?snidx=" & snidx & """>[Link]</a><br><br>" & _
                       " 문의사항은 <a rel=""noopener noreferrer"" target=""_blank"" style=""color:#517189;"" class=""CUBES-link"" href=""mailto:supports@cubes.kr"">supports@cubes.kr</a>로 문의하십시오.<br><br>감사합니다.<br><br>태광도어 드림." & _
                       " </div>" & _
                       " </td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " </td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " <table class=""CUBES_desktop"" style=""margin:0 auto"" border=""0"" cellpadding=""0"" cellspacing=""0"" width=""740"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td height=""60""></td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " </td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " </td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " <table class=""CUBES_container_full"" align=""center"" border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td style=""padding:20px 10px;"" bgcolor=""#f2f2f2"" align=""center"">" & _
                       " <table class=""CUBES_100"" style=""margin:0 auto; min-width:740px"" border=""0"" cellpadding=""0"" cellspacing=""0"" width=""700"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td style=""padding-bottom:20px;"" align=""center"">" & _
                       " <table class=""CUBES_100"" align=""center"" cellpadding=""0"" cellspacing=""0"" border=""0"" width=""100%"">" & _
                       " <tbody>" & _
                       " <tr>" & _
                       " <td class=""CUBES_center CUBES_footer_text CUBES_footer_text2"" style=""padding:0 0 25px;"" align=""center"">" & _
                       " <div style=""font-family:Lucida Grande, Helvetica Neue, Arial, Helvetica, sans-serif; color:#999999; font-size:9px; line-height:1.6667em"">" & _
                       " <p align=""center"">Copyright © 2024 Taekwangdoor<br><a rel=""noopener noreferrer"" target=""_blank"" style=""color:#517189"" class=""CUBES-link"" href=""https://www.cubes.kr/legal/privacy/kr.html"">개인정보 처리방침</a>&nbsp;|&nbsp;<a rel=""noopener noreferrer"" target=""_blank"" style=""color:#517189"" class=""CUBES-link"" href=""https://www.cubes.kr/legal/terms/kr.html"">이용 약관</a>&nbsp;|&nbsp;<a rel=""noopener noreferrer"" target=""_blank"" style=""color:#517189"" class=""CUBES-link"" href=""mailto:supports@cubes.kr"">고객 지원</a></p>" & _
                       " </div>" & _
                       " </td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " </td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" & _
                       " </td>" & _
                       " </tr>" & _
                       " </tbody>" & _
                       " </table>" 
-->