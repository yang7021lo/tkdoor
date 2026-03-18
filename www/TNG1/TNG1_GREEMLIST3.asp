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

  rsjb_idx=request("sjb_idx")
  rsjb_type_no=Request("sjb_type_no")
  rsjbsub_Idx=Request("sjbsub_Idx")

  rfkidx=Request("fkidx")
  rfksidx=Request("fksidx")
  rfidx=Request("fidx")
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


SQL=" Select sjb_type_name, SJB_barlist "
SQL=SQL&" From TNG_SJB "
SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
  sjb_type_name=Rs(0)
  sjb_barlist=Rs(1)
End If
Rs.Close

'부속이 적용된 신규 입면도면 구성을 위한 코드 시작
'=======================================
if Request("part")="pummoksub" then 
response.write rsjb_idx&"<br>"
response.write rfidx&"<br>"

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
    SQL=SQL&" , GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, fmidx, fwdate, fmeidx, fewdate,  fstatus) "
    SQL=SQL&" Values ('"&fkidx&"', '"&fknickname&"', '"&rfidx&"', '"&rsjb_idx&"', '"&fname&"', '"&GREEM_F_A&"', '"&GREEM_BASIC_TYPE&"' "
    SQL=SQL&" , '"&GREEM_FIX_TYPE&"', '"&GREEM_HABAR_TYPE&"', '"&GREEM_LB_TYPE&"', '"&GREEM_O_TYPE&"', '"&GREEM_FIX_name&"', '"&GREEM_MBAR_TYPE&"' "
    SQL=SQL&" , '"&C_midx&"', getdate(), '"&C_midx&"', getdate(), '1') "
    'Response.write (SQL)&"<br><br>"
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
response.write "<script>alert('입면도면이 추가 되었습니다.');location.replace('tng1_greemlist3.asp?sjb_idx="&rsjb_idx&"&SearchWord="&SearchWord&"&fkidx="&fkidx&"');</script>"
End If
'=======================================
'부속이 적용된 신규 입면도면 구성을 위한 코드 끝

'부속 적용하기 시작
'=======================================
if Request("part")="bfinsert" then 
    rsbfidx=Request("sbfidx")
    SQL=" Update tk_framekSub set bfidx='"&rsbfidx&"' where fksidx='"&rfksidx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if
'=======================================
'부속적용하기 끝
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title><%=projectname%></title>
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        a:link {
        color: #070707;
        text-decoration: none;
        }
        a:visited {
        color: #070707;
        text-decoration: none;
        }
        a:hover {
        color: #070707;
        text-decoration: none;
        }
    </style>
  <style>
    .box {
      border: 0px solid #ccc;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #ffffff;
    }

    .row-border {
      border-bottom: 1px solid #999;
      margin-bottom: 5px;
      padding-bottom: 5px;
    }

  .card-title-bg {
    background-color: #f1f1f1;
    padding: 10px;
    margin: -1rem -1rem 0 -1rem; /* 카드 내부 여백을 덮기 위해 마이너스 마진 */
    border-bottom: 1px solid #ddd;
  }
      .btn-spacing > .btn {
      margin-right: 1px;
    }

    /* 마지막 버튼 오른쪽 여백 제거 */
    .btn-spacing > .btn:last-child {
      margin-right: 0;
    }
  </style>
    <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
 
    }

    iframe {
      width: 100%;
      height: 100%;
      border: none;
      overflow: hidden;
    }

    .full-height-card {
      height: 100vh; /* Viewport 전체 높이 */
      display: flex;
      flex-direction: column;
    }    
  </style>
  <script>
    function validateform() {
        if(document.frmMain.SJBsub_TYPE_NAME2.value == "" ) {
            alert("품목의 이름을 입력하세요.");
        return
        }
        else {
            document.frmMain.submit();
        }
    }

    function pummoksub(fidx) {
      const message = prompt("이 입면 도면을 기본으로 부속이 적용된 신규 부족적용 입면 도면 생성합니다. 입면도면의 이름을 입력하세요.");
      if (message !== null && message.trim() !== "") {
        const encodedMessage = encodeURIComponent(message.trim());
        window.location.href = "tng1_greemlist3.asp?part=pummoksub&sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fidx="+fidx+"&fknickname="+encodedMessage;
      }
    }
  </script>
    <script>
    document.addEventListener("DOMContentLoaded", function () {
        // 공통 키프레스 핸들러
        function handleKeyPress(event, elementId1, elementId2) {
        if (event.key === "Enter") {
            event.preventDefault();
            console.log(`Enter 눌림: ${elementId1}, ${elementId2}`);
            document.getElementById("hiddenSubmit").click();
        }
        }

        // 셀렉트 변경 시
        function handleSelectChange(event, elementId1, elementId2) {
        console.log(`선택 변경됨: ${elementId1}, ${elementId2}`);
        document.getElementById("hiddenSubmit").click();
        }

        // 간단 셀렉트 처리
        function handleChange(selectElement) {
        console.log("선택값:", selectElement.value);
        document.getElementById("hiddenSubmit").click();
        }

        // 전역 폼 Enter 감지
        const form = document.getElementById("dataForm");
        if (form) {
        form.addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
            event.preventDefault();
            console.log("폼 전체에서 Enter 감지");
            document.getElementById("hiddenSubmit").click();
            }
        });
        }
        // 전역으로 함수 노출
        window.handleKeyPress = handleKeyPress;
        window.handleSelectChange = handleSelectChange;
        window.handleChange = handleChange;
    });
    </script>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  


