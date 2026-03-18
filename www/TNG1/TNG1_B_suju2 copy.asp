
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

  listgubun="one" 
  projectname="수주"

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



  rcidx=request("cidx")
  rsjidx=request("sjidx") '수주키 TB TNG_SJA
  rsjb_idx=request("sjb_idx") '수주 제품키 TB TNG_SJB
  rsjb_type_no=Request("sjb_type_no") '제품타입
  rsjbsub_Idx=Request("sjbsub_Idx")

  rfkidx=Request("fkidx")
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
mode=Request("mode")


rjaebun=Request("jaebun") ' 1 재분 2재분보강 0삭제
rboyang=Request("boyang") '보양
if rjaebun = "" then rjaebun = 0 end if 
if rboyang = "" then rboyang = 0 end if 
'Response.Write "rjaebun : " & rjaebun & "<br>"   
'Response.Write "rboyang : " & rboyang & "<br>"   
rdoorchangehigh=Request("doorchangehigh") 
'Response.Write "mode : " & mode & "<br>"   
'Response.Write "mode1 : " & mode1 & "<br>"   
'Response.Write "mode2 : " & mode2 & "<br>"   
'Response.Write "rdoorchangehigh : " & rdoorchangehigh & "<br>"  
'Response.Write "rdooryn : " & rdooryn & "<br>"   
'Response.Write "rdoorglass_t : " & rdoorglass_t & "<br>"  
'Response.Write "rfixglass_t : " & rfixglass_t & "<br>"  
'Response.Write "rpidx 도장칼라: " & rpidx & "<br>"   
'Response.Write "rtw 전체가로: " & rtw & "<br>"
'Response.Write "rth 전체세로: " & rth & "<br>"
'Response.Write "row 오픈가로: " & row & "<br>"
'Response.Write "roh 오픈세로: " & roh & "<br>"
'Response.Write "rfl 묻힘: " & rfl & "<br>"
'Response.Write "row_m : " & row_m & "<br>"
'response.write rfidx&"/<br>"
'response.write rqtyco_idx&"/<br>"
'Response.Write "rqtyidx 재질: " & rqtyidx & "<br>"
'Response.Write "rfl : " & rfl & "<br>"  
'Response.Write "rafksidx : " & rafksidx & "<br>"   
'Response.Write "rgreem_o_type : " & rgreem_o_type & "<br>"   
'Response.Write "rfksidx : " & rfksidx & "<br>"  
'Response.Write "rfkidx : " & rfkidx & "<br>"   
'Response.Write "rfidx : " & rfidx & "<br>"   
'Response.Write "mode : " & mode & "<br>"   
'Response.Write "rblength : " & rblength & "<br>"   
'Response.Write "rasub_wichi1 : " & rasub_wichi1 & "<br>"    
'Response.Write "rsjb_type_no : " & rsjb_type_no & "<br>"
'Response.Write "rgreem_f_a : " & rgreem_f_a & "<br>"
  'response.write rmwidth&"/<br>"
  'response.write rmheight&"/<br>"

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


SearchWord=Request("SearchWord")
gubun=Request("gubun")

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="tng1_greemlist3.asp?listgubun="&listgubun&"&"


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


'바 추가 복제하기 시작
'===================
if rafksidx<>"" then 
  '증가된 높이 찾기 시작
  SQL=" select distinct yi ,hi From tk_frameksub where fksidx in ("&rafksidx&") "
  Rs1.open Sql,Dbcon
  If Not (Rs1.bof or Rs1.eof) Then 
  Do while not Rs1.EOF
    ayi=Rs1(0)
    ahi=Rs1(1)
    sahi=ahi+sahi
  Rs1.movenext
  Loop
  End if
  Rs1.close
  '증가된 높이 찾기 끝
  'Response.write sahi&"<br><br>"

  '바추가 하기 시작
  SQL=" Select fsidx, fidx, xi, yi, wi, hi, imsi, whichi_fix, whichi_auto, bfidx,fkidx  "
  SQL=SQL&" From tk_frameksub "
  SQL=SQL&" where fksidx in ("&rafksidx&") "
  'Response.write (SQL)&"<br><br>"
  Rs1.open Sql,Dbcon
  If Not (Rs1.bof or Rs1.eof) Then 
  Do while not Rs1.EOF
    fsidx=Rs1(0)
    fidx=Rs1(1)
    xi=Rs1(2)
    yi=Rs1(3)
    wi=Rs1(4)
    hi=Rs1(5)
    imsi=Rs1(6)
    whichi_fix=Rs1(7)
    whichi_auto=Rs1(8)
    bfidx=Rs1(9)
    fkidx=Rs1(10)


    yi=yi-sahi

    SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx) "
    SQL=SQL&" Values ('"&fkidx&"', '"&fsidx&"', '"&fidx&"', '"&xi&"', '"&yi&"', '"&wi&"', '"&hi&"', '"&C_midx&"' "
    SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"') "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

  Rs1.movenext
  Loop
  End if
  Rs1.close
  '바추가하기 끝

  '가장 상단의 바와 위치가 같은 바들의 위치를 높이고 길이를 늘리기 시작
  SQL="Select min(yi) from tk_frameksub where fksidx in ("&rafksidx&") "
  Rs1.open Sql,Dbcon
  If Not (Rs1.bof or Rs1.eof) Then 
    ayi=Rs1(0)  '선택된 바중 가장 상단 바의 y좌표값
  End if
  Rs1.Close

  SQL=" Select fksidx, yi, hi from tk_frameksub where fkidx='"&fkidx&"' and yi='"&ayi&"' and fksidx not in ("&rafksidx&") "
  'Response.write (SQL)&"<br><br>"
  Rs1.open Sql,Dbcon
  If Not (Rs1.bof or Rs1.eof) Then 
  Do while not Rs1.EOF
    fksidx=Rs1(0)
    yi=Rs1(1)
    hi=Rs1(2)

    chg_yi=yi-sahi
    chg_hi=hi+sahi

    SQL="Update tk_frameksub set yi='"&chg_yi&"', hi='"&chg_hi&"' Where fksidx='"&fksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
  Rs1.movenext
  Loop
  End if
  Rs1.close
  '가장 상단의 바와 위치가 같은 바들의 위치를 높이고 길이를 늘리기 끝

  '유리추가하기 시작

  '유리추가하기 끝

  response.write "<script>location.replace('TNG1_B_suju2.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"')</script>"
end if
'===================
'바 추가 복제하기 끝
'개별 바의 길이 입력시작
'===================
If mode= "kblength" Then
    SQL="Update tk_framekSub  "  
    SQL=SQL&" Set blength='"&kblength&"' "
    SQL=SQL&" Where fksidx='"&rfksidx&"' "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if
