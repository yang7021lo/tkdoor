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
listgubun="one"
 
projectname="입면도면 등록"
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function

rfidx=Request("fidx")
rgreem_f_a=Request("greem_f_a")
rGREEM_BASIC_TYPE=Request("GREEM_BASIC_TYPE")
rgreem_o_type=Request("greem_o_type")
rGREEM_FIX_TYPE=Request("GREEM_FIX_TYPE")
rgreem_habar_type=Request("greem_habar_type")
rgreem_lb_type=Request("greem_lb_type")
rGREEM_MBAR_TYPE=Request("GREEM_MBAR_TYPE")


if rgreem_f_a = "" then rgreem_f_a=1 end if
if rGREEM_BASIC_TYPE = "" then rGREEM_BASIC_TYPE=0 end if
if rgreem_o_type = "" then rgreem_o_type=0 end if
if rGREEM_FIX_TYPE = "" then rGREEM_FIX_TYPE=0 end if
if rgreem_habar_type = "" then rgreem_habar_type=0 end if
if rgreem_lb_type = "" then rgreem_lb_type=0 end if
if rGREEM_MBAR_TYPE = "" then rGREEM_MBAR_TYPE=0 end if

'Response.Write "<br><br><br><br><br><br><br><br><br><br><br><br>"
'Response.Write "rfidx : " & rfidx & "<br>"
'Response.Write "rgreem_f_a : " & rgreem_f_a & "<br>"
'Response.Write "rGREEM_BASIC_TYPE : " & rGREEM_BASIC_TYPE & "<br>"
'Response.Write "rGREEM_FIX_TYPE : " & rGREEM_FIX_TYPE & "<br>"
'response.end

