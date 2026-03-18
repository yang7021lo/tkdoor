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
mode=Request("mode")
rbfwidx=Request("bfwidx")
' 파일 및 폼 데이터 읽기
gotopage = Request("gotopage")
rWHICHI_FIX       = Request("WHICHI_FIX") '이건 이제 필요가 없음
rWHICHI_FIXname   = Request("WHICHI_FIXname")
rWHICHI_AUTO      = Request("WHICHI_AUTO") '이건 이제 필요가 없음
rWHICHI_AUTOname  = Request("WHICHI_AUTOname")
rbfwstatus         = Request("bfwstatus")
rglassselect         = Request("glassselect")
runittype_bfwidx         = Request("unittype_bfwidx")
rSearchWord       = Request("SearchWord")


if rWHICHI_FIXname<>"" and rWHICHI_AUTOname<>"" then 

    response.write "alert('수동과 자동을 동시에 입력할 수 없습니다!');history.back();"
    response.end

end if
'if rWHICHI_FIXname<>"" then 
' 🔹 새로운 rWHICHI_FIXname 번호 구하기 .번호를 직접 수정하면 안됨으로 하는것
'        SQL = "SELECT ISNULL(MAX(WHICHI_FIX), 0) + 1 FROM tng_whichitype"
'        Rs.Open SQL, Dbcon
'        If Not (Rs.EOF Or Rs.BOF) Then
'            rWHICHI_FIX = Rs(0) 
'            rWHICHI_AUTO = 0
'        End if
'        Rs.Close
'end if
'if rWHICHI_AUTOname<>"" then 
' 🔹 새로운 rWHICHI_FIXname 번호 구하기 .번호를 직접 수정하면 안됨으로 하는것
'        SQL = "SELECT ISNULL(MAX(WHICHI_AUTO), 0) + 1 FROM tng_whichitype"
'        Rs.Open SQL, Dbcon
'        If Not (Rs.EOF Or Rs.BOF) Then
'            rWHICHI_AUTO = Rs(0) 
'            rWHICHI_FIX = 0
'        End If
'        Rs.Close
'end if

'Response.Write "unittype_bfwidx=" & unittype_bfwidx & "<br>"
'Response.Write "part : " & part & "<br>"
'Response.Write "rbfwidx : " & rbfwidx & "<br>"
'Response.Write "gotopage : " & gotopage & "<br>"
'Response.Write "rWHICHI_FIX : " & rWHICHI_FIX & "<br>"
'Response.Write "rWHICHI_FIXname : " & rWHICHI_FIXname & "<br>"
'Response.Write "rWHICHI_AUTO : " & rWHICHI_AUTO & "<br>"
'Response.Write "rWHICHI_AUTOname : " & rWHICHI_AUTOname & "<br>"
'Response.Write "rbfwstatus : " & rbfwstatus & "<br>"
'Response.Write "rglassselect : " & rglassselect & "<br>"
'Response.Write "rSearchWord : " & rSearchWord & "<br>"
'Response.end


if part="delete" and mode="sudong" then 
    sql = "DELETE FROM tng_whichitype WHERE bfwidx = " & rbfwidx & " "

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)
    'response.write "<script>window.close();</script>"
    response.write "<script>location.replace('TNG1_whichi_INSERT.asp?gotopage=" & gotopage & "&SearchWord="&rSearchWord&"&mode=sudong');</script>"
    
elseif part="delete" and mode="auto" then 
    sql = "DELETE FROM tng_whichitype WHERE bfwidx = " & rbfwidx & " "

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)
    'response.write "<script>window.close();</script>"
    response.write "<script>location.replace('TNG1_whichi_INSERT.asp?gotopage=" & gotopage & "&SearchWord="&rSearchWord&"&mode=auto');</script>"

