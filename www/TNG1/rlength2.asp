
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
 
gubun=Request("gubun")


rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
rsjb_idx=Request("sjb_idx")
rsjb_type_no=Request("sjb_type_no")
rgreem_f_a=Request("greem_f_a")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")
rmode=Request("mode") '값이 autocal라면 자동 계산된 값이라는 뜻, 마지막에 location.replace()할지 여부를 결정
Response.write "rsjidx:"&rsjidx&"<br>"
Response.write "rsjsidx:"&rsjsidx&"<br>"
Response.write "rsjb_idx:"&rsjb_idx&"<br>"
Response.write "rsjb_type_no:"&rsjb_type_no&"<br>"
Response.write "rgreem_f_a:"&rgreem_f_a&"<br>"
Response.write "rfkidx:"&rfkidx&"<br>"
Response.write "rfksidx:"&rfksidx&"<br>"
Response.write "rmode:"&rmode&"<br>"

'선택한 부속이 가로바인지 세로바인지 확인
SQL=" Select A.WHICHI_FIX, B.bfwidx, B.WHICHI_FIXname, B.bfwstatus , B.glassselect, B.unittype_bfwidx  "
SQL=SQL&" From tk_framekSub A "
SQL=SQL&" Join tng_whichitype B On A.WHICHI_FIX=B.WHICHI_FIX "
SQL=SQL&" Where A.fksidx='"&rfksidx&"' "

  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
  WHICHI_FIX=Rs(0)
    select case WHICHI_FIX
      case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 21, 22 '1:가로바, 2:가로바 길게, 3:중간바, 4:롯트바, 5:하바, 21:박스라인, 22:박스라인롯트바,6:세로바,7:세로중간통바,8:180도 코너바,9:90도코너바,10:비규격코너바,20:상부남마세로중간통바
        zwhichi_fix_type="wb"
      case 12                 '수동도어유리1(편개)
        zwhichi_fix_type="sd" 
      case 13                '수동도어유리2(양개)
        zwhichi_fix_type="db" 
      Case 14, 15             '하부픽스 유리1, 2
        zwhichi_fix_type="bg" 
      Case 16, 17, 18         '상부남마픽스유리 1,2,3
        zwhichi_fix_type="hg" 
      Case 19 , 23            '박스라인 하부픽스 유리 ,  11
        zwhichi_fix_type="bl" 
      case 11, 24, 25         '기타
        zwhichi_fix_type="ec" 
    end select 

    bfwidx=Rs(1)
    WHICHI_FIXname=Rs(2)
    bfwstatus=Rs(3)
    glassselect=Rs(4)
    unittype_bfwidx=Rs(5)



  End If
  Rs.Close

Response.write "zwhichi_fix_type:"&zwhichi_fix_type&"<br>"



