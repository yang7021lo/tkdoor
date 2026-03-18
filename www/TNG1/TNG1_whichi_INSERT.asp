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

mode       = Request("mode")


part=Request("part")
rbfwidx=Request("bfwidx")
' 파일 및 폼 데이터 읽기
gotopage = Request("gotopage")
rWHICHI_FIX       = Request("WHICHI_FIX")
rWHICHI_FIXname   = Request("WHICHI_FIXname")
rWHICHI_AUTO      = Request("WHICHI_AUTO")
rWHICHI_AUTOname  = Request("WHICHI_AUTOname")
bfwstatus         = Request("bfwstatus")
rSearchWord       = Request("SearchWord")
runittype_bfwidx       = Request("unittype_bfwidx")
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "rSJB_TYPE_NO : " & rSJB_TYPE_NO & "<br>"
'Response.Write "rSJB_TYPE_NAME : " & rSJB_TYPE_NAME & "<br>"
'Response.Write "rSJB_barlist : " & rSJB_barlist & "<br>"
'Response.end

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

        
        function del(rbfwidx, mode){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href = "TNG1_whichi_INSERTdb.asp?part=delete&bfwidx=" + rbfwidx + "&mode=" + mode;
            }
        }
    </script>
</head>
<body class="sb-nav-sudonged">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
            <div class="py-5 container text-center">
            <!-- 제목 나오는 부분 시작-->
                    <div class="row mb-3">
                        <div class="col-1">
                            <h3>품목명 추가</h3>
                        </div>
                        <div class="col-2">
                            <button type="button" class="btn btn-outline-dark" Onclick="location.replace('TNG1_whichi_INSERT.asp?mode=sudong');">수동위치</button>
                            <button type="button" class="btn btn-outline-dark" Onclick="location.replace('TNG1_whichi_INSERT.asp?mode=auto');">자동위치</button>
                        </div>
                        <div class="col text-end">
                        <% if mode="sudong" then %>
                            <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG1_whichi_INSERT.asp?bfwidx=0&mode=sudong');">수동등록</button>
                        <% elseif mode="auto" then %>
                            <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG1_whichi_INSERT.asp?bfwidx=0&mode=auto');">자동등록</button>
                        <% end if %>
                        </div>
                    </div>
            <!-- 제목 나오는 부분 끝-->
            
<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">품목번호</th>
                      <% if mode="sudong" then %>
                      <th align="center">수동위치번호</th>
                      <th align="center">수동위치명</th>
                       <% elseif mode="auto" then %>
                      <th align="center">자동위치번호</th>
                      <th align="center">자동위치명</th>
                      <% end if %>
                      <th align="center">자재위치 </th>
                      <th align="center">유리자재위치</th>
                      <th align="center">unittype</th>
                  </tr>
              </thead>
              <tbody>
<form id="dataForm" action="TNG1_whichi_INSERTdb.asp" method="POST">   
<input type="hidden" name="bfwidx" value="<%=rbfwidx%>">
<input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
<input type="hidden" name="mode" value="<%=mode%>">

