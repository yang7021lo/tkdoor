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

  rqtyidx=Request("qtyidx") '재질키
  rmwidth=Request("mwidth") '검측가로
  rmheight=Request("mheight") '검측세로

  rblength=Request("blength") '바의 길이
  'response.write rqtyidx&"/<br>"
  'response.write rmwidth&"/<br>"
  'response.write rmheight&"/<br>"
if rgreem_f_a = "" then rgreem_f_a=1 end if
if rGREEM_BASIC_TYPE = "" then rGREEM_BASIC_TYPE=0 end if
if rgreem_o_type = "" then rgreem_o_type=0 end if
if rGREEM_FIX_TYPE = "" then rGREEM_FIX_TYPE=0 end if
if rgreem_habar_type = "" then rgreem_habar_type=0 end if
if rgreem_lb_type = "" then rgreem_lb_type=0 end if
if rGREEM_MBAR_TYPE = "" then rGREEM_MBAR_TYPE=0 end if
if rqtyidx = "" then rqtyidx=0 end if

if rgreem_f_a="2" then 
  rgreem_habar_type = "0"
  rgreem_lb_type = "0"
  rGREEM_MBAR_TYPE = "0"
  rgreem_basic_type = "5"
  rGREEM_O_TYPE = "0"
end if

SearchWord=Request("SearchWord")
gubun=Request("gubun")

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="tng1_greemlist3.asp?listgubun="&listgubun&"&"

'바의 길이 입력하면 단가와 할증 그리고 가격 입력하기 시작
'===================
If rfksidx<>"" Then 

    if rblength<>"" then    
        SQL="Update tk_framekSub  "
        SQL=SQL&" Set blength='"&rblength&"' "
        SQL=SQL&" Where fksidx='"&rfksidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    end if

SQL="select A.fksidx, A.xi, A.yi, A.wi, A.hi, A.WHICHI_AUTO, A.WHICHI_FIX "
SQL=SQL&" , A.bfidx, B.set_name_Fix, B.set_name_AUTO, B.bfimg1, B.bfimg2, B.bfimg3, B.tng_busok_idx, B.tng_busok_idx2, B.pcent "
SQL=SQL&" , A.blength, A.unitprice, A.sprice, A.bfidx, A.whichi_fix, A.whichi_auto "
SQL=SQL&" From tk_framekSub A "
SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
Response.write (SQL)&"<br>"
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
pcent=Rs(15)

blength=Rs(16)
unitprice=Rs(17)
sprice=Rs(18)
bfidx=Rs(19)
whichi_fix=Rs(20)
whichi_auto=Rs(21)

If abfidx="0" or isnull(abfidx) then 
  aset_name_AUTO="없음"
  aset_name_Fix="없음"