If gubun="" then 
  SQL="Select A.blength, A.alength, A.xsize, A.ysize, A.xi, B.tw, B.th, B.ow, B.oh, B.fl "
  SQL=SQL&" From tk_framekSub A "
  SQL=SQL&" Join tk_framek B On A.fkidx=B.fkidx "
  SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    blength=Rs(0) '바의긴 길이, 픽스유리의 세로 | 
    alength=Rs(1) '픽스유리의 가로            | 
    xsize=Rs(2)   '자재의 깊이
    ysize=Rs(3)   '자재의 보이는 정면폭
    xi=Rs(4)      '바의 x좌표
    tw=Rs(5)      '프레임의 검측가로
    th=Rs(6)      '프레이의 검측세로
    ow=Rs(7)      '오픈가로
    oh=Rs(8)      '도어높이
    fl=Rs(9)      '묻힘
    if fl="" or isnull(fl) then 
        fl = 0
    end if

    if blength="0" and (zwhichi_fix_type="sd" or zwhichi_fix_type="db") then 
      '도어유리 아래 바의 세로 길이 구하기
      SQL=" Select A.fksidx, A.xsize, A.ysize, D.oh"
      SQL=SQL&" From tk_framekSub A "
      SQL=SQL&" Join tk_framek D On A.fkidx=D.fkidx "
      SQL=SQL&" where A.fkidx='"&rfkidx&"' and A.xi in (select B.xi from tk_framekSub B where B.fksidx='"&rfksidx&"') "
      SQL=SQL&" and A.yi > (select C.yi from tk_framekSub C where C.fksidx='"&rfksidx&"') "
      Rs1.open Sql,Dbcon
      If Not (Rs1.bof or Rs1.eof) Then 
        fksidx=Rs1(0)
        xsize=Rs1(1)
        ysize=Rs1(2)  '세로길이
        oh=Rs1(3)

        '도어유리세로(blength) = 도어높이(oh) - 하단바의 세로길이(ysize)
        blength=oh-ysize
        '하단바는 사라지고 hi값만큼 유리에추가한다.
        '도어유리의 상단바를 롯트바로 바꾼다.

      End If
      Rs1.Close
    end if

  End if
  Rs.close

  'alength : 자재의 가로 공간길이
  'blength : 자재의 세로 공간길이
  'glass_w : 유리의 실제 가로길이
  'glass_h : 유리의 실제 세로길이
  'door_w : 도어의 실제 가로길이
  'door_h : 도어의 실제 세로길이
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Bar 길이 입력</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .input-container {
      max-width: 500px;
      margin: 20px auto;
    }
    .d-inline-flex {
      gap: 10px;
      align-items: center;
    }
    input[type="text"] {
      text-align: right;
      width: 150px;
    }

  </style>
  <script>
    function lengthreset(){
      if (confirm("길이 적용을  재설정 할 수 있도록 초기화 하시겠습니까?"))
      {
          location.href="rlength2.asp?gubun=lengthreset&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>"
      }
    }
    function chg(whichi_fix){
      let result = confirm("일괄적용을 원하면 확인, 단독적용시에는 취소 버튼을 누러 주세요.");
      if (result) {
        location.href="rlength2.asp?gubun=chg&mode=auto&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>&whichi_fix="+whichi_fix;
      } else {
        location.href="rlength2.asp?gubun=chg&mode=manual&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>&whichi_fix="+whichi_fix;
      }
    }

  </script>
</head>
<body class="p-4">

<div class="container">
  <h2 class="mb-4"><%=WHICHI_FIXname%> 길이 입력 <small class="text-muted">(단위: mm)</small></h2>
  
  <form id="lengthForm" name="lengthForm" action="rlength2.asp" method="POST">
    <input type="hidden" name="gubun" value="up1date">
    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
    <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
    <input type="hidden" name="greem_f_a" value="<%=rgreem_f_a%>">
    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
    <input type="hidden" name="fksidx" value="<%=rfksidx%>">
    <input type="hidden" name="xi" value="<%=xi%>">




<% if zwhichi_fix_type="sd" or zwhichi_fix_type="db" or zwhichi_fix_type="bg" or zwhichi_fix_type="hg" or zwhichi_fix_type="bl" then %>
<!-- 도어의 세로 길이 = 도어높이 - 하단바의 높이 -->

    <div class="mb-3 d-inline-flex">
      <label for="alength" class="form-label mb-0">가로 (mm):</label>
      <input type="text" id="alength" name="alength" class="form-control" placeholder="예: 12,345" value="<%=alength%>" required>
    </div>
    <div class="mb-3 d-inline-flex">
      <label for="rlength" class="form-label mb-0">세로 (mm):</label>
      <input type="text" id="rlength" name="blength" class="form-control" placeholder="예: 12,345" value="<%=blength%>" required>
    </div>
<%  else %>
    <div class="mb-3 d-inline-flex">
      <label for="rlength" class="form-label mb-0">가로 (mm):</label>
      <input type="text" id="rlength" name="blength" class="form-control" placeholder="예: 12,345" value="<%=blength%>" required>
    </div>
