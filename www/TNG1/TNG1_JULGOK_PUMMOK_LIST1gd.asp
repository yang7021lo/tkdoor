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
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

listgubun="one"

projectname="TNG 품목관리" 
%>
<%

kgotopage=Request("kgotopage")
gotopage=Request("gotopage")
rbfidx=Request("bfidx")
rksearchword=Request("ksearchword")
rsearchword=Request("SearchWord")
rSJB_IDX = Request("SJB_IDX")
rSJB_TYPE_NO = Request("SJB_TYPE_NO")

rWHICHI_FIX  = Request("WHICHI_FIX")
rWHICHI_AUTO = Request("WHICHI_AUTO")

'Response.Write "rksearchword : " & rksearchword & "<br>"

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name = "TNG1_JULGOK_PUMMOK_LIST1GD.asp?kgotopage=" & kgotopage & "&rbfidx=" & rbfidx & "&sjb_idx=" & rsjb_idx & "&ksearchword=" & rksearchword & "&SearchWord=" & Request("SearchWord") & "&mode=" & Request("mode") & "&"

SQL = "SELECT SJB_TYPE_NO, SJB_FA FROM TNG_SJB WHERE SJB_IDX = '" & rSJB_IDX & "' "
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
If Not (Rs.EOF Or Rs.BOF) Then
    SJB_TYPE_NO = Rs(0)

    If IsNull(SJB_TYPE_NO) Or SJB_TYPE_NO = "" Then
        SJB_TYPE_NO = 0
    End If

    ' 🔹 SJB_TYPE_NO -> SJB_TYPE_NAME 변환 루프안에 또 루프하기!!!! 
    sql = "SELECT SJB_TYPE_NO, SJB_TYPE_NAME FROM tng_sjbtype WHERE SJB_TYPE_NO = " & SJB_TYPE_NO & " AND sjbtstatus = 1"
    Rs1.Open sql, Dbcon, 1, 1
    If Not (Rs1.EOF Or Rs1.BOF) Then
        rSJB_TYPE_NO   = Rs1(0)  ' = SJB_TYPE_NO
        rSJB_TYPE_NAME = Rs1(1)  ' = SJB_TYPE_NAME
    Else
        rSJB_TYPE_NO   = 0
        rSJB_TYPE_NAME = "선택 안됨"
    End If
    Rs1.Close
    
    SJB_FA = Rs(1)
    
End If
'Response.Write "SJB_TYPE_NO : " & SJB_TYPE_NO & "<br>"
'Response.Write "SJB_FA : " & SJB_FA & "<br>"
Rs.Close
%>
<%
If rbfidx <> "" And rbfidx <> "0" Then
    sql = "SELECT WHICHI_FIX, WHICHI_AUTO FROM tk_barasiF WHERE bfidx = " & rbfidx & " "
    Rs.Open SQL, Dbcon, 1, 1
    If Not (Rs.EOF Or Rs.BOF) Then
        WHICHI_FIX  = Rs(0)

          If IsNull(WHICHI_FIX) Or WHICHI_FIX = "" Then
            WHICHI_FIX = 0
          End If
          ' 🔹 WHICHI_FIX -> rWHICHI_FIXname 변환 루프안에 또 루프하기!!!!
          SQL = "SELECT WHICHI_FIX,WHICHI_FIXname FROM tng_whichitype WHERE WHICHI_FIX = " & WHICHI_FIX & " AND bfwstatus = 1"
          Rs1.Open sql, Dbcon, 1, 1
          If Not (Rs1.EOF Or Rs1.BOF) Then
              rWHICHI_FIX   = Rs1(0)  ' = WHICHI_FIX
              rWHICHI_FIXname = Rs1(1)  ' = WHICHI_FIXname
          Else
              rWHICHI_FIX   = 0
              rWHICHI_FIXname = "선택 안됨"
          End If
          Rs1.Close


        WHICHI_AUTO = Rs(1)

          If IsNull(WHICHI_AUTO) Or WHICHI_AUTO = "" Then
            WHICHI_AUTO = 0
          End If
          ' 🔹 WHICHI_AUTO -> rWHICHI_AUTOname 변환 루프안에 또 루프하기!!!!
          SQL = "SELECT WHICHI_AUTO,WHICHI_AUTOname FROM tng_whichitype WHERE WHICHI_AUTO = " & WHICHI_AUTO & " AND bfwstatus = 1"
          Rs1.Open sql, Dbcon, 1, 1
          If Not (Rs1.EOF Or Rs1.BOF) Then
              rWHICHI_AUTO   = Rs1(0)  ' = WHICHI_FIX
              rWHICHI_AUTOname = Rs1(1)  ' = WHICHI_FIXname
          Else
              rWHICHI_AUTO   = 0
              rWHICHI_AUTOname = "선택 안됨"
          End If
          Rs1.Close
    End If
    Rs.Close
