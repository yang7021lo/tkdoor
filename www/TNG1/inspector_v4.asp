
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
''
'기본알고리즘 : 모든 공간변경이 이루어진후
'가로길이 입력(바,도어(공간), 유리
'1: 가로의 길이를 입력한다. 
'1-1: 단독/일괄적용 선택가능(단독은 해당하는 부속에만 적용)
'1-2: 일괄적용시 동일한 xi 좌표의 부속에 가로 길이를 적용
'1-3: 일괄적용시 선택한 부속과 같은 yi상의 부속의 갯수를 찾고, 검측가로에서 입력한 가로의 길이를 제외한 길이를 1/n로 설정해 입력한다. 동일한 xi상의 부속에도 일괄적용한다.
'1-4: 단 rstatus가 0 인것만 길이값을 수정할 것. 0:자동입력 1:직접입력, rstatus2는 자동/수동에 관련없이 길이값입력이 되었다는 의미

'세로길이 입력
'2 : 선택한 부속의 세로의길이를 입력한다. 선택한 바와 yi와 hi가 동일한 바에도 일괄적용
'2-1: 세로가 가장긴 바 그리고 yi와 hi가 동일한 바에 검측 세로를 적용한다.

'공간변경
'3: 도어공간의 경우 고정창,편개,양개,혼합 을 자유롭게 설정변경 할 수 있어야 한다.
'3-1: 고정창 => 편개/양개 : 도어(공간)의 하바를 지우고, 도어공간의 세로길이를 하바의 세로길이만큼 늘린다, 상바의 속성을 롯트바로 변경한다.
'3-2: 고정창 => 양개 : 3-1적용, 기존 도어공간의 가로를 1/2로 줄이고, 신규하나 추가 가로의길이는 1/2 세로는 동일하게 적용
'3-5: 고정창 => 혼합공간 : 좌우 도어(공간)위치를 선택 옵션. 3-2(고정창=>양개)를 우선적용한다. 옵션에 따라 좌우에 도어(공간)으로 설정변경 및 세로바 추가 및 상바 롯트바로, 하바 삭제 및 하바세로길비만큼 도어(공가)세로 늘리기
'3-4: 편개/양개/혼합공간 => 고정창 초기화, 모든 공간변경의 시작은 고정창으로 초기화 한후 설정한다.
'* 수동도어유리1은 편개로, 수동도어유리2 는 양개로,  수동픽스유리1,2는 고정창
gubun=Request("gubun")

rsjcidx=Request("sjcidx")
rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
rsjb_idx=Request("sjb_idx")
rsjb_type_no=Request("sjb_type_no")
rgreem_f_a=Request("greem_f_a")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")
rmode=Request("mode") '값이 autocal라면 자동 계산된 값이라는 뜻, 마지막에 location.replace()할지 여부를 결정
'Response.write "rsjidx:"&rsjidx&"<br>"
'Response.write "rsjsidx:"&rsjsidx&"<br>"
'Response.write "rsjb_idx:"&rsjb_idx&"<br>"
'Response.write "rsjb_type_no:"&rsjb_type_no&"<br>"
'Response.write "rgreem_f_a:"&rgreem_f_a&"<br>"
'Response.write "rfkidx:"&rfkidx&"<br>"
'Response.write "rfksidx:"&rfksidx&"<br>"
'Response.write "rmode:"&rmode&"<br>"

'선택한 부속이 가로바인지 세로바인지 확인
SQL=" Select A.WHICHI_FIX, B.bfwidx, B.WHICHI_FIXname, B.bfwstatus , B.glassselect, B.unittype_bfwidx, A.fkidx  "
SQL=SQL&" ,A.whichi_auto, C.bfwidx, C.WHICHI_Autoname, C.bfwstatus , C.glassselect, C.unittype_bfwidx "
SQL=SQL&" From tk_framekSub A "
SQL=SQL&" Join tng_whichitype B On A.WHICHI_FIX=B.WHICHI_FIX "
SQL=SQL&" Join tng_whichitype C On A.WHICHI_auto=C.WHICHI_auto "
SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
'Response.write (SQL)&"<br><br>"
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
    fkidx=Rs(6)
    whichi_auto=Rs(7)
    abfwidx=Rs(8)
    aWHICHI_Autoname=Rs(9)
    abfwstatus=Rs(10)
    aglassselect=Rs(11)
    aunittype_bfwidx=Rs(12)

    if WHICHI_FIX<>"0" then 
      whichi_type="f" '수동프레임
    else
      whichi_type="a" '자동프레임
    end if

  End If
  Rs.Close

If rfkidx="" then 
  rfkidx=fkidx
End if
'Response.write "zwhichi_fix_type:"&zwhichi_fix_type&"<br>"


If gubun="" then 

  SQL="Select A.blength, A.alength, A.xsize, A.ysize, A.xi, A.yi, B.tw, B.th, B.ow, B.oh, B.fl, A.groupcode, A.wi, A.hi "
  SQL=SQL&" From tk_framekSub A "
  SQL=SQL&" Join tk_framek B On A.fkidx=B.fkidx "
  SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    blength=Rs(0) '바의긴 길이, 픽스유리의 세로 | 
    alength=Rs(1) '픽스유리의 가로            | 
    xsize=Rs(2)   '자재의 깊이
    ysize=Rs(3)   '자재의 보이는 정면폭
    xi=Rs(4)      '도형의 x좌표
    yi=Rs(5)      '도형의 y좌표
    tw=Rs(6)      '프레임의 검측가로
    th=Rs(7)      '프레이의 검측세로
    ow=Rs(8)      '오픈가로
    oh=Rs(9)      '도어높이
    fl=Rs(10)      '묻힘
    groupcode=Rs(11)  '혼합공간 그룹코드
    wi=Rs(12)      '도형의 폭
    hi=Rs(13)      '도형의 두께

    'response.write "groupcode:"&groupcode&"<br>"
    if fl="" or isnull(fl) then 
        fl = 0
    end if

    if blength="0" and zwhichi_fix_type<>"wb" then 
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
    '세로바의 경우 기본값 설정
    if blength="0" and zwhichi_fix_type="wb" and WHICHI_FIX="6" then 
      blength=th
    end if 

    '만약 가로바 종류이고 길이가 아직 입력되기 전이라면 동일한 yi상의 검측가로 에서 blength의 합을 뺀것을 제시한다. 
    if zwhichi_fix_type="wb" and blength="0" then 
      SQL=" Select sum(blength) "
      SQL=SQL&" from tk_framekSub " 
      SQL=SQL&" where fkidx='"&rfkidx&"' and yi='"&yi&"' and whichi_fix=1 and rstatus=1 "
      Rs1.open Sql,Dbcon
      If Not (Rs1.bof or Rs1.eof) Then 
        sum_blength=Rs1(0)
      End if
      Rs1.Close

      SQL=" Select sum(ysize) "
      SQL=SQL&" from tk_framekSub " 
      SQL=SQL&" where fkidx='"&rfkidx&"' and yi='"&yi&"' and whichi_fix=6 "
      Rs1.open Sql,Dbcon
      If Not (Rs1.bof or Rs1.eof) Then 
        sum_ysize=Rs1(0)
      End if
      Rs1.Close

      jaahnsize=tw-sum_blength-sum_ysize
      if blength="0" then 
        blength=jaahnsize
      end if 
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
  <title>Inspector V4</title>
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
    <style>
    .modal-footer { justify-content: center; }
    .btn-group-custom { display: flex; gap: 10px; margin-bottom: 10px; }
  </style>
  <script>
    function cal(){
      if (confirm("모든 부속에 계산값을 적용하시겠습니까?"))
      {
        window.open("inspector_cal.asp?gubun=cal&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>","calpop","width=400,height=300,scrollbars=no,resizable=no");
      }
    }
    function suchi(){
      if (confirm("수치를 적용하시겠습니까?"))
      {
        window.open("inspector_length.asp?sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>","calpop","width=400,height=300,scrollbars=no,resizable=no");
      }
    }
    function lengthreset(){
      if (confirm("길이 적용을  재설정 할 수 있도록 초기화 하시겠습니까?"))
      {
          location.href="inspector_v4.asp?gubun=lengthreset&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>"
      }
    }
    function del(){
      if (confirm("선택한 부속을 삭제 하시겠습니까?"))
      {
          location.href="inspector_v4.asp?gubun=del&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>"
      }
    }
    function framedel(){
      if (confirm("프레임의 모든 정보를 삭제 하시겠습니까?"))
      {
          location.href="inspector_v4.asp?gubun=framedel&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>"
      }
    }    
    
//    function chg(whichi_fix, doorwhichi){
//      let result = confirm("취소 선택시 단일적용 됩니다.");
//      if (result) {
//        location.href="inspector_v4.asp?gubun=chg&mode=auto&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>&whichi_fix="+whichi_fix+"&doorwhichi="+doorwhichi;
//      } else {
//        location.href="inspector_v4.asp?gubun=chg&mode=manual&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>&whichi_fix="+whichi_fix+"&doorwhichi="+doorwhichi;
//      }
//    }
    function gpreset(){
      if (confirm("그룹 코드를 초기화 하시겠습니까?"))
      {
        location.href="inspector_v4.asp?gubun=gpreset&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>"
      }
    }
    
    function rowdel(){
      if (confirm("동일한 행의 자재를 모두 삭제 하시겠습니까?"))
      {
        location.href="inspector_v4.asp?gubun=rowdel&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>"
      }
    }
    function match(){
      if (confirm("선택한 자재를 기준자재와 길이를 맞추시겠습니까?"))
      {
        location.href="inspector_v4.asp?gubun=match&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>"
      }
    }
    function chg(whichi_fix, doorwhichi){
      if (confirm("자재를 변경 하시겠습니까?"))
      {
        location.href="inspector_v4.asp?gubun=chg&mode=manual&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>&whichi_fix="+whichi_fix+"&doorwhichi="+doorwhichi;
      }
    }
    function chgmanual(whichi_fix, doorwhichi){
      if(confirm("실행하시겠습니까?")){
        location.href="inspector_v4.asp?gubun=chg&mode=manual&sjcidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>&whichi_fix="+whichi_fix+"&doorwhichi="+doorwhichi;
      }
    }
    function handleChange(afksidx) {
      location.href="inspector_v4.asp?sjidx=<%=rsjidx%>&sjcidx=<%=rsjcidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>&fksidx="+afksidx.value;

    }

    function submitWithValue1(val) {
      document.getElementById('buttonValue1').value = val;
      document.getElementById('myForm1').submit();
    }
    function submitWithValue(val) {
      document.getElementById('buttonValue').value = val;
      document.getElementById('myForm').submit();
    }
  </script>
</head>
<body class="p-3">

<div>

<div class="d-flex mb-1">
  <div class="col-8">
    <select class="form-select w-80" id="exampleSelect" name="exampleSelect" onchange="handleChange(this)">
    <%
    SQL=" Select A.fksidx, A.whichi_fix, B.whichi_fixname, A.alength, A.blength, A.xi, A.yi, D.whichi_auto, D.whichi_autoname "
    SQL=SQL&" From tk_framekSub A "
    SQL=SQL&" Join tng_whichitype B on A.whichi_fix=B.whichi_fix "
    SQL=SQL&" Join tk_framek C On A.fkidx=C.fkidx "
    SQL=SQL&" Join tng_whichitype D on A.whichi_auto=D.whichi_auto "
    SQL=SQL&" Where C.sjsidx='"&rsjsidx&"' "
    SQL=SQL&" Order by fksidx asc"
    'Response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF
      afksidx=Rs(0)
      awhichi_fix=Rs(1)
      awhichi_fixname=Rs(2)
      aalength=Rs(3)
      ablength=Rs(4)
      axi=Rs(5)
      ayi=Rs(6)
      awhichi_auto=Rs(7)
      awhichi_autoname=Rs(8)

      if awhichi_fix<>"0" then 
        awhichi_name=awhichi_fixname
      else
        awhichi_name=awhichi_autoname
      end if
    %>  
      <option value="<%=afksidx%>" <% if clng(afksidx)=clng(rfksidx) then response.write "selected" end if %>>[<%=right(afksidx,3)%>]<%=awhichi_name%>(<%=axi%>&times;<%=ayi%>)</option>
    <%
      Rs.movenext
      Loop
      End if
      Rs.close
    %>
    </select>
  </div>
  <div class="col-4 text-end">
    <button type="button" class="btn btn-dark" onclick="lengthreset();">초기화</button>
    <button type="button" class="btn btn-danger" onclick="framedel();">프레임삭제</button>
  </div>
</div> 
  <form id="lengthForm" name="lengthForm" action="inspector_v4.asp" method="POST">
    <input type="hidden" name="gubun" value="up1date">
    <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
    <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
    <input type="hidden" name="greem_f_a" value="<%=rgreem_f_a%>">
    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
    <input type="hidden" name="fksidx" value="<%=rfksidx%>">



<div class="mb-1 input-group">
  <span class="input-group-text">구분</span>
  <div class="d-flex border px-2 py-2 align-items-center" style="gap: 1.5rem;width: 200px;">
    <div class="form-check form-check-inline mb-0">
      <input class="form-check-input" type="radio" name="optionType" id="singleOption" value="1" checked>
      <label class="form-check-label" for="singleOption">단독</label>
    </div>
    <div class="form-check form-check-inline mb-0">
      <input class="form-check-input" type="radio" name="optionType" id="batchOption" value="2">
      <label class="form-check-label" for="batchOption">일괄</label>
    </div>
  </div>
  <% if zwhichi_fix_type="sd" or zwhichi_fix_type="db" or zwhichi_fix_type="bg" or zwhichi_fix_type="hg" or zwhichi_fix_type="bl" then %>
    <!-- 도어의 세로 길이 = 도어높이 - 하단바의 높이 -->
    <span for="bendName" class="input-group-text">가로</span>
    <input type="text" id="alength" name="alength" class="form-control" value="<%=alength%>" size="5" required>
    <span for="bendName" class="input-group-text">세로</span>
    <input type="text" id="blength" name="blength" class="form-control" value="<%=blength%>" size="5" required>
  <%  else %>
    <span for="bendName" class="input-group-text">너비</span>
    <input type="text" id="blength" name="blength" class="form-control" value="<%=blength%>" required>
  <% end if %>
    <button type="submit" class="btn btn-primary">적용</button>
    <button type="button" class="btn btn-success" onclick="window.open('lengthc.asp?sjidx=<%=rsjidx%>&sjcidx=<%=rsjcidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&greem_f_a=<%=rgreem_f_a%>','length','width=600, height=1200, top=0, left=0');">자동길이적용</button>
</div>

<div class="mb-1 input-group">
    <span for="bendName" class="input-group-text">x좌표</span>
    <input type="text" id="xi" name="xi" class="form-control" value="<%=xi%>" size="5" required>
    <span for="bendName" class="input-group-text">y좌표</span>
    <input type="text" id="yi" name="yi" class="form-control" value="<%=yi%>" size="5" required>
    <span for="bendName" class="input-group-text">너비</span>
    <input type="text" id="wi" name="wi" class="form-control" value="<%=wi%>" size="5" required>
    <span for="bendName" class="input-group-text">높이</span>
    <input type="text" id="hi" name="hi" class="form-control" value="<%=hi%>" size="5" required>
</div>
 
<style>
  .btn-group-custom .btn {
    margin: 0 1px 1px 0;
    min-width: 5.5em; /* 5글자(숫자/한글) 입력 가능한 버튼 길이 */
    padding-left: 0;
    padding-right: 0;
    text-align: center;    
  }
  .btn-group-wrap {
    display: flex;
    gap: 3px;
  }
  .btn-group-custom {
    display: flex;
    flex-direction: column;
    gap: 1px;
    background: #ffffff;
    padding: 3px;
    border-radius: 6px;
  }
  .btn-row {
    display: flex;
    gap: 1px;
  }
</style>

<div class="btn-group-wrap">
  <!-- 그룹 1 -->
  <div class="btn-group-custom">
    <div class="btn-row">
      <button type="button" class="btn btn-primary" onclick="chgmanual('0','6-3');">통바상늘</button>
      <button type="button" class="btn btn-dark" onclick="chgmanual('0','6-1');">통바상뚫</button>
      <button type="button" class="btn btn-primary" onclick="chgmanual('0','6-5');">통바상줄</button>

      <button type="button" class="btn btn-dark" onclick="chgmanual('0','6-9');">우측합체</button>
      <button type="button" class="btn btn-dark" onclick="cal();">계산값적용</button>
      <button type="button" class="btn btn-dark" onclick="chgmanual('0','6-10');">좌측합체</button>
    </div>
    <div class="btn-row">
      <button type="button" class="btn btn-primary" onclick="chgmanual('0','6-4');">통바하늘</button>
      <button type="button" class="btn btn-dark" onclick="chgmanual('0','6-2');">통바하뚫</button>
      <button type="button" class="btn btn-primary" onclick="chgmanual('0','6-6');">통바하줄</button>

      <button type="button" class="btn btn-success" onclick="del();">부속삭제</button>
      <button type="button" class="btn btn-success" onclick="chgmanual('0','6-7');">분리</button>
      <button type="button" class="btn btn-success" onclick="chgmanual('0','6-8');">통바기준분리</button>
    </div>
  </div>
</form>  
  <!-- 그룹 2 -->

</div>

<!--
1.자재단순 복제후 위치 이동
2.새위치값 자재 추가

-->


<!-- -->
<form id="myForm1" method="get" action="inspector_v4.asp" class="d-flex align-items-center gap-2">
<input type="hidden" name="gubun" id="gubun" value="move">
<input type="hidden" name="sjcidx" id="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjidx" id="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" id="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="sjb_idx" id="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="sjb_type_no" id="sjb_type_no" value="<%=rsjb_type_no%>">
<input type="hidden" name="greem_f_a" id="greem_f_a" value="<%=rgreem_f_a%>">
<input type="hidden" name="fkidx" id="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="fksidx" id="fksidx" value="<%=rfksidx%>">
<input type="hidden" name="buttonValue1" id="buttonValue1">
<div class="btn-group-wrap">
  <!-- 그룹 1 -->
  <div class="btn-group-custom">
    <div class="btn-row mb-2">
    <select class="form-select w-80" id="cfksidx" name="cfksidx" >
    <option value="" >기준자재선택</option>
    <%
    SQL=" Select A.fksidx, A.whichi_fix, B.whichi_fixname, A.alength, A.blength, A.xi, A.yi, A.wi, A.hi "
    SQL=SQL&" From tk_framekSub A "
    SQL=SQL&" Join tng_whichitype B on A.whichi_fix=B.whichi_fix "
    SQL=SQL&" Join tk_framek C On A.fkidx=C.fkidx "
    SQL=SQL&" Where C.sjsidx='"&rsjsidx&"' "
    SQL=SQL&" Order by A.fksidx asc"
    'Response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF
      cfksidx=Rs(0)
      cwhichi_fix=Rs(1)
      cwhichi_fixname=Rs(2)
      calength=Rs(3)
      cblength=Rs(4)
      cxi=Rs(5)
      cyi=Rs(6)
      cwi=Rs(7)
      chi=Rs(8)
    %>  
      <option value="<%=cfksidx%>" <% if clng(cfksidx)=clng(rfksidx) then response.write "selected" end if %>>[<%=right(cfksidx,3)%>]<%=cwhichi_fixname%>(<%=cxi%>&times;<%=cyi%>|<%=cwi%>|<%=chi%>|)</option>
    <%
      Rs.movenext
      Loop
      End if
      Rs.close
    %>
    </select>
    </div>


    <div class="btn-row">
      <button type="button" class="btn btn-outline-success" onclick="submitWithValue1(1)">좌상</button>
      <button type="button" class="btn btn-success" onclick="submitWithValue1(2)">위</button>
      <button type="button" class="btn btn-outline-success" onclick="submitWithValue1(3)">우상</button>
    </div>
    <div class="btn-row">
      <button type="button" class="btn btn-success" onclick="submitWithValue1(4)">좌</button>
      <button type="button" class="btn btn-outline-success"  onclick="submitWithValue1(0)">길이맞춤</button>
      <button type="button" class="btn btn-success" onclick="submitWithValue1(5)">우</button>
    </div>
    <div class="btn-row">
      <button type="button" class="btn btn-outline-success" onclick="submitWithValue1(6)">좌하</button>
      <button type="button" class="btn btn-success" onclick="submitWithValue1(7)">아래</button>
      <button type="button" class="btn btn-outline-success" onclick="submitWithValue1(8)">우하</button>
    </div>

    <div class="btn-row">
      <button type="button" class="btn btn-outline-success" onclick="submitWithValue1(9)">프레임상단</button>
      <button type="button" class="btn btn-outline-success" onclick="submitWithValue1(10)">프레임하단</button>
      <button type="button" class="btn btn-outline-success" onclick="submitWithValue1(11)">프레임이동</button>

    </div>
    
  </div>

</form>  
  <!-- 그룹 2 -->
