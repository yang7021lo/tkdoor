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
rSearchWord    = Request("SearchWord")
rTNG_Busok_idx=Request("TNG_Busok_idx")
rSJB_FA= Request("SJB_FA")

' 🔹 추가된 컬럼들 - 모두 r 접두어 적용
rdwsize1  = Request("dwsize1")
rdwsize2  = Request("dwsize2")
rdwsize3  = Request("dwsize3")
rdwsize4  = Request("dwsize4")
rdwsize5  = Request("dwsize5")

rdhsize1  = Request("dhsize1")
rdhsize2  = Request("dhsize2")
rdhsize3  = Request("dhsize3")
rdhsize4  = Request("dhsize4")
rdhsize5  = Request("dhsize5")

rgwsize1  = Request("gwsize1")
rgwsize2  = Request("gwsize2")
rgwsize3  = Request("gwsize3")
rgwsize4  = Request("gwsize4")
rgwsize5  = Request("gwsize5")
rgwsize6  = Request("gwsize6")

rghsize1  = Request("ghsize1")
rghsize2  = Request("ghsize2")
rghsize3  = Request("ghsize3")
rghsize4  = Request("ghsize4")
rghsize5  = Request("ghsize5")
rghsize6  = Request("ghsize6")
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
    response.write "<script>location.replace('TNG1_SJB_TYPE_INSERTgl.asp');</script>"
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
        sql = "INSERT INTO tng_sjbtype (sjbtidx, SJB_TYPE_NO, SJB_TYPE_NAME, sjbtstatus, "
        sql = sql & "dwsize1, dhsize1, dwsize2, dhsize2, dwsize3, dhsize3, dwsize4, dhsize4, dwsize5, dhsize5, "
        sql = sql & "gwsize1, ghsize1, gwsize2, ghsize2, gwsize3, ghsize3, gwsize4, ghsize4, gwsize5, ghsize5, gwsize6, ghsize6, "
        sql = sql & "SJB_FA) "
        sql = sql & "VALUES (" & rsjbtidx & ", '" & rSJB_TYPE_NO & "', '" & rSJB_TYPE_NAME & "', '" & rsjbtstatus & "', "
        sql = sql & "'" & rdwsize1 & "', '" & rdhsize1 & "', '" & rdwsize2 & "', '" & rdhsize2 & "', '" & rdwsize3 & "', '" & rdhsize3 & "', "
        sql = sql & "'" & rdwsize4 & "', '" & rdhsize4 & "', '" & rdwsize5 & "', '" & rdhsize5 & "', "
        sql = sql & "'" & rgwsize1 & "', '" & rghsize1 & "', '" & rgwsize2 & "', '" & rghsize2 & "', '" & rgwsize3 & "', '" & rghsize3 & "', "
        sql = sql & "'" & rgwsize4 & "', '" & rghsize4 & "', '" & rgwsize5 & "', '" & rghsize5 & "', '" & rgwsize6 & "', '" & rghsize6 & "', "
        sql = sql & "'" & rSJB_FA & "')"
        'Response.write sql & "<br>"
        'Response.End

        Dbcon.Execute(sql)
        response.write "<script>location.replace('TNG1_SJB_TYPE_INSERTgl.asp');</script>"
        if rSJB_IDX <>"" then     
        'response.write "<script>opener.location.replace('TNG1_PUMMOK_Item.asp');window.close();</script>"  
        response.write "<script>location.replace('TNG1_SJB_TYPE_INSERTgl.asp');</script>"
        elseif rTNG_Busok_idx <>"" then
        'response.write "<script>opener.location.replace('TNG1_BUSOK.asp');window.close();</script>"  
        response.write "<script>location.replace('TNG1_SJB_TYPE_INSERTgl.asp');</script>"
        end if
    else
        ' 🔸 만약 sjbtidx가 0 또는 null/빈값이면 오류로 간주
    If rsjbtidx = "0" Or IsNull(rsjbtidx) Or Trim(rsjbtidx) = "" Then
        response.write "<script>alert('수정할 대상이 없습니다. 다시 선택해 주세요.'); location.replace('TNG1_SJB_TYPE_INSERTgl.asp');</script>"
        response.End
    End If
    
sql = "UPDATE tng_sjbtype SET "
sql = sql & " SJB_TYPE_NO = '" & rSJB_TYPE_NO & "'"
sql = sql & " , SJB_TYPE_NAME = '" & rSJB_TYPE_NAME & "'"
sql = sql & " , sjbtstatus = '" & rsjbtstatus & "'"

sql = sql & " , dwsize1 = '" & rdwsize1 & "'"
sql = sql & " , dhsize1 = '" & rdhsize1 & "'"
sql = sql & " , dwsize2 = '" & rdwsize2 & "'"
sql = sql & " , dhsize2 = '" & rdhsize2 & "'"
sql = sql & " , dwsize3 = '" & rdwsize3 & "'"
sql = sql & " , dhsize3 = '" & rdhsize3 & "'"
sql = sql & " , dwsize4 = '" & rdwsize4 & "'"
sql = sql & " , dhsize4 = '" & rdhsize4 & "'"
sql = sql & " , dwsize5 = '" & rdwsize5 & "'"
sql = sql & " , dhsize5 = '" & rdhsize5 & "'"

sql = sql & " , gwsize1 = '" & rgwsize1 & "'"
sql = sql & " , ghsize1 = '" & rghsize1 & "'"
sql = sql & " , gwsize2 = '" & rgwsize2 & "'"
sql = sql & " , ghsize2 = '" & rghsize2 & "'"
sql = sql & " , gwsize3 = '" & rgwsize3 & "'"
sql = sql & " , ghsize3 = '" & rghsize3 & "'"
sql = sql & " , gwsize4 = '" & rgwsize4 & "'"
sql = sql & " , ghsize4 = '" & rghsize4 & "'"
sql = sql & " , gwsize5 = '" & rgwsize5 & "'"
sql = sql & " , ghsize5 = '" & rghsize5 & "'"
sql = sql & " , gwsize6 = '" & rgwsize6 & "'"
sql = sql & " , ghsize6 = '" & rghsize6 & "'"

sql = sql & " , SJB_FA = '" & rSJB_FA & "'"

sql = sql & " WHERE sjbtidx = " & rsjbtidx


    'Response.Write sql & "<br>"
    'Response.End

     Dbcon.Execute (SQL)
     response.write "<script>location.replace('TNG1_SJB_TYPE_INSERTgl.asp');</script>"
    'response.write "<script>window.close();</script>"
    'response.write "<script>location.replace('TNG1_PUMMOK_Item.asp');</script>"
    end if
end if
set Rs=Nothing
call dbClose()
%>
