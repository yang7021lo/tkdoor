<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left1.asp"-->
<%
	call dbOpen()
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")
listgubun="one"
 
projectname="MES1"
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


SearchWord=Request("SearchWord")
gubun=Request("gubun")
 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"


%>작업의뢰등록
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
    <title>텍스트 방향 설정 예제</title> 
    <style> 
    .horizontal-text { 
      writing-mode: horizontal-tb; /* 텍스트를 가로로 설정 */ 
      transform: rotate(0deg); /* 기본적으로 0도 회전 */ 
      font-size: 12px; /* 폰트 크기를 10px로 설정 */
    } 
    </style>
    <style>
        body {
             zoom: 0.8;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <title>jQuery Multi Input and Select Example</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> 
</head>
<body class="sb-nav-fixed" >
<div id="layoutSidenav_content">            
  <main>
  <div class="container-fluid px-4">
  <div class="row justify-content-between  mt-2">
    <h5 class="text-center mb-4">작업의뢰등록</h5>
    <div class="row mb-3">
      <div class="col-md-3">
        <label for="date" class="form-label">일자</label>
        <input type="date" class="form-control" id="date" value="2025-01-10">
      </div>
      <div class="col-md-3">
        <label for="number" class="form-label">번호</label>
        <input type="number" class="form-control" id="number" value="109">
      </div>
      <div class="col-md-3">
        <label for="urgency" class="form-label">긴급</label>
        <select class="form-select" id="urgency">
          <option selected>일반</option>
          <option>긴급</option>
        </select>
      </div>
      <div class="col-md-3">
        <label for="output" class="form-label">출고구분</label>
        <select class="form-select" id="output">
          <option selected>화물</option>
          <option>택배</option>
        </select>
      </div>
    </div>
    <div class="row mb-3">
      <div class="col-md-3">
        <label for="status" class="form-label">상태</label>
        <select class="form-select" id="status">
          <option selected>검토</option>
          <option>완료</option>
        </select>
      </div>
      <div class="col-md-3">
        <label class="form-label">인쇄</label>
        <div>
          <input type="radio" class="btn-check" name="printOption" id="work" autocomplete="off" checked>
          <label class="btn btn-outline-primary" for="work">작업</label>
          <input type="radio" class="btn-check" name="printOption" id="label" autocomplete="off">
          <label class="btn btn-outline-secondary" for="label">라벨</label>
        </div>
      </div>
    </div>
    <div class="mb-3">
      <label for="note" class="form-label">참고</label>
      <textarea class="form-control" id="note" rows="2"></textarea>
    </div>
    <table class="table table-bordered text-center">
      <thead>
        <tr>
          <th scope="col">No.</th>
          <th scope="col">구분</th>
          <th scope="col">거래처</th>
          <th scope="col">현장</th>
          <th scope="col">품명</th>
          <th scope="col">규격</th>
          <th scope="col">수량</th>
          <th scope="col">작업인쇄</th>
          <th scope="col">라벨인쇄</th>
          <th scope="col">유리인쇄</th>
          <th scope="col">세부정보</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>1</td>
          <td>도어</td>
          <td>사무실</td>
          <td>3</td>
          <td>신형단열자동 65*90</td>
          <td>1000x2400</td>
          <td>1</td>
          <td>좌</td>
          <td>24T</td>
          <td>H/L</td>
          <td></td>
        </tr>
      </tbody>
    </table>
  </div>
  </div>
  </main>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
