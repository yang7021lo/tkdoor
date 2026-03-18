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
Set Rs = Server.CreateObject("ADODB.Recordset")

part=Request("part")
rsjbtidx=Request("sjbtidx")
' 파일 및 폼 데이터 읽기
gotopage = Request("gotopage")
rSJB_IDX       = Request("SJB_IDX")
rSJB_TYPE_NO   = Request("SJB_TYPE_NO")
rSJB_TYPE_NAME = Request("SJB_TYPE_NAME")
rSearchWord    = Request("SearchWord")
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "rSJB_TYPE_NO : " & rSJB_TYPE_NO & "<br>"
'Response.Write "rSJB_TYPE_NAME : " & rSJB_TYPE_NAME & "<br>"
'Response.Write "rSJB_barlist : " & rSJB_barlist & "<br>"
'Response.end
' 🔹 추가된 컬럼들 - 모두 r 접두어 적용
rdwsize1  = Request("dwsize1")
rdwsize2  = Request("dwsize2")
rdwsize3  = Request("dwsize3")
rdwsize4  = Request("dwsize4")
rdwsize5  = Request("dwsize5")

rdhsize1  = Request("dhsize1")
rdhsize2  = Request("dhsize2")
rdhsize3  = Request("dhsize3")
rdhsize4  = Request("dhsize4")
rdhsize5  = Request("dhsize5")

rgwsize1  = Request("gwsize1")
rgwsize2  = Request("gwsize2")
rgwsize3  = Request("gwsize3")
rgwsize4  = Request("gwsize4")
rgwsize5  = Request("gwsize5")
rgwsize6  = Request("gwsize6")

rghsize1  = Request("ghsize1")
rghsize2  = Request("ghsize2")
rghsize3  = Request("ghsize3")
rghsize4  = Request("ghsize4")
rghsize5  = Request("ghsize5")
rghsize6  = Request("ghsize6")
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
        body {
            zoom: 1;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <style>
        /* 카드 전체 크기 조정 */
        .card.card-body {
            padding: 1px; /* 내부 여백 줄이기 */
            margin-bottom: 0.5rem; /* 하단 여백 줄이기 */
        }

        /* 글씨 크기 및 입력 필드 크기 조정 */
        .form-control {
            font-size: 12px; /* 글씨 크기 줄이기 */
            height: 25px; /* 입력 필드 높이 줄이기 */
            padding: 1px 1px; /* 내부 여백 줄이기 */
        }

        /* 레이블 크기 조정 */
        label {
            font-size: 12px;
            margin-bottom: 0px; /* 레이블과 입력 필드 간격 최소화 */
        }

        /* 행(row) 간격 줄이기 */
        .row {
            margin-bottom: 0px; /* 행 간격 줄이기 */
        }
        /* 🔹 버튼 크기 조정 */
        .btn-small {
            font-size: 18px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 22px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
        
    </style>
    <style>
        .svg-container {
            width: 250px;
        }
        svg {
            width: 100%;
            height: auto;
        }
    </style>
   <script>
        // 공통 키프레스 핸들러
        function handleKeyPress(event, elementId1, elementId2) {
            if (event.key === "Enter") {
                event.preventDefault();
                console.log(`Enter 눌림: ${elementId1}, ${elementId2}`);
                document.getElementById("hiddenSubmit").click();
            }
        }

        // Select 박스 변경(마우스 클릭/선택) 이벤트 핸들러
        function handleSelectChange(event, elementId1, elementId2) {
            console.log(`선택 변경됨: ${elementId1}, ${elementId2}`);
            document.getElementById("hiddenSubmit").click();
        }

        function handleChange(selectElement) {
            const selectedValue = selectElement.value;
            document.getElementById("hiddenSubmit").click();
        }

        // 폼 전체 Enter 이벤트 감지 (기본 방지 + 숨겨진 버튼 클릭)
        document.getElementById("dataForm").addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                event.preventDefault(); // 기본 Enter 동작 방지
                console.log("폼 전체에서 Enter 감지");
                document.getElementById("hiddenSubmit").click();
            }
        });
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_SJB_TYPE_INSERTdbgl.asp?part=delete&sjbtidx="+sTR;
            }
        }
    </script>