<% if whichi_type="f" then %>  
<form id="myForm" method="get" action="inspector_v4.asp" class="d-flex align-items-center gap-2">
<input type="hidden" name="gubun" id="gubun" value="add">
<input type="hidden" name="sjcidx" id="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjidx" id="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" id="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="sjb_idx" id="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="sjb_type_no" id="sjb_type_no" value="<%=rsjb_type_no%>">
<input type="hidden" name="greem_f_a" id="greem_f_a" value="<%=rgreem_f_a%>">
<input type="hidden" name="fkidx" id="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="fksidx" id="fksidx" value="<%=rfksidx%>">
<input type="hidden" name="buttonValue" id="buttonValue">
  <div class="btn-group-custom">
    <div class="btn-row mb-2">
    <select class="form-select w-80" id="swhichi_fix" name="swhichi_fix">
      <option value="" >위치값선택</option>
    <%
    SQL=" Select whichi_fix, WHICHI_FIXname "
    SQL=SQL&" From tng_whichitype "
    SQL=SQL&" Where whichi_fix<>'' "

    'Response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF
      swhichi_fix=Rs(0)
      swhichi_fixname=Rs(1)
 
    %>  
      <option value="<%=swhichi_fix%>" ><%=swhichi_fixname%></option>
    <%
      Rs.movenext
      Loop
      End if
      Rs.close
    %>
    </select>
    </div>

    <div class="btn-row">
      <button type="button" class="btn" onclick=""></button>
      <button type="button" class="btn btn-success" onclick="submitWithValue(1)">위</button>
      <button type="button" class="btn" onclick=""></button>
    </div>
    <div class="btn-row">
      <button type="button" class="btn btn-success" onclick="submitWithValue(2)">좌</button>
      <button type="button" class="btn btn-outline-success"  onclick="submitWithValue(0)">수동성분변경</button>
      <button type="button" class="btn btn-success" onclick="submitWithValue(3)">우</button>
    </div>
    <div class="btn-row">
      <button type="button" class="btn"></button>
      <button type="button" class="btn btn-success" onclick="submitWithValue(4)">아래</button>
      <button type="button" class="btn"></button>
    </div>
    <div class="btn-row">
      <button type="button" class="btn btn-outline-success" onclick="gpreset()">그룹코드초기화</button>
      <button type="button" class="btn btn-outline-success" onclick="rowdel()">행삭제</button>
      <button type="button" class="btn btn-outline-success" onclick="suchi();">수치적용</button>
    </div>
  </div>
</div>
<!-- -->

<script>


</script>

  </form>
<% elseif whichi_type="a" then %>
<form id="myForm" method="get" action="inspector_v4.asp" class="d-flex align-items-center gap-2">
<input type="hidden" name="gubun" id="gubun" value="add2">
<input type="hidden" name="sjcidx" id="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjidx" id="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" id="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="sjb_idx" id="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="sjb_type_no" id="sjb_type_no" value="<%=rsjb_type_no%>">
<input type="hidden" name="greem_f_a" id="greem_f_a" value="<%=rgreem_f_a%>">
<input type="hidden" name="fkidx" id="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="fksidx" id="fksidx" value="<%=rfksidx%>">
<input type="hidden" name="buttonValue" id="buttonValue">
  <div class="btn-group-custom">
    <div class="btn-row mb-2">



    <select class="form-select w-80" id="swhichi_auto" name="swhichi_auto">
      <option value="" >위치값선택</option>
    <%
    SQL=" Select whichi_auto, WHICHI_AUTOname "
    SQL=SQL&" From tng_whichitype "
    SQL=SQL&" Where whichi_auto<>'' "

    'Response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF
      swhichi_auto=Rs(0)
      swhichi_autoname=Rs(1)
 
    %>  
      <option value="<%=swhichi_auto%>" ><%=swhichi_autoname%></option>
    <%
      Rs.movenext
      Loop
      End if
      Rs.close
    %>
    </select>
    </div>

    <div class="btn-row">
      <button type="button" class="btn" onclick=""></button>
      <button type="button" class="btn btn-success" onclick="submitWithValue(1)">위</button>
      <button type="button" class="btn" onclick=""></button>
    </div>
    <div class="btn-row">
      <button type="button" class="btn btn-success" onclick="submitWithValue(2)">좌</button>
      <button type="button" class="btn btn-outline-success" onclick="">[자동성분변경]</button>
      <button type="button" class="btn btn-success" onclick="submitWithValue(3)">우</button>
    </div>
    <div class="btn-row">
      <button type="button" class="btn"></button>
      <button type="button" class="btn btn-success" onclick="submitWithValue(4)">아래</button>
      <button type="button" class="btn"></button>
    </div>
    <div class="btn-row">
      <button type="button" class="btn btn-outline-success" onclick="gpreset()">그룹코드초기화</button>
      <button type="button" class="btn btn-outline-success" onclick="rowdel()">행삭제</button>
      <button type="button" class="btn btn-outline-success" >&nbsp;</button>
    </div>
  </div>
</div>
<!-- -->

<script>


</script>

  </form>

<% end if %>
  <h5 class="mb-2">자재변경</h5>
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
  if whichi_fix="14" or whichi_fix="15" then 
SQL=SQL&" and whichi_fix in (12, 13, 14, 15) "
  elseif whichi_fix="16" or whichi_fix="17" or whichi_fix="18" then 
' 19 , 23
SQL=SQL&" and whichi_fix in (16, 17, 18) "
  else
SQL=SQL&" and whichi_fix=14"
  end if 
end if 

'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
  bfwidx=Rs(0)
  WHICHI_FIX=Rs(1)
  WHICHI_FIXname=Rs(2)
  i=i+1
%>
      <div class="col-4 mb-1">
        <button type="button" class="btn btn-outline-success" style="width:170px;" onclick="chg('<%=whichi_fix%>','0');"><%=WHICHI_FIXname%></button>
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
<% if groupcode="0"  then %>  
  <div class="mb-2"></div>
  <h5 class="mb-1">자동변경</h5>
  <div class="row">
      <div class="col-6 mb-1 text-start">
        <button type="button" class="btn btn-warning" style="width:250px;" onclick="chgmanual('0','1');">[롯트바]좌도어+우픽스</button>
      </div>
      <div class="col-6 mb-1 text-end">
        <button type="button" class="btn btn-warning" style="width:250px;" onclick="chgmanual('0','2');">[롯트바]좌픽스+우도어</button>
      </div> 
    </div>
    <div class="row">
      <div class="col-6 mb-1 text-start">
        <button type="button" class="btn btn-info" style="width:250px;" onclick="chgmanual('0','3');">[박스라인]좌도어+우픽스</button>
      </div>
      <div class="col-6 mb-1 text-end">
        <button type="button" class="btn btn-info" style="width:250px;" onclick="chgmanual('0','4');">[박스라인]좌픽스+우도어</button>
      </div> 
    </div>
<% end if %>

    <div class="row">
      <div class="col-6 mb-1">
      <% if groupcode > "0" then %>
        <button type="button" class="btn btn-outline-danger" onclick="chgmanual('0','5');">혼합공간초기화</button>
      <% end if %>
      </div>

    </div>
    <div class="mb-2"></div>
    <div class="row">
      <h5 class="mb-1">상부남마 세로중간통바 추가</h5>
      <div class="col-2 mb-1">
        <button type="button" class="btn btn-outline-danger" onclick="chgmanual('0','7-1');">1개</button>
      </div>
      <div class="col-2 mb-1">
        <button type="button" class="btn btn-outline-danger" onclick="chgmanual('0','7-2');">2개</button>
      </div> 
      <div class="col-2 mb-1">
        <button type="button" class="btn btn-outline-danger" onclick="chgmanual('0','7-3');">3개</button>
      </div> 
      <div class="col-2 mb-1">
        <button type="button" class="btn btn-outline-danger" onclick="chgmanual('0','7-4');">4개</button>
      </div>
      <div class="col-2 mb-1">
        <button type="button" class="btn btn-outline-danger" onclick="chgmanual('0','7-5');">5개</button>
      </div> 
      <div class="col-2 mb-1">
        <button type="button" class="btn btn-outline-danger" onclick="chgmanual('0','7-6');">6개</button>
      </div> 
    </div>

  </div>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <style>
</body>
</html>
<%

Elseif gubun="rowdel" Then '행삭제
'선택한 자재의 x좌표와 동일한 자재를 찾아 삭제 한다.
  SQL="Select fksidx From tk_framekSub Where fkidx='"&rfkidx&"' "
  SQL=SQL&" and xi=(Select xi From tk_framekSub Where fksidx='"&rfksidx&"')  "
    'response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF
      mfksidx=Rs(0)
      'Response.write mfksidx&"<br>"

      SQL="Delete From tk_framekSub where fksidx='"&mfksidx&"' "
      'Response.write (SQL)&"<br><br>"
      Dbcon.Execute SQL
   
    Rs.movenext
    Loop
    End if
    Rs.close

  Response.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');window.close();</script>"

Elseif gubun="gpreset" Then '그룹코드 초기화

  SQL="update tk_framekSub set groupcode='0' Where fksidx='"&rfksidx&"' " 
  response.write (SQL)&"<br><br>"
  Dbcon.Execute SQL
  Response.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');location.replace('inspector_v4.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"

Elseif gubun="move" Then '이동하기

  sjcidx=Request("sjcidx")
  rsjidx=Request("sjidx")
  rsjsidx=Request("sjsidx")
  rsjb_idx=Request("sjb_idx")
  rsjb_type_no=Request("sjb_type_no")
  rgreem_f_a=Request("greem_f_a")
  rfkidx=Request("fkidx")
  rfksidx=Request("fksidx")   '이동자재
  rcfksidx=Request("cfksidx") '기준자재
  rbuttonValue1=Request("buttonValue1") '1:좌상, 2:위, 3:우상, 4:좌, 5:우, 6:좌하, 7:아래, 8:우하
  response.write "move<br>"
  Response.write "rsjcidx:"&rsjcidx&"<br>"
  Response.write "rsjidx:"&rsjidx&"<br>"
  Response.write "rsjsidx:"&rsjsidx&"<br>"
  Response.write "rsjb_idx:"&rsjb_idx&"<br>"
  Response.write "rsjb_type_no:"&rsjb_type_no&"<br>"
  Response.write "rgreem_f_a:"&rgreem_f_a&"<br>"
  Response.write "rfkidx:"&rfkidx&"<br>"
  Response.write "rfksidx:"&rfksidx&"<br>"
  Response.write "rcfksidx:"&rcfksidx&"<br>"
  Response.write "rbuttonValue1:"&rbuttonValue1&"<br>"

  '이동자재의 도형의 좌표와 너비, 높이구하기
  SQL="Select xi, yi, wi, hi From tk_frameKsub Where fksidx='"&rfksidx&"' "
  response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    sxi=Rs(0)
    syi=Rs(1)
    swi=Rs(2)
    shi=Rs(3)
  End If
  Rs.Close

  '기준자재의 도형의 좌표와 너비, 높이구하기
  SQL="Select xi, yi, wi, hi, alength, blength, whichi_fix From tk_frameKsub Where fksidx='"&rcfksidx&"' "
  response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    txi=Rs(0)
    tyi=Rs(1)
    twi=Rs(2)
    thi=Rs(3)
    talength=Rs(4)
    tblength=Rs(5)
    twhichi_fix=Rs(6)
  End If
  Rs.Close

  If rbuttonValue1="0" Then    '길이 맞춤

    SQL="Update  tk_frameKsub set wi='"&twi&"', hi='"&thi&"', alength='"&talength&"', blength='"&tblength&"' Where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
  ElseIf rbuttonValue1="1" Then      '좌상
    zxi=txi-swi
    zyi=tyi-shi
    SQL="Update tk_framekSub set xi='"&zxi&"', yi='"&zyi&"' where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
  ElseIf rbuttonValue1="2" Then  '위
    zxi=txi
    zyi=tyi-shi
    SQL="Update tk_framekSub set xi='"&zxi&"', yi='"&zyi&"' where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
  ElseIf rbuttonValue1="3" Then  '우상
    zxi=txi+swi
    zyi=tyi-shi
    SQL="Update tk_framekSub set xi='"&zxi&"', yi='"&zyi&"' where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
  ElseIf rbuttonValue1="4" Then  '좌
    zxi=txi-swi
    zyi=tyi
    SQL="Update tk_framekSub set xi='"&zxi&"', yi='"&zyi&"' where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
  ElseIf rbuttonValue1="5" Then  '우
    zxi=txi+twi
    zyi=tyi
    SQL="Update tk_framekSub set xi='"&zxi&"', yi='"&zyi&"' where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
    'response.end
  ElseIf rbuttonValue1="6" Then  '좌하
    zxi=txi-swi
    zyi=tyi+shi
    SQL="Update tk_framekSub set xi='"&zxi&"', yi='"&zyi&"' where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
  ElseIf rbuttonValue1="7" Then  '아래
    zxi=txi
    zyi=tyi+thi
    SQL="Update tk_framekSub set xi='"&zxi&"', yi='"&zyi&"' where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
  ElseIf rbuttonValue1="8" Then  '우하
    zxi=txi+swi
    zyi=tyi+shi
    SQL="Update tk_framekSub set xi='"&zxi&"', yi='"&zyi&"' where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL

  ElseIf rbuttonValue1="9" Then  '선택한 프레임전체를 기준자제 상단에 맞춘다.
    SQL="Select min(yi) From tk_framekSub Where wi<>'0' and fkidx=(select fkidx From tk_framekSub where fksidx='"&rcfksidx&"') " 
    response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      jy=Rs(0)  '이동할 프레임의 바들중 가장 yi가 가장 아래것
    End If
    Rs.Close

    SQL="Select min(yi) From tk_framekSub Where wi<>'0' and fkidx=(select fkidx From tk_framekSub where fksidx='"&rfksidx&"') " 
    response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      ky=Rs(0)  '기준 프레임의 바들중 가장 yi가 가장 아래것
    End If
    Rs.close

    diff_yi=jy-ky '  둘사이의 차이

    SQL=" Select fksidx, xi, yi, wi, hi "
    SQL=SQL&" From tk_framekSub "
    SQL=SQL&" Where fkidx='"&rfkidx&"' "
    'response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF
      mfksidx=Rs(0)
      mxi=Rs(1)
      myi=Rs(2)
      mwi=Rs(3)
      mhi=Rs(4)
      'Response.write myi&"<br>"
      cmyi=myi+diff_yi

      if myi>0 then 
      SQL="Update tk_framekSub set  yi='"&cmyi&"' where fksidx='"&mfksidx&"' "
      'Response.write (SQL)&"<br><br>"
      Dbcon.Execute SQL
      end if
    Rs.movenext
    Loop
    End if
    Rs.close


  ElseIf rbuttonValue1="10" Then  '선택한 프레임전체를 기준자제 하단에 맞춘다.

    SQL="Select max(yi) From tk_framekSub Where wi<>'0' and fkidx=(select fkidx From tk_framekSub where fksidx='"&rcfksidx&"') " 
    response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      jy=Rs(0)  '이동할 프레임의 바들중 가장 yi가 가장 아래것
    End If
    Rs.Close

    SQL="Select max(yi) From tk_framekSub Where wi<>'0' and fkidx=(select fkidx From tk_framekSub where fksidx='"&rfksidx&"') " 
    response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      ky=Rs(0)  '기준 프레임의 바들중 가장 yi가 가장 아래것
    End If
    Rs.close

    diff_yi=jy-ky '  둘사이의 차이

    SQL=" Select fksidx, xi, yi, wi, hi "
    SQL=SQL&" From tk_framekSub "
    SQL=SQL&" Where fkidx='"&rfkidx&"' "
    'response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF
      mfksidx=Rs(0)
      mxi=Rs(1)
      myi=Rs(2) '이동알바의 y좌표
      mwi=Rs(3)
      mhi=Rs(4)
      'Response.write myi&"<br>"
      cmyi=myi+diff_yi

      if myi>0 then 
      SQL="Update tk_framekSub set  yi='"&cmyi&"' where fksidx='"&mfksidx&"' "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute SQL
      end if
    Rs.movenext
    Loop
    End if
    Rs.close

  ElseIf rbuttonValue1="11" Then  '프레임을 기준바의 우측으로 이동
  '미션433바가 속해있는 프레임을 351바가 있는 프레임의 우측으로 이동해라
  '1:351바가속해 있는 프레임의 가장 우측좌표를 찾는다
    SQL="Select (A.xi+A.wi) From tk_framekSub A Where A.fksidx='"&rcfksidx&"' " 
    response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      px=Rs(0)  '목적지 기준 좌표 700
    End If
    Rs.Close

    SQL="Select min(xi) From tk_framekSub Where wi<>'0' and fkidx=(select fkidx From tk_framekSub where fksidx='"&rfksidx&"') " 
    response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      jx=Rs(0)  '이동할 프레임의 바들중 가장 좌측바의 x좌표 1560
    End If
    Rs.Close

    SQL=" Select fksidx, xi, yi, wi, hi "
    SQL=SQL&" From tk_framekSub "
    SQL=SQL&" Where fkidx='"&rfkidx&"' "
    response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF
      mfksidx=Rs(0)
      mxi=Rs(1)
      move_xi=mxi-jx
      tx_xi=px+move_xi  '최종 변경될 x좌표
      Response.write px&"+"&move_xi&"="&tx_xi&"<br>"
      if mxi>0 then 
      SQL="Update tk_framekSub set xi='"&tx_xi&"' where fksidx='"&mfksidx&"' "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute SQL
      end if
    Rs.movenext
    Loop
    End if
    Rs.close

  '2:1의 좌표와 433바가 속해있는 좌표와의 차이를계산해 업데이트 한다.

  End If
  Response.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');location.replace('inspector_v4.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"