<div class="container-fluid">
  <div class="row">
    <!-- 왼쪽 패널: 검색및 리스트 -->
    <div class="col-md-3 border-end mb-2">
<form id="Search" name="Search" action="tng1_greemlist3.asp" method="POST">  
      <div class="input-group mb-2">
        <input type="text" class="form-control" name="SearchWord" id="SearchWord" placeholder="예: 케빈"  value="<%=Request("SearchWord")%>">
        <button type="submit" class="btn btn-outline-primary w-25"  >검색</button>
      </div>
</form>
<% if rsjb_idx<>"" then %>
      <div class="input-group mb-2">
        <span for="bendName" class="input-group-text">품목</span> 
        <input type="text" class="form-control" value="<%=sjb_type_name%>&nbsp;<%=SJB_barlist%>">
      </div>

      <div class="card mb-2">
        <div class="card-header">
          입면도면서브
        </div>    
        <div class="card-body">
            <div class="row ">
              <table id="datatablesSimple" class="table table-hover" style="table-layout: fixed; width: 100%;">
              <thead>
                <tr>
                  <th style="width: 10%;">No</th>
                  <th style="width: 50%;">품목</th>
                  <th style="width: 20%;">별칭</th>
                  <th style="width: 20%;">수주등록</th>
                </tr>
              </thead>
              <tbody>
<%
SQL=" Select fkidx, fknickname, fname, fstatus From tk_framek Where sjb_idx='"&rsjb_idx&"' "
    Rs1.open Sql,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then 
    Do while not Rs1.EOF
    fkidx=Rs1(0)
    fknickname=Rs1(1)
    fname=Rs1(2)
    fstatus=Rs1(3)
    j=j+1
    if int(fkidx)=int(rfkidx) then  
    cccc="#F7F7F9" 
    else
    cccc="#FFFFFF" 
    end if
%>
                <tr bgcolor="<%=cccc%>">
                  <td><a href="tng1_greemlist3.asp?sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fkidx=<%=fkidx%>"><%=j%></a></td>
                  <td><a href="tng1_greemlist3.asp?sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fkidx=<%=fkidx%>"><%=fname%></a></td>
                  <td><a href="tng1_greemlist3.asp?sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fkidx=<%=fkidx%>"><%=fknickname%></a></td>
                  <td><button class="btn btn-primary" id="move-down" onclick="">등록</button></td>
                </tr>
<%
    Rs1.movenext
    Loop
    End if
    Rs1.close
%>   
              </tbody>
             </table>
            </div>
        </div>
      </div>

<% else %>
      <div class="card">
        <div class="card-header">
          <h5 >품목</h5>
        </div>    
        <div class="card-body">
          <div class="row row-border">
            <div class="col-md-4 box">번호</div>
            <div class="col-md-4 box">품명</div>
            <div class="col-md-4 box">규격</div>
          </div>
<% 
SQL = "SELECT A.sjb_idx, B.sjb_type_name, A.SJB_barlist, A.sjb_type_no "
SQL = SQL & "FROM TNG_SJB A "
SQL = SQL & "LEFT OUTER JOIN tng_sjbtype B ON A.sjb_type_no = B.sjb_type_no AND B.sjbtstatus = 1 "
SQL=SQL&" Where B.sjb_type_name  like '%" & Request("SearchWord") & "%' or  A.SJB_barlist  like '%" & Request("SearchWord") & "%' "
'response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 15

if not (Rs.EOF or Rs.BOF ) then
no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
totalpage=Rs.PageCount '		
Rs.AbsolutePage=gotopage
i=1
for j=1 to Rs.RecordCount 
if i>Rs.PageSize then exit for end if
if no-j=0 then exit for end if

  sjb_idx=Rs(0)
  sjb_type_name=Rs(1)
  SJB_barlist=Rs(2)
  sjb_type_no=Rs(3)

%>
          <div class="row row-border">
            <div class="col-md-2 box"><a href="tng1_greemlist3.asp?sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&SearchWord=<%=Request("SearchWord")%>"><%=no-j%></a></div>
            <div class="col-md-7 box"><a href="tng1_greemlist3.asp?sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&SearchWord=<%=Request("SearchWord")%>"><%=sjb_type_name%></a></div>
            <div class="col-md-3 box"><%=SJB_barlist%></div>
          </div>
<% 
Rs.MoveNext 
i=i+1

Next 
'
%>
        <div class="row col-12 py-3">
<!--#include virtual="/inc/paging.asp"-->
        </div>
<%
End If  
Rs.close
  
%>
        </div>
      </div>
