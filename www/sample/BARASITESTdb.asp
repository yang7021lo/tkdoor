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


SJst2_IDX=Request("SJst2_IDX")
SJst_vc_last=Request("SJst_vc_last")
SJst_vc_1=Request("SJst_vc_1")
SJst_wc_1=Request("SJst_wc_1")
SJst_r=Request("SJst_r")
SJst_l=Request("SJst_l")
part=Request("part")

response.write "SJst2_IDX : "&SJst2_IDX&"<br>"
response.write "SJst_vc_last : "&SJst_vc_last&"<br>"
response.write "SJst_vc_1 : "&SJst_vc_1&"<br>"
response.write "SJst_wc_1 : "&SJst_wc_1&"<br>"



if part="delete" then 
    SQL="Delete From TNG_SJst2 Where SJst2_IDX='"&SJst2_IDX&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('BARASITEST.asp');</script>"
else 

    if SJst2_IDX="0" or  SJst2_IDX=""  then 
    
    SQL="Insert into TNG_SJst2 (SJst_vc_last,SJst_vc_1,SJst_wc_1,SJst_r,SJst_l) values ('"&SJst_vc_last&"','"&SJst_vc_1&"','"&SJst_wc_1&"','"&SJst_r&"','"&SJst_l&"')"
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('BARASITEST.asp');</script>"

    else
    SQL = "UPDATE TNG_SJst2 SET SJst_vc_1='" & SJst_vc_1 & "', SJst_wc_1='" & SJst_wc_1 & "', SJst_r='" & SJst_r & "', SJst_l='" & SJst_l & "' "
    SQL=SQL&" WHERE SJst2_IDX = '" & SJst2_IDX & "' "

    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('BARASITEST.asp?rSJst2_IDX="&SJst2_IDX&"');</script>"

    end if
end if
set Rs=Nothing
call dbClose()
%>
