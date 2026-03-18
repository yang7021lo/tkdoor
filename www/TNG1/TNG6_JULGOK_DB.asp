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


midx=Request("midx")
mname=Request("mname")
mpos=Request("mpos")
mtel=Request("mtel")
mhp=Request("mhp")
mfax=Request("mfax")
memail=Request("memail")
part=Request("part")

response.write "midx : "&midx&"<br>"
response.write "mname : "&mname&"<br>"
response.write "mpos : "&mpos&"<br>"
response.write "mtel : "&mtel&"<br>"
response.write "mhp : "&mhp&"<br>"
response.write "mfax : "&mfax&"<br>"
response.write "memail : "&memail&"<br>"

if part="delete" then 
    SQL="Delete From tk_member Where midx='"&midx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG6_JULGOK.asp');</script>"
else 

    if midx="0" then 
    
    SQL="Insert into tk_member (mname, mpos, mtel, mhp, mfax, memail, mwdate) values ('"&mname&"','"&mpos&"','"&mtel&"','"&mhp&"','"&mfax&"','"&memail&"', getdate())"
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG6_JULGOK.asp');</script>"

    else
    SQL="update tk_member set mname='"&mname&"', mpos='"&mpos&"', mtel='"&mtel&"', mhp='"&mhp&"', mfax='"&mfax&"', memail='"&memail&"' where midx='"&midx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG6_JULGOK.asp?rmidx="&midx&"');</script>"

    end if
end if
set Rs=Nothing
call dbClose()
%>