'===================
'개별 바의 길이 입력끝

'바의 길이 입력하면 단가===================와 할증 그리고 가격 입력하기 시작
'=========================================================

If Request("new_open") = "go" Then
    response.write "<script>"
    response.write "window.open('TNG1_B_suju2_pop.asp?cidx=" & rcidx & _
        "&sjidx=" & rsjidx & _
        "&sjsidx=" & rsjsidx & _
        "&fkidx=" & fkidx & _
        "&sjb_idx=" & rsjb_idx & _
        "&sjb_type_no=" & rsjb_type_no & _
        "&fksidx=" & rfksidx & _
        "&jaebun=" & rjaebun & _
        "&boyang=" & rboyang & "', '_blank', 'width=1000,height=600');"
    response.write "</script>"
    
End If

If rfkidx<>"" Then 
'Response.Write "rfkidx : " & rfkidx & "<br>"
    SQL="select A.fksidx, A.xi, A.yi, A.wi, A.hi, A.WHICHI_AUTO, A.WHICHI_FIX "
    SQL=SQL&" , A.bfidx, B.set_name_Fix, B.set_name_AUTO, B.bfimg1, B.bfimg2, B.bfimg3, B.tng_busok_idx, B.tng_busok_idx2 "
    SQL=SQL&" From tk_framekSub A "
    SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
    SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    'response.end
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 

    afksidx=Rs(0)
    axi=Rs(1)
    ayi=Rs(2)
    awi=Rs(3)
    ahi=Rs(4)
    aWHICHI_AUTO=Rs(5)
    aWHICHI_FIX=Rs(6)
    abfidx=Rs(7)
    aset_name_Fix=Rs(8)
    aset_name_AUTO=Rs(9)
    abfimg1=Rs(10)
    abfimg2=Rs(11)
    abfimg3=Rs(12)
    atng_busok_idx=Rs(13)
    atng_busok_idx2=Rs(14)

    If abfidx="0" or isnull(abfidx) then 
    aset_name_AUTO="없음"
    aset_name_Fix="없음"
    end if 

End If
Rs.close
End If
'Response.Write "aset_name_AUTO : " & aset_name_AUTO & "<br>"
'===================
'바의 길이 입력하면 단가와 할증 그리고 가격 입력하기 끝



'품목정보가 없을 경우 생성 시작
'===================



    SQL = "SELECT a.mwidth, a.mheight, a.qtyidx, a.sjsprice, a.disrate, a.disprice, "
    SQL = SQL & "a.fprice, a.sjb_idx, a.quan, a.taxrate, a.sprice, a.asub_wichi1, "
    SQL = SQL & "a.asub_wichi2, a.asub_bigo1, a.asub_bigo2, a.asub_bigo3, a.asub_meno1, "
    SQL = SQL & "a.asub_meno2, a.astatus, a.py_chuga, a.door_price, a.whaburail, a.robby_box, "
    SQL = SQL & "a.jaeryobunridae, a.boyangjea, a.pidx, b.sjb_type_no "
    SQL = SQL & "FROM tng_sjaSub a "
    SQL = SQL & "left outer JOIN TNG_SJB b ON b.sjb_idx = a.sjb_idx "
    SQL = SQL & "WHERE a.sjidx = '" & rsjidx & "' AND a.sjsidx = '" & rsjsidx & "'"

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
SQL=SQL&" , B.cname, C.mname, C.mtel, C.mhp, C.mfax, C.memail, D.mname, E.mname, A.su_kjtype "
SQL=SQL&" From TNG_SJA A "
SQL=SQL&" Join tk_customer B On A.sjcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.sjmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "
SQL=SQL&" Where sjidx='"&rsjidx&"' "
'Response.write (SQL)&"<br>"
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
End If
Rs.Close




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
response.write "<script>location.replace('TNG1_B_suju2.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"')</script>"

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
'=======================================
'바 삭제 끝

'기준프레임 우측으로 이동 시작
'=======================================
if Request("part")="raction" then 
  '기준프레임 찾기
  SQL="Select fkidx From tk_framek Where  setstd='1' and sjidx='"&rsjidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    stdfkidx=Rs(0)  

    '이동하는 프레임의 기준점 찾기
    SQL="Select xi, wi, yi from tk_frameksub where fkidx='"&stdfkidx&"' and xi=(select max(xi) from tk_frameksub where fkidx='"&stdfkidx&"') "
    'Response.write (SQL)&"<br>"
    Rs1.open Sql,Dbcon
    if not (Rs1.EOF or Rs1.BOF ) then
      xi=Rs1(0)
      wi=Rs1(1)
      yi=Rs1(2)

      sxi=xi+wi
      syi=yi
      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' and xi=(select min(xi) from tk_frameksub where fkidx='"&rfkidx&"') "
      'Response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      if not (Rs2.EOF or Rs2.BOF ) then
        mfksidx=Rs2(0)
        mxi=Rs2(1)
        myi=Rs2(2)

        dxi=sxi-mxi '이동해야하는 x좌표값
        dyi=syi-myi '이동해야하는 y좌표값
        'response.write dxi&"<br>"
        'response.write dyi&"<br>"
      End If
      Rs2.Close

      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' "
      'Response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      if not (Rs2.EOF or Rs2.BOF ) then
      Do while not Rs2.EOF
        mfksidx=Rs2(0)
        mxi=Rs2(1)
        myi=Rs2(2)

        mnxi=mxi+dxi
        mnyi=myi+dyi
        SQL="Update tk_frameksub set xi='"&mnxi&"', yi='"&mnyi&"' Where fksidx='"&mfksidx&"' "
        'Response.write (SQL)&"<br>"
        'Dbcon.Execute (SQL)

      Rs2.movenext
      Loop
      End If
      Rs2.Close

    End If
    Rs1.Close
  End If
  Rs.Close

