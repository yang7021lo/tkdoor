
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

cidx=Request("cidx")

SQL=" Select * From tk_member where cidx='"&cidx&"' "
Rs.open SQL,Dbcon,1,1,1
    if not (Rs.EOF or Rs.BOF ) then
        Response.write "<script>alert('소속된 멤버 정보를 먼저 삭제해 주세요.');location.replace('corpview.asp?cidx="&cidx&"');</script>"
    else 

'거래 테이블 조회해서 데이터가 없으면 삭제 가능하도록 해야 한다.- 채유정-

        SQL=" Delete From tk_customer where cidx='"&cidx&"' "
        'Dbcon.Execute (SQL)
        Response.write "<script>alert('삭제되었습니다.');location.replace('corplist.asp');</script>"
    end if
Rs.Close

set Rs=Nothing
call dbClose()
%>