<% if rbfwidx="0" then 
rWHICHI_FIX=0
rWHICHI_AUTO=0
rglassselect=0
rbfwstatus=1
%>

                  <tr>
                      <td></td>
                      <% if mode="sudong" then %>
                        <%
                         '🔹 마지막 WHICHI_FIX 구하기
                        SQL = "SELECT ISNULL(MAX(WHICHI_FIX), 0) + 1 FROM tng_whichitype"
                        Rs.Open SQL, Dbcon
                        If Not (Rs.EOF Or Rs.BOF) Then
                            rWHICHI_FIX = Rs(0) 
                            rWHICHI_AUTO = 0
                        End if
                        Rs.Close
                        %>
                      <td><input class="input-field" type="text"   name="WHICHI_FIX" id="WHICHI_FIX" value="<%=rWHICHI_FIX%>" onkeypress="handleKeyPress(event, 'WHICHI_FIX', 'WHICHI_FIX')"/></td> 
                      <td><input class="input-field" type="text" name="WHICHI_FIXname" id="WHICHI_FIXname" value="<%=rWHICHI_FIXname%>" onkeypress="handleKeyPress(event, 'WHICHI_FIXname', 'WHICHI_FIXname')"/></td>
                       <td>
                            <select class="input-field" name="bfwstatus" id="bfwstatus"  onchange="handleSelectChange(event, 'bfwstatus', 'bfwstatus')">
                                <option value="1" <% If bfwstatus = "1" Then Response.Write "selected" %> >✅</option>
                            </select>
                        </td> 
                        <td>
                            <select class="input-field" name="glassselect" id="glassselect"  onchange="handleSelectChange(event, 'bfwstatus', 'bfwstatus')">
                                <option value="0" <% If glassselect = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If glassselect = "1" Then Response.Write "selected" %> >외도어 </option>
                                <option value="2" <% If glassselect = "2" Then Response.Write "selected" %> >양개도어 </option>
                                <option value="3" <% If glassselect = "3" Then Response.Write "selected" %> >하부픽스유리 </option>
                                <option value="4" <% If glassselect = "4" Then Response.Write "selected" %> >상부남마픽스유리 </option>
                                <option value="5" <% If glassselect = "5" Then Response.Write "selected" %> >박스라인하부픽스유리 </option>
                                <option value="6" <% If glassselect = "6" Then Response.Write "selected" %> >박스라인상부픽스유리 </option>
                                
                            </select>
                        </td> 
                        <td>
                            <select class="input-field" name="unittype_bfwidx" id="unittype_bfwidx"  onchange="handleSelectChange(event, 'unittype_bfwidx', 'unittype_bfwidx')">
                                <option value="0" <% If unittype_bfwidx = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If unittype_bfwidx = "1" Then Response.Write "selected" %> >45바</option>
                                <option value="2" <% If unittype_bfwidx = "2" Then Response.Write "selected" %> >60~100바 </option>
                                <option value="3" <% If unittype_bfwidx = "3" Then Response.Write "selected" %> >코너바</option>
                                
                            </select>
                        </td>  
                      <% elseif mode="auto" then %>
                      <%
                        ' 🔹 마지막 WHICHI_AUTO 구하기
                        SQL = "SELECT ISNULL(MAX(WHICHI_AUTO), 0) + 1 FROM tng_whichitype"
                        Rs.Open SQL, Dbcon
                        If Not (Rs.EOF Or Rs.BOF) Then
                            rWHICHI_AUTO = Rs(0) 
                            rWHICHI_FIX = 0
                        End if
                        Rs.Close
                        %>
                      <td><input class="input-field" type="text"   name="WHICHI_AUTO" id="WHICHI_AUTO" value="<%=rWHICHI_AUTO%>" onkeypress="handleKeyPress(event, 'WHICHI_AUTO', 'WHICHI_AUTO')"/></td> 
                      <td><input class="input-field" type="text"   name="WHICHI_AUTOname" id="WHICHI_AUTOname" value="<%=rWHICHI_AUTOname%>"  onkeypress="handleKeyPress(event, 'WHICHI_AUTOname', 'WHICHI_AUTOname')"/></td>
                       <td>
                            <select class="input-field" name="bfwstatus" id="bfwstatus"  onchange="handleSelectChange(event, 'bfwstatus', 'bfwstatus')">
                                <option value="1" <% If bfwstatus = "1" Then Response.Write "selected" %> >✅</option>
                            </select>
                        </td> 
                        <td>
                            <select class="input-field" name="glassselect" id="glassselect"  onchange="handleSelectChange(event, 'glassselect', 'glassselect')">
                                <option value="0" <% If glassselect = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If glassselect = "1" Then Response.Write "selected" %> >외도어 </option>
                                <option value="2" <% If glassselect = "2" Then Response.Write "selected" %> >양개도어 </option>
                                <option value="3" <% If glassselect = "3" Then Response.Write "selected" %> >하부픽스유리 </option>
                                <option value="4" <% If glassselect = "4" Then Response.Write "selected" %> >상부남마픽스유리 </option>

                            </select>
                        </td>
                        <td>
                            <select class="input-field" name="unittype_bfwidx" id="unittype_bfwidx"  onchange="handleSelectChange(event, 'unittype_bfwidx', 'unittype_bfwidx')">
                                <option value="0" <% If unittype_bfwidx = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If unittype_bfwidx = "1" Then Response.Write "selected" %> >기계박스</option>
                                <option value="2" <% If unittype_bfwidx = "2" Then Response.Write "selected" %> >박스커버</option>
                                <option value="3" <% If unittype_bfwidx = "3" Then Response.Write "selected" %> >가로남마</option>
                                <option value="4" <% If unittype_bfwidx = "4" Then Response.Write "selected" %> >중간소대</option>
                                <option value="5" <% If unittype_bfwidx = "5" Then Response.Write "selected" %> >자동&픽스바</option>
                                <option value="6" <% If unittype_bfwidx = "6" Then Response.Write "selected" %> >픽스하바</option>
                                <option value="7" <% If unittype_bfwidx = "7" Then Response.Write "selected" %> >픽스상바</option>
                                <option value="8" <% If unittype_bfwidx = "8" Then Response.Write "selected" %> >코너바</option>
                                <option value="9" <% If unittype_bfwidx = "9" Then Response.Write "selected" %> >하부레일</option>
                                <option value="10" <% If unittype_bfwidx = "10" Then Response.Write "selected" %> >T형_자동홈바</option>
                                <option value="11" <% If unittype_bfwidx = "11" Then Response.Write "selected" %> >오사이</option>
                                <option value="12" <% If unittype_bfwidx = "12" Then Response.Write "selected" %> >자동홈마개</option>
                                <option value="13" <% If unittype_bfwidx = "13" Then Response.Write "selected" %> >민자홈마개</option>
                                <option value="14" <% If unittype_bfwidx = "14" Then Response.Write "selected" %> >이중_뚜껑마감</option>
                                <option value="15" <% If unittype_bfwidx = "15" Then Response.Write "selected" %> >마구리</option>
                                
                            </select>
                        </td>  
                      <% end if %>  
                       

                  </tr>
