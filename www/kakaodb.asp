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
 
midx=Request("midx")
ykakao=request("ykakao")
 

aykakao=md5(ykakao)


response.write midx&"<br>"
response.write ykakao&"<br>"
response.write aykakao&"<br>"
 



SQL="Select mpw From tk_member Where midx='"&midx&"' "
rs.open sql,dbcon,1,1,1
if not (Rs.EOF or Rs.BOF) then 
    mpw=rs(0)
    if aykakao=mpw then 
        SQL="update tk_member set mkakao='1' where midx='"&midx&"' "
        Dbcon.Execute (SQL)
        REsponse.write "<script>alert('인증되었습니다.');location.replace('index.asp');</script>"
    else
    REsponse.write "<script>alert('인증번호가 다릅니다.');history.back();</script>"
    end if

else
    REsponse.write "<script>alert('해당되는 정보가 없습니다.');history.back();</script>"
end if    
rs.close


response.end
 

 %>
 
 
 <%
  set Rs=Nothing
  call dbClose()
  %>