end if 
'Response.write blength&"/"

    if rblength<>"" then

        If whichi_fix > 0 Then
        SQL="Select bfwidx from tng_whichitype where whichi_fix='"&whichi_fix&"'" 
        ElseIf whichi_auto > 0 Then
        SQL="Select bfwidx from tng_whichitype where whichi_auto='"&whichi_auto&"'" 
        End If
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            bfwidx=Rs1(0)
        End If
        Rs1.Close

        SQL = "SELECT TOP 1 B.qtyco_idx " 
        SQL = SQL & "FROM tk_qty A "
        SQL = SQL & "JOIN tk_qtyco B ON A.QTYNo = B.QTYNo "
        SQL = SQL & "WHERE A.qtyidx = '" & rqtyidx & "' "
        SQL = SQL & "AND B.sheet_h >= '" & blength & "' "
        SQL = SQL & "ORDER BY B.sheet_h ASC "
        'Response.write (SQL)&"<br><br>"

        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            qtyco_idx=Rs1(0)
        End If
        Rs1.Close

        SQL="Select price From tng_unitprice_f Where sjb_idx='"&rsjb_idx&"' and qtyidx='"&rqtyidx&"' and bfwidx='"&bfwidx&"' and qtyco_idx='"&qtyco_idx&"' "
        'Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            unitprice=Rs1(0)
            'response.write "단가:"&unitprice&"<br>"
        End If
        Rs1.Close


        sprice = unitprice * pcent '할증적용 가격

        SQL="Update tk_framekSub  "
        SQL=SQL&" Set unitprice='"&unitprice&"', pcent='"&pcent&"', sprice='"&sprice&"' "
        SQL=SQL&" Where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)


        ' 설정 품목 가격 등록 
        SQL="Select Sum(sprice) from tk_framekSub where fkidx in (select fkidx from tk_framek where sjsidx='"&rsjsidx&"') "
        'Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            sjsprice=Rs1(0)
            'response.write "단가:"&unitprice&"<br>"
        End If
        Rs1.Close

        sjsprice=sjsprice                 '품목의 산출 가격
        disrate=0                         '할인율
        disprice=0                        '할인금액
        fprice=sjsprice-fprice            '납품금액
        taxrate=10                        '세금
        quan=1                            '수량
        sprice=fprice*(taxrate/100)*quan  '최종금액

        SQL="Update tng_sjaSub set sjsprice='"&sjsprice&"', disrate='"&disrate&"',disprice='"&disprice&"', fprice='"&fprice&"', quan='"&quan&"' "
        SQL=SQL&" , taxrate='"&taxrate&"', sprice='"&sprice&"' "
        SQL=SQL&" Where sjsidx='"&rsjsidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
        End If
        Rs.Close

    End If

End If
'===================
'바의 길이 입력하면 단가와 할증 그리고 가격 입력하기 끝




'품목정보가 없을 경우 생성 시작
'===================
if rsjsidx<>"" then 
 
  if rqtyidx<>"0" then 
  SQL="Update tng_sjaSub set qtyidx='"&rqtyidx&"', mwidth='"&rmwidth&"', mheight='"&rmheight&"' Where sjsidx='"&rsjsidx&"'"
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
  end If

  SQL="select mwidth, mheight, qtyidx, sjsprice, disrate, disprice, fprice, sjb_idx "
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
  End If
  Rs.Close

else
  SQL="Insert into tng_sjaSub (sjidx, midx, mwdate, meidx, mewdate, mwidth, mheight, qtyidx, sjsprice, disrate, disprice, fprice) "
  SQL=SQL&" values ('"&rsjidx&"', '"&C_midx&"', getdate(), '"&C_midx&"', getdate(), '"&mwidth&"', '"&mheight&"', '"&rqtyidx&"', '"&sjsprice&"', '"&disrate&"', '"&disprice&"', '"&fprice&"')"
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
  SQL="Select max(sjsidx) from tng_sjaSub "
  Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
    rsjsidx=Rs(0)
  Rs.Close
  response.write "<script>location.replace('TNG1_B_suju.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"')</script>"
End if
'===================
'품목정보가 없을 경우 생성 끝


'수주 기본 정보불러오기
'===================
SQL="Select Convert(Varchar(10),A.sjdate,121), A.sjnum, Convert(Varchar(10),A.cgdate,121), Convert(Varchar(10),A.djcgdate,121) "
SQL=SQL&" , A.cgtype, A.cgaddr, A.cgset, A.sjmidx, A.sjcidx, A.midx, A.wdate, A.meidx, A.mewdate  "
SQL=SQL&" , B.cname, C.mname, C.mtel, C.mhp, C.mfax, C.memail, D.mname, E.mname "
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
'품목변경 시작
'=======================================
if Request("part")="chgbarasif" then 
  rbfidx=Request("bfidx")  'plus 가로늘리기 minus 가로줄이기
 
  SQL=" Update tk_framekSub set bfidx='"&rbfidx&"' where fksidx='"&rfksidx&"' "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
 
