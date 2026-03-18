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

If c_midx="" then 
Response.write "<script>alert('로그인 하세요.');location.replace('/index.asp');</script>"

End If

    listgubun="one"
    projectname="회원관리-목록"
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
	page_name="memlist.asp?SearchWord="&SearchWord&"&"


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
<!--#include virtual="/inc/left_cyj.asp"-->


<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!--화면시작-->

    <div class="py-5 container text-center  card card-body">
<!-- 버튼 형식 시작--> 
<!--
        <div class="row">
            <div class="col-10">&nbsp;
            </div>
            <div class="col-2 text-end ">
                <button type="button" class="btn btn-outline-danger" Onclick="location.replace('mem.asp');">사용자등록</button>    
            </div>
        </div>
-->
<!-- 버튼 형식 끝--> 
<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">번호</th>
                      <th align="center">회사</th>
                      <th align="center">이름</th>
                      <th align="center">직책</th>
                      <th align="center">전화번호</th>
                      <th align="center">핸드폰</th>
                      <th align="center">팩스</th>
                      <th align="center">메일</th>
                      <th align="center">등록일</th>  
                      <th align="center">수정자</th>  
                      <th align="center">수정일</th>  
                      <th align="center">관리</th> 
                  </tr>
              </thead>
              <tbody>
<%
SQL=" Select B.cidx, B.cname , A.midx, A.mname, A.mpos, A.mtel, A.mhp, A.mfax, A.memail, Convert(varchar(10),A.mwdate,121) "
SQL=SQL&" , Convert(varchar(10),A.udate,121), C.mname "
SQL=SQL&" from tk_member A "
SQL=SQL&" Join tk_customer B On A.cidx=B.cidx "
SQL=SQL&" Left Outer Join tk_member C On A.umidx=C.midx "
SQL=SQL&" Order by A.mwdate DESC "
If rsearchword <> "" Then
    SQL = SQL & " AND ("
    SQL = SQL & " B.cname LIKE '%" & rsearchword & "%' "
    SQL = SQL & " A.mname LIKE '%" & rsearchword & "%' "
    SQL = SQL & " A.mtel LIKE '%" & rsearchword & "%' "
    SQL = SQL & " A.mhp LIKE '%" & rsearchword & "%' "
    SQL = SQL & " A.memail LIKE '%" & rsearchword & "%' "
    SQL = SQL & " A.mfax LIKE '%" & rsearchword & "%' "
    SQL = SQL & ") "
End If

Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 10                     

if not (Rs.EOF or Rs.BOF ) then
no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) +1
totalpage=Rs.PageCount
Rs.AbsolutePage =gotopage
i=1
for j=i to Rs.RecordCount
if i>Rs.PageSize then exit for end if
if no=j-0 then exit for end if

cidx=Rs(0)
cname=Rs(1)
midx=Rs(2)
mname=Rs(3)
mpos=Rs(4)
mtel=Rs(5)
mhp=Rs(6)
mfax=Rs(7)
memail=Rs(8)
mwdate=Rs(9)
udate=Rs(10)
cmname=Rs(11)
%>


                  <tr>
                      <td><%=no-j%></td>
                      <td><%=cname%></td>
                      <td><%=mname%></td>
                      <td><%=mpos%></td>
                      <td><%=mtel%></td>
                      <td><%=mhp%></td>
                      <td><%=mfax%></td>
                      <td><%=memail%></td>
                      <td><%=mwdate%></td>
                      <td><%=cmname%></td>
                      <td><%=udate%></td>
                      <td><button type="button" class="btn btn-primary" onClick="location.replace('memview.asp?cidx=<%=cidx%>&midx=<%=midx%>')">관리</button></td>
                  </tr>
<%
    Rs.MoveNext
    i=i+1
    Next
    End If
%>
              </tbody>
          </table>
        </div>
        <div class="row col-12 py-3">
<!--#include Virtual = "/inc/paging1.asp"-->
        </div>
<%
    Rs.close
%>
<!-- 표 형식 끝--> 

 
    </div>    

    <!--화면 끝-->
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 오소리
 
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