<%
end if
%>      
<% 
if rfkidx<>"" then 

  sql = " SELECT fidx, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, fmidx, fwdate, fmeidx, fewdate ,greem_o_type, greem_habar_type, greem_lb_type, GREEM_MBAR_TYPE "
  sql = sql & " FROM tk_framek "
  sql = sql & " WHERE fkidx='"&rfkidx&"' "

  'response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 

  fkidx        = rs(0)
  greem_f_a        = rs(1)
  greem_basic_type = rs(2)
  greem_fix_type   = rs(3)
  fmidx       = rs(4)
  fwdate      = rs(5)
  fmeidx      = rs(6)
  fewdate     = rs(7)
  greem_o_type     = rs(8)
  greem_habar_type     = rs(9)
  greem_lb_type     = rs(10)
  GREEM_MBAR_TYPE     = rs(11)

  ' ▼ greem_f_a 변환
  Select Case greem_f_a
      Case "1"
          greem_f_a_name = "자동"
      Case "2"
          greem_f_a_name = "수동"
      Case Else
          greem_f_a_name = "기타"
  End Select

  ' ▼ greem_basic_type 변환
  Select Case greem_basic_type
      Case "1"
          greem_basic_type_name = "기본"
      Case "2"
          greem_basic_type_name = "인서트 타입(T형)"
      Case "3"
          greem_basic_type_name = "픽스바 없는 타입"
      Case "4"
          greem_basic_type_name = "자동홈바 없는 타입"
      Case Else
          greem_basic_type_name = "기타 타입"
  End Select

  ' ▼ greem_o_type 변환
  Select Case greem_o_type
      Case "1"
          greem_o_type_name = "외도어"
      Case "2"
          greem_o_type_name = "외도어 상부남마"
      Case "3"
          greem_o_type_name = "외도어 상부남마 중간소대"
      Case "4"
          greem_o_type_name = "양개"
      Case "5"
          greem_o_type_name = "양개 상부남마"
      Case "6"
          greem_o_type_name = "양개 상부남마 중간소대"
      Case Else
          greem_o_type_name = "기타 타입"
  End Select

  ' ▼ greem_fix_type 변환
  Select Case greem_fix_type
      Case "0" 
          greem_fix_type_name = "픽스없음"
      Case "1"
          greem_fix_type_name = "좌픽스"
      Case "2"
          greem_fix_type_name = "우픽스"
      Case "3"
          greem_fix_type_name = "좌+우 픽스"
      Case "4"
          greem_fix_type_name = "좌+좌 픽스"
      Case "5"
          greem_fix_type_name = "우+우 픽스"
      Case "6"
          greem_fix_type_name = "좌1+우2 픽스"
      Case "7"
          greem_fix_type_name = "좌2+우1 픽스"
      Case "8"
          greem_fix_type_name = "좌2+우2 픽스"
      Case "9"
          greem_fix_type_name = "편개"
      Case "10"
          greem_fix_type_name = "양개"
      Case "11"
          greem_fix_type_name = "고정창"
      Case "12"
          greem_fix_type_name = "편개_상부남마"
      Case "13"
          greem_fix_type_name = "양개_상부남마"
      Case "14"
          greem_fix_type_name = "고정창_상부남마"
      Case "15"
          greem_fix_type_name = "편개_상부남마_중"
      Case Else
          greem_fix_type_name = "기타 타입"
  End Select
  ' ▼ greem_habar_type 변환
  Select Case greem_habar_type
      Case "0"
          greem_habar_type_name = "하바분할 없음"
      Case "1"
          greem_habar_type_name = "하바분할"
  End Select
  ' ▼ greem_lb_type 변환
  Select Case greem_lb_type
      Case "0"
          greem_lb_type_name = "로비폰 없음"
      Case "1"
          greem_lb_type_name = "로비폰"
  End Select
  ' ▼ GREEM_MBAR_TYPE 변환
  Select Case GREEM_MBAR_TYPE
      Case "0"
          GREEM_MBAR_TYPE_name = "중간소대 추가 없음"
      Case "1"
          GREEM_MBAR_TYPE_name = "중간소대 추가"
  End Select

End If
Rs.Close
%>
<!--
                        <div class="card card-body mb-1">
                            <div class="canvas-container">
                                <svg id="canvas" onclick="location.replace('tng1_greemlist3.asp?sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fidx=<%=fidx%>');" viewBox="0 100 1000 500" class="d-block">
                                
                                <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                                <text id="width-label" class="dimension-label"></text>
                                <text id="height-label" class="dimension-label"></text>
                                
                                    <%
                                    SQL="select fsidx, xi, yi, wi, hi from tk_framekSub Where fkidx='"&rfkidx&"' "
                                    Rs1.open Sql,Dbcon
                                    If Not (Rs1.bof or Rs1.eof) Then 
                                    Do while not Rs1.EOF
                                        i=i+1
                                        fksidx=Rs1(0)
                                        xi=Rs1(1)
                                        yi=Rs1(2)
                                        wi=Rs1(3)
                                        hi=Rs1(4)
                                    %>
                                    <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="#f1bcbc" stroke="#333333" stroke-width="" onclick="del('<%=fsidx%>');"/>
                                    <text x="<%=xi+5%>" y="<%=yi+20%>" font-family="Arial" font-size="14" fill="#000000"><%=i%></text>
                                    <%
                                    Rs1.movenext
                                    Loop
                                    End if
                                    Rs1.close
                                    %>          
                                </svg>
                                   
                                            <div style="text-align: center;">
                                                <p>
                                                <% if greem_f_a=1 then %>
                                                    <%=greem_basic_type_name%>_<%=greem_o_type_name%>_<%=greem_fix_type_name%>
                                                <% elseif greem_f_a=2 then %>
                                                    수동 <%=GREEM_FIX_TYPE_name%>
                                                <% end if %>
                                                </p>
                                            </div>
                              
                            </div>
                        </div>