end if
'=======================================
'품목변경 끝
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
        window.location.href = "TNG1_B_suju.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx="+sjb_idx+"&fknickname="+encodedMessage;
      }
    }
    function framedel(fkidx){
        if (confirm("프레임을 삭제 하시겠습니까?"))
        {
            location.href="TNG1_B_suju.asp?part=framedel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx="+fkidx;
        }
    }
    function bardel(fksidx){
        if (confirm("바를 삭제 하시겠습니까?"))
        {
            location.href="TNG1_B_suju.asp?part=bardel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx="+fksidx;
        }
    }

    function setstd(ni,fkidx){

        {
            location.href="TNG1_B_suju.asp?part=setstd&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx="+fkidx+"&ni="+ni;
        }
    }
    function wresize(order){
        {
            location.href="TNG1_B_suju.asp?part=wresize&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&order="+order;
        }
    }
    function hresize(order){
        {
            location.href="TNG1_B_suju.asp?part=hresize&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&order="+order;
        }
    }
    function converge(direction){
        {
            location.href="TNG1_B_suju.asp?part=converge&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&direction="+direction;
        }
    }
    function chgbarasif(bfidx){
        if (confirm("바의 품목을 변경 하시겠습니까?"))
        {
            location.href="TNG1_B_suju.asp?part=chgbarasif&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&bfidx="+bfidx;
        }
    }
    function addglass(glasstype, wsize, hsize){
        {
            location.href="TNG1_B_suju.asp?part=addglass&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&gubun=glass&glasstype="+glasstype+"&wsize="+wsize+"&hsize="+hsize;
        }
    }
 
    function addcovered(alocation){
        {
            location.href="TNG1_B_suju.asp?part=addcovered&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&gubun=covered&alocation="+alocation;
        }
    }
  </script>
</head>
<body>
<form id="dataForm" action="TNG1_B_suju.asp" method="POST" >   
    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
    <input type="hidden" name="fksidx" value="<%=rfksidx%>">
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
    <!-- 두 번째 줄 (가변 높이 3칸) -->
    <div class="second-row">
      <div class="second-fixed">
        <div class="mb-2">
<select name="sjb_type_no" class="form-control" id="sjb_type_no"  onchange="handleChange(this)">
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
  <option value="<%=sjb_type_no%>" <% if Cint(sjb_type_no)=Cint(rsjb_type_no) then response.write "selected" end if %>><%=sjb_type_name%>/<%=sjb_type_no%></option>
<%
Rs.movenext
Loop
End if
Rs.close
'
%>
</select>
        </div>

        <div class="mb-2">
          <% Response.write (SQL)&"<br><br>" %>

        
      <!-- 드롭다운 버튼 시작-->
<% if rsjb_type_no<>"" then %> 
        <div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
            품목선택
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
  '  greem_f_a="1"
  'elseif  right(sjb_type_name,3)="프레임" then 
  '  greem_f_a="2"
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
        

       
        </div>
<!-- 생성된 도면 정보 시작 -->
 
        <div class="mb-2">

<%
SQL = " Select fkidx, fknickname, fname, fstatus, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE "
SQL = SQL & " ,GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, setstd, sjb_idx "
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
    if Cint(msjb_idx)=Cint(sjb_idx) then maintext="[m]" end if
%>
        <div class="input-group mb-1">     
            <input type="text" class="form-control" value="<%=maintext%><%=fname%>_<%=setstd%>" onclick="location.replace('TNG1_B_suju.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>');" <% if Cint(fkidx)=Cint(rfkidx) then %>style="background-color: #D3D3D3;" <% end if %>>  
        </div>
        <div class="input-group mb-1">     
            <input type="number" class="form-control" name="tw" id="tw" placeholder="tw"  value="<%=tw%>" onkeypress="handleKeyPress(event, 'tw', 'tw')">
            <input type="number" class="form-control" name="th" id="th" placeholder="th"  value="<%=th%>" onkeypress="handleKeyPress(event, 'th', 'th')">
            <input type="number" class="form-control" name="ow" id="ow" placeholder="ow"  value="<%=ow%>" onkeypress="handleKeyPress(event, 'ow', 'ow')">
            <input type="number" class="form-control" name="oh" id="oh" placeholder="oh"  value="<%=oh%>" onkeypress="handleKeyPress(event, 'oh', 'oh')">
        </div>
        
