
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


  if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
  end if
  
  listgubun="one" 
  projectname="견적"

'SQL="Select ow,oh,tw,th,fl "
'SQL=SQL&" From tk_framek  "
'SQL=SQL&" Where fkidx='"&rfkidx&"' "
'Response.write (SQL)&"222222<br>"
'Rs.open SQL, Dbcon
'If Not (Rs.bof or Rs.eof) Then 

 '   row=rs(0) '오픈 가로
  '  roh=rs(1) '오픈 세로  
   ' rtw=rs(2) '전체 가로
    'rth=rs(3) '전체 세로
    'rfl=rs(4) '묻힘 치수

'End If
'Rs.close
  
  rsjcidx=request("cidx")
  rsjcidx=request("sjcidx")
  rsjidx=request("sjidx") '수주키 TB TNG_SJA
  rsjb_idx=request("sjb_idx") '수주 제품키 TB TNG_SJB
  rsjb_type_no=Request("sjb_type_no") '제품타입

  rsjbsub_Idx=Request("sjbsub_Idx")

  rfkidx=Request("fkidx")

  'Response.Write "rfkidx : " & rfkidx & "<br>" 
  rfksidx=Request("fksidx")

  rsjsidx=Request("sjsidx") '수주주문품목키
  
  rgreem_f_a=Request("greem_f_a")
  rGREEM_BASIC_TYPE=Request("GREEM_BASIC_TYPE")
  rgreem_o_type=Request("greem_o_type")
  rGREEM_FIX_TYPE=Request("GREEM_FIX_TYPE")
  rgreem_habar_type=Request("greem_habar_type")
  rgreem_lb_type=Request("greem_lb_type")
  rGREEM_MBAR_TYPE=Request("GREEM_MBAR_TYPE")
    rpidx=Request("pidx") '도장 페인트키  
    If Trim(rpidx) = "" Or IsNull(rpidx) Or Not IsNumeric(rpidx) Then
        rpidx = 0
    End If
    ' ===== coat 값 수신 (중요) =====
    rcoat = Request("coat")
    If Trim(rcoat) = "" Or Not IsNumeric(rcoat) Then
        rcoat = 0
    End If
    'Response.Write "rpidx 도장칼라: " & rpidx & "<br>" 
        
' 널/빈값 방지


    rqtyidx=Request("qtyidx") '재질키
    if rqtyidx<>"" then
        'If rqtyidx = 5 Then 
            'rpidx = 0
        ' end if
        If rqtyidx = 7 Then 
            rqtyidx = 3
        end if
    end if
    'rfidx=Request("fidx") '도면 타입
  'rqtyco_idx=Request("qtyco_idx") '재질키서브
        'If rqtyco_idx = 77 Then 
           ' rpidx = 0
        'end if
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
mode=Request("mode")




rjaebun=Request("jaebun") ' 1 재분 2재분보강 0삭제
rboyang=Request("boyang") '보양
if rjaebun = "" then rjaebun = 0 end if 
if rboyang = "" then rboyang = 0 end if 
'Response.Write "rjaebun : " & rjaebun & "<br>"   
'Response.Write "rboyang : " & rboyang & "<br>"   
rdoorchangehigh=Request("doorchangehigh") 


'rstatus = 2 값이 존재 한다면 enter 및 데이터 입력 막기 
%>
<script>
function hasDataCheck(e) {
    const form = document.getElementById("dataForm");

    const hasData = form.elements["hasData"].value === "true";

    console.log("hasData =", hasData);

 

    return true;
}
</script>

<%
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

if rfkidx="" then
    rfkidx=0
end if 

'바 종류 바꾸기 시작
'=========================================================

If Request("new_open") = "go" Then
    response.write "<script>"
    response.write "window.open('TNG1_B_suju2_pop_quick.asp?cidx=" & rcidx & _
        "&sjidx=" & rsjidx & _
        "&sjsidx=" & rsjsidx & _
        "&fkidx=" & rfkidx & _
        "&sjb_idx=" & rsjb_idx & _
        "&sjb_type_no=" & rsjb_type_no & _
        "&fksidx=" & rfksidx & "', '_blank', 'width=1000,height=800');"
    response.write "</script>"
    
End If
'=========================================================
'바 종류 바꾸기 끝
'부속 적용하기 시작
'=======================================
if Request("part")="bfinsert" then 
    rsbfidx=Request("sbfidx")
    SQL=" Update tk_framekSub set bfidx='"&rsbfidx&"' where fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if
'=======================================
'부속적용하기 끝

'프레임 삭제 시작
'=======================================
if Request("part")="framedel" then 

    SQL=" Delete From  tk_framek where fkidx='"&rfkidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    SQL=" Delete From  tk_framekSub where fkidx='"&rfkidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
'sjb_type_no="&rsjb_type_no&"& &sjb_idx="&sjb_idx&"
      ' tk_framek에서 TOP 1  fkidx 가져오기
    SQL = "SELECT TOP 1 fkidx "
    SQL = SQL & "FROM tk_frameK "
    SQL = SQL & "WHERE sjsidx='" & rsjsidx & "'"
    Set Rs3 = Server.CreateObject("ADODB.Recordset")
    response.write (SQL)&"<br>"
    Rs3.Open SQL, Dbcon
    If Not (Rs3.BOF Or Rs3.EOF) Then
        fkidx = Rs3("fkidx")
    End If
    Rs3.Close
    Set Rs3 = Nothing
response.write "<script>location.replace('TNG1_B_suju_quick.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&fkidx&"')</script>"

end if  
'=======================================
'프레임 삭제 끝
'바 삭제 시작
'=======================================
if Request("part")="bardel" then 

    SQL=" Delete From  tk_framekSub where fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if

'Response.Write "part=" & Request("part") & "<br>"
'Response.Write "ids=" & Request("ids") & "<br>"
If Request("part") = "bardelMulti" Then
    ids = Request("ids")
    If ids <> "" Then
        arr = Split(ids, ",")
        For i = 0 To UBound(arr)
            SQL = "DELETE FROM tk_framekSub WHERE fksidx=" & CLng(arr(i))
            'Response.Write SQL & "<br>" 
            Dbcon.Execute(SQL)
        Next
        'response.end
        Response.Write "<script>"
        Response.Write "alert('선택한 자재가 삭제되었습니다.');"
        Response.Write "location.href='TNG1_B_suju_quick.asp?sjcidx=" & Request("sjcidx") & "&sjidx=" & Request("sjidx") & "&sjsidx=" & Request("sjsidx") & "&fkidx=" & Request("fkidx") & "&sjb_idx=" & Request("sjb_idx") & "&sjb_type_no=" & Request("sjb_type_no") & "';"
        Response.Write "</script>"
    End If
End If
'=======================================
'바 삭제 끝
'품목삭제 시작 
gubun=Request("gubun")
if Request("gubun")="del1" then 

    sql = "DELETE FROM tk_framekSub WHERE fkidx IN (SELECT fkidx FROM tk_framek WHERE sjsidx='" & rsjsidx & "')"
    'Response.write (SQL)&"<br>"
    dbCon.execute (SQL)

    SQL="Delete from tk_framek Where sjsidx='"&rsjsidx&"' "
    'Response.write (SQL)&"<br>"
    dbCon.execute (SQL)

    SQL="Delete from tng_sjaSub Where sjsidx='"&rsjsidx&"' "
    'Response.write (SQL)&"<br>"
    dbCon.execute (SQL)
    
    'response.end

SQL = "SELECT TOP 1 a.sjsidx, b.sjb_idx, b.sjb_type_no, b.fkidx " 
SQL=SQL&" FROM tng_sjaSub a "
SQL=SQL&" left outer Join tk_framek b on a.sjsidx=b.sjsidx "
SQL=SQL&" WHERE a.sjidx='" & rsjidx & "' "
SQL=SQL&" ORDER BY sjsidx aSC"
'response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
    latest_sjsidx = Rs(0)
    latest_sjb_idx = Rs(1)
    latest_sjb_type_no = Rs(2)
    latest_fkidx = Rs(3)
Else
    latest_sjsidx = 0
    latest_sjb_idx = 0
    latest_sjb_type_no = 0
    latest_fkidx = 0
End If
Rs.Close

Response.Write "<script>"
Response.Write "location.replace('TNG1_B_suju_quick.asp?cidx=" & rcidx & _
               "&sjidx=" & rsjidx & _
               "&sjsidx=" & latest_sjsidx & "');"
               '"&sjb_idx=" & latest_sjb_idx & _
               '"&sjb_type_no=" & latest_sjb_type_no & "');"
Response.Write "</script>"

end if
'품목삭제 끝
'=============

if mode="quick" then 

    if rsjsidx=""  then 

        sql = "INSERT INTO tng_sjaSub (sjidx, midx, mwdate, meidx, mewdate, mwidth,"
        sql = sql & " mheight, qtyidx, sjsprice, disrate, disprice, fprice,"
        sql = sql & " sjb_idx, quan, taxrate, sprice, asub_wichi1, asub_wichi2,"
        sql = sql & " asub_bigo1, asub_bigo2, asub_bigo3, asub_meno1, asub_meno2,"
        sql = sql & " astatus, py_chuga, door_price, whaburail, robby_box,"
        sql = sql & " jaeryobunridae, boyangjea) "

        sql = sql & "VALUES ("
        sql = sql & " '" & rsjidx & "', '" & C_midx & "', getdate(),"
        sql = sql & " '" & C_midx & "', getdate(), '" & rmwidth & "',"
        sql = sql & " '" & rmheight & "', '" & rqtyidx & "', '" & rsjsprice & "',"
        sql = sql & " '" & rdisrate & "', '" & rdisprice & "', '" & rfprice & "',"
        sql = sql & " '" & rsjb_idx & "', '" & rquan & "', '" & rtaxrate & "',"
        sql = sql & " '" & rsprice & "', '" & rasub_wichi1 & "', '" & rasub_wichi2 & "',"
        sql = sql & " '" & rasub_bigo1 & "', '" & rasub_bigo2 & "', '" & rasub_bigo3 & "',"
        sql = sql & " '" & rasub_meno1 & "', '" & rasub_meno2 & "',"
        sql = sql & " '1', '" & rpy_chuga & "', '" & rdoor_price & "',"
        sql = sql & " '" & rwhaburail & "', '" & rrobby_box & "',"
        sql = sql & " '" & rjaeryobunridae & "', '" & rboyangjea & "'"
        sql = sql & ")"
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute (SQL)
        'response.end  

        SQL="Select max(sjsidx) from tng_sjaSub" 'rsjsidx 찾기
        Rs1.open Sql,Dbcon,1,1,1
        if not (Rs1.EOF or Rs1.BOF ) then
            rsjsidx=Rs1(0)
        end if
        Rs1.Close

    else
        
        sql="update tng_sjaSub set  mwidth='"&rmwidth&"',mheight='"&rmheight&"',sjb_idx='"&rsjb_idx&"', qtyidx='"&rqtyidx&"' , pidx='"&rpidx&"' , quan='"&rquan&"' "
        SQL=SQL&" ,asub_wichi1='"&rasub_wichi1&"',asub_wichi2='"&rasub_wichi2&"',asub_bigo1='"&rasub_bigo1&"',asub_bigo2='"&rasub_bigo2&"' "
        SQL=SQL&" ,asub_bigo3='"&rasub_bigo3&"',asub_meno1='"&rasub_meno1&"',asub_meno2='"&rasub_meno2&"', coat='"&rcoat&"' " 
        SQL=SQL&" Where sjsidx='"&rsjsidx&"' " 
        Response.write (SQL)&"<br>"
        'Response.end
        Dbcon.Execute (SQL)

        sql="update tk_framek set  qtyidx='"&rqtyidx&"' , pidx='"&rpidx&"' , quan='"&rquan&"' , coat='"&rcoat&"'  "
        SQL=SQL&" Where sjsidx='"&rsjsidx&"' " 
        Response.write (SQL)&"<br>"
        'Response.end
        Dbcon.Execute (SQL)

    End if

response.write "<script>location.replace('TNG1_B_suju_quick.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&fkidx="&rfkidx&"&mode=auto_enter')</script>"

end if

if mode="chuga" then 