Elseif gubun="add" Then '수동프레임 부속추가
  rsjcidx=Request("sjcidx")
  rsjidx=Request("sjidx")
  rsjsidx=Request("sjsidx")
  rsjb_idx=Request("sjb_idx")
  rsjb_type_no=Request("sjb_type_no")
  rgreem_f_a=Request("greem_f_a")
  rfkidx=Request("fkidx")
  rfksidx=Request("fksidx")
  rswhichi_fix=Request("swhichi_fix") '추가할 자재
  rbuttonValue=Request("buttonValue") '1:위 2:왼쪽 3:오른쪽 4:아래

  Response.write "rsjcidx:"&rsjcidx&"<br>"
  Response.write "rsjidx:"&rsjidx&"<br>"
  Response.write "rsjsidx:"&rsjsidx&"<br>"
  Response.write "rsjb_idx:"&rsjb_idx&"<br>"
  Response.write "rsjb_type_no:"&rsjb_type_no&"<br>"
  Response.write "rgreem_f_a:"&rgreem_f_a&"<br>"
  Response.write "rfkidx:"&rfkidx&"<br>"
  Response.write "rfksidx:"&rfksidx&"<br>"
  Response.write "rswhichi_fix:"&rswhichi_fix&"<br>"
  Response.write "rbuttonValue:"&rbuttonValue&"<br>"

  '1:추가부속의 bfidx 찾기

  SQL="Select A.bfidx, A.xsize, A.ysize, A.pcent, B.glassselect "
  SQL=SQL&" From tk_barasiF A"
  SQL=SQL&" Join tng_whichitype B On A.whichi_fix=B.whichi_fix "
  SQL=SQL&" Where A.whichi_fix='"&rswhichi_fix&"' "
  if (rswhichi_fix>="12" and rswhichi_fix<="19") or rswhichi_fix="23" then 
  SQL=SQL&"and A.sjb_idx='134' "
  else
  SQL=SQL&"and A.sjb_idx='"&rsjb_idx&"' "
  end if
  response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    zbfidx=Rs(0)
    zxsize=Rs(1)
    zysize=Rs(2)
    zpcent=Rs(3)
    zgls=Rs(4)

  End if
  Rs.close
  Response.write "zbfidx:"&zbfidx&"<br>"
  Response.write "zxsize:"&zxsize&"<br>"
  Response.write "zysize:"&zysize&"<br>"
  Response.write "zpcent:"&zpcent&"<br>"
  Response.write "zgls:"&zgls&"<br>"

  '2:기준부속에서 필요한 정보 가져오기
  SQL="Select fidx, xi, yi, wi, hi, alength, blength "
  SQL=SQL&" From tk_framekSub "
  SQL=SQL&" Where fksidx='"&rfksidx&"' "
  response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    zfidx=Rs(0)
    zxi=Rs(1)
    zyi=Rs(2)
    zwi=Rs(3)
    zhi=Rs(4)
    zalength=Rs(5)
    zblength=Rs(6)
  End if
  Rs.close
  Response.write "zfidx:"&zfidx&"<br>"
  Response.write "zxi:"&zxi&"<br>"
  Response.write "zyi:"&zyi&"<br>"
  Response.write "zwi:"&zwi&"<br>"
  Response.write "zhi:"&zhi&"<br>"
  Response.write "zalength:"&zalength&"<br>"
  Response.write "zblength:"&zblength&"<br>"

  response.write "rswhichi_fix:"&rswhichi_fix&"<br>"
  '3:위치에 따른 hi값 변수저장
  Select case rswhichi_fix
    case 11 '기타
      zhi=3    
    case 1, 2, 3, 5 '가로바 계열
      zhi=20
    case 16,23  '16:수동상부픽스유리1, 23:박스라인 상부 픽스 유리
      zhi=30
    case 21, 22 '21:박스라인 22:박스라인 롯트바
      zhi=50 
    case 14, 15, 16, 17, 18, 19 '픽스유리
      zhi=80'
    case 4, 21, 22, 23 '롯트바
      zhi=50
    case 6, 7  '세로바 계열
      zhi=zhi
    case 12, 13 '수동도어유리위치
      zhi=190
    case else
      zhi=20
  end select  
  response.write "zhi:"&zhi&"<br>"

  if rbuttonValue="0" Then '수동성분변경
    if rswhichi_fix="22" then '박스라인 롯트바라면 hi를 50으로 설정
      zhi=zhi
    end if
  elseif rbuttonValue="1" Then '위
    zxi=zxi
    zyi=zyi-zhi
    zwi=zwi
    zhi=zhi

  ElseIf rbuttonValue="2" Then '왼쪽
    zxi=zxi-zwi
    zyi=zyi
    zwi=zwi
    zhi=zhi
  ElseIf rbuttonValue="3" Then '오른쪽
    zxi=zxi+zwi
    zyi=zyi
    zwi=zwi
    zhi=zhi
  ElseIf rbuttonValue="4" Then '아래
    zxi=zxi
    zyi=zyi+zhi
    zwi=zwi
    zhi=zhi
  End if
  response.write "zyi:"&zyi&"<br>"

  if zwi>zhi then 
    zgaro_sero="0"
  else
    zgaro_sero="1"
  end if


  if rbuttonValue="0" then 
    SQL="Update tk_framekSub set whichi_fix='"&rswhichi_fix&"', hi='"&zhi&"' Where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL
    Response.write "<script>window.open('TNG1_B_suju2_pop_quick.asp?cidx="&rsjcidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&fksidx="&rfksidx&"','chgbf','width=800 height=600');</script>"

    if rswhichi_fix="22" then 
      '박스라인 롯트바라면 하단 유리의 hi를 조정한다. yi=yi+30, hi=hi-10
      SQL="Select fksidx, yi, hi From tk_framekSub "
      SQL=SQL&" Where fkidx='"&rfkidx&"' "
      SQL=SQL&" and xi>=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" and xi<=(Select xi+wi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" and yi>(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
      Response.write (SQL)&"<br><br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        Do while not Rs.EOF

        sfksidx=Rs(0)
        syi=Rs(1)+30
        shi=Rs(2)-30

        SQL="Update tk_framekSub set yi='"&syi&"', hi='"&shi&"' Where fksidx='"&sfksidx&"' "
        Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

        Rs.movenext
        Loop
      End if
      Rs.close
    end if
    zfksidx=rfksidx
  else
    SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate "
    SQL=SQL&" , whichi_fix, whichi_auto, bfidx, alength, blength "
    SQL=SQL&" , pcent, xsize, ysize, gls, garo_sero) "
    SQL=SQL&" Values ('"&rfkidx&"',0, '"&zfidx&"','"&zxi&"','"&zyi&"','"&zwi&"','"&zhi&"','"&c_midx&"',getdate()"
    SQL=SQL&" ,'"&rswhichi_fix&"',0,'"&zbfidx&"','"&zalength&"','"&zblength&"' "
    SQL=SQL&" ,'"&zpcent&"','"&zxsize&"','"&zysize&"','"&zgls&"','"&zgaro_sero&"' "
    SQL=SQL&" ) "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL

    SQL="Select max(fksidx) From tk_framekSub "
    response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      zfksidx=Rs(0)
    End if
    Rs.Close
  end if
  response.write "zfksidx:"&zfksidx&"<br>"
  'Response.end
  Response.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&zfksidx&"');location.replace('inspector_v4.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&zfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"

  Elseif gubun="add2" Then '자동프레임 부속추가
  rsjcidx=Request("sjcidx")
  rsjidx=Request("sjidx")
  rsjsidx=Request("sjsidx")
  rsjb_idx=Request("sjb_idx")
  rsjb_type_no=Request("sjb_type_no")
  rgreem_f_a=Request("greem_f_a")
  rfkidx=Request("fkidx")
  rfksidx=Request("fksidx")
  rswhichi_auto=Request("swhichi_auto") '추가할 자재
  rbuttonValue=Request("buttonValue") '1:위 2:왼쪽 3:오른쪽 4:아래

  Response.write "rsjcidx:"&rsjcidx&"<br>"
  Response.write "rsjidx:"&rsjidx&"<br>"
  Response.write "rsjsidx:"&rsjsidx&"<br>"
  Response.write "rsjb_idx:"&rsjb_idx&"<br>"
  Response.write "rsjb_type_no:"&rsjb_type_no&"<br>"
  Response.write "rgreem_f_a:"&rgreem_f_a&"<br>"
  Response.write "rfkidx:"&rfkidx&"<br>"
  Response.write "rfksidx:"&rfksidx&"<br>"
  Response.write "rswhichi_fix:"&rswhichi_fix&"<br>"
  Response.write "rbuttonValue:"&rbuttonValue&"<br>"

  '1:추가부속의 bfidx 찾기

  SQL="Select A.bfidx, A.xsize, A.ysize, A.pcent, B.glassselect "
  SQL=SQL&" From tk_barasiF A"
  SQL=SQL&" Join tng_whichitype B On A.whichi_auto=B.whichi_auto "
  SQL=SQL&" Where A.whichi_auto='"&rswhichi_auto&"' "
  'if (rswhichi_auto>="12" and rswhichi_auto<="19") or rswhichi_auto="23" then 
  'SQL=SQL&"and A.sjb_idx='134' "
  'else
  'SQL=SQL&"and A.sjb_idx='"&rsjb_idx&"' "
  'end if
  response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    zbfidx=Rs(0)
    zxsize=Rs(1)
    zysize=Rs(2)
    zpcent=Rs(3)
    zgls=Rs(4)

  End if
  Rs.close
  Response.write "zbfidx:"&zbfidx&"<br>"
  Response.write "zxsize:"&zxsize&"<br>"
  Response.write "zysize:"&zysize&"<br>"
  Response.write "zpcent:"&zpcent&"<br>"
  Response.write "zgls:"&zgls&"<br>"

  '2:기준부속에서 필요한 정보 가져오기
  SQL="Select fidx, xi, yi, wi, hi, alength, blength "
  SQL=SQL&" From tk_framekSub "
  SQL=SQL&" Where fksidx='"&rfksidx&"' "
  response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    zfidx=Rs(0)
    zxi=Rs(1)
    zyi=Rs(2)
    zwi=Rs(3)
    zhi=Rs(4)
    zalength=Rs(5)
    zblength=Rs(6)
  End if
  Rs.close
  Response.write "zfidx:"&zfidx&"<br>"
  Response.write "zxi:"&zxi&"<br>"
  Response.write "zyi:"&zyi&"<br>"
  Response.write "zwi:"&zwi&"<br>"
  Response.write "zhi:"&zhi&"<br>"
  Response.write "zalength:"&zalength&"<br>"
  Response.write "zblength:"&zblength&"<br>"

  response.write "rswhichi_auto:"&rswhichi_auto&"<br>"
  '3:위치에 따른 hi값 변수저장
  Select case rswhichi_auto
    case 11         '기타
      zhi=3
    case 9          '픽스상바
      zhi=5
    case 4, 16, 17, 18          '4:상부중간소대, 16:자동상부픽스유리1, 17:자동상부픽스유리2, 18:자동상부픽스유리3
      zhi=30
    case 1          '박스세트
      zhi=50
    case 14, 15     '자동픽스유리1, 자동픽스유리2
      zhi=155
    case 12, 13, 25 '자동도어유리1, 자동도어유리2, T형_자동홈바
      zhi=180
    case 5          '중간소대
      zhi=200
    case 7       '세로픽스바
      zhi=250
    case 6        '자동홈바
      zhi=300
    case else       '이외 3:가로남마, 8:픽스하바
      zhi=20
  end select  
  response.write "zhi:"&zhi&"<br>"


  if rbuttonValue="1" Then '위
    zxi=zxi
    zyi=zyi-zhi
    zwi=zwi
    zhi=zhi

  ElseIf rbuttonValue="2" Then '왼쪽
    zxi=zxi-zwi
    zyi=zyi
    zwi=zwi
    zhi=zhi
  ElseIf rbuttonValue="3" Then '오른쪽
    zxi=zxi+zwi
    zyi=zyi
    zwi=zwi
    zhi=zhi
  ElseIf rbuttonValue="4" Then '아래
    zxi=zxi
    zyi=zyi+zhi
    zwi=zwi
    zhi=zhi
  End if
  response.write "zyi:"&zyi&"<br>"

  if zwi>zhi then 
    zgaro_sero="0"
  else
    zgaro_sero="1"
  end if

  SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate "
  SQL=SQL&" , whichi_fix, whichi_auto, bfidx, alength, blength "
  SQL=SQL&" , pcent, xsize, ysize, gls, garo_sero) "
  SQL=SQL&" Values ('"&rfkidx&"',0, '"&zfidx&"','"&zxi&"','"&zyi&"','"&zwi&"','"&zhi&"','"&c_midx&"',getdate()"
  SQL=SQL&" ,0,'"&rswhichi_auto&"','"&zbfidx&"','"&zalength&"','"&zblength&"' "
  SQL=SQL&" ,'"&zpcent&"','"&zxsize&"','"&zysize&"','"&zgls&"','"&zgaro_sero&"' "
  SQL=SQL&" ) "
  Response.write (SQL)&"<br><br>"
  Dbcon.Execute SQL
  'response.end
  SQL="Select max(fksidx) From tk_framekSub "
  response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    zfksidx=Rs(0)
  End if
  Rs.Close

  response.write "zfksidx:"&zfksidx&"<br>"
  Response.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&zfksidx&"');location.replace('inspector_v4.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&zfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"

ElseIf gubun="up1date" Then 'alength, blength, xi, yi, wi, hi 단일(일괄)적용
  roptionType=Request("optionType") '1:단독적용 2:일괄적용
  ralength=int(Request("alength")) '도어와 유리의 가로사이즈
  rblength=int(Request("blength")) '도어와 유리의 세로사이즈/바의 가로 사이즈
  rxi=Request("xi") '선택한 부속(바/도어/유리)의 x좌표
  ryi=Request("yi") '선택한 부속(바/도어/유리)의 y좌표
  rwi=Request("wi") '선택한 부속(바/도어/유리)의 폭
  rhi=Request("hi") '선택한 부속(바/도어/유리)의 두께

  Response.write "roptionType:"&roptionType&"<br>"
  Response.write "ralength:"&ralength&"<br>"
  Response.write "rblength:"&rblength&"<br>"
  Response.write "rxi:"&rxi&"<br>"
  Response.write "ryi:"&ryi&"<br>"
  Response.write "rwi:"&rwi&"<br>"
  Response.write "rhi:"&rhi&"<br>"


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
    SQL=SQL&" , F.glassselect, G.glassselect, A.xi, A.yi, A.wi, A.hi "
    SQL=SQL&" From tk_framekSub A "
    SQL=SQL&" Join tk_framek B on A.fkidx = B.fkidx "
    SQL=SQL&" Join tng_sjbtype C on B.sjb_type_no = C.SJB_TYPE_NO "
    SQL=SQL&" Join tk_barasiF D on A.bfidx = D.bfidx "
    SQL=SQL&" Join tk_frame E on A.fidx = E.fidx "
    SQL=SQL&" Join tng_whichitype F on A.WHICHI_FIX = F.WHICHI_FIX "
    SQL=SQL&" Join tng_whichitype G on A.WHICHI_AUTO = G.WHICHI_AUTO"
    If roptionType="1" Then 
    SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
    ElseIf  roptionType="2" Then 
      'if zwhichi_fix_type="wb" then 
      '  SQL=SQL&" Where A.xi=(Select xi  From tk_framekSub H where H.fksidx='"&rfksidx&"') "
      '  SQL=SQL&" and A.wi=(Select wi From tk_framekSub I where I.fksidx='"&rfksidx&"') "
      '  SQL=SQL&" and A.xi='"&rxi&"' "
      'elseif  zwhichi_fix_type="hb" then 
      '  SQL=SQL&" Where A.yi=(Select yi  From tk_framekSub H where H.fksidx='"&rfksidx&"') "
      '  SQL=SQL&" and A.hi=(Select hi From tk_framekSub I where I.fksidx='"&rfksidx&"') "
      '  SQL=SQL&" and A.yi='"&ryi&"' "
      'end if
    SQL=SQL&" and A.fkidx='"&rfkidx&"' "
      if WHICHI_FIX="6" or WHICHI_FIX="7" then '세로바라면
        SQL=SQL&" Where A.yi=(Select yi  From tk_framekSub H where H.fksidx='"&rfksidx&"') "
        SQL=SQL&" and A.hi=(Select hi From tk_framekSub I where I.fksidx='"&rfksidx&"') "
        SQL=SQL&" and A.yi='"&ryi&"' "
        SQL=SQL&" Order by A.xi asc "
      Else  ' 그외의 부속이라면
        SQL=SQL&" Where A.xi=(Select xi  From tk_framekSub H where H.fksidx='"&rfksidx&"') "
        SQL=SQL&" and A.wi=(Select wi From tk_framekSub I where I.fksidx='"&rfksidx&"') "
        SQL=SQL&" and A.xi='"&rxi&"' "
        SQL=SQL&" Order by A.yi asc "
      end if
    
    End If

    response.write (SQL)&"<br><br><br>"
    'response.end
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
      zwi = Rs(51)
      zhi = Rs(52)
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




            Select Case zwhichi_fix 
                Case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,  11, 20, 21, 22, 24, 25 ' 롯트바 = 4  박스라인롯트바 = 22 ,세로바=6 180도 코너바=8 90도 코너바=9 비규격 코너바=10 
                  alength=0
                  if zwhichi_fix_type="wb" then 
                      blength=rblength
                  else
                      blength=ralength
                  end if
                    door_w=zdoor_w
                    door_h=zdoor_h
                    glass_w=zglass_w
                    glass_h=zglass_h
                    Response.write "바<br>"
                Case 12 '외도어
                    if zwhichi_fix_type="wb" then 
                      ralength=int(rblength)
                      rblength=0
                    end if
                    alength=ralength
                    blength=rblength  '도어의 세로의 길이 
  '=====                  
                    'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우
                      door_w=int(alength+zdwsize1)
                      door_h=int(blength+zdhsize1)
                      glass_w=zglass_w
                      glass_h=zglass_h
                    'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                    '  door_w=int(alength+zdwsize1)
                    '  door_h=int((zth-rblength-zfl-sysize)/scnt)
                    '  glass_w=0
                    '  glass_h=0
                    'end if
  '=====  
                    Response.write "외도어<br>"
                Case 13 '양개도어
                    if zwhichi_fix_type="wb" then 
                      ralength=int(rblength)
                      rblength=0
                    end if
  '=====              
                    alength=ralength  '도어의 가로의 길이
                    blength=rblength   '도어의 세로의 길이     
                    'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우
                      door_w=int(alength+zdwsize2)
                      door_h=int(blength+zdhsize2)
                      glass_w=zglass_w
                      glass_h=zglass_h
                    'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                    '  door_w=int(alength+zdwsize2)
                    '  door_h=int((zth-rblength-zfl-sysize)/scnt)
                    '  glass_w=0
                    '  glass_h=0
                    'end if
  '=====  
                    Response.write "양개도어<br>"
                Case 14, 15 '하부픽스 유리1, 2
                    if zwhichi_fix_type="wb" then 
                      ralength=int(rblength)
                      rblength=0
                    end if
  '=====    
  response.write "zgwsize1:"&zgwsize1&"<br>"
  response.write "zghsize1:"&zghsize1&"<br>"
                    alength=int(ralength)          '하부픽스 유리의 가로의 길이
                    blength=int(rblength)          '하부픽스 유리의 세로의 길이           
                    'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우
                      door_w=zdoor_w
                      door_h=zdoor_h
                      glass_w=int(alength+zgwsize1)   '하부픽스 유리의 가로의 길이
                      glass_h=int(blength+zghsize1)   '하부픽스 유리의 세로의 길이
                    'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                    '  door_w=0
                    '  door_h=0
                    '  glass_w=int(alength+zgwsize1)
                    '  glass_h=int((zth-rblength-zfl-sysize)/scnt)
                    '  response.write glass_h&"/<br>"

                    'end if
  '===== 

                    Response.write "하부픽스 유리<br>"
                Case 19 , 23  '박스라인 하부픽스 유리 ,  11
                    if zwhichi_fix_type="wb" then 
                      ralength=int(rblength)
                      rblength=0
                    end if
  '=====     
                    alength=int(ralength)          '박스라인 하부픽스 유리의 가로의 길이
                    blength=int(rblength)          '박스라인 하부픽스 유리의 세로의 길이              
                    'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우
                      door_w=zdoor_w
                      door_h=zdoor_h
                      glass_w=int(alength+zgwsize2)   '박스라인 하부픽스 유리의 가로의 길이
                      glass_h=int(blength+zghsize2)   '박스라인 하부픽스 유리의 가로의 길이

                    'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                    '  door_w=0
                    '  door_h=0
                    '  glass_w=int(alength+zgwsize2)
                    '  glass_h=int((zth-rblength-zfl-sysize)/scnt)

                    'end if
  '===== 
                    Response.write "박스라인 하부픽스 유리<br>"
                Case 16, 17, 18 '상부남마픽스유리 1,2,3
                    if zwhichi_fix_type="wb" then 
                      ralength=int(rblength)
                      rblength=0
                    end if
  '=====          
                    alength=int(ralength)          '상부남마픽스유리 유리의 가로의 길이
                    blength=int(rblength)          '상부남마픽스유리 유리의 세로의 길이         
                    'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우

                      door_w=zdoor_w
                      door_h=zdoor_h
                      glass_w=int(alength+zgwsize3)   '상부남마픽스유리 유리의 가로의 길이
                      glass_h=int(blength+zghsize3)   '상부남마픽스유리 유리의 세로의 길이
                    'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                    '  door_w=0
                    '  door_h=0
                    '  glass_w=int(alength+zgwsize3)
                    '  glass_h=int((zth-rblength-zfl-sysize)/scnt)

                    'end if
  '===== 
                    Response.write "상부남마픽스유리<br>"
                case 11, 24, 25 '기타
                    if zwhichi_fix_type="wb" then 
                      ralength=int(rblength)
                      rblength=0
                    end if
                    alength=int(ralength)
                    blength=int(rblength)                  
                    door_w=zdoor_w
                    door_h=zdoor_h
                    glass_w=zglass_w
                    glass_h=zglass_h
                    Response.write "기타<br>"
            End Select



    '선택한 해당 자재의 길이 적용

    if clng(rfksidx)=clng(zfksidx) then '선택한 fksidx와 전달받은 키가 일치한다면 더이상 자동으로 길이를 업데이트 하지 못하도록 rstatus=1로 설정한다.
      SQL="Update tk_framekSub "
      SQL=SQL&" Set alength='"&alength&"',blength='"&blength&"', door_w='"&door_w&"', door_h='"&door_h&"' "
      SQL=SQL&" , glass_w='"&glass_w&"', glass_h='"&glass_h&"', rstatus='1', rstatus2='1' "
      SQL=SQL&" , xi='"&rxi&"', yi='"&ryi&"', wi='"&rwi&"', hi='"&rhi&"' "    
      SQL=SQL&" , bokgu_xi='"&rxi&"', bokgu_yi='"&ryi&"', bokgu_wi='"&rwi&"', bokgu_hi='"&rhi&"', bokgu_alength='"&alength&"', bokgu_blength='"&blength&"' "
      SQL=SQL&" Where fksidx='"&zfksidx&"' "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute SQL
    Else  
      SQL="Update tk_framekSub "
      SQL=SQL&" Set alength='"&alength&"',blength='"&blength&"', door_w='"&door_w&"', door_h='"&door_h&"'"
      SQL=SQL&" , glass_w='"&glass_w&"', glass_h='"&glass_h&"', rstatus='0', rstatus2='1' "
    
      SQL=SQL&" , bokgu_xi='"&rxi&"', bokgu_yi='"&ryi&"', bokgu_wi='"&rwi&"', bokgu_hi='"&rhi&"', bokgu_alength='"&alength&"', bokgu_blength='"&blength&"' "
      SQL=SQL&" Where fksidx='"&zfksidx&"' "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute SQL


    end if

        '가로바들의 세로합 구하기
        SQL=" Select sum(ysize) "
        SQL=SQL&" From tk_framekSub A " 
        SQL=SQL&" Where A.fkidx='"&rfkidx&"' and A.xi='"&rxi&"' "
        SQL=SQL&" and A.whichi_fix in (select B.whichi_fix from tng_whichitype B where B.whichi_fix<>'' and B.glassselect=0)"
        Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
          sysize=Rs1(0)
        End If
        Rs1.Close

        '단독적용으로 확정된 유리들의 blength 합
        SQL=" Select sum(blength) From tk_framekSub A "
        SQL=SQL&" Where  A.fkidx='"&rfkidx&"' and A.xi='"&rxi&"' "
        SQL=SQL&" and A.rstatus='1' "
        SQL=SQL&" and A.whichi_fix in (12, 13, 14, 15, 16, 17, 18, 19, 23) "
        Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
          sblength=Rs1(0)
        End If
        Rs1.Close
        '자동입력될 도어(공간),유리의 갯수
        SQL=" Select count(*) "
        SQL=SQL&" From tk_framekSub A "
        SQL=SQL&" Where A.fkidx='"&rfkidx&"' and A.xi='"&rxi&"' and fksidx<>'"&rfksidx&"' and A.rstatus='0' "
        SQL=SQL&" and whichi_fix not in (select whichi_fix from tng_whichitype where whichi_fix<>'' and glassselect=0) "
        Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
          scnt=Rs1(0)
        End If
        Rs1.Close

'=====유리계열만 선택되도록
    if zwhichi_fix=14 or zwhichi_fix=15 or zwhichi_fix=19 or zwhichi_fix=23 or zwhichi_fix=16 or zwhichi_fix=17 or zwhichi_fix=18 Then 
        agtype="glass"
    end if


'===================


      if roptionType="1" and scnt>0 and agtype="glass" then '단독적용일때 동일 xi상에 있는 유리값 자동 계산적용
        '**나머지 픽스유리 alength, blength 자동입력
        '=====================================
        '1:동일한 xi값에 있는 바의 세로값의 합을 구한다.=>위에 있음
        '2:픽스유리의 갯수를 산출한다.=>위에 있음
        '3:픽스유리의 세로(blength)자동입력값 = (검측높이-선택된 유리의 높이-가로바들의 높이 합-묻힘값)/픽스유리의 갯수
        '4:픽스유리를 찾아 alength와 blength값 업데이트, rstatus=0, rstatus2=1


        '픽스유리의 세로길이

    Response.write "========<br>"    
    Response.write "zth:"&zth&"<br>"
    Response.write "rblength:"&rblength&"<br>"
    Response.write "zfl:"&zfl&"<br>"
    Response.write "sysize:"&sysize&"<br>"
    Response.write "scnt:"&scnt&"<br>"

        even_blength=int((zth-zfl-sysize-sblength)/scnt)

    Response.write "even_blength:"&even_blength&"<br>"
    Response.write "========<br>"   

        SQL=" Select A.fksidx, A.whichi_fix "
        SQL=SQL&" , C.dwsize1, C.dhsize1, C.dwsize2, C.dhsize2, C.dwsize3, C.dhsize3 "
        SQL=SQL&" , C.dwsize4, C.dhsize4, C.dwsize5, C.dhsize5"
        SQL=SQL&" , C.gwsize1, C.ghsize1, C.gwsize2, C.ghsize2, C.gwsize3, C.ghsize3"
        SQL=SQL&" , C.gwsize4, C.ghsize4, C.gwsize5, C.ghsize5, C.gwsize6, C.ghsize6 "
        SQL=SQL&" , D.xsize, D.ysize "
        SQL=SQL&" From tk_framekSub A "
        SQL=SQL&" Join tk_framek B on A.fkidx = B.fkidx " 
        SQL=SQL&" Join tng_sjbtype C on B.sjb_type_no = C.SJB_TYPE_NO "
        SQL=SQL&" Join tk_barasiF D on A.bfidx = D.bfidx "
        SQL=SQL&" Where A.fkidx='"&rfkidx&"' and A.xi='"&rxi&"' and A.fksidx<>'"&zfksidx&"' "
        SQL=SQL&" and A.whichi_fix in (12, 13, 14, 15, 16, 17, 18, 19, 23) "
        SQL=SQL&" and A.rstatus='0' "
        Response.write (SQL)&"<br><br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
        Do while not Rs1.EOF
        Response.write "even_blength:"&even_blength&"<br>"
        Response.write "whichi_fix:"&Rs1(16)&"<br>"
        Response.write "whichi_fix:"&Rs1(17)&"<br>"

          select case Rs1(1)
            case 12                       '수동도어유리1:편개
              door_w=int(alength+Rs1(2))
              door_h=int(even_blength+Rs1(3))
              glass_w=0
              glass_h=0
    
            case 13                       '수동도어유리2:양개
              door_w=int(alength+Rs1(4))
              door_h=int(even_blength+Rs1(5))
              glass_w=0
              glass_h=0
            case 14, 15                   '수동픽스유리 1,2
              door_w=0
              door_h=0
              glass_w=int(alength+Rs1(12))   
              glass_h=int(even_blength+Rs1(13))    
            case 16, 17, 18               '수동상부픽스유리1,2,3
              door_w=0
              door_h=0
              glass_w=int(alength+Rs1(16))   
              glass_h=int(even_blength+Rs1(17))  
            case 19, 23                   '19:박스라인 하부 픽스유리/23:박스라인 상부 픽스유리
              door_w=0
              door_h=0
              glass_w=int(alength+Rs1(14)) 
              glass_h=int(even_blength+Rs1(15))
          end select

          SQL="Update tk_framekSub set alength='"&alength&"', blength='"&even_blength&"' "
          SQL=SQL&" , bokgu_alength='"&alength&"', bokgu_blength='"&even_blength&"' "
          SQL=SQL&" , door_w='"&door_w&"', door_h='"&door_h&"', glass_w='"&glass_w&"', glass_h='"&glass_h&"' "
          SQL=SQL&" , rstatus='0', rstatus2='1' " '직접등록된 값이 아닌 자동 등록된 값이라는 의미
          SQL=SQL&" Where fksidx='"&Rs1(0)&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute SQL

        Rs1.movenext
        Loop
        End if
        Rs1.close
        '=====================================
      end if


    else  '자동프레임
      SQL="Update tk_framekSub "
      SQL=SQL&" Set alength='"&ralength&"',blength='"&rblength&"', door_w='"&door_w&"', door_h='"&door_h&"' "
      SQL=SQL&" , glass_w='"&glass_w&"', glass_h='"&glass_h&"', rstatus='1', rstatus2='1' "
      SQL=SQL&" , xi='"&rxi&"', yi='"&ryi&"', wi='"&rwi&"', hi='"&rhi&"' "    
      SQL=SQL&" , bokgu_xi='"&rxi&"', bokgu_yi='"&ryi&"', bokgu_wi='"&rwi&"', bokgu_hi='"&rhi&"', bokgu_alength='"&alength&"', bokgu_blength='"&blength&"' "
      SQL=SQL&" Where fksidx='"&zfksidx&"' "
      Response.write (SQL)&"***<br><br>"
      Dbcon.Execute SQL
    end if
    '수동도어 계산 끝

  '매개변수 다시받아 저장하기
    ralength=int(Request("alength"))
    rblength=int(Request("blength"))

    Response.write "ralength0000:"&ralength&"<br>"
    Response.write "rblength0000:"&rblength&"<br>"
  Rs.movenext
  Loop
  End if
  Rs.close
'response.end
    '일괄적용 추가 작업
    if roptionType="2" then 
    '일괄적용일 경우 오른쪽에 바가 있는지 확인
    SQL="Select A.fksidx, A.xi, A.yi, A.wi, A.hi "
    SQL=SQL&" From tk_framekSub A " 
    SQL=SQL&" Where A.fkidx='"&rfkidx&"' and A.wi<>'20' and A.fksidx<>'"&rfksidx&"' "
    SQL=SQL&" and A.yi in (Select B.yi From tk_framekSub B Where B.fksidx='"&rfksidx&"') "
    SQL=SQL&" and A.rstatus='0'"
    SQL=SQL&" order by A.xi asc "
    response.write (SQL)&"<br>"
    Rs1.open Sql,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then 
      fksidx=Rs1(0)
      xi=Rs1(1)
      yi=Rs1(2)
      wi=Rs1(3)
      hi=Rs1(4)
    ' 추천 가로길이((검측가로-좌측 바들의 길이합)/남은 우측 바들의 수)가 기본으로 나오고, 수정 가능

      SQL="Select sum(ysize) from tk_framekSub where fkidx='"&rfkidx&"' and wi=20 "
      SQL=SQL&" and yi=(select min(yi) From tk_framekSub where fkidx='"&rfkidx&"' and wi=20) "
      response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      If Not (Rs2.bof or Rs2.eof) Then 
        sum_ysize=Rs2(0)
      End If
      Rs2.Close

      SQL="Select count(*) from tk_framekSub Where fkidx='"&rfkidx&"' and rstatus=0 and wi<>20 "
      SQL=SQL&" and yi=(Select yi from tk_framekSub where fksidx='"&rfksidx&"') "
      response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      If Not (Rs2.bof or Rs2.eof) Then 
        barcnt=Rs2(0)
      End If
      Rs2.Close

      SQL=" Select sum(alength), sum(blength) " 
      SQL=SQL&" From tk_framekSub where fkidx='"&rfkidx&"' and wi<>20 and rstatus2='1' "
      SQL=SQL&" and yi=(Select yi from tk_framekSub where fksidx='"&rfksidx&"') "
      response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      If Not (Rs2.bof or Rs2.eof) Then 
        salength=Rs2(0)
        sblength=Rs2(1)
      End If
      Rs2.Close
      if zwhichi_fix_type="wb" then 
        garosize=sblength
      else
        garosize=salength
      end if

      divalength=(ztw-garosize-sum_ysize)/barcnt
      Response.write "zwhichi_fix_type:"&zwhichi_fix_type&"<br>"

      if zwhichi_fix_type="wb" then 

        alength="0"
        blength=int(divalength)
      else
        alength=int(divalength)
        blength=int(rblength)
      end if
      Response.write "ztw:"&ztw&"<br>"
      Response.write "garosize:"&garosize&"<br>"
  
      Response.write "sum_ysize:"&sum_ysize&"<br>"
      Response.write "barcnt:"&barcnt&"<br>"

      Response.write "alength:"&alength&"<br>"
      Response.write "blength:"&blength&"<br>"
    'response.end
    'response.write "<script>location.replace('inspector_v4.asp?gubun=up1date&optionType="&roptionType&"&sjcidx="&rsjcidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_idx="&rsjb_idx&"&SJB_TYPE_NO="&rSJB_TYPE_NO&"&greem_f_a="&rgreem_f_a&"&fkidx="&rfkidx&"&fksidx="&fksidx&"&xi="&xi&"&yi="&yi&"&wi="&wi&"&hi="&hi&"&alength="&alength&"&blength="&blength&"')</script>"

    End If
    Rs1.Close





  '
    end if
    'response.write "asdfasF"
  Response.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');location.replace('inspector_v4.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"
Elseif gubun="lengthreset" then 

  SQL="Update tk_framekSub set rstatus='0', rstatus2='0', alength='0', blength='0', door_w='0', door_h='0', glass_w='0', glass_h='0' Where fkidx='"&rfkidx&"' "
  'Response.write (SQL)&"<br><br>"
  Dbcon.Execute (SQL)

  REsponse.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');location.replace('inspector_v4.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"

Elseif gubun="chg" Then 
  rwhichi_fix=Request("whichi_fix")
  rmode=Request("mode")
  rdoorwhichi=Request("doorwhichi") '혼합공간에서 도어의 위치
  response.write "rwhichi_fix:"&rwhichi_fix&"<br>"
  response.write "rmode:"&rmode&"<br>"
  response.write "whichi_fix:"&whichi_fix&"<br>"
  response.write "rdoorwhichi:"&rdoorwhichi&"<br>"


  if rmode="auto" then '일괄적용
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

  
  elseif rmode="manual" then '단독적용

    if rwhichi_fix="12" then '수동도어유리1(편개)
    '============================
    '1.상바를 롯트바로 변경한다.
      SQL=" Update tk_framekSub set whichi_fix=4 "
      SQL=SQL&" Where fksidx= "
      SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
      SQL=SQL&" Where fkidx='"&rfkidx&"' "
      SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" order by yi desc) "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute (SQL)
    '2.하바를 없앤다.
      SQL=" Delete From tk_framekSub "
      SQL=SQL&" Where fksidx= "
      SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
      SQL=SQL&" Where fkidx='"&rfkidx&"' "
      SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and yi>(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" order by yi asc) "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute (SQL)
    '3-1.수동도어유리1으로 whichi_fix=12로 수정하고 
      SQL="Update tk_framekSub set whichi_fix='"&rwhichi_fix&"' where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute (SQL)
    '3-2.수동도어의 blength, ysize 길이 재입력 그리고 하바의 hi만큼 추가.
    '그리고 3-3.도형의 세로(yi)값에 하바의 yi값을 추가한다..
      SQL=" select A.fksidx, A.WHICHI_AUTO, A.WHICHI_FIX, A.door_w, A.door_h, A.glass_w, A.glass_h, A.gls "
      SQL=SQL&" , B.sjb_idx, B.sjb_type_no, B.greem_o_type, B.GREEM_BASIC_TYPE, B.greem_fix_type  "
      SQL=SQL&" , B.tw, B.th, B.ow, B.oh, B.fl, B.ow_m "
      SQL=SQL&" , C.dwsize1, C.dhsize1, C.dwsize2, C.dhsize2, C.dwsize3, C.dhsize3 "
      SQL=SQL&" , C.dwsize4, C.dhsize4, C.dwsize5, C.dhsize5, C.gwsize1, C.ghsize1 "
      SQL=SQL&" , C.gwsize2, C.ghsize2, C.gwsize3, C.ghsize3, C.gwsize4, C.ghsize4 "
      SQL=SQL&" , C.gwsize5, C.ghsize5, C.gwsize6, C.ghsize6 "
      SQL=SQL&" , D.xsize, D.ysize " 
      SQL=SQL&" , E.opa, E.opb, E.opc, E.opd "
      SQL=SQL&" , F.glassselect, G.glassselect, A.xi, A.yi, A.wi, A.hi, A.alength, A.blength "
      SQL=SQL&" From tk_framekSub A "
      SQL=SQL&" Join tk_framek B on A.fkidx = B.fkidx "
      SQL=SQL&" Join tng_sjbtype C on B.sjb_type_no = C.SJB_TYPE_NO "
      SQL=SQL&" Join tk_barasiF D on A.bfidx = D.bfidx "
      SQL=SQL&" Join tk_frame E on A.fidx = E.fidx "
      SQL=SQL&" Join tng_whichitype F on A.WHICHI_FIX = F.WHICHI_FIX "
      SQL=SQL&" Join tng_whichitype G on A.WHICHI_AUTO = G.WHICHI_AUTO"
      SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 

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
        zxi = rs(49)
        zyi = rs(50)
        zwi = rs(51)
        zhi = rs(52)
        zalength = Rs(53)
        zblength = Rs(54)

        zblength = zoh '도어유리이므로 blength 도어높이 값으로 변경
        door_w=int(zalength+zdwsize1)
        door_h=int(zblength+zdhsize1)
        glass_w=0
        glass_h=0

        response.write "zoh:"&zoh&"<br>"
        response.write "zdwsize1:"&zdwsize1&"<br>"
        response.write "zdhsize1:"&zdhsize1&"<br>"

        zhi=zhi+20
        SQL="Update tk_framekSub Set alength='"&zalength&"',blength='"&zblength&"', door_w='"&door_w&"', door_h='"&door_h&"' "
        SQL=SQL&" , glass_w='"&glass_w&"', glass_h='"&glass_h&"', rstatus='1', rstatus2='1' "
        SQL=SQL&" , hi='"&zhi&"', groupcode='"&zfksidx&"' "
        SQL=SQL&" Where fksidx='"&zfksidx&"' "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
      End If
    Rs.close
    'Response.end
    '============================
    elseif rwhichi_fix="13" then  '수동도어유리2(양개)
    '============================
    '1.상바를 롯트바로 변경한다.
      SQL=" Update tk_framekSub set whichi_fix=4 "
      SQL=SQL&" Where fksidx= "
      SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
      SQL=SQL&" Where fkidx='"&rfkidx&"' "
      SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" order by yi desc) "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute (SQL)
    '2.하바를 없앤다.
      SQL=" Delete From tk_framekSub "
      SQL=SQL&" Where fksidx= "
      SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
      SQL=SQL&" Where fkidx='"&rfkidx&"' "
      SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and yi>(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" order by yi asc) "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute (SQL)
    '3-1.수동도어유리1으로 whichi_fix=12로 수정하고 
      SQL="Update tk_framekSub set whichi_fix='"&rwhichi_fix&"' where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute (SQL)
    '3-2.수동도어의 blength, ysize 길이 재입력 그리고 하바의 hi만큼 추가.
    '그리고 3-3.도형의 세로(yi)값에 하바의 yi값을 추가한다..
      SQL=" select A.fksidx, A.WHICHI_AUTO, A.WHICHI_FIX, A.door_w, A.door_h, A.glass_w, A.glass_h, A.gls "
      SQL=SQL&" , B.sjb_idx, B.sjb_type_no, B.greem_o_type, B.GREEM_BASIC_TYPE, B.greem_fix_type  "
      SQL=SQL&" , B.tw, B.th, B.ow, B.oh, B.fl, B.ow_m "
      SQL=SQL&" , C.dwsize1, C.dhsize1, C.dwsize2, C.dhsize2, C.dwsize3, C.dhsize3 "
      SQL=SQL&" , C.dwsize4, C.dhsize4, C.dwsize5, C.dhsize5, C.gwsize1, C.ghsize1 "
      SQL=SQL&" , C.gwsize2, C.ghsize2, C.gwsize3, C.ghsize3, C.gwsize4, C.ghsize4 "
      SQL=SQL&" , C.gwsize5, C.ghsize5, C.gwsize6, C.ghsize6 "
      SQL=SQL&" , D.xsize, D.ysize " 
      SQL=SQL&" , E.opa, E.opb, E.opc, E.opd "
      SQL=SQL&" , F.glassselect, G.glassselect, A.xi, A.yi, A.wi, A.hi, A.alength, A.blength, A.fidx, A.bfidx "
      SQL=SQL&" From tk_framekSub A "
      SQL=SQL&" Join tk_framek B on A.fkidx = B.fkidx "
      SQL=SQL&" Join tng_sjbtype C on B.sjb_type_no = C.SJB_TYPE_NO "
      SQL=SQL&" Join tk_barasiF D on A.bfidx = D.bfidx "
      SQL=SQL&" Join tk_frame E on A.fidx = E.fidx "
      SQL=SQL&" Join tng_whichitype F on A.WHICHI_FIX = F.WHICHI_FIX "
      SQL=SQL&" Join tng_whichitype G on A.WHICHI_AUTO = G.WHICHI_AUTO"
      SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 

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
        zxi = rs(49)
        zyi = rs(50)
        zwi = rs(51)
        zhi = rs(52)
        zalength = Rs(53)
        zblength = Rs(54)
        zfidx = Rs(55)
        zbfidx = Rs(56)

        zblength = zoh '도어유리이므로 blength 도어높이 값으로 변경
        door_w=int(zalength+zdwsize1)
        door_h=int(zblength+zdhsize1)
        glass_w=0
        glass_h=0

        response.write "zoh:"&zoh&"<br>"
        response.write "zdwsize1:"&zdwsize1&"<br>"
        response.write "zdhsize1:"&zdhsize1&"<br>"
        zhi=zhi+20
        SQL="Update tk_framekSub Set alength='"&zalength&"',blength='"&zblength&"', door_w='"&door_w&"', door_h='"&door_h&"' "
        SQL=SQL&" , glass_w='"&glass_w&"', glass_h='"&glass_h&"', rstatus='1', rstatus2='1' "
        SQL=SQL&" , hi='"&zhi&"' "
        SQL=SQL&" Where fksidx='"&zfksidx&"' "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
      End If
    Rs.close

    '3-3: alength, door_w, wi의 길이를 절반으로 줄인다.
    zalength=int(zalength/2)
    door_w=int((door_w+zdwsize1)/2)
    zwi=int(zwi/2)
    SQL="Update tk_framekSub set alength='"&zalength&"', door_w='"&door_w&"', wi='"&zwi&"', groupcode='"&zfksidx&"' " 
    SQL=SQL&" Where fksidx='"&zfksidx&"' "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL

    '3-3: 동일한 유리를 복제한다.xi값을  기존 zxi=zxi+zwi로 설정한다.
    zxi=zxi+zwi
    
    SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
    SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
    SQL=SQL&" , fstype, glasstype, blength, unitprice, pcent, sprice, xsize, ysize, gls "
    SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
    SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
    SQL=SQL&" , goname, barname, alength, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode) "
    SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&zxi&"', '"&zyi&"', '"&zwi&"', '"&zhi&"' "
    SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&rwhichi_fix&"', '0', '"&zbfidx&"' "
    SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&zalength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"' "
    SQL=SQL&" , '0', '0', '0', '"&door_w&"', '"&door_h&"', '0', '0', '0', '0', '0', '0', '0', '0', '0' "
    SQL=SQL&" , '0', '0', '0', '0', '0', '0', '1', '1', '0','"&zfksidx&"') "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute SQL



    '============================
    elseif rwhichi_fix="14" then  '수동픽스유리1(고정창)/초기화
    '============================
'1. 상바의 속성을 가로바(whichi_fix=1)로 변경한다.
'1-1 : 박스라인롯트바에서 초기화라면 hi값도 20으로 변경

'2. / 3번     
      SQL=" select A.fksidx, A.WHICHI_AUTO, A.WHICHI_FIX, A.door_w, A.door_h, A.glass_w, A.glass_h, A.gls "
      SQL=SQL&" , B.sjb_idx, B.sjb_type_no, B.greem_o_type, B.GREEM_BASIC_TYPE, B.greem_fix_type  "
      SQL=SQL&" , B.tw, B.th, B.ow, B.oh, B.fl, B.ow_m "
      SQL=SQL&" , C.dwsize1, C.dhsize1, C.dwsize2, C.dhsize2, C.dwsize3, C.dhsize3 "
      SQL=SQL&" , C.dwsize4, C.dhsize4, C.dwsize5, C.dhsize5, C.gwsize1, C.ghsize1 "
      SQL=SQL&" , C.gwsize2, C.ghsize2, C.gwsize3, C.ghsize3, C.gwsize4, C.ghsize4 "
      SQL=SQL&" , C.gwsize5, C.ghsize5, C.gwsize6, C.ghsize6 "
      SQL=SQL&" , D.xsize, D.ysize " 
      SQL=SQL&" , E.opa, E.opb, E.opc, E.opd "
      SQL=SQL&" , F.glassselect, G.glassselect, A.xi, A.yi, A.wi, A.hi, A.alength, A.blength, A.fidx "
      SQL=SQL&" From tk_framekSub A "
      SQL=SQL&" Join tk_framek B on A.fkidx = B.fkidx "
      SQL=SQL&" Join tng_sjbtype C on B.sjb_type_no = C.SJB_TYPE_NO "
      SQL=SQL&" Join tk_barasiF D on A.bfidx = D.bfidx "
      SQL=SQL&" Join tk_frame E on A.fidx = E.fidx "
      SQL=SQL&" Join tng_whichitype F on A.WHICHI_FIX = F.WHICHI_FIX "
      SQL=SQL&" Join tng_whichitype G on A.WHICHI_AUTO = G.WHICHI_AUTO"
      SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br><br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 

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
        zxi = rs(49)
        zyi = rs(50)
        zwi = rs(51)
        zhi = rs(52)
        zalength = Rs(53)
        zblength = Rs(54)
        zfidx = Rs(55)


        SQL="Select bfidx, xsize, ysize "
        SQL=SQL&" From tk_barasiF Where  whichi_fix='"&rwhichi_fix&"' and sjb_idx='"&rsjb_idx&"' and ysize= "
        SQL=SQL&" (Select min(ysize) from tk_barasiF where whichi_fix='"&rwhichi_fix&"' and sjb_idx='"&rsjb_idx&"') "
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
          abfidx=Rs1(0)
          axsize=Rs1(1)
          aysize=Rs1(2)
        End If
        Rs1.Close

        '2. 하바(whichi_fix=5)를 추가한다.
        if whichi_fix="12" then '이전 속성이 편개(수동도어유리1)이었다면        



        '유리 상바의  whichi_fix값 찾아서 박스라인롯트바인 경우와 이외의 경우에 대한 픽스유리 yi, hi 값처리 
      SQL="Select top 1 whichi_fix From tk_framekSub "
      SQL=SQL&" Where fkidx='"&rfkidx&"' "
      SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" order by yi desc "
      Response.write (SQL)&"<br><br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
          swhichi_fix=Rs1(0)
          if swhichi_fix="22" then 
            zyi=zyi-30
            zhi=zhi+10
            aba_zyi=zyi+zhi  '하바의 y좌표
          else
            zyi=zyi
            zhi=zhi-20
            aba_zyi=zyi+zhi  '하바의 y좌표
          end if 
        End If
        Rs1.Close
        response.write "swhichi_fix:"&swhichi_fix&"<br>"

      SQL=" Update tk_framekSub set whichi_fix=1, hi=20 "
      SQL=SQL&" Where fksidx= "
      SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
      SQL=SQL&" Where fkidx='"&rfkidx&"' "
      SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
      SQL=SQL&" order by yi desc) "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute (SQL)

        '3. alength, blength, door_w, door_h, glass_w, glass_h 계산값 적용
        '픽스유리1  길이 및 계산값등 재설정
        'blength=도어높이-묻힘-하바ysize, zhi=zhi-20
       


        zblength=zoh-zfl-aysize
        door_w=0
        door_h=0
        glass_w=int(zalength+zgwsize3)   '상부남마픽스유리 유리의 가로의 길이
        glass_h=int(zblength+zghsize3)   '상부남마픽스유리 유리의 가로의 길이




        SQL="Update tk_framekSub Set alength='"&zalength&"',blength='"&zblength&"', door_w='"&door_w&"', door_h='"&door_h&"' "
        SQL=SQL&" , glass_w='"&glass_w&"', glass_h='"&glass_h&"', rstatus='1', rstatus2='1' "
        SQL=SQL&" , yi='"&zyi&"', hi='"&zhi&"',whichi_fix='14', groupcode='0' "
        SQL=SQL&" Where fksidx='"&zfksidx&"' "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute Sql


        rwhichi_fix="5"' 하바로 설정

        SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
        SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
        SQL=SQL&" , fstype, glasstype, blength, unitprice, pcent, sprice, xsize, ysize, gls "
        SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
        SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
        SQL=SQL&" , goname, barname, alength, chuga_jajae, rstatus, rstatus2, garo_sero) "
        SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&zxi&"', '"&aba_zyi&"', '"&zwi&"', '20' "
        SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&rwhichi_fix&"', '0', '"&abfidx&"' "
        SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&zalength&"', '0', '1', '0', '"&axsize&"', '"&aysize&"' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '1', '1', '0') "
        Response.write (SQL)&"<br><br>"
       Dbcon.Execute SQL

        elseif whichi_fix="13" then '이전 속성이 양개(수동도어유리2)이었다면
          '3-1:좌우 무엇을 선택하던지 우측 수동도어 유리를 삭제한다.
          SQL=" Select A.fksidx, A.wi, A.alength, A.blength, A.door_w, A.xi "
          SQL=SQL&" From tk_framekSub A "
          SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
          SQL=SQL&" and A.yi = (select B.yi From tk_framekSub B Where B.fksidx='"&rfksidx&"') "
          SQL=SQL&" and A.wi = (select C.wi From tk_framekSub C Where C.fksidx='"&rfksidx&"') "
          SQL=SQL&" order by A.xi asc "
          Response.write (SQL)&"<br>우측유리찾기<br>"
          Rs1.open Sql,Dbcon
          If Not (Rs1.bof or Rs1.eof) Then 
          Do while not Rs1.EOF
            dbfksidx = Rs1(0)
            dbwi = Rs1(1)
            dbalength = Rs1(2)
            dbblength = Rs1(3) 
            dbdoor_w = Rs1(4)
            dbxi =  Rs1(5)
            db=db+1
            if db="1" then '왼쪽 도어창
              l_dbfksidx = dbfksidx
              l_dbwi = dbwi
              l_dbalength = dbalength
              l_dbblength = dbblength
              l_dbdoor_w = dbdoor_w
              l_dbxi = dbxi
            elseif db="2" then '오른족 도어창
              r_dbfksidx = dbfksidx
              r_dbwi = dbwi
              r_dbalength = dbalength
              r_dbblength = dbblength
              r_dbdoor_w = dbdoor_w
              r_dbxi = dbxi
            end if

          Rs1.movenext
          Loop
          End if
          Rs1.close

        '유리 상바의  whichi_fix값 찾아서 박스라인롯트바인 경우와 이외의 경우에 대한 픽스유리 yi, hi 값처리 
      SQL="Select top 1 whichi_fix From tk_framekSub "
      SQL=SQL&" Where fkidx='"&rfkidx&"' "
      SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&l_dbfksidx&"') "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&l_dbfksidx&"') "
      SQL=SQL&" order by yi desc "
      Response.write (SQL)&"<br><br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
          swhichi_fix=Rs1(0)
          if swhichi_fix="22" then 
            zyi=zyi-30
            zhi=zhi+10
            aba_zyi=zyi+zhi  '하바의 y좌표
          else
            zyi=zyi
            zhi=zhi-20
            aba_zyi=zyi+zhi  '하바의 y좌표
          end if 
        End If
        Rs1.Close
        response.write "swhichi_fix:"&swhichi_fix&"<br>"            


      SQL=" Update tk_framekSub set whichi_fix=1, hi=20 "
      SQL=SQL&" Where fksidx= "
      SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
      SQL=SQL&" Where fkidx='"&rfkidx&"' "
      SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&l_dbfksidx&"') "
      SQL=SQL&" and fksidx<>'"&l_dbfksidx&"' "
      SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&l_dbfksidx&"') "
      SQL=SQL&" order by yi desc) "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute (SQL)



          SQL="Delete From tk_framekSub Where fksidx='"&r_dbfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute Sql

          '3-2:좌측 수동도어 유리의 alength, door_w, wi값을 변경한다.
          zalength=l_dbalength*2
          zblength=zoh-zfl-aysize
          door_w=0
          door_h=0
          glass_w=int((l_dbalength+zgwsize3)*2)   '상부남마픽스유리 유리의 가로의 길이
          glass_h=int((l_dbblength+zghsize3)*2)   '상부남마픽스유리 유리의 가로의 길이

          zwi=l_dbwi*2
        
          SQL="Update tk_framekSub Set alength='"&zalength&"',blength='"&zblength&"', door_w='"&door_w&"', door_h='"&door_h&"' "
          SQL=SQL&" , glass_w='"&glass_w&"', glass_h='"&glass_h&"', rstatus='1', rstatus2='1' "
          SQL=SQL&" , yi='"&zyi&"', hi='"&zhi&"', wi='"&zwi&"',whichi_fix='14' , groupcode='0'"
          SQL=SQL&" Where fksidx='"&l_dbfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute Sql

response.write "l_dbxi:"&l_dbxi&"<br><br>"
        '3-1양개의 하바 추가하기
        rwhichi_fix="5"' 하바로 설정
        zwi=zwi
        zalength=int(zalength*2)
        SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
        SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
        SQL=SQL&" , fstype, glasstype, blength, unitprice, pcent, sprice, xsize, ysize, gls "
        SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
        SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
        SQL=SQL&" , goname, barname, alength, chuga_jajae, rstatus, rstatus2, garo_sero) "
        SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&l_dbxi&"', '"&aba_zyi&"', '"&zwi&"', '20' "
        SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&rwhichi_fix&"', '0', '"&abfidx&"' "
        SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&zalength&"', '0', '1', '0', '"&axsize&"', '"&aysize&"' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '1', '1', '0') "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
        end if
'response.end

      End If
    Rs.close


    '============================
    elseif rwhichi_fix="0" then  '혼합공간
    '============================
  


'선택한 픽스유리 정보와 세로바 찾기는 공통 시작
'==================================

      '선택한 유리정보
  
      SQL="Select A.fidx, A.xi, A.yi, A.wi, A.hi, B.tw, B.th, B.ow, B.oh, B.fl, B.ow_m "
      SQL=SQL&" , A.alength, A.blength, C.gwsize1, C.ghsize1 "    
      SQL=SQL&" , A.bfidx, A.glass_w, A.glass_h, A.xsize, A.ysize "    
      SQL=SQL&" From tk_framekSub A "
      SQL=SQL&" Join tk_framek B on A.fkidx = B.fkidx " 
      SQL=SQL&" Join tng_sjbtype C on B.sjb_type_no = C.SJB_TYPE_NO "
      SQL=SQL&" Where fksidx='"&rfksidx&"'"
      Response.write (SQL)&"<br><br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        zfidx=Rs(0)   '원본 fidx
        zxi=Rs(1)     '도형의 x좌표
        zyi=Rs(2)     '도형의 y좌표
        zwi=Rs(3)     '도형의 넓이 픽셀
        zhi=Rs(4)     '도형의 높이 픽셀
        ztw=Rs(5)      '검측가로
        zth=Rs(6)      '검측세로
        zow=Rs(7)      '오픈가로
        zoh=Rs(8)      '도어높이
        zfl=Rs(9)      '묻힘값
        zow_m=Rs(10)
        zalength=Rs(11)
        zblength=Rs(12)
        zgwsize1=Rs(13)
        zghsize1=Rs(14)
        zbfidx=Rs(15)
        zglass_w=Rs(16)
        zglass_h=Rs(17)
        zxsize=Rs(18)
        zysize=Rs(19)
        bokgu_wi=zwi  '유리 초기화를 위한 alength값 임시저장
        bokgu_hi=zhi  '유리 초기화를 위한 blength값 임시저장
        bokgu_alength=zalength       '유리 초기화를 위한 wi값 임시저장
        bokgu_blength=zblength       '유리 초기화를 위한 wi값 임시저장
      End If
      Rs.close

      '가장 좌측 세로바 정보
      SQL=" Select top 1 A.bfidx, D.xsize, D.ysize " 
      SQL=SQL&" From tk_framekSub A "
      SQL=SQL&" Join tk_barasiF D on A.bfidx = D.bfidx "        
      SQL=SQL&" where A.whichi_fix=6 and A.fkidx='"&rfkidx&"' "
      SQL=SQL&" order by xi ASC "

      Response.write (SQL)&"<br><br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        zbfidx=Rs(0) '
        zxsize=Rs(1)
        zysize=Rs(2)
      End If
      Rs.close
'================================== 
'선택한 픽스유리 정보와 세로바 찾기는 공통 끝
    
      if rdoorwhichi="1" then '[롯트바]좌도어+우픽스


      '1-1: 좌측에 있는 세로바와 동일한 whichi_fix와 동일한 속성으로 세로바 추가

        sxi=zxi+zwi/2-10  '세로바 도형의 x좌표
        syi=zyi           '세로바 도형의 y좌표 : 기존유리의 yi와 동일
        swi=20            '세로바 도형의 가로픽셀
        shi=zhi+40        '세로바 도형의 세로픽셀
        swhichi_fix=6     '세로바 whichi_fix값=6
        salength=zoh+zfl
        SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
        SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
        SQL=SQL&" , fstype, glasstype, blength, unitprice, pcent, sprice, xsize, ysize, gls "
        SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
        SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
        SQL=SQL&" , goname, barname, alength, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength) "
        SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&sxi&"', '"&syi&"', '"&swi&"', '"&shi&"' "
        SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&swhichi_fix&"', '0', '"&zbfidx&"' "
        SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&salength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&bokgu_wi&"','"&bokgu_hi&"','"&bokgu_alength&"') "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
      '1-2:좌도어: 기존 픽스 유리를 wi를 wi=(wi-20)/2, alength를=(alength-ysize)/2 로 이고, 세로 길이(blength, glass_h)를 도어 높이 값으로 변경, hi=hi+20으로 변경한다.

        malength=int((zalength-zysize)/2)  '수정되는 수동유리1의 가로길이는= (이전픽스유리가로 길이-추가된 새로바의가로)/2
        mwi=int((zwi-20)/2)                '도형의 가로픽셀 = (기존가로픽셀-세로바가로)/2
        mglass_w=int(malength+zdwsize1)    '줄어든 수동유리1의 계산값 재설정
        
        mblength=zoh
        mhi=zhi+20
        mglass_h=int(zoh+zdhsize1)


        SQL="Update tk_framekSub set alength='"&malength&"', blength='"&mblength&"', wi='"&mwi&"', hi='"&mhi&"' "
        SQL=SQL&" , glass_w='"&mglass_w&"', glass_h='"&mglass_h&"',whichi_fix=12 , groupcode='"&rfksidx&"'"
        SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"
        SQL=SQL&" Where fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
      '1-3: 우측에 유리공간 추가 xi=xi+wi+20 로 설정하고 기존 유리정보에서 복제


        kwi=int((zwi-20)/2)                '도형의 가로픽셀 = (기존가로픽셀-세로바가로)/2 
        kxi=zxi+kwi+20
        kwhichi_fix=14                      '수동픽스유리1
        kalength=int((zalength-zysize)/2)
        kblength=zblength
        kglass_w=int(malength+zgwsize1)    '줄어든 수동유리1의 계산값 재설정
        kglass_h=int(zoh+zghsize1)

          SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
          SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
          SQL=SQL&" , fstype, glasstype, alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
          SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
          SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
          SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength) "
          SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&kxi&"', '"&zyi&"', '"&kwi&"', '"&zhi&"' "
          SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&kwhichi_fix&"', '0', '"&zbfidx&"' "
          SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&kalength&"', '"&kblength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"' "
          SQL=SQL&" , '0', '0', '0', '0', '0', '"&kglass_w&"', '"&kglass_h&"', '0', '0', '0', '0', '0', '0', '0' "
          SQL=SQL&" , '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&bokgu_wi&"','"&bokgu_hi&"','"&bokgu_alength&"') "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute SQL
        '1-4: 하바의 길이를 줄이고 좌표를 오른쪽으로 이동

          SQL=" Update tk_framekSub Set blength='"&kalength&"', xi='"&kxi&"', wi='"&kwi&"', groupcode='"&rfksidx&"' "
          SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"
          SQL=SQL&" Where fksidx= "
          SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi>(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi asc) "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)
        '1-5: 상단 롯트바로 설정
          SQL=" Update tk_framekSub set whichi_fix=4 "
          SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"
          SQL=SQL&" Where fksidx= "
          SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi desc) "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)   

      elseif rdoorwhichi="2" then '[롯트바]좌픽스+우도어

   

      '1-1: 좌측에 있는 세로바와 동일한 whichi_fix와 동일한 속성으로 세로바 추가

        sxi=zxi+zwi/2-10  '세로바 도형의 x좌표
        syi=zyi           '세로바 도형의 y좌표 : 기존유리의 yi와 동일
        swi=20            '세로바 도형의 가로픽셀
        shi=zhi+40        '세로바 도형의 세로픽셀
        swhichi_fix=6     '세로바 whichi_fix값=6
        salength=zoh+zfl
        SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
        SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
        SQL=SQL&" , fstype, glasstype, blength, unitprice, pcent, sprice, xsize, ysize, gls "
        SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
        SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
        SQL=SQL&" , goname, barname, alength, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength) "
        SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&sxi&"', '"&syi&"', '"&swi&"', '"&shi&"' "
        SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&swhichi_fix&"', '0', '"&zbfidx&"' "
        SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&salength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&bokgu_wi&"','"&bokgu_hi&"','"&bokgu_alength&"') "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
      '1-2: 좌픽스 유리 설정
      
      '기존 픽스 유리를 wi를 wi=(wi-20)/2, alength를=(alength-ysize)/2 로 이고, 세로 길이(blength, glass_h)를 도어 높이 값으로 변경, hi=hi+20으로 변경한다.

        malength=int((zalength-zysize)/2)  '수정되는 수동유리1의 가로길이는= (이전픽스유리가로 길이-추가된 새로바의가로)/2
        mwi=int((zwi-20)/2)                '도형의 가로픽셀 = (기존가로픽셀-세로바가로)/2
        mglass_w=int(malength+zgwsize1)    '줄어든 수동유리1의 계산값 재설정
        
        mblength=zoh
        mhi=zhi
        mglass_h=int(zoh+zghsize1)

        mwxi=zxi
     

        SQL="Update tk_framekSub set alength='"&malength&"', blength='"&mblength&"',xi='"&mwxi&"', wi='"&mwi&"', hi='"&mhi&"' "
        SQL=SQL&" , glass_w='"&mglass_w&"', glass_h='"&mglass_h&"',whichi_fix=14 , groupcode='"&rfksidx&"'"
        SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"
        SQL=SQL&" Where fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
      '1-3: 우도어 유리공간 추가 xi=xi+wi+20 로 설정하고 기존 유리정보에서 복제


        kwi=int((zwi-20)/2)                '도형의 가로픽셀 = (기존가로픽셀-세로바가로)/2 
        kxi=zxi+kwi+20
        khi=zhi+20
        kwhichi_fix=12                      '외도어유리
        kalength=int((zalength-zysize)/2)
        kblength=zblength
        kdoor_w=int(malength+zdwsize1)    '줄어든 수동유리1의 계산값 재설정
        kdoor_h=int(zoh+zdhsize1)

          SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
          SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
          SQL=SQL&" , fstype, glasstype, alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
          SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
          SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
          SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength) "
          SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&kxi&"', '"&zyi&"', '"&kwi&"', '"&khi&"' "
          SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&kwhichi_fix&"', '0', '"&zbfidx&"' "
          SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&kalength&"', '"&kblength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"' "
          SQL=SQL&" , '0', '0', '0', '"&kdoor_w&"', '"&kdoor_h&"', '0', '0',  '0', '0', '0', '0', '0', '0', '0' "
          SQL=SQL&" , '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&bokgu_wi&"','"&bokgu_hi&"','"&bokgu_alength&"') "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute SQL
        '1-4: 하바의 길이를 줄이고 좌표를 고정

          SQL=" Update tk_framekSub Set blength='"&kalength&"', wi='"&kwi&"', groupcode='"&rfksidx&"' "
          SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"          
          SQL=SQL&" Where fksidx= "
          SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi>(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi asc) "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)
        '1-5: 상단 롯트바로 설정
          SQL=" Update tk_framekSub set whichi_fix=4 "
          SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"          
          SQL=SQL&" Where fksidx= "
          SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi desc) "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)   

      elseif rdoorwhichi="3" then '[박스라인롯트바]좌도어+우픽스


      '1-1: 좌측에 있는 세로바와 동일한 whichi_fix와 동일한 속성으로 세로바 추가

        sxi=zxi+zwi/2-10  '세로바 도형의 x좌표
        syi=zyi+30           '세로바 도형의 y좌표 : 기존유리의 yi에 박스라인 30픽셀 추가
        swi=20            '세로바 도형의 가로픽셀
        shi=zhi+40-30        '세로바 도형의 세로픽셀-30(박스라인높이)
        swhichi_fix=6     '세로바 whichi_fix값=6
        salength=zoh+zfl
        SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
        SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
        SQL=SQL&" , fstype, glasstype, blength, unitprice, pcent, sprice, xsize, ysize, gls "
        SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
        SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
        SQL=SQL&" , goname, barname, alength, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength) "
        SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&sxi&"', '"&syi&"', '"&swi&"', '"&shi&"' "
        SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&swhichi_fix&"', '0', '"&zbfidx&"' "
        SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&salength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&bokgu_wi&"','"&bokgu_hi&"','"&bokgu_alength&"') "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
      '1-2: 좌도어:기존 픽스 유리를 wi를 wi=(wi-20)/2, alength를=(alength-ysize)/2 로 이고, 세로 길이(blength, glass_h)를 도어 높이 값으로 변경, hi=hi+20으로 변경한다.

        malength=int((zalength-zysize)/2)  '수정되는 수동유리1의 가로길이는= (이전픽스유리가로 길이-추가된 새로바의가로)/2
        mwi=int((zwi-20)/2)                '도형의 가로픽셀 = (기존가로픽셀-세로바가로)/2
        mdoor_w=int(malength+zdwsize1)    '줄어든 수동유리1의 계산값 재설정
        
        mblength=zoh

        mdoor_h=int(zoh+zdhsize1)
        myi=zyi+30  '박스라인롯트바 추가로 30만큼 더 내려간다.
        mhi=zhi+20-30 '30만큼 내려간 만큼 높이를 30 줄인다.(20은 하바만큼의 높이 추가)) 

        SQL="Update tk_framekSub set alength='"&malength&"', blength='"&mblength&"', wi='"&mwi&"' "
        SQL=SQL&" , door_w='"&mdoor_w&"', door_h='"&mdoor_h&"', glass_w='0', glass_h='0',whichi_fix=12 , groupcode='"&rfksidx&"'"
        SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"        
        SQL=SQL&" , yi='"&myi&"', hi='"&mhi&"' "
        SQL=SQL&" Where fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute SQL
      '1-3: 우픽스:우측에 유리공간 추가 xi=xi+wi+20 로 설정하고 기존 유리정보에서 복제


        kwi=int((zwi-20)/2)                '도형의 가로픽셀 = (기존가로픽셀-세로바가로)/2 
        kxi=zxi+kwi+20
        kwhichi_fix=19                      '수동사부유리 픽스3=19로 설정
        kalength=int((zalength-zysize)/2)
        kblength=zblength
        kglass_w=int(malength+zgwsize1)    '줄어든 수동유리1의 계산값 재설정
        kglass_h=int(zoh+zghsize1)
        zyi=zyi+30  '박스라인롯트바 30만큼 좌표를 아래로 이동한다.
        zhi=zhi-30  '높이를 30만큼 줄인다.

          SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
          SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
          SQL=SQL&" , fstype, glasstype, alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
          SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
          SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
          SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength) "
          SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&kxi&"', '"&zyi&"', '"&kwi&"', '"&zhi&"' "
          SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&kwhichi_fix&"', '0', '"&zbfidx&"' "
          SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&kalength&"', '"&kblength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"' "
          SQL=SQL&" , '0', '0', '0', '0', '0', '"&kglass_w&"', '"&kglass_h&"', '0', '0', '0', '0', '0', '0', '0' "
          SQL=SQL&" , '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&bokgu_wi&"','"&bokgu_hi&"','"&bokgu_alength&"') "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute SQL
        '1-4: 하바의 길이를 줄이고 좌표를 오른쪽으로 이동

          SQL=" Update tk_framekSub Set blength='"&kalength&"', xi='"&kxi&"', wi='"&kwi&"', groupcode='"&rfksidx&"' "
          SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"
          SQL=SQL&" Where fksidx= "
          SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi>(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi asc) "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)
        '1-5: 상단 박스라인롯트바로 설정
          SQL=" Update tk_framekSub set whichi_fix=22, hi=50 "
          SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"
          SQL=SQL&" Where fksidx= "
          SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi desc) "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)   

          '1-6:박스라인롯트바 바로 위의 픽스 유리의 성분을 “박스라인 상부남바 픽스 유리 whichi_fix=23으로 모두 변경 
          '박스라인롯트바의 좌표 및 가로 세로 정보 찾기

          SQL=" Select top 1 xi, yi, wi, hi From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi desc "
          Response.write (SQL)&"<br><br>"
          Rs.open SQL,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            bllb_xi=Rs(0) 
            bllb_yi=Rs(1)
            bllb_wi=Rs(2)
            bllb_hi=Rs(3)
            bllb_sxi=bllb_xi+bllb_wi  'x좌표에서 wi값을 더한 값

            '박스라인롯트바 위에 있는 유리자재를 찾는다.
            SQL=" Select fksidx " 
            SQL=SQL&" From tk_framekSub "
            SQL=SQL&" Where fkidx='"&rfkidx&"' "
            SQL=SQL&" and yi+hi='"&bllb_yi&"' "
            SQL=SQL&" and xi>='"&bllb_xi&"' and xi<='"&bllb_sxi&"' "
            SQL=SQL&" and (whichi_fix='12' or whichi_fix='13' or whichi_fix='14' or whichi_fix='15' or whichi_fix='16' or "
            SQL=SQL&" whichi_fix='17' or whichi_fix='18' or whichi_fix='19' or whichi_fix='23') "
            Response.write (SQL)&"<br><br>"
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
            Do while not Rs1.EOF  
              tfksidx=Rs1(0)
              SQL="Update tk_framekSub set whichi_fix=23 where fksidx='"&tfksidx&"' "
              Response.write (SQL)&"<br><br>"
              Dbcon.Execute (SQL)   
            Rs1.movenext
            Loop
            End if
            Rs1.close 


          End If
          Rs.close


      elseif rdoorwhichi="4" then '[박스라인롯트바]좌픽스+우도어

      '1-1: 좌측에 있는 세로바와 동일한 whichi_fix와 동일한 속성으로 세로바 추가

        sxi=zxi+zwi/2-10  '세로바 도형의 x좌표
        syi=zyi+30           '세로바 도형의 y좌표 : 기존유리의 yi에 박스라인 30픽셀 추가
        swi=20            '세로바 도형의 가로픽셀
        shi=zhi+40-30        '세로바 도형의 세로픽셀-30(박스라인높이)
        swhichi_fix=6     '세로바 whichi_fix값=6
        salength=zoh+zfl

        SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
        SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
        SQL=SQL&" , fstype, glasstype, blength, unitprice, pcent, sprice, xsize, ysize, gls "
        SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
        SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
        SQL=SQL&" , goname, barname, alength, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength) "
        SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&sxi&"', '"&syi&"', '"&swi&"', '"&shi&"' "
        SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&swhichi_fix&"', '0', '"&zbfidx&"' "
        SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&salength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' "
        SQL=SQL&" , '0', '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&bokgu_wi&"','"&bokgu_hi&"','"&bokgu_alength&"') "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute (SQL)
      '1-2: 좌픽스 유리 설정
      
      '기존 픽스 유리를 wi를 wi=(wi-20)/2, alength를=(alength-ysize)/2 로 이고, 세로 길이(blength, glass_h)를 도어 높이 값으로 변경, hi=hi+20으로 변경한다.

        malength=int((zalength-zysize)/2)  '수정되는 수동유리1의 가로길이는= (이전픽스유리가로 길이-추가된 새로바의가로)/2
        mwi=int((zwi-20)/2)                '도형의 가로픽셀 = (기존가로픽셀-세로바가로)/2
        mglass_w=int(malength+zgwsize1)    '줄어든 수동유리1의 계산값 재설정
        mwhichi_fix="19"
        mblength=zoh

        mglass_h=int(zoh+zghsize1)

        mwxi=zxi
     
        myi=zyi+30  '박스라인롯트바 30만큼 좌표를 아래로 이동한다.
        mhi=zhi-30  '높이를 30만큼 줄인다.

        SQL="Update tk_framekSub set alength='"&malength&"', blength='"&mblength&"',xi='"&mwxi&"', yi='"&myi&"', wi='"&mwi&"', hi='"&mhi&"' "
        SQL=SQL&" , glass_w='"&mglass_w&"', glass_h='"&mglass_h&"',whichi_fix='"&mwhichi_fix&"' , groupcode='"&rfksidx&"'"
        SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"
        SQL=SQL&" Where fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute (SQL)
      '1-3: 우도어 유리공간 추가 xi=xi+wi+20 로 설정하고 기존 유리정보에서 복제


        kwi=int((zwi-20)/2)                '도형의 가로픽셀 = (기존가로픽셀-세로바가로)/2 
        kxi=zxi+kwi+20
  
        kwhichi_fix="12"                      '외도어유리
        kalength=int((zalength-zysize)/2)
        kblength=zblength
        kdoor_w=int(malength+zdwsize1)    '줄어든 수동유리1의 계산값 재설정
        kdoor_h=int(zoh+zdhsize1)

        kyi=zyi+30  '박스라인롯트바 추가로 30만큼 더 내려간다.
        khi=zhi+20-30 '30만큼 내려간 만큼 높이를 30 줄인다.(20은 하바만큼의 높이 추가)) 

          SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
          SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
          SQL=SQL&" , fstype, glasstype, alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
          SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
          SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
          SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength) "
          SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&kxi&"', '"&kyi&"', '"&kwi&"', '"&khi&"' "
          SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&kwhichi_fix&"', '0', '"&zbfidx&"' "
          SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&kalength&"', '"&kblength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"' "
          SQL=SQL&" , '0', '0', '0', '"&kdoor_w&"', '"&kdoor_h&"', '0', '0',  '0', '0', '0', '0', '0', '0', '0' "
          SQL=SQL&" , '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&bokgu_wi&"','"&bokgu_hi&"','"&bokgu_alength&"') "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)
        '1-4: 하바의 길이를 줄이고 좌표를 고정

          SQL=" Update tk_framekSub Set blength='"&kalength&"', wi='"&kwi&"', groupcode='"&rfksidx&"' "
          SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"
          SQL=SQL&" Where fksidx= "
          SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi>(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi asc) "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)
        '1-5: 상단 박스라인롯트바로 설정
          SQL=" Update tk_framekSub set whichi_fix=22, hi=50 "
          SQL=SQL&" , bokgu_wi='"&bokgu_wi&"', bokgu_hi='"&bokgu_hi&"', bokgu_alength='"&bokgu_alength&"'"
          SQL=SQL&" Where fksidx= "
          SQL=SQL&" (Select top 1 fksidx From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi desc) "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)   


          '1-6:박스라인롯트바 바로 위의 픽스 유리의 성분을 “박스라인 상부남바 픽스 유리 whichi_fix=23으로 모두 변경 
          '박스라인롯트바의 좌표 및 가로 세로 정보 찾기

          SQL=" Select top 1 xi, yi, wi, hi From tk_framekSub "
          SQL=SQL&" Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" and fksidx<>'"&rfksidx&"' "
          SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by yi desc "
          Response.write (SQL)&"<br><br>"
          Rs.open SQL,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            bllb_xi=Rs(0) 
            bllb_yi=Rs(1)
            bllb_wi=Rs(2)
            bllb_hi=Rs(3)
            bllb_sxi=bllb_xi+bllb_wi  'x좌표에서 wi값을 더한 값

            '박스라인롯트바 위에 있는 유리자재를 찾는다.
            SQL=" Select fksidx " 
            SQL=SQL&" From tk_framekSub "
            SQL=SQL&" Where fkidx='"&rfkidx&"' "
            SQL=SQL&" and yi+hi='"&bllb_yi&"' "
            SQL=SQL&" and xi>='"&bllb_xi&"' and xi<='"&bllb_sxi&"' "
            SQL=SQL&" and (whichi_fix='12' or whichi_fix='13' or whichi_fix='14' or whichi_fix='15' or whichi_fix='16' or "
            SQL=SQL&" whichi_fix='17' or whichi_fix='18' or whichi_fix='19' or whichi_fix='23') "
            Response.write (SQL)&"<br><br>"
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
            Do while not Rs1.EOF  
              tfksidx=Rs1(0)
              SQL="Update tk_framekSub set whichi_fix=23 where fksidx='"&tfksidx&"' "
              Response.write (SQL)&"<br><br>"
              Dbcon.Execute (SQL)   
            Rs1.movenext
            Loop
            End if
            Rs1.close 


          End If
          Rs.close

      elseif rdoorwhichi="5" then '혼합공간 초기화


        '1:상바의 길이 정보 가져오기 : whichi_fix를 통해 박스라인이었는지 유무를 알기 위해 반드시 1-1보다  앞에 있어야 합니다.
        SQL=" Select top 1 blength, ysize, whichi_fix, bokgu_wi, bokgu_hi, bokgu_alength "
        SQL=SQL&" From tk_framekSub "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        SQL=SQL&" and xi=(Select xi From tk_framekSub where fksidx='"&rfksidx&"') "
        SQL=SQL&" and fksidx<>'"&rfksidx&"' "
        SQL=SQL&" and yi<(Select yi From tk_framekSub where fksidx='"&rfksidx&"') "
        SQL=SQL&" order by yi desc"
        Response.write (SQL)&"<br><br>"        
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
          tblength=Rs1(0)     '가로길이값
          tysize=Rs1(1)       '상바의 세로사이즈를 하바의 세로 사이즈로 설정한다.
          twhichi_fix=Rs1(2)  '상바의 위치값 22라면 박스라인롯트바로 아래에 중요 참고값
          bokgu_wi=Rs1(3)        '변경전 유리의 alength값
          bokgu_hi=Rs1(4)        '변경전 유리의 blength값
          bokgu_alength=Rs1(5)        '변경전 유리의 wi값
        End If
        Rs1.Close

        '**상바가 박스라인 바로 위의 유리들을 수동상부픽스유리1(whichi_fix=16)로 변경
          SQL=" Select top 1 xi, yi, wi, hi ,blength, ysize, whichi_fix, bokgu_wi, bokgu_hi, bokgu_alength "
          SQL=SQL&" From tk_framekSub "
          SQL=SQL&" Where fksidx=(Select top 1 fksidx From tk_framekSub  Where fkidx='"&rfkidx&"'"
          SQL=SQL&" and xi=(Select min(xi) From tk_framekSub Where groupcode=(Select groupcode from tk_framekSub where fksidx='"&rfksidx&"')) "
          SQL=SQL&" and yi<(Select min(yi) From tk_framekSub Where groupcode=(Select groupcode from tk_framekSub where fksidx='"&rfksidx&"')) "
          SQL=SQL&" order by yi desc)"
          Response.write (SQL)&"<br><br>"
          Rs.open SQL,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            bllb_xi=Rs(0) 
            bllb_yi=Rs(1)
            bllb_wi=Rs(2)
            bllb_hi=Rs(3)
            bllb_sxi=bllb_xi+bllb_wi  'x좌표에서 wi값을 더한 값
            blength=Rs(4)
            ysize=Rs(5)
            whichi_fix=Rs(6)
            bokgu_wi=Rs(7)
            bokgu_hi=Rs(8)
            bokgu_alength=Rs(9)

            '박스라인롯트바 위에 있는 유리자재를 찾는다.
            if whichi_fix="22" then '박스라인 롯트바일 경우에만 유리값초기화
              SQL=" Select fksidx " 
              SQL=SQL&" From tk_framekSub "
              SQL=SQL&" Where fkidx='"&rfkidx&"' "
              SQL=SQL&" and yi+hi='"&bllb_yi&"' "
              SQL=SQL&" and xi>='"&bllb_xi&"' and xi<='"&bllb_sxi&"' "
              SQL=SQL&" and (whichi_fix='12' or whichi_fix='13' or whichi_fix='14' or whichi_fix='15' or whichi_fix='16' or "
              SQL=SQL&" whichi_fix='17' or whichi_fix='18' or whichi_fix='19' or whichi_fix='23') "
              Response.write (SQL)&"<br><br>"
              Rs1.open Sql,Dbcon
              If Not (Rs1.bof or Rs1.eof) Then 
              Do while not Rs1.EOF  
                tfksidx=Rs1(0)
                SQL="Update tk_framekSub set whichi_fix=16 where fksidx='"&tfksidx&"' "
                Response.write (SQL)&"<br><br>"
                Dbcon.Execute (SQL)   
              Rs1.movenext
              Loop
              End if
              Rs1.close 
            End if


          End If
          Rs.close

      '1-1. 상바의 속성을 가로바(whichi_fix=1)로 변경한다.박스라인롯트바일 경우를 고려해 hi=20으로 설정한다.


        SQL=" Update tk_framekSub set whichi_fix=1, hi=20 "
        SQL=SQL&" Where fksidx=(Select top 1 fksidx From tk_framekSub  Where fkidx='"&rfkidx&"'"
        SQL=SQL&" and xi=(Select min(xi) From tk_framekSub Where groupcode=(Select groupcode from tk_framekSub where fksidx='"&rfksidx&"')) "
        SQL=SQL&" and yi<(Select min(yi) From tk_framekSub Where groupcode=(Select groupcode from tk_framekSub where fksidx='"&rfksidx&"')) "
        SQL=SQL&" order by yi desc)"

        Response.write (SQL)&"<br><br>"
        Dbcon.Execute (SQL)


        '2: 수동도어유리와 세로바 삭제, 수동픽스유리와 하바 좌표이동과 가로 늘리기
        SQL=" Select A.fksidx, A.xi, A.yi, A.wi, A.hi, A.alength, A.blength, A.glass_w, A.glass_h, A.whichi_fix  "
        SQL=SQL&" , B.tw, B.th, B.ow, B.oh, B.fl, B.ow_m, C.gwsize1, C.ghsize1, A.groupcode "
        SQL=SQL&" From tk_framekSub A "
        SQL=SQL&" Join tk_framek B on A.fkidx = B.fkidx " 
        SQL=SQL&" Join tng_sjbtype C on B.sjb_type_no = C.SJB_TYPE_NO "        
        SQL=SQL&" Where "
        SQL=SQL&" A.groupcode=(Select AA.groupcode From tk_framekSub AA where AA.fksidx='"&rfksidx&"') "
        SQL=SQL&" order by xi ASC "
        Response.write (SQL)&"<br><br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
        Do while not Rs1.EOF    
          zfksidx=Rs1(0)
          zxi=Rs1(1)
          zyi=Rs1(2)
          zwi=Rs1(3)
          zhi=Rs1(4)
          zalength=Rs1(5)
          zblength=Rs1(6)
          zglass_w=Rs1(7)
          zglass_h=Rs1(8)
          zwhichi_fix=Rs1(9)
          ztw=Rs1(10)
          zth=Rs1(11)
          zow=Rs1(12)
          zoh=Rs1(13)
          zfl=Rs1(14)
          zow_m=Rs1(15)
          zgwsize1=Rs1(16)
          zghsize1=Rs1(17)
          zgroupcode=Rs1(18)

          z=z+1
          if z="1" then 
            min_xi=zxi    '가장 왼쪽 x좌표
          end if

          if  zwhichi_fix="6" or zwhichi_fix="7" or zwhichi_fix="12" or zwhichi_fix="16" then '세로바와 세로통바, 수동도어창, 상부유리픽스1은 삭제
            if zwhichi_fix="16" then '세로통바에 대한 복구이므로 선택한 상부유리픽스 하나는 살려두어야 함
              SQL="Delete From tk_framekSub Where fksidx='"&zfksidx&"' and fksidx<>'"&rfksidx&"' "
              Response.write (SQL)&"<br><br>"
              Dbcon.Execute (SQL)

              '선택한 상부유리픽스1의 복구될 컬럼의 값들 설정
              SQL="Select bokgu_wi, bokgu_hi, bokgu_alength From tk_frameksub where groupcode='"&zgroupcode&"'"
              Response.write (SQL)&"<br><br>"
              Rs2.open Sql,Dbcon
              If Not (Rs2.bof or Rs2.eof) Then 
                bokgu_wi=Rs2(0)  '변경전 alength 값
                bokgu_hi=Rs2(1)  '변경전 blength 값
                bokgu_alength=Rs2(2)  '변경전 wi값
              End If
              Rs2.Close

              'SQL="Select sum(wi), sum(alength) from tk_frameksub where groupcode='"&zgroupcode&"'"
              'Response.write (SQL)&"<br><br>"
              'Rs2.open Sql,Dbcon
              'If Not (Rs2.bof or Rs2.eof) Then 
              '  swi=Rs2(0)
              '  salength=Rs2(1)
              'End If
              'Rs2.Close
              kalength=bokgu_wi
              kblength=bokgu_hi '기존과 동일
              kdoor_w=0
              kdoor_h=0
              kglass_w=bokgu_wi+zgwsize1
              kglass_h=zglass_h '기존과 동일
              kwhichi_fix=zwhichi_fix 'whichi_fix 기존값유지

              SQL="Update tk_framekSub set alength='"&kalength&"', blength='"&kblength&"', door_w='"&kdoor_w&"', door_h='"&kdoor_h&"' "
              SQL=SQL&" , glass_w='"&kglass_w&"', glass_h='"&kglass_h&"' , xi='"&min_xi&"', wi='"&bokgu_alength&"', groupcode=0 "
              SQL=SQL&" , yi='"&zyi&"', hi='"&zhi&"', whichi_fix='"&kwhichi_fix&"' "
              SQL=SQL&" where fksidx='"&zfksidx&"' "
              Response.write (SQL)&"<br><br>"
              Dbcon.Execute (SQL)

            else
              SQL="Delete From tk_framekSub Where fksidx='"&zfksidx&"' "
              Response.write (SQL)&"<br><br>"
              Dbcon.Execute (SQL)
            end if
          elseif zwhichi_fix="5" or  zwhichi_fix="14"  or  zwhichi_fix="19"  then   '하바와 픽스유리
            zwi=zwi*2+20

            if zwhichi_fix="5" then '하바
              kalength=0
              kblength=tblength
              kdoor_w=0
              kdoor_h=0
              kglass_w=0
              kglass_h=0
              kwhichi_fix=5
            elseif zwhichi_fix="14" or zwhichi_fix="19"  then '수동픽스유리 14, 박스라인하부픽스유리 19
              kalength=tblength
              kblength=zoh-ysize
              kdoor_w=0
              kdoor_h=0
              kglass_w=kalength+zgwsize1
              kglass_h=kblength+zghsize1
              if zwhichi_fix="19" then '박스라인롯트바였다면 yi와 hi값 수정
                zyi=zyi-30
                zhi=zhi+30
              else 
                zyi=zyi
                zhi=zhi
              end if
              kwhichi_fix=14
            end if
      
            Response.write "kblength:"&kblength&"<br>"
            Response.write "zghsize1:"&zghsize1&"<br>"
            Response.write "zyi:"&zyi&"<br>"
            Response.write "zhi:"&zhi&"<br>"

            SQL="Update tk_framekSub set alength='"&kalength&"', blength='"&kblength&"', door_w='"&kdoor_w&"', door_h='"&kdoor_h&"' "
            SQL=SQL&" , glass_w='"&kglass_w&"', glass_h='"&kglass_h&"' , xi='"&min_xi&"', wi='"&zwi&"', groupcode=0 "
            SQL=SQL&" , yi='"&zyi&"', hi='"&zhi&"', whichi_fix='"&kwhichi_fix&"' "
            SQL=SQL&" where fksidx='"&zfksidx&"' "
            Response.write (SQL)&"<br><br>"
            Dbcon.Execute (SQL)

          end if
        Rs1.movenext
        Loop
        End if
        Rs1.close 

      elseif rdoorwhichi="6-1" or rdoorwhichi="6-2" or rdoorwhichi="6-3" or rdoorwhichi="6-4" or rdoorwhichi="6-5" or rdoorwhichi="6-6" or rdoorwhichi="6-7" or rdoorwhichi="6-8" or rdoorwhichi="6-9" or rdoorwhichi="6-10" then '위로확장/아래확장/올리기/내리기

        if  rdoorwhichi="6-1" then '위로확장
        '1:세로중간통바 바로 위에 있는 가로바/상부픽스유리를 찾는다.
        '2:가로바/상부픽스유리의 wi를 세로통바의 wi=(wi-세로중간통바의 wi)/2로 업데이트 한다.
        '3:가로바/상부픽스유리의 blength를 blength= (blength-세로중간통바ysize)/2로 업데이트 한다.
        '4:가로바/상부픽스유리를 복제한다. 단 xi=xi+wi+20으로 설정해 세로중간통바 우측에 위치하도록 한다.
        '5:세로중간통바의 hi와 blength를 위 가로바/상부픽스유리의 세로값 만큰 업데이트한다.

        '1:세로중간통바 바로 위에 있는 가로바/상부픽스유리를 찾는다.
          SQL=" Select top 1 fksidx, fkidx, fsidx, fidx, xi, yi, wi, hi, whichi_fix, bfidx, alength, blength "
          SQL=SQL&" , pcent, gls, garo_sero, xsize, ysize, door_w, door_h, glass_w, glass_h "
          SQL=SQL&" , bokgu_wi, bokgu_hi, bokgu_alength, bokgu_blength "
          SQL=SQL&" From tk_framekSub A "
          SQL=SQL&" Where A.fkidx='"&rfkidx&"' and A.yi<(Select B.yi From tk_framekSub B Where B.fksidx='"&rfksidx&"') "
          SQL=SQL&" and xi= "
          SQL=SQL&" (Select C.xi From tk_framekSub C "
          SQL=SQL&" Where C.fkidx='"&rfkidx&"' and C.yi=(Select D.yi From tk_framekSub D Where D.fksidx='"&rfksidx&"') "
          SQL=SQL&" and C.xi<(Select E.xi From tk_framekSub E Where E.fksidx='"&rfksidx&"') "
          SQL=SQL&" ) "
          SQL=SQL&" Order by A.yi desc "
          Response.write (SQL)&"<br><br>"
          Rs.open Sql,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            kfksidx=Rs(0)
            kfkidx=Rs(1)
            kfsidx=Rs(2)
            kfidx=Rs(3)
            kxi=Rs(4)
            kyi=Rs(5)
            kwi=Rs(6)
            khi=Rs(7)
            kwhichi_fix=Rs(8)
            kbfidx=Rs(9)
            kalength=Rs(10)
            kblength=Rs(11)
            kpcent=Rs(12)
            kgls=Rs(13)
            kgaro_sero=Rs(14)
            kxsize=Rs(15)
            kysize=Rs(16)
            kdoor_w=Rs(17)
            kdoor_h=Rs(18)
            kglass_w=Rs(19)
            kglass_h=Rs(20)
            kbokgu_wi=Rs(21)
            kbokgu_hi=Rs(22)
            kbokgu_alength=Rs(23)
            kbokgu_blength=Rs(24)
          End If
          Rs.Close

        '2:가로바/상부픽스유리의 wi를 세로통바의 wi=(wi-세로중간통바의 wi)/2로 업데이트 한다.
        '3:가로바/상부픽스유리의 blength를 blength= (blength-세로중간통바ysize)/2로 업데이트 한다.
          swi=(kwi-zwi)/2
          sblength=int((kblength-zysize)/2)
          Response.write "swi:"&swi&"<br>"
          SQL="UPdate tk_framekSub set wi='"&swi&"', blength='"&sblength&"' Where fksidx='"&kfksidx&"'"
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)  

        '4:가로바/상부픽스유리를 복제한다. 단 xi=xi+wi+20으로 설정해 세로중간통바 우측에 위치하도록 한다.
          sng_xi=kxi+swi+20
          sng_yi=kyi
          sng_wi=swi
          sng_hi=khi
          sng_whichi_fix=kwhichi_fix
          sng_bfidx=kbfidx
          sng_alength=kalength
          sng_blength=sblength
          sng_pcent=kpcent
          sng_xsize=kxsize
          sng_ysize=kysize
          sng_gls=kgls
          sng_garo_sero=kgaro_sero
          sng_door_w=0
          sng_door_h=0
          sng_glass_w=0
          sng_glass_h=0
          sng_bokgu_wi=kbokgu_wi
          sng_bokgu_hi=kbokgu_hi
          sng_bokgu_alength=kbokgu_alength
          sng_bokgu_blength=kbokgu_blength

          SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
          SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
          SQL=SQL&" , fstype, glasstype, alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
          SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
          SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
          SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength, bokgu_blength) "
          SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&sng_xi&"', '"&sng_yi&"', '"&sng_wi&"', '"&sng_hi&"','"&c_midx&"', getdate(), '1' "
          SQL=SQL&" , '"&sng_whichi_fix&"', '0', '"&sng_bfidx&"', '0', '0', '0', '0' "
          SQL=SQL&" , '0', '0', '"&sng_alength&"', '"&sng_blength&"', '0', '"&sng_pcent&"', '1',  '"&sng_xsize&"', '"&sng_ysize&"', '"&sng_gls&"' "
          SQL=SQL&" , '0', '0', '"&sng_door_w&"', '"&sng_door_h&"','"&sng_glass_w&"', '"&sng_glass_h&"',   '0', '0' , '0' "
          SQL=SQL&" , '0', '0', '0', '0', '0', '0'"
          SQL=SQL&" , '0', '0', '0', '1', '1', '"&sng_garo_sero&"', '"&rfksidx&"','"&sng_bokgu_wi&"','"&sng_bokgu_hi&"','"&sng_bokgu_alength&"','"&sng_bokgu_blength&"') "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)  
        '5:세로중간통바의 hi와 blength를 위 가로바/상부픽스유리의 세로값 만큰 업데이트한다.
        '*이동한 세로중간통바(whichi_fix=7)보다 더 위에 가로바등 부속이 없다면 속성을 세로바(whichi_fix=6)로 변경
          skhi=khi+zhi
          Response.write "khi:"&khi&"<br>"
          Response.write "zhi:"&zhi&"<br>"
          Response.write "skhi:"&skhi&"<br>"
          Response.write "rfksidx:"&rfksidx&"<br>"
          SQL="Update tk_framekSub set yi='"&kyi&"', hi='"&skhi&"' Where fksidx='"&rfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)  
        End if
        if  rdoorwhichi="6-2" then '아래확장
        '1:세로중간통바 바로 아래에 있는 가로바/하부픽스유리를 찾는다.
        '2:가로바/하부픽스유리의 wi를 세로통바의 wi=(wi-세로중간통바의 wi)/2로 업데이트 한다.
        '3:가로바/하부픽스유리의 blength를 blength= (blength-세로중간통바ysize)/2로 업데이트 한다.
        '4:가로바/하부픽스유리를 복제한다. 단 xi=xi+wi+20으로 설정해 세로중간통바 우측에 위치하도록 한다.
        '5:세로중간통바의 hi와 blength를 위 가로바/상부픽스유리의 세로값 만큰 업데이트한다.

        '1:세로중간통바 바로 위에 있는 가로바/상부픽스유리를 찾는다.
          SQL=" Select top 1 fksidx, fkidx, fsidx, fidx, xi, yi, wi, hi, whichi_fix, bfidx, alength, blength "
          SQL=SQL&" , pcent, gls, garo_sero, xsize, ysize, door_w, door_h, glass_w, glass_h "
          SQL=SQL&" , bokgu_wi, bokgu_hi, bokgu_alength, bokgu_blength "
          SQL=SQL&" From tk_framekSub A "
          SQL=SQL&" Where A.fkidx='"&rfkidx&"' and A.yi>=(Select B.yi+B.hi From tk_framekSub B Where B.fksidx='"&rfksidx&"') "
          SQL=SQL&" and xi= "
          SQL=SQL&" (Select C.xi From tk_framekSub C "
          SQL=SQL&" Where C.fkidx='"&rfkidx&"' and C.yi=(Select D.yi From tk_framekSub D Where D.fksidx='"&rfksidx&"') "
          SQL=SQL&" and C.xi<(Select E.xi From tk_framekSub E Where E.fksidx='"&rfksidx&"') "
          SQL=SQL&" ) "
          SQL=SQL&" Order by A.yi asc "
          Response.write (SQL)&"<br><br>"
          Rs.open Sql,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            kfksidx=Rs(0)
            kfkidx=Rs(1)
            kfsidx=Rs(2)
            kfidx=Rs(3)
            kxi=Rs(4)
            kyi=Rs(5)
            kwi=Rs(6)
            khi=Rs(7)
            kwhichi_fix=Rs(8)
            kbfidx=Rs(9)
            kalength=Rs(10)
            kblength=Rs(11)
            kpcent=Rs(12)
            kgls=Rs(13)
            kgaro_sero=Rs(14)
            kxsize=Rs(15)
            kysize=Rs(16)
            kdoor_w=Rs(17)
            kdoor_h=Rs(18)
            kglass_w=Rs(19)
            kglass_h=Rs(20)
            kbokgu_wi=Rs(21)
            kbokgu_hi=Rs(22)
            kbokgu_alength=Rs(23)
            kbokgu_blength=Rs(24)
          End If
          Rs.Close
        '2:가로바/하부픽스유리의 wi를 세로통바의 wi=(wi-세로중간통바의 wi)/2로 업데이트 한다.
        '3:가로바/하부픽스유리의 blength를 blength= (blength-세로중간통바ysize)/2로 업데이트 한다.
          swi=(kwi-zwi)/2
          sblength=int((kblength-zysize)/2)
          Response.write "swi:"&swi&"<br>"
          SQL="UPdate tk_framekSub set wi='"&swi&"', blength='"&sblength&"' Where fksidx='"&kfksidx&"'"
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)  

        '4:가로바/하부픽스유리를 복제한다. 단 xi=xi+wi+20으로 설정해 세로중간통바 우측에 위치하도록 한다.
          sng_xi=kxi+swi+20
          sng_yi=kyi
          sng_wi=swi
          sng_hi=khi
          sng_whichi_fix=kwhichi_fix
          sng_bfidx=kbfidx
          sng_alength=kalength
          sng_blength=sblength
          sng_pcent=kpcent
          sng_xsize=kxsize
          sng_ysize=kysize
          sng_gls=kgls
          sng_garo_sero=kgaro_sero
          sng_door_w=0
          sng_door_h=0
          sng_glass_w=0
          sng_glass_h=0
          sng_bokgu_wi=kbokgu_wi
          sng_bokgu_hi=kbokgu_hi
          sng_bokgu_alength=kbokgu_alength
          sng_bokgu_blength=kbokgu_blength

          SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
          SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
          SQL=SQL&" , fstype, glasstype, alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
          SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
          SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
          SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength) "
          SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&sng_xi&"', '"&sng_yi&"', '"&sng_wi&"', '"&sng_hi&"','"&c_midx&"', getdate(), '1' "
          SQL=SQL&" , '"&sng_whichi_fix&"', '0', '"&sng_bfidx&"', '0', '0', '0', '0' "
          SQL=SQL&" , '0', '0', '"&sng_alength&"', '"&sng_blength&"', '0', '"&sng_pcent&"', '1',  '"&sng_xsize&"', '"&sng_ysize&"', '"&sng_gls&"' "
          SQL=SQL&" , '0', '0', '"&sng_door_w&"', '"&sng_door_h&"','"&sng_glass_w&"', '"&sng_glass_h&"',   '0', '0' , '0' "
          SQL=SQL&" , '0', '0', '0', '0', '0', '0'"
          SQL=SQL&" , '0', '0', '0', '1', '1', '"&sng_garo_sero&"', '"&rfksidx&"','"&sng_bokgu_wi&"','"&sng_bokgu_hi&"','"&sng_bokgu_alength&"','"&sng_bokgu_blength&"') "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)  

        '5:세로중간통바의 hi와 blength를 위 가로바/상부픽스유리의 세로값 만큰 업데이트한다.
          skhi=khi+zhi
          Response.write "khi:"&khi&"<br>"
          Response.write "zhi:"&zhi&"<br>"
          Response.write "skhi:"&skhi&"<br>"
          Response.write "rfksidx:"&rfksidx&"<br>"
          SQL="Update tk_framekSub set  hi='"&skhi&"' Where fksidx='"&rfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)  


        end if
        if rdoorwhichi="6-3" then '상단늘리기
          '1:선택한 세로중간통바의 바로 좌측에 있는 부속을 찾는다.'
          '2: 좌측 부속과 xi가 같으면서 바로위 부속을 찾는다. yi값필요, 복제할 컬럼들 불러오기
          '3: 선택한 세로중간통바의 yi값을 바로위 부속과 동일하게 하고 , 바로위 부속의 hi값을 더한다.

          '1: 선택한 부속과 yi좌표가 동일한 부속중 좌측 부속을 찾는다.
          SQL=" Select top 1 fksidx "
          SQL=SQL&" From tk_framekSub Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and yi=(Select yi From tk_framekSub Where fksidx='"&rfksidx&"') "
          SQL=SQL&" and xi<(Select xi From tk_framekSub Where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by xi desc "
          Response.write (SQL)&"<br><br>"
          Rs.open Sql,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            afksidx=Rs(0)
          End If
          Rs.Close
          '2: 좌측 부속과 xi가 같으면서 바로위 부속을 찾는다. yi값필요, 복제할 컬럼들 불러오기
          SQL=" Select top 1 A.fksidx, A.fkidx, A.fsidx, A.fidx, A.xi, A.yi, A.wi, A.hi, A.whichi_fix, A.bfidx, A.alength, A.blength "
          SQL=SQL&" , A.pcent, A.gls, A.garo_sero, A.xsize, A.ysize, A.door_w, A.door_h, A.glass_w, A.glass_h "
          SQL=SQL&" , A.bokgu_wi, A.bokgu_hi, A.bokgu_alength, A.bokgu_blength "
          SQL=SQL&" From tk_framekSub A "
          SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
          SQL=SQL&" and A.xi=(Select B.xi From tk_framekSub B where B.fksidx='"&afksidx&"') "
          SQL=SQL&" and A.yi<(Select C.yi From tk_framekSub C where C.fksidx='"&afksidx&"') "
          SQL=SQL&" order by A.yi desc "
          Response.write (SQL)&"<br><br>"
          Rs.open Sql,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            kfksidx=Rs(0)
            kfkidx=Rs(1)
            kfsidx=Rs(2)
            kfidx=Rs(3)
            kxi=Rs(4)
            kyi=Rs(5)
            kwi=Rs(6)
            khi=Rs(7)
            kwhichi_fix=Rs(8)
            kbfidx=Rs(9)
            kalength=Rs(10)
            kblength=Rs(11)
            kpcent=Rs(12)
            kgls=Rs(13)
            kgaro_sero=Rs(14)
            kxsize=Rs(15)
            kysize=Rs(16)
            kdoor_w=Rs(17)
            kdoor_h=Rs(18)
            kglass_w=Rs(19)
            kglass_h=Rs(20)
            kbokgu_wi=Rs(21)
            kbokgu_hi=Rs(22)
            kbokgu_alength=Rs(23)
            kbokgu_blength=Rs(24)

          End If
          Rs.Close

          '3: 선택한 세로중간통바의 yi값을 바로위 부속과 동일하게 하고 , 바로위 부속의 hi값을 더한다.
          SQL=" Update tk_framekSub set yi='"&kyi&"', hi='"&zhi+khi&"' Where fksidx='"&rfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)
          
        end if
        if rdoorwhichi="6-4" then '하단늘리기
          '1: 선택한 세로중간통바의 바로 좌측에 있는 부속을 찾는다.'
          '2: 좌측 부속과 xi가 같으면서 바로 아래 부속을 찾는다. yi+hi값필요, 복제할 컬럼들 불러오기
          '3: 선택한 세로중간통바의 hi값을 바로아래 부속의 hi만큼 추가한다.

          '1: 선택한 부속과 yi좌표가 동일한 부속중 좌측 부속을 찾는다.
          SQL=" Select top 1 fksidx "
          SQL=SQL&" From tk_framekSub Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and yi=(Select yi+hi From tk_framekSub Where fksidx='"&rfksidx&"') "
          SQL=SQL&" and xi<(Select xi From tk_framekSub Where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by xi desc "
          Response.write (SQL)&"<br><br>"
          Rs.open Sql,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            afksidx=Rs(0)
          End If
          Rs.Close
          '2: 좌측 부속과 xi가 같으면서 바로아래 부속을 찾는다. yi값필요, 복제할 컬럼들 불러오기
          SQL=" Select top 1 A.fksidx, A.fkidx, A.fsidx, A.fidx, A.xi, A.yi, A.wi, A.hi, A.whichi_fix, A.bfidx, A.alength, A.blength "
          SQL=SQL&" , A.pcent, A.gls, A.garo_sero, A.xsize, A.ysize, A.door_w, A.door_h, A.glass_w, A.glass_h "
          SQL=SQL&" , A.bokgu_wi, A.bokgu_hi, A.bokgu_alength, A.bokgu_blength "
          SQL=SQL&" From tk_framekSub A "
          SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
          SQL=SQL&" and A.fksidx='"&afksidx&"'"
          Response.write (SQL)&"<br><br>"
          Rs.open Sql,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            kfksidx=Rs(0)
            kfkidx=Rs(1)
            kfsidx=Rs(2)
            kfidx=Rs(3)
            kxi=Rs(4)
            kyi=Rs(5)
            kwi=Rs(6)
            khi=Rs(7)
            kwhichi_fix=Rs(8)
            kbfidx=Rs(9)
            kalength=Rs(10)
            kblength=Rs(11)
            kpcent=Rs(12)
            kgls=Rs(13)
            kgaro_sero=Rs(14)
            kxsize=Rs(15)
            kysize=Rs(16)
            kdoor_w=Rs(17)
            kdoor_h=Rs(18)
            kglass_w=Rs(19)
            kglass_h=Rs(20)
            kbokgu_wi=Rs(21)
            kbokgu_hi=Rs(22)
            kbokgu_alength=Rs(23)
            kbokgu_blength=Rs(24)

          End If
          Rs.Close

          '3: 선택한 세로중간통바의 hi값을 바로아래 부속의 hi만큼 추가한다.
          SQL=" Update tk_framekSub set  hi='"&zhi+khi&"' Where fksidx='"&rfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)
          
        end if
        if rdoorwhichi="6-5" then '상단줄이기
        '1:선택한 세로중간통바 yi값이 같으면서 좌측에 있는 부속의 hi를 찾는다.
        '2:선택한 세로중간통바의 yi=zyi-khi, hi=zhi-khi로 업데이트 한다.

        '1:선택한 세로중간통바 yi값이 같으면서 좌측에 있는 부속의 hi를 찾는다.
          SQL=" Select top 1 fksidx, hi "
          SQL=SQL&" From tk_framekSub Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and yi=(Select yi From tk_framekSub Where fksidx='"&rfksidx&"') "
          SQL=SQL&" and xi<(Select xi From tk_framekSub Where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by xi desc "
          Response.write (SQL)&"<br><br>"
          Rs.open Sql,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            afksidx=Rs(0)
            khi=Rs(1)
          End If
          Rs.Close

        '2:선택한 세로중간통바의 yi=zyi-khi, hi=zhi-khi로 업데이트 한다.
          SQL=" Update tk_framekSub set yi='"&zyi+khi&"', hi='"&zhi-khi&"' Where fksidx='"&rfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)
        end If
        if rdoorwhichi="6-6" then '하단줄이기
        '1:선택한 세로중간통바 하단의 위치와 (yi+hi) 같은  좌측에 있는 부속의 hi를 찾는다.
        '2:선택한 세로중간통바의 yi=zyi-khi, hi=zhi-khi로 업데이트 한다.

        '1:선택한 세로중간통바 하단의 위치와 (yi+hi) 같은  좌측에 있는 부속의 hi를 찾는다.
          SQL=" Select top 1 fksidx, hi "
          SQL=SQL&" From tk_framekSub Where fkidx='"&rfkidx&"' "
          SQL=SQL&" and (yi+hi)=(Select yi+hi From tk_framekSub Where fksidx='"&rfksidx&"') "
          SQL=SQL&" and xi<(Select xi From tk_framekSub Where fksidx='"&rfksidx&"') "
          SQL=SQL&" order by xi desc "
          Response.write (SQL)&"<br><br>"
          Rs.open Sql,Dbcon
          If Not (Rs.bof or Rs.eof) Then 
            afksidx=Rs(0)
            khi=Rs(1)
          End If
          Rs.Close
        '2:선택한 세로중간통바의 yi=zyi-khi, hi=zhi-khi로 업데이트 한다.
          SQL=" Update tk_framekSub set hi='"&zhi-khi&"' Where fksidx='"&rfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute (SQL)
        end If
        if rdoorwhichi="6-7" then '분리
          '1:선택한 부속의 정보 가져오기
          SQL=" Select fkidx, fidx, fsidx, xi, yi, wi, hi, alength, blength, whichi_fix, bfidx, xsize, ysize, garo_sero, pcent, gls "
          SQL=SQL&" , bokgu_wi, bokgu_hi, bokgu_alength, bokgu_blength "
          SQL=SQL&" From tk_framekSub "
          SQL=SQL&" Where fksidx='"&rfksidx&"'"
          Response.write (SQL)&"<br><br>"
          Rs1.open Sql,Dbcon
          If Not (Rs1.bof or Rs1.eof) Then 
            zfkidx=Rs1(0)
            zfidx=Rs1(1)
            zfsidx=Rs1(2)
            zxi=Rs1(3)
            zyi=Rs1(4)
            zwi=Rs1(5)
            zhi=Rs1(6)
            zalength=Rs1(7)
            zblength=Rs1(8)
            zwhichi_fix=Rs1(9)
            zbfidx=Rs1(10)
            zxsize=Rs1(11)
            zysize=Rs1(12)
            zgaro_sero=Rs1(13)
            zpcent=Rs1(14)
            zgls=Rs1(15)
            zbokgu_wi=Rs1(16)
            zbokgu_hi=Rs1(17)
            zbokgu_alength=Rs1(18)
            zbokgu_blength=Rs1(19)

            '2:선택한 부속의 alength(또는 가로바 계열은 blengrh)를 반으로 나눈다.
            zalength=int(zalength/2)
            zwi=int(zwi/2)
            SQL="Update tk_framekSub set alength='"&zalength&"',blength='"&zblength&"', wi='"&zwi&"'" 
            SQL=SQL&" Where fksidx='"&rfksidx&"' "
            Response.write (SQL)&"<br><br>"
            Dbcon.Execute SQL

            '3:선택한 부속을 복제한다. 단 xi=xi+wi로 설정해 우측에 위치하도록 한다.
            zxi=zxi+zwi
            
            SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
            SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
            SQL=SQL&" , fstype, glasstype,alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
            SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
            SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
            SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, bokgu_wi, bokgu_hi, bokgu_alength, bokgu_blength) "
            SQL=SQL&" Values ('"&zfkidx&"', '"&zfsidx&"', '"&zfidx&"', '"&zxi&"', '"&zyi&"', '"&zwi&"', '"&zhi&"', '"&c_midx&"', getdate(), '1' "
            SQL=SQL&" , '"&zwhichi_fix&"', '0', '"&zbfidx&"', '0', '0', '0', '0' "
            SQL=SQL&" ,  '0', '0', '"&zalength&"', '"&zblength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"', '"&zgls&"'"
            SQL=SQL&" ,  '0', '0', '0', '0', '0', '0', '0', '0', '0' "
            SQL=SQL&" , '0', '0', '0', '0' , '0', '0' "
            SQL=SQL&" , '0', '0',  '0', '1', '1', '0', '"&bokgu_wi&"', '"&bokgu_hi&"', '"&bokgu_alength&"', '"&bokgu_blength&"') "
            Response.write (SQL)&"<br><br>"
            Dbcon.Execute SQL
          End If
          Rs1.Close

        end If
        if rdoorwhichi="6-8" then '통바기준분리
          '1:선택한 부속의 정보 가져오기
          SQL=" Select fkidx, fidx, fsidx, xi, yi, wi, hi, alength, blength, whichi_fix, bfidx, xsize, ysize, garo_sero, pcent, gls "
          SQL=SQL&" , bokgu_wi, bokgu_hi, bokgu_alength, bokgu_blength "
          SQL=SQL&" From tk_framekSub "
          SQL=SQL&" Where fksidx='"&rfksidx&"'"
          Response.write (SQL)&"<br><br>"
          Rs1.open Sql,Dbcon
          If Not (Rs1.bof or Rs1.eof) Then 
            zfkidx=Rs1(0)
            zfidx=Rs1(1)
            zfsidx=Rs1(2)
            zxi=Rs1(3)
            zyi=Rs1(4)
            zwi=Rs1(5)
            zhi=Rs1(6)
            zalength=Rs1(7)
            zblength=Rs1(8)
            zwhichi_fix=Rs1(9)
            zbfidx=Rs1(10)
            zxsize=Rs1(11)
            zysize=Rs1(12)
            zgaro_sero=Rs1(13)
            zpcent=Rs1(14)
            zgls=Rs1(15)
            zbokgu_wi=Rs1(16)
            zbokgu_hi=Rs1(17)
            zbokgu_alength=Rs1(18)
            zbokgu_blength=Rs1(19)
            '2:프레임에서 세로통바 또는 세로바 찾기(세로통바 먼저 찾고 없으면 세로바 찾아서 yzise값 알아낸다)
            SQL=" select xsize, ysize from tk_barasiF A "
            SQL=SQL&" Where A.bfidx=(Select top 1 bfidx from tk_framekSub where fkidx='"&rfkidx&"' and  whichi_fix=7) "
            Response.write (SQL)&"<br><br>"
            Rs2.open Sql,Dbcon
            If Not (Rs2.bof or Rs2.eof) Then 
              kxsize=Rs2(0) '세로중간통바의 xsize
              kysize=Rs2(1) '세로중간통바의 ysize
            Else
              SQL=" select xsize, ysize from tk_barasiF A "
              SQL=SQL&" Where A.bfidx=(Select top 1 bfidx from tk_framekSub where fkidx='"&rfkidx&"' and  whichi_fix=6) "
              Response.write (SQL)&"<br><br>"
              Rs3.open Sql,Dbcon
              If Not (Rs3.bof or Rs3.eof) Then 
                kxsize=Rs2(0) '세로바의 xsize
                kysize=Rs2(1) '세로바의 ysize
              End If
              Rs3.Close
            End If
            Rs2.Close


            '3:선택한 부속의 alength(또는 가로바 계열은 blength)를 반으로 나눈다.
            select case whichi_fix 
              case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,  11, 20, 21, 22, 24, 25
                zalength=0
                zblength=int((zblength-kysize)/2)
              case else
                zalength=int((zalength-kysize)/2)
                zblength=zblength
            end select 

            zwi=int((zwi-20)/2)
            SQL="Update tk_framekSub set alength='"&zalength&"',blength='"&zblength&"', wi='"&zwi&"'" 
            SQL=SQL&" Where fksidx='"&rfksidx&"' "
            Response.write (SQL)&"<br><br>"
            Dbcon.Execute SQL

            '4:선택한 부속을 복제한다. 단 xi=xi+wi로 설정해 우측에 위치하도록 한다.
            zxi=zxi+zwi+20
            
            SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
            SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
            SQL=SQL&" , fstype, glasstype,alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
            SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
            SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
            SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, bokgu_wi, bokgu_hi, bokgu_alength, bokgu_blength) "
            SQL=SQL&" Values ('"&zfkidx&"', '"&zfsidx&"', '"&zfidx&"', '"&zxi&"', '"&zyi&"', '"&zwi&"', '"&zhi&"', '"&c_midx&"', getdate(), '1' "
            SQL=SQL&" , '"&zwhichi_fix&"', '0', '"&zbfidx&"', '0', '0', '0', '0' "
            SQL=SQL&" ,  '0', '0', '"&zalength&"', '"&zblength&"', '0', '1', '0', '"&zxsize&"', '"&zysize&"', '"&zgls&"'"
            SQL=SQL&" ,  '0', '0', '0', '0', '0', '0', '0', '0', '0' "
            SQL=SQL&" , '0', '0', '0', '0' , '0', '0' "
            SQL=SQL&" , '0', '0',  '0', '1', '1', '0', '"&bokgu_wi&"', '"&bokgu_hi&"', '"&bokgu_alength&"', '"&bokgu_blength&"') "
            Response.write (SQL)&"<br><br>"
            Dbcon.Execute SQL
          End If
          Rs1.Close

        end If
        if rdoorwhichi="6-9" then '우측합체
        '1:동일한 yi, wi값을 가지면서 우측첫번째 있는 부속을 찾는다.
        '2:우측 부속을 삭제한다.
          SQL=" Delete From tk_framekSub where fksidx="
          SQL=SQL&" ("
          SQL=SQL&" Select top 1 fksidx From tk_framekSub"
          SQL=SQL&" Where fkidx='"&rfkidx&"' and fksidx<>'"&rfksidx&"'"
          SQL=SQL&" and xi>(select xi from tk_framekSub where fksidx='"&rfksidx&"')"
          SQL=SQL&" and yi=(select yi from tk_framekSub where fksidx='"&rfksidx&"')"
          SQL=SQL&" and wi=(select wi from tk_framekSub where fksidx='"&rfksidx&"')"
          SQL=SQL&" order by xi asc"
          SQL=SQL&" )"
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute SQL
        '3:선택한 부속의 alength(또는 가로바 계열은 blengrh)를 복구한다.
        '3-1:bokgu_alength, bokgu_blength, bokgu_wi, bokgu_hi 사용
          SQL=" Select bokgu_alength, bokgu_blength, bokgu_wi, bokgu_hi From tk_framekSub where fksidx='"&rfksidx&"'"
          Response.write (SQL)&"<br><br>"
          Rs1.open Sql,Dbcon
          If Not (Rs1.bof or Rs1.eof) Then 
            bokgu_alength=Rs1(0)
            bokgu_blength=Rs1(1)
            bokgu_wi=Rs1(2)
            bokgu_hi=Rs1(3)
          End If
          Rs1.Close
          Response.write "bokgu_alength:"&bokgu_alength&"<br>"
          Response.write "bokgu_blength:"&bokgu_blength&"<br>"
          Response.write "bokgu_wi:"&bokgu_wi&"<br>"
          Response.write "bokgu_hi:"&bokgu_hi&"<br>"
          SQL=" Update tk_framekSub set wi='"&bokgu_wi&"', hi='"&bokgu_hi&"', alength='"&bokgu_alength&"',blength='"&bokgu_blength&"' "
          SQL=SQL&" where fksidx='"&rfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute SQL
        end If
        if rdoorwhichi="6-10" then '좌측합체
        '1:동일한 yi, wi값을 가지면서 좌측 첫번째 있는 부속을 찾는다.
          'SQL=" Select top 1 xi From tk_framekSub"
          'SQL=SQL&" Where fkidx='"&rfkidx&"' and fksidx<>'"&rfksidx&"'"
          'SQL=SQL&" and xi<(select xi from tk_framekSub where fksidx='"&rfksidx&"')"
          'SQL=SQL&" and yi=(select yi from tk_framekSub where fksidx='"&rfksidx&"')"
          'SQL=SQL&" and wi=(select wi from tk_framekSub where fksidx='"&rfksidx&"')"
          'SQL=SQL&" order by xi asc"
          'Response.write (SQL)&"<br><br>"
          'Rs1.open Sql,Dbcon
          'If Not (Rs1.bof or Rs1.eof) Then 
          '  kxi=Rs1(0)  '좌측 부속의 xi값'
          'End If
          'Rs1.Close
        '2:우측 부속을 삭제한다.
          SQL=" Delete From tk_framekSub where fksidx="
          SQL=SQL&" ("
          SQL=SQL&" Select top 1 fksidx From tk_framekSub"
          SQL=SQL&" Where fkidx='"&rfkidx&"' and fksidx<>'"&rfksidx&"'"
          SQL=SQL&" and xi<(select xi from tk_framekSub where fksidx='"&rfksidx&"')"
          SQL=SQL&" and yi=(select yi from tk_framekSub where fksidx='"&rfksidx&"')"
          SQL=SQL&" and wi=(select wi from tk_framekSub where fksidx='"&rfksidx&"')"
          SQL=SQL&" order by xi asc"
          SQL=SQL&" )"
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute SQL
        '3:선택한 부속의 alength(또는 가로바 계열은 blengrh)를 복구한다.
        '3-1:bokgu_alength, bokgu_blength, bokgu_wi, bokgu_hi 사용
          SQL=" Select bokgu_alength, bokgu_blength, bokgu_wi, bokgu_hi, wi, xi From tk_framekSub where fksidx='"&rfksidx&"'"
          Response.write (SQL)&"<br><br>"
          Rs1.open Sql,Dbcon
          If Not (Rs1.bof or Rs1.eof) Then 
            bokgu_alength=Rs1(0)
            bokgu_blength=Rs1(1)
            bokgu_wi=Rs1(2)
            bokgu_hi=Rs1(3)
            kwi=Rs1(4)
            kxi=Rs1(5)

            divsize=bokgu_wi/kwi
            if divsize=2 then '나누었을 때 절반이라면
              kxi=kxi-kwi
            else
              kxi=kxi-kwi-20
            end if
          End If
          Rs1.Close
          Response.write "kwi:"&kwi&"<br>"
          Response.write "divsize:"&divsize&"<br>"
          Response.write "bokgu_alength:"&bokgu_alength&"<br>"
          Response.write "bokgu_blength:"&bokgu_blength&"<br>"
          Response.write "bokgu_wi:"&bokgu_wi&"<br>"
          Response.write "bokgu_hi:"&bokgu_hi&"<br>"
          Response.write "kxi:"&kxi&"<br>"

          SQL=" Update tk_framekSub set xi='"&kxi&"', wi='"&bokgu_wi&"', hi='"&bokgu_hi&"', alength='"&bokgu_alength&"',blength='"&bokgu_blength&"' "
          SQL=SQL&" where fksidx='"&rfksidx&"' "
          Response.write (SQL)&"<br><br>"
          Dbcon.Execute SQL
        end If

      elseif rdoorwhichi="7-1" or rdoorwhichi="7-2" or rdoorwhichi="7-3" or rdoorwhichi="7-4" or rdoorwhichi="7-5" or rdoorwhichi="7-6" or rdoorwhichi="7-7" or rdoorwhichi="7-8" or rdoorwhichi="7-9" or rdoorwhichi="7-10" or rdoorwhichi="7-11" or rdoorwhichi="7-12"  then '상부남마세로중간통바 