<%
    maintext=""
    Rs.movenext
    Loop
    End if
    Rs.close
%>   

        </div>
 
       
<!-- 생성된 도면정보 끝 -->

        <div class="mb-2">
 

        </div>
        <div class="card-body">
          <div class="input-group mb-2">
            <span for="bendName" class="input-group-text">스텐재질</span>
            <select name="qtyidx" class="form-control" id="qtyidx"  onchange="handleChange(this)">
              <option value="0" <% if rqtyidx="" then %>selected<% end if %>없음/<%=qtyidx%>/<%=rqtyidx%></option>
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
                <option value="<%=qtyidx%>" <% if Cint(qtyidx)=Cint(rqtyidx) then %> selected <% end if %> ><%=qtyname%></option>
<%
Rs.movenext
Loop
End if
Rs.close
%>
            </select>
          </div>
          <div class="input-group mb-2">
            <input type="number" class="form-control" name="mwidth" id="mwidth" placeholder="검측가로"  value="<%=rmwidth%>" onkeypress="handleKeyPress(event, 'mwidth', 'mwidth')">
            <input type="number" class="form-control" name="mheight" id="mheight" placeholder="검측세로"  value="<%=rmheight%>" onkeypress="handleKeyPress(event, 'mheight', 'mheight')">
          </div>
<%

%>
          <div class="input-group mb-2">

          </div>
<% if rfksidx<>"" then %>
          <div class="input-group mb-2">
            <span for="bendName" class="input-group-text">바의길이</span>
            <input type="number" class="form-control" name="blength" id="blength" placeholder="숫자"  value="<%=blength%>" onkeypress="handleKeyPress(event, 'blength', 'blength')">
          </div>
<% end if %>

          <div class="input-group mb-2">
            <table class="table">
              <thead>
                <th class="text-center">길이</th>
                <th class="text-center">단가</th>
                <th class="text-center">할증</th>
                <th class="text-center">가격</th>
              </thead>
              <tbody  class="table-group-divider">
<%
SQL="Select B.fksidx, B.unitprice, B.pcent, B.sprice, B.blength"
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
  if rfksidx="" then rfksidx="0" end if
%>
              <tr <% if Cint(fksidx)=Cint(rfksidx) then %>class="table-warning" <% end if %>>
                <td class="text-center"><%=blength%></td>      
                <td class="text-center"><%=unitprice%></td>
                <td class="text-center"><%=pcent%></td>
                <td class="text-center"><%=sprice%></td>
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

        
        <div class="line"> </div>
        <div class="mb-2">
 
        </div>
 
        <div class="line menu-line">
          <div class="menu-container">
          
            <div class="dropdown-header" onclick="toggleDropdown(1)">검측정보</div>
            <div class="dropdown-content" id="dropdown-1">
              <div class="input-group">
                <label>검측가로</label><input type="text" name="menu1_input1" class="form-control">
              </div>
              <div class="input-group">
                <label>검측높이</label><input type="text" name="menu1_input2" class="form-control">
              </div>
              <div class="input-group">
                <label>바닥묻힘</label><input type="text" name="menu1_input3" class="form-control">
              </div>
            </div>

            <div class="dropdown-header" onclick="toggleDropdown(2)">자동옵션정보</div>
            <div class="dropdown-content" id="dropdown-2">
              <div class="input-group">
                <label>항목 1</label><input type="text" name="menu2_input1" class="form-control">
              </div>
              <div class="input-group">
                <label>항목 2</label><input type="text" name="menu2_input2" class="form-control">
              </div>
              <div class="input-group">
                <label>항목 3</label><input type="text" name="menu2_input3" class="form-control">
              </div>
            </div>
       
          </div>
        </div>
 
      </div>

      <div class="second-flex-grow" >

      <!-- 두번째 줄 두 번째 칸 시작 -->
 
            <div class="canvas-container" id="svgCanvas" style="width: 100%; height: 100%; padding: 10px;">
                <div class="svg-container">
                    <svg id="canvas" width="100%" height="100%" class="d-block">
                    <g id="viewport" transform="translate(0, 0) scale(1)">
                    <rect id="rectangle" fill="white" stroke="black" stroke-width="1" width="0" height="0"></rect>
                    <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                    <text id="width-label" class="dimension-label"></text>
                    <text id="height-label" class="dimension-label"></text>
                    
                        <%
 
                        SQL="Select A.fkidx, B.fksidx, B.xi, B.yi, B.wi, B.hi ,C.set_name_Fix, C.set_name_AUTO, A.sjb_idx, fstype,blength"
                        SQL=SQL&" from tk_framek A "
                        SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
                        SQL=SQL&" Left OUter Join tk_barasiF C On B.bfidx=C.bfidx "
                        SQL=SQL&" Where A.sjidx='"&rsjidx&"' and A.sjsidx='"&rsjsidx&"' "
                        'Response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            i=i+1
                            fkidx=Rs(0)
                            fksidx=Rs(1)
                            xi=Rs(2)
                            yi=Rs(3)
                            wi=Rs(4)
                            hi=Rs(5)
                            set_name_Fix=Rs(6)
                            set_name_AUTO=Rs(7)
                            sjb_idx=Rs(8)
                            fstype=Rs(9)
                            yblength=rs(10)

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

                        if Cint(hi) > Cint(wi) then 
                          text_direction="writing-mode: vertical-rl; glyph-orientation-vertical: 0;"
                        else
                          text_direction=""
                        end if 
                        %>
