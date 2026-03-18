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

' Request 값을 받아 변수에 저장
bfidx     = Request("bfidx")
set_name  = Request("set_name")
bfbfmidx    = Request("bfbfmidx")
bfwdate   = Request("bfwdate")
bfebfmidx   = Request("bfebfmidx")
bfewdate  = Request("bfewdate")

' 값 출력 (디버깅용)
Response.Write "bfidx : " & bfidx & "<br>"
Response.Write "set_name : " & set_name & "<br>"
Response.Write "bfmidx : " & bfmidx & "<br>"
Response.Write "bfwdate : " & bfwdate & "<br>"
Response.Write "bfebfmidx : " & bfebfmidx & "<br>"
Response.Write "bfewdate : " & bfewdate & "<br>"

if part="delete" then 
    SQL="Delete From tk_barasiF Where bfidx='"&bfidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    
    sql = "DELETE FROM tk_barasisub WHERE  bfidx='"&bfidx&"' "
    Response.write (SQL)&"<br>"
    Response.end
    'Dbcon.Execute (SQL)

    sql="Delete from tk_barasi where  bfidx='"&bfidx&"' "
    Response.write (SQL)&"<br>"
    'Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_JULGOK_IN.asp');</script>"
else 

    if bfidx="0" then 
    
    SQL = "INSERT INTO tk_barasiF (set_name, bfmidx, bfwdate, bfemidx, bfewdate) "
    SQL = SQL & "VALUES ('" & set_name & "', " & c_midx & ", getdate(), " & c_midx & ", getdate())"
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_JULGOK_IN.asp');</script>"

    else
    SQL = "UPDATE tk_barasiF SET set_name = '" & set_name & "', bfmidx = " & c_midx & ", bfwdate = getdate(), "
    SQL = SQL & " bfemidx = " & c_midx & ", bfewdate = getdate() "
    SQL = SQL & " where bfidx='"&bfidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_JULGOK_IN.asp?rbfidx="&bfidx&"');</script>"

    end if
end if
set Rs=Nothing
call dbClose()
%>
