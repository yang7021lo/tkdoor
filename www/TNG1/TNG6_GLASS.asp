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
    <title>티엔지 발주서 (A4 세로)</title>
    <style>
    @page {
        size: A4 portrait; /* 세로 방향 A4 설정 */
        margin: 10mm;
    }

    @media print {
        body {
        margin: 0;
        }

        .print-btn { display: none; } /* 프린트 시 버튼 숨기기 */

        .print-container {
        width: 100%;
        font-size: 12px;
        }

        table {
        width: 100%;
        border-collapse: collapse;
        }

        th, td {
        border: 0.3mm solid #333;
        padding: 0px;
        vertical-align: middle;
        text-align: center;
        }

        .header {
        background-color: #f0f0f0;
        font-weight: bold;
        }

        .highlight {
        background-color: yellow;
        font-weight: bold;
        font-size: 16px;
        }

        .sub-header {
        background-color: #ddd;
        font-weight: bold;
        }

        .left {
        text-align: left;
        }

        .bold {
        font-weight: bold;
        }
    }

    /* 화면 보기용 */
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f9f9f9;
    }

    .print-container {
        width: 800px;
        margin: 0 auto;
        border: 1px solid #333;
        padding: 10px;
        background-color: #fff;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th, td {
        border: 1px solid #333;
        padding: 0px;
        text-align: center;
    }

    .highlight {
        background-color: yellow;
        font-weight: bold;
        font-size: 18px;
    }

    .qr-code {
        width: 80px;
        height: 80px;
        background-color: #eee;
        line-height: 80px;
        margin: 0 auto;
    }

    </style>
</head>
<body>
    <div class="print-container">
        <div class="row ">
            <div class="container mt-1 TEXT-CENTER">
                <button class="print-btn" onclick="window.print()">🖨️[제품라벨 : 100x45] 레이블 프린터 전용 출력하기</button>
            </div>
        </div>
        <div class="header-title">태광도어 티앤지단열프레임 유리치수</div>
        <table>
            <tr>
                <th style="width: 10%;">거래처</th>
                <td colspan="3">전남광주 스마트도어팩토2222222리</td>
                <th style="width: 10%;">재질</th>
                <td>헤어라인1.2</td>
                <th style="width: 10%;">수주번호</th>
                <td>250509_11_10</td>
                <th style="width: 10%;">일자</th>
                <td>2025-03-11</td>
            </tr>
            <tr>
                <th>품명</th>
                <td colspan="3">단열자동프레임22222222</td>
                <th>도장색상</th>
                <td colspan="2">F3185 모던블랙 다크2222222</td>
                <th>현장명</th>
                <td colspan="2">당고개행 긴축공사 SJA_address</td>
            </tr>
        </table>
        <table style="margin-top: 10px;">
            <thead>
                <tr>
                <th rowspan="2">제품번호</th>
                <th colspan="4">검측</th>
                <th colspan="4">도어유리 <br> (6~8T)</th>
                <th colspan="4">픽스유리 <br> (6~24T)</th>
                <th rowspan="2">위치</th>
                </tr>
                <tr>
                <th>가로</th>
                <th>X</th>
                <th>세로</th>
                <th>수량</th>
                <th>가로</th>
                <th>X</th>
                <th>세로</th>
                <th>수량</th>
                <th>가로</th>
                <th>X</th>
                <th>세로</th>
                <th>수량</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                <td rowspan="4">1</td>
                <td rowspan="4">6000</td>
                <td rowspan="4">X</td>
                <td rowspan="4">6000</td>
                <td rowspan="4">1개소</td>
                <td>945</td>
                <td>X</td>
                <td>2310</td>
                <td>1틀</td>
                <td>805</td>
                <td>X</td>
                <td>320</td>
                <td>1장</td>
                <td rowspan="4">1층 행정복지관 1 AD-1 SJA_wichi</td>
                </tr>
                <tr>
                <td>945</td>
                <td>X</td>
                <td>2310</td>
                <td>2틀</td>
                <td>895</td>
                <td>X</td>
                <td>320</td>
                <td>2장</td>
                </tr>
                <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td>432</td>
                <td>X</td>
                <td>2310</td>
                <td>3장</td>
                </tr>
                <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td>432</td>
                <td>X</td>
                <td>320</td>
                <td>4장</td>
                </tr>
            </tbody>
        </table>
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