<% end if %>
<%
sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus ,glassselect, unittype_bfwidx "
sql = sql & "FROM tng_whichitype "
    if mode="sudong" then 
    sql = sql & "WHERE WHICHI_FIX <> '' "
    elseif mode="auto" then
    sql = sql & "WHERE WHICHI_AUTO <> '' "
    end if
sql = sql & "ORDER BY bfwidx ASC "
Rs.open Sql,Dbcon,1,1,1
'Response.write sql & "<br>"
'Response.End
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
    bfwidx           = Rs(0)
    WHICHI_FIX       = Rs(1)
    WHICHI_FIXname   = Rs(2)
    WHICHI_AUTO      = Rs(3)
    WHICHI_AUTOname  = Rs(4)
    bfwstatus        = Rs(5)
    glassselect        = Rs(6)
    unittype_bfwidx    = Rs(7)
    select case bfwstatus
        case "0"
            bfwstatus_text="❌"
        case "1"
            bfwstatus_text="✅"
    end select

    select case glassselect
        case "0"
            glassselect_text="❌"
        case "1"
            glassselect_text="외도어"
        case "2"
            glassselect_text="양개도어"
        case "3"
            glassselect_text="하부픽스유리"     
        case "4"
            glassselect_text="상부남마픽스유리"    
        case "5"
            glassselect_text="박스라인하부픽스유리"  
        case "6"
            glassselect_text="박스라인상부픽스유리"  
    end select
    if mode="sudong" then 
        select case unittype_bfwidx
            case "0"
                unittype_bfwidx_text="❌"
            Case "1"
            unittype_bfwidx_text = "45바"
            Case "2"
                unittype_bfwidx_text = "60~100바"
            Case "3"
                unittype_bfwidx_text = "코너바"
            case else
                unittype_bfwidx_text="(없음)"
        end select    

    elseif mode="auto" then
        select case unittype_bfwidx
            case "0"
                unittype_bfwidx_text="❌"
            Case "1"
            unittype_bfwidx_text = "기계박스"
            Case "2"
                unittype_bfwidx_text = "박스커버"
            Case "3"
                unittype_bfwidx_text = "가로남마"
            Case "4"
                unittype_bfwidx_text = "중간소대"
            Case "5"
                unittype_bfwidx_text = "자동&픽스바"
            Case "6"
                unittype_bfwidx_text = "픽스하바"
            Case "7"
                unittype_bfwidx_text = "픽스상바"
            Case "8"
                unittype_bfwidx_text = "코너바"
            Case "9"
                unittype_bfwidx_text = "하부레일"
            Case "10"
                unittype_bfwidx_text = "T형_자동홈바"
            Case "11"
                unittype_bfwidx_text = "오사이"
            Case "12"
                unittype_bfwidx_text = "자동홈마개"
            Case "13"
                unittype_bfwidx_text = "민자홈마개"
            Case "14"
                unittype_bfwidx_text = "이중_뚜껑마감"
            Case "15"
                unittype_bfwidx_text = "마구리"    
            case else
                unittype_bfwidx_text="(없음)"
        end select    
    end if
    i=i+1