<% if fstype="2" then %>
    <defs>
      <pattern id="diagonalHatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
        <line x1="0" y1="0" x2="0" y2="8" stroke="black" stroke-width="2" />
      </pattern>
    </defs>
                        <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="url(#diagonalHatch)" stroke="black" stroke-width="2" onclick="location.replace('TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>&fksidx=<%=fksidx%>');"/>
<% else %>
                        <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1" onclick="location.replace('TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>&fksidx=<%=fksidx%>');"/>
<% end if %>
                        <text x="<%=xi+10%>" y="<%=yi+15%>" font-family="Arial" font-size="14" fill="#000000" style="<%=text_direction%>"><%=set_name_Fix%><%=set_name_AUTO%>_길이=<%=yblength%></text>
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

      <div class="second-fixed">
      <!-- 두번째 줄 세 번째 칸 시작 -->
<div class="container mt-2" style="padding:2px;" >
  <div class="button-grid">

<%
if rfksidx<>"" then 
%>
    <button type="button" class="btn btn-secandary" onclick="wresize('minus');">가로바줄이기</button> 
    <button type="button" class="btn btn-secandary" onclick="wresize('plus');">가로바늘이기</button> 
    <button type="button" class="btn btn-secandary" onclick="hresize('minus');">세로바줄이기</button> 
    <button type="button" class="btn btn-secandary" onclick="hresize('plus');">세로바늘이기</button> 
    <button type="button" class="btn btn-secandary" onclick="converge('movel');">좌측이동</button> 
    <button type="button" class="btn btn-secandary" onclick="converge('mover');">우측이동</button> 
    <button type="button" class="btn btn-secandary" onclick="converge('moveu');">위로이동</button> 
    <button type="button" class="btn btn-secandary" onclick="converge('moved');">아래로이동</button> 
<%
end if
%>    
<!--    
    <button type="button" class="btn btn-secandary" onclick="converge('left');">좌측붙이기</button> 
    <button type="button" class="btn btn-secandary" onclick="converge('right');">우측붙히기</button> 
-->
  </div>
</div>
<div class="container mt-2" style="padding:2px;" >
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
<% if rfkidx<>"" then %>

<div class="container mt-2" style="padding:2px;" >
  <div class="button-grid">
    <button type="button" class="btn btn-secandary" onclick="location.replace('TNG1_B_suju.asp?gubun=glass&sjidx=<%=rsjidx%>&sjb_idx=<%=rsjb_idx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>');">유리추가</button>
