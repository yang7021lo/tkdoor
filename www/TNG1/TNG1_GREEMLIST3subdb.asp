<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

part=Request("part")

' 파일 및 폼 데이터 읽기
rsjb_idx           = Request("sjb_idx")
rSJBsub_IDX        = Request("SJBsub_IDX")
rSJBsub_TYPE_NAME2 = Request("SJBsub_TYPE_NAME2")
rsjb_type_no       = Request("sjb_type_no")
gotopage           = Request("gotopage")
rSearchWord         = Request("SearchWord")
if rSJBsub_IDX="" then rSJBsub_IDX="0" end if

'Response.Write "rsjb_idx : " & rsjb_idx & "<br>"
'Response.Write "rSJBsub_IDX : " & rSJBsub_IDX & "<br>"
'Response.Write "rSJBsub_TYPE_NAME2 : " & rSJBsub_TYPE_NAME2 & "<br>"
'Response.Write "rSJBsub_TYPE_NAME2 : " & rSJBsub_TYPE_NAME2 & "<br>"
'Response.End

if part="delete" then 
    SQL="Delete From TNG_SJBsub Where sJBsub_IDX='"&rsJBsub_IDX&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_GREEMLIST3.asp?gotopage=" & gotopage & "&SearchWord=" & rSearchWord & "#" & rSJB_IDX & "');</script>"

else 
    if rSJBsub_IDX="0" then 
        SQL = "INSERT INTO TNG_SJBsub (SJBsub_TYPE_NO, SJBsub_TYPE_NAME2, SJBsub_midx, SJBsub_mdate, SJBsub_meidx, SJBsub_medate, SJB_IDX) "
        SQL = SQL & "VALUES ('" & rsjb_type_no & "', '" & rSJBsub_TYPE_NAME2 & "', '" & C_midx & "', GETDATE(), '" & C_midx & "', GETDATE(), '" & rSJB_IDX & "' )"
        Response.write (SQL)&"<br>"
        Dbcon.Execute(SQL)


        SQL="Select max(sjbsub_idx) From TNG_SJBsub "
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
          rsjbsub_idx=Rs(0)
        end if
        Rs.Close
        response.write "<script>location.replace('TNG1_GREEMLIST3.asp?sjb_idx="&rsjb_idx&"&sjbsub_idx="&rsjbsub_idx&"&sjb_type_no="&rsjb_type_no&"&gotopage="&gotopage&"&SearchWord="&rSearchWord&"');</script>"
    else
        SQL = "UPDATE TNG_SJBsub SET "
        SQL = SQL & " SJBsub_TYPE_NO = '" & rsjb_type_no & "', SJBsub_TYPE_NAME2 = '" & rSJBsub_TYPE_NAME2 & "',  SJBsub_meidx = " & C_midx & ", SJBsub_medate = GETDATE(), SJB_IDX = " & rSJB_IDX & " "
        SQL = SQL & " WHERE SJBsub_IDX = '" & rSJBsub_IDX & "' "
        'Response.write(SQL) & "<br>"
        Dbcon.Execute(SQL)
        response.write "<script>location.replace('TNG1_GREEMLIST3.asp?sjb_idx="&rsjb_idx&"&sjbsub_idx="&rsjbsub_idx&"&sjb_type_no="&rsjb_type_no&"&gotopage="&gotopage&"&SearchWord="&rSearchWord&"');</script>"
    end if
end if

set Rs = Nothing
call dbClose()
%>
