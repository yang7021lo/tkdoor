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
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

listgubun="one"
subgubun="one2"
projectname="부속자재 관리" %>
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function

rBUIDX=Request("rBUIDX")
SearchWord=Request("SearchWord")
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
    <style>
    /* 왼쪽 여백 제거 */
    body, html {
        zoom: 1;
        margin: 0; /* 기본 여백 제거 */
        padding: 0;
    }
     /* 부모 컨테이너를 꽉 채우기 */
    .container-full {
        width: 100%;
        margin: 0;
        padding: 0;
    }

    /* 테이블을 화면 전체로 늘리기 */
    table.full-width-table {
        width: 100%;
        border-collapse: collapse;
    }

    /* 필요하면 테이블 안쪽 패딩도 제거 */
    table.full-width-table th, table.full-width-table td {
        padding: 8px; /* 여백 조절 가능 */
        text-align: center; /* 텍스트 중앙 정렬 등 */
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
                location.href="pummok_Busok_itemDB.asp?part=delete&buidx="+sTR;
            }
        }
    </script>
</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_pummok.asp"-->
    <div class="container py-5 text-center">
        <div class="row mb-3">
            <div class="input-group mb-3">
                <h3>도어 절곡 바라시 관리</h3>
            </div>  
            <div class="col text-end">
                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="pummok_Busok_ST_item.asp" name="form1">   
                    <div style="display: flex; align-items: center; gap: 8px;"> 
                        <input class="form-control" type="text" placeholder="품명,유리,채널넘버 조회" aria-label="품명,유리,채널넘버 조회" aria-describedby="btnNavbarSearch" name="SearchWord" />
                        <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i></button>
                </form> 
                    <button type="button"
                        class="btn btn-outline-danger"
                        style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;"
                        onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=0');">등록
                    </button>
                </div>
            </div>
        <div>
            <div style="width: 100%; margin: 0; padding: 0;">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr>
                            <th align="center">순번</th>
                            <th align="center">타입선택</th><!-- 0=알미늄바 1=스텐,껍데기 2=출몰바 3=보강 4=부자재 -->
                            <th align="center">품명</th> <!-- 고정 너비와 줄바꿈 방지 -->
                            <th align="center">사용중/안함(0/1)</th>
                            <th align="center">이미지파일</th>
                            <th align="center">캐드파일</th>
                            <th align="center">유리두께</th> <!-- 고정 너비와 줄바꿈 방지 -->
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
                    <tbody>
                        <form id="dataForm" action="pummok_Busok_ST_itemDB.asp" method="POST">   
                            <input type="hidden" name="BUIDX" value="<%=rBUIDX%>">
                            <% if rBUIDX="0" then %>
                            <tr>
                                <th></th> <!-- 순번 -->
                                <td><input class="input-field" type="text" size="10" placeholder="선택" aria-label="선택" name="BUSELECT" id="BUSELECT" value="<%=BUSELECT%>" onkeypress="handleKeyPress(event, 'BUSELECT', 'BUSELECT')"/></td> <!-- 타입선택여부 -->
                                <td><input class="input-field" type="text" size="30" placeholder="품명" aria-label="품명" name="BUNAME" id="BUNAME" value="<%=BUNAME%>" onkeypress="handleKeyPress(event, 'BUNAME', 'BUNAME')"/></td> <!-- 품명 -->
                                <td><input class="input-field" type="text" size="5" placeholder="사용중/안함" aria-label="사용중/안함" name="BUSTATUS" id="BUSTATUS" value="<%=BUSTATUS%>" onkeypress="handleKeyPress(event, 'BUSTATUS', 'BUSTATUS')"/><%=BUSTATUS%></td> <!-- 사용중/안함 -->
                                <td><input class="input-field" type="text" size="10" placeholder="이미지" aria-label="이미지" name="BUIMAGES" id="BUIMAGES" value="<%=BUIMAGES%>" onkeypress="handleKeyPress(event, 'BUIMAGES', 'BUIMAGES')"/><%=BUIMAGES%></td> <!-- 이미지파일 -->
                                <td><input class="input-field" type="text" size="10" placeholder="캐드파일" aria-label="캐드파일" name="BUCADFILES" id="BUCADFILES" value="<%=BUCADFILES%>" onkeypress="handleKeyPress(event, 'BUCADFILES', 'BUCADFILES')"/><%=BUCADFILES%></td> <!-- 캐드파일 -->
                                <td><input class="input-field" type="text" size="10" placeholder="유리두께" aria-label="유리두께" name="BUST_GLASS" id="BUST_GLASS" value="<%=BUST_GLASS%>" onkeypress="handleKeyPress(event, 'BUST_GLASS', 'BUST_GLASS')"/><%=BUST_GLASS%></td> <!-- 유리두께 -->  
                                <td><input class="input-field" type="text" size="10" placeholder="노컷/컷 " aria-label="노컷/컷 " name="BUST_N_CUT_STATUS" id="BUST_N_CUT_STATUS" value="<%=BUST_N_CUT_STATUS%>" onkeypress="handleKeyPress(event, 'BUST_N_CUT_STATUS', 'BUST_N_CUT_STATUS')"/><%=BUST_N_CUT_STATUS%></td> <!-- 노컷/컷 유무(0/1) -->
                                <td><input class="input-field" type="text" size="10" placeholder="코일 매치" aria-label="코일 매치" name="BUST_HL_COIL" id="BUST_HL_COIL" value="<%=BUST_HL_COIL%>" onkeypress="handleKeyPress(event, 'BUST_HL_COIL', 'BUST_HL_COIL')"/><%=BUST_HL_COIL%></td> <!-- 헤어라인코일 매치 (0/1) -->
                                <td><input class="input-field" type="text" size="10" placeholder="노컷절단" aria-label="노컷절단" name="BUST_NUCUT_ShRing" id="BUST_NUCUT_ShRing" value="<%=BUST_NUCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_ShRing', 'BUST_NUCUT_ShRing')"/><%=BUST_NUCUT_ShRing%></td> <!-- 노컷절단 -->
                                <td><input class="input-field" type="text" size="5" placeholder="노컷 1차" aria-label="노컷 1차" name="BUST_NUCUT_1" id="BUST_NUCUT_1" value="<%=BUST_NUCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_1', 'BUST_NUCUT_1')"/><%=BUST_NUCUT_1%></td> <!-- 노컷 1차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="노컷 2차" aria-label="노컷 2차" name="BUST_NUCUT_2" id="BUST_NUCUT_2" value="<%=BUST_NUCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_2', 'BUST_NUCUT_2')"/><%=BUST_NUCUT_2%></td> <!-- 노컷 2차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷절단" aria-label="V컷절단" name="BUST_VCUT_ShRing" id="BUST_VCUT_ShRing" value="<%=BUST_VCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_ShRing', 'BUST_VCUT_ShRing')"/><%=BUST_VCUT_ShRing%></td> <!-- V컷절단 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷 1차" aria-label="V컷 1차" name="BUST_VCUT_1" id="BUST_VCUT_1" value="<%=BUST_VCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_1', 'BUST_VCUT_1')"/><%=BUST_VCUT_1%></td> <!-- V컷 1차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷 2차" aria-label="V컷 2차" name="BUST_VCUT_2" id="BUST_VCUT_2" value="<%=BUST_VCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_2', 'BUST_VCUT_2')"/><%=BUST_VCUT_2%></td> <!-- V컷 2차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷 채널넘버" aria-label="V컷 채널넘버" name="BUST_VCUT_CH" id="BUST_VCUT_CH" value="<%=BUST_VCUT_CH%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_CH', 'BUST_VCUT_CH')"/><%=BUST_VCUT_CH%></td> <!-- V컷 채널넘버 -->
                                <td><input class="input-field" type="text" size="5" placeholder="작성자" aria-label="작성자" name="BUmidx" id="BUmidx" value="<%=BUmidx%>" onkeypress="handleKeyPress(event, 'BUmidx', 'BUmidx')"/><%=BUmidx%></td> <!-- 작성자 키 -->
                                <td><input class="input-field" type="text" size="5" placeholder="작성일" aria-label="작성일" name="BUwdate" id="BUwdate" value="<%=BUwdate%>" onkeypress="handleKeyPress(event, 'BUwdate', 'BUwdate')"/><%=BUwdate%></td> <!-- 최초 작성일 -->
                                <td><input class="input-field" type="text" size="5" placeholder="수정자" aria-label="수정자" name="BUemidx" id="BUemidx" value="<%=BUemidx%>" onkeypress="handleKeyPress(event, 'BUemidx', 'BUemidx')"/><%=BUemidx%></td> <!-- 최종 수정자 키 -->
                                <td><input class="input-field" type="text" size="5" placeholder="수정일" aria-label="수정일" name="BUewdate" id="BUewdate" value="<%=BUewdate%>" onkeypress="handleKeyPress(event, 'BUewdate', 'BUewdate')"/><%=BUewdate%></td> <!-- 최종 수정일시 -->
                            </tr>
                            <% end if %>
                            <%
                                SQL = "SELECT BUIDX, BUSELECT, BUCODE, BUshorten, BUNAME, BUQTY, BUSTATUS, qtype, atype, Buprice, "
                                SQL = SQL & "BUGEMHYUNG, BUBIJUNG, BUDUKKE, BUHIGH, BU_BOGANG_LENGTH, BUIMAGES, BUCADFILES, BUsangbarTYPE, "
                                SQL = SQL & "BUhabarTYPE, BUchulmolbarTYPE, BUpainttype, BUgrouptype, BUST_GLASS, BUST_N_CUT_STATUS, "
                                SQL = SQL & "BUST_HL_COIL, BUST_NUCUT_ShRing, BUST_NUCUT_1, BUST_NUCUT_2, BUST_VCUT_ShRing, "
                                SQL = SQL & "BUST_VCUT_1, BUST_VCUT_2, BUST_VCUT_CH, BUmidx, Convert(varchar(10),BUwdate,121), BUemidx, Convert(varchar(10),BUewdate,121)  "
                                SQL = SQL & "FROM tk_BUSOK "
                                SQL = SQL & "WHERE BUST_GLASS IS NOT NULL"

                                If Request("SearchWord")<>"" Then 
                                    SQL=SQL&" AND ( BUNAME like '%" & Request("SearchWord") & "%' or BUST_GLASS like '%" & Request("SearchWord") & "%' or BUST_VCUT_CH like '%" & Request("SearchWord") & "%') "
                                End If 
                                SQL=SQL&" Order by BUIDX DEsc "
                                'Response.write (SQL)&"<br>"
                                
                                Rs.open Sql,Dbcon,1,1,1
                                if not (Rs.EOF or Rs.BOF ) then
                                Do while not Rs.EOF

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
                                i=i+1
                            %>
                            <% if int(BUIDX)=int(rBUIDX) then %>
                            <tr>
                                <td align="center"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=BUIDX%>');"><%=i%></button></td><!-- 순번 -->
                                <td><input class="input-field" type="text" size="10" placeholder="선택" aria-label="선택" name="BUSELECT" id="BUSELECT" value="<%=BUSELECT%>" onkeypress="handleKeyPress(event, 'BUSELECT', 'BUSELECT')"/></td> <!-- 타입선택여부 -->
                                <td><input class="input-field" type="text" size="30" placeholder="품명" aria-label="품명" name="BUNAME" id="BUNAME" value="<%=BUNAME%>" onkeypress="handleKeyPress(event, 'BUNAME', 'BUNAME')"/></td> <!-- 품명 -->
                                <td><input class="input-field" type="text" size="5" placeholder="사용중/안함" aria-label="사용중/안함" name="BUSTATUS" id="BUSTATUS" value="<%=BUSTATUS%>" onkeypress="handleKeyPress(event, 'BUSTATUS', 'BUSTATUS')"/><%=BUSTATUS%></td> <!-- 사용중/안함 -->
                                <td><input class="input-field" type="text" size="10" placeholder="이미지" aria-label="이미지" name="BUIMAGES" id="BUIMAGES" value="<%=BUIMAGES%>" onkeypress="handleKeyPress(event, 'BUIMAGES', 'BUIMAGES')"/><%=BUIMAGES%></td> <!-- 이미지파일 -->
                                <td><input class="input-field" type="text" size="10" placeholder="캐드파일" aria-label="캐드파일" name="BUCADFILES" id="BUCADFILES" value="<%=BUCADFILES%>" onkeypress="handleKeyPress(event, 'BUCADFILES', 'BUCADFILES')"/><%=BUCADFILES%></td> <!-- 캐드파일 -->
                                <td><input class="input-field" type="text" size="10" placeholder="유리두께" aria-label="유리두께" name="BUST_GLASS" id="BUST_GLASS" value="<%=BUST_GLASS%>" onkeypress="handleKeyPress(event, 'BUST_GLASS', 'BUST_GLASS')"/><%=BUST_GLASS%></td> <!-- 유리두께 -->  
                                <td><input class="input-field" type="text" size="10" placeholder="노컷/컷 " aria-label="노컷/컷 " name="BUST_N_CUT_STATUS" id="BUST_N_CUT_STATUS" value="<%=BUST_N_CUT_STATUS%>" onkeypress="handleKeyPress(event, 'BUST_N_CUT_STATUS', 'BUST_N_CUT_STATUS')"/><%=BUST_N_CUT_STATUS%></td> <!-- 노컷/컷 유무(0/1) -->
                                <td><input class="input-field" type="text" size="10" placeholder="코일 매치" aria-label="코일 매치" name="BUST_HL_COIL" id="BUST_HL_COIL" value="<%=BUST_HL_COIL%>" onkeypress="handleKeyPress(event, 'BUST_HL_COIL', 'BUST_HL_COIL')"/><%=BUST_HL_COIL%></td> <!-- 헤어라인코일 매치 (0/1) -->
                                <td><input class="input-field" type="text" size="10" placeholder="노컷절단" aria-label="노컷절단" name="BUST_NUCUT_ShRing" id="BUST_NUCUT_ShRing" value="<%=BUST_NUCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_ShRing', 'BUST_NUCUT_ShRing')"/><%=BUST_NUCUT_ShRing%></td> <!-- 노컷절단 -->
                                <td><input class="input-field" type="text" size="5" placeholder="노컷 1차" aria-label="노컷 1차" name="BUST_NUCUT_1" id="BUST_NUCUT_1" value="<%=BUST_NUCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_1', 'BUST_NUCUT_1')"/><%=BUST_NUCUT_1%></td> <!-- 노컷 1차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="노컷 2차" aria-label="노컷 2차" name="BUST_NUCUT_2" id="BUST_NUCUT_2" value="<%=BUST_NUCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_NUCUT_2', 'BUST_NUCUT_2')"/><%=BUST_NUCUT_2%></td> <!-- 노컷 2차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷절단" aria-label="V컷절단" name="BUST_VCUT_ShRing" id="BUST_VCUT_ShRing" value="<%=BUST_VCUT_ShRing%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_ShRing', 'BUST_VCUT_ShRing')"/><%=BUST_VCUT_ShRing%></td> <!-- V컷절단 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷 1차" aria-label="V컷 1차" name="BUST_VCUT_1" id="BUST_VCUT_1" value="<%=BUST_VCUT_1%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_1', 'BUST_VCUT_1')"/><%=BUST_VCUT_1%></td> <!-- V컷 1차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷 2차" aria-label="V컷 2차" name="BUST_VCUT_2" id="BUST_VCUT_2" value="<%=BUST_VCUT_2%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_2', 'BUST_VCUT_2')"/><%=BUST_VCUT_2%></td> <!-- V컷 2차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷 채널넘버" aria-label="V컷 채널넘버" name="BUST_VCUT_CH" id="BUST_VCUT_CH" value="<%=BUST_VCUT_CH%>" onkeypress="handleKeyPress(event, 'BUST_VCUT_CH', 'BUST_VCUT_CH')"/><%=BUST_VCUT_CH%></td> <!-- V컷 채널넘버 -->
                                <td><input class="input-field" type="text" size="5" placeholder="작성자" aria-label="작성자" name="BUmidx" id="BUmidx" value="<%=BUmidx%>" onkeypress="handleKeyPress(event, 'BUmidx', 'BUmidx')"/><%=BUmidx%></td> <!-- 작성자 키 -->
                                <td><input class="input-field" type="text" size="5" placeholder="작성일" aria-label="작성일" name="BUwdate" id="BUwdate" value="<%=BUwdate%>" onkeypress="handleKeyPress(event, 'BUwdate', 'BUwdate')"/><%=BUwdate%></td> <!-- 최초 작성일 -->
                                <td><input class="input-field" type="text" size="5" placeholder="수정자" aria-label="수정자" name="BUemidx" id="BUemidx" value="<%=BUemidx%>" onkeypress="handleKeyPress(event, 'BUemidx', 'BUemidx')"/><%=BUemidx%></td> <!-- 최종 수정자 키 -->
                                <td><input class="input-field" type="text" size="5" placeholder="수정일" aria-label="수정일" name="BUewdate" id="BUewdate" value="<%=BUewdate%>" onkeypress="handleKeyPress(event, 'BUewdate', 'BUewdate')"/><%=BUewdate%></td> <!-- 최종 수정일시 -->
                            </tr>
                            <% else %>
                            <tr>
                                <td align="center"><%=i%></td><!-- 순번 -->
                                <td><input class="input-field" type="text" size="10" placeholder="선택" aria-label="선택" name="BUSELECT" id="BUSELECT" value="<%=BUSELECT%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 타입선택여부 -->
                                <td><input class="input-field" type="text" size="30" placeholder="품명" aria-label="품명" name="BUNAME" id="BUNAME" value="<%=BUNAME%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 품명 -->
                                <td><input class="input-field" type="text" size="5" placeholder="사용중/안함" aria-label="사용중/안함" name="BUSTATUS" id="BUSTATUS" value="<%=BUSTATUS%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 사용중/안함 -->
                                <td><input class="input-field" type="text" size="10" placeholder="이미지" aria-label="이미지" name="BUIMAGES" id="BUIMAGES" value="<%=BUIMAGES%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 이미지파일 -->
                                <td><input class="input-field" type="text" size="10" placeholder="캐드파일" aria-label="캐드파일" name="BUCADFILES" id="BUCADFILES" value="<%=BUCADFILES%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 캐드파일 -->
                                <td><input class="input-field" type="text" size="10" placeholder="유리두께" aria-label="유리두께" name="BUST_GLASS" id="BUST_GLASS" value="<%=BUST_GLASS%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 유리두께 -->  
                                <td><input class="input-field" type="text" size="10" placeholder="노컷/컷 " aria-label="노컷/컷 " name="BUST_N_CUT_STATUS" id="BUST_N_CUT_STATUS" value="<%=BUST_N_CUT_STATUS%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 노컷/컷 유무(0/1) -->
                                <td><input class="input-field" type="text" size="10" placeholder="코일 매치" aria-label="코일 매치" name="BUST_HL_COIL" id="BUST_HL_COIL" value="<%=BUST_HL_COIL%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 헤어라인코일 매치 (0/1) -->
                                <td><input class="input-field" type="text" size="10" placeholder="노컷절단" aria-label="노컷절단" name="BUST_NUCUT_ShRing" id="BUST_NUCUT_ShRing" value="<%=BUST_NUCUT_ShRing%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 노컷절단 -->
                                <td><input class="input-field" type="text" size="5" placeholder="노컷 1차" aria-label="노컷 1차" name="BUST_NUCUT_1" id="BUST_NUCUT_1" value="<%=BUST_NUCUT_1%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 노컷 1차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="노컷 2차" aria-label="노컷 2차" name="BUST_NUCUT_2" id="BUST_NUCUT_2" value="<%=BUST_NUCUT_2%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 노컷 2차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷절단" aria-label="V컷절단" name="BUST_VCUT_ShRing" id="BUST_VCUT_ShRing" value="<%=BUST_VCUT_ShRing%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- V컷절단 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷 1차" aria-label="V컷 1차" name="BUST_VCUT_1" id="BUST_VCUT_1" value="<%=BUST_VCUT_1%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- V컷 1차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷 2차" aria-label="V컷 2차" name="BUST_VCUT_2" id="BUST_VCUT_2" value="<%=BUST_VCUT_2%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- V컷 2차 -->
                                <td><input class="input-field" type="text" size="5" placeholder="V컷 채널넘버" aria-label="V컷 채널넘버" name="BUST_VCUT_CH" id="BUST_VCUT_CH" value="<%=BUST_VCUT_CH%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- V컷 채널넘버 -->
                                <td><input class="input-field" type="text" size="5" placeholder="작성자" aria-label="작성자" name="BUmidx" id="BUmidx" value="<%=BUmidx%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 작성자 키 -->
                                <td><input class="input-field" type="text" size="5" placeholder="작성일" aria-label="작성일" name="BUwdate" id="BUwdate" value="<%=BUwdate%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 최초 작성일 -->
                                <td><input class="input-field" type="text" size="5" placeholder="수정자" aria-label="수정자" name="BUemidx" id="BUemidx" value="<%=BUemidx%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 최종 수정자 키 -->
                                <td><input class="input-field" type="text" size="5" placeholder="수정일" aria-label="수정일" name="BUewdate" id="BUewdate" value="<%=BUewdate%>" onclick="location.replace('pummok_Busok_ST_item.asp?rbuidx=<%=buidx%>');"/></td> <!-- 최종 수정일시 -->
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
    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>