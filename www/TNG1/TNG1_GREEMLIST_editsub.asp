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

rftidx=Request("ftidx")
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
Response.Write "rftidx : " & rftidx & "<br>"
'Response.Write "rgreem_f_a : " & rgreem_f_a & "<br>"
'Response.Write "rGREEM_BASIC_TYPE : " & rGREEM_BASIC_TYPE & "<br>"
'Response.Write "rgreem_o_type : " & rgreem_o_type & "<br>"

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
        function del(ftidx){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_GREEMLIST_editsub.asp?part=delete&ftidx="+ftidx;
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
                    <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG1_GREEMLIST_editsubsub.asp?ftidx=0');">등록</button>
                </div>
            </div>
            <!-- 표 형식 시작--> 
            <div class="input-group mb-3">
                <table id="datatablesSimple"  class="table table-hover">
                    <thead>
                        <tr>
                            <th align="center">번호</th>
                            <th align="center">자동_타입</th>
                            <th align="center">자동_타입이름</th>
                            <th align="center">수동_타입</th>
                            <th align="center">수동_타입이름</th>
                            <th align="center">자동옵션_타입</th>
                            <th align="center">자동옵션_타입이름</th>
                        </tr>
                    </thead>
                    <tbody>
                    <form id="dataForm" action="TNG1_GREEMLIST_DBsub.asp" method="POST">   
                    <input type="hidden" name="ftidx" value="<%=rftidx%>">
                        <% if rftidx="0" then %>
                        <tr>
                            <td><input class="input-field" type="GREEM_BASIC_TYPEname" size="3"  name="GREEM_BASIC_TYPEname" id="GREEM_BASIC_TYPEname" 
                            value="<%=rGREEM_BASIC_TYPEname%>" 
                            onkeypress="handleKeyPress(event, 'GREEM_BASIC_TYPEname', 'GREEM_BASIC_TYPEname')"/></td> 
                        </tr>
                        <% end if %>
                        <%
                        SQL = "SELECT ftidx"
                        SQL = SQL & " , GREEM_BASIC_TYPE, GREEM_BASIC_TYPEname"
                        SQL = SQL & " , GREEM_FIX_TYPE, GREEM_FIX_TYPEname"
                        SQL = SQL & " , greem_o_type, greem_o_typename"
                        SQL = SQL & " , GREEM_HABAR_TYPE, GREEM_HABAR_TYPEname"
                        SQL = SQL & " , GREEM_MBAR_TYPE, GREEM_MBAR_TYPEname"
                        SQL = SQL & " , GREEM_LB_TYPE, GREEM_LB_TYPEname"
                        SQL = SQL & " , midx, mdate"
                        SQL = SQL & " FROM tk_frametype"
                        sql = sql & " WHERE ftidx <> 0  "
                        sql = sql & " ORDER BY ftidx aSC "
                            Rs.open Sql,Dbcon,1,1,1
                            if not (Rs.EOF or Rs.BOF ) then
                            Do while not Rs.EOF
                                ftidx                 = rs(0)
                                GREEM_BASIC_TYPE      = rs(1)
                                GREEM_BASIC_TYPEname  = rs(2)
                                GREEM_FIX_TYPE        = rs(3)
                                GREEM_FIX_TYPEname    = rs(4)
                                greem_o_type          = rs(5)
                                greem_o_typename      = rs(6)
                                GREEM_HABAR_TYPE      = rs(7)
                                GREEM_HABAR_TYPEname  = rs(8)
                                GREEM_MBAR_TYPE       = rs(9)
                                GREEM_MBAR_TYPEname   = rs(10)
                                GREEM_LB_TYPE         = rs(11)
                                GREEM_LB_TYPEname     = rs(12)
                                midx                  = rs(13)
                                mdate                 = rs(14)
                                
                                i=i+1
                        %>  
                        <% if int(ftidx)=int(rftidx) then %>
                        <tr>
                            <td style="text-align:center; vertical-align:middle;">
                            <a name="<%=ftidx%>"></a>
                                <div>
                                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="del('<%=ftidx%>');"><%=i%></button>
                                </div>
                            </td>
                            <td>
                                <input class="input-field" type="GREEM_BASIC_TYPE" size="3"  name="GREEM_BASIC_TYPE" id="GREEM_BASIC_TYPE" 
                                value="<%=GREEM_BASIC_TYPE%>" 
                                onkeypress="handleKeyPress(event, 'GREEM_BASIC_TYPE', 'GREEM_BASIC_TYPE')"/>
                            </td>
                            <td>
                                <input class="input-field" type="GREEM_BASIC_TYPEname" size="5"  name="GREEM_BASIC_TYPEname" id="GREEM_BASIC_TYPEname" 
                                value="<%=GREEM_BASIC_TYPEname%>" 
                                onkeypress="handleKeyPress(event, 'GREEM_BASIC_TYPEname', 'GREEM_BASIC_TYPEname')"/>
                            </td> 
                            <td>
                                <input class="input-field" type="GREEM_FIX_TYPE" size="3"  name="GREEM_FIX_TYPE" id="GREEM_FIX_TYPE" 
                                value="<%=GREEM_FIX_TYPE%>" 
                                onkeypress="handleKeyPress(event, 'GREEM_FIX_TYPE', 'GREEM_FIX_TYPE')"/>
                            </td>
                            <td>
                                <input class="input-field" type="GREEM_FIX_TYPEname" size="5"  name="GREEM_FIX_TYPEname" id="GREEM_FIX_TYPEname" 
                                value="<%=GREEM_FIX_TYPEname%>" 
                                onkeypress="handleKeyPress(event, 'GREEM_FIX_TYPEname', 'GREEM_FIX_TYPEname')"/>
                            </td>
                            <td>
                                <input class="input-field" type="greem_o_type" size="3"  name="greem_o_type" id="greem_o_type" 
                                value="<%=greem_o_type%>" 
                                onkeypress="handleKeyPress(event, 'greem_o_type', 'greem_o_type')"/>
                            </td>
                            <td>
                                <input class="input-field" type="greem_o_typename" size="5"  name="greem_o_typename" id="greem_o_typename" 
                                value="<%=greem_o_typename%>" 
                                onkeypress="handleKeyPress(event, 'greem_o_typename', 'greem_o_typename')"/>
                            </td>  
                        </tr>   
                        <% else %>   
                        <tr> 
                            <td align="center"><%=i%></td>
                            <td>
                                <input class="input-field" type="text" value="<%=GREEM_BASIC_TYPE%>" onclick="location.replace('TNG1_GREEMLIST_editsub.asp?ftidx=<%=ftidx%>#<%=ftidx%>');" readonly />
                            </td>
                            <td>
                                <input class="input-field" type="text" value="<%=GREEM_BASIC_TYPEname%>" onclick="location.replace('TNG1_GREEMLIST_editsub.asp?ftidx=<%=ftidx%>#<%=ftidx%>');" readonly />
                            </td>
                            <td>
                                <input class="input-field" type="text" value="<%=GREEM_FIX_TYPE%>" onclick="location.replace('TNG1_GREEMLIST_editsub.asp?ftidx=<%=ftidx%>#<%=ftidx%>');" readonly />
                            </td>
                            <td>
                                <input class="input-field" type="text" value="<%=GREEM_FIX_TYPEname%>" onclick="location.replace('TNG1_GREEMLIST_editsub.asp?ftidx=<%=ftidx%>#<%=ftidx%>');" readonly />
                            </td>
                            <td>
                                <input class="input-field" type="text" value="<%=greem_o_type%>" onclick="location.replace('TNG1_GREEMLIST_editsub.asp?ftidx=<%=ftidx%>#<%=ftidx%>');" readonly />
                            </td>
                            <td>
                                <input class="input-field" type="text" value="<%=greem_o_typename%>" onclick="location.replace('TNG1_GREEMLIST_editsub.asp?ftidx=<%=ftidx%>#<%=ftidx%>');" readonly />
                            </td>
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