end if
'=======================================
'기준프레임 우측으로 이동 끝
'기준프레임 설정 시작
'=======================================
if Request("part")="setstd" then 
  rni=request("ni")
  'response.write rni&"/<br>"

  SQL=" Update tk_framek set setstd='"&rni&"' where fkidx='"&rfkidx&"' "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)

  '1번정렬 처리 시작
  '=============
  if rni="1" then 
    SQL="Select xi, yi from tk_framekSub where fkidx='"&rfkidx&"' and xi=(select min(xi) From tk_framekSub Where fkidx='"&rfkidx&"') "
    Rs.open Sql,Dbcon
    if not (Rs.EOF or Rs.BOF ) then
      dxi=Rs(0)
      dyi=Rs(1)

      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' "
      'Response.write (SQL)&"<br>"
      Rs1.open Sql,Dbcon
      if not (Rs1.EOF or Rs1.BOF ) then
      Do while not Rs1.EOF
        mfksidx=Rs1(0)
        mxi=Rs1(1)
        myi=Rs1(2)

        mnxi=mxi-dxi
        mnyi=myi
        SQL="Update tk_frameksub set xi='"&mnxi&"', yi='"&mnyi&"' Where fksidx='"&mfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

      Rs1.movenext
      Loop
      End If
      Rs1.Close
    end if
    Rs.Close
  end if
  '=============
  '1번정렬 처리 끝
  'n번 정렬 처리 시작
  '=============
  '기준프레임 찾기
  setstd=rni-1  '바로앞 프레임 키 찾기
  SQL="Select fkidx From tk_framek Where  setstd='"&setstd&"' and sjidx='"&rsjidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    stdfkidx=Rs(0)  

    '이동하는 프레임의 기준점 찾기
    SQL="Select xi, wi, yi from tk_frameksub where fkidx='"&stdfkidx&"' and xi=(select max(xi) from tk_frameksub where fkidx='"&stdfkidx&"') "
    'Response.write (SQL)&"<br>"
    Rs1.open Sql,Dbcon
    if not (Rs1.EOF or Rs1.BOF ) then
      xi=Rs1(0)
      wi=Rs1(1)
      yi=Rs1(2)

      sxi=xi+wi
      syi=yi
      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' and xi=(select min(xi) from tk_frameksub where fkidx='"&rfkidx&"') "
      'Response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      if not (Rs2.EOF or Rs2.BOF ) then
        mfksidx=Rs2(0)
        mxi=Rs2(1)
        myi=Rs2(2)

        dxi=sxi-mxi '이동해야하는 x좌표값
        dyi=syi-myi '이동해야하는 y좌표값
        'response.write dxi&"<br>"
        'response.write dyi&"<br>"
      End If
      Rs2.Close

      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' "
      'Response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      if not (Rs2.EOF or Rs2.BOF ) then
      Do while not Rs2.EOF
        mfksidx=Rs2(0)
        mxi=Rs2(1)
        myi=Rs2(2)

        mnxi=mxi+dxi
        mnyi=myi+dyi
        SQL="Update tk_frameksub set xi='"&mnxi&"', yi='"&mnyi&"' Where fksidx='"&mfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

      Rs2.movenext
      Loop
      End If
      Rs2.Close

    End If
    Rs1.Close
  End If
  Rs.Close
  '=============
  'n번 정렬 처리 끝

end if

'=======================================
'기준 프레임 설정 끝

'선택된 가로바 줄이기/늘이기 시작
'=======================================
if Request("part")="wresize" then 
  order=Request("order")  'plus 가로늘리기 minus 가로줄이기
  SQL="select wi from tk_framekSub where fksidx='"&rfksidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    wi=Rs(0)
    
      if order="plus" then 
        cwi=wi+10 '20씩 늘인다.
      elseif order="minus" then 
        cwi=wi-10 '20씩 줄인다.
      end if
      if cwi < 0 then 
        cwi=0
      end if
      SQL=" Update tk_framekSub set wi='"&cwi&"' where fksidx='"&rfksidx&"' "
      'Response.write (SQL)&"<br>"
      Dbcon.Execute (SQL)

  end if
  Rs.Close
end if
'=======================================
'선택된 가로바 줄이기/늘이기 끝


'선택된 세로바 줄이기/늘이기 시작
'=======================================
if Request("part")="hresize" then 
  order=Request("order")  'plus 가로늘리기 minus 가로줄이기
  SQL="select hi from tk_framekSub where fksidx='"&rfksidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    hi=Rs(0)
    
      if order="plus" then 
        chi=hi+10 '10씩 늘인다.
      elseif order="minus" then 
        chi=hi-10 '10씩 줄인다.
      end if
      if chi < 0 then 
        chi=0
      end if
      SQL=" Update tk_framekSub set hi='"&chi&"' where fksidx='"&rfksidx&"' "
      'Response.write (SQL)&"<br>"
      Dbcon.Execute (SQL)

  end if
  Rs.Close
end if
'=======================================
'선택된 세로바 줄이기/늘이기 끝

'방향 이동 시작
'=======================================
if Request("part")="converge" then 
  direction=Request("direction")    '방향
  SQL="Select xi, wi, yi, hi from tk_framekSub where fksidx='"&rfksidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    xi=Rs(0)
    wi=Rs(1)
    yi=Rs(2)
    hi=Rs(3)

    if direction="left" then 
      SQL="select distinct xi, wi from tk_framekSub where fkidx='"&rfkidx&"' and fksidx<>'"&rfksidx&"' and xi<'"&xi&"' order by xi desc"
      'Response.write (SQL)&"<br>"
      Rs1.open Sql,Dbcon
      if not (Rs1.EOF or Rs1.BOF ) then
        axi=Rs1(0)
        awi=Rs1(1)
        cwi=axi+awi
        SQL=" Update tk_framekSub set xi='"&cwi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
      end if
      Rs1.Close
    elseif  direction="right" then
      xi=xi+wi
      SQL="select distinct xi, wi from tk_framekSub where fkidx='"&rfkidx&"' and fksidx<>'"&rfksidx&"' and xi>'"&xi&"' order by xi asc"
      'Response.write (SQL)&"<br>"
      Rs1.open Sql,Dbcon
      if not (Rs1.EOF or Rs1.BOF ) then
        axi=Rs1(0)
        awi=Rs1(1)
        cwi=axi-xi
        SQL=" Update tk_framekSub set xi='"&cwi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

      end if
      Rs1.Close

    elseif direction="movel" then
        cwi=xi-10
        SQL=" Update tk_framekSub set xi='"&cwi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    elseif  direction="mover" then
        cwi=xi+10
        SQL=" Update tk_framekSub set xi='"&cwi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    elseif direction="moveu" then
        cyi=yi-10
        SQL=" Update tk_framekSub set yi='"&cyi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    elseif  direction="moved" then
        cyi=yi+10
        SQL=" Update tk_framekSub set yi='"&cyi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    end if
  end if
  Rs.Close

end if
'=======================================
'방향이동 끝

'유리추가 시작
'=======================================
if Request("part")="addglass" then 

'bwsize : 바 가로 실사이즈
'bhsize : 바 세로 실사이즈
fstype = "1" ' : 바의 타임(0:바/1:유리/2:묻힘
rwsize = Request("wsize") '유리 가로 실사이즈
rhsize = Request("hsize") '유리 세로 실사이즈
glasstype = Request("glasstype") '유리의 타입 d1:외도어편개 d2:외도어양개, d3:언밸런스, d4~d5:여분/g1:하부픽스유리, g2:박스라인 하부픽스유리2,d3:상부픽스유리1, d4:상부픽스유리2, d5:상부픽스유리3, d6:상부픽스유리4

