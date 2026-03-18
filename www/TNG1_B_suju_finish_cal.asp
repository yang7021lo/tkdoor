
<%@ codepage="65001" language="vbscript"%>
<%
' -------------------------------
' 안전 나눗셈 함수 정의 (페이지 최상위)
' -------------------------------
Function SafeDivide(numerator, denominator)
    If IsNumeric(denominator) And CDbl(denominator) <> 0 Then
        SafeDivide = CDbl(numerator) / CDbl(denominator)
    Else
        SafeDivide = 0
    End If
End Function
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()
Set RsC = Server.CreateObject ("ADODB.Recordset")
Set Rs = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")
Set Rs2 = Server.CreateObject ("ADODB.Recordset")
Set Rs3 = Server.CreateObject ("ADODB.Recordset")


rcidx=request("cidx")
rsjidx=request("sjidx") '수주키 TB TNG_SJA
rsjb_idx=request("sjb_idx") '수주 제품키 TB TNG_SJB
rsjb_type_no=Request("sjb_type_no") '제품타입
rsjbsub_Idx=Request("sjbsub_Idx")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")
rsjsidx=Request("sjsidx") '수주주문품목키
Response.Write "rsjsidx : " & rsjsidx & "<br>" 
'response.end
rgreem_f_a=Request("greem_f_a")
rGREEM_BASIC_TYPE=Request("GREEM_BASIC_TYPE")
rgreem_o_type=Request("greem_o_type")
rGREEM_FIX_TYPE=Request("GREEM_FIX_TYPE")
rgreem_habar_type=Request("greem_habar_type")
rgreem_lb_type=Request("greem_lb_type")
rGREEM_MBAR_TYPE=Request("GREEM_MBAR_TYPE")
rpidx=Request("pidx") '도장 페인트키  
rquan=Request("quan") '수량
'Response.Write "rpidx 도장칼라: " & rpidx & "<br>" 
rqtyidx=Request("qtyidx") '재질키
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
rblength=Request("blength") '바의 길이
rafksidx=Request("afksidx") '복제할 바의 키값
rtw=Request("tw") '검측가로
rth=Request("th") '검측세로
row=Request("ow") '오픈 가로 치수
roh = Request("oh")  ' 오픈 세로 치수
rfl = Request("fl")  ' 묻힘 치수
row_m=Request("ow_m") '자동_오픈지정
rdoorglass_t =Request("doorglass_t") '도어유리두께
rfixglass_t =Request("fixglass_t") '픽스유리두께
rdooryn=Request("dooryn") '도어같이 나중
rasub_wichi1=Request("asub_wichi1")
rasub_wichi2 =Request("asub_wichi2")
rasub_bigo1=Request("asub_bigo1")
rasub_bigo2=Request("asub_bigo2")
rasub_bigo3=Request("asub_bigo3")
rasub_meno1 =Request("asub_meno1")
rasub_meno2 =Request("asub_meno2")

rquan=Request("quan") '수량

rjaebun=Request("jaebun") ' 1 재분 2재분보강 0삭제
rboyang=Request("boyang") '보양

'Response.Write "rjaebun : " & rjaebun & "<br>"   
'Response.Write "rboyang : " & rboyang & "<br>"   
rdoorchangehigh=Request("doorchangehigh") 

if rgreem_f_a = "" then rgreem_f_a=1 end if
if rGREEM_BASIC_TYPE = "" then rGREEM_BASIC_TYPE=0 end if
if rgreem_o_type = "" then rgreem_o_type=0 end if
if rGREEM_FIX_TYPE = "" then rGREEM_FIX_TYPE=0 end if
if rgreem_habar_type = "" then rgreem_habar_type=0 end if
if rgreem_lb_type = "" then rgreem_lb_type=0 end if
if rGREEM_MBAR_TYPE = "" then rGREEM_MBAR_TYPE=0 end if


if rgreem_f_a="2" then 
    rgreem_habar_type = "0"
    rgreem_lb_type = "0"
    rGREEM_MBAR_TYPE = "0"
    rgreem_basic_type = "5"
    rGREEM_O_TYPE = "0"
end if