old_sjsidx = Request("sjsidx")   '👉 복사 기준이 되는 기존 sjsidx

    if rsjsidx<>""  then 


    '=======================
    ' 1) tng_sjaSub 복사 (SELECT → INSERT)
    '=======================
    sql = ""
    sql = sql & "INSERT INTO tng_sjaSub (sjidx, midx, mwdate, meidx, mewdate, mwidth, "
    sql = sql & "mheight, qtyidx, sjsprice, disrate, disprice, fprice, "
    sql = sql & "sjb_idx, quan, taxrate, sprice, asub_wichi1, asub_wichi2, "
    sql = sql & "asub_bigo1, asub_bigo2, asub_bigo3, asub_meno1, asub_meno2, "
    sql = sql & "astatus, py_chuga, door_price, whaburail, robby_box, "
    sql = sql & "jaeryobunridae, boyangjea , pidx , framename ) "
    
    sql = sql & "SELECT sjidx, midx, getdate(), meidx, getdate(), mwidth, "
    sql = sql & "mheight, qtyidx, sjsprice, disrate, disprice, fprice, "
    sql = sql & "sjb_idx, quan, taxrate, sprice, asub_wichi1, asub_wichi2, "
    sql = sql & "asub_bigo1, asub_bigo2, asub_bigo3, asub_meno1, asub_meno2, "
    sql = sql & "'1', py_chuga, door_price, whaburail, robby_box, "
    sql = sql & "jaeryobunridae, boyangjea , pidx , framename  "
    sql = sql & "FROM tng_sjaSub WHERE sjsidx = '" & old_sjsidx & "' AND astatus=1 "
    'Response.write (SQL)&"<br><br>"
    Dbcon.Execute(sql)

    ' 새 sjsidx 찾기
    sql = "SELECT MAX(sjsidx) FROM tng_sjaSub"
    Rs1.open Sql,Dbcon,1,1,1
    If Not (Rs1.EOF Or Rs1.BOF) Then
        new_sjsidx = Rs1(0)
    Else
    new_sjsidx = 0
    End If
    Rs1.Close

    ' astatus=1 없으면 중단
    If new_sjsidx = 0 Then
        Response.Write "⚠️ astatus=1 데이터 없음 → 복사 중단"
        Response.End
    End If


    '=======================
    ' 2) tk_framek + tk_framekSub 복사 (old_sjsidx 속 fkidx 전체)
    '=======================
    sql = "SELECT fkidx FROM tk_framek WHERE sjsidx='" & old_sjsidx & "'"
    'response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon    
    If Not (Rs.EOF Or Rs.BOF) Then
    Do while not Rs.EOF

        old_fkidx = Rs(0)

        ' 새 fkidx 발급
        sql = "SELECT ISNULL(MAX(fkidx),0)+1  FROM tk_framek"
        Rs1.open Sql,Dbcon,1,1,1
        If Not (Rs1.EOF Or Rs1.BOF) Then
            new_fkidx = Rs1(0)
        End If
        Rs1.Close

        ' tk_framek 복사

        sql = ""
        sql = sql & "INSERT INTO tk_framek (fkidx, fknickname, fidx, sjb_idx, fname, fmidx, fwdate, fstatus, "
        sql = sql & "GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, "
        sql = sql & "fmeidx, fewdate, GREEM_MBAR_TYPE, sjidx, sjb_type_no, setstd, sjsidx, ow, oh, tw, th, bcnt, FL, "
        sql = sql & "qtyidx, pidx, ow_m, framek_price, sjsprice, disrate, disprice, fprice, quan, taxrate, sprice, "
        sql = sql & "py_chuga, robby_box, jaeryobunridae, boyangjea, dooryn, doorglass_t, fixglass_t, doorchoice, "
        sql = sql & "whaburail, jaeryobunridae_type, door_price) "

        sql = sql & "SELECT '" & new_fkidx & "', fknickname, fidx, sjb_idx, fname, fmidx, getdate(), fstatus, "
        sql = sql & "GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, "
        sql = sql & "fmeidx, fewdate, GREEM_MBAR_TYPE, sjidx, sjb_type_no, setstd, '" & new_sjsidx & "', ow, oh, tw, th, bcnt, FL, "
        sql = sql & "qtyidx, pidx, ow_m, framek_price, sjsprice, disrate, disprice, fprice, quan, taxrate, sprice, "
        sql = sql & "py_chuga, robby_box, jaeryobunridae, boyangjea, dooryn, doorglass_t, fixglass_t, doorchoice, "
        sql = sql & "whaburail, jaeryobunridae_type, door_price "
        sql = sql & "FROM tk_framek WHERE fkidx='" & old_fkidx & "'"
        'Response.write (SQL)&"<br><br>"
        Dbcon.Execute(sql)

        '=======================
        ' 3) tk_framekSub 복사
        '=======================
        sql = ""
        sql = sql & "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, "
        sql = sql & "WHICHI_FIX, WHICHI_AUTO, bfidx, bwsize, bhsize, gwsize, ghsize, fstype, glasstype, "
        sql = sql & "blength, unitprice, pcent, sprice, xsize, ysize, gls, OPT, FL, "
        sql = sql & "door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t, fixglass_t, doortype, "
        sql = sql & "doorglass_w, doorglass_h, doorsizechuga_price, door_price, goname, barNAME, alength, chuga_jajae, "
        sql = sql & "rstatus, rstatus2, garo_sero, sunstatus) "

        sql = sql & "SELECT '" & new_fkidx & "', fsidx, fidx, xi, yi, wi, hi, fmidx, getdate(), imsi, "
        sql = sql & "WHICHI_FIX, WHICHI_AUTO, bfidx, bwsize, bhsize, gwsize, ghsize, fstype, glasstype, "
        sql = sql & "blength, unitprice, pcent, sprice, xsize, ysize, gls, OPT, FL, "
        sql = sql & "door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t, fixglass_t, doortype, "
        sql = sql & "doorglass_w, doorglass_h, doorsizechuga_price, door_price, goname, barNAME, alength, chuga_jajae, "
        sql = sql & "rstatus, rstatus2, garo_sero , sunstatus "
        sql = sql & "FROM tk_framekSub WHERE fkidx='" & old_fkidx & "'"
        'response.write (SQL)&"<br>"
        Dbcon.Execute(sql)

    Rs.movenext
    Loop
    End if
    Rs.close

    End if

    SQL = " Select sjb_idx,sjb_type_no "
    SQL = SQL & " From tk_framek "
    SQL = SQL & " Where fkidx='"&new_fkidx&"' "
    'response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        new_sjb_idx=Rs(0)
        new_sjb_type_no=Rs(1)
    End If
    Rs.Close

response.write "<script>location.replace('TNG1_B_suju_quick.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx_new&"&sjb_idx="&new_sjb_idx&"'&sjb_type_no="&new_sjb_type_no&"'&fkidx="&new_fkidx&"')</script>"

end if

'=================복사 끝

if rsjb_type_no="" then 
  SQL=" Select sjb_type_name, SJB_barlist, sjb_type_no "
  SQL=SQL&" From TNG_SJB "
  SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon,1,1,1
  if not (Rs.EOF or Rs.BOF ) then
    sjb_type_name=Rs(0)
    sjb_barlist=Rs(1)
    rsjb_type_no=Rs(2)
  'Response.write rsjb_type_no&"<br>"
  End If
  Rs.Close
end if




'품목정보가 없을 경우 생성 시작
'===================

    SQL = "SELECT a.mwidth, a.mheight, a.qtyidx, a.sjsprice, a.disrate, a.disprice, "
    SQL = SQL & "a.fprice, a.sjb_idx, a.quan, a.taxrate, a.sprice, a.asub_wichi1, "
    SQL = SQL & "a.asub_wichi2, a.asub_bigo1, a.asub_bigo2, a.asub_bigo3, a.asub_meno1, "
    SQL = SQL & "a.asub_meno2, a.astatus, a.py_chuga, a.door_price, a.whaburail, a.robby_box, "
    SQL = SQL & "a.jaeryobunridae, a.boyangjea, a.pidx, b.sjb_type_no "
    SQL = SQL & "FROM tng_sjaSub a "
    SQL = SQL & "left outer JOIN TNG_SJB b ON b.sjb_idx = a.sjb_idx "
    if rsjsidx="" then 
      SQL = SQL & "WHERE a.sjidx = '" & rsjidx & "' "
    else
      SQL = SQL & "WHERE a.sjidx = '" & rsjidx & "' AND a.sjsidx = '" & rsjsidx & "'"
    end if

    'response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.EOF Or Rs.BOF) Then
        sja_mwidth        = Rs(0)   ' 검측 가로
        sja_mheight       = Rs(1)   ' 검측 세로
        sja_qtyidx        = Rs(2)   ' 재질
        sja_sjsprice      = Rs(3)   ' 품목가
        sja_disrate       = Rs(4)   ' 할인율
        sja_disprice      = Rs(5)   ' 할인가

        sja_fprice        = Rs(6)   ' 최종가
        sja_sjb_idx       = Rs(7)   ' sjb_idx
        sja_quan          = Rs(8)   ' 수량
        sja_taxrate       = Rs(9)   ' 세율
        sja_sprice        = Rs(10)  ' 공급가
        sja_sub_wichi1    = Rs(11)  ' 위치1

        sja_sub_wichi2    = Rs(12)  ' 위치2
        sja_sub_bigo1     = Rs(13)  ' 비고1
        sja_sub_bigo2     = Rs(14)  ' 비고2
        sja_sub_bigo3     = Rs(15)  ' 비고3
        sja_sub_meno1     = Rs(16)  ' 추가사항1
        sja_sub_meno2     = Rs(17)  ' 추가사항2

        sja_astatus       = Rs(18)  ' 상태
        sja_py_chuga      = Rs(19)  ' 추가금
        sja_door_price    = Rs(20)  ' 도어가격
        sja_whaburail     = Rs(21)  ' 하부레일
        sja_robby_box     = Rs(22)  ' 로비박스
        sja_jaeryobunridae= Rs(23)  ' 자재분리대

        sja_boyangjea     = Rs(24)  ' 보양개수
        sja_pidx          = Rs(25)  ' 페인트 pidx
        sja_sjb_type_no   = Rs(26)  ' 제품타입

    End If
    Rs.Close

'===================
'품목정보가 없을 경우 생성 끝

'수주 기본 정보불러오기
'===================
SQL="Select Convert(Varchar(10),A.sjdate,121), A.sjnum, Convert(Varchar(10),A.cgdate,121), Convert(Varchar(10),A.djcgdate,121) "
SQL=SQL&" , A.cgtype, A.cgaddr, A.cgset, A.sjmidx, A.sjcidx, A.midx, A.wdate, A.meidx, A.mewdate  "
SQL=SQL&" , B.cname, C.mname, C.mtel, C.mhp, C.mfax, C.memail, D.mname, E.mname, A.su_kjtype ,b.cdlevel, b.cflevel"
SQL=SQL&" From TNG_SJA A "
SQL=SQL&" Join tk_customer B On A.sjcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.sjmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "
SQL=SQL&" Where sjidx='"&rsjidx&"' "
'Response.write (SQL)&"<br>"
'response.end
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
  sjdate=Rs(0)    '수주일
  sjnum=Rs(1)     '수주번호
  cgdate=Rs(2)    '출고일자
  djcgdate=Rs(3)  '도장출고일자
  cgtype=Rs(4)    '출고방식
  cgaddr=Rs(5)    '현장명
  cgset=Rs(6)     '입금후 출고 설정
  sjmidx=Rs(7)    '거래처 담당자키
  sjcidx=Rs(8)    '거래처 키
  midx=Rs(9)      '등록자키
  wdate=Rs(10)    '등록일시
  meidx=Rs(11)    '수정자키
  mewdate=Rs(12)  '수정일시
  cname=Rs(13)    '거래처명
  mname=Rs(14)    '거래처 담당자명
  mtel=Rs(15)     '거래처 담당자 전화번호
  mhp=Rs(16)      '거래처 담당자 휴대폰
  mfax=Rs(17)     '거래처 담당자 팩스
  memail=Rs(18)   '거래처 담당자 이메일
  amname=Rs(19)   '등록자명
  bmname=Rs(20)   '수정자명
  su_kjtype=Rs(21) '견적이냐 수주냐냐. 견적이 1 수주주가 2
  cdlevel=Rs(22)  ' 1=10만(기본), 2=-10000, 3= +10000, 4= +20000, 5= +30000 , 6= 9만에 1000*2400
  cflevel=Rs(23)  ' 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨), 3=C(자동만 10% 디씨), 4=D, 5=E

  Select Case cdlevel
    Case 1
        cdlevel_text = "기본"
    Case 2
        cdlevel_text = "-10,000"
    Case 3
        cdlevel_text = "+10,000"
    Case 4
        cdlevel_text = "+20,000"
    Case 5
        cdlevel_text = "+30,000"
    Case 6
        cdlevel_text = "-1만:1000*2400"
    Case Else
        cdlevel_text = "미설정"
End Select

Select Case cflevel
    '======= 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨),
    '        3=C(자동만 10% 디씨), 4=D(전체 10% 업), 5=E 미설정 =======
    Case 0
        cflevel_text = "기본"
    Case 1
        cflevel_text = "수동,자동 전체 10% 디씨"
    Case 2
        cflevel_text = "수동만10%디씨"
    Case 3
        cflevel_text = "자동만10%디씨"
    Case 4
        cflevel_text = "전체10%업"
    Case 5
        cflevel_text = "미설정"
    Case Else
        cflevel_text = "미설정"
End Select

End If
Rs.Close