Response.write "zalength:"&zalength&"<br>"
Response.write "zwi:"&zwi&"<br>"

splrwcnt=split(rdoorwhichi,"-")

divnum=splrwcnt(1)+1      '나눠질 유리의 수
tongbarnum=splrwcnt(1)  '상부남마세로중간통바의 수

one_glass_wi=int((zwi-(20*tongbarnum))/divnum) '유리하나의 wi값=((상부남마유리의 wi-상부남마세로중간통바의 가로 wi)/유리의 수)
Response.write "one_glass_wi:"&one_glass_wi&"<br>"
Response.write "zwi:"&zwi&"<br>"
Response.write "zxi:"&zxi&"<br>"
Response.write "zyi:"&zyi&"<br>"
Response.write "zalength:"&zalength&"<br>"
Response.write "whichi_fix:"&whichi_fix&"<br>"
sng_fidx=zfidx
sng_xi=zxi      '상부남마유리 xi초기값 설정
sng_yi=zyi
sng_wi=one_glass_wi
sng_hi=zhi
sng_bfidx=zbfidx

sng_alength=int(((zalength-(zysize*tongbarnum))/divnum))  '유리하나의 alength 값
sng_blength=zblength                                    'blength값은 기존 유리의 세로 길이와 동일하다.
sng_xsize=zxsize             
sng_ysize=zysize
sng_glass_w=sng_alength+zgwsize3
sng_glass_h=sng_blength+zghsize3