if rfkidx<>"" then  

    '=================tk_framek 도어업데이트 시작
        SQL = "" ' ✅ 반드시 초기화!!
        SQL = SQL & " select doorsizechuga_price,door_price "
        SQL = SQL & " from tk_framekSub "
        SQL=SQL&" Where fkidx = '"&rfkidx&"' and doortype>0 "
        'Response.write (SQL)&"<br>"
        Rs1.open SQL, Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
        Do While Not Rs1.EOF

            doorsizechuga_price = rs1(0)
            door_price = rs1(1)

            total_doorsizechuga_price         = total_doorsizechuga_price         + doorsizechuga_price '총 도어 추가금(별도 분리되서 계산)
            total_door_price          = total_door_price          + door_price '총 도어(도어추가금 포함되어있음) 단가

        rs1.MoveNext
        Loop
        End If
        Rs1.Close 

        SQL = "UPDATE tk_framek SET "
        SQL = SQL & " door_price = '" & total_door_price & "' "
        SQL = SQL & " WHERE fkidx = '"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)
    '=================tk_framek 도어업데이트 끝


sjsprice = 0
disrate = 0
disprice = 0
fprice = 0
py_chuga= 0
robby_box= 0
jaeryobunridae= 0
boyangjea= 0
whaburail= 0
total_sjsprice         = 0
total_disrate          = 0
total_disprice         = 0
total_fprice           = 0
total_py_chuga         = 0
total_robby_box        = 0
total_jaeryobunridae   = 0
total_boyangjea        = 0
total_whaburail        = 0
total_door_price       = 0

    sql = "SELECT fkidx, fknickname, fidx, sjb_idx, fname, fmidx"
    sql = sql & ", fwdate, fstatus, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE"
    sql = sql & ", GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, fmeidx, fewdate, GREEM_MBAR_TYPE"
    sql = sql & ", sjidx, sjb_type_no, setstd, sjsidx, ow, oh"
    sql = sql & ", tw, th, bcnt, FL, qtyidx, pidx"
    sql = sql & ", ow_m, framek_price, sjsprice, disrate, disprice, fprice"
    sql = sql & ", quan, taxrate, sprice, py_chuga, robby_box, jaeryobunridae"
    sql = sql & ", boyangjea, dooryn, doorglass_t, fixglass_t, doorchoice, whaburail"
    sql = sql & ", jaeryobunridae_type, door_price "
    sql = sql & " FROM tk_framek"
    sql = sql & " WHERE sjsidx = '" & rsjsidx & "'"
    'Response.write (SQL)&"<br>"
    rs.Open sql, Dbcon
    If Not (rs.BOF Or rs.EOF) Then
    Do While Not rs.EOF

        fkidx = rs(0)
        fknickname = rs(1)
        fidx = rs(2)
        sjb_idx = rs(3)
        fname = rs(4)
        fmidx = rs(5)
        fwdate = rs(6)
        fstatus = rs(7)
        GREEM_F_A = rs(8)
        GREEM_BASIC_TYPE = rs(9)
        GREEM_FIX_TYPE = rs(10)
        GREEM_HABAR_TYPE = rs(11)
        GREEM_LB_TYPE = rs(12)
        GREEM_O_TYPE = rs(13)
        GREEM_FIX_name = rs(14)
        fmeidx = rs(15)
        fewdate = rs(16)
        GREEM_MBAR_TYPE = rs(17)
        sjidx = rs(18)
        sjb_type_no = rs(19)
        setstd = rs(20)
        sjsidx = rs(21)
        ow = rs(22)
        oh = rs(23)
        tw = rs(24)
        th = rs(25)
        bcnt = rs(26)
        FL = rs(27)
        qtyidx = rs(28)
        pidx = rs(29)
        ow_m = rs(30)
        framek_price = rs(31)
        sjsprice = rs(32)
        disrate = rs(33)
        disprice = rs(34)
        fprice = rs(35)
        quan = rs(36)
        taxrate = rs(37)
        sprice = rs(38)
        py_chuga = rs(39)
        robby_box = rs(40)
        jaeryobunridae = rs(41)
        boyangjea = rs(42)
        dooryn = rs(43)
        doorglass_t = rs(44)
        fixglass_t = rs(45)
        doorchoice = rs(46)
        whaburail = rs(47)
        jaeryobunridae_type = rs(48)
        door_price = rs(49)

            total_sjsprice         = total_sjsprice         + sjsprice  '단가
            total_disrate          = disrate '할인율
            total_disprice         = total_disprice         + disprice '할인금액
            total_fprice           = total_fprice           + fprice '공급가 (tk_frmaek에서 단가에서 할인을 뺴서 계산되어 있음 . 수량도 곱해져 있음)
            'total_quan             = total_quan             + quan '수량
            'total_taxrate          = total_taxrate          + taxrate '세율
            'total_sprice           = total_sprice           + sprice '최종가
            total_py_chuga         = total_py_chuga         + py_chuga
            total_robby_box        = total_robby_box        + robby_box
            total_jaeryobunridae   = total_jaeryobunridae   + jaeryobunridae
            total_boyangjea        = total_boyangjea        + boyangjea
            total_whaburail        = total_whaburail        + whaburail
        
        'response.write "fkidx : " & fkidx & "<br>"
        'response.write "fprice : " & fprice & "<br>"
        'response.write "total_fprice : " & total_fprice & "<br>"


        If doorchoice = 2 Then
            ' door_price는 무시 (가격 있음에도 불구하고 더하지 않음)
            door_price = 0

        End If



        If doorchoice = 3 Then
            ' door_price는 무시 (가격 있음에도 불구하고 더하지 않음)
            door_price = 0

        End If

        total_door_price = total_door_price + door_price

        rs.MoveNext
        Loop
        End If
        Rs.Close 
        
        'total_robby_box
        'response.write "quan : " & quan & "<br>"
        'response.write "total_robby_box : " & total_robby_box & "<br>"
        'response.write "total_jaeryobunridae : " & total_jaeryobunridae & "<br>"
        'response.write "total_boyangjea : " & total_boyangjea & "<br>"
        'response.write "total_whaburail : " & total_whaburail & "<br>"
        'response.write "total_door_price : " & total_door_price & "<br>"
        'response.write "total_sjsprice : " & total_sjsprice & "<br>"
        'response.write "total_disprice : " & total_disprice & "<br>"
        'response.write "total_fprice : " & total_fprice & "<br>"
        'response.write "total_py_chuga : " & total_py_chuga & "<br>"
        'response.write "total_disrate : " & total_disrate & "<br>"
        'response.end


        sjsprice_update =  total_sjsprice + total_robby_box + total_jaeryobunridae + total_boyangjea + total_whaburail + total_door_price
        fprice_update =  total_fprice + ((total_robby_box + total_jaeryobunridae + total_boyangjea + total_whaburail + total_door_price) * quan )
        total_taxrate=(fprice_update * 0.1)  '세액
        total_sprice=(fprice_update+total_taxrate)   '최종금액