End If

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
    <style>
        .custom-bg {
            background-color: #f8f8f8; /* Bootstrap danger background color */
            'padding: 20px;
            border-radius: 5px;
        }
    </style>
<style>
    table {
      border-collapse: collapse;
      width: 80%;
      margin: 20px auto;
    }

    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: left;
      position: relative;
    }

    .hover-image {
      display: none;
      position: absolute;
      top: 100%;
      left: 50%;
      transform: translateY(-100%);
      width: 250px;
      border: 1px solid #aaa;
      background-color: #fff;
      z-index: 100;
      box-shadow: 0px 0px 5px rgba(0,0,0,0.2);
    }

    .title-cell:hover .hover-image {
      display: block;
    }

    .title-cell {
      cursor: pointer;
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
        function del(str){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_JULGOK_PUMMOK_LIST1GDDB.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&SJB_IDX=<%=rSJB_IDX%>&part=delete&bfidx="+str;
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
                <div class="input-group mb-3">
                    <button type="button"
                        class="btn btn-outline-danger"
                        style="writing-mode: horizontal-tb; letter-spa
                        g: normal; white-space: nowrap;"
                        onclick="location.replace('TNG1_PUMMOK_Item_gd.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&SJB_IDX=<%=rSJB_IDX%>');">돌아가기
                    </button>
                </div>
                <div class="col text-end">
                    <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="TNG1_JULGOK_PUMMOK_LIST1GD.asp" id="form1"  name="form1">   
                        <!-- *검색 폼 form1에서는 이걸 완전히 제거해야 에러가 안남 -->
                        <!-- <input type="hidden" name="bfidx" value="<%=rbfidx%>"> -->
                        <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
                        <input type="hidden" name="gotopage" value="<%=gotopage%>">
                        <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
                        <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                        <div style="display: flex; align-items: center; gap: 8px;"> 
                            <input class="form-control" type="text" placeholder="품명,규격 조회" aria-label="품명,규격 조회" aria-describedby="btnNavbarSearch" name="ksearchword" value="<%=rksearchword%>"/>
                            <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i></button>
                        </div>
                    </form> 
                    <div>
                        <button type="button"
                            class="btn btn-outline-danger"
                            style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;"
                            onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1GD.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=0&SJB_IDX=<%=rSJB_IDX%>');">등록
                        </button>
                    </div>    
                </div>
            </div>
        <div>
            <form id="dataForm" action="TNG1_JULGOK_PUMMOK_LIST1GDDB.asp" method="POST" >   
                <input type="hidden" name="bfidx" value="<%=rbfidx%>">
                <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
                <input type="hidden" name="gotopage" value="<%=gotopage%>">
                <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
                <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                <input type="hidden" name="ksearchword" value="<%=rksearchword%>">
                <!-- 신규입력 폼 시작 -->
                <% if rbfidx="0" then 
                cccc="#E7E7E7"
                %>
                <div style="width: 100%; margin: 0; padding: 0;">
                    <table style="width: 100%; border-collapse: collapse;" id="datatablesSimple"  class="table table-hover">
                        <thead>
                            <tr>
                            <% IF SJB_FA="1" then %>
                            <th style="text-align: center;">수동도어유리1</th>
                            <th style="text-align: center;">수동사용위치</th>
                            <% elseIF SJB_FA="2" then %>  
                            <th style="text-align: center;">자동유리명</th>                            
                            <th style="text-align: center;">자동사용위치</th>
                            <% end if %>  
                            <th style="text-align: center;">유리가로-공차</th>
                            <th style="text-align: center;">유리세로-공차</th>
                            <th style="text-align: center;">도어가로-공차</th>
                            <th style="text-align: center;">도어세로-공차</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr bgcolor="<%=cccc%>" >
                                <% IF SJB_FA="1" then %>
                                <td><input class="input-field" type="text" size="" name="set_name_FIX" id="set_name_FIX" value="<%=set_name_FIX%>" onkeypress="handleKeyPress(event, 'set_name_FIX', 'set_name_FIX')"/></td> 
                                <td>
                                    <select class="input-field" name="WHICHI_FIX" id="WHICHI_FIX"  onchange="handleChange(this)">
                                    <%
                                    sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                    sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                    sql = sql & "FROM tng_whichitype "
                                    sql = sql & "WHERE bfwstatus = 1 and glassselect = 1 "
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
                                <% elseIF SJB_FA="2" then %> 
                                <td>
                                    <input class="input-field" type="text" size="" name="set_name_AUTO" id="set_name_AUTO" value="<%=set_name_AUTO%>" onkeypress="handleKeyPress(event, 'set_name_AUTO', 'set_name_AUTO')"/>
                                </td> 
                                <td>
                                    <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                                        <%
                                        sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                        sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                        sql = sql & "FROM tng_whichitype "
                                        sql = sql & "WHERE bfwstatus = 1 and glassselect = 1 "
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
                                <% end if %>  
                                <td>
                                    <input class="input-field" type="text" size="8" name="gwsize" id="gwsize" value="<%=gwsize%>" onkeypress="handleKeyPress(event, 'gwsize', 'gwsize')"/>
                                </td> 
                                <td>
                                    <input class="input-field" type="text" size="8" name="gysize" id="gysize" value="<%=ysize%>" onkeypress="handleKeyPress(event, 'gysize', 'gysize')"/>
                                </td>
                                <td>
                                    <input class="input-field" type="text" size="8" name="dwsize" id="dwsize" value="<%=dwsize%>" onkeypress="handleKeyPress(event, 'dwsize', 'dwsize')"/>
                                </td> 
                                <td>
                                    <input class="input-field" type="text" size="8" name="dysize" id="dysize" value="<%=dysize%>" onkeypress="handleKeyPress(event, 'dysize', 'dysize')"/>
                                </td>  
                            </tr>
                        </tbody>
                    </table>
                </div>   
                    <% end if %>    
                    <!-- 신규입력 폼 끝 -->
                            <div class="row mt-1">
                    <% 
                    cccc=""
                    SQL = "SELECT A.bfidx, A.set_name_FIX, A.set_name_AUTO, A.WHICHI_FIX, A.WHICHI_AUTO, A.xsize "
                    SQL = SQL & ", A.ysize, A.bfimg1, A.bfimg2, A.sjb_idx, A.bfmidx, Convert(varchar(10), A.bfwdate, 121) "
                    SQL = SQL & ", A.bfemidx, Convert(varchar(10), A.bfewdate, 121), B.mname "
                    SQL = SQL & ", C.mname, A.TNG_Busok_idx, D.T_Busok_name_f, A.bfimg3, A.TNG_Busok_idx2, E.T_Busok_name_f "
                    SQL = SQL & ", F.WHICHI_FIXname, G.WHICHI_AUTOname "  ' 🔹 추가된 컬럼
                    SQL = SQL & ", A.gwsize, A.gysize, A.dwsize, A.dysize "  ' 🔹 추가된 컬럼
                    SQL = SQL & ", H.SJB_TYPE_NO, H.SJB_FA "   ' 🔹 추가된 컬럼 2
                    SQL = SQL & "FROM tk_barasiF A "
                    SQL = SQL & "JOIN tk_member B ON A.bfmidx = B.midx "
                    SQL = SQL & "LEFT OUTER JOIN tk_member C ON A.bfemidx = C.midx "
                    SQL = SQL & "LEFT OUTER JOIN TNG_Busok D ON A.TNG_Busok_idx = D.TNG_Busok_idx "
                    SQL = SQL & "LEFT OUTER JOIN TNG_Busok E ON A.TNG_Busok_idx2 = E.TNG_Busok_idx "
                    SQL = SQL & "LEFT OUTER JOIN tng_whichitype F ON A.WHICHI_FIX = F.WHICHI_FIX "
                    SQL = SQL & "LEFT OUTER JOIN tng_whichitype G ON A.WHICHI_AUTO = G.WHICHI_AUTO "
                    SQL = SQL & "LEFT OUTER JOIN TNG_SJB H ON A.SJB_IDX = H.SJB_IDX "  ' ✅ 이 줄 추가!
                    If rSJB_IDX <> "" Then
                    SQL = SQL & "WHERE A.sjb_idx = '" & rSJB_IDX & "' "
                    SQL = SQL & "AND (A.xsize IS NULL OR A.xsize = '') "
                    SQL = SQL & "AND (A.ysize IS NULL OR A.ysize = '') "

                    End If
                    If rksearchword <>"" Then 
                        SQL = SQL & "AND ( A.set_name_FIX LIKE '%" & rksearchword & "%' "
                        SQL = SQL & "OR A.set_name_AUTO LIKE '%" & rksearchword & "%' "
                        SQL = SQL & "OR A.xsize LIKE '%" & rksearchword & "%' "
                        SQL = SQL & "OR A.ysize LIKE '%" & rksearchword & "%' "
                        SQL = SQL & "OR E.T_Busok_name_f LIKE '%" & rksearchword & "%' "
                        SQL = SQL & "OR F.WHICHI_FIXname LIKE '%" & rksearchword & "%' "
                        SQL = SQL & "OR G.WHICHI_AUTOname LIKE '%" & rksearchword & "%' ) "

                    End If 
                    SQL = SQL & "ORDER BY A.bfidx desc"

                    'Response.write (SQL)&"<br>"
                    Rs.open Sql,Dbcon,1,1,1
                    Rs.PageSize = 10
                    If Not (Rs.EOF Or Rs.BOF) Then
                    no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                    totalpage=Rs.PageCount 
                    Rs.AbsolutePage =gotopage
                    i=1
                    for j=1 to Rs.RecordCount 
                    if i>Rs.PageSize then exit for end if
                    if no-j=0 then exit for end if

                    bfidx         = Rs(0)
                    set_name_FIX  = Rs(1)
                    set_name_AUTO = Rs(2)
                    WHICHI_FIX    = Rs(3)
                    ' WHICHI_FIX 가 비어 있거나 이상한 값일 경우 대비
                    If isnull(WHICHI_FIX)  Then
                        WHICHI_FIX = "0"
                    End If
                    WHICHI_AUTO   = Rs(4) 
                    ' WHICHI_AUTO 가 비어 있거나 이상한 값일 경우 대비
                    If isnull(WHICHI_AUTO)  Then
                        WHICHI_AUTO = "0"
                    End If
                    xsize         = Rs(5)
                    ysize         = Rs(6)
                    bfimg1        = Rs(7)
                    bfimg2        = Rs(8)
                    sjb_idx       = Rs(9)
                    bfmidx        = Rs(10)
                    bfwdate       = Rs(11)
                    bfemidx       = Rs(12)
                    bfewdate      = Rs(13)
                    mname       = Rs(14)
                    mename      = Rs(15)
                    Busok_idx   = Rs(16)
                    ' Busok_idx 가 비어 있거나 이상한 값일 경우 대비
                    if isnull(Busok_idx) then 
                        Busok_idx="0"
                    end if
                    T_Busok_name_f   = Rs(17)
                    bfimg3        = Rs(18)
                    Busok_idx2   = Rs(19)
                    ' Busok_idx2 가 비어 있거나 이상한 값일 경우 대비
                    if isnull(Busok_idx2) then 
                        Busok_idx2="0"
                    end if

                    T_Busok_name_f2= rs(20)
                    WHICHI_FIXname  = Rs(21)  ' F.WHICHI_FIXname
                    WHICHI_AUTOname = Rs(22)  ' G.WHICHI_AUTOname
                    gwsize          = Rs(23)
                    gysize          = Rs(24)
                    dwsize          = Rs(25)
                    dysize          = Rs(26)
                    SJB_TYPE_NO = Rs(27)  ' H.SJB_TYPE_NO
                    SJB_FA      = Rs(28)  ' H.SJB_FA

                    If IsNull(SJB_TYPE_NO) Then SJB_TYPE_NO = 0
                    If IsNull(SJB_FA) Then SJB_FA = 0

                    i=i+1
                    
                    %>

                    <% 
                    'response.write "bfidx : "&bfidx&"<br>"
                    'response.write "rbfidx : "&rbfidx&"<br>"
                    if int(bfidx)=int(rbfidx) then 
                    cccc="#E7E7E7"
                    %>
                <div class="col-3 custom-bg" id="<%=bfidx%>">
                    <div class="card card-body mb-1">          
                        <div class="row">
                            <div class="col">
                                <table  class="table custom-table">
                                    <% IF SJB_FA="1" then %>
                                    <tr>
                                        <th style="text-align: center;">수동유리명</th>
                                        <th style="text-align: center;">수동사용위치</th>
                                        <!-- <th style="text-align: center;">유리가로-공차</th>
                                        <th style="text-align: center;">유리세로-공차</th>
                                        <th style="text-align: center;">도어가로-공차</th>
                                        <th style="text-align: center;">도어세로-공차</th> -->
                                    </tr>
                                    <tr>
                                        <td>
                                        <input class="input-field" type="text" size="" name="set_name_FIX" id="set_name_FIX" 
                                        value="<%=set_name_FIX%>" onkeypress="handleKeyPress(event, 'set_name_FIX', 'set_name_FIX')"/> 
                                        </td>
                                        <td>
                                            <select class="input-field" name="WHICHI_FIX" id="WHICHI_FIX"  onchange="handleChange(this)">
                                            <%
                                                sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                                sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                                sql = sql & "FROM tng_whichitype "
                                                sql = sql & "WHERE bfwstatus = 1 and glassselect = 1 "
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
                                    </tr> 
                                    <% ElseIf SJB_FA = "2" Then %>
                                    <tr>
                                        <th style="text-align: center;">자동유리명</th>
                                        <th style="text-align: center;">자동사용위치</th>

                                    </tr>
                                    <tr>
                                        <td>
                                            <input class="input-field" type="text" size="" name="set_name_AUTO" id="set_name_AUTO" 
                                            value="<%=set_name_AUTO%>" onkeypress="handleKeyPress(event, 'set_name_AUTO', 'set_name_AUTO')"/> </td>
                                        <td>
                                            <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                                            <%
                                            sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                            sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                            sql = sql & "FROM tng_whichitype "
                                            sql = sql & "WHERE bfwstatus = 1 and glassselect = 1"
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
                                    </tr>
                                    <% end if %>
                                    <tr>
                                        <th>유리가로-공차</th>
                                        <th>유리세로-공차</th>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input class="input-field" type="text" size="8" name="gwsize" id="gwsize" value="<%=gwsize%>" onkeypress="handleKeyPress(event, 'gwsize', 'gwsize')"/>
                                        </td> 
                                        <td>
                                            <input class="input-field" type="text" size="8" name="gysize" id="gysize" value="<%=gysize%>" onkeypress="handleKeyPress(event, 'gysize', 'gysize')"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>도어가로-공차</th>
                                        <th>도어세로-공차</th>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input class="input-field" type="text" size="8" name="dwsize" id="dwsize" value="<%=dwsize%>" onkeypress="handleKeyPress(event, 'dwsize', 'dwsize')"/>
                                        </td> 
                                        <td>
                                            <input class="input-field" type="text" size="8" name="dysize" id="dysize" value="<%=dysize%>" onkeypress="handleKeyPress(event, 'dysize', 'dysize')"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <button type="button" class="btn btn-outline-danger btn-small" onclick="del('<%=bfidx%>');">삭제</button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <% else %>
                <div class="col-3 custom-bg" id="<%=bfidx%>">
                    <div class="card card-body mb-1">
                        <div class="row">
                            <div class="col">  
                                <table  class="table custom-table">
                                    <% IF SJB_FA="1" then %>
                                        <tr>
                                            <th>수동유리명</th>
                                            <th>수동사용위치</th>
                                        </tr>
                                        <tr>
                                            <td><input class="input-field" type="text" value="<%=set_name_FIX%>" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1gd.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=bfidx%>&SJB_IDX=<%=SJB_IDX%>#<%=bfidx%>');"/> </td>
                                            <td><input class="input-field" type="text" value="<%=WHICHI_FIXname%>" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1gd.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=bfidx%>&SJB_IDX=<%=SJB_IDX%>#<%=bfidx%>');"/> </td>
                                        </tr>
                                    <% End If %>
                                    <% If SJB_FA = "2" Then %>
                                        <tr>
                                            <th>자동유리명</th>
                                            <th>자동사용위치</th>
                                        </tr>
                                        <tr>
                                            <td><input class="input-field" type="text" value="<%=set_name_AUTO%>" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1gd.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=bfidx%>&SJB_IDX=<%=SJB_IDX%>#<%=bfidx%>');"/> </td>
                                            <td><input class="input-field" type="text" value="<%=WHICHI_AUTOname%>" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1gd.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=bfidx%>&SJB_IDX=<%=SJB_IDX%>#<%=bfidx%>');"/> </td>
                                        </tr>
                                    <% end if  %>
                                    <tr>
                                        <th>유리가로-공차</th>
                                        <th>유리세로-공차</th>
                                    </tr>
                                    <tr>
                                            <td><input class="input-field" type="text" value="<%=gwsize%>" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1gd.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=bfidx%>&SJB_IDX=<%=SJB_IDX%>#<%=bfidx%>');"/> </td>
                                            <td><input class="input-field" type="text" value="<%=gysize%>" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1gd.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=bfidx%>&SJB_IDX=<%=SJB_IDX%>#<%=bfidx%>');"/> </td>
                                    </tr>
                                    <tr>
                                        <th>도어가로-공차</th>
                                        <th>도어세로-공차</th>
                                    </tr>
                                    <tr>
                                            <td><input class="input-field" type="text" value="<%=dwsize%>" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1gd.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=bfidx%>&SJB_IDX=<%=SJB_IDX%>#<%=bfidx%>');"/> </td>
                                            <td><input class="input-field" type="text" value="<%=dysize%>" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1gd.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=bfidx%>&SJB_IDX=<%=SJB_IDX%>#<%=bfidx%>');"/> </td>
                                    </tr>

                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                end if 
                %>
                <% 
                cccc=""
                Rs.MoveNext
                Next 
                End If 
                %>
                        </div>
                <button type="submit" id="hiddenSubmit" style="display: none;"></button>
            </form>
<div  class="col-10 py-3"> 
<!--#include Virtual = "/inc/paging.asp" -->
</div>
<%
Rs.Close
%>
        </div>
    </div>


        
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
    // 페이지 로드 후 앵커로 이동
    window.addEventListener("DOMContentLoaded", function () {
        const hash = window.location.hash;
        if (hash) {
            const target = document.querySelector(hash);
            if (target) {
                target.scrollIntoView({ behavior: "smooth", block: "center" });
            }
        }
    });
</script>
<script>
    window.addEventListener("DOMContentLoaded", function () {
        const bfidx = "<%=rbfidx%>";
        if (bfidx && bfidx !== "0") {
            const target = document.getElementById(bfidx);
            if (target) {
                // 앵커 위치로 이동
                target.scrollIntoView({  block: "center" });

                // URL에 앵커 강제로 추가
                history.replaceState(null, null, "#" + bfidx);
            }
        }
    });
</script>
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