<% end if %>
    <div class="d-flex align-items-center gap-3 mb-3">
      <label class="form-label mb-0">구분</label>
      
      <div class="form-check mb-0">
        <input class="form-check-input" type="radio" name="optionType" value="1" >
        <label class="form-check-label" for="singleOption">단독적용</label>
      </div>

      <div class="form-check mb-0">
        <input class="form-check-input" type="radio" name="optionType" value="2" checked>
        <label class="form-check-label" for="batchOption">일괄적용</label>
      </div>
    </div>
    <button type="button" class="btn btn-dark" onclick="lengthreset();">초기화</button>
    <button type="submit" class="btn btn-primary">길이적용</button>

 
  </form>
    <div class="mb-3 ">
  <h2 class="mb-2">자재변경</h2>
  <div class="row">
<%
SQL=" SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
SQL=SQL&" FROM tng_whichitype "
SQL=SQL&" Where whichi_fix>=0 and bfwstatus=1 and whichi_fix<>'"&WHICHI_FIX&"' "
if zwhichi_fix_type="wb" then 
SQL=SQL&" and whichi_fix in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 21, 22)"
elseif zwhichi_fix_type="ec" then 
SQL=SQL&" and whichi_fix in (11, 24, 25) "
else
SQL=SQL&" and whichi_fix in (12, 13, 14, 15, 16, 17, 18, 19 , 23) "
end if 
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
  bfwidx=Rs(0)
  WHICHI_FIX=Rs(1)
  WHICHI_FIXname=Rs(2)
  i=i+1
%>    <div class="col mb-2">
        <button type="button" class="btn btn-outline-success" onclick="chg('<%=whichi_fix%>');"><%=WHICHI_FIXname%></button>
      </div>
<%
  k = i mod 3
  if k = 0 then response.write "</div><div class=row>" end if  
Rs.movenext
Loop
End if
Rs.close
%>
  </div>

    </div>
<!-- 세로 길이 설정 시작 -->
<!--
  <h2 class="mb-4">도어/유리 세로 길이 입력 <small class="text-muted">(단위: mm)</small></h2>
  <form id="lengthForm" name="lengthForm" action="rlength2.asp" method="POST">
<%
SQL=" Select fksidx, alength, blength, whichi_fix "
SQL=SQL&" From tk_framekSub "
SQL=SQL&" Where fkidx='"&rfkidx&"' and xi='"&xi&"' and gls<>'0' order by yi ASC "
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
  hfksidx=Rs(0)
  halength=Rs(1)
  hblength=Rs(2)
  hwhichi_fix=Rs(3)
  j=j+1
%>  
    <div class="mb-12 d-inline-flex">
      <label for="rlength" class="form-label mb-0"><%=j%>세로길이 (mm):</label>
      <input type="text" id="rlength" name="rlength" class="form-control" placeholder="예: 12,345" value="<%=hblength%>" required>
    </div>
<%
Rs.movenext
Loop
End if
Rs.close
%>
  </form>
-->
<!-- 세로 길이 설정 끝 -->
</div>

<script>
  const rlengthInput = document.getElementById('rlength');

  // 천 단위 콤마 자동 적용, 최대 5자리 숫자 제한
  rlengthInput.addEventListener('input', function() {
    let value = this.value.replace(/[^0-9]/g, ''); // 숫자만 남김
    if (value.length > 7) value = value.slice(0, 7); // 5자리까지만 허용
    //this.value = value ? Number(value).toLocaleString() : '';   //천단위 콤마 표시는 오류배제를 위해 당분간 사용안함
  });


</script>

</body>
</html>
<%
ElseIf gubun="up1date" Then 
roptionType=Request("optionType")
ralength=Request("alength") '도어와 유리의 가로사이즈
rblength=Request("blength") '도어와 유리의 세로사이즈/바의 가로 사이즈
rxi=Request("xi") '선택한 부속(바/도어/유리)의 x좌표

Response.write "roptionType:"&roptionType&"<br>"
Response.write "ralength:"&ralength&"<br>"
Response.write "rblength:"&rblength&"<br>"
Response.write "rxi:"&rxi&"<br>"
   