sng_whichi_fix=whichi_fix

tong_whichi_fix="7" '상부남마세로중간통바의 whichi_fix
'상부남마세로통바의 bfidx, xsize, ysize tk_barasiF에서 가져오기
SQL="Select bfidx, xsize, ysize From tk_barasiF where whichi_fix='"&tong_whichi_fix&"' "
Response.write (SQL)&"<br><br>"
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
  tong_bfidx=Rs1(0)
  tong_xsize=Rs1(1)
  tong_ysize=Rs1(2)
  Response.write "tong_bfidx:"&tong_bfidx&"<br>"
  Response.write "tong_xsize:"&tong_xsize&"<br>"
  Response.write "tong_ysize:"&tong_ysize&"<br>"
End If
Rs1.Close


For sng= 1 to divnum
  sng_xi=sng_xi+one_glass_xi
  Response.write "sng_xi:"&sng_xi&"<br><br>"

  one_glass_xi=one_glass_wi+20
  '상부남마유리 배치
  SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
  SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
  SQL=SQL&" , fstype, glasstype, alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
  SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
  SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
  SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength, bokgu_blength) "
  SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&sng_xi&"', '"&sng_yi&"', '"&sng_wi&"', '"&sng_hi&"' "
  SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&sng_whichi_fix&"', '0', '"&sng_bfidx&"' "
  SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&sng_alength&"', '"&sng_blength&"', '0', '1', '0', '"&sng_xsize&"', '"&sng_ysize&"' "
  SQL=SQL&" , '0', '0', '0', '0', '0','"&sng_glass_w&"', '"&sng_glass_h&"',   '0', '0', '0', '0', '0', '0', '0' "
  SQL=SQL&" , '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&bokgu_wi&"','"&bokgu_hi&"','"&bokgu_alength&"','"&bokgu_blength&"') "
  Response.write (SQL)&"<br><br>"
  Dbcon.Execute (SQL)  

  '상부남마세로중간통바 배치
  
  if int(sng)<=int(tongbarnum) then
    tong_xi=sng_xi+sng_wi
    tong_yi=sng_yi
    tong_wi="20"
    tong_hi=sng_hi
    tong_alength=tong_ysize
    tong_blength=zblength
    tong_xsize=tong_xsize
    tong_ysize=tong_ysize
    tong_glass_w=0
    tong_glass_h=0
    tong_bokgu_wi=tong_wi
    tong_bokgu_hi=tong_hi
    tong_bokgu_alength=tong_alength
    tong_bokgu_blength=tong_blength
    Response.write "sng_xi:"&sng_xi&"<br>"
    Response.write "sng_wi:"&sng_wi&"<br>"        
    Response.write "tong_xi:"&tong_xi&"<br>"

    SQL="Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi "
    SQL=SQL&" , whichi_fix, whichi_auto, bfidx, bwsize, bhsize, gwsize, ghsize "
    SQL=SQL&" , fstype, glasstype, alength, blength, unitprice, pcent, sprice, xsize, ysize, gls "
    SQL=SQL&" , OPT, FL, door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
    SQL=SQL&" , fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price, door_price "
    SQL=SQL&" , goname, barname, chuga_jajae, rstatus, rstatus2, garo_sero, groupcode, bokgu_wi, bokgu_hi, bokgu_alength, bokgu_blength) "
    SQL=SQL&" Values ('"&rfkidx&"', '0', '"&zfidx&"', '"&tong_xi&"', '"&tong_yi&"', '"&tong_wi&"', '"&tong_hi&"' "
    SQL=SQL&" , '"&c_midx&"', getdate(), '1', '"&tong_whichi_fix&"', '0', '"&tong_bfidx&"' "
    SQL=SQL&" , '0', '0', '0', '0',  '0', '0', '"&tong_alength&"', '"&tong_blength&"', '0', '1', '0', '"&tong_xsize&"', '"&tong_ysize&"' "
    SQL=SQL&" , '0', '0', '0', '0', '0','"&tong_glass_w&"', '"&tong_glass_h&"',   '0', '0', '0', '0', '0', '0', '0' "
    SQL=SQL&" , '0', '0', '0', '0', '0', '1', '1', '0', '"&rfksidx&"','"&tong_bokgu_wi&"','"&tong_bokgu_hi&"','"&tong_bokgu_alength&"','"&tong_bokgu_blength&"') "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute (SQL) 
  end if