fsidx="0" 'framesub의 키값은 없어서 0으로 넣는다.

  SQL="Select top 1 A.fidx, B.xi, B.yi "
  SQL=SQL&" From tk_framek A "
  SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
  SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
  SQL=SQL&" Order by B.xi asc "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    fidx=Rs(0)
    xi=Rs(1)
    yi=Rs(2)

    axi=xi+40
    ayi=yi+40
    awi=200
    ahi=200
    WHICHI_FIX=""
    WHICHI_AUTO=""
    bfidx=""

    SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, gwsize, ghsize, fstype, glasstype) "
    SQL=SQL&" Values ('"&rfkidx&"', '"&fsidx&"', '"&fidx&"', '"&axi&"', '"&ayi&"', '"&awi&"', '"&ahi&"', '"&C_midx&"' "
    SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"', '"&rwsize&"', '"&rhsize&"', '"&fstype&"', '"&glasstype&"') "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

  End If
  Rs.Close
end if
'=======================================
'유리추가 끝
'묻힘추가 시작
'=======================================
If Request("part")="addcovered" Then

  alocation=Request("alocation")  '묻힘방향
  fsidx="0" 'framesub의 키값은 없어서 0으로 넣는다.
  fstype = "2" ' : 바의 타임(0:바/1:유리/2:묻힘
  SQL="Select  A.fidx, B.xi, B.yi, B.wi, B.hi "
  SQL=SQL&" From tk_framek A "
  SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
  SQL=SQL&" Where B.fksidx='"&rfksidx&"' "
  SQL=SQL&" Order by B.xi asc "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    fidx=Rs(0)
    xi=Rs(1)
    yi=Rs(2)
    wi=Rs(3)
    hi=Rs(4)

    if alocation="top" then 
      axi=xi
      ayi=yi
      awi=wi
      ahi=40
    end if
    if alocation="bottom" then 
      axi=xi
      ayi=yi+hi-40
      awi=wi
      ahi=40
    end if
    
    WHICHI_FIX="0"
    WHICHI_AUTO="0"
    bfidx=""

    SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, gwsize, ghsize, fstype, glasstype) "
    SQL=SQL&" Values ('"&rfkidx&"', '"&fsidx&"', '"&fidx&"', '"&axi&"', '"&ayi&"', '"&awi&"', '"&ahi&"', '"&C_midx&"' "
    SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"', '"&rwsize&"', '"&rhsize&"', '"&fstype&"', '"&glasstype&"') "
    'Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)

  End If
  Rs.Close
End If
'=======================================
'묻힘추가 끝


%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title><%=projectname%></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!--#include virtual="/tng1/TNG1_B_suju.css"-->
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
        window.location.href = "TNG1_B_suju2.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx="+sjb_idx+"&fknickname="+encodedMessage;
      }
    }
    function framedel(fkidx){
        if (confirm("프레임을 삭제 하시겠습니까?"))
        {
            location.href="TNG1_B_suju2.asp?part=framedel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx="+fkidx;
        }
    }
    function bardel(fksidx){
        if (confirm("바를 삭제 하시겠습니까?"))
        {
            location.href="TNG1_B_suju2.asp?part=bardel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx="+fksidx;
        }
    }
    function setstd(ni,fkidx){

        {
            location.href="TNG1_B_suju2.asp?part=setstd&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx="+fkidx+"&ni="+ni;
        }
    }
    function wresize(order){
        {
            location.href="TNG1_B_suju2.asp?part=wresize&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&order="+order;
        }
    }
    function hresize(order){
        {
            location.href="TNG1_B_suju2.asp?part=hresize&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&order="+order;
        }
    }
    function converge(direction){
        {
            location.href="TNG1_B_suju2.asp?part=converge&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&direction="+direction;
        }
    }
    
    function addglass(glasstype, wsize, hsize){
        {
            location.href="TNG1_B_suju2.asp?part=addglass&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&gubun=glass&glasstype="+glasstype+"&wsize="+wsize+"&hsize="+hsize;
        }
    }
 
    function addcovered(alocation){
        {
            location.href="TNG1_B_suju2.asp?part=addcovered&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&gubun=covered&alocation="+alocation;
        }
    }
    function wincopy(){
        if (confirm("바를 추가하시겠습니까?"))
        {
            document.dataForm.submit();
        }
    }
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

</head>
<body>
<form id="dataForm_original" name="dataForm_original"  action="TNG1_B_suju_sjasub.asp" method="POST" >   
    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
    <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
    
