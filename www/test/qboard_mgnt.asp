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
Set Rs = Server.CreateObject("ADODB.Recordset")
%>

<%
Idx=Request("idx")
statusv=Request("statusv")

if idx<>"" then 
SQL="update yang set status='"&statusv&"' where idx='"&idx&"'"
'Response.write (SQL)& "<br>"
Dbcon.Execute(SQL)
end if
%>

<%
if request("gotopage")="" then
gotopage=1
else
gotopage=request("gotopage")
end if 
page_name="qboard_mgnt.asp?"
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no"/>
    <meta name="description" content="고객문의 접수 웹사이트 기초과정"/>
    <meta name="작가" content="yang"/>
    <title>게시판 관리자</title>
    <link rel="icon" type="image/png" sizes="32x32" href="http://devkevin.cafe24.com/lyh/favicon-32x32.png">


<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  
    


</head>
  <body>
    고객문의 게시판    
         

         <!--입력시작-->
<div class="container py-5 text-center">
    <div class="input-group mb-1">
      <!--게시판 제목하고 검색 버튼-->
    

        <div class="col-11 text-start">
            <h3>문의사항 관리</h3>
          </div>
          <div class="col-1 text-end">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">검색</button>
          </div>
    </div>


    <div class="text-end mb-1">
        <!--modal-->
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
        <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="exampleModalLabel">검색</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="close"></button>
                </div>
        <div class="modal-body">
             <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="qboard_mgnt.asp" name="form1">
             <div class="mb-3">
                <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해주세요" name="SearchWord">
    
             </div>
            <div class="col-12">
                <button type="button" onclick="submit();" class="btn btn-primary ">등록</button>
            </div>
             </form>
        </div>
        </div>
       </div>
    </div>
    <!--modal end-->

    </div>

    <div class="card mb-4 card-body">

        <table class="table table-bordered border-DANGER">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">회사명</th>
                    <th scope="col">담당자</th>
                    <th scope="col">연락처</th>
                    <th scope="col">이메일</th>
                    <th scope="col">문의유형</th>
                    <th scope="col">상태</th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
                <tr>
                    <th scope="row" rowspan="2"></th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
            </tr>
            <tr>
                <td colspan="6"></td>
            </tr>
    <%
    SQL=" Select idx, corp_name, duty_name, tel_number,  email, qtype, qcontents, wdate, status"
    SQL=SQL&" From yang "
    If Request("SearchWord")<>"" Then 
    SQL=SQL&" Where(corp_name like '%"&request("SearchWord")&"%'  or duty_name like '%"&request("SearchWord")&"%'  or qcontents like '%"&request("SearchWord")&"%'  ) "
    End If 
    SQL=SQL&" Order by idx desc "
    'Response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon,1,1,1
    Rs.PageSize = 20
    
    if not (Rs.EOF or Rs.BOF) then 
    no = Rs.Recordcount - (Rs.pagesize * (gotopage-1) ) + 1
    totalpage=Rs.PageCount
    Rs.AbsolutePage=gotopage
    i=1
    for j=1 to Rs.RecordCount 
    if i>Rs.PageSize then exit for end if 
    if no-j=0 then exit for end if 
    
     idx=Rs(0)
     corp_name=Rs(1)
     duty_name=Rs(2)
     tel_number=Rs(3)
     email=Rs(4)
     qtype=Rs(5)
     qcontents=Rs(6)
     wdate=Rs(7)
     status=Rs(8)
    
    select case qtype 
      case "1"
    qtype_text="견적문의"
      case "2"
    qtype_text="상품문의"
      case "3"
    qtype_text="기타문의"
      end select 
    
    select case status
     case "0"
      status_text="대기중"
      status_class="btn btn-primary"
      statusv="1"
     case "1"
      status_text="완료"
      status_class="btn btn-secondary"
      statusv="0"
     end select 
    
     if qcontents<>"" then qcontents=replace(qcontents,chr(13) & chr(10),"<br>")
     %>

     <tr>
        <th scope="row" rowspan="2"><%=no-j%></th>
        <td><%=corp_name%></td>
        <td><%=duty_name%></td>
        <td><%=tel_number%></td>
        <td><%=email%></td>
        <td><%=qtype_text%></td>
        <td><button type="button" class="<%=status_class%>" onclick="location.replace('qboard_mgnt.asp?idx=<%=idx%>&statusv=<%=statusv%>');"><%=status_text%></button></td>
    
     </tr>
    <tr>
        <td colspan="6"><%=qcontents%></td>
    </tr>
    
     <%
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







    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>
<%
set Rs=Nothing
call dbClose()
%>