'===================
'1. 선택한 부속품의 xi와 wi가 동일한 부속품을 찾아서 실길이를 적용한다. rstatus의 값이 1인 레코드는 대상에서 제외한다.
'2. 실길이가 적용된 fksidx에는 적용완료 여부를 표시하는 rstatus의 값을 1로 변경한다.
'===================

'1. 적용대상 찾기


  SQL=" select A.fksidx, A.WHICHI_AUTO, A.WHICHI_FIX, A.door_w, A.door_h, A.glass_w, A.glass_h, A.gls "
  SQL=SQL&" , B.sjb_idx, B.sjb_type_no, B.greem_o_type, B.GREEM_BASIC_TYPE, B.greem_fix_type  "
  SQL=SQL&" , B.tw, B.th, B.ow, B.oh, B.fl, B.ow_m "
  SQL=SQL&" , C.dwsize1, C.dhsize1, C.dwsize2, C.dhsize2, C.dwsize3, C.dhsize3 "
  SQL=SQL&" , C.dwsize4, C.dhsize4, C.dwsize5, C.dhsize5, C.gwsize1, C.ghsize1 "
  SQL=SQL&" , C.gwsize2, C.ghsize2, C.gwsize3, C.ghsize3, C.gwsize4, C.ghsize4 "
  SQL=SQL&" , C.gwsize5, C.ghsize5, C.gwsize6, C.ghsize6 "
  SQL=SQL&" , D.xsize, D.ysize " 
  SQL=SQL&" , E.opa, E.opb, E.opc, E.opd "
  SQL=SQL&" , F.glassselect, G.glassselect, A.xi, A.yi "
  SQL=SQL&" From tk_framekSub A "
  SQL=SQL&" Join tk_framek B on A.fkidx = B.fkidx "
  SQL=SQL&" Join tng_sjbtype C on B.sjb_type_no = C.SJB_TYPE_NO "
  SQL=SQL&" Join tk_barasiF D on A.bfidx = D.bfidx "
  SQL=SQL&" Join tk_frame E on A.fidx = E.fidx "
  SQL=SQL&" Join tng_whichitype F on A.WHICHI_FIX = F.WHICHI_FIX "
  SQL=SQL&" Join tng_whichitype G on A.WHICHI_AUTO = G.WHICHI_AUTO"
  If roptionType="1" Then 
  sql=sql&" Where A.fksidx='"&rfksidx&"' "
  ElseIf  roptionType="2" Then 
    if zwhichi_fix_type="wb" then 
      SQL=SQL&" Where A.xi=(Select xi  From tk_framekSub H where H.fksidx='"&rfksidx&"') "
      SQL=SQL&" and A.wi=(Select wi From tk_framekSub I where I.fksidx='"&rfksidx&"') "
    elseif  zwhichi_fix_type="hb" then 
      SQL=SQL&" Where A.yi=(Select yi  From tk_framekSub H where H.fksidx='"&rfksidx&"') "
      SQL=SQL&" and A.hi=(Select hi From tk_framekSub I where I.fksidx='"&rfksidx&"') "
    end if
  SQL=SQL&" and A.fkidx='"&rfkidx&"' and A.xi='"&rxi&"'"
  End If
  SQL=SQL&" Order by A.yi asc "
  response.write (SQL)&"<br><br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
  Do while not Rs.EOF

    zfksidx = rs(0)
    zWHICHI_AUTO = rs(1)
    zWHICHI_FIX = rs(2)
    zdoor_w = rs(3)
    zdoor_h = rs(4)
    zglass_w = rs(5)
    zglass_h = rs(6)
    zgls = rs(7)
    zsjb_idx = rs(8)
    zsjb_type_no = rs(9)
    zgreem_o_type = rs(10)
    zGREEM_BASIC_TYPE = rs(11)
    zgreem_fix_type = rs(12)
    ztw = rs(13)
    zth = rs(14)
    zow = rs(15)
    zoh = rs(16)
    zfl = rs(17)
    zow_m = rs(18)
    zdwsize1 = rs(19) '외도어 가로 치수
    zdhsize1 = rs(20) '외도어 세로 치수
    zdwsize2 = rs(21) '양개도어 가로 치수
    zdhsize2 = rs(22) '양개도어 가로 치수
    zdwsize3 = rs(23) '도어임시3_w
    zdhsize3 = rs(24) '도어임시3_h
    zdwsize4 = rs(25) '도어임시4_w
    zdhsize4 = rs(26) '도어임시4_h
    zdwsize5 = rs(27) '도어임시5_w
    zdhsize5 = rs(28) '도어임시5_h
    zgwsize1 = rs(29) '하부픽스유리 가로 치수
    zghsize1 = rs(30) '하부픽스유리 세로 치수
    zgwsize2 = rs(31) '박스라인 경우 하부픽스유리2 가로 치수
    zghsize2 = rs(32) '박스라인 경우 하부픽스유리2 세로 치수
    zgwsize3 = rs(33) '상부픽스유리 1 가로 치수
    zghsize3 = rs(34) '상부픽스유리 1 세로 치수
    zgwsize4 = rs(35) '픽스유리3_w
    zghsize4 = rs(36) '픽스유리3_h
    zgwsize5 = rs(37) '픽스유리4_w
    zghsize5 = rs(38) '픽스유리4_h
    zgwsize6 = rs(39) '픽스유리5_w
    zghsize6 = rs(40) '픽스유리5_h
    zxsize = rs(41)
    zysize = rs(42)
    zopa = rs(43)
    zopb = rs(44)
    zopc = rs(45)
    zopd = rs(46)
    zglassselect_fix   = Rs(47) '1= 외도어 , 2 = 양개도어 , 3 = 유리 , 4 = 상부남마유리 , 5 = 박스라인하부픽스유리 , 6 = 박스라인상부픽스유리
    zglassselect_auto   = Rs(48)  '1 = 외도어 , 2 = 양개도어 , 3 = 유리 , 4 = 상부남마유리
    xi = rs(49)
    yi = rs(50)
    i = i + 1


