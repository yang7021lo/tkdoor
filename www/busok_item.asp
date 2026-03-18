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
                                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="busok_item.asp" name="form1">
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
                            <th scope="col">타입선택여부</th><!-- 1=알미늄바 2=스텐,껍데기 3=출몰바 4=보강 5=부자재 -->
                            <th scope="col">코드</th>
                            <th scope="col">축약어</th>
                            <th scope="col" class="wide-column">이름</th> <!-- 고정 너비와 줄바꿈 방지 -->
                            <th scope="col">단위</th>
                            <th scope="col">사용중/안함</th>
                            <th scope="col">qtype</th>
                            <th scope="col">atype</th>
                            <th scope="col">단가</th>
                            <th scope="col">금형NO</th>
                            <th scope="col">AL비중</th>
                            <th scope="col">두께</th>
                            <th scope="col">보이는면</th>
                            <th scope="col">보강절단치수</th>
                            <th scope="col">이미지파일</th>
                            <th scope="col">캐드파일</th>
                            <th scope="col">상바 타입</th>
                            <th scope="col">하바 타입</th>
                            <th scope="col">출몰바 타입</th>
                            <th scope="col">도장 타입</th>
                            <th scope="col">그룹 타입</th>
                            <th scope="col">작성자 키</th>
                            <th scope="col">최초 작성일</th>
                            <th scope="col">최종 수정자 키</th>
                            <th scope="col">최종 수정일시</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <%
                        SQL = "SELECT BUIDX, BUSELECT, BUCODE, BUshorten, BUNAME, BUQTY, BUSTATUS, qtype, atype, Buprice, "
                        SQL = SQL & "BUGEMHYUNG, BUBIJUNG, BUDUKKE, BUHIGH, BU_BOGANG_LENGTH, BUIMAGES, BUCADFILES, BUsangbarTYPE, "
                        SQL = SQL & "BUhabarTYPE, BUchulmolbarTYPE, BUpainttype, BUgrouptype, BUST_GLASS, BUST_N_CUT_STATUS, "
                        SQL = SQL & "BUST_HL_COIL, BUST_NUCUT_ShRing, BUST_NUCUT_1, BUST_NUCUT_2, BUST_VCUT_ShRing, "
                        SQL = SQL & "BUST_VCUT_1, BUST_VCUT_2, BUST_VCUT_CH, BUmidx, BUwdate, BUemidx, BUewdate "
                        SQL = SQL & "FROM tk_BUSOK "
                        SQL = SQL & "WHERE BUST_GLASS IS NULL"

                        If Request("SearchWord")<>"" Then 
                            SQL=SQL&" Where(BUCODE like '%"&Request("SearchWord")&"%'  or BUshorten like '%"&Request("SearchWord")&"%'  or BUNAME like '%"&Request("SearchWord")&"%') "
                        End If 
                        SQL=SQL&" Order by BUIDX DEsc "
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

                        BUIDX = Rs(0)            ' 기본 키
                        BUSELECT = Rs(1)         ' 선택 여부
                        BUCODE = Rs(2)           ' 코드
                        BUshorten = Rs(3)        ' 축약 이름
                        BUNAME = Rs(4)           ' 이름
                        BUQTY = Rs(5)            ' 단위
                        BUSTATUS = Rs(6)         ' 사용중/안함
                        qtype = Rs(7)            ' qtype
                        atype = Rs(8)            ' atype
                        Buprice = Rs(9)          ' 단가
                        BUGEMHYUNG = Rs(10)      ' 금형NO
                        BUBIJUNG = Rs(11)        ' AL비중
                        BUDUKKE = Rs(12)         ' 두께
                        BUHIGH = Rs(13)          ' 보이는면
                        BU_BOGANG_LENGTH = Rs(14) ' 보강절단치수
                        BUIMAGES = Rs(15)        ' 이미지파일
                        BUCADFILES = Rs(16)      ' 캐드파일
                        BUsangbarTYPE = Rs(17)   ' 상바 타입
                        BUhabarTYPE = Rs(18)     ' 하바 타입
                        BUchulmolbarTYPE = Rs(19) ' 출몰바 타입
                        BUpainttype = Rs(20)     ' 도장 타입
                        BUgrouptype = Rs(21)     ' 그룹 타입
                        BUST_GLASS = Rs(22)      ' 유리두께
                        BUST_N_CUT_STATUS = Rs(23) ' 노컷/컷 유무
                        BUST_HL_COIL = Rs(24)    ' 헤어라인코일 매치
                        BUST_NUCUT_ShRing = Rs(25) ' 노컷절단
                        BUST_NUCUT_1 = Rs(26)    ' 노컷 1차
                        BUST_NUCUT_2 = Rs(27)    ' 노컷 2차
                        BUST_VCUT_ShRing = Rs(28) ' V컷절단
                        BUST_VCUT_1 = Rs(29)     ' V컷 1차
                        BUST_VCUT_2 = Rs(30)     ' V컷 2차
                        BUST_VCUT_CH = Rs(31)    ' V컷 채널넘버
                        BUmidx = Rs(32)          ' 작성자 키
                        BUwdate = Rs(33)         ' 최초 작성일
                        BUemidx = Rs(34)         ' 최종 수정자 키
                        BUewdate = Rs(35)        ' 최종 수정일시
                        %>
                        <tr>
                            <th><%=no-j%></th>
                            <td><%=BUIDX%></td>
                            <td><%=BUSELECT%></td> <!-- 선택 여부 -->
                            <td><%=BUCODE%></td> <!-- 코드 -->
                            <td><%=BUshorten%></td> <!-- 축약 이름 -->
                            <td class="name-column"><%=BUNAME%></td> <!-- 이름 -->
                            <td><%=BUQTY%></td> <!-- 단위 -->
                            <td><%=BUSTATUS%></td> <!-- 사용중/안함 -->
                            <td><%=qtype%></td> <!-- qtype -->
                            <td><%=atype%></td> <!-- atype -->
                            <td><%=Buprice%></td> <!-- 단가 -->
                            <td><%=BUGEMHYUNG%></td> <!-- 금형NO -->
                            <td><%=BUBIJUNG%></td> <!-- AL비중 -->
                            <td><%=BUDUKKE%></td> <!-- 두께 -->
                            <td><%=BUHIGH%></td> <!-- 보이는면 -->
                            <td><%=BU_BOGANG_LENGTH%></td> <!-- 보강절단치수 -->
                            <td><%=BUIMAGES%></td> <!-- 이미지파일 -->
                            <td><%=BUCADFILES%></td> <!-- 캐드파일 -->
                            <td><%=BUsangbarTYPE%></td> <!-- 상바 타입 -->
                            <td><%=BUhabarTYPE%></td> <!-- 하바 타입 -->
                            <td><%=BUchulmolbarTYPE%></td> <!-- 출몰바 타입 -->
                            <td>
                            <% if BUchulmolbarTYPE="1" or BUchulmolbarTYPE="" then  %>안전<% end if %>
                            <% if BUchulmolbarTYPE="2" then  %>안전끼움<% end if %>                        
                            <% if BUchulmolbarTYPE="3" then  %>복층<% end if %>
                            <% if BUchulmolbarTYPE="4" then  %>삼중복층<% end if %>
                            </td>
                            <td><%=BUpainttype%></td> <!-- 도장 타입 -->
                            <td><%=BUgrouptype%></td> <!-- 그룹 타입 -->
                            <td><%=BUmidx%></td> <!-- 작성자 키 -->
                            <td><%=BUwdate%></td> <!-- 최초 작성일 -->
                            <td><%=BUemidx%></td> <!-- 최종 수정자 키 -->
                            <td><%=BUewdate%></td> <!-- 최종 수정일시 -->
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