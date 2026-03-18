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
  projectname="입면도면서브"


  rsjidx=request("sjidx") '수주키 TB TNG_SJA
  rsjb_idx=request("sjb_idx") '수주 제품키 TB TNG_SJB
  rsjb_type_no=Request("sjb_type_no") '제품타입
  rsjbsub_Idx=Request("sjbsub_Idx")

  rfkidx=Request("fkidx")
  rfksidx=Request("fksidx")

  'rfidx=Request("fidx")
  rfidx="2" '기본_외도어 상부남마 중간소대롤 고정
  
  rgreem_f_a=Request("greem_f_a")
  rGREEM_BASIC_TYPE=Request("GREEM_BASIC_TYPE")
  rgreem_o_type=Request("greem_o_type")
  rGREEM_FIX_TYPE=Request("GREEM_FIX_TYPE")
  rgreem_habar_type=Request("greem_habar_type")
  rgreem_lb_type=Request("greem_lb_type")
  rGREEM_MBAR_TYPE=Request("GREEM_MBAR_TYPE")


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

SearchWord=Request("SearchWord")
gubun=Request("gubun")
 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="tng1_greemlist3.asp?listgubun="&listgubun&"&"

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




SQL=" Select sjb_type_name, SJB_barlist "
SQL=SQL&" From TNG_SJB "
SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
  sjb_type_name=Rs(0)
  sjb_barlist=Rs(1)
End If
Rs.Close

'부속이 적용된 신규 입면도면 구성을 위한 코드 시작
'=======================================
if Request("part")="pummoksub" then 
'response.write rsjb_idx&"<br>"
'response.write rfidx&"<br>"

'tk_framek 만들기 시작
  SQL="Select fname, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, fstatus "
  SQL=SQL&" From tk_frame "
  SQL=SQL&" Where fidx='"&rfidx&"' "
  'Response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon,1,1,1
  if not (Rs.EOF or Rs.BOF ) then
    fname=Rs(0)
    GREEM_F_A=Rs(1)
    GREEM_BASIC_TYPE=Rs(2)
    GREEM_FIX_TYPE=Rs(3)
    GREEM_HABAR_TYPE=Rs(4)
    GREEM_LB_TYPE=Rs(5)
    GREEM_O_TYPE=Rs(6)
    GREEM_FIX_name=Rs(7)
    GREEM_MBAR_TYPE=Rs(8)
    fstatus=Rs(9)

    'fkidx값 찾기
    SQL="Select max(fkidx) from tk_frameK"
    Rs1.open Sql,Dbcon,1,1,1
    if not (Rs1.EOF or Rs1.BOF ) then
      fkidx=Rs1(0)+1
      if isnull(fkidx) then 
        fkidx=1
      end if 
    end if
    Rs1.Close

    fknickname=Request("fknickname")
    SQL=" Insert into tk_framek (fkidx, fknickname, fidx, sjb_idx, fname, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE "
    SQL=SQL&" , GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, fmidx, fwdate, fmeidx, fewdate,  fstatus, sjidx, sjb_type_no) "
    SQL=SQL&" Values ('"&fkidx&"', '"&fknickname&"', '"&rfidx&"', '"&rsjb_idx&"', '"&fname&"', '"&GREEM_F_A&"', '"&GREEM_BASIC_TYPE&"' "
    SQL=SQL&" , '"&GREEM_FIX_TYPE&"', '"&GREEM_HABAR_TYPE&"', '"&GREEM_LB_TYPE&"', '"&GREEM_O_TYPE&"', '"&GREEM_FIX_name&"', '"&GREEM_MBAR_TYPE&"' "
    SQL=SQL&" , '"&C_midx&"', getdate(), '"&C_midx&"', getdate(), '1', '"&rsjidx&"', '"&rsjb_type_no&"') "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute (SQL)


    'tk_frameksub 입력 시작
    SQL=" Select fsidx, fidx, xi, yi, wi, hi, imsi, whichi_fix, whichi_auto from tk_frameSub Where fidx='"&rfidx&"' "
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

'부속 기본값 자동으로 넣기 위한 코드 시작
        SQL=" Select bfidx "
        SQL=SQL&" From tk_barasiF "
        SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
        if greem_f_a="1" then
        SQL=SQL&" and whichi_auto='"&WHICHI_AUTO&"' "
        Elseif  greem_f_a="2" then
        SQL=SQL&" and whichi_fix='"&WHICHI_FIX&"' "
        End if 
        Rs2.open Sql,Dbcon
        If Not (Rs2.bof or Rs2.eof) Then 
            bfidx=Rs2(0)
        End If
        Rs2.Close