-->
<%
End if
%>

<!-- 부속설정 시작 -->
<% if rfkidx<>"" then %>
      <div class="card">
        <div class="card-header">
          부속설정 : <%=greem_f_a_name%>자재
        </div>    
        <div class="card-body">
            <div class="row ">
            <form id="dataForm" name="dataForm" action="tng1_greemlist3.asp" method="post">
                <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                <input type="hidden" name="fksidx" value="<%=rfksidx%>">
                <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                <input type="hidden" name="SearchWord" value="<%=SearchWord%>">
                <input type="hidden" name="part" value="bfinsert">


              <table id="datatablesSimple" class="table table-hover" style="table-layout: fixed; width: 100%;">
              <thead>
                <tr>
                  <th style="width: 10%;">No</th>
                  <th style="width: 30%;">자재위치</th>
                  <th style="width: 60%;">부속</th>
                </tr>
              </thead>
              <tbody>
              <%
i=0
              SQL="select A.fksidx, A.xi, A.yi, A.wi, A.hi, A.WHICHI_AUTO, A.WHICHI_FIX "
              SQL=SQL&" , A.bfidx, B.set_name_Fix, B.set_name_AUTO "
              SQL=SQL&" From tk_framekSub A "
              SQL=SQL&" Left Outer Join tk_barasiF B On A.bfidx=B.bfidx "
              SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
              'Response.write (SQL)
              Rs.open Sql,Dbcon
              If Not (Rs.bof or Rs.eof) Then 
              Do while not Rs.EOF
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

              Select Case WHICHI_FIX
                Case "1"
                    WHICHI_FIX_text = "가로바"
                Case "2"
                    WHICHI_FIX_text = "가로바 길게"
                Case "3"
                    WHICHI_FIX_text = "중간바"
                Case "4"
                    WHICHI_FIX_text = "롯트바"
                Case "5"
                    WHICHI_FIX_text = "하바"
                Case "6"
                    WHICHI_FIX_text = "세로바"
                Case "7"
                    WHICHI_FIX_text = "세로중간통바"
                Case "8"
                    WHICHI_FIX_text = "180도 코너바"
                Case "9"
                    WHICHI_FIX_text = "90도 코너바"
                Case "10"
                    WHICHI_FIX_text = "비규격 코너바"
                Case Else
                    WHICHI_FIX_text = "선택 안됨"
              End Select

              Select Case WHICHI_AUTO
                Case "1"
                    WHICHI_AUTO_text = "박스세트"
                Case "2"
                    WHICHI_AUTO_text = "박스커버"
                Case "3"
                    WHICHI_AUTO_text = "가로남마"
                Case "4"
                    WHICHI_AUTO_text = "상부중간소대"
                Case "5"
                    WHICHI_AUTO_text = "중간소대"
                Case "6"
                    WHICHI_AUTO_text = "자동홈바"
                Case "7"
                    WHICHI_AUTO_text = "세로픽스바"
                Case "8"
                    WHICHI_AUTO_text = "픽스하바"
                Case "9"
                    WHICHI_AUTO_text = "픽스상바"
                Case "10"
                    WHICHI_AUTO_text = "코너바"
                Case Else
                    WHICHI_AUTO_text = "선택 안됨"
              End Select

              If bfidx="0" or isnull(bfidx) then 
                set_name_AUTO="없음"
                set_name_Fix="없음"
              end if 
              %>
<% 
if int(fksidx)=int(rfksidx) then  
    cccc="#F7F7F9" 