<% if rfksidx<>"" then %>
    <button type="button" class="btn btn-secandary" onclick="location.replace('TNG1_B_suju.asp?gubun=covered&sjidx=<%=rsjidx%>&sjb_idx=<%=rsjb_idx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>');">묻힘추가</button>
<% else %>
   <button type="button" class="btn btn-secandary" onclick="alert('적용 할 세로바를 먼전 선택 하세요.');">묻힘추가</button>
<% end if%>
  </div>
</div>

<% if Request("gubun")="glass" then %>
<div class="container mt-0" style="padding:2px;" >
  <div class="button-grid">
  <%
  sql = "SELECT sjbtidx, SJB_TYPE_NO, SJB_TYPE_NAME , sjbtstatus"
  sql = sql & " , dwsize1, dhsize1, dwsize2, dhsize2, dwsize3, dhsize3, dwsize4, dhsize4, dwsize5, dhsize5"
  sql = sql & " , gwsize1, ghsize1, gwsize2, ghsize2, gwsize3, ghsize3, gwsize4, ghsize4, gwsize5, ghsize5, gwsize6, ghsize6 "
  sql = sql & " , SJB_FA "
  sql = sql & " FROM tng_sjbtype "
  sql = sql & " WHERE sjbtstatus = 1 and SJB_TYPE_NO='"&rsjb_type_no&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon,1,1,1
  if not (Rs.EOF or Rs.BOF ) then
      sjbtidx       = Rs(0)
      SJB_TYPE_NO   = Rs(1)
      SJB_TYPE_NAME = Rs(2)
      sjbtstatus    = Rs(3)

      dwsize1       = Rs(4)
      dhsize1       = Rs(5)
      dwsize2       = Rs(6)
      dhsize2       = Rs(7)
      dwsize3       = Rs(8)
      dhsize3       = Rs(9)
      dwsize4       = Rs(10)
      dhsize4       = Rs(11)
      dwsize5       = Rs(12)
      dhsize5       = Rs(13)

      gwsize1       = Rs(14)
      ghsize1       = Rs(15)
      gwsize2       = Rs(16)
      ghsize2       = Rs(17)
      gwsize3       = Rs(18)
      ghsize3       = Rs(19)
      gwsize4       = Rs(20)
      ghsize4       = Rs(21)
      gwsize5       = Rs(22)
      ghsize5       = Rs(23)
      gwsize6       = Rs(24)
      ghsize6       = Rs(25)

      SJB_FA        = rs(26)
%>
  <% if dwsize1<>"0" or dhsize1<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('d1','<%=dwsize1%>','<%=dhsize1%>');">외도어편개</button>
  <% end if %>
  <% if dwsize2<>"0" or dhsize2<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('d2','<%=dwsize2%>','<%=dhsize2%>');">양개</button>
  <% end if %>
  <% if dwsize3<>"0" or dhsize3<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('d3','<%=dwsize3%>','<%=dhsize3%>');">언밸런스</button>
  <% end if %>
  <% if dwsize4<>"0" or dhsize4<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('d4','<%=dwsize4%>','<%=dhsize4%>');">도어4</button>
  <% end if %>
  <% if dwsize5<>"0" or dhsize5<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('d5','<%=dwsize5%>','<%=dhsize5%>');">도어5</button>
  <% end if %>

  <% if gwsize1<>"0" or ghsize1<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('g1','<%=gwsize1%>','<%=ghsize1%>');">하부픽스1</button>
  <% end if %>
  <% if gwsize2<>"0" or ghsize2<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('g2','<%=gwsize2%>','<%=ghsize2%>');">박스라인하부픽스2</button>
  <% end if %>
  <% if gwsize3<>"0" or ghsize3<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('g3','<%=gwsize3%>','<%=ghsize3%>');">상부픽스1</button>
  <% end if %>
  <% if gwsize4<>"0" or ghsize4<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('g4','<%=gwsize4%>','<%=ghsize4%>');">상부픽스2</button>
  <% end if %>
  <% if gwsize5<>"0" or ghsize5<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('g5','<%=gwsize5%>','<%=ghsize5%>');">상부픽스3</button>
  <% end if %>
  <% if gwsize6<>"0" or ghsize6<>"0" then %>
    <button type="button" class="btn btn-secandary" onclick="addglass('g6','<%=gwsize6%>','<%=ghsize6%>');">상부픽스4</button>
  <% end if %>
