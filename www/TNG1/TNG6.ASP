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

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 

listgubun="one"

projectname="작업의뢰등록"
%>

<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function

rbaidx=Request("rbaidx")
rbasidx=Request("rbasidx")
part=Request("part")

rmidx=Request("rmidx")

SQL="select midx "
SQL=SQL&" from tk_member "
Rs.open Sql,Dbcon,1,1,1
    if not (Rs.EOF or Rs.BOF ) then
        midx=Rs(0)
    end if 
rs.close       

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
    </style>

</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->


<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
            <div class="card card-body mb-1">
                <div class="row ">
                    <div class="col-md-1">
                    <label for="name">일자</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" >
                    </div>
                    <div class="col-md-1">
                    <label for="name">수주내역불러오기</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="선택" value="<%%>" style="background-color: YELLOW; color: RED;"
                    onclick="window.open('TNG6_1.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>','_blank','width=1500  , height=1000, top=200, left=500' );">
                    </div>
                    <div class="col-md-1">
                    <label for="name">긴급</label><p>
                    <select name="" class="form-control" id="" required>
                        <option value="">일반</option>
                        <option value="">긴급</option>
                        <option value="">초긴급</option>
                        <option value="">재작업</option>
                    </select>
                    </div> 
                    <div class="col-md-1">
                    <label for="name">의뢰번호</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div> 
                    <div class="col-md-1">
                    <label for="name">의뢰번호 수정</label><p>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div> 
                    <div class="col-md-1">
                    <label for="name">상태</label><p>
                    <select name="" class="form-control" id="" required>
                        <option value="">검토</option>
                        <option value="">확정</option>
                    </select>
                    </div> 
                    <div class="col-md-4">
                        <label for="name">인쇄</label><p>
                        <button class="btn btn-dark btn-small " type="submit" 
                        onclick="window.open('TNG6_LABEL.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>','_blank','width=1500  , height=1000, top=200, left=500' );">라벨인쇄</button>
                        <button class="btn btn-dark btn-small " type="submit" 
                        onclick="window.open('TNG6_JULGOK.asp?cidx=<%=rcidx%>&baidx=<%=rbaidx%>&rmidx=<%=midx%>','_blank','width=1500  , height=1000, top=200, left=500' );">스텐발주서_인쇄</button>
                        <button class="btn btn-dark btn-small " type="submit" 
                        onclick="window.open('TNG6_AL.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>','_blank','width=1500  , height=1000, top=200, left=500' );">AL발주서_인쇄</button>
                        <button class="btn btn-dark btn-small " type="submit" 
                        onclick="window.open('TNG6_GLASS.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>','_blank','width=1500  , height=1000, top=200, left=500' );">유리_인쇄</button>
                    </div>
                </div>
            </div>
            <div class="card card-body mb-1">
                <div class="row ">
                    <div class="col-md-12">
                        <label for="name">작업의뢰등록</label><p>
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th align="center">체크박스</th>
                                    <th align="center">번호</th>
                                    <th align="center">거래처</th>
                                    <th align="center">현장</th>
                                    <th align="center">품명</th>
                                    <th align="center">규격 W</th>
                                    <th align="center">규격 H</th>
                                    <th align="center">수량</th>
                                    <th align="center">스텐_인쇄</th>
                                    <th align="center">AL_인쇄</th>
                                    <th align="center">라벨_인쇄</th>
                                    <th align="center">유리_인쇄</th>
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
                                </tr>
                                <%
                                %>
                            </tbody>
                        </table> 
                    </div>
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

%>
<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