%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title><%=projectname%></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="/tng1/TNG1_B_suju.css"  rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <!-- SweetAlert2 CDN -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
            // --- dataForm용 ---
                function handleKeyPress_dataForm(event, elementId1, elementId2) {
                    if (event.key === "Enter") {
                        event.preventDefault();
                        console.log(`[dataForm] Enter 눌림: ${elementId1}, ${elementId2}`);
                        document.getElementById("hiddenSubmit").click();
                    }
                }

                function handleSelectChange_dataForm(event, elementId1, elementId2) {
                    console.log(`[dataForm] 선택 변경됨: ${elementId1}, ${elementId2}`);
                    document.getElementById("hiddenSubmit").click();
                }

                function handleChange_dataForm(selectElement) {
                    const selectedValue = selectElement.value;
                    document.getElementById("hiddenSubmit").click();
                }

                document.getElementById("dataForm").addEventListener("keydown", function (event) {
                    if (event.key === "Enter") {
                        event.preventDefault();
                        console.log("[dataForm] 폼 Enter 감지");
                        document.getElementById("hiddenSubmit").click();
                    }
                });

                // --- dataForm_original용 ---
                function handleKeyPress_dataFormOriginal(event, elementId1, elementId2) {
                    if (event.key === "Enter") {
                        event.preventDefault();
                        console.log(`[dataForm_original] Enter 눌림: ${elementId1}, ${elementId2}`);
                        document.getElementById("hiddenSubmit1").click();
                    }
                }

                function handleSelectChange_dataFormOriginal(event, elementId1, elementId2) {
                    console.log(`[dataForm_original] 선택 변경됨: ${elementId1}, ${elementId2}`);
                    document.getElementById("hiddenSubmit1").click();
                }

                function handleChange_dataFormOriginal(selectElement) {
                    const selectedValue = selectElement.value;
                    document.getElementById("hiddenSubmit1").click();
                }

                function handleChange_dataFormOriginalCoat(sel) {
                    const hidden = document.getElementById("coat_hidden");
                    if (hidden) hidden.value = sel.value;
                    document.getElementById("hiddenSubmit1").click(); // 또는 form submit
                }




                document.getElementById("dataForm_original").addEventListener("keydown", function (event) {
                    if (event.key === "Enter") {
                        event.preventDefault();
                        console.log("[dataForm_original] 폼 Enter 감지");
                        document.getElementById("hiddenSubmit1").click();
                    }
                });
           
        function pummoksub(sjb_idx) {
        const message = prompt("이 입면 도면을 기본으로 부속이 적용된 신규 부족적용 입면 도면 생성합니다. 입면도면의 이름을 입력하세요.");
        if (message !== null && message.trim() !== "") {
            const encodedMessage = encodeURIComponent(message.trim());
            window.location.href = "TNG1_B_suju_quick.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx="+sjb_idx+"&fknickname="+encodedMessage;
        }
        }
        function framedel(fkidx){
            if (confirm("프레임을 삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_suju_quick.asp?part=framedel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx="+fkidx;
            }
        }
        function bardel(fksidx){
            if (confirm("바를 삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_suju_quick.asp?part=bardel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx="+fksidx;
            }
        }
        function setstd(ni,fkidx){

            {
                location.href="TNG1_B_suju_quick.asp?part=setstd&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx="+fkidx+"&ni="+ni;
            }
        }
        function wresize(order){
            {
                location.href="TNG1_B_suju_quick.asp?part=wresize&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&order="+order;
            }
        }
        function hresize(order){
            {
                location.href="TNG1_B_suju_quick.asp?part=hresize&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&order="+order;
            }
        }
        function converge(direction){
            {
                location.href="TNG1_B_suju_quick.asp?part=converge&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&direction="+direction;
            }
        }
        
        function addglass(glasstype, wsize, hsize){
            {
                location.href="TNG1_B_suju_quick.asp?part=addglass&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&gubun=glass&glasstype="+glasstype+"&wsize="+wsize+"&hsize="+hsize;
            }
        }
    
        function addcovered(alocation){
            {
                location.href="TNG1_B_suju_quick.asp?part=addcovered&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&gubun=covered&alocation="+alocation;
            }
        }
        function wincopy(){
            if (confirm("바를 추가하시겠습니까?"))
            {
                document.dataForm.submit();
            }
        }
    </script>
    <script>  //TNG1_B_suju_cal_quick.asp 자동실행하기 //
        document.addEventListener("DOMContentLoaded", function() {
            const params = new URLSearchParams(window.location.search);
            if (params.get("mode") === "auto_enter") {
                const formQuick = document.getElementById("dataForm");
                if (formQuick) {
                    formQuick.submit();   // ✅ dataForm만 자동 submit
                }
            }
        });
    </script>
    <script>
    function barchange1() {
    Swal.fire({
        title: '변경할 자재를 선택하세요.',
        icon: 'info',
        confirmButtonText: '확인'
    }).then((result) => {
        if (result.isConfirmed) {
        const url = new URL(window.location.href);
        url.searchParams.set("new_open", "start"); // 쿼리 추가
        window.location.href = url.toString(); // 새로고침
        }
    });
    }
    </script>
    <script>
    function del1(rsjsidx){
        if (confirm("삭제 하시겠습니까?"))
            {
                
                location.href="TNG1_B_suju_quick.asp?gubun=del1&sjcidx=<%=sjcidx%>&sjidx=<%=rsjidx%>&sjmidx=<%=rsjmidx%>&sjsidx="+rsjsidx;
            }
        }
    </script>          
    <script>
           '분할 시 form 입력 불가
           function lockForm(formId, lock) {
            const form = document.getElementById(formId);
            if (!form) return;

            const elements = form.querySelectorAll('input, select, textarea, button');

            elements.forEach(el => {

                el.disabled = lock;
            });
        }
    </script>
    </head>
<body>
<form id="dataForm_original" name="dataForm_original"  action="TNG1_B_suju_quick.asp" method="POST" >   
    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
    <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
    <input type="hidden" name="mode" value="quick">
    <%
    Response.Write "<!-- PAGE fkidx = [" & Server.HTMLEncode(CStr(rfkidx)) & "] -->"
    %>
<div class="container-fluid">

    <!-- 첫 번째 줄 -->
    <div class="first-row">
        <div class="row px-3 w-100">
        <div class="input-group mb-0 flex-nowrap">
            <span class="input-group-text" style="min-width:100px;">수주번호</span>
            <input type="text" class="form-control" style="max-width:200px;" value="<%=sjdate%>_<%=sjnum%>">

            <span class="input-group-text" style="min-width:70px;">거래처</span>
            <input type="text" class="form-control" style="max-width:350px; cursor:pointer;"
            value="<%=cname%>" readonly
            onclick="window.open('/cyj/corpudt.asp?cidx=<%=sjcidx%>','_blank');">
            <span class="input-group-text" style="min-width:90px;">도어레벨</span>
            <input type="text" class="form-control" style="max-width:150px;" value="<%=cdlevel_text%>">

            <span class="input-group-text" style="min-width:90px;">프레임레벨</span>
            <input type="text" class="form-control" style="max-width:150px;" value="<%=cflevel_text%>">

            <span class="input-group-text" style="min-width:70px;">담당자</span>
            <input type="text" class="form-control" style="max-width:120px;" value="<%=mname%>">

            <span class="input-group-text" style="min-width:70px;">전화</span>
            <input type="text" class="form-control" style="max-width:140px;" value="<%=mtel%>">

            <span class="input-group-text" style="min-width:70px;">휴대폰</span>
            <input type="text" class="form-control" style="max-width:140px;" value="<%=mhp%>">

            <span class="input-group-text" style="min-width:70px;">팩스</span>
            <input type="text" class="form-control" style="max-width:140px;" value="<%=mfax%>">

            <span class="input-group-text" style="min-width:80px;">이메일</span>
            <input type="text" class="form-control" style="max-width:200px;" value="<%=memail%>">
        </div>
        </div>
    </div>
    <!-- 두번째 줄 -->
    <div class="first-row">
        <div class="row px-3 w-100">
            <div class="input-group mb-0">
                <div class="mb-2">
                    <select name="sjb_type_no" style="background-color:#6c757d; color:#fff; border-color:#6c757d;" class="form-control" id="sjb_type_no"  onchange="handleChange_dataFormOriginal(this)">
                    <option value="0" >선택</option> 
                    <%
                    SQL=" Select sjbtidx, sjb_type_no, sjb_type_name "
                    SQL=SQL&" From tng_sjbtype "
                    SQL=SQL&" Where sjbtstatus=1 "
                    Response.write (SQL)&"<br><br>"
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF
                    sjbtidx=Rs(0)
                    sjb_type_no=Rs(1)
                    sjb_type_name=Rs(2)


                    if rsjidx<>"" then 
                        class_text="btn btn-secondary btn-small"
                    else
                        class_text="btn btn-outline-secondary btn-small"
                    end if
                    %>
                    <option value="<%=sjb_type_no%>" <% if clng(sjb_type_no)=clng(rsjb_type_no) then response.write "selected" end if %>><%=sjb_type_name%></option>
                    <%
                    Rs.movenext
                    Loop
                    End if
                    Rs.close
                    '
                    %>
                    </select>
                </div>
                <div class="mb-2 d-flex align-items-center " >
                    <!-- 드롭다운 버튼 시작-->
                        <% if rsjb_type_no<>"" then %> 
                    <div class="dropdown">
                        <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                            <% 
                            SQL = " SELECT A.sjb_idx, B.sjb_type_name, A.SJB_barlist, A.sjb_type_no, A.sjb_fa "
                            SQL = SQL & " FROM TNG_SJB A "
                            SQL = SQL & " LEFT OUTER JOIN tng_sjbtype B ON A.sjb_type_no = B.sjb_type_no AND B.sjbtstatus = 1 "
                            SQL = SQL & " Where A.sjb_idx='"&rsjb_idx&"' "
                            'response.write (SQL)&"<br>"
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                            sjb_idx=Rs(0)
                            sjb_type_name=Rs(1)
                            SJB_barlist=Rs(2)
                            sjb_type_no=Rs(3)
                            sjb_fa=Rs(4)
                            'if right(sjb_type_name,2)="자동" then 
                            '  greem_f_a="2"
                            'elseif  right(sjb_type_name,3)="프레임" then 
                            '  greem_f_a="1"
                            'end if 
                            
                            if rsjb_type_no ="" then
                            pummokname="품목선택"
                            else
                            pummokname=SJB_barlist
                            end if
                            %>
                            <%=pummokname%>
                            <%
                    
                            End if
                            Rs.close
                            %>  
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                            <% 
                            SQL = " SELECT A.sjb_idx, B.sjb_type_name, A.SJB_barlist, A.sjb_type_no, A.sjb_fa "
                            SQL = SQL & " FROM TNG_SJB A "
                            SQL = SQL & " LEFT OUTER JOIN tng_sjbtype B ON A.sjb_type_no = B.sjb_type_no AND B.sjbtstatus = 1 "
                            SQL = SQL & " Where A.sjb_type_no='"&rsjb_type_no&"' "
                            SQL = SQL & " and (B.sjb_type_name  like '%" & Request("SearchWord") & "%' or  A.SJB_barlist  like '%" & Request("SearchWord") & "%') "
                            'response.write (SQL)&"<br>"
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                            Do while not Rs.EOF

                            sjb_idx=Rs(0)
                            sjb_type_name=Rs(1)
                            SJB_barlist=Rs(2)
                            sjb_type_no=Rs(3)
                            sjb_fa=Rs(4)
                            'if right(sjb_type_name,2)="자동" then 
                            '  greem_f_a="2"
                            'elseif  right(sjb_type_name,3)="프레임" then 
                            '  greem_f_a="1"
                            'end if 
                            %>
                                <li><a class="dropdown-item" onclick="window.open('TNG1_B_choiceframe_quick.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&greem_f_a=<%=sjb_fa%>&mode=quick','choice','top=0 left=0 width=800, height=700');"><%=sjb_type_name%>&nbsp;<%=SJB_barlist%></a></li>
                            <%
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                            %>    
                        </ul>
                    </div>
                        <%
                        end if
                        %>
                        <!-- 드롭다운 버튼 끝-->
                        <!-- 드롭다운 버튼 시작-->
                        <% if rsjb_type_no<>"" then %> 
                    <div class="dropdown">
                        <button class="btn btn-secondary  dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                            수동전용
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                            <% 
                            SQL = " SELECT A.sjb_idx, B.sjb_type_name, A.SJB_barlist, A.sjb_type_no, A.sjb_fa "
                            SQL = SQL & " FROM TNG_SJB A "
                            SQL = SQL & " LEFT OUTER JOIN tng_sjbtype B ON A.sjb_type_no = B.sjb_type_no AND B.sjbtstatus = 1 "
                            SQL = SQL & " Where A.sjb_type_no='"&rsjb_type_no&"' "
                            SQL = SQL & " and (B.sjb_type_name  like '%" & Request("SearchWord") & "%' or  A.SJB_barlist  like '%" & Request("SearchWord") & "%') "
                            SQL = SQL & " and A.sjb_fa=1 "
                            'response.write (SQL)&"<br>"
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                            Do while not Rs.EOF

                            sjb_idx=Rs(0)
                            sjb_type_name=Rs(1)
                            SJB_barlist=Rs(2)
                            sjb_type_no=Rs(3)
                            sjb_fa=Rs(4)
                            'if right(sjb_type_name,2)="자동" then 
                            '  greem_f_a="2"
                            'elseif  right(sjb_type_name,3)="프레임" then 
                            '  greem_f_a="1"
                            'end if 
                            %>
                            <% if sjb_fa="1" then %><!--수동이라면-->
                                <li><a class="dropdown-item" onclick="window.open('TNG1_b_choiceframe_fix.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&greem_f_a=<%=sjb_fa%>','choice','top=0 left=0 width=800, height=700');"><%=sjb_type_name%>&nbsp;<%=SJB_barlist%></a></li>
                            <% end if %>
                            <%
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                            %>    
                        </ul>
                    </div>
                        <%
                        end if
                        %>
                    <!-- 드롭다운 버튼 끝-->
                </div>
                    <%
                        SQL = " Select fkidx, fknickname, fname, fstatus, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE "
                        SQL = SQL & " ,GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, setstd, sjb_idx, fidx , qtyidx , pidx ,sjb_type_no  "
                        SQL = SQL & " From tk_framek "
                        SQL = SQL & " Where sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"' "
                        'response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            fkidx=Rs(0)
                            fknickname=Rs(1)
                            fname=Rs(2)
                            fstatus=Rs(3)
                            GREEM_F_A=Rs(4)
                            GREEM_BASIC_TYPE=Rs(5)
                            GREEM_FIX_TYPE=Rs(6)
                            GREEM_HABAR_TYPE=Rs(7)
                            GREEM_LB_TYPE=Rs(8)
                            GREEM_O_TYPE=Rs(9)
                            GREEM_FIX_name=Rs(10)
                            GREEM_MBAR_TYPE=Rs(11)
                            setstd=Rs(12) + 1
                            sjb_idx=Rs(13)
                            fidx=Rs(14)
                            zqtyidx=Rs(15) 
                            zpidx=Rs(16)    
                            zsjb_type_no=Rs(17)
                            if clng(msjb_idx)=clng(sjb_idx) then maintext="[m]" end if
                    %>
                        <div>     
                            <input id="frame_<%=fkidx%>" type="text" class="form-control" value="<%=maintext%><%=fname%>_<%=setstd&"번"%>" 
                            onclick="location.replace('TNG1_B_suju_quick.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=zsjb_type_no%>&fkidx=<%=fkidx%>');" 
                            <% if clng(fkidx)=clng(rfkidx) then %>style="background-color: #D3D3D3;" <% end if %>>  
                        </div>
                        <%
                            maintext=""
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                        %>   
            </div>
        </div>
    </div>
    <div class="first-row">
        <div class="row px-3 w-100">
            <div class="input-group mb-0">
                <span class="input-group-text">전체가로</span>
                <input type="text" class="form-control"  name="mwidth" value="<%=sja_mwidth%>" >
                <span class="input-group-text">전체세로</span>
                <input type="text" class="form-control"  name="mheight" value="<%=sja_mheight%>" >
                <span class="input-group-text">위치1</span>
                <input type="text" class="form-control" name="asub_wichi1" value="<%=sja_sub_wichi1%>">
                <span class="input-group-text">위치2</span>
                <input type="text" class="form-control"  name="asub_wichi2" value="<%=sja_sub_wichi2%>">
                
            </div>
        </div>
    </div>
    <!-- 세번째 줄 -->
    <div class="first-row">
        <div class="row px-3 w-100">
            <div class="input-group mb-0">
            <%
                If IsNull(sja_quan) Or Trim(sja_quan & "") = "" Or sja_quan  = 0  Then
                    sja_quan = 1
                End If
            %>
            <span class="input-group-text">수량</span>
            <input type="text" class="form-control" name="quan" value="<%=sja_quan%>">
            <%
                If rsjb_type_no >= 1 and rsjb_type_no >= 5 Then
                    if sja_qtyidx="" then
                        sja_qtyidx = 15
                    End if    
                End If

                Select Case sja_qtyidx
                    Case 5  ' AL/블랙
                        If sja_pidx = 306 Or sja_pidx = 1017 Or sja_pidx = 1193 Then
                            sja_pidx = sja_pidx
                        Else
                            sja_pidx = 1095  ' 블랙 도장 기본값
                        End If

                    Case 15 ' AL/실버
                        sja_pidx = 40   ' 실버 도장 자동 지정

                    Case Else
                        ' 그 외는 기존값 유지 (아무 것도 안함)
                End Select
            %>
            <span for="bendName" class="input-group-text">스텐재질</span>
            <select name="qtyidx" class="form-control" id="qtyidx"  onchange="handleChange_dataFormOriginal(this)">
                <option value="0" <% if sja_qtyidx="" then %>selected<% end if %>없음</option>
                    <%
                    SQL=" Select DISTINCT A.qtyidx, B.QTYNo ,B.qtyname " 
                    SQL=SQL&" From tk_qty A   "
                    SQL=SQL&" join tk_qtyco B on A.QTYNo=B.QTYNo  "
                    SQL=SQL&" Where B.qtyname<>'' and A.qtystatus='1' "
                    SQL=SQL&" Order by B.QTYNo ASC  "
                    'response.write(sql)
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF
                    qtyidx=Rs(0)
                    QTYNo=Rs(1)
                    qtyname=Rs(2)
                    %>
                                    <option value="<%=qtyidx%>" <% if clng(qtyidx)=clng(sja_qtyidx) then %> selected <% end if %> ><%=qtyname%></option>
      <%
                                            '스텐 제질 qtyno 가져오기'
                                            if clng(qtyidx)=clng(sja_qtyidx) then 
                                                    sqtyno = QTYNO
                                            End if
                                     %>                   
                    <%
                    Rs.movenext
                    Loop
                    End if
                    Rs.close
                    %>
            </select>  
            <% ' 👉 추가 : pidx로 pname 조회

                    SQL = ""
                    SQL = SQL & "SELECT "
                    SQL = SQL & "    P.pname, "
                    SQL = SQL & "    F.coat "
                    SQL = SQL & "FROM tk_framek F "
                    SQL = SQL & "LEFT JOIN tk_paint P ON F.pidx = P.pidx "
                    If rpidx = 0 Then
                        SQL = SQL & "WHERE F.pidx = '" & sja_pidx & "'"
                    Else
                        SQL = SQL & "WHERE F.pidx = '" & rpidx & "' "
                    End If
                    SQL = SQL & "AND F.fkidx = '" & rfkidx & "'"
                    'response.write(sql)
                    Rs2.open Sql,Dbcon
                    If Not (Rs2.EOF Or Rs2.BOF) Then
                        pname = Rs2(0)
                        coat = Rs2(1)
                    End If
                    Rs2.Close
                    Set Rs2 = Nothing

                
            
            %>
            <span for="bendName" class="input-group-text">도장재질</span>
            <input type="text" class="form-control" id="pname" value="<%=pname%>" readonly> <!-- name빠짐 단순 전송용-->
            <input type="hidden" id="pidx" name="pidx" value="<%=sja_pidx%>">

            <button type="button" class="btn btn-secondary"
                    onclick="window.open('/paint_color/picker.asp?sjidx=<%=rsjidx%>&pidx=<%=sja_pidx%>','paintPopup','width=950,height=680,scrollbars=yes,resizable=yes');">
            선택
            </button>
            <!-- setPaint함수가 실행되는 시점은 팝업창(paint_item_pop.asp) 안에서 선택 항목을 클릭했을 때 -->
            <script>
                function setPaint(pidx, pname, coat){
                    document.getElementById('pidx').value  = pidx;
                    document.getElementById('pname').value = pname;
                    const coatSelect = document.querySelector("select[name='coat']");
                    if (coatSelect) coatSelect.value = coat;
                    document.getElementById('dataForm_original').submit();
                }
            </script>
            
            <span class="input-group-text">코트</span>
            <select name="coat" class="form-select" onchange="handleChange_dataFormOriginalCoat(this)">
                <option value="0" <% If coat="0" Then Response.Write "selected" %>>❌</option>
                <option value="1"  <% If coat="1"  Then Response.Write "selected" %>>기본(2코트)</option>
                <option value="2"  <% If coat="2"  Then Response.Write "selected" %>>필수(3코트)</option>
            </select>
            
            <span class="input-group-text">비고1</span>
            <input type="text" class="form-control" name="asub_bigo1" value="<%=sja_sub_bigo1%>">
            <span class="input-group-text">비고2</span>
            <input type="text" class="form-control" name="asub_bigo2" value="<%=sja_sub_bigo2%>">
            <span class="input-group-text">비고3</span>
            <input type="text" class="form-control" name="asub_bigo3" value="<%=sja_sub_bigo3%>">
            <span class="input-group-text">추가사항1</span>
            <input type="text" class="form-control" name="asub_meno1" value="<%=sja_sub_meno1%>">
            <span class="input-group-text">추가사항2</span>
            <input type="text" class="form-control" name="asub_meno2" value="<%=sja_sub_meno2%>">
            </div>
        </div>
    </div>
        <button type="submit" id="hiddenSubmit1" style="display: none;"></button>
        </form>
    
                        
                        <%                      
                            ' 분할 및 기타 옵션 같은 작업을 실시 했을때 엔터 및 form 입력 값들 막기
                            hasData = False
                            rs_count = 0
                            sql_check = " SELECT count(*) "
                            sql_check = sql_check & " FROM tk_framekSub "
                            sql_check = sql_check & " where fkidx = '" &rfkidx & "' "
                            sql_check = sql_check & " and  rstatus = 2 "
                            sql_check = sql_check & " and  rstatus2 = 2 "
                            Rs.open sql_check ,dbcon
                                if not(Rs.EOF) Then 
                                    rs_count = Rs(0)
                                End if
                            Rs.close()

                            if(rs_count > 0) Then 
                                 hasData = True
                            Else 
                                hasData  = False
                            End if
                        '존재 한다면 enter 키 사용 불가 
                        
                        'rstatus = 2  rstatus2 = 2 존재 한다면 form 내용 입력 불가 엔터키 사용
                            
                        %>                   
                        <form id="dataForm" name="dataForm"  action="TNG1_B_suju_cal_quick.asp" method="POST" onkeydown="if(<%= LCase(CStr(hasData)) %>){  alert('삭제 후 사용 가능합니다.'); return false; }">

                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                var hasData = "<%= LCase(CStr(hasData)) %>" === "true";
                                if (!hasData) return;
                                var form = document.getElementById('dataForm');
                                if (!form) return;
                                var elements = form.querySelectorAll('input, select, textarea, button');
                                elements.forEach(function (el) {
                                        el.disabled = true;
                                });
                            });
                        </script>
                            <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                            <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                            <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                            <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>"> 
                            <input type="hidden" name="fksidx" value="<%=rfksidx%>">
                            <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                            <input type="hidden" name="coat" id="coat_hidden" value="<%=coat%>">
                            <input type="hidden" name="mode" value="quick">
                            <input type="hidden" name="mode2" id="mode2" value="">
 
                            <!-- 두 번째 줄 (가변 높이 3칸) 시작-->
                    <div class="second-row">
                        <div class="second-left-1"> <!-- 첫 번째 영역 -->
                            <div class="mb-2 d-flex align-items-center " >
                                <div >
                                    <% if rfkidx<>"" then %>
                                        <button class="btn btn-secondary  btn-small" type="button" Onclick="window.open('/documents/installationManual?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&SJB_TYPE_NO=<%=rSJB_TYPE_NO%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>','TNG1_B_doorpop','top=100 left=400 width=1000 height=800');">도어유리보기</button>
                                    <% end if%> 
                                </div>
                            </div>
                                <!-- 생성된 도면 정보 시작 -->
                                <div class="row">
                                    
                                    
                                        <%
                                        SQL = " Select doorglass_t , fixglass_t , dooryn ,doorchoice "
                                        SQL = SQL & " From tk_framek"
                                        SQL = SQL & " Where fkidx='"&rfkidx&"'  "
                                        'response.write (SQL)&"<br>"
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 

                                            zdoorglass_t=Rs(0)
                                            zfixglass_t=Rs(1)
                                            zdooryn=Rs(2)
                                            zdoorchoice=Rs(3)
                                        End if
                                        Rs.close
                                        %>
                                    <div class="input-group mb-2">  
                                        <select name="dooryn" class="form-control" id="dooryn"  onchange="handleChange_dataForm(this)">
                                            <option value="0" <% If clng(zdooryn) = "0" Then Response.Write "selected" %>>도어나중</option>
                                            <option value="1" <% If clng(zdooryn) = "1" Then Response.Write "selected" %>>도어같이</option>
                                            <option value="2" <% If clng(zdooryn) = "2" Then Response.Write "selected" %>>도어안함</option>
                                        </select>
                                        <select name="doorchoice" class="form-control" id="doorchoice"  onchange="handleChange_dataForm(this)">
                                            <option value="1" <% If clng(zdoorchoice) = "1" Then Response.Write "selected" %>>도어포함</option>
                                            <option value="2" <% If clng(zdoorchoice) = "2" Then Response.Write "selected" %>>도어별도</option>
                                            <option value="3" <% If clng(zdoorchoice) = "3" Then Response.Write "selected" %>>도어제외</option>
                                        </select>
                                        <button type="button"
                                            class="btn btn-outline-danger"
                                            style="writing-mode: horizontal-tb; letter-spa
                                            g: normal; white-space: nowrap;"
                                            onclick="location.replace('TNG1_B_suju_quick.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_type_no=<%=rsjb_type_no%>&sjb_idx=<%=rsjb_idx%>&mode=chuga');">추가견적
                                        </button>
                                    </div>
                                        <%
                                            Select Case clng(rsjb_type_no)
                                                Case 1,5,6 '도어12티 픽스 12티
                                                    door_depth = 12
                                                    fix_depth = 12
                                                Case 2,3,7,8,10,11,15 '도어24티 픽스 24티
                                                    door_depth = 24
                                                    fix_depth = 24
                                                Case 4  '도어24티 픽스 39티
                                                    door_depth = 24
                                                    fix_depth = 39
                                                Case 9 '도어24티 픽스 43티
                                                    door_depth = 24
                                                    fix_depth = 43
                                                Case 12 '도어43티 픽스 43티
                                                    door_depth = 43
                                                    fix_depth = 43
                                            End Select
                                            if zdoorglass_t="" or zdoorglass_t = 0 then
                                                zdoorglass_t = door_depth
                                            end if
                                            if zfixglass_t="" or zfixglass_t = 0 then
                                                zfixglass_t = fix_depth
                                            end if
                                        %>
                                    <div class="input-group mb-2" style="gap: 8px; align-items: center;">
                                        <span class="input-group-text py-0 px-1 small">도어유리</span>
                                        <input type="number" class="form-control" name="doorglass_t" value="<%=zdoorglass_t%>" onkeypress="handleKeyPress_dataForm(event, 'doorglass_t', 'doorglass_t')">
                                        <span class="input-group-text py-0 px-1 small">픽스유리</span>
                                        <input type="number" class="form-control" name="fixglass_t" value="<%=zfixglass_t%>" onkeypress="handleKeyPress_dataForm(event, 'fixglass_t', 'fixglass_t')">
                                    </div>   
                                    <div class="mb-2">
                                        <%
                                        SQL = " Select tw,th,ow,oh,fl,ow_m,fkidx,GREEM_F_A,GREEM_FIX_TYPE,greem_o_type "
                                        SQL = SQL & " From tk_framek "
                                        SQL = SQL & " Where fkidx='"&rfkidx&"' "
                                        'response.write (SQL)&"<br>"
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do while not Rs.EOF
                                            tw=Rs(0)
                                            th=Rs(1)
                                            ow=Rs(2)
                                            oh=Rs(3)
                                            fl=Rs(4)
                                            ow_m=Rs(5)
                                            fkidx=Rs(6)
                                            GREEM_F_A=Rs(7)
                                            GREEM_FIX_TYPE=Rs(8)
                                            greem_o_type=Rs(9)
                                            if fl="" or isnull(fl) then 
                                                fl = 0
                                            end if
                                        %>
                                        <div class="input-group mb-1">     
                                            <% 
                                            if clng(fkidx)=clng(rfkidx) then 
                                            %>
                                                <div style="display: flex; flex-wrap: wrap;">
                                                    <div class="row">
                                                        <div class="col-4">
                                                            <label>검측가로</label>
                                                            <input type="text" class="form-control" name="tw" value="<%=tw%>" placeholder="가로" onkeypress="handleKeyPress(event, 'tw', 'tw')">
                                                        </div>
                                                        <div class="col-4">
                                                            <label>검측세로</label>
                                                            <input type="text" class="form-control" name="th" value="<%=th%>" placeholder="세로" onkeypress="handleKeyPress(event, 'th', 'th')">
                                                        </div>
                                                        <script>
                                                            function handleKeyPress(e) {
                                                                if (e.key === 'Enter') {
                                                                    const val = e.target.value.trim();

                                                                    // 숫자, 연산자, 괄호, 공백, 소수점만 허용
                                                                    if (/^[0-9+\-*/().\s]+$/.test(val)) {
                                                                        try {
                                                                            const result = eval(val);
                                                                            if (!isNaN(result)) {
                                                                                e.target.value = result;
                                                                            } else {
                                                                                alert('잘못된 계산식입니다.');
                                                                            }
                                                                        } catch {
                                                                            alert('계산 오류: 수식을 확인하세요.');
                                                                        }
                                                                    } else {
                                                                        alert('잘못된 문자 입력입니다. (숫자, + - * / ( ) 만 허용)');
                                                                    }
                                                                }
                                                            }
                                                        </script>
                                                    <% if GREEM_F_A = 2  or ( GREEM_F_A = 1 and ( GREEM_FIX_TYPE = 15 or GREEM_FIX_TYPE = 34 ) ) then 'GREEM_F_A=2(자동) , GREEM_F_A=1(수동)%>
                                                        <div class="col-4">
                                                            <label>오픈가로</label>
                                                            <input type="number" class="form-control" name="ow" value="<%=ow%>" placeholder="오픈가로" onkeypress="handleKeyPress(event, 'ow', 'ow')">
                                                        </div>
                                                <% end if %>  
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">  
                                                            <label>도어높이</label>
                                                            <input type="number" class="form-control" name="oh" value="<%=oh%>" placeholder="오픈세로" onkeypress="handleKeyPress(event, 'oh', 'oh')">
                                                        </div>
                                                        <div class="col-4">  
                                                            <label>묻힘</label>
                                                            <input type="number" class="form-control" name="fl" value="<%=fl%>" placeholder="묻힘" onkeypress="handleKeyPress(event, 'fl', 'fl')">
                                                        </div>   
                                                    <% if GREEM_F_A = 2  or ( GREEM_F_A = 1 and ( GREEM_FIX_TYPE = 15 or GREEM_FIX_TYPE = 34 ) ) then 'GREEM_F_A=2(자동) , GREEM_F_A=1(수동)%>
                                                        <div class="col-4"> 
                                                            <label>지정오픈</label>
                                                            <input type="number" 
                                                            class="form-control" 
                                                            name="ow_m" 
                                                            value="<%=ow_m%>" 
                                                            placeholder="수기!!" 
                                                            title="오픈 초기화시 0 을 입력하세요" 
                                                            onkeypress="handleKeyPress(event, 'ow_m', 'ow_m')">                                   
                                                        </div>
                                                    <% end if %>   
                                                    </div>   
                                                    <% 
                                                        'inspector_v5에 넘어갈 검측가로 와 검측 세로 값'
                                                        ins_tw = tw
                                                        ins_th = th
                                                    %>
                                                    <div class="row mt-2">
                                                            <% if GREEM_F_A=2 then %>
                                                        <!-- 가로: 오픈으로 외경 구하기 -->
                                                        <div class="col-4">
                                                            <input type="number" class="form-control" name="op_tw" value="<%=op_tw%>" title="오픈치수로 외경구하기" placeholder="오픈으로외경" onkeypress="handleKeyPress(event, 'op_tw', 'op_tw')">
                                                            <style>
                                                                input[name="op_tw"]::placeholder {
                                                                    color: red;
                                                                    font-size: 0.6em;  /* 🔽 글씨 작게 */
                                                                    opacity: 1; /* 일부 브라우저에서 연하게 나오지 않도록 */
                                                                }
                                                            </style>
                                                        </div>
                                                        <!-- 세로: 오픈으로 외경 구하기 -->
                                                        <div class="col-4">
                                                        <% if greem_o_type = 1 or greem_o_type = 4 then %>
                                                            <input type="number" class="form-control" name="dh_th" value="<%=dh_th%>" title="도어높이로 외경구하기" placeholder="도어높이외경" onkeypress="handleKeyPress(event, 'dh_th', 'dh_th')">
                                                            <style>
                                                                input[name="dh_th"]::placeholder {
                                                                    color: red;
                                                                    font-size: 0.6em;  /* 🔽 글씨 작게 */
                                                                    opacity: 1; /* 일부 브라우저에서 연하게 나오지 않도록 */
                                                                }
                                                            </style>
                                                        <% end if %>
                                                        </div>
                                                        <div class="col-4">
                                                        <% if greem_o_type = 4 or greem_o_type = 5 or greem_o_type = 6 then %>
                                                            <input type="number" class="form-control" name="opt_habar1" value="<%=opt_habar1%>" title="언발란스 양개일 때 좌측하바 치수를 입력하세요"  placeholder="언발란스양개" onkeypress="handleKeyPress(event, 'opt_habar1', 'opt_habar1')">
                                                            <style>
                                                                input[name="opt_habar1"]::placeholder {
                                                                    color: red;
                                                                    font-size: 0.6em;  /* 🔽 글씨 작게 */
                                                                    opacity: 1; /* 일부 브라우저에서 연하게 나오지 않도록 */
                                                                }
                                                            </style>
                                                        <% end if %>
                                                        </div>
                                                        <% end if %>
                                                    </div> 
                                                </div>   
                                            <% else %>
                                                <input class="form-control" type="number" value="<%=tw%>" onclick="location.replace('TNG1_B_suju_quick.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                            
                                                <input class="form-control" type="number" value="<%=th%>" onclick="location.replace('TNG1_B_suju_quick.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                        
                                                <% if GREEM_F_A = 2 then 'GREEM_F_A=2(자동) , GREEM_F_A=1(수동)%>
                                                <input class="form-control" type="number" value="<%=ow%>" onclick="location.replace('TNG1_B_suju_quick.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                          
                                                <% end if %>  
                                                <input class="form-control" type="number" value="<%=oh%>" onclick="location.replace('TNG1_B_suju_quick.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                      
                                                <input class="form-control" type="number" value="<%=fl%>" onclick="location.replace('TNG1_B_suju_quick.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                      
                                                <% if GREEM_F_A = 2 then 'GREEM_F_A=2(자동) , GREEM_F_A=1(수동)%>
                                                <input class="form-control" type="number" value="<%=ow_m%>" onclick="location.replace('TNG1_B_suju_quick.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                      
                                                <% end if %>  
                                            <% end if %>
                                        </div>
                                            <%
                                                tw=""
                                                th=""
                                                ow=""
                                                oh=""
                                                fl=""
                                                ow_m=""
                                                GREEM_F_A=""
                                                GREEM_FIX_TYPE=""
                                                greem_o_type=""
                                                Rs.movenext
                                                Loop
                                                End if
                                                Rs.close
                                            %>   
                                    </div>
                                        <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                                    </form>
                                    <div class="input-group mb-2">
                                        <table class="table">
                                            <thead>
                                                <th class="text-center"></th>
                                                <th class="text-center">기본</th>
                                                <th class="text-center">평 추가</th>
                                                <th class="text-center">
                                                    <div class="dropdown-header" 
                                                        style="cursor:pointer; display:inline-block; margin-left:5px; color:#0d6efd; font-weight:bold;"
                                                        onclick="toggleDropdown(2)">
                                                        추가<br>자재
                                                    </div>
                                                </th>
                                                <th class="text-center">도어</th>
                                                <th class="text-center">총합계</th>
                                            </thead>
                                            <tbody  class="table-group-divider">
                                                <%
                                                SQL = "SELECT a.fkidx, a.sjsprice, a.py_chuga, a.doorchoice  "
                                                SQL = SQL & " , (SELECT SUM(door_price)  "
                                                SQL = SQL & "  FROM tk_framekSub b "
                                                SQL = SQL & "  WHERE b.fkidx = a.fkidx "
                                                SQL = SQL &" and b.doortype in (0,1,2) ) " '도어 타입 (1:편개, 2:양개) 
                                                SQL = SQL & " ,a.chuga_jajae ,a.fprice "
                                                SQL = SQL & "FROM tk_framek a "
                                                SQL = SQL & "WHERE a.fkidx = '" & rfkidx & "'"
                                                'Response.write (SQL)&"<br>"
                                                Rs.open Sql,Dbcon
                                                If Not (Rs.bof or Rs.eof) Then 

                                                    tfkidx=Rs(0)
                                                    sjsprice=Rs(1)
                                                    py_chuga=Rs(2)
                                                    doorchoice=Rs(3)
                                                    door_price=Rs(4)
                                                    chuga_jajae=Rs(5)
                                                    fprice=Rs(6)
                                                    i=i+1 

                                                    If IsNull(door_price) Then door_price = 0

                                                    gibonprice = sjsprice -  py_chuga     
                                                    '도어 제외 일때  
                                                     if doorchoice = 3 then 
                                                        gibonprice  = gibonprice  + Abs(door_price) '도어 포함 원가 가져오기
                                                        
                                                    ENd if

                                                    if rsjb_type_no >= 1 and rsjb_type_no <= 5 then
                                                        'if doorchoice="3" then  ' 도어제외 견적
                                                        '    sjsprice_total =  fprice - door_price
                                                        'else
                                                            sjsprice_total =   gibonprice + door_price + py_chuga
                                                        'end if
                                                    else 
                                                        
                                                        sjsprice_total =  gibonprice + door_price + py_chuga

                                                    end if
                                                %>
                                            <tr <% if clng(tfkidx)=clng(rfkidx) then %>class="table-warning" <% end if %>>
                                                <td class="text-center"><%=i%></td> 
                                                <td class="text-center"><%=FormatNumber(gibonprice, 0, -1, -1, -1)%></td>
                                                <td class="text-center"><%=FormatNumber(py_chuga, 0, -1, -1, -1)%></td>
                                                <td class="text-center"><%=FormatNumber(chuga_jajae, 0, -1, -1, -1)%></td>
                                                <td class="text-center"><%=FormatNumber(door_price, 0, -1, -1, -1)%></td>
                                                <td class="text-center"><%=FormatNumber(sjsprice_total, 0, -1, -1, -1)%></td>  
                                            </tr>
                                                <%
                                            
                                                End if
                                                Rs.close
                                                %> 
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="input-group mb-2">
                                        <table class="table">
                                            <thead>
                                                <th class="text-center"></th>
                                                <th class="text-center">재분</th>
                                                <th class="text-center">로비폰</th>
                                                <th class="text-center">보양재</th>
                                                <th class="text-center">하부레일</th>
                                            </thead>
                                            <tbody  class="table-group-divider">
                                                <%
                                                SQL="Select jaeryobunridae,robby_box,boyangjea,fkidx,whaburail "
                                                SQL=SQL&" from tk_framek  "
                                                SQL=SQL&" Where fkidx='"&rfkidx&"' "
                                                'Response.write (SQL)&"<br>"
                                                Rs.open Sql,Dbcon
                                                If Not (Rs.bof or Rs.eof) Then 
                                            
                                                    jaeryobunridae=Rs(0)
                                                    robby_box=Rs(1)
                                                    boyangjea=Rs(2)
                                                    ufkidx=Rs(3)
                                                    whaburail=Rs(4)
                                                    i=i+1               
                                                %>
                                            <tr <% if clng(ufkidx)=clng(rfkidx) then %>class="table-warning" <% end if %>>
                                                <td class="text-center"><%=i%></td> 

                                                <td class="text-center">
                                                <% If IsNumeric(jaeryobunridae) Then %>
                                                    <%=FormatNumber(jaeryobunridae, 0, -1, -1, -1)%>
                                                <% Else %>
                                                    -
                                                <% End If %>
                                                </td>

                                                <td class="text-center">
                                                <% If IsNumeric(robby_box) Then %>
                                                    <%=FormatNumber(robby_box, 0, -1, -1, -1)%>
                                                <% Else %>
                                                    -
                                                <% End If %>
                                                </td>

                                                <td class="text-center">
                                                <% If IsNumeric(boyangjea) Then %>
                                                    <%=FormatNumber(boyangjea, 0, -1, -1, -1)%>
                                                <% Else %>
                                                    -
                                                <% End If %>
                                                </td>

                                                <td class="text-center">
                                                <% If IsNumeric(whaburail) Then %>
                                                    <%=FormatNumber(whaburail, 0, -1, -1, -1)%>
                                                <% Else %>
                                                    -
                                                <% End If %>
                                                </td>
                                            </tr>

                                                <%
                                            
                                                End if
                                                Rs.close
                                                
                                                %> 
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <!-- 생성된 도면정보 끝 -->
                                </div>    
                            <!-- 두 번째 줄 (가변 높이 3칸) 끝--> 
                        </div>  
                        <div class="second-row">    
                            <div class="second-flex-grow"> <!-- 가운데 SVG 영역 -->  
                                <!-- 두번째 줄 두 번째 칸 시작 -->
                                    <div class="canvas-container" id="svgCanvas" style="width: 100%; height: 100%; padding: 0px;">
                                        <div class="svg-container" style="width: 100%; height: 100%; padding: 0px;">
                                            <svg id="canvas" width="100%" height="100%" class="d-block">
                                            <g id="viewport" transform="translate(0, 0) scale(1)">
                                            
                                                <%
                                                y1_blength=""
                                                SQL = "SELECT A.fkidx, B.fksidx, B.xi, B.yi, B.wi, B.hi"
                                                SQL = SQL & ", C.set_name_FIX, C.set_name_AUTO, A.sjb_idx, b.fstype, b.blength"
                                                SQL = SQL & ", B.WHICHI_FIX, B.WHICHI_AUTO, D.glassselect, E.glassselect "
                                                SQL = SQL & ", B.door_w, B.door_h , B.glass_w, B.glass_h, B.ysize,b.doortype ,a.sjb_type_no ,b.alength"
                                                SQL = SQL & " FROM tk_framek A"
                                                SQL = SQL & " LEFT OUTER JOIN tk_framekSub B ON A.fkidx = B.fkidx"
                                                SQL = SQL & " LEFT OUTER JOIN tk_barasiF C ON B.bfidx = C.bfidx"
                                                SQL = SQL & " LEFT OUTER JOIN tng_whichitype D ON B.WHICHI_FIX = D.WHICHI_FIX "
                                                SQL = SQL & " LEFT OUTER JOIN tng_whichitype E ON B.WHICHI_AUTO = E.WHICHI_AUTO"
                                                SQL = SQL & " WHERE A.sjidx = '" & rsjidx & "' AND A.sjsidx = '" & rsjsidx & "' "
                                                SQL = SQL & " and b.whichi_auto not in (2,24,26,27,28,29) " 'whichi_auto=2 박스커버 ,24=오사이
                                                SQL = SQL & " and b.xi <> 0 "
                                                'Response.write (SQL)&"<br>"
                                                'response.end
                                                Rs.open Sql,Dbcon
                                                If Not (Rs.bof or Rs.eof) Then 
                                                Do while not Rs.EOF
                                                    i = i + 1
                                                    fkidx         = Rs(0)
                                                    fksidx        = Rs(1)
                                                    xi            = Rs(2)
                                                    yi            = Rs(3)
                                                    wi            = Rs(4)
                                                    hi            = Rs(5)
                                                    set_name_FIX  = Rs(6)
                                                    set_name_AUTO = Rs(7)
                                                    sjb_idx       = Rs(8)
                                                    fstype        = Rs(9)
                                                    yblength      = Rs(10)
                                                    whichi_fix    = Rs(11)
                                                    whichi_auto   = Rs(12)
                                                    glassselect_fix   = Rs(13)
                                                    glassselect_auto   = Rs(14)
                                                    door_w            = Rs(15)
                                                    door_h            = Rs(16)
                                                    glass_w = Rs(17)
                                                    glass_h = Rs(18)
                                                    ysize = Rs(19)
                                                    doortype = Rs(20)
                                                    sjb_type_no = Rs(21)
                                                    alength = Rs(22)

                                                    fksidx_str = CStr(fksidx)   ' 숫자를 문자열로 변환
                                                    fksidx_last3 = Right(fksidx_str, 3) '케빈 자재 숫자찾기
                                                    

                                                    if rfksidx="" then 
                                                        rfksidx="0" 
                                                    end if

                                                    'response.write "rfksidx:"&rfksidx&"/<br>"
                                                    'response.write "fksidx:"&fksidx&"/<br>"

                                                        if clng(fksidx)=clng(rfksidx) then 
                                                            stroke_text="#696969"
                                                            fill_text="#BEBEBE"
                                                        else
                                                            if clng(fkidx)=clng(rfkidx) then 
                                                                if fstype="1" then '유리라면
                                                                    stroke_text="#779ECB"
                                                                    fill_text="#ADD8E6"
                                                                else 
                                                                    stroke_text="#D3D3D3"
                                                                    fill_text="#EEEEEE"
                                                                end if
                                                            else
                                                                if fstype="1" then '유리라면
                                                                stroke_text="#779ECB"
                                                                fill_text="#ADD8E6"
                                            
                                                                else 
                                                                    stroke_text="#A9A9A9"
                                                                    fill_text="white"
                                                                end if 
                                                            end if
                                                        end if
                                                   
                                                    if WHICHI_AUTO<>"" and WHICHI_FIX=0 then

                                                        If clng(glassselect_auto) = 0 Then '자재는 ysize, blength 이게 A.length 구분 반전 0이 디폴트
                                                                                                'a= 가로 b= 세로
                                                            If clng(WHICHI_AUTO) = 21 Then
                                                                fill_text = "#FFC0CB" ' 재료분리대 우선
                                                            ElseIf clng(WHICHI_AUTO) = 20 Then
                                                                fill_text = "#FA8072" ' 하부레일        
                                                            Else
                                                                fill_text = "#DCDCDC" ' 회색
                                                            End If

                                                            if WHICHI_FIX<>"" and WHICHI_AUTO=9 then
                                                                fill_text = "#FA8072" ' 픽스상부오사이
                                                            end if
                                                            if WHICHI_FIX<>"" and WHICHI_AUTO=25 then
                                                                fill_text = "#FA8072" ' t형_자동홈바
                                                            end if

                                                        ElseIf clng(glassselect_auto) = 1 Then
                                                            fill_text = "#cce6ff" ' 투명 파랑 외도어
                                                        ElseIf clng(glassselect_auto) = 2 Then
                                                            fill_text = "#ccccff"   ' 파랑 양개도어 (코드 누락 있음: #ccccff 등으로 수정 권장)
                                                        ElseIf clng(glassselect_auto) = 3 Then
                                                            fill_text = "#FFFFE0" ' 유리
                                                        ElseIf clng(glassselect_auto) = 4 Then
                                                            fill_text = "#FFFF99" ' 상부남마유리
                                                        ElseIf clng(WHICHI_AUTO) = 21 Then
                                                            fill_text = "#FFC0CB" ' 재료분리대 보조조건
                                                        End If
                                                        
                                                    End If
                            
                                                    if WHICHI_FIX<>"" and WHICHI_AUTO=0 then

                                                        If clng(glassselect_fix) = 0 Then
                                                            If clng(WHICHI_FIX) = 24 Then
                                                                fill_text = "#FFC0CB" ' 재료분리대 우선
                                                            Else
                                                                fill_text = "#DCDCDC" ' 회색
                                                            End If
                                                        ElseIF clng(glassselect_fix) = 1 Then
                                                            fill_text = "#cce6ff" ' 투명 파랑 외도어
                                                        ElseIF clng(glassselect_fix) = 2 Then
                                                            fill_text = "#ccccff" '  파랑 양개도어
                                                        ElseIF clng(glassselect_fix) = 3 Then
                                                            fill_text = "#FFFFE0" '  유리
                                                        ElseIF clng(glassselect_fix) = 4 Then
                                                            fill_text = "#FFFF99" '  상부남마유리 
                                                        ElseIF clng(glassselect_fix) = 5 Then
                                                            fill_text = "#CCFFCC" '  박스라인하부픽스유리   
                                                        ElseIF clng(glassselect_fix) = 6 Then
                                                            fill_text = "#CCFFCC" '  박스라인상부픽스유리  
                                                        End If

                                                    End If

                                                    select case doortype
                                                        case 0 
                                                            doortype_text = "없음"
                                                        case 1 
                                                            doortype_text = "좌도어"
                                                        case 2  
                                                            doortype_text = "우도어"
                                                    end select 

                                                if clng(hi) > clng(wi) then 
                                                    text_direction="writing-mode: vertical-rl; glyph-orientation-vertical: 0;"
                                                    else
                                                    text_direction=""
                                                end if 
                                                'Response.write (glassselect_auto)&"--   glassselect_auto<br>"
                                                'response.write (glassselect_fix)&" ---  glassselect_fix<br>"
                                                'response.write (door_w)&" ---  door_w<br>"
                                                'Response.write (SQL)&"<br>"
                                                %>
                                            <% 
                                            
                                            'yblength(실값 가로) ysize(실값 세로)
                                            'wi(정한값 가로) hi(정한값 세로)
                                            ' 1. 비율
                                            ' 2. 
                                            ' 예: 계산된 값을 바로 CLng으로 

                                    
                                            if fstype="2" then %>
                                                <defs>
                                                <pattern id="diagonalHatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
                                                    <line x1="0" y1="0" x2="0" y2="8" stroke="black" stroke-width="2" />
                                                </pattern>
                                                </defs>
                                                <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="url(#diagonalHatch)" stroke="black" stroke-width="2" 
                                                onclick="location.replace('TNG1_B_suju_quick.asp?sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=fkidx%>&sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&fksidx=<%=fksidx%>');" data-value="id=<%=fksidx%>;width=<%=yblength%>;height=<%=ysize%>;"/> 
                                     
                                            <% else%>
                                                <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" 
                                                fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1"
                                                onclick="window.open(
                                                    'inspector_v5.asp?sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=fkidx%>&sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&fksidx=<%=fksidx%>&greem_f_a=<%=rgreem_f_a%>&tw=<%=ins_tw%>&th=<%=ins_th%>&qtyno=<%=sqtyno%>'
                                                    ,'inspector_v5','top=100 left=400 width=570 height=800');"
                                                data-value="id=<%=fksidx%>;width=<%=yblength%>;height=<%=ysize%>;"/>
                                            <% end if %>
                                            <% if request("new_open")="start" then %>
                                                <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1" 
                                                onclick="location.replace('TNG1_B_suju_quick.asp?sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=fkidx%>&sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&fksidx=<%=fksidx%>&new_open=go');" data-value="id=<%=fksidx%>;width=<%=yblength%>;height=<%=ysize%>;"/>
                                            <% end if %>
                                            <%
                                                ' 중심 좌표 계산
                                                centerX = xi + (wi / 2)
                                                centerY = yi + (hi / 2)
                                                
                                                If (glassselect_auto = 0) Or (glassselect_fix = 0) Then
                                                    y1_blength = yblength
                                                ElseIf (glassselect_auto >= 3) Or (glassselect_fix >= 3) Then
                                                    y1_blength = alength & "×" & yblength
                                                ElseIf (glassselect_auto = 1 Or glassselect_auto = 2) Or (glassselect_fix = 1 Or glassselect_fix = 2) Then
                                                    y1_blength = door_w & "×" & door_h

                                                End If  
                                            %>
                                            <%
                                            y = yi + (hi / 2) + 4   ' 폰트 높이 보정용
                                            centerX = xi + (wi / 2)
                                            centerY = yi + (hi / 2) + 4 ' 폰트 높이에 따라 조정
                                            %>
                                                <% if whichi_auto = 21 or whichi_fix = 24 then ' 재료분리대 %> 
                                                <text x="<%=centerX%>" y="<%=centerY%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="15" fill="#000000" style="<%=text_direction%>">재료분리대</text>
                                                <% elseif whichi_auto = 20 then '히부레일 %>
                                                <text x="<%=centerX%>" y="<%=centerY%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="15" fill="#000000" style="<%=text_direction%>">하부레일 : <%=yblength%></text>
                                                <% elseif whichi_auto = 23 or whichi_fix = 25 then ' 로비폰박스 %>
                                                    <%
                                                    SQL="select a.ysize,a.fl,a.xsize from tk_framekSub a "
                                                    sql=sql&" join tk_framek b on  a.fkidx = b.fkidx "
                                                    sql=sql&" where b.fkidx='"&rfkidx&"' "
                                                    sql=sql&" and (a.whichi_auto=23 or a.whichi_fix=25 )"
                                                    'Response.write (SQL)&"<br>로비폰박스 높이 알아내기<br>"
                                                    Rsc.open Sql,Dbcon
                                                    If Not (Rsc.bof or Rsc.eof) Then 
                                                        robby_ysize=Rsc(0) '로비폰박스높이
                                                        robby_fl=Rsc(1) '로비폰박스하부기준
                                                        robby_xsize=Rsc(2) '로비폰박스 두께
                                                    End if
                                                    Rsc.Close
                                                    %>
                                                <text x="<%=centerX%>" y="<%=centerY%>" text-anchor="middle" alignment-baseline="middle"
                                                    font-family="Arial" font-size="10" fill="#000000" style="<%=text_direction%>">
                                                <tspan x="<%=centerX%>" dy="-0.4em">로비폰박스: <%=robby_xsize%>*<%=robby_ysize%>*<%=yblength%></tspan>
                                                <tspan x="<%=centerX%>" dy="1.2em">하부기준 센터:⇧<%=robby_fl%></tspan>
                                                </text>
                                                <% else %>
                                                <text x="<%=centerX%>" y="<%=centerY%>" 
                                                    text-anchor="middle" alignment-baseline="middle" 
                                                    font-family="Arial" font-size="15" fill="#000000" style="<%=text_direction%>">

                                                <tspan font-size="15" font-weight="bold" fill="red"><%=fksidx_last3%></tspan>
                                                <tspan font-size="8" font-weight="bold" fill="red">👈</tspan>
                                                <tspan><%=y1_blength%></tspan>

                                                </text>
                                                <% end if %>
                                                <% if whichi_auto = 12 or whichi_auto = 13 or whichi_fix = 12 or  whichi_fix = 13 then ' 도어방향 좌도어 우도어 %>
                                                    <text x="<%=centerX%>" y="<%=centerY-70%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="30" fill="#000000" font-weight="bold" style="writing-mode: horizontal-tb;"><%=doortype_text%></text>
                                                <% end if %>
                                                <%
                                                Rs.movenext
                                                Loop
                                                End if
                                                Rs.close
                                                %>   
                                            </g>    
                                            </svg>
                                        </div>
                                    </div>
                                <!-- 두번째 줄 두 번째 칸 끝 -->
                            </div>  
                        </div>    
    
                    </div>
    
    <!-- 세 번째 줄 (200px 고정) -->
    <div class="third-row">
        <div class="col-2">
            <div class="fixed-width">
            <!--
                <div style="display: flex; gap: 8px; margin-top: 10px;">
                    <form id="dataForm1" name="dataForm1"  action="TNG1_B_suju_alprice.asp" method="POST" >  
                        <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                        <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                        <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                        <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                        <input type="hidden" name="qtyidx" value="<%=zqtyidx%>">
                        <input type="hidden" name="pidx" value="<%=pidx%>">
                        <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
                        <div>
                            <button class="btn btn-secondary " type="button" onclick="submit();" >평당 단가적용</button>
                        </div>
                    </form>   
                    <form id="dataForm2" name="dataForm2"  action="TNG1_B_suju_stprice.asp" method="POST" >                   
                        <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                        <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                        <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                        <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                        <input type="hidden" name="qtyidx" value="<%=zqtyidx%>">
                        <input type="hidden" name="pidx" value="<%=pidx%>">
                        <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">

                        <div>
                            <button class="btn btn-secondary " type="button" onclick="submit();" >미터당 단가적용</button>
                        </div>
                    </form>   
                </div>
            -->    
                <!-- 두번째 줄 세 번째 칸 시작 -->
                    <div>
                        <% if rfkidx<>"" then %>
                            <button class="btn btn-success btn-sm" type="button" Onclick="window.open('TNG1_B_doorhchg.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&SJB_TYPE_NO=<%=rSJB_TYPE_NO%>&mode=quick','doorchg','top=100 left=400 width=500 height=400,scrollbars=yes,resizable=yes');">기타옵션</button>
                        
                            <button class="btn btn-secondary  btn-sm" type="button" Onclick="window.open('TNG1_B_doorpop.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&SJB_TYPE_NO=<%=rSJB_TYPE_NO%>','TNG1_B_doorpop','top=100 left=400 width=1000 height=800');">도어수정</button>

                            <form id="meter_price" name="meter_price"  action="TNG1_B_suju_stprice.asp" method="POST" style="display:inline;" >                   
                                <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                                <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                                <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                                <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>"> 
                                <input type="hidden" name="fksidx" value="<%=rfksidx%>">
                                <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                                <input type="hidden" name="pidx" value="<%=pidx%>">
                                <input type="hidden" name="qtyidx" value="<%=zqtyidx%>">
                                <input type="hidden" name="mode" value="quick">  
                                <input type="hidden" name="meter_price" value="meter_price">   

                                
                                    <button class="btn btn-secondary btn-sm " type="button" onclick="submit();" >미터단가</button>
                               
                            </form> 
                        <% end if%> 
                               
                                <button type="button"
                                    class="btn btn-outline-danger btn-sm"
                                    style="white-space: nowrap;"
                                    onclick="(async () => {
                                        try {

                                            // -----------------------------
                                            // 1️⃣ 첫 번째 URL : 발주서 저장
                                            // -----------------------------
                                            const url1 = '/TNG1/TNG1_B_baljuDB.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>';
                                            console.log('📡 요청1:', url1);

                                            let success1 = false;
                                            try {
                                                const resp1 = await fetch(url1, { method: 'GET', cache: 'no-cache' });
                                                const text1 = await resp1.text();
                                                console.log('📡 응답1 상태:', resp1.status);
                                                console.log('📩 응답1 내용:', text1);

                                                if (resp1.ok) {
                                                    success1 = true;
                                                    alert('✅ 발주서 저장 완료');
                                                } else {
                                                    alert('⚠️ 발주서 저장 실패: ' + resp1.status);
                                                }
                                            } catch (e1) {
                                                alert('❌ 발주서 저장 중 에러 발생');
                                                console.error(e1);
                                            }


                                            // -----------------------------
                                            // 2️⃣ 두 번째 URL : WMS 생성
                                            // -----------------------------
                                            const url2 = '/TNG_WMS/TNG_WMS_Create.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>';
                                            console.log('📡 요청2:', url2);

                                            let success2 = false;
                                            try {
                                                const resp2 = await fetch(url2, { method: 'GET', cache: 'no-cache' });
                                                const text2 = await resp2.text();
                                                console.log('📡 응답2 상태:', resp2.status);
                                                console.log('📩 응답2 내용:', text2);

                                                if (resp2.ok) {
                                                    success2 = true;
                                                    alert('✅ WMS 생성 완료');
                                                } else {
                                                    alert('⚠️ WMS 생성 실패: ' + resp2.status);
                                                }
                                            } catch (e2) {
                                                alert('❌ WMS 생성 중 에러 발생');
                                                console.error(e2);
                                            }


                                            // -----------------------------
                                            // 3️⃣ 두 URL 모두 실행 후 리다이렉트
                                            // -----------------------------
                                            const backUrl =
                                                'TNG1_B.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&money_reset=0';

                                            console.log('🔄 리다이렉트 이동:', backUrl);

                                            if (window.opener && !window.opener.closed) {
                                                window.opener.location.href = backUrl;
                                                window.close();
                                            } else {
                                                location.href = backUrl;
                                            }

                                        } catch (e) {
                                            console.error('❌ 전체 오류:', e);
                                            alert('❌ 처리 중 오류 발생 (콘솔 확인)');
                                        }
                                    })()">
                                    견적완료
                                </button>


                                <button type="button"
                                        class="btn btn-outline-danger btn-sm"
                                        style="white-space: nowrap;"
                                        onclick="window.open('/TNG1/TNG1_B_baljuDB.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>', '_blank');">
                                개발중
                                </button>

                    </div> 
                <form id="dataForm3" name="dataForm3"  action="TNG1_B_jaebun.asp" method="POST" onsubmit="return checkFlBeforeSubmit();" >                   
                    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                    <input type="hidden" name="qtyidx" value="<%=zqtyidx%>">
                    <input type="hidden" name="pidx" value="<%=pidx%>">
                    <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
                    <input type="hidden" name="mode" value="quick">
                <div>
                    <button class="btn btn-secondary" type="submit" style="display: none;">재료분리대</button>
                </div>
                <div class="row">
                    <!-- 좌측: 재분 -->
                    <div class="col-md-6" style="border: 1px solid #444; box-sizing: border-box;">
                        <fieldset class="p-3">
                            <legend class="fs-5 fw-bold">재분</legend>
                            <%
                                SQL = "SELECT jaeryobunridae_type "
                                SQL = SQL & "FROM tk_framek  "
                                SQL = SQL & "WHERE fkidx = '" & rfkidx & "'"
                                'Response.write (SQL)&"<br>"
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                
                                    jaeryobunridae_type=Rs(0) '1재분 2재분갈바보양

                                end if
                                rs.close

                                if rjaebun="" or IsNull(rjaebun) then
                                    rjaebun = 0
                                end if
                            %> 
                            <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="jaebun" value="1" id="jaebun" style="width: 20px; height: 20px;"
                                <% If  clng(jaeryobunridae_type) = 1 Then Response.Write "checked" %>>
                            <label class="form-check-label" for="jaebun1">재분</label>
                            </div>

                            <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="jaebun" value="0" id="jaebun" style="width: 20px; height: 20px;"
                                <% If clng(jaeryobunridae_type) = 0 Then Response.Write "checked" %>>
                            <label class="form-check-label" for="jaebun0">재분 없음</label>
                            </div>

                            <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="jaebun" value="2" id="jaebun" style="width: 20px; height: 20px;"
                                <% If clng(jaeryobunridae_type) = 2 Then Response.Write "checked" %>>
                            <label class="form-check-label" for="jaebun2" style="white-space: nowrap;">재분_보강</label>
                            </div>
                        </fieldset>
                    </div>
                    </form>
                    <!-- 우측: 보양 -->
                    <div class="col-md-6" style="border: 1px solid #444; box-sizing: border-box;">
                        <form id="dataForm4" name="dataForm4" action="TNG1_B_boyang.asp" method="POST" onsubmit="return checkFlBeforeSubmit();" >
                        <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                        <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                        <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                        <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                        <input type="hidden" name="qtyidx" value="<%=zqtyidx%>">
                        <input type="hidden" name="pidx" value="<%=pidx%>">
                        <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
                        <input type="hidden" name="mode" value="quick">
                        <div>
                            <button class="btn btn-secondary" type="submit" style="display: none;">보양</button>
                        </div>
                        <fieldset class="p-3">
                            <legend class="fs-5 fw-bold">보양</legend>
                            <%
                                SQL = "SELECT boyangjea "
                                SQL = SQL & "FROM tk_framek  "
                                SQL = SQL & "WHERE fkidx = '" & rfkidx & "'"
                                'Response.write (SQL)&"<br>"
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                
                                    boyangjea=Rs(0) '1재분 2재분갈바보양

                                end if
                                rs.close

                                if boyangjea > 0  then
                                    boyangjea_type = 1
                                else
                                    boyangjea_type = 0
                                end if
                                
                            %> 

                            <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="boyang" value="1" id="boyang" style="width: 20px; height: 20px;"
                                <% If clng(boyangjea_type) = 1 Then Response.Write "checked" End If %>>
                            <label class="form-check-label" for="boyang1">보양</label>
                            </div>

                            <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="boyang" value="0" id="boyang" style="width: 20px; height: 20px;"
                                <% If clng(boyangjea_type) = 0 Then Response.Write "checked" End If %>>
                            <label class="form-check-label" for="boyang0">보양없음</label>
                            </div>
                        </fieldset>
                    </form>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12" style="border: 1px solid #444; box-sizing: border-box;">
                        <div class="button-grid">
                            <%
                            'if rni="" then rni="0" end if '오류방지를 위해 수신된 순번값 rni변수 0으로 초기화
                            SQL="Select setstd from tk_framek where fkidx='"&rfkidx&"' "
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                            setstd=Rs(0)
                            End if
                            Rs.Close
                            
                            SQL="select count(*) from tk_framek where sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"'"
                            Rs.open Sql,Dbcon
                            cntni=Rs(0)
                            Rs.close

                            For ni = 1 to cntni
                            
                            if clng(setstd)=clng(ni) then 
                                class_text="<u>정렬["&ni&"]번</u>"
                            else
                                class_text="정렬["&ni&"]번"
                            end if
                            %>  
                                <button type="button" class="btn btn-secondary" onclick="setstd('<%=ni%>','<%=rfkidx%>');"><%=class_text%></button>
                            <%
                            Next
                            %> 
                            <button type="button" class="btn btn-secondary" onclick="framedel('<%=rfkidx%>');">프레임삭제</button> 
                            <!-- 사용안함 
                            <button type="button" class="btn btn-secondary" onclick="bardel('<%=rfksidx%>');">바삭제</button> 
                            -->
                        </div>
                    </div>
                </div>
            </div>
        </div>    
        <div class="col-10 flex-fill" > 
            <div class="col-12" style="padding: 0;">   
                <div class="line menu-line">
                    <div class="menu-container">
                        <div class="dropdown-header" onclick="toggleDropdown(1)">견적정보</div>
                            <div class="dropdown-content" id="custom-dropdown-1">
                                <div class="input-group mb-2" style="overflow-x: auto; white-space: nowrap;">
                                            <table id="datatablesSimple"  class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th class="text-center">순번</th>
                                                        <th class="text-center">기본품목</th>
                                                        <th class="text-center">검측가로</th>
                                                        <th class="text-center">검측세로</th>
                                                        <th class="text-center">단가</th>
                                                        <th class="text-center">수량</th>
                                                        <th class="text-center">공급가</th>
                                                        <th class="text-center">할인율</th>  
                                                        <th class="text-center">할인금액</th>
                                                        <th class="text-center">세액</th>
                                                        <th class="text-center">최종가</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                    i = 0   ' 순번 초기화 먼저
                                                    SQL = "SELECT A.sjsidx, A.sjb_idx, F.sjb_type_name, A.mwidth, A.mheight, A.qtyidx, g.qtyname, "
                                                    SQL = SQL & "A.sjsprice, A.quan, A.disrate, A.disprice, A.taxrate, A.sprice, A.fprice, "
                                                    SQL = SQL & "A.midx, D.mname, A.mwdate, A.meidx, E.mname, A.mewdate, A.astatus, "
                                                    SQL = SQL & "B.sjb_type_no, A.framename, i.pname, h.fkidx "
                                                    SQL = SQL & "FROM tng_sjaSub A "
                                                    SQL = SQL & "LEFT JOIN tng_sjb B ON A.sjb_idx=B.sjb_idx "
                                                    SQL = SQL & "LEFT JOIN tk_qty C ON A.qtyidx=C.qtyidx "
                                                    SQL = SQL & "JOIN tk_member D ON A.midx=D.midx "
                                                    SQL = SQL & "JOIN tk_member E ON A.meidx=E.midx "
                                                    SQL = SQL & "LEFT JOIN tng_sjbtype F ON B.sjb_type_no=F.sjb_type_no "
                                                    SQL = SQL & "LEFT JOIN (SELECT DISTINCT qtyno, qtyname FROM tk_qtyco) g ON C.qtyno=g.qtyno "
                                                    SQL = SQL & "LEFT JOIN (SELECT sjsidx, MIN(fkidx) AS fkidx FROM tk_framek GROUP BY sjsidx) h "
                                                    SQL = SQL & "ON A.sjsidx=h.sjsidx "
                                                    SQL = SQL & "LEFT JOIN tk_paint i ON A.pidx=i.pidx "
                                                    SQL = SQL & "WHERE A.sjidx<>0 AND A.sjidx=" & CLng(rsjidx) & " "
                                                    SQL = SQL & "AND A.astatus=1 "
                                                    SQL = SQL & "ORDER BY A.sjsidx ASC"
                                                    'Response.write (SQL)&"<br>"
                                                    Rs.open Sql,Dbcon
                                                    if not (Rs.EOF or Rs.BOF ) then
                                                    Do while not Rs.EOF
                                                        i=i+1               '순번

                                                        sjsidx=Rs(0)        '주문품목키
                                                        sjb_idx=Rs(1)       '기본품목키
                                                        sjb_type_name=Rs(2)  '기본품목명
                                                        mwidth=Rs(3)        '검측가로
                                                        mheight=Rs(4)       '검측세로
                                                        qtyidx=Rs(5)        '재질키
                                                        qtyname=Rs(6)       '재질명
                                                        sjsprice=Rs(7)      '단가
                                                        quan=Rs(8)          '수량
                                                        disrate=Rs(9)       '할인율
                                                        disprice=Rs(10)     '할인금액
                                                        taxrate=Rs(11)      '세율
                                                        sprice=Rs(12)       '공급가
                                                        fprice=Rs(13)       '최종가
                                                        midx=Rs(14)         '최초작성자키
                                                        mname=Rs(15)        '최초작성자명
                                                        mwdate=Rs(16)       '최초작성일
                                                        meidx=Rs(17)        '최종작성자키
                                                        mename=Rs(18)       '최종작성자명
                                                        mewdate=Rs(19)      '최종작성일
                                                        astatus=Rs(20)      '1은 사용 0은 사용안함 수정/삭제 ㅋㅋㅋㅋ
                                                        sjb_type_no=Rs(21)
                                                        framename=Rs(22)    '프레임명
                                                        pname=Rs(23)        '도장명
                                                        fkidx=Rs(24)        'framek

                                                    %> 

                                                    <tr>
                                                        <td class="text-center"><button type="button" class="btn btn-outline-danger" Onclick="del1('<%=sjsidx%>');"><%=i%></button></td>
                                                        <td class="text-center">
                                                        <button class="<%=class_text%>" type="button"
                                                            onclick="if (document.getElementById('dropdown-<%=sjsidx%>')) { 
                                                                    toggleDropdown(<%=sjsidx%>); 
                                                                } 
                                                                location.replace('TNG1_B_suju_quick.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&fkidx=<%=fkidx%>');"> 
                                                        <%=framename%>
                                                        </button>
                                                        </td>
                                                        <td class="text-end"><%=formatnumber(mwidth,0)%>mm</td>
                                                        <td class="text-end"><%=formatnumber(mheight,0)%>mm</td>
                                                        <td class="text-end"><%=formatnumber(sjsprice,0)%>원</td>
                                                        <td class="text-end"><%=formatnumber(quan,0)%>EA</td>
                                                        <td class="text-end"><%=formatnumber(fprice,0)%>원</td>
                                                        <td class="text-end"><%=formatnumber(disrate,0)%>%</td>
                                                        <td class="text-end"><%=formatnumber(disprice,0)%>원</td>
                                                        <td class="text-end"><%=formatnumber(taxrate,0)%>원</td>
                                                        <td class="text-end"><%=formatnumber(sprice,0)%>원</td>
                                                    </tr>

                                                        <%
                                                            Rs.movenext
                                                            Loop
                                                            End If
                                                            Rs.Close 
                                                        %>
                                                    </tbody>
                                            </table>    
                                </div>
                                <%
                                'Response.Write "sjb_idx: " & sjb_idx & "<br>"
                                'Response.Write "rqtyidx: " & rqtyidx & "<br>"
                                'Response.Write "yfidx: " & yfidx & "<br>"
                                'Response.Write "rqtyco_idx: " & rqtyco_idx & "<br>"
                                'Response.Write "qtyco_idx: " & qtyco_idx & "<br>"
                                %>
                            </div>
                        <div class="dropdown-header" onclick="toggleDropdown(2)">추가자재</div>
                        <div class="dropdown-content" id="custom-dropdown-2">
                            <div class="input-group mb-2" style="overflow-x: auto; white-space: nowrap;">
                                <table id="datatablesSimple"  class="table table-hover">
                                    <thead>
                                        <th class="text-center"></th>
                                        <th class="text-center">추가자재명</th>
                                        <th class="text-center">길이</th>
                                        <th class="text-center">단가</th>
                                    </thead>
                                    <tbody  class="table-group-divider">
                                        <%
                                        p=0
                                        SQL = "SELECT A.fkidx, B.fksidx, c.ysize , b.blength , B.WHICHI_FIX, B.WHICHI_AUTO "
                                        SQL = SQL & ", C.set_name_FIX, C.set_name_AUTO "
                                        SQL = SQL & ",  c.xsize ,c.bfidx "
                                        SQL = SQL & ",c.TNG_Busok_idx,c.TNG_Busok_idx2,c.TNG_Busok_idx3 "
                                        SQL = SQL & ",c.bfimg1,c.bfimg2,c.bfimg3 ,c.bfimg4 "
                                        SQL = SQL & ",d.T_Busok_name_f,e.T_Busok_name_f,f.T_Busok_name_f " 
                                        SQL = SQL & ",d.TNG_Busok_images,e.TNG_Busok_images,f.TNG_Busok_images ,GREEM_F_A " 
                                        SQL = SQL & ",a.chuga_jajae,b.chuga_jajae ,b.unitprice , a.sjb_idx ,a.sjidx ,a.sjsidx  "
                                        SQL = SQL & " FROM tk_framek A"
                                        SQL = SQL & " LEFT OUTER JOIN tk_framekSub B ON A.fkidx = B.fkidx"
                                        SQL = SQL & " LEFT OUTER JOIN tk_barasiF C ON B.bfidx = C.bfidx"
                                        SQL = SQL & " LEFT OUTER JOIN TNG_Busok d ON c.TNG_Busok_idx = d.TNG_Busok_idx"
                                        SQL = SQL & " LEFT OUTER JOIN TNG_Busok e ON c.TNG_Busok_idx2 = e.TNG_Busok_idx"
                                        SQL = SQL & " LEFT OUTER JOIN TNG_Busok f ON c.TNG_Busok_idx3 = f.TNG_Busok_idx"
                                        SQL = SQL & " WHERE a.fkidx = '" & rfkidx & "' "
                                        SQL = SQL & " and b.gls=0 " ' 자재일 경우
                                        SQL = SQL & " and b.chuga_jajae<>0 " 
                                        'Response.write (SQL)&"<br>"
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do while not Rs.EOF

                                            c_fkidx            = Rs(0)   '품목별. 자동은 1개당 1장, 수동은 집합해서 출력
                                            c_fksidx           = Rs(1)
                                            c_ysize            = Rs(2)   '정면폭 (set_name_FIX or set_name_AUTO 포함됨)
                                            c_blength          = Rs(3)   '절단치수
                                            c_whichi_fix       = Rs(4)
                                            c_whichi_auto      = Rs(5)
                                            c_set_name_FIX     = Rs(6)   '수동품명
                                            c_set_name_AUTO    = Rs(7)   '자동품명
                                            c_xsize            = Rs(8)   '측면폭 (set_name_FIX or set_name_AUTO 포함됨)
                                            c_bfidx            = Rs(9) 
                                            c_TNG_Busok_idx    = Rs(10)  '소요 알루미늄자재 1
                                            c_TNG_Busok_idx2   = Rs(11)  '소요 알루미늄자재 2
                                            c_TNG_Busok_idx3   = Rs(12)  '소요 알루미늄자재 3
                                            c_bfimg1           = Rs(13)  '자재 결합 이미지1
                                            c_bfimg2           = Rs(14)  '자재 결합 이미지2
                                            c_bfimg3           = Rs(15)  '자재 결합 이미지3
                                            c_bfimg4           = Rs(16)  '자재 결합 이미지4
                                            c_T_Busok_name_f1  = Rs(17)  '알루미늄 원 자재명1
                                            c_T_Busok_name_f2  = Rs(18)  '알루미늄 원 자재명2
                                            c_T_Busok_name_f3  = Rs(19)  '알루미늄 원 자재명3
                                            c_TNG_Busok_images1= Rs(20)  '알루미늄 원 자재 이미지1
                                            c_TNG_Busok_images2= Rs(21)  '알루미늄 원 자재 이미지2
                                            c_TNG_Busok_images3= Rs(22)  '알루미늄 원 자재 이미지3
                                            c_GREEM_F_A        = Rs(23)  '1=수동, 2=자동
                                            c_chuga_jajae_A    = Rs(24)  'tk_framek.A.chuga_jajae
                                            c_chuga_jajae_B    = Rs(25)  'tk_framekSub.B.chuga_jajae 
                                            c_unitprice        = Rs(26)  'tk_framekSub.B.unitprice
                                            c_sjb_idx          = Rs(27)  'tk_framek.A.sjb_idx
                                            c_sjidx            = Rs(28)  'tk_framek.A.sjidx
                                            c_sjsidx           = Rs(29)  'tk_framek.A.sjsidx
                                            p=p+1 
                                        %>
                                        <tr>
                                            <td class="text-center"><%=p%></td> 
                                            <td class="text-center"
                                            onclick="location.replace('TNG1_B_suju_quick.asp?sjidx=<%=c_sjidx%>&sjsidx=<%=c_sjsidx%>&fkidx=<%=c_fkidx%>&sjb_idx=<%=c_sjb_idx%>&fksidx=<%=c_fksidx%>');"
                                            ><%=c_xsize%>*<%=c_ysize%>_<%=c_T_Busok_name_f1%></td>
                                            <td class="text-center"><%=c_blength%></td>
                                            <td class="text-center"><%=FormatNumber(c_unitprice, 0, -1, -1, -1)%></td>
                                        </tr>
                                        <%
                                        Rs.movenext
                                        Loop
                                        End if
                                        Rs.close
                                        %> 

                                    </tbody>
                                </table>
                            </div>
                        </div>    
                        <div class="dropdown-header" onclick="toggleDropdown(3)">자동옵션정보</div>
                        <div class="dropdown-content" id="custom-dropdown-3"> 
                            <div class="input-group mb-2" style="overflow-x: auto; white-space: nowrap;">
                                        <%
                                        yyCheck = ""
                                        yyLength = ""
                                        yyUnit = ""
                                        yyPcent = ""
                                        yyPrice = ""
                                        bar_name = ""

                                          SQL = "SELECT A.fksidx, A.whichi_fix, B.whichi_fixname, A.alength, A.blength, A.xi, A.yi, A.bfidx,D.whichi_auto, D.whichi_autoname, "
                                        SQL = SQL & "F.unitprice, F.pcent, F.sprice, F.blength AS F_blength, F.ysize, F.alength AS F_alength, F.gls, F.doortype, "
                                        SQL = SQL & "G.set_name_fix, G.set_name_auto, C.sjb_idx, C.sjb_type_no "
                                        SQL = SQL & "FROM tk_framekSub A "
                                        SQL = SQL & "JOIN tng_whichitype B ON A.whichi_fix = B.whichi_fix "
                                        SQL = SQL & "JOIN tk_framek C ON A.fkidx = C.fkidx "
                                        SQL = SQL & "JOIN tng_whichitype D ON A.whichi_auto = D.whichi_auto "
                                        SQL = SQL & "JOIN tk_framekSub F ON A.fksidx = F.fksidx "
                                        SQL = SQL & "LEFT JOIN tk_barasiF G ON F.bfidx = G.bfidx "
                                        SQL = SQL & "WHERE C.sjidx='" & rsjidx & "' "
                                        SQL = SQL & "AND C.sjsidx='" & rsjsidx & "' "
                                        SQL = SQL & "AND A.fkidx='" & rfkidx & "' "
                                        SQL = SQL & "ORDER BY A.fksidx ASC"
                                        'Response.write (SQL)&"<br>"
                                        'response.end
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do while not Rs.EOF
                                                fksidx          = Rs("fksidx")
                                                whichi_fix      = Rs("whichi_fix")
                                                whichi_fixname  = Rs("whichi_fixname")
                                                alength         = Rs("alength")
                                                blength         = Rs("blength")
                                                xi              = Rs("xi")
                                                yi              = Rs("yi")
                                                whichi_auto     = Rs("whichi_auto")
                                                whichi_autoname = Rs("whichi_autoname")
                                                unitprice       = Rs("unitprice")
                                                pcent           = Rs("pcent")
                                                sprice          = Rs("sprice")
                                                F_blength       = Rs("F_blength")
                                                ysize           = Rs("ysize")
                                                F_alength       = Rs("F_alength")
                                                gls             = Rs("gls")
                                                doortype        = Rs("doortype")
                                                set_name_fix    = Rs("set_name_fix")
                                                set_name_auto   = Rs("set_name_auto")
                                                sjb_idx         = Rs("sjb_idx")
                                                sjb_type_no     = Rs("sjb_type_no")
                                                bfidx           = Rs("bfidx")
                                            select case doortype
                                                case 0 
                                                    doortype_text = ""
                                                case 1 
                                                    doortype_text = "좌도어"
                                                case 2  
                                                    doortype_text = "우도어"
                                                case else  
                                                    doortype_text = ""
                                            end select 
                                            'response.write "--"&doortype&"--"
                                            'response.write "--"&set_name_fix&"--"
                                            if  doortype > 0 then '도어 타입 0 없음 1 좌도어 2 우도어
                                                if set_name_auto <> "" then
                                                    bar_name = set_name_auto & ":" & doortype_text
                                                elseif set_name_fix <> "" then
                                                    bar_name = set_name_fix & ":" & doortype_text
                                                end if
                                            else
                                                if set_name_auto <> "" then
                                                    bar_name = set_name_auto
                                                elseif set_name_fix <> "" then
                                                    bar_name = set_name_fix
                                                end if
                                            end if   
                                            'response.write "--"&bar_name&"--" 

                                            If IsNull(ysize) Or ysize = "" Or ysize = 0 Then
                                                ysize="-"
                                            end if

                                            select case gls
                                                case 0 
                                                    gls_text = "프레임"
                                                case 1 
                                                    gls_text = "외도어"
                                                case 2  
                                                    gls_text = "양개도어"
                                                case else  
                                                    gls_text = "픽스유리"
                                            end select 

                                            
                                            fksidx_str = CStr(fksidx)   ' 숫자를 문자열로 변환
                                            fksidx_last3 = Right(fksidx_str, 3) '케빈 자재 숫자찾기

                                            if rfksidx="" then rfksidx="0" end if
                                            lbn=lbn+1

                                            yyCheck = yyCheck & "<td><input type='checkbox' class='form-check-input' name='afksidx' value='" & fksidx & "'></td>"

                                            If clng(rfksidx) = clng(fksidx) Then

                                                yylbn = yylbn & "<td style='background:#80ff80;white-space:nowrap;'>"
                                                yylbn = yylbn & fksidx_last3

                                                ' 🔥 자재변경 버튼 추가 (NEW)
                                                yylbn = yylbn & " <button type=""button"" class=""btn btn-sm btn-outline-primary"" "
                                                yylbn = yylbn & " onclick=""goChangeMode(" & fksidx & ");"">변경</button>"

                                                yylbn = yylbn & "</td>"

                                            Else

                                                yylbn = yylbn & "<td style='white-space:nowrap;cursor:pointer;' "
                                                yylbn = yylbn & " onclick=""location.replace('TNG1_B_suju_quick.asp?sjcidx=" & rsjcidx
                                                yylbn = yylbn & "&sjidx=" & rsjidx
                                                yylbn = yylbn & "&sjsidx=" & rsjsidx
                                                yylbn = yylbn & "&fkidx=" & rfkidx
                                                yylbn = yylbn & "&sjb_idx=" & sjb_idx
                                                yylbn = yylbn & "&sjb_type_no=" & sjb_type_no
                                                yylbn = yylbn & "&fksidx=" & fksidx & "');"">"
                                                yylbn = yylbn & fksidx_last3 & "</td>"

                                            End If
                                            
                                            If clng(rfksidx) = clng(fksidx) Then
                                            yygls_text = yygls_text & "<td style=background:#80ff80; >" & gls_text & "</td>"
                                            else
                                            yygls_text = yygls_text & "<td>" & gls_text & "</td>"
                                            end if

                                            Dim display_name

                                            ' 1) 먼저 표시할 텍스트 결정
                                            If whichi_fixname = "롯트바" Then
                                                display_name = "롯트바"
                                            ElseIf whichi_fixname = "박스라인 롯트바" Then
                                                display_name = "박스라인"
                                            Else
                                                display_name = bar_name
                                            End If

                                            ' 2) fksidx 조건에 따라 td 생성
                                            If CLng(rfksidx) = CLng(fksidx) Then
                                                ' 같은 fksidx → 강조(초록색)
                                                yybar_name = yybar_name & "<td style='background:#80ff80;'>" & _
                                                "<a href='TNG1_JULGOK_PUMMOK_LIST1.asp?bfidx=" & bfidx & _
                                                "&SJB_IDX=" & sjb_idx & "#" & bfidx & "' target='_blank' " & _
                                                "style='text-decoration:none;color:black;'>" & _
                                                display_name & "</a></td>"
                                            Else
                                                ' 다른 fksidx → 일반 td
                                                yybar_name = yybar_name & "<td class='text-center'>" & _
                                                "<a href='TNG1_JULGOK_PUMMOK_LIST1.asp?bfidx=" & bfidx & _
                                                "&SJB_IDX=" & sjb_idx & "#" & bfidx & "' target='_blank' " & _
                                                "style='text-decoration:none;color:black;'>" & _
                                                display_name & "</a></td>"
                                            End If

                                            If clng(rfksidx) = clng(fksidx) Then
                                            yyysize = yyysize & "<td style=background:#80ff80; >" & ysize & "</td>"
                                            else
                                            yyysize = yyysize & "<td>" & ysize & "</td>"
                                            end if

                                            If clng(rfksidx) = clng(fksidx) Then
                                            yyLength = yyLength & "<td style=background:#80ff80; >" & blength & "</td>"
                                            else
                                            yyLength = yyLength & "<td>" & blength & "</td>"
                                            end if
                                            
                                            If clng(rfksidx) = clng(fksidx) Then
                                                If IsNumeric(unitprice) Then
                                                    yyUnit = yyUnit & "<td style=background:#80ff80;>" & FormatNumber(unitprice, 0, -1, -1, -1) & " 원</td>"
                                                Else
                                                    yyUnit = yyUnit & "<td>-</td>"
                                                End If
                                            else
                                                If IsNumeric(unitprice) Then
                                                    yyUnit = yyUnit & "<td>" & FormatNumber(unitprice, 0, -1, -1, -1) & " 원</td>"
                                                Else
                                                    yyUnit = yyUnit & "<td>-</td>"
                                                End If
                                            end if

                                            If clng(rfksidx) = clng(fksidx) Then
                                            yyPcent = yyPcent & "<td style=background:#80ff80;>" & pcent & "%</td>"
                                            else
                                            yyPcent = yyPcent & "<td>" & pcent & "%</td>"
                                            end if

                                            If clng(rfksidx) = clng(fksidx) Then
                                                If IsNumeric(sprice) Then
                                                    yyPrice = yyPrice & "<td style=background:#80ff80;>" & FormatNumber(sprice, 0, -1, -1, -1) & " 원</td>"
                                                Else
                                                    yyPrice = yyPrice & "<td>-</td>"
                                                End If
                                            else
                                                If IsNumeric(sprice) Then
                                                yyPrice = yyPrice & "<td>" & FormatNumber(sprice, 0, -1, -1, -1) &" 원</td>"
                                                Else
                                                    yyPrice = yyPrice & "<td>-</td>"
                                                End If
                                            end if

                                        %>
                                        <%
                                        Rs.movenext
                                        Loop
                                        End if
                                        Rs.close
                                        %> 
                                    <table class="table table-bordered text-center align-middle" style="margin-left: 0;">
                                        <tbody class="table-group-divider">
                                            <tr>
                                                <td><i class="fa-solid fa-clone" style="color: #74C0FC;" onclick="wincopy();"></i></td>
                                                <%=yyCheck %>
                                            </tr>
                                            <tr>
                                                <td style="white-space: nowrap;">
                                                <button type="button" class="btn btn-secondary btn-sm" onclick="barchange1();">자재변경</button>
                                                <button type="button" class="btn btn-danger btn-sm" onclick="bardelMulti()">선택삭제</button>
                                                </td>
                                                <%=yylbn %>
                                            </tr>
                                            <tr>
                                                <td style="white-space: nowrap;">구분</td>
                                                <%= yygls_text %>
                                            </tr>
                                            <tr>
                                                <td style="white-space: nowrap;">자재명</td>
                                                <%= yybar_name %> 
                                            </tr>
                                            <tr>
                                                <td style="white-space: nowrap;">정면폭</td>
                                                <%= yyysize %>
                                            </tr>
                                            <tr>
                                                <td style="white-space: nowrap;">길이</td>
                                                <%= yyLength %>
                                            </tr>
                                            <tr>
                                                <td style="white-space: nowrap;">단가</td>
                                                <%= yyUnit %>
                                            </tr>
                                            <tr>
                                                <td style="white-space: nowrap;">할증</td>
                                                <%= yyPcent %>
                                            </tr>
                                            <tr>
                                                <td style="white-space: nowrap;">가격</td>
                                                <%= yyPrice %>
                                            </tr>
                                        </tbody>
                                    </table>
                            </div>
                            <script>
                                function goChangeMode(fksidx){

                                    const url = new URL(window.location.href);

                                    // ✅ 기존 파라미터 유지
                                    url.searchParams.set("new_open", "go");
                                    url.searchParams.set("fksidx", fksidx);

                                    // ✅ 전체 쿼리 유지한 채 이동
                                    location.href = url.toString();
                                }
                            </script>

                            <script>
                                function bardelMulti() {
                                const checked = document.querySelectorAll('input[name="afksidx"]:checked');
                                if (checked.length === 0) {
                                    alert('삭제할 항목을 선택하세요.');
                                    return;
                                }

                                if (!confirm(checked.length + '개의 항목을 삭제하시겠습니까?')) return;

                                const ids = Array.from(checked).map(el => el.value).join(',');
                                const url = new URL(window.location.href);
                                url.searchParams.set('part', 'bardelMulti');
                                url.searchParams.set('ids', ids);
                                location.href = url.toString();
                                }
                            </script>
                            <% 
                            'Response.Write "sjb_idx: " & sjb_idx & "<br>"
                            'Response.Write "rqtyidx: " & rqtyidx & "<br>"
                            'Response.Write "yfidx: " & yfidx & "<br>"
                            'Response.Write "rqtyco_idx: " & rqtyco_idx & "<br>"
                            'Response.Write "qtyco_idx: " & qtyco_idx & "<br>"
                            %>
                        </div>
                    </div>
                </div>
            </div>    
        </div> 
    </div>
    </div>   
    


    <!-- 드롭다운 스크립트 -->
    <script>
    // 현재 열려있는 드롭다운 번호를 저장할 변수
    // 아무것도 안 열려 있으면 null
    let currentOpen = null;

    // 드롭다운 열고 닫기 함수
    function toggleDropdown(num) {
        // custom- prefix로 찾기
        const selected = document.getElementById(`custom-dropdown-${num}`);
        if (!selected) return;

        if (currentOpen === num) {
            selected.style.display = 'none';
            currentOpen = null;
        } else {
            // custom-dropdown- 으로 시작하는 것만 닫기
            document.querySelectorAll('[id^="custom-dropdown-"]').forEach(el => {
                el.style.display = 'none';
            });

            selected.style.display = 'block';
            currentOpen = num;
        }
    }

    document.addEventListener("DOMContentLoaded", () => {
        toggleDropdown(3); // 기본으로 2번 열기
    });
    </script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