'2. 실제 길이 적용
'계산값 산정 시작   
'===========================

'alength, blength 업데이트
'blength>0'
'도어가로세로 업데이트
'door_w>0
'door_h>0
'픽스유리 가로세로 업데이트
'glass_w>0
'glass_h>0

Response.write "zsjb_type_no:"&zsjb_type_no&"<br>"

 '수동도어 계산
  If zsjb_type_no = 6 Or zsjb_type_no = 7 Or zsjb_type_no = 11 Or zsjb_type_no = 12 Then
  Response.write "zgreem_fix_type:"&zgreem_fix_type&"<br>"
  Response.write "zwhichi_fix:"&zwhichi_fix&"<br>"
  Response.write "zdwsize1:"&zdwsize1&"<br>"
  Response.write "zdhsize1:"&zdhsize1&"<br>"


if zwhichi_fix_type="wb" then 
  ralength=rblength
end if

          Select Case zwhichi_fix 
              Case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,  11, 20, 21, 22, 24, 25 ' 롯트바 = 4  박스라인롯트바 = 22 ,세로바=6 180도 코너바=8 90도 코너바=9 비규격 코너바=10 
                  alength=0
                  blength=rblength
                  door_w=0
                  door_h=0
                  glass_w=0
                  glass_h=0
                  Response.write "바<br>"
              Case 12 '외도어
                  alength=ralength
                  blength=rblength  '도어의 세로의 길이 
                  door_w=alength+zdwsize1
                  door_h=blength+zdhsize1
                  glass_w=0
                  glass_h=0
                  Response.write "외도어<br>"
              Case 13 '양개도어
                  alength=ralength  '도어의 가로의 길이
                  blength=rblength   '도어의 세로의 길이 
                  door_w=alength+zdwsize2
                  door_h=blength+zdhsize2
                  glass_w=0
                  glass_h=0
                  Response.write "양개도어<br>"
              Case 14, 15 '하부픽스 유리1, 2
                  alength=ralength          '하부픽스 유리의 가로의 길이
                  blength=rblength                 '하부픽스 유리의 세로의 길이 

                  door_w=0
                  door_h=0
                  glass_w=alength+zgwsize1   '하부픽스 유리의 가로의 길이
                  glass_h=blength+zghsize1   '하부픽스 유리의 가로의 길이
              Case 19 , 23  '박스라인 하부픽스 유리 ,  11
                  alength=ralength          '박스라인 하부픽스 유리의 가로의 길이
                  blength=rblength                 '박스라인 하부픽스 유리의 세로의 길이 
                  door_w=0
                  door_h=0
                  glass_w=alength+zgwsize2   '박스라인 하부픽스 유리의 가로의 길이
                  glass_h=blength+zghsize2   '박스라인 하부픽스 유리의 가로의 길이
                  Response.write "박스라인 하부픽스 유리<br>"
              Case 16, 17, 18 '상부남마픽스유리 1,2,3
                  alength=ralength          '상부남마픽스유리 유리의 가로의 길이
                  blength=rblength                 '상부남마픽스유리 유리의 세로의 길이 
                  door_w=0
                  door_h=0
                  glass_w=alength+zgwsize3   '상부남마픽스유리 유리의 가로의 길이
                  glass_h=blength+zghsize3   '상부남마픽스유리 유리의 가로의 길이
              case 11, 24, 25 '기타
                  alength=ralength 
                  blength=rblength                  
                  door_w=0
                  door_h=0
                  glass_w=0 
                  glass_h=0   '
                  Response.write "기타<br>"
          End Select



  '선택한 해당 자재의 길이 적용

  if rmode="autocal" then '길이가 자동계산된 임시값인 경우
    SQL="Update tk_framekSub Set alength='"&alength&"',blength='"&blength&"', door_w='"&door_w&"', door_h='"&door_h&"', glass_w='"&glass_w&"', glass_h='"&glass_h&"', rstatus='0', rstatus2='1' Where fksidx='"&zfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
  Else  '길이가 사용자가 직접입력 또는 확인한 값인경우
    SQL="Update tk_framekSub Set alength='"&alength&"',blength='"&blength&"', door_w='"&door_w&"', door_h='"&door_h&"', glass_w='"&glass_w&"', glass_h='"&glass_h&"', rstatus='1', rstatus2='1' Where fksidx='"&zfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
  end if



  end if
  '수동도어 계산 끝
