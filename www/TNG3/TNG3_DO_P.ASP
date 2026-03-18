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
    <script>
        function formatCurrency(input) {
            let value = input.value.replace(/[^0-9]/g, '');
            value = new Intl.NumberFormat('ko-KR').format(value);
            input.value = value;
        }
    </script>
        <title>가로 1줄 인쇄</title>
    <style>
        .print-row {
            display: flex;
            flex-wrap: wrap;
            gap: 15px; /* 요소 간격 */
        }
        
        .print-item {
            display: flex;
            align-items: center;
        }

        .input-group-text {
            font-weight: bold;
            margin-right: 10px;
        }

        .form-control {
            font-weight: bold;
            width: 150px; /* 입력 필드 크기 조정 */
        }

        @media print {
            .print-row {
                display: flex;
                flex-wrap: nowrap; /* 인쇄 시 줄 바꿈 없이 한 줄로 유지 */
                justify-content: space-between;
            }
            
            .form-control {
                width: auto; /* 인쇄 시 너비 자동 조정 */
            }
        }
    </style>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/left_TNG1.asp"-->

<div id="layoutSidenav_content">    
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
            <div class="container mt-1 TEXT-CENTER">
                <div class="header" >견 적 서</div>
            </div>
            <div class="row col-7">
                <div class="input-group mb-3">
                    <span class="input-group-text" style="font-weight: bold;">견적번호&nbsp;&nbsp;&nbsp;</span>
                    <input type="text" class="form-control" style="font-weight: bold;" name="" value="">
                </div> 
                <div class="input-group mb-3">
                    <span class="input-group-text" style="font-weight: bold;">업&nbsp;체&nbsp;명&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <input type="text" class="form-control" style="font-weight: bold;" name="" value="(주)아사아블로이엔트런스시스템">
                </div> 
                <div class="input-group mb-3">    
                    <span class="input-group-text" style="font-weight: bold;">견적일자&nbsp;&nbsp;&nbsp;</span>
                    <input type="text" class="form-control" style="font-weight: bold;" name="" value="">
                </div> 
                <div class="input-group mb-3">
                    <span class="input-group-text" style="font-weight: bold;">프로젝트명</span>
                    <input type="text" class="form-control" style="font-weight: bold;" name="" value="창원 상남동 생활형숙박시설">
                </div>
                <div class="input-group mb-3">
                    <span class="input-group-text" style="font-weight: bold;">총&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</span>
                    <input type="text" class="form-control" style="font-weight: bold;" name="" value="123213213213" oninput="formatCurrency(this)" >
                </div>
            </div> 
            <div class="row col-5">
                <img id="image1" src="\img\frame\taekwang_logo1.jpg" alt="태광도어" class="active img-fluid ">
            </div>  
            <div class="print-row">
                <div class="print-item">
                    <label class="input-group-text" for="name">도어_포함/별도</label>
                    <input type="text" class="form-control" value="도어포함가">
                </div>

                <div class="print-item">
                    <label class="input-group-text" for="name">재질</label>
                    <input type="text" class="form-control" value="헤어라인1.2">
                </div>

                <div class="print-item">
                    <label class="input-group-text" for="name">도장</label>
                    <input type="text" class="form-control" value="지정색도장사용">
                </div>

                <div class="print-item">
                    <label class="input-group-text" for="name">규격</label>
                    <input type="text" class="form-control" value="130*45">
                </div>

                <div class="print-item">
                    <label class="input-group-text" for="name">품목</label>
                    <input type="text" class="form-control" value="단열알루미늄자동">
                </div>
            </div>
            <div class="card card-body mb-1"><!-- *  222222  -->
                <div class="row ">
                    <div class="col-md-8">
                        <label for="name"></label><p>
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th align="center">No.</th>
                                    <th align="center">품명</th>
                                    <th align="center">개소명</th>
                                    <th align="center">규격 W</th>
                                    <th align="center">규격 H</th>
                                    <th align="center">수량</th>
                                    <th align="center">단가</th>
                                    <th align="center">금액</th>
                                </tr>
                            </thead>
                            <tbody>
                        <%
                        %> 
                                <tr>
                                    <td><%=no-i%></td>
                                    <td><%=tname%></td>
                                    <td><%=gtype_text%></td>
                                    <td><%=ttype_text%></td>
                                    <td><%=atitle%></td>
                                    <td><%=tstatus_text%></td>
                                </tr>
                        <%
                        %>
                                </tbody>
                        </table> 
                    </div>
                </div>
            </div>
            <div class="card card-body mb-1"><!-- *  33333333  -->
                <div class="d-flex justify-content-end align-items-center">
                    <label for="name" style="margin-right: 10px; font-size: 20px; font-weight: bold;">공     급     가     총     액</label>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly style="width: 400px;">
                </div>
                <div class="d-flex justify-content-end align-items-center">
                    <label for="name" style="margin-right: 10px; font-size: 20px; font-weight: bold;">세   액 (부  가  가  치  세 )</label>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly style="width: 400px;">
                </div>
                <div class="d-flex justify-content-end align-items-center">
                    <label for="name" style="margin-right: 10px; font-size: 20px; font-weight: bold;">합        계        금        액</label>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly style="width: 400px;">
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
