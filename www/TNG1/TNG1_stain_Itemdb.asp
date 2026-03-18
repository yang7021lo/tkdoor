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

part=Request("part")

' 파일 및 폼 데이터 읽기
gotopage = Request("gotopage")
rSJB_IDX       = Request("SJB_IDX")
rSJB_TYPE_NO   = Request("SJB_TYPE_NO")
rSJB_TYPE_NAME = Request("SJB_TYPE_NAME")
rSJB_barlist   = Request("SJB_barlist")
rSJB_FA        = Request("SJB_FA")
rSJB_Paint     = Request("SJB_Paint")
rSJB_St        = Request("SJB_St")
rSJB_Al        = Request("SJB_Al")
rSJB_midx      = Request("SJB_midx")
rSJB_mdate     = Request("SJB_mdate")
rSJB_meidx     = Request("SJB_meidx")
rSJB_medate    = Request("SJB_medate")
rSearchWord    = Request("SearchWord")
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "rSJB_TYPE_NO : " & rSJB_TYPE_NO & "<br>"
'Response.Write "rSJB_TYPE_NAME : " & rSJB_TYPE_NAME & "<br>"
'Response.Write "rSJB_barlist : " & rSJB_barlist & "<br>"
'Response.Write "rSJB_Paint : " & rSJB_Paint & "<br>"
'Response.Write "rSJB_St : " & rSJB_St & "<br>"
'Response.Write "rSJB_Al : " & rSJB_Al & "<br>"
'Response.Write "rSJB_midx : " & rSJB_midx & "<br>"
'Response.Write "rSJB_mdate : " & rSJB_mdate & "<br>"
'Response.Write "rSJB_meidx : " & rSJB_meidx & "<br>"
'Response.Write "rSJB_medate : " & rSJB_medate & "<br>"
'Response.end

if part="delete" then 
    SQL="Delete From TNG_SJB Where SJB_IDX='"&rSJB_IDX&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_PUMMOK_Item.asp?gotopage=" & gotopage & "&SearchWord="&rSearchWord&"');</script>"
else 
    if rsJB_IDX="0" then 
        SQL = "INSERT INTO TNG_SJB (SJB_TYPE_NO, SJB_TYPE_NAME, SJB_barlist, SJB_FA, SJB_Paint, SJB_St, SJB_Al, SJB_midx, SJB_mdate, SJB_meidx, SJB_medate) "
        SQL = SQL & "VALUES ('" & rSJB_TYPE_NO & "', '" & rSJB_TYPE_NAME & "', '" & rSJB_barlist & "', '" & rSJB_FA & "', "
        SQL = SQL & rSJB_Paint & ", " & rSJB_St & ", " & rSJB_Al & ", " & C_midx & ", GETDATE(), " & C_midx & ", GETDATE())"
        'Response.write (SQL)&"<br>"
        'Response.END       
        Dbcon.Execute(SQL)

        SQL=" Select max(SJB_IDX) From TNG_SJB  "
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            SJB_IDX = Rs(0)
        End If
        Rs.Close

        response.write "<script>location.replace('TNG1_PUMMOK_Item.asp?gotopage=" & gotopage & "&SJB_IDX="&SJB_IDX&"&SearchWord="&rSearchWord&"#"&SJB_IDX&"');</script>"
    else
        SQL = "UPDATE TNG_SJB SET "
        SQL = SQL & " SJB_TYPE_NO = '" & rSJB_TYPE_NO & "', SJB_TYPE_NAME = '" & rSJB_TYPE_NAME & "', SJB_barlist = '" & rSJB_barlist & "' "
        SQL = SQL & ", SJB_FA='" & rSJB_FA & "', SJB_Paint = '" & rSJB_Paint & "', SJB_St = '" & rSJB_St & "', SJB_Al = '" & rSJB_Al & "'  "
        SQL = SQL & ", SJB_meidx = '" &C_midx & "', SJB_medate = GETDATE() "
        SQL = SQL & " WHERE SJB_IDX = '" & rSJB_IDX & "' "
       ' Response.write(SQL) & "<br>"
         'Response.END
        Dbcon.Execute(SQL)
        response.write "<script>location.replace('TNG1_PUMMOK_Item.asp?gotopage=" & gotopage & "&SJB_IDX="&rSJB_IDX&"&SearchWord="&rSearchWord&"#"&rSJB_IDX&"');</script>"
    end if
end if

set Rs = Nothing
call dbClose()
%>