%>
                <tr bgcolor="<%=cccc%>">
                  <td align="center"><%=i%></td>
                  <td><% if greem_f_a="1" then %><%=WHICHI_AUTO_text%><% elseif greem_f_a="2" then %><%=WHICHI_FIX_text%><% else %><% end if %></td>
                  <td>
                    <%
                    mode = Request("mode")
                    %>        
                    <input type="hidden" name="mode" id="modeInput" value="<%=mode%>">  
                    <!-- 모드 선택 버튼 -->
                    <div class="mb-2">
                        <button class="btn btn-secondary" type="button"
                            onclick="location.replace('TNG1_GREEMLIST3.asp?sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fkidx=<%=rfkidx%>&fksidx=<%=fksidx%>&mode=mode#<%=rfkidx%>');">
                            전체 자재 보기
                        </button>

                        <button class="btn btn-secondary" type="button"
                            onclick="location.replace('TNG1_GREEMLIST3.asp?sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fkidx=<%=rfkidx%>&fksidx=<%=fksidx%>&mode=kmode#<%=rfkidx%>');">
                            조건별 자재 보기
                        </button>
                    </div>                  
                    <!-- 자재 선택 Select 박스 -->
                    <select class="form-select" name="sbfidx" id="sbfidx" onchange="handleChange(this)">
                        <option value="0" <% If bfidx = "0" Then Response.Write "selected" %>>없음</option>
                    <%
                    SQL=" Select bfidx, set_name_Fix, set_name_AUTO "
                    SQL=SQL&" From tk_barasiF "
                    SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "

                    ' 조건모드가 아니면 전체 가져옴
                    If mode = "kmode" Or mode = "" Or IsNull(mode) Then
                        If rsjb_idx <> "" Then SQL = SQL & " AND sjb_idx = '" & rsjb_idx & "' "
                        If WHICHI_AUTO <> "" Then SQL = SQL & " AND whichi_auto = '" & WHICHI_AUTO & "' "
                        If WHICHI_FIX <> "" Then SQL = SQL & " AND whichi_fix = '" & WHICHI_FIX & "' "
                    End If

                    'response.write SQL & "<br>"
                    Rs1.open SQL, Dbcon, 1, 1, 1
                    If Not (Rs1.BOF Or Rs1.EOF) Then 
                        Do While Not Rs1.EOF
                            sbfidx = Rs1(0)
                            set_name_FIX = Rs1(1)
                            set_name_AUTO = Rs1(2)
                    %>
                        <option value="<%=sbfidx%>" <% If CInt(sbfidx) = CInt(bfidx) Then Response.Write "selected" %>>
                            <% If greem_f_a = "1" Then %><%=set_name_AUTO%><% ElseIf greem_f_a = "2" Then %><%=set_name_FIX%><% Else %><%=set_name_AUTO%>/<%=set_name_FIX%><% End If %>
                        </option>
                    <%
                            Rs1.MoveNext
                        Loop
                    End If
                    Rs1.Close
                    %>
                    </select>
                  </td> 

                </tr>


<% else 
cccc=""
%>

                <tr bgcolor="<%=cccc%>">
                  <td align="center"><a href="tng1_greemlist3.asp?sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fkidx=<%=rfkidx%>&fksidx=<%=fksidx%>"><%=i%></a></td>
                  <td><a href="tng1_greemlist3.asp?sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fkidx=<%=rfkidx%>&fksidx=<%=fksidx%>"><% if greem_f_a="1" then %><%=WHICHI_AUTO_text%><% elseif greem_f_a="2" then %><%=WHICHI_FIX_text%><% else %><% end if %></a></td>
                  <td><a href="tng1_greemlist3.asp?sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fkidx=<%=rfkidx%>&fksidx=<%=fksidx%>"><% if greem_f_a="1" then %><%=set_name_AUTO%><% elseif greem_f_a="2" then %><%=set_name_Fix%><% else %><% end if %></a></td> 
                </tr>
<%
end if
%>
              <%
                Rs.movenext
                Loop
                End if
                Rs.close
              %> 
              <button type="submit" id="hiddenSubmit" style="display: none;"></button>
              </form>
              </tbody>
              </table>

            </div>
        </div>
      </div>
<% end if %>
<!-- 부속정정 끝 -->

    </div>


  <!-- 오른쪽 패널: 자재 (카드 안으로 감쌈) -->

  <div class="col-md-9">
<%
if rsjb_idx<>"" and rfkidx="" then 
%>  
    <div class="card">
    
      <div class="card-header">
