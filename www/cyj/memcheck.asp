
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


mhp=Request("mhp")

if mhp="" then 
    Response.write "<script>alert('휴대폰 번호를 입력해 주세요.');parent.oFrom.mhp.value='';</script>"
else

    sql="select count(*) from tk_member where mhp='"&mhp&"'"
    response.write (sql)
    rs.open Sql,dbcon,1,1,1
        count=rs(0)
    rs.Close

    'response.end
    if count>0 then
        Response.write "<script>alert('중복된 휴대폰 번호가 있습니다.');parent.oFrom.mhp.value='';</script>"
    else
        Response.write "<script>alert('중복된 휴대폰 번호가 없습니다^^.');parent.oFrom.ep_check.value='OK';</script>"
    end if



end if




set Rs=Nothing
call dbClose()
%>