'부속 기본값 자동으로 넣기 위한 코드 끝




      SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx) "
      SQL=SQL&" Values ('"&fkidx&"', '"&fsidx&"', '"&fidx&"', '"&xi&"', '"&yi&"', '"&wi&"', '"&hi&"', '"&C_midx&"' "
      SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"') "
      'Response.write (SQL)&"<br>"
      Dbcon.Execute (SQL)

    Rs1.movenext
    Loop
    End if
    Rs1.close
    'tk_frameksub 입력 끝
  End If
  Rs.Close

'tk_framk 만들기 끝  
'Response.end
response.write "<script>alert('입면도면이 추가 되었습니다.');location.replace('tng1b_suju.asp?sjidx="&rsjidx&"&sjb_type_no="&rsjb_type_no&"&sjb_idx="&rsjb_idx&"&fkidx="&fkidx&"');</script>"
End If
'=======================================
'부속이 적용된 신규 입면도면 구성을 위한 코드 끝

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
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>프레임수주</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" sizes="image/x-icon" href="/inc/tkico.png">
  <!-- Bootstrap CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    html, body {
      height: 100%;
      margin: 0;
    }
    .full-height {
      height: 98vh;
    }
    .row-1 {
      height: 50px;
      background-color: #f0f0f0;
    }
    .row-2 {
      flex: 1;
      display: flex;
      background-color: white;
    }
    .row-3 {
      height: 200px;
      background-color: white;
      border-top: 1px solid #ccc;
    }
    .col-fixed {
      width: 300px;
    }
    .col-flex {
      flex: 1;
    }
  </style>
<!-- 두번째 줄 첫번째 칸 메뉴 시작 -->
  <style>

    .menu-container {
      width: auto;
      margin: 2px auto;
      border: 1px solid #ccc;
      border-radius: 4px;
      overflow: hidden;
      background-color: #fff;
    }

    .dropdown-header {
      font-size: 15px;
      padding: 12px;
      background-color: #f1f1f1;
      border-bottom: 1px solid #ccc;
      cursor: pointer;
      //font-weight: bold;
    }

    .dropdown-header:hover {
      background-color: #e1e1e1;
    }

    .dropdown-content {
      display: none;
      padding: 12px;
      background-color: #fff;
      border-top: 1px solid #ccc;
    }

    .input-group {
      margin-bottom: 10px;
    }

    label {
      display: block;
      margin-bottom: 4px;
      background-color: #fff;
    }

    input {
      width: 100%;
      padding: 6px;
      background-color: #fff;
      border: 1px solid #ccc;
      box-sizing: border-box;
    }
  </style>
<!-- 두번째 줄 첫번째 칸 메뉴 끝 -->
<!-- 두번째 줄 세번째 칸 버튼에 관한 스타일시트 시작-->
  <style>
    .button-grid {
      display: grid;
      grid-template-columns: 1fr 1fr; /* 두 개의 버튼 */
      gap: 2px; /* 버튼 사이 1px */
      background-color: #ccc; /* 여백 영역을 회색으로 */
      padding: 1px; /* 바깥쪽 여백 */
      max-width: 600px;
      margin: 10px auto;
    }

    .button-grid .btn {
      height: 50px;
      background-color: #f1f1f1;
      border: none;
      border-radius: 0;
      margin: 0;
      color: #333;
      //font-weight: bold;
      width: 100%;
    }

    .button-grid .btn:hover {
      background-color: #e4e4e4;
    }
  </style>
