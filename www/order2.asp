<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/tkdoor/n_inc/dbcon1.asp"-->
<!--#include virtual="/tkdoor/n_inc/cookies.asp"-->
<%
	call dbOpen()
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")
listgubun="two"
subgubun="two2"
 
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="appmgnt.asp?SearchWord="&request("SearchWord")&"&"

gubun=Request("gubun")
projectname="견적서"
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
        <link href="css/styles.css" rel="stylesheet" />
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



    <!-- Custom styles for this template -->
    <link href="sidebars.css" rel="stylesheet">
    </head>
    <body class="sb-nav-fixed">


<!--#include virtual="/tkdoor/inc/top.asp"-->
<!-- -->        

<!--#include virtual="/tkdoor/inc/left2.asp"-->
<!-- -->

            <div id="layoutSidenav_content">
<%
if gubun="" then 
%>            
                <main>
  <div class="album py-5">
    <div class="container">

      <div class="row g-3">
<%
SQL=" Select A.cidx, A.cname, A.caddr1, A.caddr2, A.cpost, A.cmidx, A.cdidx, Convert(varchar(10),A.cwdate,121), A.cnumber "
'SQL=SQL&" , B.mname, C.mname "
SQL=SQL&" From tk_customer A "
'SQL=SQL&" Left Outer Join tk_member B On A.cmidx=B.midx"
'SQL=SQL&" Left Outer Join tk_member C On A.cdidx=B.midx"
If SearchWord<>"" Then 
SQL=SQL&" Where (A.cname  like '%"&request("SearchWord")&"%' or A.caddr1  like '%"&request("SearchWord")&"%' or A.caddr2  like '%"&request("SearchWord")&"%' )"
End If 
SQL=SQL&" Order by A.cwdate desc "
'response.write (SQL)
	Rs.open Sql,Dbcon,1,1,1
	Rs.PageSize = 8

	if not (Rs.EOF or Rs.BOF ) then
	no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
	totalpage=Rs.PageCount '		
	Rs.AbsolutePage =gotopage
	i=1
	for j=1 to Rs.RecordCount 
	if i>Rs.PageSize then exit for end if
	if no-j=0 then exit for end if
	bgcolor="#FFFFFF"
	tempValue=i mod 2
	if tempvalue=1 then bgcolor="#F5F5F5"

  cidx=Rs(0)
  cname=Rs(1)
  caddr1=Rs(2)
  caddr2=Rs(3)
  cpost=Rs(4)
  cmidx=Rs(5)
  cdidx=Rs(6)
  cwdate=Rs(7)
  cnumber=Rs(8)

SQL=" select mname, mpos From tk_member where cidx='"&cdidx&"' "
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
  imname=Rs1(0)
  impos=Rs1(1)
End if
Rs1.Close
%> 
        <div class="col-2">
          <div class="card shadow-sm">
            <div class="card-body">
              <p class="card-text"><%=cname%></p>
              <button type="button" class="btn btn-primary" onclick="location.replace('');">견적</button>
              <button type="button" class="btn btn-secondary" onclick="location.replace('');">수정</button>
            </div>
          </div>
        </div>
<% 
			Rs.MoveNext 
			i=i+1
			Next 
%>
      </div>
      <div class="row">
        <div  class="col-12 py-3"> 
<!--#include Virtual = "/tkdoor/inc/paging.asp" -->
        </div>
      </div>

    </div>
  </div> 
  <%
		End If   
    Rs.Close
%> 
                </main>
 
<% end if %>            
               
 
<!-- footer 시작 -->                
 
<!-- footer 끝 --> 
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
        <script src="assets/demo/chart-area-demo.js"></script>
        <script src="assets/demo/chart-bar-demo.js"></script>
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
