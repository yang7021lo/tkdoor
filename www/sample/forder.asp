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
projectname="샘플"
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
    <script src="//code.jquery.com/jquery-1.12.0.min.js"></script>


 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left.asp"-->


<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!--화면시작-->
<% if gubun="" then %>




    <div class="py-5 container text-center  card card-body">
<form name="frmMain" action="order.asp" method="post"  >	
<% if gubun="insert" then %> 
<input type="hidden" name="gubun" value="input">
<% elseif gubun="edit" then %>
<input type="hidden" name="gubun" value="update">
<input type="hidden" name="oidx" value="<%=oidx%>">
<input type="hidden" name="ostatus" value="<%=ostatus%>">
<% end if %>
<input type="hidden" name="cidx" value="<%=cidx%>">
<input type="hidden" name="omidx" value="<%=midx%>">
<input type="hidden" name="oftype" value="<%=oftype%>">

<!-- 제목 나오는 부분 시작-->
        <div class="input-group mb-3">
            <h3><%=Year(date())%>.<%=Month(date())%>.<%=Day(date())%>&nbsp;티엔지발주서</h3>
        </div>
<!-- 제목 나오는 부분 끝-->
<!-- 내용 시작-->
          <div class="row">
            <div class="col-6">
<!-- 입력값 시작 -->
 
          

          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="name">검축가로</label>
              <input type="number" class="form-control" id="oinsw" name="oinsw" placeholder="너비(mm)" value="<%=oinsw%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');oinswf();" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">검축높이</label>
              <input type="number" class="form-control" id="oinsh" name="oinsh" placeholder="높이(mm)" value="<%=oinsh%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');oinshf();" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">바닥묻힘</label>
              <input type="number" class="form-control" id="obitg" name="obitg" placeholder="높이(mm)" value="<%=obitg%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');obitgf();" required>
            </div>

          </div>



<!-- 입력값 끝 -->
            </div>  
            <div class="col-6">
<!-- SVG 시작 -->
    <svg width="1000" height="600"  fill="none" stroke="#000000" stroke-width="1" >
        <rect x="80" y="35" width="10" height="300" /><!-- 좌측자동홈바 -->
        <rect x="560" y="35" width="10" height="300" /><!-- 우측자동홈바 -->
        <rect x="300" y="75" width="15" height="265" /><!-- 중간소대 -->
        <rect x="90" y="35" width="470" height="40" /><!-- 상바 -->
        <rect x="90" y="200" width="210" height="40" /><!-- 걸레받이 -->    
        
        <line x1="80" y1="5" x2="80" y2="28" />
        <line x1="80" y1="15" x2="230" y2="15" stroke-dasharray="5" />
        <text x="320" y="20" fill="#000000" font-size="14" text-anchor="middle" >가로외경 :  </text>   
        <text x="360" y="20"  fill="#000000" font-size="14" text-anchor="left"  id="result" >0</text>
        <line x1="570" y1="5" x2="570" y2="28" />
        <line x1="400" y1="15" x2="570" y2="15" stroke-dasharray="5" />

        <line x1="90" y1="55" x2="230" y2="55" stroke-dasharray="5" />
        <text x="260" y="60" fill="#000000" font-size="14" text-anchor="middle" >가로내경 :  </text>   
        <text x="300" y="60"  fill="#000000" font-size="14" text-anchor="left"  id="result1" >0</text>
        <line x1="400" y1="55" x2="550" y2="55" stroke-dasharray="5" />

        <text x="30" y="150" fill="#000000" font-size="14" text-anchor="middle">외경높이</text> 
        <text x="30" y="170"  fill="#000000" font-size="14" text-anchor="middle"  id="kkk" >0</text>

        <text x="30" y="250" fill="#000000" font-size="14" text-anchor="middle">묻힘</text> 
        <text x="30" y="270"  fill="#000000" font-size="14" text-anchor="middle"  id="ggg" >0</text>
 
    </svg>

    
<!-- SVG 시작 -->
            </div> 
    <script>
        $(document).ready(function() {
            $('input').on('input', function() {
                let oinsw = parseFloat($('#oinsw').val()) || 0;
                let oinsh = parseFloat($('#oinsh').val()) || 0;
                let obitg = parseFloat($('#obitg').val()) || 0;
                let sum = oinsw + oinsh;
                let hei = oinsw - 20;
                let kkk = oinsh - obitg;
                let ggg  = obitg;
                $('#result').text(oinsw+'mm');
                $('#result1').text(hei+'mm');
                $('#kkk').text(kkk + 'mm');
                $('#ggg').text(ggg + 'mm');
            });
        });
    </script>
 </form>
             
          </div>
<!-- 내용 끝-->

 
    </div>    
<% elseif gubun="input" then  %>

<% end if %>
<!--화면 끝-->
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 이름
 
<!-- footer 끝 --> 
            </div>
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