<!-- 두번째 줄 세번째 칸 버튼에 관한 스타일시트 끝-->
<!-- 세번째 줄 시작 -->
  <style>
    .card-container {
      display: flex;
      gap: 2px; /* 카드 간 좌우 여백 */
      padding: 0px; /* 상하 좌우 여백 */
      justify-content: center;
      background-color: #fff;
    }

    .custom-card {
      width: 280px;
      height: 180px;
      margin: 2px; /* 개별 카드 여백 (예외적 여유 포함 시) */
      display: flex;
      flex-direction: column;
    }

    .custom-card .card-header {
      padding: 0.5rem;
      font-size: 14px;
      background-color: #f8f9fa;
      text-align: center;
    }

    .custom-card .card-body {
      flex: 1;
      padding: 10px;
      text-align: center;
    }
  </style>
    <style>
    .fixed-box {
      width: 300px;          /* 가로 크기 고정 */
      height: 190px;         /* 세로 크기도 고정하고 싶으면 */
      box-sizing: border-box; /* padding, border 포함 */
      //border: 1px solid #ccc; 
      padding: 10px;
      background-color: #fff;
    }
    .scroll-container {
      white-space: nowrap;    
  </style>
<!-- 세ㄴ째 줄 끝 -->
  <script>
    function pummoksub(sjb_idx) {
      const message = prompt("이 입면 도면을 기본으로 부속이 적용된 신규 부족적용 입면 도면 생성합니다. 입면도면의 이름을 입력하세요.");
      if (message !== null && message.trim() !== "") {
        const encodedMessage = encodeURIComponent(message.trim());
        window.location.href = "tng1b_suju.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjb_type_no=<%=rsjb_type_no%>&sjb_idx="+sjb_idx+"&fknickname="+encodedMessage;
      }
    }
  </script>
</head>
<body>
  <div class="container-fluid full-height d-flex flex-column p-0">
    <!-- 첫 번째 줄 -->
    <div class="row-1 d-flex align-items-center">
    <!-- 첫 번째 줄 내용 시작 -->
      <div class="row px-3">
        <div class="input-group mb-0">
          <span for="bendName" class="input-group-text">수주번호</span>         
          <input type="text" class="form-control" value="<%=sjdate%>_<%=sjnum%>">
          <span for="bendName" class="input-group-text">거래처</span>         
          <input type="text" class="form-control" value="<%=cname%>">
          <span for="bendName" class="input-group-text">담당자</span>         
          <input type="text" class="form-control" value="<%=mname%>">
          <span for="bendName" class="input-group-text">전화</span>         
          <input type="text" class="form-control" value="<%=mtel%>">
          <span for="bendName" class="input-group-text">휴대폰</span>         
          <input type="text" class="form-control" value="<%=mhp%>">
          <span for="bendName" class="input-group-text">팩스</span>         
          <input type="text" class="form-control" value="<%=mfax%>">
          <span for="bendName" class="input-group-text">이메일</span>         
          <input type="text" class="form-control" value="<%=memail%>">

        </div>
 
      </div>
    <!-- 첫 번째 줄 내용 끝 -->
    </div>

    <!-- 두 번째 줄 -->
    <div class="row-2">
      <div class="col-fixed border-end px-2 mt-2">
      <!-- 두번째 줄 첫 번째 칸 시작 -->
      <!-- 드롭다운 버튼 시작-->
        <div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
            품목선택하기
          </button>
          <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
<% 
SQL = " SELECT A.sjb_idx, B.sjb_type_name, A.SJB_barlist, A.sjb_type_no "
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

%>
            <li><a class="dropdown-item" onclick="pummoksub('<%=sjb_idx%>');"><%=sjb_type_name%>&nbsp;<%=SJB_barlist%></a></li>
<%
    Rs.movenext
    Loop
    End if
    Rs.close
%>    
          </ul>
        </div>
      <!-- 드롭다운 버튼 끝-->
      <!-- 생성된 도면 정보 시작 -->
        <div class="row mt-2">
<%
SQL = " Select fkidx, fknickname, fname, fstatus, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE "
SQL = SQL & " ,GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE "
SQL = SQL & " From tk_framek "
SQL = SQL & " Where sjb_type_no='"&rsjb_type_no&"' and fkidx='"&rfkidx&"'"
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
%>
        <div class="input-group mb-1">     
          <input type="text" class="form-control" value="<%=fname%>_<%=fknickname%>" onclick="location.replace('');" readonly>      
        </div>
<%
    Rs.movenext
    Loop
    End if
    Rs.close
%>   
        </div>
<!-- 생성된 도면정보 끝 -->
<!-- 대메뉴 보이기 시작 -->
<div class="menu-container">

  <div class="dropdown-header" onclick="toggleDropdown(1)">검측정보</div>
  <div class="dropdown-content" id="dropdown-1">
    <div class="input-group">
      <label>검측가로</label>
      <input type="text" name="menu1_input1">
    </div>
    <div class="input-group">
      <label>검측높이</label>
      <input type="text" name="menu1_input2">
    </div>
    <div class="input-group">
      <label>바닥묻힘</label>
      <input type="text" name="menu1_input3">
    </div>
  </div>

  <div class="dropdown-header" onclick="toggleDropdown(2)">자동옵션정보</div>
  <div class="dropdown-content" id="dropdown-2">
    <div class="input-group">
      <label>대메뉴 2 - 항목 1</label>
      <input type="text" name="menu2_input1">
    </div>
    <div class="input-group">
      <label>대메뉴 2 - 항목 2</label>
      <input type="text" name="menu2_input2">
    </div>
    <div class="input-group">
      <label>대메뉴 2 - 항목 3</label>
      <input type="text" name="menu2_input3">
    </div>
  </div>

  <div class="dropdown-header" onclick="toggleDropdown(3)">대메뉴 3</div>
  <div class="dropdown-content" id="dropdown-3">
    <div class="input-group">
      <label>대메뉴 3 - 항목 1</label>
      <input type="text" name="menu3_input1">
    </div>
    <div class="input-group">
      <label>대메뉴 3 - 항목 2</label>
      <input type="text" name="menu3_input2">
    </div>
    <div class="input-group">
      <label>대메뉴 3 - 항목 3</label>
      <input type="text" name="menu3_input3">
    </div>
  </div>

  <div class="dropdown-header" onclick="toggleDropdown(4)">대메뉴 4</div>
  <div class="dropdown-content" id="dropdown-4">
    <div class="input-group">
      <label>대메뉴 4 - 항목 1</label>
      <input type="text" name="menu4_input1">
    </div>
    <div class="input-group">
      <label>대메뉴 4 - 항목 2</label>
      <input type="text" name="menu4_input2">
    </div>
    <div class="input-group">
      <label>대메뉴 4 - 항목 3</label>
      <input type="text" name="menu4_input3">
    </div>
  </div>

  <div class="dropdown-header" onclick="toggleDropdown(5)">대메뉴 5</div>
  <div class="dropdown-content" id="dropdown-5">
    <div class="input-group">
      <label>대메뉴 5 - 항목 1</label>
      <input type="text" name="menu5_input1">
    </div>
    <div class="input-group">
      <label>대메뉴 5 - 항목 2</label>
      <input type="text" name="menu5_input2">
    </div>
    <div class="input-group">
      <label>대메뉴 5 - 항목 3</label>
      <input type="text" name="menu5_input3">
    </div>
  </div>

  <div class="dropdown-header" onclick="toggleDropdown(6)">대메뉴 6</div>
  <div class="dropdown-content" id="dropdown-6">
    <div class="input-group">
      <label>대메뉴 6 - 항목 1</label>
      <input type="text" name="menu6_input1">
    </div>
    <div class="input-group">
      <label>대메뉴 6 - 항목 2</label>
      <input type="text" name="menu6_input2">
    </div>
    <div class="input-group">
      <label>대메뉴 6 - 항목 3</label>
      <input type="text" name="menu6_input3">
    </div>
  </div>

</div>

<script>
  let currentOpen = null;

  function toggleDropdown(num) {
    const selected = document.getElementById(`dropdown-${num}`);

    // 현재 열려 있는 것이 다시 클릭된 경우 -> 닫기
    if (currentOpen === num) {
      selected.style.display = 'none';
      currentOpen = null;
    } else {
      // 모든 드롭다운 닫기
      for (let i = 1; i <= 6; i++) {
        document.getElementById(`dropdown-${i}`).style.display = 'none';
      }
      // 선택된 드롭다운 열기
      selected.style.display = 'block';
      currentOpen = num;
    }
  }
</script>
<!-- 대메뉴 보이기 끝 -->



      <!-- 두번째 줄 첫 번째 칸 끝 -->
      </div>
      <div class="col-flex">
      <!-- 두번째 줄 두 번째 칸 시작 -->
            <div class="canvas-container">
                <div class="svg-container">
                    <svg id="canvas" width="100%" height="100%" class="d-block">
                    <rect id="rectangle" fill="white" stroke="black" stroke-width="1" width="0" height="0"></rect>
                    <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                    <text id="width-label" class="dimension-label"></text>
                    <text id="height-label" class="dimension-label"></text>
                        <%
                        SQL="select fksidx, xi, yi, wi, hi from tk_framekSub Where fkidx='"&rfkidx&"' "
                        response.write (SQL)
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            i=i+1
                            fksidx=Rs(0)
                            xi=Rs(1)
                            yi=Rs(2)
                            wi=Rs(3)
                            hi=Rs(4)
                            if cint(fksidx)=cint(rfksidx) then 
                              stroke_text="red"
                              fill_text="red"
                            else
                              stroke_text="black"
                              fill_text="white"
                            end if
                        %>
                        <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="black" stroke-width="1" onclick="location.replace('tng1b_suju.asp?sjidx=<%=rsjidx%>&sjb_type_no=<%=rsjb_type_no%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=fkidx%>&fksidx=<%=fksidx%>');"/>
                        <text x="<%=xi+5%>" y="<%=yi+20%>" font-family="Arial" font-size="14" fill="#000000"><%=i%></text>
                        <%
                        Rs.movenext
                        Loop
                        End if
                        Rs.close
                        %>          
                    </svg>
                </div>
            </div>
      <!-- 두번째 줄 두 번째 칸 끝 -->
      </div>
      <div class="col-fixed border-start">
      <!-- 두번째 줄 세 번째 칸 시작 -->


<div class="container mt-2">
  <div class="button-grid">
    <button class="btn">로비폰박스 추가</button>
    <button class="btn">로비폰 입력구간</button>
    <button class="btn">좌측세로바추가</button>
    <button class="btn">우측세로바추가</button>
    <button class="btn">자동문방향</button>
    <button class="btn">중간바 박스라인</button>
    <button class="btn">좌도어 롯트바</button>
    <button class="btn">우도어 롯트바</button>
    <button class="btn">양개도어 롯트바</button>
    <button class="btn">하부분할중간소대</button>
    <button class="btn">하바1개 중간소대</button>
    <button class="btn">버튼 12</button>
  </div>
</div>
      <!-- 두번째 줄 세 번째 칸 끝 -->
      </div>
    </div>

    <!-- 세 번째 줄 -->
    <div class="row-3 d-flex align-items-center">
      <!-- 세 번째 줄 (200px 높이) -->
<div class="row" style="width: 100%;border: 1px solid black;">
  <!-- 왼쪽 칸 -->
  <div style="width: 300px;">
ㄴㄴㄴㄴ
  </div>
  <div class="col-6" >
<!-- 부속품 선택하기 시작 -->
    <div  class="scroll-container" style="display: flex; justify-content: flex-start;">
      <!-- 반복문으로 이 블럭을 생성 -->
<%
SQL="select A.fksidx, A.xi, A.yi, A.wi, A.hi, A.WHICHI_AUTO, A.WHICHI_FIX "
SQL=SQL&" , A.bfidx, B.set_name_Fix, B.set_name_AUTO "
SQL=SQL&" From tk_framekSub A "
SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 

i=i+1
fksidx=Rs(0)
xi=Rs(1)
yi=Rs(2)
wi=Rs(3)
hi=Rs(4)
WHICHI_AUTO=Rs(5)
WHICHI_FIX=Rs(6)
bfidx=Rs(7)
set_name_Fix=Rs(8)
set_name_AUTO=Rs(9)

If bfidx="0" or isnull(bfidx) then 
  set_name_AUTO="없음"
  set_name_Fix="없음"
end if 
%>
<%

  End if
  Rs.close
%> 
<%
SQL=" Select top 6 bfidx, set_name_Fix, set_name_AUTO, whichi_auto, whichi_fix, xsize, ysize, bfimg1, bfimg2, bfimg3 "
SQL=SQL&" , tng_busok_idx, tng_busok_idx2 "
SQL=SQL&" From tk_barasiF "
SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
If WHICHI_AUTO <> "0" Then 
SQL = SQL & " AND whichi_auto = '" & WHICHI_AUTO & "' "
End if
If WHICHI_FIX <> "0" Then 
SQL = SQL & " AND whichi_fix = '" & WHICHI_FIX & "' "
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


      <div class="card custom-card">
        <div class="card-header"><%=set_name_AUTO%><%=set_name_Fix%></div>
        <div class="card-body">
        <% if bfimg3<>"" then %>
          <img src="/img/frame/bfimg/<%=bfimg3%>" loading="lazy" width="180" height="100"  border="0">
        <% elseif bfimg1<>"" then %>
          <img src="/img/frame/bfimg/<%=bfimg1%>" loading="lazy" width="180" height="100"  border="0">
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

  <!-- Bootstrap JS (optional) -->
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