%>              
<% if int(bfwidx)=int(rbfwidx) then %>
                  <tr>
                      <td align="center"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=bfwidx%>','<%=mode%>');"><%=i%></button></td>
                      <% if mode="sudong" then %>
                      <td><input class="input-field" type="text"  placeholder="수동위치번호" aria-label="수동위치번호" name="WHICHI_FIX" id="WHICHI_FIX" value="<%=WHICHI_FIX%>" onkeypress="handleKeyPress(event, 'WHICHI_FIX', 'WHICHI_FIX')"/></td>
                      <td><input class="input-field" type="text"  placeholder="수동위치명" aria-label="수동위치명" name="WHICHI_FIXname" id="WHICHI_FIXname" value="<%=WHICHI_FIXname%>" onkeypress="handleKeyPress(event, 'WHICHI_FIXname', 'WHICHI_FIXname')"/></td>
                      <td>
                            <select class="input-field" name="bfwstatus" id="bfwstatus"  onchange="handleSelectChange(event, 'bfwstatus', 'bfwstatus')">
                                <option value="0" <% If bfwstatus = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If bfwstatus = "1" Then Response.Write "selected" %> >✅</option>
                            </select>
                        </td> 
                        <td>
                            <select class="input-field" name="glassselect" id="glassselect"  onchange="handleSelectChange(event, 'glassselect', 'glassselect')">
                                <option value="0" <% If glassselect = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If glassselect = "1" Then Response.Write "selected" %> >외도어 </option>
                                <option value="2" <% If glassselect = "2" Then Response.Write "selected" %> >양개도어 </option>
                                <option value="3" <% If glassselect = "3" Then Response.Write "selected" %> >하부픽스유리 </option>
                                <option value="4" <% If glassselect = "4" Then Response.Write "selected" %> >상부남마픽스유리 </option>
                                <option value="5" <% If glassselect = "5" Then Response.Write "selected" %> >박스라인하부픽스유리 </option>
                                <option value="6" <% If glassselect = "6" Then Response.Write "selected" %> >박스라인상부픽스유리 </option>
                            </select>
                        </td> 
                        <td>
                            <select class="input-field" name="unittype_bfwidx" id="unittype_bfwidx"  onchange="handleSelectChange(event, 'unittype_bfwidx', 'unittype_bfwidx')">
                                <option value="0" <% If unittype_bfwidx = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If unittype_bfwidx = "1" Then Response.Write "selected" %> >45바</option>
                                <option value="2" <% If unittype_bfwidx = "2" Then Response.Write "selected" %> >60~100바 </option>
                                <option value="3" <% If unittype_bfwidx = "3" Then Response.Write "selected" %> >코너바</option>
                                
                            </select>
                        </td> 
                      <% elseif mode="auto" then %>
                      <td><input class="input-field" type="text"  placeholder="자동위치번호" aria-label="자동위치번호" name="WHICHI_AUTO" id="WHICHI_AUTO" value="<%=WHICHI_AUTO%>" onkeypress="handleKeyPress(event, 'WHICHI_AUTO', 'WHICHI_AUTO')"/></td>
                      <td><input class="input-field" type="text" placeholder="자동위치명" aria-label="자동위치명" name="WHICHI_AUTOname" id="WHICHI_AUTOname" value="<%=WHICHI_AUTOname%>"  onkeypress="handleKeyPress(event, 'WHICHI_AUTOname', 'WHICHI_AUTOname')"/></td>
                      <td>
                            <select class="input-field" name="bfwstatus" id="bfwstatus"  onchange="handleSelectChange(event, 'bfwstatus', 'bfwstatus')">
                                <option value="0" <% If bfwstatus = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If bfwstatus = "1" Then Response.Write "selected" %> >✅</option>
                            </select>
                        </td> 
                        <td>
                            <select class="input-field" name="glassselect" id="glassselect"  onchange="handleSelectChange(event, 'glassselect', 'glassselect')">
                                <option value="0" <% If glassselect = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If glassselect = "1" Then Response.Write "selected" %> >외도어 </option>
                                <option value="2" <% If glassselect = "2" Then Response.Write "selected" %> >양개도어 </option>
                                <option value="3" <% If glassselect = "3" Then Response.Write "selected" %> >하부픽스유리 </option>
                                <option value="4" <% If glassselect = "4" Then Response.Write "selected" %> >상부남마픽스유리 </option>

                            </select>
                        </td> 
                        <td>
                            <select class="input-field" name="unittype_bfwidx" id="unittype_bfwidx"  onchange="handleSelectChange(event, 'unittype_bfwidx', 'unittype_bfwidx')">
                                <option value="0" <% If unittype_bfwidx = "0" Then Response.Write "selected" %> >❌</option>
                                <option value="1" <% If unittype_bfwidx = "1" Then Response.Write "selected" %> >기계박스</option>
                                <option value="2" <% If unittype_bfwidx = "2" Then Response.Write "selected" %> >박스커버</option>
                                <option value="3" <% If unittype_bfwidx = "3" Then Response.Write "selected" %> >가로남마</option>
                                <option value="4" <% If unittype_bfwidx = "4" Then Response.Write "selected" %> >중간소대</option>
                                <option value="5" <% If unittype_bfwidx = "5" Then Response.Write "selected" %> >자동&픽스바</option>
                                <option value="6" <% If unittype_bfwidx = "6" Then Response.Write "selected" %> >픽스하바</option>
                                <option value="7" <% If unittype_bfwidx = "7" Then Response.Write "selected" %> >픽스상바</option>
                                <option value="8" <% If unittype_bfwidx = "8" Then Response.Write "selected" %> >코너바</option>
                                <option value="9" <% If unittype_bfwidx = "9" Then Response.Write "selected" %> >하부레일</option>
                                <option value="10" <% If unittype_bfwidx = "10" Then Response.Write "selected" %> >T형_자동홈바</option>
                                <option value="11" <% If unittype_bfwidx = "11" Then Response.Write "selected" %> >오사이</option>
                                <option value="12" <% If unittype_bfwidx = "12" Then Response.Write "selected" %> >자동홈마개</option>
                                <option value="13" <% If unittype_bfwidx = "13" Then Response.Write "selected" %> >민자홈마개</option>
                                <option value="14" <% If unittype_bfwidx = "14" Then Response.Write "selected" %> >이중_뚜껑마감</option>
                                <option value="15" <% If unittype_bfwidx = "15" Then Response.Write "selected" %> >마구리</option>
                            </select>
                        </td>                           
                       <% end if %>  
                        
                  </tr>
<% else %>
                  <tr> 
                    <td align="center"><%=i%></td>
                    <%
                    'Response.Write "unittype_bfwidx=" & unittype_bfwidx & "<br>"
                    %>
                    <% if mode="sudong" then %>
                    <td><input class="input-field" type="text"  value="<%=WHICHI_FIX%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=sudong#<%=bfwidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=WHICHI_FIXname%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=sudong#<%=bfwidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=bfwstatus_text%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=sudong#<%=bfwidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=glassselect_text%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=sudong#<%=bfwidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=unittype_bfwidx_text%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=sudong#<%=bfwidx%>');"/></td>
                    
                    <% elseif mode="auto" then %>
                    <td><input class="input-field" type="text"  value="<%=WHICHI_AUTO%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=auto#<%=bfwidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=WHICHI_AUTOname%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=auto#<%=bfwidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=bfwstatus_text%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=auto#<%=bfwidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=glassselect_text%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=auto#<%=bfwidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=unittype_bfwidx_text%>" onclick="location.replace('tng1_whichi_insert.asp?bfwidx=<%=bfwidx%>&mode=auto#<%=bfwidx%>');"/></td>
                    
                    <% end if %>
                  </tr>
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
