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
 
projectname="도장리스트"
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
            zoom: 0.8;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <style>
        /* 카드 전체 크기 조정 */
        .card.card-body {
            padding: 1px; /* 내부 여백 줄이기 */
            margin-bottom: 0.5rem; /* 하단 여백 줄이기 */
        }

        /* 글씨 크기 및 입력 필드 크기 조정 */
        .form-control {
            font-size: 12px; /* 글씨 크기 줄이기 */
            height: 25px; /* 입력 필드 높이 줄이기 */
            padding: 1px 1px; /* 내부 여백 줄이기 */
        }

        /* 레이블 크기 조정 */
        label {
            font-size: 12px;
            margin-bottom: 0px; /* 레이블과 입력 필드 간격 최소화 */
        }

        /* 행(row) 간격 줄이기 */
        .row {
            margin-bottom: 0px; /* 행 간격 줄이기 */
        }
        /* 🔹 버튼 크기 조정 */
        .btn-small {
            font-size: 18px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 22px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
    </style>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG3.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
            <div class="card card-body mb-1">
                <div class="row ">
                    <div class="form-group col-md-2">
                        <label for="name">조회 기준</label><p>
                        <input type="radio" name="date-type" checked> 작업의뢰일자
                        <input type="radio" name="date-type"> 도장일자
                    </div>
                    <div class="form-group col-md-4">
                        <label for="name">작업의뢰_조회</label><p>
                        <input type="date"> ~ <input type="date">
                    </div>
                    <div class="col-md-2">
                        <label for="name">조회/적용/닫기</label><p>
                        <button class="btn btn-primary btn-small " type="submit" >조회</button>
                        <button class="btn btn-success btn-small " type="submit" >적용</button>
                        <button class="btn btn-danger btn-small " type="submit" onclick="window.close();" >닫기</button>
                    </div>
                    <div class="col-md-2">
                        <label for="name">인쇄</label><p>
                        <button class="btn btn-primary btn-small " type="submit"
                        onclick="window.open('TNG3_DO_P.ASP?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>','_blank','width=1500  , height=1000, top=200, left=500' );">도장리스트_인쇄</button>
                    </div>
                </div>    
            </div>
            <div class="card card-body mb-1">       <!-- * 도장리스트폼 시작-->   
                <div class="col-md-12">
                    <table id="datatablesSimple"  class="table table-hover">
                        <thead>
                            <tr>
                                <th align="center">체크박스</th>
                                <th align="center">No</th>
                                <th align="center">긴급여부</th>
                                <th align="center">발주처</th>
                                <th align="center">재질</th>
                                <th align="center">도장색상</th>
                                <th align="center">총수량</th>
                                <th align="center">샘플여부</th>                                
                                <th align="center">사이즈와 수량</th>
                                <th align="center">품목</th>
                                <th align="center">품목수량</th>
                                <th align="center">도어</th>
                                <th align="center">도어수량</th>
                                <th align="center">도장출고일자</th>
                                <th align="center">오전/오후</th>
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
                <!-- footer 시작 -->    
                Coded By 양양
                <!-- footer 끝 --> 
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
