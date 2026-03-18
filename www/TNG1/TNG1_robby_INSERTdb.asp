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
rsjbtidx=Request("sjbtidx")
' 파일 및 폼 데이터 읽기
gotopage = Request("gotopage")
rSJB_IDX       = Request("SJB_IDX")
rSJB_TYPE_NO   = Request("SJB_TYPE_NO")
rSJB_TYPE_NAME = Request("SJB_TYPE_NAME")
rsjbtstatus = Request("sjbtstatus")
rSJB_FA = Request("SJB_FA")
rSearchWord    = Request("SearchWord")
rTNG_Busok_idx=Request("TNG_Busok_idx")
'Response.Write "rsjbtidx : " & rsjbtidx & "<br>"
'Response.Write "rSJB_TYPE_NO : " & rSJB_TYPE_NO & "<br>"
'Response.Write "rSJB_TYPE_NAME : " & rSJB_TYPE_NAME & "<br>"
'Response.Write "rSJB_barlist : " & rSJB_barlist & "<br>"
'Response.end

if part="delete" then 
    sql = "DELETE FROM tng_sjbtype WHERE sjbtidx = " & rsjbtidx & " "

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)
    'response.write "<script>window.close();</script>"
    'response.write "<script>location.replace('TNG1_PUMMOK_Item.asp');</script>"
    response.write "<script>location.replace('TNG1_SJB_TYPE_INSERT.asp');</script>"
else 

    if rsjbtidx="0" then 
    
     ' 🔹 새로운 sjbtidx 번호 구하기
        SQL = "SELECT ISNULL(MAX(sjbtidx), 0) + 1 FROM tng_sjbtype"
        Rs.Open SQL, Dbcon
        If Not (Rs.EOF Or Rs.BOF) Then
            rsjbtidx = Rs(0)
        End If
        Rs.Close

        ' 🔹 INSERT 실행
        sql = "INSERT INTO tng_sjbtype (sjbtidx, SJB_TYPE_NO, SJB_TYPE_NAME, sjbtstatus, SJB_FA ) "
        sql = sql & "VALUES (" & rsjbtidx & ", " & rSJB_TYPE_NO & ", '" & rSJB_TYPE_NAME & "', " & rsjbtstatus & ", " & rSJB_FA & ")"

        'Response.write sql & "<br>"
        'Response.End

        Dbcon.Execute(sql)
        response.write "<script>location.replace('TNG1_SJB_TYPE_INSERT.asp');</script>"
        if rSJB_IDX <>"" then     
        'response.write "<script>opener.location.replace('TNG1_PUMMOK_Item.asp');window.close();</script>"  
        response.write "<script>location.replace('TNG1_SJB_TYPE_INSERT.asp');</script>"
        elseif rTNG_Busok_idx <>"" then
        'response.write "<script>opener.location.replace('TNG1_BUSOK.asp');window.close();</script>"  
        response.write "<script>location.replace('TNG1_SJB_TYPE_INSERT.asp');</script>"
        end if
    else
    sql = "UPDATE tng_sjbtype SET "
    sql = sql & "SJB_TYPE_NO = " & rSJB_TYPE_NO & ", "
    sql = sql & "SJB_TYPE_NAME = '" & rSJB_TYPE_NAME & "', "
    sql = sql & "SJB_FA = '" & rSJB_FA & "', "
    sql = sql & "sjbtstatus = " & rsjbtstatus & " "
    sql = sql & " WHERE sjbtidx = " & rsjbtidx & " "

    'Response.Write sql & "<br>"
    'Response.End

     Dbcon.Execute (SQL)
     response.write "<script>location.replace('TNG1_SJB_TYPE_INSERT.asp');</script>"
    'response.write "<script>window.close();</script>"
    'response.write "<script>location.replace('TNG1_PUMMOK_Item.asp');</script>"
    end if
end if
set Rs=Nothing
call dbClose()
%>