Rs.movenext
Loop
End if
Rs.close


  if roptionType="2" then '일괄적용일 때만


    if zwhichi_fix_type="wb" then '가로바일 경우
      '2-1.남은 가로바 찾기 시작
      '======================================
      '해당 프레임에서  (fkidx), 처음 선택한 부속의 y좌표가 같은 것을 찾고
      ' 길이 적용이 안되어 있는 레코드만 (rstatus='0') 나오도록 조건 설정
      ' 수동이면서 가로바를 찾는다.
      ' location.replace();로 하나씩 이동할 것이기에 반복하지는 않는다
      SQL=" Select fksidx From tk_framekSub Where fkidx='"&rfkidx&"' and yi='"&ryi&"' and rstatus2='0' "
      SQL=SQL&" and whichi_fix in (1, 2, 3, 4, 5, 21, 22 ) "
      Response.write (SQL)&"<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        rfksidx=Rs(0)

        '동일한 y좌표의 부속중 길이가 결정된 부속의 합을 전체길이에서 제외하고 남은 부속의 갯수로 나누어 rrlength 변수의 값을 설정한다.
        '길이가 설정된 가로바의 길이 합과 세로바의 발 구하기
        
        SQL=" Select "
        SQL=SQL&" ( "
        SQL=SQL&" Select sum(blength) "
        SQL=SQL&" From tk_framekSub " 
        SQL=SQL&" Where fkidx='"&rfkidx&"' and yi='"&ryi&"' and rstatus='1' "
        SQL=SQL&" and whichi_fix in (1, 2, 3, 4, 5, 21, 22 ) "
        SQL=SQL&" ) "  
        SQL=SQL&", ( "
        SQL=SQL&" Select sum(ysize) "
        SQL=SQL&" From tk_framekSub " 
        SQL=SQL&" where fkidx='"&rfkidx&"' and yi='"&ryi&"' " 
        SQL=SQL&" and whichi_fix not in (1, 2, 3, 4, 5, 21, 22 ) "
        SQL=SQL&" ) "  
        SQL=SQL&", ( "
        SQL=SQL&" Select count(*) "
        SQL=SQL&" From tk_framekSub "
        SQL=SQL&" Where fkidx='"&rfkidx&"' and yi='"&ryi&"' and rstatus='0' "
        SQL=SQL&" and whichi_fix in (1, 2, 3, 4, 5, 21, 22 ) "
        SQL=SQL&" ) "  

        Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
          sum_blength=Rs1(0)
          sum_ysize=Rs1(1)
          cnt_barnum=Rs1(2)
        End If
        Rs1.Close

        r_length = ztw - sum_blength - sum_ysize '남은 길이
        i_length = Int(r_length / cnt_barnum)

        Response.write ztw&"/"&sum_blength&"/"&sum_ysize&"/"&r_length&"/"&cnt_barnum&"/"&i_length&"<br>"
        Response.write "<script>location.replace('rlength2.asp?gubun=up1date&mode=autocal&optionType="&roptionType&"&rlength="&i_length&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"

      Else
      '자동 계산이 끝나면 rstatus2를 0으로 다음 자동 계산 대상으로 만들기 위해 초기화 한다.

        SQL="Update tk_framekSub set rstatus2=0 where fkidx='"&rfkidx&"' and rstatus=0 "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
      End if
      Rs.Close
      '======================================
      '2-1.남은 가로바 찾기 끝
    elseif zwhichi_fix_type="hb" then 
      '2-2 남은 세로바 찾기 시작
      '======================================
      SQL=" Select fksidx From tk_framekSub Where fkidx='"&rfkidx&"' and yi='"&ryi&"' and rstatus2='0' "
      SQL=SQL&" and whichi_fix in (6,7,8,9,10,20) "
      Response.write (SQL)&"<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        zfksidx=Rs(0)

        SQL="Update tk_framekSub Set alength='"&alength&"',blength='"&blength&"', rstatus='0', rstatus2='1' Where fksidx='"&zfksidx&"' "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL

      End if
      Rs.Close
      '======================================
      '2-2 남은 세로바 찾기 끝

    end if