</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
            <div class="py-5 container text-center">
                    <!-- 제목 나오는 부분 시작-->
                    <div class="row mb-3">
                        <div class="col text-start">
                            <h3>품목명 추가</h3>
                        </div>
                        <div class="col text-end">
                            <button type="button"
                                class="btn btn-outline-danger"
                                style="writing-mode: horizontal-tb; letter-spa
                                g: normal; white-space: nowrap;"
                                onclick="location.replace('TNG1b.asp');">돌아가기
                            </button>
                            <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG1_SJB_TYPE_INSERTgl.asp?sjbtidx=0');">등록</button>
                        </div>
                    </div>
                    <!-- 제목 나오는 부분 끝-->
                        
                    <!-- 표 형식 시작--> 
                    <div class="input-group mb-3">
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">번호</th>
                                    <th width="160" rowspan="2" style="text-align:center; vertical-align:middle;">품목</th>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">수동<br>자동</th>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">✅<br>❌</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">도어사용_위치값1<br>:(외도어)</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">도어사용_위치값2<br>:(양개)</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">픽스사용_위치값1<br>:하부픽스유리1</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">픽스사용_위치값2<br>(박스라인 경우)<br>:하부픽스유리2</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">픽스사용_위치값3<br>:상부픽스유리1</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">도어사용_위치값3<br>:(언밸런스)_미정</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">도어사용_위치값4<br>:_미정</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">도어사용_위치값5<br>:_미정</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">픽스사용_위치값4<br>:상부픽스유리2</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">픽스사용_위치값5<br>:상부픽스유리3</th>
                                    <th width="40" colspan="2" style="text-align:center; vertical-align:middle;">픽스사용_위치값6<br>:상부픽스유리4</th>
                                </tr>
                                    <th width="40" style="text-align:center; vertical-align:middle;">도어w<br>:편개</th>
                                    <th width="40" style="text-align:center; vertical-align:middle;">도어h<br>:편개</th>
                                    <th width="40" style="text-align:center; vertical-align:middle;">도어w<br>:양개</th>
                                    <th width="40" style="text-align:center; vertical-align:middle;">도어h<br>:양개</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스w</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스h</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스1w</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스1h</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스2w</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스2h</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">도어2w<br>:언밸런스</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">도어2h<br>:언밸런스</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">도어3w</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">도어3h</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">도어4w</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">도어4h</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스3w</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스3h</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스4w</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스4h</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스5w</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">픽스5h</th>
                                </tr>
                            </thead>
                            <tbody>
                                <form id="dataForm" action="TNG1_SJB_TYPE_INSERTdbgl.asp" method="POST">   
                                    <input type="hidden" name="sjbtidx" value="<%=rsjbtidx%>">
                                    <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">

                                    <% if rsjbtidx="0" then %>
                                        <tr>
                                            <%
                                            ' 🔹 마지막 SJB_TYPE_NO 구하기
                                            sql = "SELECT ISNULL(MAX(SJB_TYPE_NO), 0) + 1 FROM tng_sjbtype"
                                            Rs.open sql, Dbcon, 1, 1
                                            If Not (Rs.EOF Or Rs.BOF) Then
                                                rjb_type_no = Rs(0)
                                            End If
                                            Rs.Close
                                            %>
                                            <td><input class="input-field" type="text" size="3" placeholder="품목번호" aria-label="품목번호" name="sjb_type_no" id="sjb_type_no" value="<%=rjb_type_no%>" onkeypress="handleKeyPress(event, 'sjb_type_no', 'sjb_type_no')"/></td> 
                                            <td><input class="input-field" type="text" size="16" name="sjb_type_name" id="sjb_type_name" value="<%=rsjb_type_name%>"  onkeypress="handleKeyPress(event, 'sjb_type_name', 'sjb_type_name')"/></td>
                                            <td></td>
                                            <td>
                                                <select class="input-field" name="sjbtstatus" id="sjbtstatus"  onchange="handleSelectChange(event, 'sjbtstatus', 'sjbtstatus')">
                                                    <option value="1" <% If sjbtstatus = "1" Then Response.Write "selected" %> >✅</option>
                                                </select>
                                            </td> 
                                        </tr>
                                    <% end if %>
                                            <%
                                            sql = "SELECT sjbtidx, SJB_TYPE_NO, SJB_TYPE_NAME "
                                            sql = sql & " , sjbtstatus, gwsize1, ghsize1, dwsize1, dhsize1 "
                                            sql = sql & " , dwsize2, dhsize2, dwsize3, dhsize3, dwsize4, dhsize4 "
                                            sql = sql & " , dwsize5, dhsize5, gwsize2, gwsize3, gwsize4, gwsize5, gwsize6 "
                                            sql = sql & " , ghsize2, ghsize3, ghsize4, ghsize5, ghsize6 "
                                            sql = sql & " , SJB_FA "
                                            sql = sql & " FROM tng_sjbtype "
                                            'sql = sql & " WHERE tng_sjbtype = 1 "
                                            sql = sql & " ORDER BY sjbtidx DESC "
                                            Rs.open Sql,Dbcon,1,1,1
                                            if not (Rs.EOF or Rs.BOF ) then
                                            Do while not Rs.EOF
                                                sjbtidx       = Rs(0)
                                                SJB_TYPE_NO   = Rs(1)
                                                SJB_TYPE_NAME = Rs(2)
                                                sjbtstatus    = Rs(3)
                                                gwsize1      = Rs(4)
                                                ghsize1      = Rs(5)
                                                dwsize1      = Rs(6)
                                                dhsize1      = Rs(7)
                                                dwsize2      = Rs(8)
                                                dhsize2      = Rs(9)
                                                dwsize3      = Rs(10)
                                                dhsize3      = Rs(11)
                                                dwsize4      = Rs(12)
                                                dhsize4      = Rs(13)
                                                dwsize5      = Rs(14)
                                                dhsize5      = Rs(15)
                                                gwsize2      = Rs(16)
                                                gwsize3      = Rs(17)
                                                gwsize4      = Rs(18)
                                                gwsize5      = Rs(19)
                                                gwsize6      = Rs(20)
                                                ghsize2      = Rs(21)
                                                ghsize3      = Rs(22)
                                                ghsize4      = Rs(23)
                                                ghsize5      = Rs(24)
                                                ghsize6      = Rs(25)
                                                SJB_FA       = Rs(26)
                                                select case sjbtstatus
                                                    case "0"
                                                        sjbtstatus_text="❌"
                                                    case "1"
                                                        sjbtstatus_text="✅"

                                                end select
                                                select case SJB_FA
                                                    case "0"
                                                        SJB_FA_text="안함"
                                                    case "1"
                                                        SJB_FA_text="수동"
                                                    case "2"
                                                        SJB_FA_text="자동"
                                                end select
                                                i=i+1
                                            %>              
                                            <% if int(sjbtidx)=int(rsjbtidx) then %>
                                        <tr>
                                            <td style="text-align:center; vertical-align:middle;">
                                                <div>
                                                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="del('<%=sjbtidx%>');">삭제</button>
                                                </div>
                                                <div>
                                                    <input class="input-field" type="text" size="3" name="sjb_type_no" id="sjb_type_no" 
                                                        value="<%=sjb_type_no%>" 
                                                        onkeypress="handleKeyPress(event, 'sjb_type_no', 'sjb_type_no')"/>
                                                </div>
                                            </td>
                                            <td><input class="input-field" type="text" size="16" name="sjb_type_name" id="sjb_type_name" value="<%=sjb_type_name%>"  onkeypress="handleKeyPress(event, 'sjb_type_name', 'sjb_type_name')"/></td>
                                            <td>
                                                <select class="input-field" name="SJB_FA" id="SJB_FA"  onchange="handleSelectChange(event, 'SJB_FA', 'SJB_FA')">
                                                    <option value="0" <% If SJB_FA = "0" Then Response.Write "selected" %> >안함</option>
                                                    <option value="1" <% If SJB_FA = "1" Then Response.Write "selected" %> >수동</option>
                                                    <option value="2" <% If SJB_FA = "2" Then Response.Write "selected" %> >자동</option>
                                                </select>
                                            </td> 
                                            <td>
                                                <select class="input-field" name="sjbtstatus" id="sjbtstatus"  onchange="handleSelectChange(event, 'sjbtstatus', 'sjbtstatus')">
                                                    <option value="0" <% If sjbtstatus = "0" Then Response.Write "selected" %> >❌</option>
                                                    <option value="1" <% If sjbtstatus = "1" Then Response.Write "selected" %> >✅</option>
                                                </select>
                                            </td> 
                                            <td><input class="input-field" type="text" size="4" name="dwsize1" id="dwsize1" value="<%=dwsize1%>" onkeypress="handleKeyPress(event, 'dwsize1', 'dwsize1')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="dhsize1" id="dhsize1" value="<%=dhsize1%>" onkeypress="handleKeyPress(event, 'dhsize1', 'dhsize1')" /></td>

                                            <td><input class="input-field" type="text" size="4" name="dwsize2" id="dwsize2" value="<%=dwsize2%>" onkeypress="handleKeyPress(event, 'dwsize2', 'dwsize2')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="dhsize2" id="dhsize2" value="<%=dhsize2%>" onkeypress="handleKeyPress(event, 'dhsize2', 'dhsize2')" /></td>

                                            

                                            <!-- gwsize / ghsize 짝으로 나열 -->
                                            <td><input class="input-field" type="text" size="4" name="gwsize1" id="gwsize1" value="<%=gwsize1%>" onkeypress="handleKeyPress(event, 'gwsize1', 'gwsize1')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="ghsize1" id="ghsize1" value="<%=ghsize1%>" onkeypress="handleKeyPress(event, 'ghsize1', 'ghsize1')" /></td>

                                            <td><input class="input-field" type="text" size="4" name="gwsize2" id="gwsize2" value="<%=gwsize2%>" onkeypress="handleKeyPress(event, 'gwsize2', 'gwsize2')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="ghsize2" id="ghsize2" value="<%=ghsize2%>" onkeypress="handleKeyPress(event, 'ghsize2', 'ghsize2')" /></td>

                                            <td><input class="input-field" type="text" size="4" name="gwsize3" id="gwsize3" value="<%=gwsize3%>" onkeypress="handleKeyPress(event, 'gwsize3', 'gwsize3')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="ghsize3" id="ghsize3" value="<%=ghsize3%>" onkeypress="handleKeyPress(event, 'ghsize3', 'ghsize3')" /></td>

                                            <td><input class="input-field" type="text" size="4" name="dwsize3" id="dwsize3" value="<%=dwsize3%>" onkeypress="handleKeyPress(event, 'dwsize3', 'dwsize3')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="dhsize3" id="dhsize3" value="<%=dhsize3%>" onkeypress="handleKeyPress(event, 'dhsize3', 'dhsize3')" /></td>

                                            <td><input class="input-field" type="text" size="4" name="dwsize4" id="dwsize4" value="<%=dwsize4%>" onkeypress="handleKeyPress(event, 'dwsize4', 'dwsize4')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="dhsize4" id="dhsize4" value="<%=dhsize4%>" onkeypress="handleKeyPress(event, 'dhsize4', 'dhsize4')" /></td>

                                            <td><input class="input-field" type="text" size="4" name="dwsize5" id="dwsize5" value="<%=dwsize5%>" onkeypress="handleKeyPress(event, 'dwsize5', 'dwsize5')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="dhsize5" id="dhsize5" value="<%=dhsize5%>" onkeypress="handleKeyPress(event, 'dhsize5', 'dhsize5')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="gwsize4" id="gwsize4" value="<%=gwsize4%>" onkeypress="handleKeyPress(event, 'gwsize4', 'gwsize4')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="ghsize4" id="ghsize4" value="<%=ghsize4%>" onkeypress="handleKeyPress(event, 'ghsize4', 'ghsize4')" /></td>

                                            <td><input class="input-field" type="text" size="4" name="gwsize5" id="gwsize5" value="<%=gwsize5%>" onkeypress="handleKeyPress(event, 'gwsize5', 'gwsize5')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="ghsize5" id="ghsize5" value="<%=ghsize5%>" onkeypress="handleKeyPress(event, 'ghsize5', 'ghsize5')" /></td>

                                            <td><input class="input-field" type="text" size="4" name="gwsize6" id="gwsize6" value="<%=gwsize6%>" onkeypress="handleKeyPress(event, 'gwsize6', 'gwsize6')" /></td>
                                            <td><input class="input-field" type="text" size="4" name="ghsize6" id="ghsize6" value="<%=ghsize6%>" onkeypress="handleKeyPress(event, 'ghsize6', 'ghsize6')" /></td>

                                        </tr>

                                            <% else %>
                                        <tr> 
                                            <!--  <td style="text-align:center; vertical-align:middle;"><%=i%></td> -->
                                            <td><input class="input-field" type="text" size="1"  value="<%=sjb_type_no%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td> 
                                            <td><input class="input-field" type="text" size="16" value="<%=sjb_type_name%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=SJB_FA_text%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=sjbtstatus_text%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=dwsize1%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=dhsize1%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>

                                            <td><input class="input-field" type="text" size="4" value="<%=dwsize2%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=dhsize2%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>

                                            

                                            <td><input class="input-field" type="text" size="4" value="<%=gwsize1%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=ghsize1%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>

                                            <td><input class="input-field" type="text" size="4" value="<%=gwsize2%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=ghsize2%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>

                                            <td><input class="input-field" type="text" size="4" value="<%=gwsize3%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=ghsize3%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>

                                            <td><input class="input-field" type="text" size="4" value="<%=dwsize3%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=dhsize3%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>

                                            <td><input class="input-field" type="text" size="4" value="<%=dwsize4%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=dhsize4%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>

                                            <td><input class="input-field" type="text" size="4" value="<%=dwsize5%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=dhsize5%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=gwsize4%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=ghsize4%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>

                                            <td><input class="input-field" type="text" size="4" value="<%=gwsize5%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=ghsize5%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>

                                            <td><input class="input-field" type="text" size="4" value="<%=gwsize6%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>
                                            <td><input class="input-field" type="text" size="4" value="<%=ghsize6%>" onclick="location.replace('tng1_sjb_type_insertgl.asp?sjbtidx=<%=sjbtidx%>');"/></td>


                                            <% end if %>
                                            <%
                                            Rs.movenext
                                            Loop
                                            End If 
                                            Rs.Close 
                                            %>
                                        <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                                </form>
                            </tbody>
                        </table>
                    </div>
<!-- 표 형식 끝--> 

 
    </div>    

    <!--화면 끝-->
        
</div>
</div>
</main>                          
                <!-- footer 시작 -->    
                Coded By 양양
                <!-- footer 끝 --> 
</div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
</body>
</html>

<%
set Rs = Nothing
call dbClose()
%>