<form name="frmMain" action="tng1_greemlist3.asp" method="POST">  
<input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="SearchWord" value="<%=SearchWord%>">


        <div class="input-group mt-2 mb-1">
                        <div class="col-auto">
                        <!-- -->
                          <span>
                              <input type="radio" class="form-check-input" name="greem_f_a" value="1" onchange="this.form.submit();" <% If rgreem_f_a = "1" Then Response.Write "checked" end if %>> 자동
                              <input type="radio" class="form-check-input" name="greem_f_a" value="2" onchange="this.form.submit();" <% If rgreem_f_a = "2" Then Response.Write "checked" end if %>> 수동
                          </span>
                        <!-- -->
                        <!-- -->
                          <label>
                              <input type="radio" class="form-check-input" name="greem_habar_type" value="0" onchange="this.form.submit();" 
                              <% If rgreem_habar_type = "0" Then Response.Write "checked" end if %>> 하바분할 없음
                          </label>
                          <label>
                              <input type="radio" class="form-check-input" name="greem_habar_type" value="1" onchange="this.form.submit();" 
                              <% If rgreem_habar_type = "1" Then Response.Write "checked" end if %>> 하바분할 타입
                          </label>
                        <!-- -->
                        <!-- -->
                          <label>
                              <input type="radio" class="form-check-input" name="greem_lb_type" value="0" onchange="this.form.submit();" 
                              <% If rgreem_lb_type = "0" Then Response.Write "checked" end if %>>로비폰 없음
                          </label>
                          <label>
                              <input type="radio" class="form-check-input" name="greem_lb_type" value="1" onchange="this.form.submit();" 
                              <% If rgreem_lb_type = "1" Then Response.Write "checked" end if %>>로비폰 추가
                          <label>
                              <input type="radio" class="form-check-input" name="GREEM_MBAR_TYPE" value="0" onchange="this.form.submit();" 
                              <% If rGREEM_MBAR_TYPE = "0" Then Response.Write "checked" end if %>>중간소대 추가 없음
                          </label>
                          <label>
                              <input type="radio" class="form-check-input" name="GREEM_MBAR_TYPE" value="1" onchange="this.form.submit();" 
                              <% If rGREEM_MBAR_TYPE = "1" Then Response.Write "checked" end if %>>중간소대 추가    
                        <!-- -->
                        </div>
        </div>

        <div class="input-group mb-2">
                        <% If rgreem_f_a = "1" Then %>
                        <div class="col-2">
                            <select name="greem_basic_type" class="form-control" onchange="this.form.submit();">
                                <option value="">세부 타입 선택</option>
                                    <% 
                                    sql = "SELECT DISTINCT  greem_basic_type "
                                    sql = sql & "FROM tk_frame "
                                    sql = sql & "WHERE GREEM_F_A = '" & rgreem_f_a & "' ORDER BY greem_basic_type"
                                    'response.write (SQL)&"<br>"
                                        Rs.open Sql,Dbcon,1,1,1
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do until Rs.EOF
                                            greem_basic_type        = rs(0)

                                            Select Case greem_basic_type
                                            Case "1"
                                                greem_basic_type_name = "기본"
                                            Case "2"
                                                greem_basic_type_name = "인서트 타입(T형)"
                                            Case "3"
                                                greem_basic_type_name = "픽스바 없는 타입"
                                            Case "4"
                                                greem_basic_type_name = "자동홈바 없는 타입"
                                            Case Else
                                                greem_basic_type_name = "기타 타입"    
                                        end select         
                                    %>
                                    <option value="<%=greem_basic_type%>" <% if cint(greem_basic_type) = cint(rgreem_basic_type) then Response.Write "selected" end if %>><%=greem_basic_type_name%></option>
                                    <%
                                    Rs.MoveNext
                                    Loop
                                    End If
                                    Rs.close
                                    %>
                            </select>
                        </div>
                        <div class="col-2">
                            <select name="GREEM_O_TYPE" class="form-control" onchange="this.form.submit();">
                                <option value="">모양 선택</option>
                                <% 
                                sql = "SELECT DISTINCT  GREEM_O_TYPE "
                                sql = sql & " FROM tk_frame "
                                sql = sql & " WHERE GREEM_F_A = '" & rgreem_f_a & "' and greem_basic_type = '" & rgreem_basic_type & "' ORDER BY GREEM_O_TYPE"
                                'response.write (SQL)&"<br>"
                                    Rs.open Sql,Dbcon,1,1,1
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do until Rs.EOF
                                        GREEM_O_TYPE        = rs(0)

                                        Select Case GREEM_O_TYPE
                                        Case "1"
                                            GREEM_O_TYPE_name = "외도어"
                                        Case "2"
                                            GREEM_O_TYPE_name = "외도어 상부남마"
                                        Case "3"
                                            GREEM_O_TYPE_name = "외도어 상부남마 중간소대"
                                        Case "4"
                                            GREEM_O_TYPE_name = "양개"
                                        Case "5"
                                            GREEM_O_TYPE_name = "양개 상부남마"
                                        Case "6"
                                            GREEM_O_TYPE_name = "양개 상부남마 중간소대"    
                                        Case Else
                                            GREEM_O_TYPE_name = "기타 타입"    
                                    end select         
                                %>
                                <option value="<%=GREEM_O_TYPE%>" <% if cint(GREEM_O_TYPE) = cint(rGREEM_O_TYPE) then Response.Write "selected" end if %>><%=GREEM_O_TYPE_name%></option>
                                <%
                                Rs.MoveNext
                                Loop
                                End If
                                Rs.close
                                %>
                            </select>
                        </div>
                        <% end if %>
                        <div class="col-2">
                            <select name="greem_fix_type" class="form-control" onchange="this.form.submit();">
                                <option value="">픽스 추가 선택</option>
                                <% 
                                sql = "SELECT DISTINCT  greem_fix_type "
                                sql = sql & " FROM tk_frame "
                                sql = sql & " WHERE GREEM_F_A = '" & rgreem_f_a & "' and greem_basic_type = '" & rgreem_basic_type & "'  and GREEM_O_TYPE = '" & rGREEM_O_TYPE & "'ORDER BY greem_fix_type"
                                'response.write (SQL)&"<br>"
                                    Rs.open Sql,Dbcon,1,1,1
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do until Rs.EOF
                                        greem_fix_type        = rs(0)

                                        Select Case greem_fix_type
                                        Case "0"
                                            greem_fix_type_name = "픽스없음"
                                        Case "1"
                                            greem_fix_type_name = "좌픽스"
                                        Case "2"
                                            greem_fix_type_name = "우픽스"
                                        Case "3"
                                            greem_fix_type_name = "좌+우 픽스"
                                        Case "4"
                                            greem_fix_type_name = "좌+좌 픽스"
                                        Case "5"
                                            greem_fix_type_name = "우+우 픽스"
                                        Case "6"
                                            greem_fix_type_name = "좌1+우2 픽스"    
                                        Case "7"
                                            greem_fix_type_name = "좌2+우1 픽스"    
                                        Case "8"
                                            greem_fix_type_name = "좌2+우2 픽스"   
                                        Case "9"
                                        greem_fix_type_name = "편개"
                                        Case "10"
                                            greem_fix_type_name = "양개"
                                        Case "11"
                                            greem_fix_type_name = "고정창"
                                        Case "12"
                                            greem_fix_type_name = "편개_상부남마"
                                        Case "13"
                                            greem_fix_type_name = "양개_상부남마"
                                        Case "14"
                                            greem_fix_type_name = "고정창_상부남마"
                                        Case "15"
                                            greem_fix_type_name = "편개_상부남마_중"     
                                        Case Else
                                            greem_fix_type_name = "기타 타입"    
                                    end select         
                                %>
                                <option value="<%=greem_fix_type%>" <% if cint(greem_fix_type) = cint(rgreem_fix_type) then Response.Write "selected" end if %>><%=greem_fix_type_name%></option>
                                <%
                                Rs.MoveNext
                                Loop
                                End If
                                Rs.close
                                %>
                            </select>
                        </div>
        </div>