<%
End If 
Rs.Close 
%>   

  </div>
</div> 
<% end if %>
<% if Request("gubun")="covered" then %>
<div class="container mt-0" style="padding:2px;" >
  <div class="button-grid">
<button type="button" class="btn btn-secandary" onclick="addcovered('top');">상단묻힘</button>
<button type="button" class="btn btn-secandary" onclick="addcovered('bottom');">하단묻힘</button>
  </div>
</div> 
<% end if %>


<% end if %> 
      <!-- 두번째 줄 세 번째 칸 끝 -->
      </div>
    </div>

    <!-- 세 번째 줄 (200px 고정) -->
    <div class="third-row">
      <div class="third-inner">
        <div class="fixed-width">
          <!-- 세 번째 줄 첫 번째 칸 (300px) -->
              <div class="card card-custom">
                <div class="card-header"><%=aset_name_AUTO%><%=aset_name_Fix%></div>
                <div class="card-body">
                  <% if abfimg3<>"" then %>
                    <img src="/img/frame/bfimg/<%=abfimg3%>" loading="lazy" width="180" height="100"  border="0">
                  <% elseif abfimg1<>"" then %>
                    <img src="/img/frame/bfimg/<%=abfimg1%>" loading="lazy" width="180" height="100"  border="0">
                  <% elseif abfimg2<>"" then %>
                    <img src="/img/frame/bfimg/<%=abfimg2%>" loading="lazy" width="180" height="100"  border="0">
                  <% end if %>
                </div>
              </div>
        </div>
        <div class="flex-grow">
          <div class="scroll-container">


<%
SQL=" Select bfidx, set_name_Fix, set_name_AUTO, whichi_auto, whichi_fix, xsize, ysize, bfimg1, bfimg2, bfimg3 "
SQL=SQL&" , tng_busok_idx, tng_busok_idx2 "
SQL=SQL&" From tk_barasiF "
SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' and bfidx<>'"&abfidx&"'"
If aWHICHI_AUTO <> "0" Then 
SQL = SQL & " AND whichi_auto = '" & aWHICHI_AUTO & "' "
End if
If aWHICHI_FIX <> "0" Then 
SQL = SQL & " AND whichi_fix = '" & aWHICHI_FIX & "' "
End If
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
  bfidx=Rs(0)
  set_name_Fix=Rs(1)
  set_name_AUTO=Rs(2)
  whichi_auto=Rs(3)
  whichi_fix=Rs(4)
  xsize=Rs(5)
  ysize=Rs(6)
  bfimg1=Rs(7)
  bfimg2=Rs(8)
  bfimg3=Rs(9)
  tng_busok_idx=Rs(10)
  tng_busok_idx2=Rs(11)
%>
              <div class="card card-custom">
                <div class="card-header"><%=set_name_AUTO%><%=set_name_Fix%></div>
                <div class="card-body">
                  <% if bfimg3<>"" then %>
                    <a onclick="chgbarasif('<%=bfidx%>');"><img src="/img/frame/bfimg/<%=bfimg3%>" loading="lazy" width="180" height="100"  border="0"></a>
                  <% elseif bfimg1<>"" then %>
                    <img src="/img/frame/bfimg/<%=bfimg1%>" loading="lazy" width="180" height="100"  border="0">
                  <% elseif bfimg2<>"" then %>
                    <img src="/img/frame/bfimg/<%=bfimg2%>" loading="lazy" width="180" height="100"  border="0">
                  <% end if %>
                </div>
              </div>
<%
  Rs.movenext
  Loop
  End if
  Rs.close
%> 
          </div>
        </div>
      </div>
    </div>
  </div>
<button type="submit" id="hiddenSubmit" style="display: none;"></button>
</form>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

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
