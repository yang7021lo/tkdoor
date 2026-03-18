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
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")
listgubun="one"
subgubun="one2"
projectname="TNG1_B_suju_sjasub"
%>
<%

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 



rcidx=request("cidx")
rsjidx=request("sjidx") '수주키 TB TNG_SJA
rsjb_idx=request("sjb_idx") '수주 제품키 TB TNG_SJB
rsjb_type_no=Request("sjb_type_no") '제품타입
rsjbsub_Idx=Request("sjbsub_Idx")

rfkidx=Request("fkidx")
rfksidx=Request("fksidx")

rsjsidx=Request("sjsidx") '수주주문품목키

rpidx=Request("pidx") '도장 페인트키  
If Trim(rpidx) = "" Or IsNull(rpidx) Or Not IsNumeric(rpidx) Then
    rpidx = 0
End If
'Response.Write "rpidx 도장칼라: " & rpidx & "<br>" 

rqtyidx=Request("qtyidx") '재질키
'Response.Write "rqtyidx 재질키 : " & rqtyidx & "<br>" 
    If rqtyidx = 5 Then 
        rpidx = 0
    end if
    If rqtyidx = 7 Then 
        rqtyidx = 3
    end if
'rfidx=Request("fidx") '도면 타입
rqtyco_idx=Request("qtyco_idx") '재질키서브
    If rqtyco_idx = 77 Then 
        rpidx = 0
    end if
rmwidth=Request("mwidth") '검측가로
rmheight=Request("mheight") '검측세로

rasub_wichi1=Request("asub_wichi1")
rasub_wichi2 =Request("asub_wichi2")
rasub_bigo1=Request("asub_bigo1")
rasub_bigo2=Request("asub_bigo2")
rasub_bigo3=Request("asub_bigo3")
rasub_meno1 =Request("asub_meno1")
rasub_meno2 =Request("asub_meno2")


rquan=Request("quan") '수량
mode=Request("mode")


rsjsprice = Request("sjsprice")     ' 품목 단가
rdisrate  = Request("disrate")      ' 할인율
rdisprice = Request("disprice")     ' 할인가
rfprice   = Request("fprice")       ' 최종가
rtaxrate  = Request("taxrate")      ' 세율
rsprice   = Request("sprice")       ' 공급가

rastatus       = Request("astatus")         ' 상태값 (기본: 1)
rpy_chuga      = Request("py_chuga")        ' 추가금
rdoor_price    = Request("door_price")      ' 도어 가격
rwhaburail     = Request("whaburail")       ' 하부레일
rrobby_box     = Request("robby_box")       ' 로비박스
rjaeryobunridae= Request("jaeryobunridae")  ' 자재분리대
rboyangjea     = Request("boyangjea")       ' 보양 수량

'Response.Write "mode : " & mode & "<br>"   



if rsjsidx<>""  then 
           
    sql="update tng_sjaSub set  sjb_idx='"&rsjb_idx&"', qtyidx='"&rqtyidx&"' , pidx='"&rpidx&"' , quan='"&rquan&"' "
    SQL=SQL&" ,asub_wichi1='"&rasub_wichi1&"',asub_wichi2='"&rasub_wichi2&"',asub_bigo1='"&rasub_bigo1&"',asub_bigo2='"&rasub_bigo2&"' "
    SQL=SQL&" ,asub_bigo3='"&rasub_bigo3&"',asub_meno1='"&rasub_meno1&"',asub_meno2='"&rasub_meno2&"' " 
    SQL=SQL&" Where sjsidx='"&rsjsidx&"' " 
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)



    if  rquan <> "" then    '수량
        sql="update tk_framek set quan='"&rquan&"'  "
        sql=sql&" where sjsidx = '" & rsjsidx & "'"
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if

    if  rqtyidx > 0  then   '스텐 재질
        sql="update tk_framek set qtyidx='"&rqtyidx&"'  "
        sql=sql&" where sjsidx = '" & rsjsidx & "'"
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if

    if  rpidx <> "" then   '도장 재질
        sql="update tk_framek set pidx='"&rpidx&"' "
        sql=sql&" where sjsidx = '" & rsjsidx & "'"
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL) 
    end if




End if

response.write "<script>location.replace('TNG1_B_suju2.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_idx="&rsjb_idx&"')</script>"


%>  
<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>    
