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

    listgubun="two"
    projectname="도장목록"
    SearchWord=Request("SearchWord")
    gubun=Request("gubun")


	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="paintmgntlist.asp?listgubun="&listgubun&"&"


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
<!-- 내용 입력 시작 -->  
    <div class="container py-1 text-center">
        <div class="input-group mb-2">
            <div class="col-12 text-end mb-2">
                <button type="button" class="btn btn-outline-danger" Onclick="location.replace('paintmgnt.asp');">품목등록</button>  
            </div>
            <div class="card mb-4 card-body">
                <table class="table">
                    <thead>
                    <tr>
                    <th scope="col">#</th>
                    <th scope="col">품명</th>

                    <th scope="col">사용</th>                           
                    <th scope="col">작성자</th>
                    <th scope="col">작성일시</th>
                    <th scope="col">수정자</th>
                    <th scope="col">수정일시</th>
                    </tr>
                    
                    <tbody class="table-group-divider">
<%

OES=" select A.pidx, A.pname, A.pstatus, A.pmidx, B.mname, A.pwdate, A.pemidx, C.mname, A.pewdate "
OES=OES&" From tk_paint A "
OES=OES&" Join tk_member B On A.pmidx=B.midx "
OES=OES&" Left Outer Join tk_member C On A.pemidx=C.midx "
If Request("SearchWord")<>"" Then
OES=OES &" Where (A.pname like '%"&request("SearchWord")&"%' or B.mname like '%"&request("SearchWord")&"%'   or C.mname like '%"&request("SearchWord")&"%') "
End If
OES=OES &" Order by pidx desc "
'response.write (OES)&"<br>"
Rs.open OES,Dbcon,1,1,1
Rs.PageSize = 10                     

if not (Rs.EOF or Rs.BOF ) then
no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) +1
totalpage=Rs.PageCount
Rs.AbsolutePage =gotopage
i=1
for j=i to Rs.RecordCount
if i>Rs.PageSize then exit for end if
if no=j-0 then exit for end if

pidx=Rs(0) 
pname=Rs(1)
pstatus=Rs(2)
pmidx=Rs(3)
mname=Rs(4)
pwdate=Rs(5)
pemidx=Rs(6)
emname=Rs(7)
pewdate=Rs(8)

select case pstatus
    case "0"
        pstatus_text="사용안함"
    case "1"
        pstatus_text="사용중"
end select 
%>

    <tr>
        <th><%=no-j%></th>
        <td><a href="paintmgntudt.asp?pidx=<%=pidx%>"><%=pname%></a></td>
        <td>



<div class="form-check form-switch">
  <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckChecked" <% if pstatus="1" then %>checked<% end if%>>
  <label class="form-check-label" for="flexSwitchCheckChecked"></label>
</div>




        </td>
        <td><%=mname%></td>
        <td><%=pwdate%></td>
        <td><%=emname%></td>
        <td><%=pewdate%></td>
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
    <!--#include Virtual = "/inc/paging.asp"-->
    
            </div>
        </div> 
    </div>  








<!-- 내용입력 끝 -->
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
