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
rfidx              = Request("fidx")
rGREEM_F_A         = Request("GREEM_F_A")
rGREEM_BASIC_TYPE  = Request("GREEM_BASIC_TYPE")
rGREEM_FIX_TYPE    = Request("GREEM_FIX_TYPE")
rfmidx             = Request("fmidx")
rfwdate            = Request("fwdate")
rfmeidx            = Request("fmeidx")
rfewdate           = Request("fewdate")
rGREEM_O_TYPE      = Request("GREEM_O_TYPE")
rGREEM_HABAR_TYPE  = Request("GREEM_HABAR_TYPE")
rGREEM_LB_TYPE     = Request("GREEM_LB_TYPE")
rGREEM_MBAR_TYPE   = Request("GREEM_MBAR_TYPE")
ropa               = Request("opa")
ropb               = Request("opb")
ropc               = Request("opc")
ropd               = Request("opd")
rfname          = Request("fname")

Response.Write "part : " & part & "<br>"
Response.Write "rfidx : " & rfidx & "<br>"
'Response.end

'그림 추가 복제하기 시작
'===================

start_fidx = Request("start_fidx")

if start_fidx<>"" then
    Response.Write "start_fidx : " & start_fidx & "<br>"
    'Response.End
    response.write "<script>location.replace('TNG1_GREEMLIST_edit.asp?start_fidx="&start_fidx&"#"&start_fidx&"');</script>"
end if

if split_fidx<>"" then
split_fidx = Request("split_fidx")
ssplit_fidx=split(split_fidx,"_")

    start_fidx=ssplit_fidx(0) 
    copy_fidx=ssplit_fidx(1) 



Response.Write "start_fidx : " & start_fidx & "<br>"
Response.Write "rfidx : " & rfidx & "<br>"
Response.Write "copy_fidx : " & copy_fidx & "<br>"

    'Response.End

If IsNumeric(start_fidx) And IsNumeric(copy_fidx) Then
    sql = "INSERT INTO tk_frameSub (fidx, xi, yi, wi, hi, fmidx, imsi, WHICHI_FIX, WHICHI_AUTO) "
    sql = sql & "SELECT " & copy_fidx & ", xi, yi, wi, hi, fmidx, imsi, WHICHI_FIX, WHICHI_AUTO "
    sql = sql & "FROM tk_frameSub WHERE fidx = " & start_fidx

    Dbcon.Execute(sql)

    Response.Write "<script>alert('복사 완료: " & start_fidx & " → " & copy_fidx & "');"
    Response.Write "location.href='TNG1_GREEMLIST_edit.asp?fidx=" & copy_fidx & "#" & copy_fidx & "';</script>"
Else
    Response.Write "<script>alert('잘못된 접근입니다.'); history.back();</script>"
End If

end if
'=====
'바 추가 복제하기 끝

if part="delete" then 
    sql = "DELETE FROM tk_frame WHERE fidx = " & rfidx & " "

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_GREEMLIST_edit.asp');</script>"
else 
    if rfidx="0" then 

        ' 🔹 INSERT 실행
        sql = "INSERT INTO tk_frame (fname) "
        sql = sql & "VALUES (" & rfname & ")"
        'Response.write sql & "<br>"
        'Response.End
        Dbcon.Execute(sql)
        response.write "<script>location.replace('TNG1_GREEMLIST_edit.asp');</script>"
    else
        sql = "UPDATE tk_frame SET "
        sql = sql & " GREEM_F_A = '" & rGREEM_F_A & "'"
        sql = sql & ", GREEM_BASIC_TYPE = '" & rGREEM_BASIC_TYPE & "'"
        sql = sql & ", GREEM_FIX_TYPE = '" & rGREEM_FIX_TYPE & "'"
        sql = sql & ", fmidx = '" & rfmidx & "'"
        sql = sql & ", fwdate = '" & rfwdate & "'"
        sql = sql & ", fmeidx = '" & rfmeidx & "'"
        sql = sql & ", fewdate = '" & rfewdate & "'"
        sql = sql & ", GREEM_O_TYPE = '" & rGREEM_O_TYPE & "'"
        sql = sql & ", GREEM_HABAR_TYPE = '" & rGREEM_HABAR_TYPE & "'"
        sql = sql & ", GREEM_LB_TYPE = '" & rGREEM_LB_TYPE & "'"
        sql = sql & ", GREEM_MBAR_TYPE = '" & rGREEM_MBAR_TYPE & "'"
        sql = sql & ", opa = '" & ropa & "'"
        sql = sql & ", opb = '" & ropb & "'"
        sql = sql & ", opc = '" & ropc & "'"
        sql = sql & ", opd = '" & ropd & "'"
        sql = sql & ", fname = '" & rfname & "'"
        sql = sql & " WHERE fidx = '" & rfidx & "'"
        Response.Write sql & "<br>"
        'Response.End
        Dbcon.Execute (SQL)
        response.write "<script>location.replace('TNG1_GREEMLIST_edit.asp?fidx="&rfidx&"#"&rfidx&"');</script>"
    end if
end if
set Rs=Nothing
call dbClose()
%>









