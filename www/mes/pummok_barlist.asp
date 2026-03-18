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
    subgubun="one2"
    projectname="품목관리"
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

rgoidx=Request("rgoidx")    '품목 키
rsidx=Request("rsidx")  '규격키
rgoidx=Request("rgoidx")
rsidx=Request("rsidx")
rbuidx=Request("rbuidx")
smidx=Request("smidx")
baridx=Request("baridx")
barNAME=Request("barNAME")
goname=Request("goname")

'Response.write "rgoidx;"&rgoidx&"<br>"
'Response.write "rsidx;"&rsidx&"<br>"
'Response.write "rbuidx;"&rbuidx&"<br>"
'Response.write "smidx;"&smidx&"<br>"
'Response.write "baridx;"&baridx&"<br>"
'Response.write "barNAME;"&barNAME&"<br>"
'Response.write "goname;"&goname&"<br>"
'response.end



if rgoidx="" then rgoidx="0" end if 


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
  /* 왼쪽 여백 제거 */
  body {
      zoom: 0.8;
      margin: 0; /* 기본 여백 제거 */
      padding: 0;
  }

  /* 컨테이너 플루이드 스타일 수정 */
  .container-fluid {
      padding: 0 !important; /* 패딩 제거 */
  }

  /* 레이아웃 중앙 정렬 */
  #layoutSidenav_content {
      margin: 0 auto;
      width: 100%;
  }

  /* Iframe 내부 스타일 수정 */
  iframe {
      border: 0;
      width: 100%; /* 화면에 꽉 차게 설정 */
      height: 100%;
  }

  /* 카드 스타일 수정 */
  .card {
      margin: 0 !important; /* 카드의 여백 제거 */
      padding: 0 !important; /* 카드의 패딩 제거 */
  }

  .row {
      margin: 0 !important; /* 카드 내부의 row 여백 제거 */
      padding: 0 !important; /* 카드 내부의 row 패딩 제거 */
  }
</style>
    <script>

    function toggleAllCheckboxes(source) {
        const checkboxes = document.querySelectorAll('.rowCheckbox');
        checkboxes.forEach(checkbox => checkbox.checked = source.checked);
    }
    function del(rsidx)
    {
      if (confirm("공정구성까지 삭제할까요?"))
      {
        location.href="delete_stand.asp?rgoidx=<%=rgoidx%>&rsidx="+rsidx;
      }
    }
     function del1(smidx)
    {
      if (confirm("정말 삭제할까요?"))
      {
        location.href="delete_material.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>&smidx="+smidx;
      }
    }
    del1
</script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_pummok.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
<!-- 내용 입력 시작 -->  
                <div class="row card mb-2" style="height:500px;">
                    <iframe name="hide" width="100%" height="100%" src="/barlist_item.asp" border="0"></iframe> 
                </div>
            <div class="col-12 card"> 
                <div class="row card mb-2" style="height:600px;">
                <iframe name="hide" width="100%" height="100%" src="/barlist_itemin.asp" border="0"></iframe> 
                </div>
            </div>
<!-- 내용입력 끝 -->
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
