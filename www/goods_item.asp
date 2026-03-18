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
page_name="goods.item.asp?"
%>

<% projectname="품명 관리" %>

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
                <h3>품명 관리</h3>
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
                                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="goods_item.asp" name="form1">
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
                          <th scope="col">idx</th>
                          <th scope="col">타입</th>
                          <th scope="col">코드</th>
                          <th scope="col">축약어</th>
                          <th scope="col">품명 이름</th>
                          <th scope="col">품명 이름1</th>
                          <th scope="col">품명 이름2</th>
                          <th scope="col">품명 이름3</th>
                          <th scope="col">품명 이름4</th>
                          <th scope="col">품명 이름5</th>
                          <th scope="col">품명 이름6</th>
                          <th scope="col">품명 이름7</th>
                          <th scope="col">품명 이름8</th>
                          <th scope="col">품명 이름9</th>
                          <th scope="col">품명 이름10</th>
                          <th scope="col">품명 이름11</th>
                          <th scope="col">품명 이름12</th>
                          <th scope="col">품명 이름13</th>
                          <th scope="col">가격1</th>
                          <th scope="col">가격2</th>
                          <th scope="col">가격3</th>
                          <th scope="col">사용중/안함</th>
                          <th scope="col">작성자 키</th>
                          <th scope="col">최초 작성일</th>
                          <th scope="col">최종수정자 키</th>
                          <th scope="col">최종수정일시</th>
                      </tr>
                  </thead>
                    <tbody class="table-group-divider">

                        <%
                        SQL = "SELECT goidx, gotype, gocode, gocword, goname, gopaint, gosecfloor, gomidkey"
                        SQL = SQL & ", gounit, gostatus, gomidx, gowdate, goemidx, goewdate, goprice, goname1"
                        SQL = SQL & ", goname2, goname3, goname4, goname5, goname6, goname7, goname8, goname9"
                        SQL = SQL & ", goname10, goname11, goname12, goname13, goprice1, goprice2, goprice3"
                        SQL = SQL & " FROM tk_goods"
                        If Request("SearchWord")<>"" Then 
                        SQL=SQL&" Where(gocode like '%"&request("SearchWord")&"%'  or gocword like '%"&request("SearchWord")&"%'  or goname like '%"&request("SearchWord")&"%'  ) "
                        End If 
                        ' SQL=SQL&" Order by tk_goods desc "
                        'Response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon,1,1,1
                        Rs.PageSize = 10
                        
                        if not (Rs.EOF or Rs.BOF) then 
                        no = Rs.Recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                        totalpage=Rs.PageCount
                        Rs.AbsolutePage=gotopage
                        i=1
                        for j=1 to Rs.RecordCount 
                        if i>Rs.PageSize then exit for end if 
                        if no-j=0 then exit for end if 
                        
                        goidx = Rs(0)         ' 고유 인덱스
                        gotype = Rs(1)        ' 상품 유형
                        gocode = Rs(2)        ' 상품 코드
                        gocword = Rs(3)       ' 상품 약어
                        goname = Rs(4)        ' 상품 이름
                        gopaint = Rs(5)       ' 도색 여부
                        gosecfloor = Rs(6)    ' 보안 등급
                        gomidkey = Rs(7)      ' 중간 키
                        gounit = Rs(8)        ' 단위
                        gostatus = Rs(9)      ' 상태
                        gomidx = Rs(10)       ' 관리자 인덱스
                        gowdate = Rs(11)      ' 작성 날짜
                        goemidx = Rs(12)      ' 수정자 인덱스
                        goewdate = Rs(13)     ' 수정 날짜
                        goprice = Rs(14)      ' 가격
                        goname1 = Rs(15)      ' 추가 이름 필드 1
                        goname2 = Rs(16)      ' 추가 이름 필드 2
                        goname3 = Rs(17)      ' 추가 이름 필드 3
                        goname4 = Rs(18)      ' 추가 이름 필드 4
                        goname5 = Rs(19)      ' 추가 이름 필드 5
                        goname6 = Rs(20)      ' 추가 이름 필드 6
                        goname7 = Rs(21)      ' 추가 이름 필드 7
                        goname8 = Rs(22)      ' 추가 이름 필드 8
                        goname9 = Rs(23)      ' 추가 이름 필드 9
                        goname10 = Rs(24)     ' 추가 이름 필드 10
                        goname11 = Rs(25)     ' 추가 이름 필드 11
                        goname12 = Rs(26)     ' 추가 이름 필드 12
                        goname13 = Rs(27)     ' 추가 이름 필드 13
                        goprice1 = Rs(28)     ' 가격1
                        goprice2 = Rs(29)     ' 가격2
                        goprice3 = Rs(30)     ' 가격3

                        %>

                        <tr>
                            <th><%=no-j%></th>
                            <td><%= goidx %></td>         <!-- 고유 인덱스 -->
                            <td><%= gotype %></td>        <!-- 상품 유형 -->
                            <td><%= gocode %></td>        <!-- 상품 코드 -->
                            <td><%= gocword %></td>       <!-- 상품 약어 -->
                            <td><%= goname %></td>        <!-- 상품 이름 -->
                            <td><%= goname1 %></td>       <!-- 추가 이름 필드 1 -->
                            <td><%= goname2 %></td>       <!-- 추가 이름 필드 2 -->
                            <td><%= goname3 %></td>       <!-- 추가 이름 필드 3 -->
                            <td><%= goname4 %></td>       <!-- 추가 이름 필드 4 -->
                            <td><%= goname5 %></td>       <!-- 추가 이름 필드 5 -->
                            <td><%= goname6 %></td>       <!-- 추가 이름 필드 6 -->
                            <td><%= goname7 %></td>       <!-- 추가 이름 필드 7 -->
                            <td><%= goname8 %></td>       <!-- 추가 이름 필드 8 -->
                            <td><%= goname9 %></td>       <!-- 추가 이름 필드 9 -->
                            <td><%= goname10 %></td>      <!-- 추가 이름 필드 10 -->
                            <td><%= goname11 %></td>      <!-- 추가 이름 필드 11 -->
                            <td><%= goname12 %></td>      <!-- 추가 이름 필드 12 -->
                            <td><%= goname13 %></td>      <!-- 추가 이름 필드 13 -->
                            <td><%= goprice1 %></td>      <!-- 가격1 -->
                            <td><%= goprice2 %></td>      <!-- 가격2 -->
                            <td><%= goprice3 %></td>      <!-- 가격3 -->
                            <td><%= gostatus %></td>      <!-- 상태 -->
                            <td><%= gomidx %></td>        <!-- 관리자 인덱스 -->
                            <td><%= gowdate %></td>       <!-- 작성 날짜 -->
                            <td><%= goemidx %></td>       <!-- 수정자 인덱스 -->
                            <td><%= goewdate %></td>      <!-- 수정 날짜 -->
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