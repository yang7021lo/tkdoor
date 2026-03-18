<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
    Set RsC = Server.CreateObject ("ADODB.Recordset")
    Set Rs = Server.CreateObject ("ADODB.Recordset")
    Set Rs1 = Server.CreateObject ("ADODB.Recordset")
    Set Rs2 = Server.CreateObject ("ADODB.Recordset")
    Set Rs3 = Server.CreateObject ("ADODB.Recordset")

    listgubun="four"
    projectname="자재등록"
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

page_name="khorder.asp?listgubun="&listgubun&"&order_dept="&order_dept&"&SearchWord="&SearchWord&"&"



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

 
      .container-flex {
        display: flex;
        justify-content: space-between;
      }

      .left-section {
        width: 36%; 
        padding: 10px;
        border-right: 2px solid #ddd;
      }

      .right-section {
        width: 64%; 
        padding: 10px;
      }

      .input-group-text {
        width: 120px;
      }
    </style>
    <script>
        function validateForm(){
            if(document.frmMain.order_name.value ==""){
                alert("자재명을 입력하세요.");
                return;
            }
            if(document.frmMain.order_type.value ==""){
                alert("자재 재질을 선택하세요.");
                return;
            }
            if(document.frmMain.order_length.value ==""){
                alert("자재 길이를 선택하세요.");
                return;
            }
            else{
                document.frmMain.submit();
            }
        }
        
    </script>
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left.asp"-->
<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
    <div class="container-flex">
      <!-- 왼쪽 섹션: 자재 등록 폼 -->
      <div class="left-section">
        <div class="py-5 container text-center">
            <h3>자재등록</h3>
            <form name="frmMain" action="khorderdb.asp" method="post">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text">부서</span>
                            <select class="form-select" name="order_dept">
                                <option value="1">도어</option>
                                <option value="2">프레임</option>
                                <option value="3">시스템도어</option>
                                <option value="4">자동문</option>
                                <option value="5">보호대</option>
                                <option value="6">기타</option>
                            </select>
                        </div>
                    </div>
                             <div class="col-md-6">
                                <div class="input-group">
                                   <span class="input-group-text">자재명&nbsp;&nbsp;&nbsp;</span>
                                   <input type="text" class="form-control" name="order_name" value="">
                                </div>
                             </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text">자재길이</span>
                            <select class="form-select" name="order_length">
                                <option value="0" >없음</option>
                                <option value="1" >2,200mm</option>
                                <option value="2">2,400mm</option>
                                <option value="3">2,500mm</option>
                                <option value="4">2,800mm</option>
                                <option value="5">3,000mm</option>
                                <option value="6">3,200mm</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text">자재재질</span>
                            <select class="form-select" name="order_type">
                                <option value="0" >없음</option>
                                <option value="1">무피</option>
                                <option value="2">백피</option>
                                <option value="3">블랙</option>
                            </select>
                        </div>
                    </div>

                </div>
                <div class="row mb-3">
                    <div class="col-md-6">

                        <div class="input-group">
                            <span class="input-group-text">단중&nbsp;&nbsp;&nbsp;</span>
                            <input type="text" class="form-control" name="kg_m" value="">
                         </div>

                    </div>

                </div>
                <div class="input-group mb-3">
                    <button type="button" class="btn btn-outline-primary" onclick="validateForm();">등록</button>
                    <button type="button" class="btn btn-outline-danger" onclick="location.replace('khorderlist.asp');">리스트</button>
                </div>
            </form>
        </div>
      </div>

      <!-- 오른쪽 섹션: 자재 목록 -->

      <div class="right-section">
        <div class="py-1 container text-center card card-body">
          <h3>자재 목록</h3>
          <div class="col-10">
            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="khorder.asp" name="form1">    
            <input type="hidden" name="order_idx" value="<%=order_idx%>">  
                    <div class="input-group">
                      <input class="form-control" type="text" placeholder="자재조회" aria-label="자재조회" aria-describedby="btnNavbarSearch" name="SearchWord" />
                      <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i></button>
                      <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorder.asp?order_dept=1');">도어</button>
                      <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorder.asp?order_dept=2');">프레임</button>
                      <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorder.asp?order_dept=3');">시스템도어</button>
                      <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorder.asp?order_dept=4');">자동문</button>
                      <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorder.asp?order_dept=5');">보호대</button>
                      <button type="button" class="btn btn-outline-primary" onclick="location.replace('khorder.asp?order_dept=6');">기타</button>
                    </div>
            </form>        
          </div> 
          <div class="input-group mb-3">
            <table id="datatablesSimple" class="table table-hover">
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
totalpage=Rs.PageCount
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
dept_text=""
i=i+1
Rs.MoveNext
Next
End If
%>
              </tbody>
            </table>
          </div>
          <div class="row col-12 py-3">
            <nav aria-label="Page navigation example">
            <!--#include Virtual = "/inc/paging.asp"-->
            </nav>
          </div>
        </div>
    </div>
  </div>

 Coded By 김호영
 
</main>

<!-- footer 시작 -->    


<!-- footer 끝 --> 
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
