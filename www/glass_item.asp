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
if request("gotopage")="" then
gotopage=1
else
gotopage=request("gotopage")
end if 
page_name="glass_item.asp?"
%>

<% projectname="유리 관리" %>

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
  <body>
    
         

         <!--입력시작-->
        <div class="container py-5 text-center">
            <div class="input-group mb-1">
      <!--게시판 제목하고 검색 버튼-->
    

                <div class="col-11 text-start">
                <h3>유리 관리</h3>
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
                                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="glass_item.asp" name="form1">
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
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">코드</th>
                        <th scope="col">유리종류</th>
                        <th scope="col">품명</th>
                        <th scope="col">두께</th>
                        <th scope="col">단가</th>
                        <th scope="col">사용</th>
                    </tr>
                    </thead>
                    <tbody class="table-group-divider">

                        <%
                        SQL=" Select glidx, glcode, glsort, glvariety, gldepth, glprice, glwdate "
                        SQL=SQL&" From tk_glass "
                        If Request("SearchWord")<>"" Then 
                        SQL=SQL&" Where(glcode like '%"&request("SearchWord")&"%'  or glsort like '%"&request("SearchWord")&"%'  or glvariety like '%"&request("SearchWord")&"%'  ) "
                        End If 
                        SQL=SQL&" Order by glidx desc "
                        'Response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon,1,1,1
                        Rs.PageSize = 5
                        
                        if not (Rs.EOF or Rs.BOF) then 
                        no = Rs.Recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                        totalpage=Rs.PageCount
                        Rs.AbsolutePage=gotopage
                        i=1
                        for j=1 to Rs.RecordCount 
                        if i>Rs.PageSize then exit for end if 
                        if no-j=0 then exit for end if 
                        
                        glidx=Rs(0)
                        glcode=Rs(1)
                        glsort=Rs(2)
                        glvariety=Rs(3)
                        gldepth=Rs(4)
                        glprice=Rs(5)
                        glwdate=Rs(6)
                        

                        %>

                        <tr>
                            <th><%=no-j%></th>
                            <td><%=glcode%></td>
                            <td>
                            <% if glsort="1" or glsort="" then  %>단판<% end if %>
                            <% if glsort="2" then  %>접합<% end if %>                        
                            <% if glsort="3" then  %>복층<% end if %>
                            <% if glsort="4" then  %>복층접합<% end if %>
                            <% if glsort="5" then  %>삼중복층<% end if %>
                            </td>
                            <td><%=glvariety%></td>
                            <td><%=gldepth%>T</td>
                            <td><%=glprice%></td>
                            <td><%=glwdate%></td>
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
<%
rs.close
%>
        </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>