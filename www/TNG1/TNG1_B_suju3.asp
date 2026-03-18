
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
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")

  listgubun="one" 
  projectname="수주"

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
 ' 비활성화 상태임 수정해야해
  rtw = Request("tw")  ' 검측가로
  rth = Request("th")  ' 검측세로

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
if rsjsidx<>"" then 
 
  if rqtyidx<>"0" then 
  SQL="Update tng_sjaSub set qtyidx='"&rqtyidx&"' "
  SQL=SQL&" ,asub_wichi1='"&rasub_wichi1&"',asub_wichi2='"&rasub_wichi2&"',asub_bigo1='"&rasub_bigo1&"',asub_bigo2='"&rasub_bigo1&"'"
  SQL=SQL&" ,asub_bigo3='"&rasub_bigo3&"',asub_meno1='"&rasub_meno1&"',asub_meno2='"&rasub_meno2&"' " 
  SQL=SQL&" Where sjsidx='"&rsjsidx&"'" 
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
  end If

  SQL="select mwidth, mheight, qtyidx, sjsprice, disrate, disprice, fprice, sjb_idx "
  SQL=SQL&",asub_wichi1,asub_wichi2,asub_bigo1,asub_bigo2,asub_bigo3,asub_meno1,asub_meno2 "
  SQL=SQL&" From tng_sjaSub  "
  SQL=SQL&" Where sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"' "
  'response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    rmwidth=Rs(0)  '검측가로
    rmheight=Rs(1)  '검측세로
    rqtyidx=Rs(2)  '재질
    rsjsprice=Rs(3)  '주문품목가격
    rdisrate=Rs(4)  '주문품목할인율
    rdisprice=Rs(5)  '주문품목할인가격
    rfprice=Rs(6)  '주문품목 최종가격
    msjb_idx=Rs(7)  '메인여부
    asub_wichi1=Rs(8)
    asub_wichi2 =Rs(9)
    asub_bigo1=Rs(10)
    asub_bigo2=Rs(11)
    asub_bigo3=Rs(12)
    asub_meno1 =Rs(13)
    asub_meno2 =Rs(14)
  End If
  Rs.Close

else
  response.write"<script>window.open('TNG1_B_totalsize.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"','TNG1_B_totalsize','top=100 left=100 width=400 height=250');</script>"