</form>

      </div>
<form name="frmMainsub" action="tng1_greemlist.asp" method="POST">  

      <div class="card-body">
        <div >
                <div class="row ">
                    <%
                    sql = " SELECT fidx, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, fmidx, fwdate, fmeidx, fewdate ,greem_o_type, greem_habar_type, greem_lb_type, GREEM_MBAR_TYPE "
                    sql = sql & " FROM tk_frame "
                    sql = sql & " WHERE fidx <>'' "
                    if  rgreem_f_a <>"0" then
                    sql = sql & " and greem_f_a= '"&rgreem_f_a&"'  "
                    end if
                    if  rGREEM_BASIC_TYPE <>"0" then
                    sql = sql & " and GREEM_BASIC_TYPE = '"&rGREEM_BASIC_TYPE&"'  "
                    end if            
                    if  rgreem_o_type <>"0" then
                    sql = sql & " and greem_o_type = '"&rgreem_o_type&"' "
                    end if 
                    if  rgreem_fix_type <>"" then
                    sql = sql & " and greem_fix_type = '"&rgreem_fix_type&"' "
                    end if
                    if  rgreem_habar_type <>"" then
                    sql = sql & " and greem_habar_type = '"&rgreem_habar_type&"' "
                    end if
                    if  rgreem_lb_type <>"" then
                    sql = sql & " and greem_lb_type = '"&rgreem_lb_type&"' "
                    end if
                    if  rGREEM_MBAR_TYPE <>"" then
                    sql = sql & " and GREEM_MBAR_TYPE = '"&rGREEM_MBAR_TYPE&"' "
                    end if


                    'response.write (SQL)&"<br>"
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF
                    fidx        = rs(0)
                    greem_f_a        = rs(1)
                    greem_basic_type = rs(2)
                    greem_fix_type   = rs(3)
                    fmidx       = rs(4)
                    fwdate      = rs(5)
                    fmeidx      = rs(6)
                    fewdate     = rs(7)
                    greem_o_type     = rs(8)
                    greem_habar_type     = rs(9)
                    greem_lb_type     = rs(10)
                    GREEM_MBAR_TYPE     = rs(11)

                    ' ▼ greem_f_a 변환
                    Select Case greem_f_a
                        Case "1"
                            greem_f_a_name = "자동"
                        Case "2"
                            greem_f_a_name = "수동"
                        Case Else
                            greem_f_a_name = "기타"
                    End Select

                    ' ▼ greem_basic_type 변환
                    Select Case greem_basic_type
                        Case "1"
                            greem_basic_type_name = "기본"
                        Case "2"
                            greem_basic_type_name = "인서트 타입(T형)"
                        Case "3"
                            greem_basic_type_name = "픽스바 없는 타입"
                        Case "4"
                            greem_basic_type_name = "자동홈바 없는 타입"
                        Case Else
                            greem_basic_type_name = "기타 타입"
                    End Select

                    ' ▼ greem_o_type 변환
                    Select Case greem_o_type
                        Case "1"
                            greem_o_type_name = "외도어"
                        Case "2"
                            greem_o_type_name = "외도어 상부남마"
                        Case "3"
                            greem_o_type_name = "외도어 상부남마 중간소대"
                        Case "4"
                            greem_o_type_name = "양개"
                        Case "5"
                            greem_o_type_name = "양개 상부남마"
                        Case "6"
                            greem_o_type_name = "양개 상부남마 중간소대"
                        Case Else
                            greem_o_type_name = "기타 타입"
                    End Select

                    ' ▼ greem_fix_type 변환
                    Select Case greem_fix_type
                        Case "0" 
                            greem_fix_type_name = "픽스없음"
                        Case "1"
                            greem_fix_type_name = "좌픽스"
                        Case "2"
                            greem_fix_type_name = "우픽스"
                        Case "3"
                            greem_fix_type_name = "좌+우 픽스"
                        Case "4"
                            greem_fix_type_name = "좌+좌 픽스"
                        Case "5"
                            greem_fix_type_name = "우+우 픽스"
                        Case "6"
                            greem_fix_type_name = "좌1+우2 픽스"
                        Case "7"
                            greem_fix_type_name = "좌2+우1 픽스"
                        Case "8"
                            greem_fix_type_name = "좌2+우2 픽스"
                        Case "9"
                            greem_fix_type_name = "편개"
                        Case "10"
                            greem_fix_type_name = "양개"
                        Case "11"
                            greem_fix_type_name = "고정창"
                        Case "12"
                            greem_fix_type_name = "편개_상부남마"
                        Case "13"
                            greem_fix_type_name = "양개_상부남마"
                        Case "14"
                            greem_fix_type_name = "고정창_상부남마"
                        Case "15"
                            greem_fix_type_name = "편개_상부남마_중"
                        Case Else
                            greem_fix_type_name = "기타 타입"
                    End Select
                    ' ▼ greem_habar_type 변환
                    Select Case greem_habar_type
                        Case "0"
                            greem_habar_type_name = "하바분할 없음"
                        Case "1"
                            greem_habar_type_name = "하바분할"
                    End Select
                    ' ▼ greem_lb_type 변환
                    Select Case greem_lb_type
                        Case "0"
                            greem_lb_type_name = "로비폰 없음"
                        Case "1"
                            greem_lb_type_name = "로비폰"
                    End Select
                    ' ▼ GREEM_MBAR_TYPE 변환
                    Select Case GREEM_MBAR_TYPE
                        Case "0"
                            GREEM_MBAR_TYPE_name = "중간소대 추가 없음"
                        Case "1"
                            GREEM_MBAR_TYPE_name = "중간소대 추가"
                    End Select

                    %> 


                    <div class="col-3">
                        <div class="card card-body mb-1">
                            <div class="canvas-container">
                                <svg id="canvas" onclick="pummoksub('<%=fidx%>');" viewBox="0 100 1000 500" class="d-block">
                                
                                <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                                <text id="width-label" class="dimension-label"></text>
                                <text id="height-label" class="dimension-label"></text>
                                
                                    <%
                                    SQL="select fsidx, xi, yi, wi, hi from tk_frameSub Where fidx='"&fidx&"' "
                                    Rs1.open Sql,Dbcon
                                    If Not (Rs1.bof or Rs1.eof) Then 
                                    Do while not Rs1.EOF
                                        i=i+1
                                        fsidx=Rs1(0)
                                        xi=Rs1(1)
                                        yi=Rs1(2)
                                        wi=Rs1(3)
                                        hi=Rs1(4)
                                    %>
                                    <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="#f1bcbc" stroke="#333333" stroke-width="" onclick="del('<%=fsidx%>');"/>
                                    <text x="<%=xi+5%>" y="<%=yi+20%>" font-family="Arial" font-size="14" fill="#000000"><%=i%></text>
                                    <%
                                    Rs1.movenext
                                    Loop
                                    End if
                                    Rs1.close
                                    %>          
                                </svg>
                                   
                                            <div style="text-align: center;">
                                                <p>
                                                <% if greem_f_a=1 then %>
                                                    <%=greem_basic_type_name%>_<%=greem_o_type_name%>_<%=greem_fix_type_name%>
                                                <% elseif greem_f_a=2 then %>
                                                    수동 <%=GREEM_FIX_TYPE_name%>
                                                <% end if %>
                                                </p>
                                            </div>
                              
                            </div>
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

</form>


      </div>
<% elseIf rsjb_idx<>"" and rfkidx<>"" then  %>


    <div class="card full-height-card mb-5">
      <div class="card-header"><%=greem_f_a_name%>,<%=greem_habar_type_name%>,<%=greem_lb_type_name%>,<%=GREEM_MBAR_TYPE_name%>,<%=greem_o_type_name%>,<%=greem_fix_type_name%>,<%=greem_basic_type_name%>
      </div>
      <div class="card-body">
  <iframe src="tng1_greemlist3_frame.asp?fkidx=<%=rfkidx%>" frameborder="0" scrolling="no" height="700" allowfullscreen></iframe>
      </div>
    </div>
<% end if %>
    </div>


  </div>

</div>
<!-- 내용 입력 끝 -->  
        </div>
    </div>
</main>                          
                <!-- footer 시작 -->    
                Coded By 양양
                <!-- footer 끝 --> 
</div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="/js/scripts.js"></script>

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