<div class="container-fluid">
    <!-- 첫 번째 줄 -->
    <div class="first-row">
        <div class="row px-3 w-100">
            <div class="input-group mb-0">
            <span class="input-group-text">수주번호</span>
            <input type="text" class="form-control" value="<%=sjdate%>_<%=sjnum%>">
            <span class="input-group-text">거래처</span>
            <input type="text" class="form-control" value="<%=cname%>">
            <span class="input-group-text">담당자</span>
            <input type="text" class="form-control" value="<%=mname%>">
            <span class="input-group-text">전화</span>
            <input type="text" class="form-control" value="<%=mtel%>">
            <span class="input-group-text">휴대폰</span>
            <input type="text" class="form-control" value="<%=mhp%>">
            <span class="input-group-text">팩스</span>
            <input type="text" class="form-control" value="<%=mfax%>">
            <span class="input-group-text">이메일</span>
            <input type="text" class="form-control" value="<%=memail%>">
            </div>
        </div>
    </div>
    <!-- 두번째 줄 -->
    <div class="first-row">
        <div class="row px-3 w-100">
            <div class="input-group mb-0">
                <span class="input-group-text">전체가로</span>
                <input type="text" class="form-control" style="width: 10px;" name="mwidth" value="<%=sja_mwidth%>" readonly>
                <span class="input-group-text">전체세로</span>
                <input type="text" class="form-control"  name="mheight" value="<%=sja_mheight%>" readonly>
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
            <span class="input-group-text">수량</span>
            <input type="text" class="form-control" name="quan" value="<%=sja_quan%>">
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
                                    <option value="<%=qtyidx%>" <% if Cint(qtyidx)=Cint(sja_qtyidx) then %> selected <% end if %> ><%=qtyname%></option>
                    <%
                    Rs.movenext
                    Loop
                    End if
                    Rs.close
                    %>
            </select>  
            <% ' 👉 추가 : pidx로 pname 조회
            pname = ""
            If IsNumeric(sja_pidx) And sja_pidx <> "" Then
                SQL = "SELECT pname FROM tk_paint WHERE pidx = '" & sja_pidx & "'"
                Rs2.open Sql,Dbcon
                If Not (Rs2.EOF Or Rs2.BOF) Then
                    pname = Rs2(0)
                End If
                Rs2.Close
                Set Rs2 = Nothing
            End If
            %>
            <span for="bendName" class="input-group-text">도장재질</span>
            <input type="text" class="form-control" id="pname" value="<%=pname%>" readonly> <!-- name빠짐 단순 전송용-->
            <input type="hidden" id="pidx" name="pidx" value="<%=sja_pidx%>">

            <button type="button" class="btn btn-secondary"
                    onclick="window.open('/paint_item_pop.asp','paintPopup','width=900,height=650,scrollbars=yes,resizable=yes');">
            선택
            </button>
            <!-- setPaint함수가 실행되는 시점은 팝업창(paint_item_pop.asp) 안에서 선택 항목을 클릭했을 때 -->
            <script>
                function setPaint(pidx, pname){
                document.getElementById('pidx').value  = pidx;   // 서버 전송용
                document.getElementById('pname').value = pname; // 화면 표시용

                // 선택 즉시 저장
                document.getElementById('dataForm_original').submit();
                }
            </script>

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
    
    <form id="dataForm" name="dataForm"  action="TNG1_B_suju_cal.asp" method="POST" >   
    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
    <!-- <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>"> -->
    <input type="hidden" name="fksidx" value="<%=rfksidx%>">
    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
    <input type="hidden" name="mode" value="kblength">
    <!-- 두 번째 줄 (가변 높이 3칸) 시작-->
    <div class="second-row">
        <div class="second-left-1"> <!-- 첫 번째 영역 -->
            <div class="mb-2">
                <select name="sjb_type_no" class="form-control" id="sjb_type_no"  onchange="handleChange_dataForm(this)">
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
                <option value="<%=sjb_type_no%>" <% if Cint(sjb_type_no)=Cint(rsjb_type_no) then response.write "selected" end if %>><%=sjb_type_name%></option>
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
                        SQL = SQL & " Where A.sjb_type_no='"&rsjb_type_no&"' "
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
                            <li><a class="dropdown-item" onclick="window.open('TNG1_B_choiceframe.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&greem_f_a=<%=sjb_fa%>','choice','top=0 left=0 width=800, height=700');"><%=sjb_type_name%>&nbsp;<%=SJB_barlist%></a></li>
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
                 <div >
                        <% if rfkidx<>"" then %>
                            <button class="btn btn-secondary  btn-small" type="button" Onclick="window.open('TNG1_B_door_glass_pop.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&SJB_TYPE_NO=<%=rSJB_TYPE_NO%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>','TNG1_B_doorpop','top=100 left=400 width=1000 height=800');">도어유리보기</button>
                        <% end if%> 
                    </div>
            </div>
                <!-- 생성된 도면 정보 시작 -->
                <div class="row">
                    <div class="col-9">
                        <%
                        SQL = " Select fkidx, fknickname, fname, fstatus, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE "
                        SQL = SQL & " ,GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, setstd, sjb_idx, fidx , qtyidx , pidx   "
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
                            setstd=Rs(12)
                            sjb_idx=Rs(13)
                            fidx=Rs(14)
                            zqtyidx=Rs(15) 
                            zpidx=Rs(16)    
                     
                            if Cint(msjb_idx)=Cint(sjb_idx) then maintext="[m]" end if
                        %>
                        <div class="input-group mb-1">     
                            <input type="text" class="form-control" value="<%=maintext%><%=fname%>_<%=setstd&"번"%>" 
                            onclick="location.replace('TNG1_B_suju2.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>');" 
                            <% if Cint(fkidx)=Cint(rfkidx) then %>style="background-color: #D3D3D3;" <% end if %>>  
                        </div>
                        <%
                            maintext=""
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                        %>   
                    </div>
                        <%
                        SQL = " Select doorglass_t , fixglass_t , dooryn  "
                        SQL = SQL & " From tk_framek"
                        SQL = SQL & " Where fkidx='"&rfkidx&"'  "
                        'response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 

                            zdoorglass_t=Rs(0)
                            zfixglass_t=Rs(1)
                            zdooryn=Rs(2)
                        End if
                        Rs.close
                        %>
                    <div class="input-group mb-2">  
                        <span for="bendName" class="input-group-text">도어 🔵 ❌</span>
                        <select name="dooryn" class="form-control" id="dooryn"  onchange="handleChange_dataForm(this)">
                            <option value="0" <% If Cint(zdooryn) = "0" Or Trim(zdooryn) = "" Then Response.Write "selected" %>>도어나중</option>
                            <option value="1" <% If Cint(zdooryn) = "1" Then Response.Write "selected" %>>도어같이</option>
                            <option value="2" <% If Cint(zdooryn) = "2" Then Response.Write "selected" %>>도어안함</option>
                        </select>
                    </div>
                    <div class="input-group mb-2" style="gap: 8px; align-items: center;">
                        <span class="input-group-text py-0 px-1 small">도어유리</span>
                        <select name="doorglass_t" class="form-control" id="doorglass_t"  onchange="handleChange_dataForm(this)">
                        <option value="0" <% if zdoorglass_t="" then %>selected<% end if %>>t</option>
                        <%
                        SQL=" Select glidx, glcode, glsort, glvariety, gldepth, glprice, glwdate "
                        SQL=SQL&" From tk_glass "
                        SQL=SQL&" Order by gldepth asc "
                        'response.write(sql)
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            glidx=Rs(0)
                            glcode=Rs(1)
                            glsort=Rs(2)
                            glvariety=Rs(3)
                            gldepth=Rs(4)
                            glprice=Rs(5)
                            glwdate=Rs(6)
                        %>
                                        <option value="<%=gldepth%>" <% if Cint(gldepth)=Cint(zdoorglass_t) then %> selected <% end if %> ><%=gldepth%></option>
                        <%
                        Rs.movenext
                        Loop
                        End if
                        Rs.close
                        %>
                        </select>
                        <span class="input-group-text py-0 px-1 small">픽스유리</span>
                        <select name="fixglass_t" class="form-control" id="fixglass_t"  onchange="handleChange_dataForm(this)">
                        <option value="0" <% if zfixglass_t="" then %>selected<% end if %>>t</option>
                        <%
                        SQL=" Select glidx, glcode, glsort, glvariety, gldepth, glprice, glwdate "
                        SQL=SQL&" From tk_glass "
                        SQL=SQL&" Order by gldepth asc "
                        'response.write(sql)
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            glidx=Rs(0)
                            glcode=Rs(1)
                            glsort=Rs(2)
                            glvariety=Rs(3)
                            gldepth=Rs(4)
                            glprice=Rs(5)
                            glwdate=Rs(6)
                        %>
                                        <option value="<%=gldepth%>" <% if Cint(gldepth)=Cint(zfixglass_t) then %> selected <% end if %> ><%=gldepth%></option>
                        <%
                        Rs.movenext
                        Loop
                        End if
                        Rs.close
                        %>
                        </select>
                    </div>   
                <div class="mb-2">
                    <%
                    SQL = " Select tw,th,ow,oh,fl,ow_m,fkidx,GREEM_F_A,GREEM_FIX_TYPE "
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
                        if fl="" or isnull(fl) then 
                            fl = 0
                        end if
                    %>
                    <div class="input-group mb-1">     
                        <% 
                        if Cint(fkidx)=Cint(rfkidx) then 
                        %>
                            <div style="display: flex; flex-wrap: wrap;">
                                <div class="row">
                                    <div class="col-4">
                                        <label>검측가로</label>
                                        <input type="number" class="form-control" name="tw" value="<%=tw%>" placeholder="가로" onkeypress="handleKeyPress(event, 'tw', 'tw')">
                                    </div>
                                    <div class="col-4">
                                        <label>검측세로</label>
                                        <input type="number" class="form-control" name="th" value="<%=th%>" placeholder="세로" onkeypress="handleKeyPress(event, 'th', 'th')">
                                    </div>
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
                            </div>   
                        <% else %>
                            <input class="form-control" type="number" value="<%=tw%>" onclick="location.replace('TNG1_B_suju2.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                            
                            <input class="form-control" type="number" value="<%=th%>" onclick="location.replace('TNG1_B_suju2.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                        
                            <% if GREEM_F_A = 2 then 'GREEM_F_A=2(자동) , GREEM_F_A=1(수동)%>
                            <input class="form-control" type="number" value="<%=ow%>" onclick="location.replace('TNG1_B_suju2.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                          
                            <% end if %>  
                            <input class="form-control" type="number" value="<%=oh%>" onclick="location.replace('TNG1_B_suju2.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                      
                            <input class="form-control" type="number" value="<%=fl%>" onclick="location.replace('TNG1_B_suju2.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                      
                            <% if GREEM_F_A = 2 then 'GREEM_F_A=2(자동) , GREEM_F_A=1(수동)%>
                            <input class="form-control" type="number" value="<%=ow_m%>" onclick="location.replace('TNG1_B_suju2.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                      
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
                            <th class="text-center">도어합계</th>
                            <th class="text-center">총합계</th>
                        </thead>
                        <tbody  class="table-group-divider">
                            <%
                            SQL = "SELECT a.fkidx, a.sjsprice, a.py_chuga, a.doorchoice "
                            SQL = SQL & " , (SELECT SUM(door_price) "
                            SQL = SQL & "  FROM tk_framekSub b "
                            SQL = SQL & "  WHERE b.fkidx = a.fkidx "
                            SQL = SQL &" and b.doortype in (1,2) ) " '도어 타입 (1:편개, 2:양개) 
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
                                i=i+1 

                                If IsNull(door_price) Then door_price = 0

                                gibonprice = sjsprice -  py_chuga     

                                if rsjb_type_no >= 1 and rsjb_type_no <= 5 then
                                    if doorchoice="3" then  ' 도어제외 견적
                                        sjsprice_total =  sjsprice - door_price
                                    else
                                        sjsprice_total =  sjsprice + door_price
                                    end if
                                else 
                                    
                                    sjsprice_total =  sjsprice + door_price

                                end if
                            %>
                        <tr <% if Cint(tfkidx)=Cint(rfkidx) then %>class="table-warning" <% end if %>>
                            <td class="text-center"><%=i%></td> 
                            <td class="text-center"><%=FormatNumber(gibonprice, 0, -1, -1, -1)%></td>
                            <td class="text-center"><%=FormatNumber(py_chuga, 0, -1, -1, -1)%></td>
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
                        <tr <% if Cint(ufkidx)=Cint(rfkidx) then %>class="table-warning" <% end if %>>
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
                        <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                        <text id="width-label" class="dimension-label"></text>
                        <text id="height-label" class="dimension-label"></text>
                        
                            <%
                            SQL = "SELECT A.fkidx, B.fksidx, B.xi, B.yi, B.wi, B.hi"
                            SQL = SQL & ", C.set_name_FIX, C.set_name_AUTO, A.sjb_idx, b.fstype, b.blength"
                            SQL = SQL & ", B.WHICHI_FIX, B.WHICHI_AUTO, D.glassselect, E.glassselect "
                            SQL = SQL & ", B.door_w, B.door_h , B.glass_w, B.glass_h, B.ysize,b.doortype "
                            SQL = SQL & " FROM tk_framek A"
                            SQL = SQL & " LEFT OUTER JOIN tk_framekSub B ON A.fkidx = B.fkidx"
                            SQL = SQL & " LEFT OUTER JOIN tk_barasiF C ON B.bfidx = C.bfidx"
                            SQL = SQL & " LEFT OUTER JOIN tng_whichitype D ON B.WHICHI_FIX = D.WHICHI_FIX "
                            SQL = SQL & " LEFT OUTER JOIN tng_whichitype E ON B.WHICHI_AUTO = E.WHICHI_AUTO"
                            SQL = SQL & " WHERE A.sjidx = '" & rsjidx & "' AND A.sjsidx = '" & rsjsidx & "'"
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

                                if rfksidx="" then rfksidx="0" end if
                                if cint(fksidx)=cint(rfksidx) then 
                                stroke_text="#696969"
                                fill_text="#BEBEBE"
                                else
                                if cint(fkidx)=cint(rfkidx) then 
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

                                    If CInt(glassselect_auto) = 0 Then '자재는 ysize, blength 이게 A.length 구분 반전 0이 디폴트
                                                                            'a= 가로 b= 세로
                                        If CInt(WHICHI_AUTO) = 21 Then
                                            fill_text = "#FFC0CB" ' 재료분리대 우선
                                        ElseIf CInt(WHICHI_AUTO) = 20 Then
                                            fill_text = "#FA8072" ' 하부레일        
                                        Else
                                            fill_text = "#DCDCDC" ' 회색
                                        End If
                                    ElseIf CInt(glassselect_auto) = 1 Then
                                        fill_text = "#cce6ff" ' 투명 파랑 외도어
                                    ElseIf CInt(glassselect_auto) = 2 Then
                                        fill_text = "#ccccff"   ' 파랑 양개도어 (코드 누락 있음: #ccccff 등으로 수정 권장)
                                    ElseIf CInt(glassselect_auto) = 3 Then
                                        fill_text = "#FFFFE0" ' 유리
                                    ElseIf CInt(glassselect_auto) = 4 Then
                                        fill_text = "#FFFF99" ' 상부남마유리
                                    ElseIf CInt(WHICHI_AUTO) = 21 Then
                                        fill_text = "#FFC0CB" ' 재료분리대 보조조건
                                    End If
                                    
                                End If
        
                                if WHICHI_FIX<>"" and WHICHI_AUTO=0 then

                                    If CInt(glassselect_fix) = 0 Then
                                        If CInt(WHICHI_FIX) = 24 Then
                                            fill_text = "#FFC0CB" ' 재료분리대 우선
                                        Else
                                            fill_text = "#DCDCDC" ' 회색
                                        End If
                                    ElseIF CInt(glassselect_fix) = 1 Then
                                        fill_text = "#cce6ff" ' 투명 파랑 외도어
                                    ElseIF CInt(glassselect_fix) = 2 Then
                                        fill_text = "#ccccff" '  파랑 양개도어
                                    ElseIF CInt(glassselect_fix) = 3 Then
                                        fill_text = "#FFFFE0" '  유리
                                    ElseIF CInt(glassselect_fix) = 4 Then
                                        fill_text = "#FFFF99" '  상부남마유리 
                                    ElseIF CInt(glassselect_fix) = 5 Then
                                        fill_text = "#CCFFCC" '  박스라인하부픽스유리   
                                    ElseIF CInt(glassselect_fix) = 6 Then
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

                            if Cint(hi) > Cint(wi) then 
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
                        ' 예: 계산된 값을 바로 CLng으로 변환

                        
                        
                        if fstype="2" then %>
                            <defs>
                            <pattern id="diagonalHatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
                                <line x1="0" y1="0" x2="0" y2="8" stroke="black" stroke-width="2" />
                            </pattern>
                            </defs>
                            <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="url(#diagonalHatch)" stroke="black" stroke-width="2" 
                            onclick="location.replace('TNG1_B_suju2.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=fkidx%>&sjb_idx=<%=sjb_idx%>&fksidx=<%=fksidx%>');" data-value="id=<%=fksidx%>;width=<%=yblength%>;height=<%=ysize%>;"/> 
                        <% else%>
                            <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1" 
                            onclick="location.replace('TNG1_B_suju2.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=fkidx%>&sjb_idx=<%=sjb_idx%>&fksidx=<%=fksidx%>');" data-value="id=<%=fksidx%>;width=<%=yblength%>;height=<%=ysize%>;"/>
                        <% end if %>
                        <% if request("new_open")="start" then %>
                            <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1" 
                            onclick="location.replace('TNG1_B_suju2.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=fkidx%>&sjb_idx=<%=sjb_idx%>&fksidx=<%=fksidx%>&new_open=go');" data-value="id=<%=fksidx%>;width=<%=yblength%>;height=<%=ysize%>;"/>
                        <% end if %>
                        <%
                            ' 중심 좌표 계산
                            centerX = xi + (wi / 2)
                            centerY = yi + (hi / 2)

                            ' 텍스트 라인 구성
                            text_line1 = ""
                            text_line2 = ""

                            If (CInt(glassselect_auto) = 1 Or CInt(glassselect_auto) = 2) Or (CInt(glassselect_fix) = 1 Or CInt(glassselect_fix) = 2) Then

                                ' door_w * door_h
                                If IsNumeric(door_w) And IsNumeric(door_h) Then
                                    yblength = CStr(door_w) & "×" & CStr(door_h)
                                End If
                            else
                                ' glass_w * glass_h
                                If IsNumeric(glass_w) And IsNumeric(glass_h) Then
                                    yblength = CStr(glass_w) & "×" & CStr(glass_h)
                                End If

                            end if   
                        %>
                        <%
                        y = yi + (hi / 2) + 4   ' 폰트 높이 보정용
                        centerX = xi + (wi / 2)
                        centerY = yi + (hi / 2) + 4 ' 폰트 높이에 따라 조정
                        %>
                            <% if whichi_auto = 21 or whichi_fix = 24 then %>
                            <text x="<%=centerX%>" y="<%=centerY%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="15" fill="#000000" style="<%=text_direction%>">재료분리대</text>
                            <% elseif whichi_auto = 20 then %>
                            <text x="<%=centerX%>" y="<%=centerY%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="15" fill="#000000" style="<%=text_direction%>">하부레일 : <%=yblength%></text>
                            <% else %>
                            <text x="<%=centerX%>" y="<%=centerY%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="15" fill="#000000" style="<%=text_direction%>"><%=yblength%></text>
                            <% end if %>
                            <% if whichi_auto = 12 or whichi_fix = 13 or whichi_fix = 12 or  whichi_fix = 13 then %>
                                <text x="<%=centerX%>" y="<%=centerY-70%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="30" fill="#000000" font-weight="bold" style="writing-mode: horizontal-tb;"><%=doortype_text%></text>
                            <% end if %>
                            <% if whichi_auto = 23 or whichi_fix = 25 then %>
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
    </div>
    <!-- 세 번째 줄 (200px 고정) -->
    <div class="row">
        <div class="col-2">
            <div class="fixed-width">
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
                <!-- 두번째 줄 세 번째 칸 시작 -->
                    <div>
                        <% if rfkidx<>"" then %>
                            <button class="btn btn-success btn-small" type="button" Onclick="window.open('TNG1_B_doorhchg.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&SJB_TYPE_NO=<%=rSJB_TYPE_NO%>','doorchg','top=100 left=400 width=500 height=400');">기타옵션</button>
                        <% end if%>
                        <% if rfkidx<>"" and zdooryn=1 then %>
                            <button class="btn btn-secondary  btn-small" type="button" Onclick="window.open('TNG1_B_doorpop.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&SJB_TYPE_NO=<%=rSJB_TYPE_NO%>','TNG1_B_doorpop','top=100 left=400 width=1000 height=800');">도어견적</button>
                        <% end if%> 
                            <button type="button"
                                class="btn btn-outline-danger"
                                style="writing-mode: horizontal-tb; letter-spa
                                g: normal; white-space: nowrap;"
                                onclick="location.replace('TNG1_B_suju_finish_cal.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&sjb_type_no=<%=rsjb_type_no%>');">견적완료
                            </button>
                    </div> 
                <form id="dataForm3" name="dataForm3"  action="TNG1_B_jaebun.asp" method="POST" >                   
                <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                <input type="hidden" name="qtyidx" value="<%=zqtyidx%>">
                <input type="hidden" name="pidx" value="<%=pidx%>">
                <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
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
                                <%

