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
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")
%>
<%

listgubun="two"
subgubun="one2"
projectname="AL자재등록" 
%>
<%

rTNG_Busok_idx=Request("TNG_Busok_idx")
rSearchWord=Request("SearchWord")
'rSJB_TYPE_NO = Request("SJB_TYPE_NO")


	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="TNG1_BUSOK.asp?SearchWord="&Request("SearchWord")&"&"
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
    /* 🔹 버튼 크기 조정 */
    .btn-small {
        font-size: 12px; /* 글씨 크기 */
        padding: 2px 4px; /* 버튼 내부 여백 */
        height: 22px; /* 버튼 높이를 자동으로 */
        line-height: 1; /* 버튼 텍스트 정렬 */
        border-radius: 3px; /* 모서리를 조금 둥글게 */
    }
    </style>
        <style>
        /* 스타일 정의 */
        .input-field {
            width: 100%; /* 너비를 100%로 설정 */
            //padding: 10px; /* 안쪽 여백 */
            //margin-bottom: 15px; /* 아래 여백 */
            border: none; /* 테두리 제거 */
            //border-bottom: 2px solid #ccc; /* 하단 경계선만 추가 */
            //font-size: 16px; /* 글꼴 크기 */
            outline: none; /* 포커스 시 아웃라인 제거 */
        }

        .input-field:focus {
         //   border-bottom: 2px solid #007bff; /* 포커스 시 하단 경계선 강조 */
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
                location.href="TNG1_BUSOK_DB.asp?part=delete&SearchWord=<%=rSearchWord%>&TNG_Busok_idx="+sTR;
            }
        }
    </script>
    <script>
        function validateForm() {
            {
                document.frmMain.submit();
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

        <div class="row justify-content-between">
            <div class="py-5 container text-center  card card-body">
                <div class="input-group mb-3">
                    <h3><%=rSJB_TYPE_NAME%></h3>
                </div>
            
            <div class="col text-end">
                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="TNG1_BUSOK.asp" name="form1">   
                   <!-- <input type="hidden" name="TNG_Busok_idx" value="<%=rTNG_Busok_idx%>"> -->
                    <div style="display: flex; align-items: center; gap: 8px;"> 
                        <input class="form-control" type="text" placeholder="자재 조회" aria-label="자재 조회" aria-describedby="btnNavbarSearch" name="SearchWord" value="<%=Request("SearchWord")%>"/>
                        <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i>검색</button>
                        <button type="button"
                            class="btn btn-outline-danger"
                            style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;"
                            onclick="location.replace('TNG1_BUSOK.asp?TNG_Busok_idx=0');">등록
                        </button>
                    </div>
                </form> 
            </div>
        <div>
            <div style="width: 100%; margin: 0; padding: 0;">
                <table style="width: 100%; border-collapse: collapse;" id="datatablesSimple"  class="table table-hover">
                    <thead>

                    </thead>
                    <tbody>
                        <form id="dataForm" action="TNG1_BUSOK_DB.asp" method="POST" >   
                            <input type="hidden" name="TNG_Busok_idx" value="<%=rTNG_Busok_idx%>">
                            <input type="hidden" name="SearchWord" value="<%=rSearchWord%>">
                            <input type="hidden" name="gotopage" value="<%=gotopage%>">
                            <% if rTNG_Busok_idx="0" then 
                            cccc="#E7E7E7"
                            %>
                            <tr  bgcolor="#c0c0c0">
                            <th  >순번</th>
                            <th   colspan="3" >자재명</th>
                            <th   colspan="3">품목명</th>
                            <th>위치수동</th>                            
                            <th >위치자동</th>
                            <th >자동/수동</th>
                            <th>이미지1</th>
                            <th>이미지2</th>
                        </tr>

                            <tr bgcolor="<%=cccc%>" >

                                <th rowspan="3" style="vertical-align: middle;"></th> <!-- 순번 -->
                                <td  colspan="3" ><input class="input-field" type="text" size="" name="T_Busok_name_f" id="T_Busok_name_f" value="<%=T_Busok_name_f%>" onkeypress="handleKeyPress(event, 'T_Busok_name_f', 'T_Busok_name_f')"/></td> 
                                <td  colspan="3" >
                                    <select class="input-field" name="SJB_TYPE_NO" id="SJB_TYPE_NO"  onchange="handleChange(this)">
                                        <%
                                        If SJB_TYPE_NO = "" Then SJB_TYPE_NO = "0"

                                        sql="SELECT sjbtidx,SJB_TYPE_NO,SJB_TYPE_NAME from tng_sjbtype "
                                        sql=sql&" where sjbtstatus='1' "
                                        'response.write (SQL)&"<br>"
                                        Rs1.open Sql,Dbcon,1,1,1
                                        If Not (Rs1.bof or Rs1.eof) Then 
                                        Do until Rs1.EOF

                                            sjbtidx        = rs1(0)
                                            ySJB_TYPE_NO        = rs1(1)
                                            ySJB_TYPE_NAME        = rs1(2)

                                        %>
                                        <option value="<%=ySJB_TYPE_NO%>" <% If cint(SJB_TYPE_NO) = cint(ySJB_TYPE_NO) Then Response.Write "selected" End If %> >
                                            <%=ySJB_TYPE_NAME%>
                                        </option>
                                        <%
                                        Rs1.MoveNext
                                        Loop
                                        End If
                                        Rs1.close
                                        %>
                                    </select>
                                    <!-- 인서트용 팝업 버튼 -->
                                        <button type="button" class="btn btn-secondary btn-small" 
                                        onclick="window.open('TNG1_SJB_TYPE_INSERT.asp?gotopage=<%=gotopage%>&SJB_IDX=<%=SJB_IDX%>&SearchWord=<%=rSearchWord%>#<%=SJB_IDX%>', 'typeInsert', 'width=500,height=300,scrollbars=no');">
                                        + 추가
                                    </button>
                                </td>
                                <td>
                                    <select class="input-field" name="WHICHI_FIX" id="WHICHI_FIX"  onchange="handleChange(this)">
                                        <option value="0">없음</option>   
                                            <%
                                            sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                            sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                            sql = sql & "FROM tng_whichitype "
                                            sql = sql & "WHERE bfwstatus = 1 and glassselect = 0 "
                                            'response.write (sql)&"<br>"

                                            Rs1.open sql, Dbcon, 1, 1, 1
                                            If Not (Rs1.bof Or Rs1.eof) Then 
                                                Do Until Rs1.EOF

                                                    bfwidx           = Rs1(0)
                                                    yWHICHI_FIX      = Rs1(1)
                                                    yWHICHI_FIXname  = Rs1(2)
                                                    yWHICHI_AUTO     = Rs1(3)
                                                    yWHICHI_AUTOname = Rs1(4)
                                                    bfwstatus        = Rs1(5)
                                            ' 🔹 NULL 또는 빈값이 아니면 출력
                                            If Not IsNull(yWHICHI_FIX)  Then
                                            %>
                                            <option value="<%=yWHICHI_FIX%>" >
                                            <%=yWHICHI_FIXname%>
                                            </option>
                                            <%
                                            End If
                                            Rs1.MoveNext
                                            Loop
                                            End If
                                            Rs1.close
                                            %>
                                    </select>
                                </td>
                                <td>
                                    <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                                        <option value="0">없음</option>   
                                        <%
                                        sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                        sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                        sql = sql & "FROM tng_whichitype "
                                        sql = sql & "WHERE bfwstatus = 1 and glassselect = 0 "
                                        'response.write (sql)&"<br>"

                                        Rs1.open sql, Dbcon, 1, 1, 1
                                        If Not (Rs1.bof Or Rs1.eof) Then 
                                            Do Until Rs1.EOF

                                                bfwidx           = Rs1(0)
                                                yWHICHI_FIX      = Rs1(1)
                                                yWHICHI_FIXname  = Rs1(2)
                                                yWHICHI_AUTO     = Rs1(3)
                                                yWHICHI_AUTOname = Rs1(4)
                                                bfwstatus        = Rs1(5)
                                        ' 🔹 NULL 또는 빈값이 아니면 출력
                                        If Not IsNull(yWHICHI_AUTO)  Then
                                        %>
                                        <option value="<%=yWHICHI_AUTO%>" >
                                            <%=yWHICHI_AUTOname%>
                                        </option>
                                        <%
                                        End If
                                        Rs1.MoveNext
                                        Loop
                                        End If
                                        Rs1.close
                                        %>
                                    </select>
                                </td>
                                <td>
                                    <select class="input-field" name="SJB_FA" id="SJB_FA"  onchange="handleSelectChange(event, 'SJB_FA', 'SJB_FA')">
                                        <option value="0" <% If SJB_FA = "0" Then Response.Write "selected" %> >안함</option>
                                        <option value="1" <% If SJB_FA = "1" Then Response.Write "selected" %> >수동</option>
                                        <option value="2" <% If SJB_FA = "2" Then Response.Write "selected" %> >자동</option>
                                    </select>
                                </td>
                                <td rowspan="3"><input class="input-field" type="text"  name="TNG_Busok_images" id="TNG_Busok_images" value="<%=TNG_Busok_images%>" onkeypress="handleKeyPress(event, 'TNG_Busok_images', 'TNG_Busok_images')"/><%=TNG_Busok_images%></td> <!-- 이미지파일 -->
                                <td rowspan="3"><input class="input-field" type="text"  name="TNG_Busok_CAD" id="TNG_Busok_CAD" value="<%=TNG_Busok_CAD%>" onkeypress="handleKeyPress(event, 'TNG_Busok_CAD', 'TNG_Busok_CAD')"/><%=TNG_Busok_CAD%></td> <!-- 이미지파일 -->
                            </tr>
                                <tr  bgcolor="#c0c0c0">
                                    <th >금형1</th>
                                    <th >비중1</th>
                                    <th >금형2</th>
                                    <th >비중2</th>
                                    <th>폴리1</th>
                                    <th>폴리2</th>
                                    <th>길이</th> 
                                    <th>블랙</th>
                                    <th>도장</th>
        <!--
                                    <th>수정자</th>
                                    <th>수정일</th>
        -->
                                </tr> 
                            <tr bgcolor="<%=cccc%>" >

                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_al1" id="TNG_Busok_comb_al1" value="<%=TNG_Busok_comb_al1%>" 
                                    onkeypress="handleKeyPress(event, 'TNG_Busok_comb_al1', 'TNG_Busok_comb_al1')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_alBJ1" id="TNG_Busok_comb_alBJ1" value="<%=TNG_Busok_comb_alBJ1%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_comb_alBJ1', 'TNG_Busok_comb_alBJ1')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_al2" id=" TNG_Busok_comb_al2" value="<%= TNG_Busok_comb_al2%>" 
                                    onkeypress="handleKeyPress(event, ' TNG_Busok_comb_al2', ' TNG_Busok_comb_al2')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_alBJ2" id="TNG_Busok_comb_alBJ2" value="<%=TNG_Busok_comb_alBJ2%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_comb_alBJ2', 'TNG_Busok_comb_alBJ2')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_pa1" id="TNG_Busok_comb_pa1" value="<%=TNG_Busok_comb_pa1%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_comb_pa1', 'TNG_Busok_comb_pa1')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_pa2" id="TNG_Busok_comb_pa2" value="<%=TNG_Busok_comb_pa2%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_comb_pa2', 'TNG_Busok_comb_pa2')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_length1" id="TNG_Busok_length1" value="<%=TNG_Busok_length1%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_length1', 'TNG_Busok_length1')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_BLACK" id="TNG_Busok_BLACK" value="<%=TNG_Busok_BLACK%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_BLACK', 'TNG_Busok_BLACK')"/></td>
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_PAINT" id="TNG_Busok_PAINT" value="<%=TNG_Busok_PAINT%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_PAINT', 'TNG_Busok_PAINT')"/></td>  
<!--
                                <td></td>
                                <td></td> 
-->
                            </tr>
                            <% end if %>
                            <% 
                            cccc=""
                                i=0
                                sql = "SELECT A.TNG_Busok_idx, A.T_Busok_name_f, A.TNG_Busok_comb_st, A.TNG_Busok_name1_Number,"
                                sql = sql & " A.SJB_TYPE_NO, D.SJB_TYPE_NAME, A.TNG_Busok_name_KR, A.TNG_Busok_name1, A.TNG_Busok_name2,"
                                sql = sql & " A.TNG_Busok_comb_al1, A.TNG_Busok_comb_alBJ1, A.TNG_Busok_comb_al2, A.TNG_Busok_comb_alBJ2,"
                                sql = sql & " A.TNG_Busok_comb_pa1, A.TNG_Busok_comb_pa2, A.TNG_Busok_length1, A.TNG_Busok_length2,"
                                sql = sql & " A.TNG_Busok_BLACK, A.TNG_Busok_PAINT, A.TNG_Busok_comb_al3, A.TNG_Busok_comb_alBJ3,"
                                sql = sql & " A.TNG_Busok_comb_pa3, A.TNG_Busok_images, A.TNG_Busok_CAD, A.WHICHI_FIX, A.WHICHI_AUTO, A.SJB_FA, "
                                sql = sql & " A.midx, Convert(varchar(10), A.wdate, 121), A.emidx, Convert(varchar(10), A.ewdate, 121), "
                                sql = sql & " B.mname, C.mname, F.WHICHI_FIXname, G.WHICHI_AUTOname "
                                sql = sql & " FROM TNG_Busok A "
                                sql = sql & " JOIN tk_member B ON A.midx = B.midx "
                                sql = sql & " LEFT OUTER JOIN tk_member C ON A.emidx = C.midx "
                                sql = sql & " LEFT OUTER JOIN tng_sjbtype D ON A.SJB_TYPE_NO = D.SJB_TYPE_NO AND D.sjbtstatus = 1 "
                                sql = sql & " LEFT OUTER JOIN tng_whichitype F ON A.WHICHI_FIX = F.WHICHI_FIX "
                                sql = sql & " LEFT OUTER JOIN tng_whichitype G ON A.WHICHI_AUTO = G.WHICHI_AUTO "
                                sql = sql & " WHERE A.TNG_Busok_idx <> '' "

                                If Request("SearchWord") <> "" Then 
                                    sql = sql & " AND ( A.T_Busok_name_f like '%" & Request("SearchWord") & "%' "
                                    sql = sql & " OR A.TNG_Busok_comb_al1 like '%" & Request("SearchWord") & "%' "
                                    sql = sql & " OR A.TNG_Busok_comb_alBJ1 like '%" & Request("SearchWord") & "%' "
                                    sql = sql & " OR D.SJB_TYPE_NAME like '%" & Request("SearchWord") & "%' "
                                    sql = sql & " OR A.TNG_Busok_name1_Number like '%" & Request("SearchWord") & "%' "
                                    sql = sql & " OR A.TNG_Busok_name1 like '%" & Request("SearchWord") & "%' "
                                    sql = sql & " OR A.WHICHI_FIX like '%" & Request("SearchWord") & "%' "
                                    sql = sql & " OR A.WHICHI_AUTO like '%" & Request("SearchWord") & "%' "
                                    sql = sql & " OR F.WHICHI_FIXname like '%" & Request("SearchWord") & "%' "
                                    sql = sql & " OR G.WHICHI_AUTOname like '%" & Request("SearchWord") & "%' )"
                                End If
                                SQL = SQL & " ORDER BY A.TNG_Busok_idx desc"
                                'Response.write (SQL)&"<br>"
                                Rs.open Sql,Dbcon,1,1,1
                                Rs.PageSize = 10
                                if not (Rs.EOF or Rs.BOF ) then
                                no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                                    totalpage=Rs.PageCount 
                                    Rs.AbsolutePage =gotopage
                                    i=1
                                for j=1 to Rs.RecordCount 
                                if i>Rs.PageSize then exit for end if
                                if no-j=0 then exit for end if

                                TNG_Busok_idx        = Rs(0)
                                T_Busok_name_f       = Rs(1)
                                TNG_Busok_comb_st    = Rs(2)
                                TNG_Busok_name1_Num  = Rs(3)
                                SJB_TYPE_NO          = Rs(4)
                                ySJB_TYPE_NAME       = Rs(5)  ' 🔹 조인으로 가져온 항목
                                TNG_Busok_name_KR    = Rs(6)
                                TNG_Busok_name1      = Rs(7)
                                TNG_Busok_name2      = Rs(8)
                                TNG_Busok_comb_al1   = Rs(9)
                                TNG_Busok_comb_alBJ1 = Rs(10)
                                TNG_Busok_comb_al2   = Rs(11)
                                TNG_Busok_comb_alBJ2 = Rs(12)
                                TNG_Busok_comb_pa1   = Rs(13)
                                TNG_Busok_comb_pa2   = Rs(14)
                                TNG_Busok_length1    = Rs(15)
                                TNG_Busok_length2    = Rs(16)
                                TNG_Busok_BLACK      = Rs(17)
                                TNG_Busok_PAINT      = Rs(18)
                                TNG_Busok_comb_al3   = Rs(19)
                                TNG_Busok_comb_alBJ3 = Rs(20)
                                TNG_Busok_comb_pa3   = Rs(21)
                                TNG_Busok_images     = Rs(22)
                                TNG_Busok_CAD        = Rs(23)
                                WHICHI_FIX           = rs(24)
                                ' WHICHI_FIX 가 비어 있거나 이상한 값일 경우 대비
                                If isnull(WHICHI_FIX)  Then
                                    WHICHI_FIX = "0"
                                End If
                                WHICHI_AUTO          = rs(25)
                                ' WHICHI_AUTO 가 비어 있거나 이상한 값일 경우 대비
                                If isnull(WHICHI_AUTO)  Then
                                    WHICHI_AUTO = "0"
                                End If
                                SJB_FA               = rs(26)
                                midx                 = rs(27)
                                wdate                = rs(28)
                                emidx                = rs(29)
                                ewdate               = rs(30)
                                mname                = rs(31)
                                mename               = rs(32)
                                WHICHI_FIXname      = Rs(33)  
                                WHICHI_AUTOname      = Rs(34)
                                i=i+1
                                
                                select case SJB_FA
                                    case "1"
                                        SJB_FA_text="수동"
                                    case "2"
                                        SJB_FA_text="자동"
                                    case else
                                        SJB_FA_text="안함"
                                end select 
                            %>
                            <% 
                            'response.write "rTNG_Busok_idx : "&rTNG_Busok_idx&"<br>"
                            if int(TNG_Busok_idx)=int(rTNG_Busok_idx) then 
                            cccc="#E7E7E7"
                            %>
                            <tr  bgcolor="#c0c0c0">
                            <th  >순번</th>
                            <th    colspan="3" >자재명</th>
                            <th    colspan="3" >품목명</th>
                            <th>위치수동</th>                            
                            <th >위치자동</th>
                            <th >자동/수동</th>
                            <th>이미지1</th>
                            <th>이미지2</th>
                            </tr>
                            <tr bgcolor="<%=cccc%>">
                                <td align="center" rowspan="3" style="vertical-align: middle;" ><a name="<%=TNG_Busok_idx%>"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=TNG_Busok_idx%>');"><%=no-j%></button></td> <!-- 삭제  -->
                                <td  colspan="3"  ><input class="input-field" type="text" size="" name="T_Busok_name_f" id="T_Busok_name_f" value="<%=T_Busok_name_f%>" onkeypress="handleKeyPress(event, 'T_Busok_name_f', 'T_Busok_name_f')"/></td> 
                                <td  colspan="3"  >
                                    <select class="input-field" name="SJB_TYPE_NO" id="SJB_TYPE_NO"  onchange="handleChange(this)">
                                        <%
                                        If SJB_TYPE_NO = "" Then SJB_TYPE_NO = "14"

                                        sql="SELECT sjbtidx,SJB_TYPE_NO,SJB_TYPE_NAME from tng_sjbtype "
                                        sql=sql&" where sjbtstatus='1' "
                                        'response.write (SQL)&"<br>"
                                        Rs1.open Sql,Dbcon,1,1,1
                                        If Not (Rs1.bof or Rs1.eof) Then 
                                        Do until Rs1.EOF

                                            sjbtidx        = rs1(0)
                                            ySJB_TYPE_NO        = rs1(1)
                                            ySJB_TYPE_NAME        = rs1(2)

                                        %>
                                        <option value="<%=ySJB_TYPE_NO%>" <% If cint(SJB_TYPE_NO) = cint(ySJB_TYPE_NO) Then Response.Write "selected" End If %> >
                                            <%=ySJB_TYPE_NAME%>
                                        </option>
                                        <%
                                        Rs1.MoveNext
                                        Loop
                                        End If
                                        Rs1.close
                                        %> 
                                    </select>
                                </td>
                                <td>
                                    <select class="input-field" name="WHICHI_FIX" id="WHICHI_FIX"  onchange="handleChange(this)">
                                        <option value="0">없음</option>   
                                        <%
                                        sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                        sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                        sql = sql & "FROM tng_whichitype "
                                        sql = sql & "WHERE bfwstatus = 1 and glassselect = 0 "
                                        'response.write (sql)&"<br>"

                                        Rs1.open sql, Dbcon, 1, 1, 1
                                        If Not (Rs1.bof Or Rs1.eof) Then 
                                            Do Until Rs1.EOF

                                                bfwidx           = Rs1(0)
                                                yWHICHI_FIX      = Rs1(1)
                                                yWHICHI_FIXname  = Rs1(2)
                                                yWHICHI_AUTO     = Rs1(3)
                                                yWHICHI_AUTOname = Rs1(4)
                                                bfwstatus        = Rs1(5)
                                        ' 🔹 NULL 또는 빈값이 아니면 출력
                                        If Not IsNull(yWHICHI_FIX)  Then
                                        %>
                                        <option value="<%=yWHICHI_FIX%>" <% If cint(yWHICHI_FIX) = cint(WHICHI_FIX) Then Response.Write "selected" End If %> >
                                            <%=yWHICHI_FIXname%>
                                        </option>
                                        <%
                                        End If
                                        Rs1.MoveNext
                                        Loop
                                        End If
                                        Rs1.close
                                        %>
                                    </select>
                                </td>
                                <td>
                                    <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                                        <option value="0">없음</option>   
                                        <%
                                        sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                        sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                        sql = sql & "FROM tng_whichitype "
                                        sql = sql & "WHERE bfwstatus = 1 and glassselect = 0 "
                                        'response.write (sql)&"<br>"

                                        Rs1.open sql, Dbcon, 1, 1, 1
                                        If Not (Rs1.bof Or Rs1.eof) Then 
                                            Do Until Rs1.EOF

                                                bfwidx           = Rs1(0)
                                                yWHICHI_FIX      = Rs1(1)
                                                yWHICHI_FIXname  = Rs1(2)
                                                yWHICHI_AUTO     = Rs1(3)
                                                yWHICHI_AUTOname = Rs1(4)
                                                bfwstatus        = Rs1(5)
                                        ' 🔹 NULL 또는 빈값이 아니면 출력
                                        If Not IsNull(yWHICHI_AUTO)  Then
                                        %>
                                        <option value="<%=yWHICHI_AUTO%>" <% If cint(yWHICHI_AUTO) = cint(WHICHI_AUTO) Then Response.Write "selected" End If %> >
                                            <%=yWHICHI_AUTOname%>
                                        </option>
                                        <%
                                        End If
                                        Rs1.MoveNext
                                        Loop
                                        End If
                                        Rs1.close
                                        %> 
                                    </select>
                                </td>
                                <td>
                                    <select class="input-field" name="SJB_FA" id="SJB_FA"  onchange="handleSelectChange(event, 'SJB_FA', 'SJB_FA')">
                                        <option value="0" <% If SJB_FA = "0" Then Response.Write "selected" %> >안함</option>
                                        <option value="1" <% If SJB_FA = "1" Then Response.Write "selected" %> >수동</option>
                                        <option value="2" <% If SJB_FA = "2" Then Response.Write "selected" %> >자동</option>
                                    </select>
                                </td>
                                <td rowspan="3"><% if TNG_Busok_images<>"" then %><img src="/img/frame/bfimg/<%=TNG_Busok_images%>"   height="150" onclick="window.open('TNG1_BUSOK_DB_UPLOAD2.asp?TNG_Busok_idx=<%=TNG_Busok_idx%>&bftype=bfimg1','bfimg1','top=10, left=10, width=700, height=500');" /><% else %><button class="btn btn-primary btn-small " type="button"  onclick="window.open('TNG1_BUSOK_DB_UPLOAD2.asp?TNG_Busok_idx=<%=TNG_Busok_idx%>&bftype=bfimg1','bfimg1','top=10, left=10, width=700, height=500');" >등록</button><% end if %></td> <!-- 이미지파일 -->
                                <td rowspan="3"><% if TNG_Busok_CAD<>"" then %><img src="/img/frame/bfimg/<%=TNG_Busok_CAD%>"   height="150" onclick="window.open('TNG1_BUSOK_DB_UPLOAD.asp?TNG_Busok_idx=<%=TNG_Busok_idx%>&bftype=bfimg2','bfimg2','top=10, left=10, width=700, height=200');" /><% else %><button class="btn btn-primary btn-small " type="button"  onclick="window.open('TNG1_BUSOK_DB_UPLOAD.asp?TNG_Busok_idx=<%=TNG_Busok_idx%>&bftype=bfimg2','bfimg2','top=10, left=10, width=700, height=200');" >등록</button><% end if %></td> <!-- 이미지파일 -->
                            </tr>
                                <tr  bgcolor="#c0c0c0">
                                    <th >금형1</th>
                                    <th >비중1</th>
                                    <th >금형2</th>
                                    <th >비중2</th>
                                    <th>폴리1</th>
                                    <th>폴리2</th>
                                    <th>길이</th> 
                                    <th>블랙</th>
                                    <th>도장</th>
        <!--
                                    <th>수정자</th>
                                    <th>수정일</th>
        -->
                                </tr> 
                            <tr bgcolor="<%=cccc%>" > 
  
                                <td>
                                    <input class="input-field" type="text" size="8" name="TNG_Busok_comb_al1" id="TNG_Busok_comb_al1" value="<%=TNG_Busok_comb_al1%>" onkeypress="handleKeyPress(event, 'TNG_Busok_comb_al1', 'TNG_Busok_comb_al1')"/>
                                </td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_alBJ1" id="TNG_Busok_comb_alBJ1" value="<%=TNG_Busok_comb_alBJ1%>" onkeypress="handleKeyPress(event, 'TNG_Busok_comb_alBJ1', 'TNG_Busok_comb_alBJ1')"/></td> 
                                <td>
                                    <input class="input-field" type="text" size="8" name="TNG_Busok_comb_al2" id="TNG_Busok_comb_al1" value="<%=TNG_Busok_comb_al2%>" onkeypress="handleKeyPress(event, 'TNG_Busok_comb_al2', 'TNG_Busok_comb_al2')"/>
                                </td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_alBJ2" id="TNG_Busok_comb_alBJ2" value="<%=TNG_Busok_comb_alBJ2%>" onkeypress="handleKeyPress(event, 'TNG_Busok_comb_alBJ2', 'TNG_Busok_comb_alBJ2')"/></td> 
                                
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_pa1" id="TNG_Busok_comb_pa1" value="<%=TNG_Busok_comb_pa1%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_comb_pa1', 'TNG_Busok_comb_pa1')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_comb_pa2" id="TNG_Busok_comb_pa2" value="<%=TNG_Busok_comb_pa2%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_comb_pa2', 'TNG_Busok_comb_pa2')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_length1" id="TNG_Busok_length1" value="<%=TNG_Busok_length1%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_length1', 'TNG_Busok_length1')"/></td> 
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_BLACK" id="TNG_Busok_BLACK" value="<%=TNG_Busok_BLACK%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_BLACK', 'TNG_Busok_BLACK')"/></td>
                                <td><input class="input-field" type="text" size="8" name="TNG_Busok_PAINT" id="TNG_Busok_PAINT" value="<%=TNG_Busok_PAINT%>" 
                                onkeypress="handleKeyPress(event, 'TNG_Busok_PAINT', 'TNG_Busok_PAINT')"/></td>  
<!--
                                <td><%=mename%></td>
                                <td><%=ewdate%></td> 
-->
                            </tr>
                            <% else 
                            'cccc="#CCCCCC"
                            %>
                            <tr  bgcolor="#c0c0c0">
                            <th  >순번</th>
                            <th    colspan="3" >자재명</th>
                            <th    colspan="3" >품목명</th>
                            <th>위치수동</th>                            
                            <th >위치자동</th>
                            <th >자동/수동</th>
                            <th>이미지1</th>
                            <th>이미지2</th>
                            </tr>    
                            <tr bgcolor="<%=cccc%>">
                                <td align="center" rowspan="3" style="vertical-align: middle;" ><%=no-j%><a name="<%=TNG_Busok_idx%>"></td><!-- 순번 -->
                                <td  colspan="3" ><input class="input-field" type="text" value="<%=T_Busok_name_f%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>
                                <td><input class="input-field" type="text" value="<%=ySJB_TYPE_NAME%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>                           
                                <td></td>
                                <td></td>
                                <td><input class="input-field" type="text" value="<%=WHICHI_FIXname%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>    
                                <td><input class="input-field" type="text" value="<%=WHICHI_AUTOname%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/>  </td>    
                                <td><input class="input-field" type="text" value="<%=SJB_FA_text%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>    
                                <td rowspan="3"><% if TNG_Busok_images<>"" then %><img src="/img/frame/bfimg/<%=TNG_Busok_images%>"   height="150" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"><% end if %></td> 
                                <td rowspan="3"><% if TNG_Busok_CAD<>"" then %><img src="/img/frame/bfimg/<%=TNG_Busok_CAD%>"   height="150" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"><% end if %></td> 
                            </tr>
                            <tr  bgcolor="#c0c0c0">
                                    <th >금형1</th>
                                    <th >비중1</th>
                                    <th >금형2</th>
                                    <th >비중2</th>
                                    <th>폴리1</th>
                                    <th>폴리2</th>
                                    <th>길이</th> 
                                    <th>블랙</th>
                                    <th>도장</th>
        <!--
                                    <th>수정자</th>
                                    <th>수정일</th>
        -->
                                </tr>
                            <tr bgcolor="<%=cccc%>" >     
                                <td><input class="input-field" type="text" value="<%=TNG_Busok_comb_al1%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>    
                                <td><input class="input-field" type="text" value="<%=TNG_Busok_comb_alBJ1%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>    
                                <td><input class="input-field" type="text" value="<%=TNG_Busok_comb_al2%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>    
                                <td><input class="input-field" type="text" value="<%=TNG_Busok_comb_alBJ2%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>    
                                
                                <td><input class="input-field" type="text" value="<%=TNG_Busok_comb_pa1%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>        
                                <td><input class="input-field" type="text" value="<%=TNG_Busok_comb_pa2%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>
                                <td><input class="input-field" type="text" value="<%=TNG_Busok_length1%>"  onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>
                                <td><input class="input-field" type="text" value="<%=TNG_Busok_BLACK%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>   
                                <td><input class="input-field" type="text" value="<%=TNG_Busok_PAINT%>" onclick="location.replace('TNG1_BUSOK.asp?gotopage=<%=gotopage%>&TNG_Busok_idx=<%=TNG_Busok_idx%>&SearchWord=<%=rSearchWord%>#<%=TNG_Busok_idx%>');"/> </td>   
<!--
                                <td><%=mename%></td>
                                <td><%=ewdate%></td>
-->
                            </tr>
                            <% end if %>
                            <%
                            WHICHI_AUTO_text =""
                            WHICHI_FIX_text =""
                            cccc=""
                            SJB_FA_text=""
                            Rs.MoveNext
                            Next 
                            End If 
                            %>
                            <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                        </form>    
                    </tbody>
                </table>
            </div>
            <div class="row">
                <div  class="col-12 py-3"> 
                <!--#include Virtual = "/inc/paging.asp" -->
                </div>
                <%
                Rs.Close
                %>
            </div>        
        </div>
    </div>

            </div>
        </div>
        
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
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