SearchWord=Request("SearchWord")
gubun=Request("gubun")
 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"


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
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
            <div class="card card-body mb-1"><!-- *  11111111111  -->
                <form name="frmMain" method="post" action="TNG1_GREEMLIST2.asp" >
                    <div class="row">
                        <div class="col-3">
                        <!-- -->
                          <label>
                              <input type="radio" name="greem_f_a" value="1" onchange="this.form.submit();" 
                              <% If rgreem_f_a = "1" Then Response.Write "checked" end if %>> 자동
                          </label>
                          <label>
                              <input type="radio" name="greem_f_a" value="2" onchange="this.form.submit();" 
                              <% If rgreem_f_a = "2" Then 
                              Response.Write "checked" 
                              rgreem_habar_type = "0"
                              rgreem_lb_type = "0"
                              rGREEM_MBAR_TYPE = "0"
                              rgreem_basic_type = "5"
                              rGREEM_O_TYPE = "0"
                              end if %>> 수동
                          </label>
                        <!-- -->
                        <!-- -->
                          <label>
                              <input type="radio" name="greem_habar_type" value="0" onchange="this.form.submit();" 
                              <% If rgreem_habar_type = "0" Then Response.Write "checked" end if %>> 하바분할 없음
                          </label>
                          <label>
                              <input type="radio" name="greem_habar_type" value="1" onchange="this.form.submit();" 
                              <% If rgreem_habar_type = "1" Then Response.Write "checked" end if %>> 하바분할 타입
                          </label>
                        <!-- -->
                        <!-- -->
                          <label>
                              <input type="radio" name="greem_lb_type" value="0" onchange="this.form.submit();" 
                              <% If rgreem_lb_type = "0" Then Response.Write "checked" end if %>>로비폰 없음
                          </label>
                          <label>
                              <input type="radio" name="greem_lb_type" value="1" onchange="this.form.submit();" 
                              <% If rgreem_lb_type = "1" Then Response.Write "checked" end if %>>로비폰 추가
                          <label>
                              <input type="radio" name="GREEM_MBAR_TYPE" value="0" onchange="this.form.submit();" 
                              <% If rGREEM_MBAR_TYPE = "0" Then Response.Write "checked" end if %>>중간소대 추가 없음
                          </label>
                          <label>
                              <input type="radio" name="GREEM_MBAR_TYPE" value="1" onchange="this.form.submit();" 
                              <% If rGREEM_MBAR_TYPE = "1" Then Response.Write "checked" end if %>>중간소대 추가    
                        <!-- -->
                        </div>
                        <% If rgreem_f_a = "1" Then %>
                        <div class="col-2">
                            <select name="greem_basic_type" class="form-control" onchange="this.form.submit();">
                                <option value="">세부 타입 선택</option>
                                    <% 
                                    sql = "SELECT DISTINCT  greem_basic_type "
                                    sql = sql & "FROM tk_frame "
                                    sql = sql & "WHERE GREEM_F_A = '" & rgreem_f_a & "' ORDER BY greem_basic_type"
                                    'response.write (SQL)&"<br>"
                                        Rs.open Sql,Dbcon,1,1,1
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do until Rs.EOF
                                            greem_basic_type        = rs(0)

                                            Select Case greem_basic_type
                                            Case "1"
                                                greem_basic_type_name = "기본"
                                            Case "2"
                                                greem_basic_type_name = "인서트 타입(T형)"
                                            Case "3"
                                                greem_basic_type_name = "픽스바 없는 타입"
                                            Case "4"
                                                greem_basic_type_name = "자동홈바 없는 타입"
                                            Case Else
                                                greem_basic_type_name = "기타 타입"    
                                        end select         
                                    %>
                                    <option value="<%=greem_basic_type%>" <% if cint(greem_basic_type) = cint(rgreem_basic_type) then Response.Write "selected" end if %>><%=greem_basic_type_name%></option>
                                    <%
                                    Rs.MoveNext
                                    Loop
                                    End If
                                    Rs.close
                                    %>
                            </select>
                        </div>
                        <div class="col-2">
                            <select name="GREEM_O_TYPE" class="form-control" onchange="this.form.submit();">
                                <option value="">모양 선택</option>
                                <% 
                                sql = "SELECT DISTINCT  GREEM_O_TYPE "
                                sql = sql & " FROM tk_frame "
                                sql = sql & " WHERE GREEM_F_A = '" & rgreem_f_a & "' and greem_basic_type = '" & rgreem_basic_type & "' ORDER BY GREEM_O_TYPE"
                                'response.write (SQL)&"<br>"
                                    Rs.open Sql,Dbcon,1,1,1
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do until Rs.EOF
                                        GREEM_O_TYPE        = rs(0)

                                        Select Case GREEM_O_TYPE
                                        Case "1"
                                            GREEM_O_TYPE_name = "외도어"
                                        Case "2"
                                            GREEM_O_TYPE_name = "외도어 상부남마"
                                        Case "3"
                                            GREEM_O_TYPE_name = "외도어 상부남마 중간소대"
                                        Case "4"
                                            GREEM_O_TYPE_name = "양개"
                                        Case "5"
                                            GREEM_O_TYPE_name = "양개 상부남마"
                                        Case "6"
                                            GREEM_O_TYPE_name = "양개 상부남마 중간소대"    
                                        Case Else
                                            GREEM_O_TYPE_name = "기타 타입"    
                                    end select         
                                %>
                                <option value="<%=GREEM_O_TYPE%>" <% if cint(GREEM_O_TYPE) = cint(rGREEM_O_TYPE) then Response.Write "selected" end if %>><%=GREEM_O_TYPE_name%></option>
                                <%
                                Rs.MoveNext
                                Loop
                                End If
                                Rs.close
                                %>
                            </select>
                        </div>
                        <% end if %>
                        <div class="col-2">
                            <select name="greem_fix_type" class="form-control" onchange="this.form.submit();">
                                <option value="">픽스 추가 선택</option>
                                <% 
                                sql = "SELECT DISTINCT  greem_fix_type "
                                sql = sql & " FROM tk_frame "
                                sql = sql & " WHERE GREEM_F_A = '" & rgreem_f_a & "' and greem_basic_type = '" & rgreem_basic_type & "'  and GREEM_O_TYPE = '" & rGREEM_O_TYPE & "'ORDER BY greem_fix_type"
                                'response.write (SQL)&"<br>"
                                    Rs.open Sql,Dbcon,1,1,1
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do until Rs.EOF
                                        greem_fix_type        = rs(0)

                                        Select Case greem_fix_type
                                        Case "0"
                                            greem_fix_type_name = "픽스없음"
                                        Case "1"
                                            greem_fix_type_name = "좌픽스"
                                        Case "2"
                                            greem_fix_type_name = "우픽스"
                                        Case "3"
                                            greem_fix_type_name = "좌+우 픽스"
                                        Case "4"
                                            greem_fix_type_name = "좌+좌 픽스"
                                        Case "5"
                                            greem_fix_type_name = "우+우 픽스"
                                        Case "6"
                                            greem_fix_type_name = "좌1+우2 픽스"    
                                        Case "7"
                                            greem_fix_type_name = "좌2+우1 픽스"    
                                        Case "8"
                                            greem_fix_type_name = "좌2+우2 픽스"   
                                        Case "9"
                                        greem_fix_type_name = "편개"
                                        Case "10"
                                            greem_fix_type_name = "양개"
                                        Case "11"
                                            greem_fix_type_name = "고정창"
                                        Case "12"
                                            greem_fix_type_name = "편개_상부남마"
                                        Case "13"
                                            greem_fix_type_name = "양개_상부남마"
                                        Case "14"
                                            greem_fix_type_name = "고정창_상부남마"
                                        Case "15"
                                            greem_fix_type_name = "편개_상부남마_중"     
                                        Case Else
                                            greem_fix_type_name = "기타 타입"    
                                    end select         
                                %>
                                <option value="<%=greem_fix_type%>" <% if cint(greem_fix_type) = cint(rgreem_fix_type) then Response.Write "selected" end if %>><%=greem_fix_type_name%></option>
                                <%
                                Rs.MoveNext
                                Loop
                                End If
                                Rs.close
                                %>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="card card-body mb-1"><!-- *  33333333  -->
                <div class="row ">
                    <%
                    sql = " SELECT fidx, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, fmidx, fwdate, fmeidx, fewdate ,greem_o_type, greem_habar_type, greem_lb_type, GREEM_MBAR_TYPE "
                    sql = sql & " FROM tk_frame "
                    sql = sql & " WHERE fidx <>'' "
                    if  rgreem_f_a <>"0" then
                    sql = sql & " and greem_f_a= '"&rgreem_f_a&"'  "
                    end if
                    if  rGREEM_BASIC_TYPE <>"0" then
                    sql = sql & " and GREEM_BASIC_TYPE = '"&rGREEM_BASIC_TYPE&"'  "
                    end if            
                    if  rgreem_o_type <>"0" then
                    sql = sql & " and greem_o_type = '"&rgreem_o_type&"' "
                    end if 
                    if  rgreem_fix_type <>"" then
                    sql = sql & " and greem_fix_type = '"&rgreem_fix_type&"' "
                    end if
                    if  rgreem_habar_type <>"" then
                    sql = sql & " and greem_habar_type = '"&rgreem_habar_type&"' "
                    end if
                    if  rgreem_lb_type <>"" then
                    sql = sql & " and greem_lb_type = '"&rgreem_lb_type&"' "
                    end if
                    if  rGREEM_MBAR_TYPE <>"" then
                    sql = sql & " and GREEM_MBAR_TYPE = '"&rGREEM_MBAR_TYPE&"' "
                    end if


                    'response.write (SQL)&"<br>"
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF
                    fidx        = rs(0)
                    greem_f_a        = rs(1)
                    greem_basic_type = rs(2)
                    greem_fix_type   = rs(3)
                    fmidx       = rs(4)
                    fwdate      = rs(5)
                    fmeidx      = rs(6)
                    fewdate     = rs(7)
                    greem_o_type     = rs(8)
                    greem_habar_type     = rs(9)
                    greem_lb_type     = rs(10)
                    GREEM_MBAR_TYPE     = rs(11)

                    ' ▼ greem_f_a 변환
                    Select Case greem_f_a
                        Case "1"
                            greem_f_a_name = "자동"
                        Case "2"
                            greem_f_a_name = "수동"
                        Case Else
                            greem_f_a_name = "기타"
                    End Select

                    ' ▼ greem_basic_type 변환
                    Select Case greem_basic_type
                        Case "1"
                            greem_basic_type_name = "기본"
                        Case "2"
                            greem_basic_type_name = "인서트 타입(T형)"
                        Case "3"
                            greem_basic_type_name = "픽스바 없는 타입"
                        Case "4"
                            greem_basic_type_name = "자동홈바 없는 타입"
                        Case Else
                            greem_basic_type_name = "기타 타입"
                    End Select

                    ' ▼ greem_o_type 변환
                    Select Case greem_o_type
                        Case "1"
                            greem_o_type_name = "외도어"
                        Case "2"
                            greem_o_type_name = "외도어 상부남마"
                        Case "3"
                            greem_o_type_name = "외도어 상부남마 중간소대"
                        Case "4"
                            greem_o_type_name = "양개"
                        Case "5"
                            greem_o_type_name = "양개 상부남마"
                        Case "6"
                            greem_o_type_name = "양개 상부남마 중간소대"
                        Case Else
                            greem_o_type_name = "기타 타입"
                    End Select

                    ' ▼ greem_fix_type 변환
                    Select Case greem_fix_type
                        Case "0" 
                            greem_fix_type_name = "픽스없음"
                        Case "1"
                            greem_fix_type_name = "좌픽스"
                        Case "2"
                            greem_fix_type_name = "우픽스"
                        Case "3"
                            greem_fix_type_name = "좌+우 픽스"
                        Case "4"
                            greem_fix_type_name = "좌+좌 픽스"
                        Case "5"
                            greem_fix_type_name = "우+우 픽스"
                        Case "6"
                            greem_fix_type_name = "좌1+우2 픽스"
                        Case "7"
                            greem_fix_type_name = "좌2+우1 픽스"
                        Case "8"
                            greem_fix_type_name = "좌2+우2 픽스"
                        Case "9"
                            greem_fix_type_name = "편개"
                        Case "10"
                            greem_fix_type_name = "양개"
                        Case "11"
                            greem_fix_type_name = "고정창"
                        Case "12"
                            greem_fix_type_name = "편개_상부남마"
                        Case "13"
                            greem_fix_type_name = "양개_상부남마"
                        Case "14"
                            greem_fix_type_name = "고정창_상부남마"
                        Case "15"
                            greem_fix_type_name = "편개_상부남마_중"
                        Case Else
                            greem_fix_type_name = "기타 타입"
                    End Select
                    ' ▼ greem_habar_type 변환
                    Select Case greem_habar_type
                        Case "0"
                            greem_habar_type_name = "하바분할 없음"
                        Case "1"
                            greem_habar_type_name = "하바분할"
                    End Select
                    ' ▼ greem_lb_type 변환
                    Select Case greem_lb_type
                        Case "0"
                            greem_lb_type_name = "로비폰 없음"
                        Case "1"
                            greem_lb_type_name = "로비폰"
                    End Select
                    ' ▼ GREEM_MBAR_TYPE 변환
                    Select Case GREEM_MBAR_TYPE
                        Case "0"
                            GREEM_MBAR_TYPE_name = "중간소대 추가 없음"
                        Case "1"
                            GREEM_MBAR_TYPE_name = "중간소대 추가"
                    End Select

                    %> 
                    <div class="col-2">
                        <div class="card card-body mb-1">
                            <div class="canvas-container">
                                <svg id="canvas" width="200" height="100" viewBox="0 100 1000 500" style="background-color: #c8cbe7;" class="d-block">
                                <rect id="rectangle" fill="white" stroke="black" stroke-width="1" width="0" height="0"></rect>
                                <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                                <text id="width-label" class="dimension-label"></text>
                                <text id="height-label" class="dimension-label"></text>
                                
                                    <%
                                    SQL="select fsidx, xi, yi, wi, hi from tk_frameSub Where fidx='"&fidx&"' "
                                    Rs1.open Sql,Dbcon
                                    If Not (Rs1.bof or Rs1.eof) Then 
                                    Do while not Rs1.EOF
                                        i=i+1
                                        fsidx=Rs1(0)
                                        xi=Rs1(1)
                                        yi=Rs1(2)
                                        wi=Rs1(3)
                                        hi=Rs1(4)
                                    %>
                                    <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="#f1bcbc" stroke="#333333" stroke-width="" onclick="del('<%=fsidx%>');"/>
                                    <text x="<%=xi+5%>" y="<%=yi+20%>" font-family="Arial" font-size="14" fill="#000000"><%=i%></text>
                                    <%
                                    Rs1.movenext
                                    Loop
                                    End if
                                    Rs1.close
                                    %>          
                                </svg>
                                    <%  
                                        sql = " SELECT fidx, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, fmidx, fwdate, fmeidx, fewdate ,greem_o_type, greem_habar_type, greem_lb_type, GREEM_MBAR_TYPE "
                                        sql = sql & " FROM tk_frame "
                                        sql = sql & " WHERE fidx='"&fidx&"' "
                                        Rs1.open Sql,Dbcon
                                        If Not (Rs1.bof or Rs1.eof) Then 
                                        Do while not Rs1.EOF
                                            greem_o_type        = rs(0)
                                            Select Case greem_o_type
                                                Case "1"
                                                    greem_o_type_name = "외도어"
                                                Case "2"
                                                    greem_o_type_name = "외도어 상부남마"
                                                Case "3"
                                                    greem_o_type_name = "외도어 상부남마 중간소대"
                                                Case "4"
                                                    greem_o_type_name = "양개"
                                                Case "5"
                                                    greem_o_type_name = "양개 상부남마"
                                                Case "6"
                                                    greem_o_type_name = "양개 상부남마 중간소대"
                                                Case Else
                                                    greem_o_type_name = "기타 타입"
                                            End Select
                                        %>
                                            <div>
                                                <button 
                                                    class="btn btn-success btn-small" 
                                                    type="button" 
                                                    onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST.asp?SJB_IDX=<%=SJB_IDX%>#<%=SJB_IDX%>');">
                                                    <%=greem_o_type_name%>
                                                </button>
                                            </div>
                                        <%
                                            Rs1.movenext
                                        Loop
                                        End if
                                        Rs1.close
                                        %>
                            </div>
                        </div>
                    </div>
                <%
                Rs.movenext
                Loop
                End if
                Rs.close
                %>
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
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