'
  end if
  'Response.write "<script>opener.location.replace('TNG1_B_suju_temp.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');window.close();</script>"

Elseif gubun="lengthreset" then 

  SQL="Update tk_framekSub set rstatus='0', rstatus2='0' Where fkidx='"&rfkidx&"' "
  'Response.write (SQL)&"<br><br>"
  Dbcon.Execute (SQL)

  REsponse.write "<script>location.replace('rlength2.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"

Elseif gubun="chg" Then 
  rwhichi_fix=Request("whichi_fix")
  rmode=Request("mode")
  response.write rmode&"<br>"


  if rmode="auto" then 
  SQL="Select yi, whichi_fix From tk_framekSub where fksidx='"&rfksidx&"'"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    byi=Rs(0)          'y좌표
    bwhichi_fix=Rs(1) '기존 whichi_fix값

    SQL="Update tk_framekSub set WHICHI_FIX='"&rwhichi_fix&"' where fkidx='"&rfkidx&"' and fksidx in "
    SQL=SQL&" (Select fksidx From tk_framekSub Where yi='"&byi&"' and  whichi_fix='"&bwhichi_fix&"'  and fkidx='"&rfkidx&"') "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute (SQL)
  End If
  Rs.Close

  
  elseif rmode="manual" then 
  SQL="Update tk_framekSub set whichi_fix='"&rwhichi_fix&"' where fksidx='"&rfksidx&"' "
  Response.write (SQL)&"<br><br>"
  Dbcon.Execute (SQL)
  end if
  'Response.write "<script>opener.location.replace('TNG1_B_suju_temp.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');window.close();</script>"
  'REsponse.write "<script>location.replace('rlength2.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"

End If
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>