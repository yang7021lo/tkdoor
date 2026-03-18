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




    <div class="py-5 container text-center  card card-body">
<form name="frmMain" action="TNG_SJst2.asp" method="post"  >	

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
              <label for="name">시작x</label>
              <input type="number" class="form-control" id="SJst_vc_1" name="SJst_vc_1" placeholder="시작x" value="<%=SJst_vc_1%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');SJst_vc_1f();" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">시작y</label>
              <input type="number" class="form-control" id="SJst_wc_1" name="SJst_wc_1" placeholder="시작y" value="<%=SJst_wc_1%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');SJst_wc_1f();" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">끝x</label>
              <input type="number" class="form-control" id="SJst_r" name="SJst_r" placeholder="끝x" value="<%=SJst_r%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');SJst_rf();" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">끝y</label>
              <input type="number" class="form-control" id="SJst_l" name="SJst_l" placeholder="끝y" value="<%=SJst_l%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');SJst_lf();" required>
            </div>

          </div>



<!-- 입력값 끝 -->
            </div>  
            <div class="col-6">
<!-- SVG 시작 -->
<%
    SQL=" select SJst2_IDX,SJst_vc_last,SJst_vc_1,SJst_wc_1,SJst_r,SJst_l "
    SQL=SQL&" from TNG_SJst2  "
    SQL=SQL&" order by SJst2_IDX desc "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do until Rs.EOF
        SJst2_IDX=Rs(0)
        SJst_vc_last=Rs(1)
        SJst_vc_1=Rs(2)
        SJst_wc_1=Rs(3)
        SJst_r=Rs(4)
        SJst_l=Rs(5)
        i=i+1
%> 
    <svg width="1000" height="600"  fill="none" stroke="#000000" stroke-width="5" >
       
        
        <line x1="0" y1="0" x2="0" y2="40" /> <!--  시작 점-->
        <line x1="<%=SJst_vc_1%>" y1="<%=SJst_wc_1%>" x2="<%=SJst_r%>" y2="<%=SJst_l%>" /> <!--  시작 점-->
        <line x1="200" y1="5" x2="200" y2="10" />

    </svg>

    <%
    Rs.MoveNext
    Loop
    End If
    Rs.close
    %>
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
