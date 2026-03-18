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
    <title>레이블 프린터 전용 출력</title>
        <style>
        @page {
            size: 100mm 45mm;  /* 기본 페이지 크기를 도어라벨로 설정 */
            margin: 0;          /* 여백 제거 */
        }

        @media print {
            body {
            margin: 0;
            padding: 0;
            }
            .print-btn { display: none; } /* 프린트 시 버튼 숨기기 */    
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .label {
            width: 100mm;
            height: 45mm;
            box-sizing: border-box;
            padding: 0mm;
            border: 0.3mm solid #000;
        }

        table {
            width: 100%;
            height: 100%;
            font-size: 3mm;
            table-layout: fixed;
            border-collapse: collapse;
        }

        th, td {
            border: 0.1mm solid #000;
            padding: 0mm;
            text-align: left;
            vertical-align: middle;
        }

        .qr-code {
            background-color: #eee;
            text-align: center;
            line-height: 20mm;
            font-size: 2.5mm;
            display: inline-block;
        }
        .center {
        text-align: center;
        }
    </style>
</head>
<body>
    <div class="row ">
        <div class="container mt-1 TEXT-CENTER">
            <button class="print-btn" onclick="window.print()">🖨️[제품라벨 : 100x45] 레이블 프린터 전용 출력하기</button>
        </div>
    </div>
    <div class="row ">
        <div class="label-box"  style="width: 400px; border-collapse: collapse;">
            <table>
                <tbody>
                    <tr>
                        <th style="width: 15%;">거래처</th>
                        <td colspan="3">전남광주 스마트도어팩토2222222리</td>
                        <th style="width: 15%;">수주번호</th>
                        <td colspan="3">250509_11_10</td>
                        <th rowspan="2" style="width: 10%;">제품 번호</th>
                        <td rowspan="2">11번</td>
                    </tr>
                    <tr>
                        <th>품명</th>
                            <td colspan="3">단열자동프레임22222222</td>
                        <th >검측</th>
                            <td colspan="3" class="center" >11500 x 22550</td>
                    </tr>
                    <tr>
                        <th>재질</th>
                            <td colspan="3">헤어라인1.2</td>
                        <th>도장색상</th>
                            <td colspan="3">F3185 모던블랙 다크2222222</td>
                        <th>수량</th>
                            <td>1</td>
                    </tr>
                    <tr>
                        <th>현장명</th>
                            <td colspan="6">당고개행 긴축공사 SJA_address</td>
                            <td rowspan="3" colspan="3" class="center">
                                <div class="qr-code">QR 이미지</div>
                            </td>
                    </tr>
                    <tr>
                        <th>위치</th>
                            <td colspan="6">1층 행정복지관 1 AD-1 SJA_wichi</td>
                    </tr>
                    <tr>
                        <th>비고</th>
                            <td colspan="6">월요일 아침에 꼭 받아야해요</td>
                    </tr>
                </tbody>
            </table>
        </div>
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