%>
                                <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="jaebun" value="1" id="jaebun" style="width: 20px; height: 20px;"
                                    <% If  CInt(jaeryobunridae_type) = 1 Then Response.Write "checked" %>>
                                <label class="form-check-label" for="jaebun1">재분</label>
                                </div>

                                <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="jaebun" value="0" id="jaebun" style="width: 20px; height: 20px;"
                                    <% If CInt(jaeryobunridae_type) = 0 Then Response.Write "checked" %>>
                                <label class="form-check-label" for="jaebun0">재분 없음</label>
                                </div>

                                <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="jaebun" value="2" id="jaebun" style="width: 20px; height: 20px;"
                                    <% If CInt(jaeryobunridae_type) = 2 Then Response.Write "checked" %>>
                                <label class="form-check-label" for="jaebun2" style="white-space: nowrap;">재분_보강</label>
                                </div>
                            </fieldset>
                            </form>
                        </div>

                        <!-- 우측: 보양 -->
                        <div class="col-md-6" style="border: 1px solid #444; box-sizing: border-box;">
                            <form id="dataForm4" name="dataForm4" action="TNG1_B_boyang.asp" method="POST">
                            <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                            <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                            <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                            <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                            <input type="hidden" name="qtyidx" value="<%=zqtyidx%>">
                            <input type="hidden" name="pidx" value="<%=pidx%>">
                            <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
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
                                    <% If cint(boyangjea_type) = 1 Then Response.Write "checked" End If %>>
                                <label class="form-check-label" for="boyang1">보양</label>
                                </div>

                                <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="boyang" value="0" id="boyang" style="width: 20px; height: 20px;"
                                    <% If cint(boyangjea_type) = 0 Then Response.Write "checked" End If %>>
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
                                
                                if Cint(setstd)=Cint(ni) then 
                                    class_text="<u>정렬["&ni&"]번</u>"
                                else
                                    class_text="정렬["&ni&"]번"
                                end if
                                %>  
                                    <button type="button" class="btn btn-secandary" onclick="setstd('<%=ni%>','<%=rfkidx%>');"><%=class_text%></button>
                                <%
                                Next
                                %> 
                                <button type="button" class="btn btn-secandary" onclick="framedel('<%=rfkidx%>');">프레임삭제</button> 
                                <button type="button" class="btn btn-secandary" onclick="bardel('<%=rfksidx%>');">바삭제</button> 
                            </div>
                        </div>
                    </div>
            </div>
        </div>
            <div class="col-10" style="padding: 0;">    
                <div class="input-group mb-2" style="overflow-x: auto; white-space: nowrap;">
                            <%
                            yyCheck = ""
                            yyLength = ""
                            yyUnit = ""
                            yyPcent = ""
                            yyPrice = ""

                            SQL="Select B.fksidx, B.unitprice, c.pcent, B.sprice, B.blength,b.ysize,b.alength,b.gls,b.doortype"
                            SQL=SQL&" ,c.set_name_fix,c.set_name_auto "
                            SQL=SQL&" from tk_framek A "
                            SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
                            SQL=SQL&" Left OUter Join tk_barasiF C On B.bfidx=C.bfidx "
                            SQL=SQL&" Where A.sjidx='"&rsjidx&"' and A.sjsidx='"&rsjsidx&"' "
                            'Response.write (SQL)&"<br>"
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                            Do while not Rs.EOF
                                fksidx=Rs(0)
                                unitprice=Rs(1)
                                pcent=Rs(2)
                                sprice=Rs(3)
                                blength=Rs(4)
                                ysize=Rs(5)
                                alength=Rs(6)
                                gls=Rs(7)
                                doortype=Rs(8)
                                set_name_fix=Rs(9)
                                set_name_auto=Rs(10)

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

                                if rfksidx="" then rfksidx="0" end if
                                lbn=lbn+1

                                yyCheck = yyCheck & "<td><input type='checkbox' class='form-check-input' name='afksidx' value='" & fksidx & "'></td>"

                                If CInt(rfksidx) = CInt(fksidx) Then
                                yylbn = yylbn & "<td style=background:#80ff80; >" & lbn & "</td>"
                                else
                                yylbn = yylbn & "<td>" & lbn & "</td>"
                                end if

                                If CInt(rfksidx) = CInt(fksidx) Then
                                yygls_text = yygls_text & "<td style=background:#80ff80; >" & gls_text & "</td>"
                                else
                                yygls_text = yygls_text & "<td>" & gls_text & "</td>"
                                end if

                                If CInt(rfksidx) = CInt(fksidx) Then
                                yybar_name = yybar_name & "<td style=background:#80ff80; >" & bar_name & "</td>"
                                else
                                yybar_name = yybar_name & "<td>" & bar_name & "</td>"
                                end if

                                If CInt(rfksidx) = CInt(fksidx) Then
                                yyysize = yyysize & "<td style=background:#80ff80; >" & ysize & "</td>"
                                else
                                yyysize = yyysize & "<td>" & ysize & "</td>"
                                end if

                                If CInt(rfksidx) = CInt(fksidx) Then
                                yyLength = yyLength & "<td style=background:#80ff80; >" & blength & "</td>"
                                else
                                yyLength = yyLength & "<td>" & blength & "</td>"
                                end if
                                
                                If CInt(rfksidx) = CInt(fksidx) Then
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

                                If CInt(rfksidx) = CInt(fksidx) Then
                                yyPcent = yyPcent & "<td style=background:#80ff80;>" & pcent & "%</td>"
                                else
                                yyPcent = yyPcent & "<td>" & pcent & "%</td>"
                                end if

                                If CInt(rfksidx) = CInt(fksidx) Then
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
                                <tr >
                                    <td><i class="fa-solid fa-clone" style="color: #74C0FC;" onclick="wincopy();"></i></td>
                                    <%= yyCheck %>
                                </tr>
                                <tr >
                                    <td style="white-space: nowrap;">
                                    <button type="button" class="btn btn-secondary btn-small" onclick="barchange1();">자재변경</button>
                                    </td>
                                    <%= yylbn %>
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

  <!-- 드롭다운 스크립트 -->
  <script>
    let currentOpen = null;
    function toggleDropdown(num) {
      const selected = document.getElementById(`dropdown-${num}`);
      if (currentOpen === num) {
        selected.style.display = 'none';
        currentOpen = null;
      } else {
        for (let i = 1; i <= 6; i++) {
          const el = document.getElementById(`dropdown-${i}`);
          if (el) el.style.display = 'none';
        }
        selected.style.display = 'block';
        currentOpen = num;
      }
    }
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
