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
subgubun="one2"
projectname="절곡 바라시"
%>
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if

    SearchWord=Request("SearchWord")
    gubun=Request("gubun")

    rbfidx=Request("rbfidx") 
    rbaidx=Request("rbaidx") 
    rbasidx=Request("rbasidx") 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
    page_name=" TNG1_JULGOK_IN.asp?bfidx="&bfidx&"&"
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
        .pagination li a {
        min-width: 25px; /* 강제로 최소 너비 설정 */
        padding: 0px 0px; /* 패딩 조정 */
        text-align: center;
        }
    </style>
    <style>
        .left-scroll {
        height: 90vh;
        overflow-y: auto;
        background-color: #f8f9fa;
        border-right: 1px solid #dee2e6;
        }
        .iframe-container {
        border: 1px solid #ccc;
        margin-bottom: 10px;
        height: 45%;
        }
        iframe {
        width: 100%;
        height: 100%;
        border: none;
        }
        .full-iframe {
        height: 100vh;
        border: 1px solid #ccc;
        }
    </style>
    <script>
        document.getElementById("dataForm").addEventListener("keypress", function (event) {
            if (event.key === "Enter") { // Enter 키를 감지
                event.preventDefault(); // 기본 Enter 동작 방지
                document.getElementById("hiddenSubmit").click(); // 폼 제출
            }
        });
        function del(sTR){
            if (confirm("삭제 하시겠습니까?"))
            {
                location.href="TNG1_JULGOK_IN_DB.asp?part=delete&bfidx="+sTR;
            }
        }
    </script>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="card card-body mb-1"><!-- *  11111111111  -->
            <div class="row ">
                <div class="col-md-3">
                    <button class="btn btn-primary btn-small " type="submit" >도면분류등록</button>
                    <button class="btn btn-success btn-small " type="submit" >절곡검색</button>
                    <button class="btn btn-danger btn-small " type="submit" >새도면등록</button>
                </div>
                <div class="col-md-2">
                <input type="text" class="form-control" id="" name="" placeholder="" value="단열 알미늄자동 외도어" >
                </div>
                <div class="col-md-3">
                    <button class="btn btn-primary btn-small " type="submit" >발주입력</button>
                    <button class="btn btn-success btn-small " type="submit" >도면저장</button>
                    <button class="btn btn-danger btn-small " type="submit" >복사저장</button>
                    <button class="btn btn-danger btn-small " type="submit" >도면삭제</button>
                </div>
            </div>
        </div>
        <div class="row ">
            <div class="col-md-3 left-scroll">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <label for="name" class="mb-0">도면분류리스트</label>
                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="location.replace('TNG1_JULGOK_IN.asp?rbfidx=0');">등록</button>
                </div>
                <div class="row justify-content-between">
                    <div>
                        <table id="datatablesSimple"  class="table table-hover" >
                            <thead>
                                <tr>
                                    <th align="center">No</th>
                                    <th align="center">품목</th>
                                    <th align="center">품명</th>
                                </tr>
                            </thead>
                            <tbody>
                                <form id="dataForm" action="TNG1_JULGOK_IN_DB.asp" method="POST">   
                                    <input type="hidden" name="bfidx" value="<%=rbfidx%>">
                                    <% if rbfidx="0" then
                                    cccc="#800080"
                                    %>
                                        <tr bgcolor="<%=cccc%>" >
                                            <td></td>
                                            <td><input class="input-field" type="text"  name="set_name" id="set_name" value="<%=set_name%>" onkeypress="handleKeyPress(event, 'set_name', 'set_name')"/></td>
                                        </tr>
                                    <% end if %>
                                        <%
                                        SQL = "SELECT bfidx, set_name, bfmidx, Convert(varchar(10),bfwdate,121) , bfemidx, Convert(varchar(10),bfewdate,121) " 
                                        SQL=SQL&" FROM tk_barasiF " 
                                        SQL=SQL&" ORDER BY bfidx aSC" 
                                        Rs.open Sql,Dbcon,1,1,1
                                        if not (Rs.EOF or Rs.BOF ) then
                                        Do while not Rs.EOF

                                            bfidx = Rs(0)
                                            set_name = Rs(1)
                                            bfmidx = Rs(2)
                                            bfwdate = Rs(3)
                                            bfemidx = Rs(4)
                                            bfewdate = Rs(5)
                                            i=i+1
                                        %> 
                                    <% if Cint(bfidx)=Cint(rbfidx) then 
                                    cccc="#f1592c"
                                    %>
                                        <tr bgcolor="<%=cccc%>">
                                            <td align="center"><button type="button" class="btn btn-dark" Onclick="del('<%=bfidx%>');"><%=i%></button></td>
                                            <td><input class="input-field" type="text" name="set_name" id="set_name" value="<%=set_name%>" onkeypress="handleKeyPress(event, 'set_name', 'set_name')"/></td>
                                        </tr>
                                    <% else 
                                    cccc="#CCCCCC"
                                    %>
                                        <tr bgcolor="<%=cccc%>">
                                            <td align="center"><%=i%></td>
                                            <td><input class="input-field" type="text" value="<%=set_name%>" onclick="location.replace('TNG1_JULGOK_IN.asp?rbfidx=<%=bfidx%>');"/></td>
                                        </tr>
                                    <% end if %>
                                        <%
                                        Rs.movenext
                                        Loop
                                        End If 
                                        Rs.Close 
                                        %>
                                    <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                                </form>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-md-9 d-flex flex-column" >
                <div class="full-iframe">
                    <iframe name="barasi" src="TNG1_JULGOK_IN_SUB.asp?rbfidx=<%=rbfidx%>&rbaidx=<%=rbaidx%>&rbasidx=<%=rbasidx%>" border="0" ></iframe>
                </div>
                
            </div>
        </div>

</main>                          
Coded By 양양
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
