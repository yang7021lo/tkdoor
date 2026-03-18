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
 
projectname="도면 등록"
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
        body {
            zoom: 1;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <style>
        /* 🔹 버튼 크기 조정 */
        .btn-small {
            font-size: 18px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 22px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
    </style>
    <style>
        .header {
            text-align: center;
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 20px;
            position: relative;
            display: inline-block;
        }
        .header::after {
            content: "";
            display: block;
            width: 100%;
            height: 3px;
            background-color: black;
            position: absolute;
            bottom: -5px;
            left: 0;
        }
        .table thead th { background-color: #f8f9fa; }
    </style>
    <style>
         /* 프린트 설정 */
        @page {
            size: A4 landscape; /* 가로(A4) */
            margin: auto; /* 최소 여백 설정 */
        }
        @media print {
            .form-control {
                width: auto; /* 인쇄 시 너비 자동 조정 */
            }
            .print-btn { display: none; } /* 프린트 시 버튼 숨기기 */
        }
    </style>
</head>
<body class="sb-nav-fixed">
<div id="layoutSidenav_content">    
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
            <div class="card card-body mb-1">
                <div class="d-flex align-items-center justify-content-between">
                    <span class="input-group-text" style="font-weight: bold; font-size: 48px; white-space: nowrap;">
                        보고폼 리스트
                    </span>
                    <button class="print-btn" onclick="window.print()">🖨️ 출력하기</button>
                    <input type="date" class="form-control text-end"
                        id="dateInput"
                        style="font-weight: bold; font-size: 48px; width: 500px; text-align: right;">
                    <span id="dayOfWeek" style="font-weight: bold; font-size: 48px; margin-left: 10px; white-space: nowrap;"></span>
                </div>
            </div>
            <div class="card card-body mb-1">       <!-- * 보고폼 시작-->   
                <div class="col-md-12">
                    <table id="datatablesSimple"  class="table table-hover">
                        <thead>
                            <tr>
                                <th align="center">체크박스</th>
                                <th align="center">No</th>
                                <th align="center">날짜</th>
                                <th align="center">발주처</th>
                                <th align="center">출고구분/창고/배달</th>
                                <th align="center">보내는 주소</th>
                                <th align="center">입금여부</th>                                
                                <th align="center">사이즈와 수량</th>
                                <th align="center">품목</th>
                                <th align="center">품목수량</th>
                                <th align="center">도어</th>
                                <th align="center">도어수량</th>
                                <th align="center">재질</th>
                                <th align="center">발주시 업체명</th>
                                <th align="center">출고일자</th>
                                <th align="center">작업의뢰일자</th>
                                <th align="center">비고</th>
                                <th align="center">작성자</th>
                            </tr>
                        </thead>
                        <tbody>
                    <%
                    %> 
                            <tr>
                                <td><input type="checkbox"></td>
                                <td><%=no-i%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                                <td><%%></td>
                            </tr>
                    <%
                    %>
                            </tbody>
                    </table>    
                </div>
            </div>
        </div>
    </div>
</main>                          
</div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
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
