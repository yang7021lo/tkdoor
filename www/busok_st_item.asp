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

rBUIDX=Request("rBUIDX")
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
        document.getElementById("dataForm").addEventListener("keypress", function (event) {
            if (event.key === "Enter") { // Enter 키를 감지
                event.preventDefault(); // 기본 Enter 동작 방지
                document.getElementById("hiddenSubmit").click(); // 폼 제출
            }
        });
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="busok_st_itemdb.asp?part=delete&buidx="+sTR;
            }
        }
    </script>
</head>
<body>
    <div class="container py-5 text-center">
        <div class="input-group mb-1">
            <div class="col-11 text-start">
            <h3>도어 절곡 바라시 관리</h3>
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
                        <div class="mb-3">
                        <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해주세요" name="SearchWord">
                        </div>
                        <div class="col-12">
                        <button type="button" class="btn btn-outline-danger" Onclick="location.replace('pummok_Busok_ST.asp?rBUIDX=0');">등록</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <!--modal end-->
        <div class="input-group mb-3">
            <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th align="center">#</th>
                        <th align="center">기본 키</th>
                        <th align="center">타입선택여부</th><!-- 0=알미늄바 1=스텐,껍데기 2=출몰바 3=보강 4=부자재 -->
                        <th align="center">축약어</th>
                        <th align="center" class="wide-column">이름</th> <!-- 고정 너비와 줄바꿈 방지 -->
                        <th align="center">사용중/안함(1/2)</th>
                        <th align="center">이미지파일</th>
                        <th align="center">캐드파일</th>
                        <th align="center" class="wide-column">유리두께타입</th> <!-- 고정 너비와 줄바꿈 방지 -->
                        <th align="center">노컷/컷 유무(노컷1/컷2)</th>
                        <th align="center">헤어라인코일 매치 (노코일1/코일2)</th><!-- 61,72,75,77,83,87,95,97,99,100,102 -->
                        <th align="center">노컷절단</th>
                        <th align="center">노컷 1차</th>
                        <th align="center">노컷 2차</th>
                        <th align="center">V컷절단</th>
                        <th align="center">V컷 1차</th>
                        <th align="center">V컷 2차</th>                            
                        <th align="center">V컷 채널넘버</th>
                        <th align="center">작성자 키</th>
                        <th align="center">최초 작성일</th>
                        <th align="center">최종 수정자 키</th>
                        <th align="center">최종 수정일시</th>
                    </tr>
                </thead>
                <tbody class="table-group-divider">
                    <form id="dataForm" action="pummok_Busok_ST_db.asp" method="POST">   
                        <input type="hidden" name="BUIDX" value="<%=rBUIDX%>">
                        <% if rBUIDX="" then %>
                        <%
                            SQL = "SELECT BUIDX, BUSELECT, BUCODE, BUshorten, BUNAME, BUQTY, BUSTATUS, qtype, atype, Buprice, "
                            SQL = SQL & "BUGEMHYUNG, BUBIJUNG, BUDUKKE, BUHIGH, BU_BOGANG_LENGTH, BUIMAGES, BUCADFILES, BUsangbarTYPE, "
                            SQL = SQL & "BUhabarTYPE, BUchulmolbarTYPE, BUpainttype, BUgrouptype, BUST_GLASS, BUST_N_CUT_STATUS, "
                            SQL = SQL & "BUST_HL_COIL, BUST_NUCUT_ShRing, BUST_NUCUT_1, BUST_NUCUT_2, BUST_VCUT_ShRing, "
                            SQL = SQL & "BUST_VCUT_1, BUST_VCUT_2, BUST_VCUT_CH, BUmidx, BUwdate, BUemidx, BUewdate "
                            SQL = SQL & "FROM tk_BUSOK "
                            SQL = SQL & "WHERE BUST_GLASS IS NOT NULL"

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
                            <th><%=no-j%></th> <!-- 순번 -->
                            <td><input class="input-field" type="text" size="3" placeholder="키" aria-label="키" name="BUIDX" id="BUIDX" value="<%=BUIDX%>" onkeypress="handleKeyPress(event, 'BUIDX', 'BUIDX')"/></td> <!-- 기본 키 -->
                            <td><input class="input-field" type="text" size="3" placeholder="선택" aria-label="선택" name="BUSELECT" id="BUSELECT" value="<%=BUSELECT%>" onkeypress="handleKeyPress(event, 'BUSELECT', 'BUSELECT')"/></td> <!-- 타입선택여부 -->
                            <td class="name-column"><%=BUNAME%></td> <!-- 이름 -->
                            <td><input class="input-field" type="text" size="3" placeholder="사용중/안함" aria-label="사용중/안함" name="BUSTATUS" id="BUSTATUS" value="<%=BUSTATUS%>" onkeypress="handleKeyPress(event, 'BUSTATUS', 'BUSTATUS')"/><%=BUSTATUS%></td> <!-- 사용중/안함 -->
                            <td><input class="input-field" type="text" size="3" placeholder="이미지" aria-label="이미지" name="BUIMAGES" id="BUIMAGES" value="<%=BUIMAGES%>" onkeypress="handleKeyPress(event, 'BUIMAGES', 'BUIMAGES')"/><%=BUIMAGES%></td> <!-- 이미지파일 -->
                            <td><input class="input-field" type="text" size="3" placeholder="캐드파일" aria-label="캐드파일" name="BUCADFILES" id="BUCADFILES" value="<%=BUCADFILES%>" onkeypress="handleKeyPress(event, 'BUCADFILES', 'BUCADFILES')"/><%=BUCADFILES%></td> <!-- 캐드파일 -->
                            <td class="name-column"><%=BUST_GLASS%></td> <!-- 유리두께 -->  
                            <td><input class="input-field" type="text" size="3" placeholder="노컷/컷 " aria-label="노컷/컷 " name="BUST_N_CUT_STATUS" id="BUST_N_CUT_STATUS" value="<%=BUST_N_CUT_STATUS%>" onkeypress="handleKeyPress(event, 'BUST_N_CUT_STATUS', 'BUST_N_CUT_STATUS')"/><%=BUST_N_CUT_STATUS%></td> <!-- 노컷/컷 유무(0/1) -->
                            <td><input class="input-field" type="text" size="3" placeholder="코일 매치" aria-label="코일 매치" name="BUST_HL_COIL" id="BUST_HL_COIL" value="<%=BUST_HL_COIL%>" onkeypress="handleKeyPress(event, 'BUST_HL_COIL', 'BUST_HL_COIL')"/><%=BUST_HL_COIL%></td> <!-- 헤어라인코일 매치 (0/1) -->
                            <td><input class="input-field" type="text" size="3" placeholder="노컷절단" aria-label="노컷절단" name="BUST_NUCUT_ShRing" id="BUST_NUCUT_ShRing" value="<%=BUST_NUCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_ShRing', 'BUST_NUCUT_ShRing')"/><%=BUST_NUCUT_ShRing%></td> <!-- 노컷절단 -->
                            <td><input class="input-field" type="text" size="3" placeholder="노컷 1차" aria-label="노컷 1차" name="BUST_NUCUT_1" id="BUST_NUCUT_1" value="<%=BUST_NUCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_1', 'BUST_NUCUT_1')"/><%=BUST_NUCUT_1%></td> <!-- 노컷 1차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="노컷 2차" aria-label="노컷 2차" name="BUST_NUCUT_2" id="BUST_NUCUT_2" value="<%=BUST_NUCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_2', 'BUST_NUCUT_2')"/><%=BUST_NUCUT_2%></td> <!-- 노컷 2차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷절단" aria-label="V컷절단" name="BUST_VCUT_ShRing" id="BUST_VCUT_ShRing" value="<%=BUST_VCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_ShRing', 'BUST_VCUT_ShRing')"/><%=BUST_VCUT_ShRing%></td> <!-- V컷절단 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷 1차" aria-label="V컷 1차" name="BUST_VCUT_1" id="BUST_VCUT_1" value="<%=BUST_VCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_1', 'BUST_VCUT_1')"/><%=BUST_VCUT_1%></td> <!-- V컷 1차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷 2차" aria-label="V컷 2차" name="BUST_VCUT_2" id="BUST_VCUT_2" value="<%=BUST_VCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_2', 'BUST_VCUT_2')"/><%=BUST_VCUT_2%></td> <!-- V컷 2차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷 채널넘버" aria-label="V컷 채널넘버" name="BUST_VCUT_CH" id="BUST_VCUT_CH" value="<%=BUST_VCUT_CH%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_CH', 'BUST_VCUT_CH')"/><%=BUST_VCUT_CH%></td> <!-- V컷 채널넘버 -->
                            <td><input class="input-field" type="text" size="3" placeholder="작성자" aria-label="작성자" name="BUmidx" id="BUmidx" value="<%=BUmidx%>" onkeypress="handleKeyPress(event, 'BUmidx', 'BUmidx')"/><%=BUmidx%></td> <!-- 작성자 키 -->
                            <td><input class="input-field" type="text" size="3" placeholder="작성일" aria-label="작성일" name="BUwdate" id="BUwdate" value="<%=BUwdate%>" onkeypress="handleKeyPress(event, 'BUwdate', 'BUwdate')"/><%=BUwdate%></td> <!-- 최초 작성일 -->
                            <td><input class="input-field" type="text" size="3" placeholder="수정자" aria-label="수정자" name="BUemidx" id="BUemidx" value="<%=BUemidx%>" onkeypress="handleKeyPress(event, 'BUemidx', 'BUemidx')"/><%=BUemidx%></td> <!-- 최종 수정자 키 -->
                            <td><input class="input-field" type="text" size="3" placeholder="수정일" aria-label="수정일" name="BUewdate" id="BUewdate" value="<%=BUewdate%>" onkeypress="handleKeyPress(event, 'BUewdate', 'BUewdate')"/><%=BUewdate%></td> <!-- 최종 수정일시 -->
                        </tr>
                        <% end if %>
                        <%
                            SQL = "SELECT BUIDX, BUSELECT, BUCODE, BUshorten, BUNAME, BUQTY, BUSTATUS, qtype, atype, Buprice, "
                            SQL = SQL & "BUGEMHYUNG, BUBIJUNG, BUDUKKE, BUHIGH, BU_BOGANG_LENGTH, BUIMAGES, BUCADFILES, BUsangbarTYPE, "
                            SQL = SQL & "BUhabarTYPE, BUchulmolbarTYPE, BUpainttype, BUgrouptype, BUST_GLASS, BUST_N_CUT_STATUS, "
                            SQL = SQL & "BUST_HL_COIL, BUST_NUCUT_ShRing, BUST_NUCUT_1, BUST_NUCUT_2, BUST_VCUT_ShRing, "
                            SQL = SQL & "BUST_VCUT_1, BUST_VCUT_2, BUST_VCUT_CH, BUmidx, BUwdate, BUemidx, BUewdate "
                            SQL = SQL & "FROM tk_BUSOK "
                            SQL = SQL & "WHERE BUST_GLASS IS NOT NULL"

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
                        <% if int(BUIDX)=int(rBUIDX) then %>
                        <tr>
                            <th><%=no-j%></th> <!-- 순번 -->
                            <td><input class="input-field" type="text" size="3" placeholder="키" aria-label="키" name="BUIDX" id="BUIDX" value="<%=BUIDX%>" onkeypress="handleKeyPress(event, 'BUIDX', 'BUIDX')"/></td> <!-- 기본 키 -->
                            <td><input class="input-field" type="text" size="3" placeholder="선택" aria-label="선택" name="BUSELECT" id="BUSELECT" value="<%=BUSELECT%>" onkeypress="handleKeyPress(event, 'BUSELECT', 'BUSELECT')"/></td> <!-- 타입선택여부 -->
                            <td class="name-column"><%=BUNAME%></td> <!-- 이름 -->
                            <td><input class="input-field" type="text" size="3" placeholder="사용중/안함" aria-label="사용중/안함" name="BUSTATUS" id="BUSTATUS" value="<%=BUSTATUS%>" onkeypress="handleKeyPress(event, 'BUSTATUS', 'BUSTATUS')"/><%=BUSTATUS%></td> <!-- 사용중/안함 -->
                            <td><input class="input-field" type="text" size="3" placeholder="이미지" aria-label="이미지" name="BUIMAGES" id="BUIMAGES" value="<%=BUIMAGES%>" onkeypress="handleKeyPress(event, 'BUIMAGES', 'BUIMAGES')"/><%=BUIMAGES%></td> <!-- 이미지파일 -->
                            <td><input class="input-field" type="text" size="3" placeholder="캐드파일" aria-label="캐드파일" name="BUCADFILES" id="BUCADFILES" value="<%=BUCADFILES%>" onkeypress="handleKeyPress(event, 'BUCADFILES', 'BUCADFILES')"/><%=BUCADFILES%></td> <!-- 캐드파일 -->
                            <td class="name-column"><%=BUST_GLASS%></td> <!-- 유리두께 -->  
                            <td><input class="input-field" type="text" size="3" placeholder="노컷/컷 " aria-label="노컷/컷 " name="BUST_N_CUT_STATUS" id="BUST_N_CUT_STATUS" value="<%=BUST_N_CUT_STATUS%>" onkeypress="handleKeyPress(event, 'BUST_N_CUT_STATUS', 'BUST_N_CUT_STATUS')"/><%=BUST_N_CUT_STATUS%></td> <!-- 노컷/컷 유무(0/1) -->
                            <td><input class="input-field" type="text" size="3" placeholder="코일 매치" aria-label="코일 매치" name="BUST_HL_COIL" id="BUST_HL_COIL" value="<%=BUST_HL_COIL%>" onkeypress="handleKeyPress(event, 'BUST_HL_COIL', 'BUST_HL_COIL')"/><%=BUST_HL_COIL%></td> <!-- 헤어라인코일 매치 (0/1) -->
                            <td><input class="input-field" type="text" size="3" placeholder="노컷절단" aria-label="노컷절단" name="BUST_NUCUT_ShRing" id="BUST_NUCUT_ShRing" value="<%=BUST_NUCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_ShRing', 'BUST_NUCUT_ShRing')"/><%=BUST_NUCUT_ShRing%></td> <!-- 노컷절단 -->
                            <td><input class="input-field" type="text" size="3" placeholder="노컷 1차" aria-label="노컷 1차" name="BUST_NUCUT_1" id="BUST_NUCUT_1" value="<%=BUST_NUCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_1', 'BUST_NUCUT_1')"/><%=BUST_NUCUT_1%></td> <!-- 노컷 1차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="노컷 2차" aria-label="노컷 2차" name="BUST_NUCUT_2" id="BUST_NUCUT_2" value="<%=BUST_NUCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_2', 'BUST_NUCUT_2')"/><%=BUST_NUCUT_2%></td> <!-- 노컷 2차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷절단" aria-label="V컷절단" name="BUST_VCUT_ShRing" id="BUST_VCUT_ShRing" value="<%=BUST_VCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_ShRing', 'BUST_VCUT_ShRing')"/><%=BUST_VCUT_ShRing%></td> <!-- V컷절단 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷 1차" aria-label="V컷 1차" name="BUST_VCUT_1" id="BUST_VCUT_1" value="<%=BUST_VCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_1', 'BUST_VCUT_1')"/><%=BUST_VCUT_1%></td> <!-- V컷 1차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷 2차" aria-label="V컷 2차" name="BUST_VCUT_2" id="BUST_VCUT_2" value="<%=BUST_VCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_2', 'BUST_VCUT_2')"/><%=BUST_VCUT_2%></td> <!-- V컷 2차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷 채널넘버" aria-label="V컷 채널넘버" name="BUST_VCUT_CH" id="BUST_VCUT_CH" value="<%=BUST_VCUT_CH%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_CH', 'BUST_VCUT_CH')"/><%=BUST_VCUT_CH%></td> <!-- V컷 채널넘버 -->
                            <td><input class="input-field" type="text" size="3" placeholder="작성자" aria-label="작성자" name="BUmidx" id="BUmidx" value="<%=BUmidx%>" onkeypress="handleKeyPress(event, 'BUmidx', 'BUmidx')"/><%=BUmidx%></td> <!-- 작성자 키 -->
                            <td><input class="input-field" type="text" size="3" placeholder="작성일" aria-label="작성일" name="BUwdate" id="BUwdate" value="<%=BUwdate%>" onkeypress="handleKeyPress(event, 'BUwdate', 'BUwdate')"/><%=BUwdate%></td> <!-- 최초 작성일 -->
                            <td><input class="input-field" type="text" size="3" placeholder="수정자" aria-label="수정자" name="BUemidx" id="BUemidx" value="<%=BUemidx%>" onkeypress="handleKeyPress(event, 'BUemidx', 'BUemidx')"/><%=BUemidx%></td> <!-- 최종 수정자 키 -->
                            <td><input class="input-field" type="text" size="3" placeholder="수정일" aria-label="수정일" name="BUewdate" id="BUewdate" value="<%=BUewdate%>" onkeypress="handleKeyPress(event, 'BUewdate', 'BUewdate')"/><%=BUewdate%></td> <!-- 최종 수정일시 -->
                        </tr>
                        <% else %>
                        <tr>
                            <th><%=no-j%></th> <!-- 순번 -->
                            <td><input class="input-field" type="text" size="3" placeholder="키" aria-label="키" name="BUIDX" id="BUIDX" value="<%=BUIDX%>" onkeypress="handleKeyPress(event, 'BUIDX', 'BUIDX')"/></td> <!-- 기본 키 -->
                            <td><input class="input-field" type="text" size="3" placeholder="선택" aria-label="선택" name="BUSELECT" id="BUSELECT" value="<%=BUSELECT%>" onkeypress="handleKeyPress(event, 'BUSELECT', 'BUSELECT')"/></td> <!-- 타입선택여부 -->
                            <td class="name-column"><%=BUNAME%></td> <!-- 이름 -->
                            <td><input class="input-field" type="text" size="3" placeholder="사용중/안함" aria-label="사용중/안함" name="BUSTATUS" id="BUSTATUS" value="<%=BUSTATUS%>" onkeypress="handleKeyPress(event, 'BUSTATUS', 'BUSTATUS')"/><%=BUSTATUS%></td> <!-- 사용중/안함 -->
                            <td><input class="input-field" type="text" size="3" placeholder="이미지" aria-label="이미지" name="BUIMAGES" id="BUIMAGES" value="<%=BUIMAGES%>" onkeypress="handleKeyPress(event, 'BUIMAGES', 'BUIMAGES')"/><%=BUIMAGES%></td> <!-- 이미지파일 -->
                            <td><input class="input-field" type="text" size="3" placeholder="캐드파일" aria-label="캐드파일" name="BUCADFILES" id="BUCADFILES" value="<%=BUCADFILES%>" onkeypress="handleKeyPress(event, 'BUCADFILES', 'BUCADFILES')"/><%=BUCADFILES%></td> <!-- 캐드파일 -->
                            <td class="name-column"><%=BUST_GLASS%></td> <!-- 유리두께 -->  
                            <td><input class="input-field" type="text" size="3" placeholder="노컷/컷 " aria-label="노컷/컷 " name="BUST_N_CUT_STATUS" id="BUST_N_CUT_STATUS" value="<%=BUST_N_CUT_STATUS%>" onkeypress="handleKeyPress(event, 'BUST_N_CUT_STATUS', 'BUST_N_CUT_STATUS')"/><%=BUST_N_CUT_STATUS%></td> <!-- 노컷/컷 유무(0/1) -->
                            <td><input class="input-field" type="text" size="3" placeholder="코일 매치" aria-label="코일 매치" name="BUST_HL_COIL" id="BUST_HL_COIL" value="<%=BUST_HL_COIL%>" onkeypress="handleKeyPress(event, 'BUST_HL_COIL', 'BUST_HL_COIL')"/><%=BUST_HL_COIL%></td> <!-- 헤어라인코일 매치 (0/1) -->
                            <td><input class="input-field" type="text" size="3" placeholder="노컷절단" aria-label="노컷절단" name="BUST_NUCUT_ShRing" id="BUST_NUCUT_ShRing" value="<%=BUST_NUCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_ShRing', 'BUST_NUCUT_ShRing')"/><%=BUST_NUCUT_ShRing%></td> <!-- 노컷절단 -->
                            <td><input class="input-field" type="text" size="3" placeholder="노컷 1차" aria-label="노컷 1차" name="BUST_NUCUT_1" id="BUST_NUCUT_1" value="<%=BUST_NUCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_1', 'BUST_NUCUT_1')"/><%=BUST_NUCUT_1%></td> <!-- 노컷 1차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="노컷 2차" aria-label="노컷 2차" name="BUST_NUCUT_2" id="BUST_NUCUT_2" value="<%=BUST_NUCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_2', 'BUST_NUCUT_2')"/><%=BUST_NUCUT_2%></td> <!-- 노컷 2차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷절단" aria-label="V컷절단" name="BUST_VCUT_ShRing" id="BUST_VCUT_ShRing" value="<%=BUST_VCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_ShRing', 'BUST_VCUT_ShRing')"/><%=BUST_VCUT_ShRing%></td> <!-- V컷절단 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷 1차" aria-label="V컷 1차" name="BUST_VCUT_1" id="BUST_VCUT_1" value="<%=BUST_VCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_1', 'BUST_VCUT_1')"/><%=BUST_VCUT_1%></td> <!-- V컷 1차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷 2차" aria-label="V컷 2차" name="BUST_VCUT_2" id="BUST_VCUT_2" value="<%=BUST_VCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_2', 'BUST_VCUT_2')"/><%=BUST_VCUT_2%></td> <!-- V컷 2차 -->
                            <td><input class="input-field" type="text" size="3" placeholder="V컷 채널넘버" aria-label="V컷 채널넘버" name="BUST_VCUT_CH" id="BUST_VCUT_CH" value="<%=BUST_VCUT_CH%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_CH', 'BUST_VCUT_CH')"/><%=BUST_VCUT_CH%></td> <!-- V컷 채널넘버 -->
                            <td><input class="input-field" type="text" size="3" placeholder="작성자" aria-label="작성자" name="BUmidx" id="BUmidx" value="<%=BUmidx%>" onkeypress="handleKeyPress(event, 'BUmidx', 'BUmidx')"/><%=BUmidx%></td> <!-- 작성자 키 -->
                            <td><input class="input-field" type="text" size="3" placeholder="작성일" aria-label="작성일" name="BUwdate" id="BUwdate" value="<%=BUwdate%>" onkeypress="handleKeyPress(event, 'BUwdate', 'BUwdate')"/><%=BUwdate%></td> <!-- 최초 작성일 -->
                            <td><input class="input-field" type="text" size="3" placeholder="수정자" aria-label="수정자" name="BUemidx" id="BUemidx" value="<%=BUemidx%>" onkeypress="handleKeyPress(event, 'BUemidx', 'BUemidx')"/><%=BUemidx%></td> <!-- 최종 수정자 키 -->
                            <td><input class="input-field" type="text" size="3" placeholder="수정일" aria-label="수정일" name="BUewdate" id="BUewdate" value="<%=BUewdate%>" onkeypress="handleKeyPress(event, 'BUewdate', 'BUewdate')"/><%=BUewdate%></td> <!-- 최종 수정일시 -->
                        </tr>
                        <% end if %>
                        <%
                        Rs.MoveNext
                        Loop
                        End If 
                        Rs.Close 
                        %>
                        <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                    </form>    
                </tbody>
            </table>
        </div>
    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>