Next

'기존 상부남마유리를 삭제
  SQL="Delete From tk_framekSub Where fksidx='"&rfksidx&"' "
  Response.write (SQL)&"<br><br>"
  Dbcon.Execute (SQL)    



      end if
    '============================
    end if 

  end if
    '새로 생성된 통바를 찾아서 fksidx를 보낸다.
    SQL="Select max(fksidx) From tk_framekSub "
    response.write (SQL)&"<br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      zfksidx=Rs(0)
    End if
    Rs.Close
  Response.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');location.replace('inspector_v4.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&zfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"
elseif gubun="del" then 
  SQL="Delete From tk_framekSub Where fksidx='"&rfksidx&"' "
  Response.write (SQL)&"<br><br>"
  Dbcon.Execute (SQL)  
  Response.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');location.replace('inspector_v4.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');</script>"

elseif gubun="framedel" then 
  SQL="Delete From tk_framekSub Where fkidx='"&rfkidx&"' "
  Response.write (SQL)&"<br><br>"
  Dbcon.Execute (SQL)  
  SQL="Delete From tk_framek Where fkidx='"&rfkidx&"' "
  Response.write (SQL)&"<br><br>"
  Dbcon.Execute (SQL)  
  Response.write "<script>window.opener.location.replace('TNG1_B_suju_temp2.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');window.close();</script>"
  
End If
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>