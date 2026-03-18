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
page_name="busok_item.asp?"
%>

<% projectname="부속자재 관리" %>

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
    <title>테이블 열 너비 조정</title>
    <style>
        /* 테이블 스타일 */
        table {
            width: 100%; /* 테이블 전체 너비 */
            table-layout: auto; /* 테이블 너비를 자동으로 설정 */
            border-collapse: collapse; /* 테두리 간격 제거 */
        }

        th, td {
            border: 1px solid black; /* 셀 경계선 추가 */
            padding: 8px; /* 셀 패딩 */
            text-align: left; /* 텍스트 정렬 */
        }

        /* 이름 열에 대한 스타일 */
        th.name-column, td.name-column {
            width: 300px; /* 이름 열의 고정 너비 */
            white-space: nowrap; /* 줄바꿈 방지 */
            overflow: hidden; /* 넘치는 내용 숨김 */
            text-overflow: ellipsis; /* 넘치는 텍스트를 '...'로 표시 */
        }

        /* 헤더 고정 스타일 */
        th {
            background-color: #f2f2f2; /* 헤더 배경색 */
        }
        </style>
        <style>
        table {
            table-layout: auto; /* 열 너비를 글씨 내용에 따라 자동 조정 */
            width: 100%; /* 테이블이 전체 너비를 차지하도록 설정 */
            border-collapse: collapse; /* 테두리를 결합 */
        }
        th, td {
            border: 1px solid #000; /* 테두리 추가 */
            text-align: left; /* 텍스트 정렬 */
            padding: 8px; /* 셀 안쪽 여백 */
        }
        </style>
        <style>
        th, td {
            min-width: 80px; /* 기본 최소 너비 설정 */
            padding: 8px;
            border: 1px solid #000;
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
                <h3>부속 관리</h3>
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
                                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="barlist_item.asp" name="form1">
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
                            <th scope="col">기본 키</th>
                            <th scope="col">타입선택여부</th> <!-- barSELECT: 통도장/스텐/겸용 선택 값 -->
                            <th scope="col">코드</th> <!-- barCODE: 코드 값 -->
                            <th scope="col">축약어</th>  <!-- barshorten: 축약된 이름 또는 코드 -->
                            <th scope="col" class="wide-column">이름</th>  <!-- barNAME: 항목의 이름 -->
                            <th scope="col">단가</th> <!-- barlistprice: 항목의 목록 가격 -->
                            <th scope="col">사용중/안함</th>
                            <th scope="col">qtype</th>
                            <th scope="col">atype</th>
                            <th scope="col">작성자 키</th>
                            <th scope="col">최초 작성일</th>
                            <th scope="col">최종 수정자 키</th>
                            <th scope="col">최종 수정일시</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <%
                        SQL=" SELECT barIDX, barSELECT, barCODE, barshorten, barNAME, barQTY, barSTATUS, barmidx, barwdate, baremidx, barewdate "
                        SQL=SQL&" , qtype, atype, barlistprice "
                        SQL=SQL&" FROM tk_barlist "
                        SQL=SQL&" Where barIDX<>''  "

                        If Request("SearchWord")<>"" Then 
                            SQL=SQL&" Where(barCODE like '%"&Request("SearchWord")&"%'  or barshorten like '%"&Request("SearchWord")&"%'  or barNAME like '%"&Request("SearchWord")&"%') "
                        End If 
                        'SQL=SQL&" Order by barIDX asc "
                        'Response.write (SQL)&"<br>"

                        Rs.open SQL, Dbcon, 1, 1, 1
                        Rs.PageSize = 10

                        If Not (Rs.EOF Or Rs.BOF) Then
                        no = Rs.Recordcount - (Rs.PageSize * (gotopage-1)) + 1
                        totalpage = Rs.PageCount
                        Rs.AbsolutePage = gotopage
                        i = 1
                        For j = 1 To Rs.Recordcount
                        If i > Rs.PageSize Then Exit For
                        If no - j = 0 Then Exit For

                        barIDX = Rs(0)         ' 인덱스 또는 고유 ID
                        barSELECT = Rs(1)      ' 선택 값
                        barCODE = Rs(2)        ' 코드 값
                        barshorten = Rs(3)     ' 축약된 이름 또는 코드
                        barNAME = Rs(4)        ' 항목의 이름
                        barQTY = Rs(5)         ' 수량
                        barSTATUS = Rs(6)      ' 항목의 상태
                        barmidx = Rs(7)        ' 중간 인덱스 (외래 키 또는 참조 가능성 있음)
                        barwdate = Rs(8)       ' 작성 날짜 또는 생성 날짜
                        baremidx = Rs(9)       ' 수정한 사용자 또는 참조하는 인덱스
                        barewdate = Rs(10)     ' 수정된 날짜
                        qtype = Rs(11)         ' 쿼리 유형 또는 추가 유형
                        atype = Rs(12)         ' 작업 유형 또는 다른 유형
                        barlistprice = Rs(13)  ' 항목의 목록 가격
                        %>
                        <tr>
                            <th><%=no-j%></th>
                            <td><%=barIDX%></td> <!-- barIDX: 인덱스 또는 고유 ID -->
                            <td><%=barSELECT%></td> <!-- barSELECT: 선택 값 -->
                            <td><%=barCODE%></td> <!-- barCODE: 코드 값 -->
                            <td><%=barshorten%></td> <!-- barshorten: 축약된 이름 또는 코드 -->
                            <td><%=barNAME%></td> <!-- barNAME: 항목의 이름 -->
                            <td><%=barlistprice%></td> <!-- barlistprice: 항목의 목록 가격 -->
                            <td>
                            <% if barSTATUS="0" or barSTATUS="" then  %>사용안함<% end if %>
                            <% if barSTATUS="1" then  %>사용중<% end if %>                        
                            </td>
                            
                            <td><%=qtype%></td> <!-- qtype: 쿼리 유형 또는 추가 유형 -->
                            <td><%=atype%></td> <!-- atype: 작업 유형 또는 다른 유형 -->
                            <td><%=barmidx%></td> <!-- barmidx: 중간 인덱스 (외래 키 또는 참조 가능성 있음) -->
                            <td><%=barwdate%></td> <!-- barwdate: 작성 날짜 또는 생성 날짜 -->
                            <td><%=baremidx%></td> <!-- baremidx: 수정한 사용자 또는 참조하는 인덱스 -->
                            <td><%=barewdate%></td> <!-- barewdate: 수정된 날짜 -->
                            <td>
                        </tr>
                        <%
                        Rs.MoveNext
                        i = i + 1
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