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
 
projectname="발주 및 견적"
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
    <style>
    .button-container {
        position: relative;
        display: inline-block;
    }

    .label-text {
        position: absolute;
        top: -20px; /* 글씨를 위로 이동 */
        left: 50%;
        transform: translateX(-50%); /* 중앙 정렬 */
        background-color: rgba(0, 0, 0, 0.7); /* 반투명 검은 배경 */
        color: white;
        padding: 5px 10px;
        border-radius: 5px;
        font-weight: bold;
        font-size: 15px;
        white-space: nowrap; /* 글자가 줄바꿈되지 않도록 설정 */
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
            <div class="card card-body mb-0 col-md-4"><!-- *  11111111111  -->
                <div class="card card-body mb-0" style="border: 2px solid black;">
                    <div class="row ">
                        <div class="row ">
                            <div class="col-md-3">
                            <label for="name">수량</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_QY" >
                            </div>
                            <div class="col-md-3">
                            <label for="name">도어같이_유무</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_YN" >
                            </div>
                            <div class="col-md-3">
                            <label for="name">도어유리두께</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="TK_GLASS(TB)" >
                            </div>
                            <div class="col-md-3">
                            <label for="name">픽스유리두께</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="TK_GLASS(TB)" >
                            </div>
                        </div>
                        <div class="row">    
                            <div class="col-md-3">
                            <label for="name">검측가로</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_FW" >
                            </div>
                            <div class="col-md-3">
                            <label for="name">검측세로</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_FH" >
                            </div> 
                            <div class="col-md-3">
                            <label for="name">바닥묻힘(FL)</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_FL" >
                            </div> 
                            <div class="col-md-3">
                            <label for="name">오픈</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_OP" >
                            </div> 
                        </div>
                        <div class="row ">
                            <div class="col-md-3">
                            <label for="name">도어 검측 높이</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_DFL" >
                            </div> 
                            <div class="col-md-3">
                            <label for="name">박스 위 라인</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_BOXFL" >
                            </div>
                            <div class="col-md-3">
                            <label for="name">상부 남마 내경</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_up" >
                            </div>      
                        </div>
                        <div class="row ">
                            <div class="col-md-4">
                                <label for="name" style="font-size: 20px; font-weight: bold;">필수입력</label>
                            </div>
                        </div>
                        <div class="row ">
                            <div class="col-md-4">
                                <button class="btn btn-primary btn-small " type="submit" >수정</button>
                                <button class="btn btn-success btn-small " type="submit" >저장</button>
                                <button class="btn btn-danger btn-small " type="submit" >삭제</button>
                            </div>
                        </div> 
                    </div>
                </div>
                <div class="card card-body mb-0" style="border: 2px solid black;">
                    <div class="row ">
                        <div class="row ">
                            <div class="col-md-3">
                            <label for="name">도어_가로줄이기</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_D_W" >
                            </div> 
                            <div class="col-md-3">
                            <label for="name">도어_높이줄이기</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_D_H" >
                            </div> 
                            <div class="col-md-3">
                            <label for="name">하바분할픽스내경</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_D_H" >
                            </div> 
                            <div class="col-md-3">
                            <label for="name">양개언발란스_하바치수</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_D_HD" >
                            </div>
                        </div>
                        <div class="row ">
                            <div class="col-md-3">
                            <label for="name">외부방향(좌/우)</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_LR" >
                            </div>
                        </div>
                        <div class="row ">
                            <div class="col-md-4">
                                <label for="name" style="font-size: 20px; font-weight: bold;">추가옵션</label>
                            </div>
                        </div>
                        <div class="row ">
                            <div class="col-md-4">
                                <button class="btn btn-primary btn-small " type="submit" >수정</button>
                                <button class="btn btn-success btn-small " type="submit" >저장</button>
                                <button class="btn btn-danger btn-small " type="submit" >삭제</button>
                            </div>
                        </div> 
                    </div>
                </div>
                <div class="card card-body mb-0" style="border: 2px solid black;">
                    <div class="row ">
                        <div class="row ">
                            <div class="col-md-3">
                            <label for="name">단가</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_P_DANGA" >
                            </div>
                            <div class="col-md-3">
                            <label for="name">단가할인율</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_P_DC" >
                            </div>
                            <div class="col-md-3">
                            <label for="name">도어제외금액</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_P_DANGA_DX" >
                            </div>
                            <div class="col-md-3">
                            <label for="name">총금액(부가세별도)</label><p>
                            <input type="text" class="form-control" id="" name="" placeholder="" value="T_P_CHONG" >
                            </div>
                            <div class="col-md-4">
                                <label for="name" style="font-size: 20px; font-weight: bold;">가격전송</label>
                            </div>
                        </div>
                        <div class="row ">
                            <div class="col-md-4">
                                <button class="btn btn-primary btn-small " type="submit" >수정</button>
                                <button class="btn btn-success btn-small " type="submit" >저장</button>
                                <button class="btn btn-danger btn-small " type="submit" >삭제</button>
                            </div>
                        </div>       
                    </div>
                </div>
            </div>
            <div class="card card-body mb-0 col-md-8" style="border: 2px solid black;"><!-- * 2222  -->
                <div class="row ">
                    <div class="col-md-1">
                        <label for="name" style="font-size: 20px; font-weight: bold;"></label><P>
                    </div>
                    <div class="col-md-12">
                        <button class="btn btn-secondary btn-sm button-container" type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD.asp')">
                            <span class="label-text">외도어</span>
                            <img id="image1" src="/img/frame/CAD_AL/al4.jpg" alt="기본" class="img-fluid" style="width: 200px;; height: auto;">
                        </button>
                        <button class="btn btn-secondary btn-sm button-container" type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD.asp')">
                            <span class="label-text">외도어 상부남마</span>
                            <img id="image1" src="/img/frame/CAD_AL/al2.jpg" alt="기본" class="img-fluid" style="width: 200px; height: auto;">
                        </button>
                        <button class="btn btn-secondary btn-sm button-container" type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD.asp')">
                            <span class="label-text">외도어 상부남마 중간소대</span>
                            <img id="image1" src="/img/frame/CAD_AL/al3.jpg" alt="기본" class="img-fluid" style="width: 200px; height: auto;">
                        </button>
                        <button class="btn btn-secondary btn-sm button-container" type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD.asp')">
                            <span class="label-text">양개</span>
                            <img id="image1" src="/img/frame/CAD_AL/al4.jpg" alt="기본" class="img-fluid" style="width: 200px; height: auto;">
                        </button>
                        <button class="btn btn-secondary btn-sm button-container" type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD.asp')">
                            <span class="label-text">양개 상부남마</span>
                            <img id="image1" src="/img/frame/CAD_AL/al1.jpg" alt="기본" class="img-fluid" style="width: 200px; height: auto;">
                        </button>
                        <button class="btn btn-secondary btn-sm button-container" type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD.asp')">
                            <span class="label-text">양개 상부남마 중간소대</span>
                            <img id="image1" src="/img/frame/CAD_AL/al1.jpg" alt="기본" class="img-fluid" style="width: 200px; height: auto;">
                        </button>
                    </div>
                    <div class="col-md-12">
                        <button class="btn btn-danger btn-small " type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD.asp')" >기본 타입</button>
                        <button class="btn btn-DARK btn-small " type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD_1.asp')" >인서트 타입(T형)</button>
                        <button class="btn btn-DARK btn-small " type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD_2.asp')" >픽스바 없는 타입</button>
                        <button class="btn btn-DARK btn-small " type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD_3.asp')" >자동홈바 없는 타입</button>
                        <button class="btn btn-INFO btn-small " type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD_4.asp')" >기본타입_하부픽스분할</button>
                        <button class="btn btn-INFO btn-small " type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD_5.asp')" >인서트 타입(T형)_하부픽스분할</button>
                        <button class="btn btn-INFO btn-small " type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD_6.asp')" >픽스바 없는 타입_하부픽스분할</button>
                        <button class="btn btn-INFO btn-small " type="button" onClick="location.replace('/TNG1/TNG1_N_12t_AD_7.asp')" >자동홈바 없는 타입_하부픽스분할</button>
                    </div>
                </div>
                
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
