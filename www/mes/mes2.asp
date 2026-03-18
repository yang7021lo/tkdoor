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
projectname="MES2"
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
    <script>

    </script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_mes2.asp"-->


<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between">
<!-- 내용 입력 시작 --> 
  
            <div class="col-11">
                <div class="row card mb-2" style="height:100%;">
                    <iframe name="hide" width="100%" height="100%" src="/appmgnt.asp" border="0"></iframe>
                </div>
            <div class="row " >
                <div class="col-2 card">
<!-- 표 부속자재 형식 시작--> 
                    <div class="mt-1"><h5>부속자재</h5></div>
                        <iframe name="hide" width="100%" height="300" src="/busok.asp" border="0"></iframe>  
<!-- 표 부속자재 형식 끝--> 
                </div>
                <div class="col-10 card">
<!-- 표 형식 시작--> 
                    <div class="mt-1"><h5>공정구성</h5></div>
                    <div class="input-group mb-3">
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th align="center"><input type="checkbox" name=""></th>                  
                                    <th align="center">순번</th>
                                    <th align="center">구분</th>
                                    <th align="center">공정</th>
                                    <th align="center">품명</th>
                                    <th align="center">AL</th>
                                    <th align="center">수량(AL)</th>
                                    <th align="center">ST</th>  
                                    <th align="center">수량(ST)</th>
                                    <th align="center">유리</th>
                                    <th align="center">격자</th>
                                    <th align="center">비고</th>
                                    <th align="center">결합제외여부</th>
                                    <th align="center">작성자</th>
                                    <th align="center">작성일시</th>
                                    <th align="center">수정자</th>
                                    <th align="center">수정일시</th>                      
                                </tr>
                            </thead>
                            <tbody>
<%
for i = 1 to 3
%>              
                                <tr>
                                    <td><input type="checkbox" name=""></td>
                                    <td><%=i%></td>
                                    <td>값2</td>
                                    <td>값3</td>
                                    <td>값4</td>
                                    <td>값5</td>
                                    <td>값6</td>
                                    <td>값7</td>
                                    <td>값8</td>
                                    <td>값4</td>
                                    <td>값5</td>      
                                    <td>값3</td>
                                    <td>값4</td>
                                    <td>값5</td> 
                                    <td>값3</td>
                                    <td>값4</td>
                                    <td>값5</td>                       
                                </tr>
<%
next
%>
                            </tbody>
                        </table>
                    </div>
<!-- 표 형식 끝--> 
                </div>
            </div>
        </div>
            <div class="col-1" >
                <div class="row card" style="height:300;">
<!-- 표 형식 시작--> 
                    <div class="input-group mb-3">
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th align="center">사용규격</th>
                                </tr>
                            </thead>
                            <tbody>
<%
for i = 1 to 2
%>              
                                <tr>
                                    <td><%=i%></td>
                                </tr>
<%
next
%>
                            </tbody>
                        </table>
                    </div>
<!-- 표 형식 끝--> 
                </div>
                <div class="row card" > 
                <!-- 표 형식 시작--> 
                <iframe name="hide"  height="550" src="/barlist.asp" border="0"></iframe>  
                <!-- 표 형식 끝--> 
                </div>
            </div>









<!-- 내용입력 끝 -->
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

%>
<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
