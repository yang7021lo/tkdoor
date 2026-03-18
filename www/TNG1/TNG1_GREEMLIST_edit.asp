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

part = Request("part")

rfidx=Request("fidx")
rgreem_f_a=Request("greem_f_a")
rGREEM_BASIC_TYPE=Request("GREEM_BASIC_TYPE")
rgreem_o_type=Request("greem_o_type")
rGREEM_FIX_TYPE=Request("GREEM_FIX_TYPE")
rgreem_habar_type=Request("greem_habar_type")
rgreem_lb_type=Request("greem_lb_type")
rGREEM_MBAR_TYPE=Request("GREEM_MBAR_TYPE")

'start_fidx = Request("start_fidx")
'copy_fidx = Request("copy_fidx")


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
'Response.Write "rgreem_o_type : " & rgreem_o_type & "<br>"

'Response.Write "rGREEM_FIX_TYPE : " & rGREEM_FIX_TYPE & "<br>"
'response.end
'▣ 편개 (공통 / 좌우 아님)
' 9   편개
' 12  편개_상부남마
' 15  편개_상부남마_중
' 28  편개_박스라인
' 31  편개_상부남마_박스라인
' 34  편개_상부남마_중_박스라인
'▣ 편개_좌
' 16  좌_편개
' 22  좌_편개_남마
' 35  좌_편개_박스라인
' 41  좌_편개_남마_박스라인
'▣ 편개_우
' 17  우_편개
' 23  우_편개_남마
' 36  우_편개_박스라인
' 42  우_편개_남마_박스라인
'▣ 양개 (공통 / 좌우 아님)
' 10  양개
' 13  양개_상부남마
' 29  양개_박스라인
' 32  양개_상부남마_박스라인
'▣ 양개_좌
' 18  좌_양개
' 24  좌_양개_남마
' 37  좌_양개_박스라인
' 43  좌_양개_남마_박스라인
'▣ 양개_우
' 19  우_양개
' 25  우_양개_남마
' 38  우_양개_박스라인
' 44  우_양개_남마_박스라인
'▣ 고정창 (공통 / 좌우 아님)
' 11  고정창
' 14  고정창_상부남마
' 30  고정창_박스라인
' 33  고정창_상부남마_박스라인
'▣ 픽스_좌
' 20  좌_픽스
' 26  좌_픽스_남마
' 39  좌_픽스_박스라인
' 45  좌_픽스_남마_박스라인
'▣ 픽스_우
' 21  우_픽스
' 27  우_픽스_남마
' 40  우_픽스_박스라인
' 46  우_픽스_남마_박스라인
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
        function del(fidx){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_GREEMLIST_DB.asp?part=delete&fidx="+fidx;
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
            <div class="row mb-3">
                <div class="col text-start">
                    <h3>품목명 추가</h3>
                </div>
                <div class="col text-end">
                    <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=0');">등록</button>
                </div>
            </div>
            <!-- 표 형식 시작--> 
            <div class="input-group mb-3">
                <table id="datatablesSimple"  class="table table-hover">
                    <thead>
                        <tr>
                        <!--
                            <th align="center">start</th>
                            <th align="center">copy</th>
                            -->
                            <th align="center">번호</th>
                            <th align="center">이름</th>
                            <th align="center">수동/자동</th>
                            <th align="center">자동_타입</th>
                            <th align="center">수동_타입</th>
                            <th align="center">자동옵션_타입</th>
                            <th align="center">하바_타입</th>
                            <th align="center">로비폰_타입</th>
                            <th align="center">중간소대_타입</th>
                            <th align="center">자동옵션_샐랙트A</th>
                            <th align="center">자동옵션_샐랙트B</th>
                            <th align="center">자동옵션_샐랙트C</th>
                            <th align="center">자동옵션_샐랙트D</th>
                        </tr>
                    </thead>
                    <tbody>
                    <form id="dataForm" action="TNG1_GREEMLIST_DB.asp" method="POST">   
                    <input type="hidden" name="fidx" value="<%=rfidx%>">
                        <% if rfidx="0" then %>
                        <tr>
                            <td><input class="input-field" type="fname" size="3"  name="fname" id="fname" value="<%=rfname%>" 
                            onkeypress="handleKeyPress(event, 'fname', 'fname')"/></td> 
                        </tr>
                        <% end if %>
                        <%
                        sql = " SELECT A.fidx, A.GREEM_F_A, A.GREEM_BASIC_TYPE, A.GREEM_FIX_TYPE, A.fmidx, A.fwdate, A.fmeidx "
                        sql = sql & " , A.fewdate, A.greem_o_type, A.greem_habar_type, A.greem_lb_type, A.GREEM_MBAR_TYPE "
                        sql = sql & " , A.opa, A.opb, A.opc, A.opd, A.fname "
                        sql = sql & " , B.GREEM_BASIC_TYPEname, C.GREEM_FIX_TYPEname, D.GREEM_O_TYPENAME "
                        sql = sql & " FROM tk_frame A "
                        sql = sql & " LEFT JOIN (SELECT DISTINCT GREEM_BASIC_TYPE, GREEM_BASIC_TYPEname FROM tk_frametype  WHERE GREEM_BASIC_TYPE IS NOT NULL) B "
                        sql = sql & "   ON A.GREEM_BASIC_TYPE = B.GREEM_BASIC_TYPE "
                        sql = sql & " LEFT JOIN (SELECT DISTINCT GREEM_FIX_TYPE, GREEM_FIX_TYPEname FROM tk_frametype  WHERE GREEM_FIX_TYPE IS NOT NULL) C "
                        sql = sql & "   ON A.GREEM_FIX_TYPE = C.GREEM_FIX_TYPE "
                        sql = sql & " LEFT JOIN (SELECT DISTINCT greem_o_type, greem_o_typename FROM tk_frametype  WHERE greem_o_type IS NOT NULL) D "
                        sql = sql & "   ON A.greem_o_type = D.greem_o_type "
                        sql = sql & " WHERE A.fidx <> 0 and a.fstatus = 1 "
                        'sql = sql & " and A.GREEM_F_A =1  "
                        'sql = sql & " and A.greem_o_type =6  "
                        sql = sql & " ORDER BY A.fidx ASC "
                            Rs.open Sql,Dbcon,1,1,1
                            if not (Rs.EOF or Rs.BOF ) then
                            Do while not Rs.EOF
                            fidx                   = rs(0)
                            GREEM_F_A              = rs(1)
                            GREEM_BASIC_TYPE       = rs(2)
                            GREEM_FIX_TYPE         = rs(3)
                            fmidx                  = rs(4)
                            fwdate                 = rs(5)
                            fmeidx                 = rs(6)
                            fewdate                = rs(7)
                            GREEM_O_TYPE           = rs(8)
                            GREEM_HABAR_TYPE       = rs(9)
                            GREEM_LB_TYPE          = rs(10)
                            GREEM_MBAR_TYPE        = rs(11)
                            opa                    = rs(12)
                            opb                    = rs(13)
                            opc                    = rs(14)
                            opd                    = rs(15)
                            fname                  = rs(16)
                            GREEM_BASIC_TYPE_name  = rs(17)
                            GREEM_FIX_TYPE_name    = rs(18)
                            GREEM_O_TYPE_name      = rs(19)

                                select case GREEM_F_A
                                    case "1"
                                        GREEM_F_A_name="수동"
                                    case "2"
                                        GREEM_F_A_name="자동"
                                end select

                                Select Case GREEM_HABAR_TYPE
                                    Case "0"
                                        GREEM_HABAR_TYPE_name = "❌"
                                    Case "1"
                                        GREEM_HABAR_TYPE_name = "✅"
                                End Select

                                Select Case GREEM_LB_TYPE
                                    Case "0"
                                        GREEM_LB_TYPE_name = "❌"
                                    Case "1"
                                        GREEM_LB_TYPE_name = "✅"
                                End Select

                                Select Case GREEM_MBAR_TYPE
                                    Case "0"
                                        GREEM_MBAR_TYPE_name = "❌"
                                    Case "1"
                                        GREEM_MBAR_TYPE_name = "✅"
                                End Select
                                i=i+1
                        %>  
                        <% if int(fidx)=int(rfidx) then %>
                        <tr>
                            <!--<td>
                                <input class="input-field" type="text" size="1"  name="start_fidx" id="start_fidx" value="<%=fidx%>" 
                                onkeypress="handleKeyPress(event, 'start_fidx', 'start_fidx')"/> 
                            </td>
                            <%Response.Write "start_fidx : " & start_fidx & "<br>"%>
                            <td>
                                <input class="input-field" type="text" size="1"  name="split_fidx" id="split_fidx" value="<%=start_fidx%>_<%=fidx%>" 
                                onkeypress="handleKeyPress(event, 'split_fidx', 'split_fidx')"/> 
                            </td> -->
                            <td style="text-align:center; vertical-align:middle;">
                            <a name="<%=fidx%>"></a>
                                <div>
                                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="del('<%=fidx%>');"><%=fidx%></button>
                                    <button 
                                        class="btn btn-dark" 
                                        type="button" 
                                        onclick="window.open('TNG1_FRAME.asp?rfidx=<%=fidx%>', '_blank', 'width=1300,height=1000,scrollbars=yes');">
                                    </button>
                                </div>
                            </td>
                            <td><input class="input-field" type="fname" size="40"  name="fname" id="fname" value="<%=fname%>" 
                            onkeypress="handleKeyPress(event, 'fname', 'fname')"/></td> 
                            <td>
                                <select class="input-field" name="GREEM_F_A" id="GREEM_F_A"  onchange="handleSelectChange(event, 'GREEM_F_A', 'GREEM_F_A')">
                                    <option value="1" <% If GREEM_F_A = "1" Then Response.Write "selected" %> >수동</option>
                                    <option value="2" <% If GREEM_F_A = "2" Then Response.Write "selected" %> >자동</option>
                                </select>
                            </td> 
                            <td>
                                <select class="input-field" name="GREEM_BASIC_TYPE" id="GREEM_BASIC_TYPE" onchange="handleSelectChange(event, 'GREEM_BASIC_TYPE', 'GREEM_BASIC_TYPE')">
                                    <%
                                    sql = "SELECT DISTINCT GREEM_BASIC_TYPE, GREEM_BASIC_TYPEname FROM tk_frametype  WHERE GREEM_BASIC_TYPE IS NOT NULL"
                                    Rs1.open sql, Dbcon, 1, 1, 1
                                    If Not (Rs1.BOF Or Rs1.EOF) Then 
                                        Do Until Rs1.EOF
                                            yGREEM_BASIC_TYPE = Rs1(0)
                                            yGREEM_BASIC_TYPEname = Rs1(1)
                                    %>
                                    <option value="<%=yGREEM_BASIC_TYPE%>" 
                                        <% If IsNumeric(GREEM_BASIC_TYPE) And IsNumeric(yGREEM_BASIC_TYPE) Then 
                                            If CInt(GREEM_BASIC_TYPE) = CInt(yGREEM_BASIC_TYPE) Then 
                                                Response.Write "selected"
                                            End If 
                                        End If %>>
                                        <%=yGREEM_BASIC_TYPEname%>
                                    </option>
                                    <%
                                        Rs1.MoveNext
                                        Loop
                                    End If
                                    Rs1.Close
                                    %>
                                </select>
                            </td>
                            <td>
                                <select class="input-field" name="GREEM_FIX_TYPE" id="GREEM_FIX_TYPE" onchange="handleSelectChange(event, 'GREEM_FIX_TYPE', 'GREEM_FIX_TYPE')">
                                    <%
                                    sql = "SELECT DISTINCT GREEM_FIX_TYPE, GREEM_FIX_TYPEname FROM tk_frametype  WHERE GREEM_FIX_TYPE IS NOT NULL"
                                    Rs1.Open sql, Dbcon, 1, 1
                                    If Not (Rs1.BOF Or Rs1.EOF) Then 
                                        Do Until Rs1.EOF
                                            yGREEM_FIX_TYPE = Rs1(0)
                                            yGREEM_FIX_TYPEname = Rs1(1)
                                    %>
                                    <option value="<%=yGREEM_FIX_TYPE%>" 
                                    <% If IsNumeric(GREEM_FIX_TYPE) And IsNumeric(yGREEM_FIX_TYPE) Then 
                                            If CInt(GREEM_FIX_TYPE) = CInt(yGREEM_FIX_TYPE) Then 
                                                Response.Write "selected"
                                            End If 
                                        End If %>>
                                        <%=yGREEM_FIX_TYPEname%>
                                    </option>
                                    <%
                                        Rs1.MoveNext
                                        Loop
                                    End If
                                    Rs1.Close
                                    %>
                                </select>
                                </td>
                                <td>
                                    <select class="input-field" name="GREEM_O_TYPE" id="GREEM_O_TYPE" onchange="handleSelectChange(event, 'GREEM_O_TYPE', 'GREEM_O_TYPE')">
                                        <%
                                        sql = "SELECT DISTINCT greem_o_type, greem_o_typename FROM tk_frametype  WHERE greem_o_type IS NOT NULL"
                                        Rs1.open sql, Dbcon, 1, 1, 1
                                        If Not (Rs1.BOF Or Rs1.EOF) Then 
                                            Do Until Rs1.EOF
                                                yGREEM_O_TYPE = Rs1(0)
                                                yGREEM_O_TYPENAME = Rs1(1)
                                        %>
                                        <option value="<%=yGREEM_O_TYPE%>" 
                                            <% If IsNumeric(GREEM_O_TYPE) And IsNumeric(yGREEM_O_TYPE) Then 
                                                If CInt(GREEM_O_TYPE) = CInt(yGREEM_O_TYPE) Then 
                                                    Response.Write "selected"
                                                End If 
                                            End If %>>
                                            <%=yGREEM_O_TYPENAME%>
                                        </option>
                                        <%
                                            Rs1.MoveNext
                                            Loop
                                        End If
                                        Rs1.Close
                                        %>
                                    </select>
                                </td>
                            <td>
                                <select class="input-field" name="GREEM_HABAR_TYPE" id="GREEM_HABAR_TYPE" onchange="handleSelectChange(event, 'GREEM_HABAR_TYPE', 'GREEM_HABAR_TYPE')">
                                    <option value="0" <% If GREEM_HABAR_TYPE = "0" Then Response.Write "selected" %>>❌</option>
                                    <option value="1" <% If GREEM_HABAR_TYPE = "1" Then Response.Write "selected" %>>✅</option>
                                </select>
                            </td>
                            <td>
                                <select class="input-field" name="GREEM_LB_TYPE" id="GREEM_LB_TYPE" onchange="handleSelectChange(event, 'GREEM_LB_TYPE', 'GREEM_LB_TYPE')">
                                    <option value="0" <% If GREEM_LB_TYPE = "0" Then Response.Write "selected" %>>❌</option>
                                    <option value="1" <% If GREEM_LB_TYPE = "1" Then Response.Write "selected" %>>✅</option>
                                </select>
                            </td>
                            <td>
                                <select class="input-field" name="GREEM_MBAR_TYPE" id="GREEM_MBAR_TYPE" onchange="handleSelectChange(event, 'GREEM_MBAR_TYPE', 'GREEM_MBAR_TYPE')">
                                    <option value="0" <% If GREEM_MBAR_TYPE = "0" Then Response.Write "selected" %>>❌</option>
                                    <option value="1" <% If GREEM_MBAR_TYPE = "1" Then Response.Write "selected" %>>✅</option>
                                </select>
                            </td>
                            <td><input class="input-field" type="text" size="3"  name="opa" id="opa" value="<%=opa%>" 
                            onkeypress="handleKeyPress(event, 'opa', 'opa')"/></td> 
                            <td><input class="input-field" type="text" size="3"  name="opb" id="opb" value="<%=opb%>" 
                            onkeypress="handleKeyPress(event, 'opb', 'opb')"/></td> 
                            <td><input class="input-field" type="text" size="3"  name="opc" id="opc" value="<%=opc%>" 
                            onkeypress="handleKeyPress(event, 'opc', 'opc')"/></td> 
                            <td><input class="input-field" type="text" size="3"  name="opd" id="opd" value="<%=opd%>" 
                            onkeypress="handleKeyPress(event, 'opd', 'opd')"/></td> 
                        </tr>   
                        <% else %>   
                        <tr> 
                            <!--<td><input class="input-field" type="text" value="<%=start_fidx%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>&start_fidx=<%=start_fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" value="<%=start_fidx%>_<%=fidx%>" onclick="location.replace('TNG1_GREEMLIST_DB.asp?fidx=<%=fidx%>&split_fidx=<%=start_fidx%>_<%=fidx%>#<%=fidx%>');" readonly /></td>  -->
                            <td align="center">
                            <%=fidx%>
                                <button 
                                    class="btn btn-dark" 
                                    type="button" 
                                    onclick="window.open('TNG1_FRAME.asp?rfidx=<%=fidx%>', '_blank', 'width=1300,height=1000,scrollbars=yes');">
                                </button>
                            </td>
                            <!-- <td><input class="input-field" type="text" value="<%=fname%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>&start_fidx=<%=start_fidx%>#<%=fidx%>');" readonly /></td> -->
                            <td><input class="input-field" type="text" size="40" value="<%=fname%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="3" value="<%=GREEM_F_A_name%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="15" value="<%=GREEM_BASIC_TYPE_name%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="8"  value="<%=GREEM_FIX_TYPE_name%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="30" value="<%=GREEM_O_TYPE_name%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="3" value="<%=GREEM_HABAR_TYPE_name%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="3" value="<%=GREEM_LB_TYPE_name%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="3" value="<%=GREEM_MBAR_TYPE_name%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="3" value="<%=opa%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="3" value="<%=opb%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="3" value="<%=opc%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
                            <td><input class="input-field" type="text" size="3" value="<%=opd%>" onclick="location.replace('TNG1_GREEMLIST_edit.asp?fidx=<%=fidx%>#<%=fidx%>');" readonly /></td>
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
           </main>                          
                <!-- footer 시작 -->    
       
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