<script>
  const svg = document.getElementById("svgCanvas");
  const viewport = document.getElementById("viewport");

  let scale = 1;
  let translateX = 0;
  let translateY = 0;

  // 마우스 휠 확대/축소
  svg.addEventListener("wheel", function (event) {
    event.preventDefault();
    const zoomSpeed = 0.1;
    const delta = event.deltaY > 0 ? -1 : 1;
    scale += delta * zoomSpeed;
    scale = Math.min(Math.max(scale, 0.2), 5);
    updateTransform();
  });

  // 드래그 이동
  let isDragging = false;
  let startX, startY;

  svg.addEventListener("mousedown", function (event) {
    if (event.button === 0) { // 왼쪽 버튼
      isDragging = true;
      startX = event.clientX;
      startY = event.clientY;
    }
  });

  svg.addEventListener("mousemove", function (event) {
    if (isDragging) {
      const dx = event.clientX - startX;
      const dy = event.clientY - startY;
      translateX += dx;
      translateY += dy;
      startX = event.clientX;
      startY = event.clientY;
      updateTransform();
    }
  });

  svg.addEventListener("mouseup", function () {
    isDragging = false;
  });

  svg.addEventListener("mouseleave", function () {
    isDragging = false;
  });

  function updateTransform() {
    viewport.setAttribute("transform", `translate(${translateX}, ${translateY}) scale(${scale})`);
  }

  function checkFlBeforeSubmit() {

    var flInput = document.querySelector("input[name='fl']");
    if (!flInput) return true;

    var flVal = flInput.value;

    if (flVal === "" || flVal === "0") {
        alert("묻힘이 없으면 실행이 안됩니다.");
        return false; // 🔥 submit 자체 차단
    }

    return true;
}


</script>  

</body>
</html>
<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
