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
 
projectname="발주서 출력"
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
            font-size: 8px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 5px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
    </style>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
            <div class="card card-body mb-1"><!-- * 출력화면 불러오기 11111111111  -->
                <div class="row ">
                    <div class="col-md-2">
                    <label for="name">거래처</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" >
                    </div>
                    <div class="col-md-2">
                    <label for="name">사업장</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div> 
                    <div class="col-md-1">
                    <label for="name">TEL</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div> 
                    <div class="col-md-1">
                    <label for="name">FAX</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div> 
                    <div class="col-md-2">
                    <label for="name">비고</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div>
                    <div class="col-md-2">
                    <label for="name">참고사항</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div>
                </div>
            </div><!-- * 거래처 불러오기 11111111111  -->
            <div class="card card-body mb-1">  <!-- * 수주일자 2222222222222222222222222222  -->
                <div class="row ">
                    <div class="col-md-1">
                        <label for="name">수주일자</label><p>
                        <input type="date" class="form-control" id="" name="" placeholder="" value="" >
                    </div>
                    <div class="col-md-1">
                        <label for="name">수주번호</label><p>
                        <select name="" class="form-control" id="" required>
                            <option value="">0001</option>
                            <option value="">0002</option>
                            <option value="">0003</option>
                            <option value="">0004</option>
                        </select>
                    </div> 
                    <div class="col-md-1">
                        <label for="name">출고일자</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_chulgodate"  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">도장출고일자</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_chulgodate"  readonly>
                    </div>  
                    <div class="col-md-1">
                        <label for="name">출고방식</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_chulgo"  readonly>
                    </div>
                    <div class="col-md-2">
                        <label for="name">현장명</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_address" readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">입금후출고 설정</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name"> 업체담당자명</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_hjcname2" readonly>
                    </div>
                        <div class="col-md-1">
                        <label for="name">업체담당자 TEL</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_hjctel1"  readonly>
                    </div>
                </div>
            </div>    
            <div class="card card-body mb-1">  <!-- * 견적  /  품목선택 -->
                <div class="row ">
                    <div class="col-md-1">
                        <label for="name">품번번호</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">품목</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">스텐재질</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongmoney_yn" readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">도장색상</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongmoney_yn" readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">위치</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_wichi"  readonly>
                    </div> 
                    <div class="col-md-1">
                        <label for="name">비고1</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_bigo1"  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">추가사항1</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_meno1" readonly>
                    </div>
                </div>    
            </div> 
            <div class="card card-body mb-1">  <!-- * 용차 선택 -->    
                <div class="row ">
                    <div class="col-md-1">
                    <label for="name">용차받는분</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongname"  readonly>
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차받는전화</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongtel" readonly>
                    </div>
                    <div class="col-md-2">
                    <label for="name">용차주소</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongaddress"  readonly>
                    </div> 
                    <div class="col-md-1">
                    <label for="name">용차도착일자/시간</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongdate"  readonly>
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차당부사항</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차차대번호</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongchanumber" readonly>
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차기사번호</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongtel_gisa"  readonly>
                    </div> 
                    <div class="col-md-1">
                    <label for="name">용차착불yn</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongmoney_yn" readonly>
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차 선불금액</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongmoney"  readonly>
                    </div> 
                </div>
            </div>
            <div class="card card-body mb-1">  <!-- * 화물 선택 -->    
                <div class="row ">
                    <div class="col-md-1">
                        <label for="name">대신화물지점</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="팝업창 화물검색"  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">박스포장 수량</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value=" "  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">화물당부사항</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value=" "  readonly>
                    </div>
                </div>
            </div>
            <div class="row card mb-1" style="height:500px;">
              <iframe name="goods" width="100%" height="100%" src="/sample/barasik.asp?rbaidx=<%=rbaidx%>" border="0" scrolling="none"></iframe>
            </div>
        </div>
    </div>
</main>                          
                <!-- footer 시작 -->    
                Coded By 양양
                <!-- footer 끝 --> 
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