'response.write "sjsprice_update : " & sjsprice_update & "<br>"
'response.write "fprice_update : " & fprice_update & "<br>"
'response.write "total_taxrate : " & total_taxrate & "<br>"
'response.write "total_sprice : " & total_sprice & "<br>"


        '=================sjasub 업데이트 시작
        SQL = "UPDATE tng_sjaSub SET "
        SQL = SQL & " sjsprice = '" & sjsprice_update & "' , disprice = '" & total_disprice & "' , fprice = '" & fprice_update & "' "
        SQL = SQL & " , taxrate = '" & total_taxrate & "' , sprice = '" & total_sprice & "', py_chuga = '" & total_py_chuga & "' "
        SQL = SQL & " , robby_box = '" & total_robby_box & "' , jaeryobunridae = '" & total_jaeryobunridae & "', boyangjea = '" & total_boyangjea & "' "
        SQL = SQL & " , whaburail = '" & total_whaburail & "' , door_price = '" & total_door_price & "' ,quan='"&quan&"' "
        SQL = SQL & " WHERE sjsidx = '" & rsjsidx & "' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)
        '=================sjasub 업데이트 끝

end if 'if rfkidx<>"" then  


'=================cidx 찾기

SQL="select a.sjmidx, a.sjcidx "
SQL=SQL&" From tng_sja a "
SQL=SQL&" join tng_sjasub b on a.sjidx=b.sjidx "
SQL=SQL&" where b.sjidx='"&rsjidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
    rsjmidx=Rs(0)
    rsjcidx=Rs(1)
End If
Rs.Close

'response.end
if Request("part")="choiceb" then 
response.write"<script>location.replace('TNG1_b_choiceframeb.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&quan="&rquan&"');</script>"
else

Response.Write "<script>"
Response.Write "if (window.opener && !window.opener.closed) {"
Response.Write "  window.opener.location.href = 'TNG1_B.asp?sjcidx=" & rsjcidx & "&sjmidx=" & rsjmidx & "&sjidx=" & rsjidx & "&sjsidx=" & rsjsidx & "&money_reset=0';"
Response.Write "  window.close();"
Response.Write "} else {"
Response.Write "  location.href = 'TNG1_B.asp?sjcidx=" & rsjcidx & "&sjmidx=" & rsjmidx & "&sjidx=" & rsjidx & "&sjsidx=" & rsjsidx & "&money_reset=0';"
Response.Write "}"
Response.Write "</script>"

end if
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>