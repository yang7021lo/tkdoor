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

part = Request("part") 

' 🔹 파일 및 폼 데이터 읽기
kgotopage = Request("kgotopage")
rSearchWord = Request("SearchWord")

rualidx = Request("ualidx")
rprice_bk = Request("price_bk")
rprice_etl = Request("price_etl")

' 🔹 요청 받은 변수 출력 (디버그용)
'Response.Write "rualidx : " & rualidx & "<br>"
'Response.Write "rprice_bk : " & rprice_bk & "<br>"
'Response.Write "rprice_etl : " & rprice_etl & "<br>"
'Response.End

' 삭제 처리
If part = "delete" Then

        sql = "DELETE FROM tng_unitprice_t WHERE uptidx = " & ruptidx
        'Response.Write sql & "<br>"
        'Response.End
        Dbcon.Execute(sql)

        Response.Write "<script>location.replace('unittype_al.asp?ualidx=" & rualidx & ");</script>"

Else

        ' UPDATE 실행
        sql = "UPDATE tng_unitprice_al SET "
        sql = sql & "price_bk = '" & rprice_bk & "' "
        sql = sql & ", price_etl = '" & rprice_etl & "' "
        sql = sql & " WHERE ualidx = '" & rualidx & "' "
        Response.Write sql & "<br>"
        'Response.End
        Dbcon.Execute(sql)
        Response.Write "<script>location.replace('unittype_al.asp?ualidx=" & rualidx & "#"&rualidx&"');</script>"  

End If

Set Rs = Nothing
call dbClose()
%>
