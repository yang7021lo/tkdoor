
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

    listgubun="two"   '왼쪽 메뉴
    projectname="자재관리-목록" '페이지제목
%>
 
<%
    function encodestr(str)
        if str = "" then exit function
        str = replace(str,chr(34),"&#34") ' 큰따옴표(`"`)를 HTML 엔터티(`&#34`)로 변환
        str = replace(str,"'","''")  ' 작은따옴표(`'`)를 이스케이프(`''`) 처리 (SQL 인젝션 방지 목적)
        encodestr = str
    end Function
'23~28작음따음표 방지 코드'
order_dept=Request("order_dept")    '전달받은 부서코드 변수 order_dept에 저장하기'
SearchWord=Request("SearchWord")
gubun=Request("gubun")

if request("gotopage")="" then
    gotopage=1
else
    gotopage=request("gotopage")
end if

page_name="khorderlist.asp?listgubun="&listgubun&"&order_dept="&order_dept&"&SearchWord="&SearchWord&"&"



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
<!--#include virtual="/inc/left.asp"-->


<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid py-1 px-4">
     <div class="row">
        <div class="col-12 text-end mb-2">
            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="khorderlist.asp" name="form1">    
                <input type="hidden" name="order_idx" value="<%=order_idx%>"> 
                <div class="py-1 container text-center card card-body">
                    <h3>자재 목록</h3> 
                        <div class="input-group">
                          <input class="form-control" type="text" placeholder="자재조회" aria-label="자재조회" aria-describedby="btnNavbarSearch" name="SearchWord" />
                          <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i></button>
                          <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorderlist.asp?order_dept=1');">도어</button>
                          <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorderlist.asp?order_dept=2');">프레임</button>
                          <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorderlist.asp?order_dept=3');">시스템도어</button>
                          <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorderlist.asp?order_dept=4');">자동문</button>
                          <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorderlist.asp?order_dept=5');">보호대</button>
                          <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorderlist.asp?order_dept=6');">기타</button>
                        </div>
                </div>        
            </form>  
  <button type="button" class="btn btn-outline-danger" Onclick="location.replace('khorder.asp');">자재등록</button>   
        </div>
    </div>   
   <div class="row justify-content-between">
<!--화면시작-->

    <div class="py-1 container text-center  card card-body">
            
<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">번호</th>
                      <th align="center">부서</th>
                      <th align="center">자재명</th>
                      <th align="center">자재길이</th>
                      <th align="center">재질</th>
                      <th align="center">단중</th>
                      <th align="center">사용여부</th>
                      <th align="center">등록일</th>
                      <th align="center">종료일</th>
                      <th align="center">관리</th>  
                  </tr>
              </thead>
              <tbody>
<%
SearchWord=request("SearchWord")



SQL=" Select order_idx, order_name, order_length, order_type, kg_m, Convert(varchar(10),order_date,121), order_status , order_fdate , order_dept"
SQL=SQL&" From tk_khyorder "
SQL=SQL&" where order_name<>'' "
If Request("SearchWord")<>"" Then
SQL=SQL &" and order_name like '%"&SearchWord&"%'" 
End If
if Request("order_dept")<>"" Then
SQL=SQL&" and order_dept='"&request("order_dept")&"'"
end if
SQL=SQL&" Order by order_idx desc "
'Response.write (sql)
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 6

if not (Rs.EOF or Rs.BOF ) then
no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
totalpage=Rs.PageCount '
Rs.AbsolutePage =gotopage
i=1
for j=i to Rs.RecordCount
if i>Rs.PageSize then exit for end if
if no=j-0 then exit for end if

order_idx=Rs(0)
order_name=Rs(1)
order_length=Rs(2)
order_type=Rs(3)
kg_m=Rs(4)
order_date=Rs(5)
order_status=Rs(6)
order_fdate=Rs(7)
order_dept=Rs(8)

select case order_length
    case "0"
        length_text="없음"
    case "1"
        length_text="2,200mm"
    case "2"
        length_text="2,400mm"
    case "3"
        length_text="2,500mm"
    case "4"
        length_text="2,800mm"
    case "5"
        length_text="3,000mm"
    case "6"
        length_text="3,200mm"
end select



select case order_type
    case "0"
    type_text="없음"
    case "1"
        type_text="무피"
    case "2"
        type_text="백피"
    case "3"
        type_text="블랙"
end select 


select case order_status
    case "0"
        order_status_text="사용안함"
    case "1"
        order_status_text="사용중"
end select 

select case order_dept
    case "1"
        dept_text="도어"
    case "2"
        dept_text="프레임"
    case "3"
        dept_text="시스템도어"
    case "4"
        dept_text="자동문"
    case "5"
        dept_text="보호대"
    case "6"
        dept_text="기타"
end select
%>              
                  <tr>
                      <td><%=no-j%></td>
                      <td><%=dept_text%></td>
                      <td><%=order_name%></td>
                      <td><%=length_text%></td>
                      <td><%=type_text%></td>
                      <td><%=kg_m%></td>
                      <td><%=order_status_text%></td>
                      <td><%=order_date%></td>
                      <td><% if order_fdate<>"1900-01-01" then %><%=order_fdate%><% end if %></td> 
                      <td><button type="button" class="btn btn-primary" onClick="location.replace('khorderudt.asp?order_idx=<%=order_idx%>')">관리</button></td>
                  </tr>
<%
i=i+1
Rs.MoveNext
Next
End If
%>
              </tbody>
          </table>
        </div>
        <div class="row col-12 py-3">
<!--#include Virtual = "/inc/paging.asp"-->

        </div>
<%
Rs.Close
%>   
<!-- 표 형식 끝--> 
 
 
    </div>    

    <!--화면 끝-->
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 호영
 
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