End if
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
  SQL="Select  A.fidx, B.xi, B.yi, B.wi, B.hi, A.fl "
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
  <link href="/tng1/TNG1_B_suju.css"  rel="stylesheet">
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
<!-- SweetAlert2 CDN -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <script>
        // 공통 키프레스 핸들러
        function handleKeyPress(event, elementId1, elementId2) {
            if (event.key === "Enter") {
                event.preventDefault();
                console.log(`Enter 눌림: ${elementId1}, ${elementId2}`);
                document.getElementById("hiddenSubmit").click();
            }
        }

        // Select 박스 변경(마우스 클릭/선택) 이벤트 핸들러
        function handleSelectChange(event, elementId1, elementId2) {
            console.log(`선택 변경됨: ${elementId1}, ${elementId2}`);
            document.getElementById("hiddenSubmit").click();
        }

        function handleChange(selectElement) {
            const selectedValue = selectElement.value;
            document.getElementById("hiddenSubmit").click();
        }

        // 폼 전체 Enter 이벤트 감지 (기본 방지 + 숨겨진 버튼 클릭)
        document.getElementById("dataForm").addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                event.preventDefault(); // 기본 Enter 동작 방지
                console.log("폼 전체에서 Enter 감지");
                document.getElementById("hiddenSubmit").click();
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
            location.href="TNG1_B_suju2.asp?part=framedel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&jaebun=<%=rjaebun%>&boyang=<%=rboyang%>&fkidx="+fkidx;
        }
    }
    function bardel(fksidx){
        if (confirm("바를 삭제 하시겠습니까?"))
        {
            location.href="TNG1_B_suju2.asp?part=bardel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&jaebun=<%=rjaebun%>&boyang=<%=rboyang%>&fksidx="+fksidx;
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




    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
    <input type="hidden" name="fksidx" value="<%=rfksidx%>">
    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
    <input type="hidden" name="mode" value="kblength">

<style>
    /* A4 크기 컨테이너 */
.container-fluid {
  width: 297mm;        /* A4 폭 */
  height: 210mm;       /* A4 높이 */
  margin: 0 auto;      /* 가운데 정렬 */
  padding: 0;          /* 여백 제거 */
  box-sizing: border-box;  /* border 포함 크기 계산 */
  border: 1mm solid #000;  /* 실선 윤곽선 (두께 1mm, 검은색) */
  /* 또는 outline 사용 */
  /* outline: 0.5mm dashed #666; */
}
</style>

        <!-- 가운데 SVG 영역 -->  
            <!-- 두번째 줄 두 번째 칸 시작 -->
                <div class="canvas-container" id="svgCanvas" style="width: 100%; height: 100%; padding: 0px;" data-total-width="<%=rmwidth%>" data-total-height="<%=rmheight%>">
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
                            SQL = SQL & ", B.door_w, B.door_h , B.glass_w, B.glass_h, B.ysize,b.doortype,b.garo_sero,b.alength,a.ow,a.oh,a.fl "
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
                                garo_sero = Rs(21)
                                alength = Rs(22)
                                ow = Rs(23)
                                oh = Rs(24)
                                fl = Rs(25)


                  

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

                            ' 가로/세로 실제 표기값 계산 (반전만 적용)
                            Dim real_wi, real_hi
                            
                            If glassselect_auto <> 0 Then
                              real_wi = alength
                              real_hi = yblength
                            Else
                              If garo_sero = 1 Then
                                real_wi = ysize      ' 가로 ← ysize
                                real_hi = yblength   ' 세로 ← yblength
                              Else
                                real_wi = yblength         ' 가로 ← wi
                                real_hi = ysize         ' 세로 ← hi
                              End If
                            End If
                      
                            %>
                            <%
' AUTO 우선
If WHICHI_AUTO <> "" And CInt(WHICHI_FIX) = 0 Then
  Select Case CInt(glassselect_auto)
    Case 0
      Select Case CInt(WHICHI_AUTO)
        Case 21: rect_type = "재료분리대"
        Case 20: rect_type = "하부레일"
        Case Else: rect_type = "자재"
      End Select
    Case 1: rect_type = "외도어"
    Case 2: rect_type = "양개도어"
    Case 3: rect_type = "유리"
    Case 4: rect_type = "상부남마유리"
    Case Else: rect_type = "기타"
  End Select
End If

' FIX
If WHICHI_FIX <> "" And CInt(WHICHI_AUTO) = 0 Then
  Select Case CInt(glassselect_fix)
    Case 0
      If CInt(WHICHI_FIX) = 24 Then
        rect_type = "재료분리대"
      Else
        rect_type = "자재"
      End If
    Case 1: rect_type = "외도어"
    Case 2: rect_type = "양개도어"
    Case 3: rect_type = "유리"
    Case 4: rect_type = "상부남마유리"
    Case 5: rect_type = "박스라인하부픽스유리"
    Case 6: rect_type = "박스라인상부픽스유리"
    Case Else: rect_type = "기타"
  End Select
End If
%>


                        <% 
                        if fstype="2" then %>
                            <defs>
                                <pattern id="diagonalHatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
                                    <line x1="0" y1="0" x2="0" y2="8" stroke="black" stroke-width="2" />
                                </pattern>
                            </defs>
                            <rect 
                                x="<%=xi%>" 
                                y="<%=yi%>" 
                                width="<%=wi%>" 
                                height="<%=hi%>" 
                                fill="url(#diagonalHatch)" 
                                stroke="black" 
                                stroke-width="2"
                                data-value="width=<%=real_wi%>,height=<%=real_hi%>" 
                                data-type="<%=rect_type%>" 
                            />
                        <% else %>
                            <rect 
                                x="<%=xi%>" 
                                y="<%=yi%>" 
                                width="<%=wi%>" 
                                height="<%=hi%>" 
                                fill="<%=fill_text%>" 
                                stroke="<%=stroke_text%>" 
                                stroke-width="1"
                                data-value="width=<%=real_wi%>,height=<%=real_hi%>"
                                data-type="<%=rect_type%>" 
                            />
                        <% end if %>

                        <% if request("new_open")="start" then %>
                            <rect 
                                x="<%=xi%>" 
                                y="<%=yi%>" 
                                width="<%=wi%>" 
                                height="<%=hi%>" 
                                fill="<%=fill_text%>" 
                                stroke="<%=stroke_text%>" 
                                stroke-width="1"
                                data-value="width=<%=real_wi%>,height=<%=real_hi%>"
                                data-type="<%=rect_type%>" 
                            />
                        <% end if %>
                        <%
                            ' 중심 좌표 계산
                            centerX = xi + (wi / 2)
                            centerY = yi + (hi / 2)

                            ' 텍스트 라인 구성
                            text_line1 = ""
                            text_line2 = ""

                            ' door_w * door_h
                            If IsNumeric(door_w) And IsNumeric(door_h) Then
                                yblength = CStr(door_w) & "×" & CStr(door_h)
                            End If

                            ' glass_w * glass_h
                            If IsNumeric(glass_w) And IsNumeric(glass_h) Then
                                yblength = CStr(glass_w) & "×" & CStr(glass_h)
                            End If
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
                            ow=""
                            oh=""
                            fl=""
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
  
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- 도면 수치 표현 모듈 - 엣지 주석기 -->
<script src="/schema/total.js"></script>
<script src="/schema/horizontal.js"></script>
<script src="/schema/vertical.js"></script>
<script src="/schema/zoom.js"></script>
<script src="/schema/intergrate.js"></script>

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
