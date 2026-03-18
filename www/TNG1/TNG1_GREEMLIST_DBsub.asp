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

' 로그인 체크 (선택 사항)
if c_midx = "" then
    response.write "<script>alert('로그인이 필요합니다.');location.replace('/index.asp');</script>"
    response.end
end if
part = Request("part")
rftidx              = Request("ftidx")
rGREEM_BASIC_TYPE   = Request("GREEM_BASIC_TYPE")
rGREEM_BASIC_TYPEname = Request("GREEM_BASIC_TYPEname")
rGREEM_FIX_TYPE     = Request("GREEM_FIX_TYPE")
rGREEM_FIX_TYPEname = Request("GREEM_FIX_TYPEname")
rgreem_o_type       = Request("greem_o_type")
rgreem_o_typename   = Request("greem_o_typename")
rGREEM_HABAR_TYPE   = Request("GREEM_HABAR_TYPE")

'Response.Write "rGREEM_F_A : " & rGREEM_F_A & "<br>"
'Response.end

if part="delete" then 
    sql = "DELETE FROM tk_frametype WHERE ftidx = " & rftidx & " "

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_GREEMLIST_editsub.asp');</script>"
else 
    if rftidx="0" then 

        ' 🔹 INSERT 실행
        sql = "INSERT INTO tk_frametype (fname) "
        sql = sql & "VALUES (" & rGREEM_BASIC_TYPEname & ")"
        'Response.write sql & "<br>"
        'Response.End
        Dbcon.Execute(sql)
        response.write "<script>location.replace('TNG1_GREEMLIST_editsub.asp');</script>"
    else
        sql = "UPDATE tk_frametype SET "
        sql = sql & " GREEM_BASIC_TYPE = '" & rGREEM_BASIC_TYPE & "'"
        sql = sql & " , GREEM_BASIC_TYPEname = N'" & rGREEM_BASIC_TYPEname & "'"
        sql = sql & " , GREEM_FIX_TYPE = '" & rGREEM_FIX_TYPE & "'"
        sql = sql & " , GREEM_FIX_TYPEname = N'" & rGREEM_FIX_TYPEname & "'"
        sql = sql & " , greem_o_type = '" & rgreem_o_type & "'"
        sql = sql & " , greem_o_typename = N'" & rgreem_o_typename & "'"
        sql = sql & " WHERE ftidx = '" & rftidx & "'"
        Response.Write sql & "<br>"
        'Response.End
        Dbcon.Execute (SQL)
        response.write "<script>location.replace('TNG1_GREEMLIST_editsub.asp?ftidx="&rftidx&"');</script>"
    end if
end if
set Rs=Nothing
call dbClose()
%>