elseif  mode="sudong" then 

    if rbfwidx="0" then 
    
    ' 🔹 새로운 bfwidx 번호 구하기
        SQL = "SELECT ISNULL(MAX(bfwidx), 0) + 1 FROM tng_whichitype"
        Rs.Open SQL, Dbcon
        If Not (Rs.EOF Or Rs.BOF) Then
            rbfwidx = Rs(0)
        End If
        Rs.Close

        ' 🔹 INSERT 실행
        sql = "INSERT INTO tng_whichitype (bfwidx, WHICHI_FIX, WHICHI_FIXname, bfwstatus, glassselect, unittype_bfwidx) "
        sql = sql & "VALUES (" & rbfwidx & ", " & rWHICHI_FIX & ", '" & rWHICHI_FIXname & "', " & rbfwstatus & " , " & rglassselect & " , " & runittype_bfwidx & ")"

        'Response.write sql & "<br>"
        'Response.End

        Dbcon.Execute(sql)
        response.write "<script>location.replace('TNG1_whichi_INSERT.asp?gotopage=" & gotopage & "&bfwidx="&rbfwidx&"&SearchWord="&rSearchWord&"&mode="&mode&"#"&rbfwidx&"');</script>"
    else

sql = "UPDATE tng_whichitype SET "
sql = sql & "WHICHI_FIX = '" & rWHICHI_FIX & "', WHICHI_FIXname = '" & rWHICHI_FIXname & "' "
sql = sql & ", bfwstatus = '" & rbfwstatus & "', glassselect = '" & rglassselect & "' , unittype_bfwidx = '" & runittype_bfwidx & "' "
sql = sql & "WHERE bfwidx = '" & rbfwidx & "'"


    'Response.Write sql & "<br>"
    'Response.End

     Dbcon.Execute (SQL)
    response.write "<script>location.replace('TNG1_whichi_INSERT.asp?gotopage=" & gotopage & "&bfwidx="&rbfwidx&"&SearchWord="&rSearchWord&"&mode="&mode&"#"&rbfwidx&"');</script>"

    end if

elseif  mode="auto" then 

    if rbfwidx="0" then 
    
    ' 🔹 새로운 bfwidx 번호 구하기
        SQL = "SELECT ISNULL(MAX(bfwidx), 0) + 1 FROM tng_whichitype"
        Rs.Open SQL, Dbcon
        If Not (Rs.EOF Or Rs.BOF) Then
            rbfwidx = Rs(0)
        End If
        Rs.Close

        ' 🔹 INSERT 실행
        sql = "INSERT INTO tng_whichitype (bfwidx, WHICHI_AUTO, WHICHI_AUTOname, bfwstatus, glassselect, unittype_bfwidx) "
        sql = sql & "VALUES (" & rbfwidx & ",  " & rWHICHI_AUTO & ", '" & rWHICHI_AUTOname & "', " & rbfwstatus & " , " & rglassselect & " , " & runittype_bfwidx & ")"

        'Response.write sql & "<br>"
        'Response.End

        Dbcon.Execute(sql)
        response.write "<script>location.replace('TNG1_whichi_INSERT.asp?gotopage=" & gotopage & "&bfwidx="&rbfwidx&"&SearchWord="&rSearchWord&"&mode="&mode&"#"&rbfwidx&"');</script>"
    else

sql = "UPDATE tng_whichitype SET "
sql = sql & "WHICHI_AUTO = '" & rWHICHI_AUTO & "', "
sql = sql & "WHICHI_AUTOname = '" & rWHICHI_AUTOname & "', bfwstatus = '" & rbfwstatus & "', glassselect = '" & rglassselect & "' , unittype_bfwidx = '" & runittype_bfwidx & "' "
sql = sql & "WHERE bfwidx = '" & rbfwidx & "'"


    'Response.Write sql & "<br>"
    'Response.End

     Dbcon.Execute (SQL)
    response.write "<script>location.replace('TNG1_whichi_INSERT.asp?gotopage=" & gotopage & "&bfwidx="&rbfwidx&"&SearchWord="&rSearchWord&"&mode="&mode&"#"&rbfwidx&"');</script>"

    end if


end if
set Rs=Nothing
call dbClose()
%>
