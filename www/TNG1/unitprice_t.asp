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
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

part=Request("part")

' 파일 및 폼 데이터 읽기
rSearchWord    = Request("SearchWord")
kgotopage    = Request("kgotopage")
' 🔹 추가된 컬럼들 - 모두 r 접두어 적용
' 🔹 tk_qty 테이블 기준 변수
ruptidx     = Request("uptidx")



'Response.Write "ruptidx : " & ruptidx & "<br>"
'Response.Write "ruptidx : " & ruptidx & "<br>"
'Response.Write "rQTYNAME : " & rQTYNAME & "<br>"
'Response.Write "rQTYcoNAME : " & rQTYcoNAME & "<br>"
'Response.Write "rQTYcostatus : " & rQTYcostatus & "<br>"
'Response.Write "rQTYcomidx : " & rQTYcomidx & "<br>"
'Response.Write "rQTYcowdate : " & rQTYcowdate & "<br>"
'Response.Write "rQTYcoemidx : " & rQTYcoemidx & "<br>"
'Response.Write "rQTYcoewdate : " & rQTYcoewdate & "<br>"
'Response.Write "rsheet_w : " & rsheet_w & "<br>"
'Response.Write "rsheet_h : " & rsheet_h & "<br>"
'Response.Write "rsheet_t : " & rsheet_t & "<br>"
'Response.Write "rcoil_cut : " & rcoil_cut & "<br>"
'Response.Write "rcoil_t : " & rcoil_t & "<br>"
'Response.end

	if request("kgotopage")="" then
	kgotopage=1
	else
	kgotopage=request("kgotopage")
	end if
	page_name="unitprice_t.asp?SearchWord="&Request("SearchWord")&"&"

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
                location.href="unitprice_tdb.asp?part=delete&searchWord=<%=rsearchword%>&uptidx="+sTR;
            }
        }
    </script>
</head>
<body class="sb-nav-fixed">

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
                        <div class="col-3 text-start">
                            <form id="Search" name="Search" action="unitprice_t.asp" method="POST">
                                <div class="input-group mb-3">
                                    <button type="button"
                                        class="btn btn-outline-danger"
                                        onclick="location.replace('TNG1b.asp');">돌아가기
                                    </button>
                                    <input type="text" class="form-control"   style="height: 36px;" name="SearchWord" value="<%=Request("SearchWord")%>">
                                    <button type="button" class="btn btn-outline-success"  onclick="submit();">검색</button>
                                    <button type="button" class="btn btn-outline-danger" Onclick="location.replace('unitprice_t.asp?uptidx=0');">등록</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!-- 제목 나오는 부분 끝-->
                        
                    <!-- 표 형식 시작--> 
                    <div class="input-group mb-3">
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th width="50" style="text-align:center; vertical-align:middle;">번호</th>
                                    <th width="80" style="text-align:center; vertical-align:middle;">bfwidx</th>
                                    <th width="80" style="text-align:center; vertical-align:middle;">bfidx</th>
                                    <th width="80" style="text-align:center; vertical-align:middle;">sjbtidx</th>
                                    <th width="80" style="text-align:center; vertical-align:middle;">qtyco_idx</th>
                                    <th width="80" style="text-align:center; vertical-align:middle;">SJB_IDX</th>
                                    <th width="80" style="text-align:center; vertical-align:middle;">QTYIDX</th>
                                    <th width="80" style="text-align:center; vertical-align:middle;">price</th>
                                    <th width="80" style="text-align:center; vertical-align:middle;">✅사용<br>❌안함</th>
                                </tr>
                            </thead>
                            <tbody>
                                <form id="dataForm" action="unitprice_tdb.asp" method="POST">   
                                    <input type="hidden" name="uptidx" value="<%=ruptidx%>">
                                    <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                                    <input type="hidden" name="kgotopage" value="<%=kgotopage%>">

                                    <% if ruptidx="0" then
                                    cccc="#800080"
                                    %>
                                        <tr>
                                            
                                            <%
                                            ' 🔹 새로운 uptidx 번호 구하기
                                                SQL = "SELECT ISNULL(MAX(uptidx), 0) + 1 FROM tng_unitprice_t"
                                                Rs.Open SQL, Dbcon
                                                If Not (Rs.EOF Or Rs.BOF) Then
                                                    ruptidx = Rs(0)
                                                End If
                                                Rs.Close
                                            %>
                                            <td>
                                            <input class="input-field" type="text" size="3"  name="ruptidx" id="uptidx" value="<%=ruptidx%>" onkeypress="handleKeyPress(event, 'uptidx', 'uptidx')"/>
                                            </td> 
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <!-- 단가 -->
                                            <td>
                                                <div style="display:flex; align-items:center;">
                                                    <input type="text" name="price" id="price"
                                                        value="<%=price%>"
                                                        style="width:80px; text-align:right;"
                                                        onkeypress="handleKeyPress(event, 'price', 'price')" />
                                                    <span style="margin-left:4px;">원</span>
                                                </div>
                                            </td>
                                            <td>
                                                <select class="input-field" name="upstatus" id="upstatus"  onchange="handleSelectChange(event, 'upstatus', 'upstatus')">
                                                    <option value="1" <% If upstatus = "1" Then Response.Write "selected" %> >✅</option>
                                                </select>
                                            </td> 
                                            

                                        </tr>
                                    <% end if %>
                                            <%
                                            i=0
                                            cccc=""
                                            sql = "SELECT uptidx, bfwidx, bfidx, sjbtidx, qtyco_idx, price, upstatus, SJB_IDX, QTYIDX FROM tng_unitprice_t "
                                            sql = sql & "WHERE uptidx <> '' "
                                            If Request("SearchWord") <> "" Then
                                                sql = sql & "AND ( uptidx LIKE '%" & Request("SearchWord") & "%' "
                                                sql = sql & "OR price LIKE '%" & Request("SearchWord") & "%' ) "
                                            End If
                                            sql = sql & "ORDER BY uptidx DESC"
                                            'response.write (SQL)&"<br>"
                                            Rs.open Sql,Dbcon,1,1,1
                                            Rs.PageSize = 10
                                            If Not (Rs.EOF Or Rs.BOF) Then
                                            no = Rs.recordcount - (Rs.pagesize * (kgotopage-1) ) + 1
                                            totalpage=Rs.PageCount 
                                            Rs.AbsolutePage =kgotopage
                                            i=1
                                            for j=1 to Rs.RecordCount 
                                            if i>Rs.PageSize then exit for end if
                                            if no-j=0 then exit for end if
                                                uptidx = Rs(0)
                                                bfwidx = Rs(1)
                                                bfidx = Rs(2)
                                                sjbtidx = Rs(3)
                                                qtyco_idx = Rs(4)
                                                price = Rs(5)
                                                upstatus = Rs(6)
                                                SJB_IDX = Rs(7)
                                                QTYIDX = Rs(8)
                                                
                                                Select Case upstatus
                                                    Case "0"
                                                        upstatus_text = "❌"
                                                    Case "1"
                                                        upstatus_text = "✅"
                                                End Select

                                                i=i+1
                                            %>
                                                          
                                            <% 
                                            'Response.Write "ruptidx : " & ruptidx & "<br>"
                                            if int(uptidx)=int(ruptidx) then 
                                            cccc="#E7E7E7"
                                            
                                            %>
                                        <tr>
                                            <!-- 번호 + 삭제 버튼 + 번호 입력 -->

                                            <td align="center"><a name="<%=uptidx%>">-><button type="button" class="btn btn-outline-danger" Onclick="del('<%=uptidx%>');"><%=uptidx%></button></td> 
                                           
                                            <!-- bfwidx SELECT 박스 -->
                                            <td>
                                            <select name="bfwidx" class="input-field">
                                                <%
                                                sql = "SELECT bfwidx, WHICHI_FIXname, WHICHI_AUTOname FROM tng_whichitype WHERE bfwstatus=1  ORDER BY bfwidx ASC"
                                                Rs1.Open sql, Dbcon, 1, 1
                                                If Not Rs1.EOF Then
                                                    Do Until Rs1.EOF
                                                        ybfwidx = Rs1(0)
                                                        yWHICHI_FIXname = Rs1(1)
                                                        yWHICHI_AUTOname = Rs1(2)
                                                %>
                                                    <option value="<%=ybfwidx%>" <% If CInt(bfwidx) = CInt(ybfwidx) Then Response.Write "selected" %>><%=yWHICHI_FIXname%> / <%=yWHICHI_AUTOname%></option>
                                                <%
                                                        Rs1.MoveNext
                                                    Loop
                                                End If
                                                Rs1.Close
                                                %>
                                            </select>
                                            </td>
                                            <!-- bfwidx SELECT 박스 -->
                                            <td>
                                                <select name="bfidx" class="input-field">
                                                <%
                                                sql = "SELECT bfidx, set_name_FIX, set_name_AUTO, WHICHI_FIX, WHICHI_AUTO FROM tk_barasiF ORDER BY bfidx ASC"
                                                Rs1.Open sql, Dbcon, 1, 1
                                                If Not Rs1.EOF Then
                                                    Do Until Rs1.EOF
                                                        ybfidx = Rs1(0)
                                                        yset_name_FIX = Rs1(1)
                                                        yset_name_AUTO = Rs1(2)
                                                        yWHICHI_FIX = Rs1(3)
                                                        yWHICHI_AUTO = Rs1(4)
                                                %>
                                                    <option value="<%=ybfidx%>" <% If CInt(bfidx) = CInt(ybfidx) Then Response.Write "selected" End If %>>
                                                        <%=yset_name_FIX%> / <%=yset_name_AUTO%> / <%=yWHICHI_FIX%> / <%=yWHICHI_AUTO%>
                                                    </option>
                                                <%
                                                        Rs1.MoveNext
                                                    Loop
                                                End If
                                                Rs1.Close
                                                %>
                                                </select>
                                            </td>
                                            <!-- sjbtidx  SELECT 박스 -->
                                            <td>
                                            <select name="sjbtidx" class="input-field">
                                            <%
                                            sql = "SELECT sjbtidx, SJB_TYPE_NO, SJB_TYPE_NAME FROM tng_sjbtype ORDER BY sjbtidx ASC"
                                            Rs1.Open sql, Dbcon, 1, 1
                                            If Not Rs1.EOF Then
                                                Do Until Rs1.EOF
                                                    ysjbtidx = Rs1(0)
                                                    ySJB_TYPE_NO = Rs1(1)
                                                    ySJB_TYPE_NAME = Rs1(2)
                                            %>
                                                <option value="<%=ysjbtidx%>" <% If CInt(sjbtidx) = CInt(ysjbtidx) Then Response.Write "selected" %>><%=ySJB_TYPE_NAME%></option>
                                            <%
                                                    Rs1.MoveNext
                                                Loop
                                            End If
                                            Rs1.Close
                                            %>
                                            </select>
                                            </td>

                                            <!-- qtyco_idx  SELECT 박스 -->
                                            <td>
                                            <select name="qtyco_idx" class="input-field">
                                            <%
                                            sql = "SELECT qtyco_idx, QTYNAME FROM tk_qtyco WHERE QTYcostatus=1 ORDER BY qtyco_idx ASC"
                                            Rs1.Open sql, Dbcon, 1, 1
                                            If Not Rs1.EOF Then
                                                Do Until Rs1.EOF
                                                    yqtyco_idx = Rs1(0)
                                                    yQTYNAME = Rs1(1)
                                            %>
                                                <option value="<%=yqtyco_idx%>" <% If CInt(qtyco_idx) = CInt(yqtyco_idx) Then Response.Write "selected" %>><%=yQTYNAME%></option>
                                            <%
                                                    Rs1.MoveNext
                                                Loop
                                            End If
                                            Rs1.Close
                                            %>
                                            </select>
                                            </td>

                                            <!-- SJB_IDX  SELECT 박스 -->
                                            <td>
                                            <select name="SJB_IDX" class="input-field">
                                            <%
                                            sql = "SELECT SJB_IDX, SJB_TYPE_NAME FROM TNG_SJB ORDER BY SJB_IDX ASC"
                                            Rs1.Open sql, Dbcon, 1, 1
                                            If Not Rs1.EOF Then
                                                Do Until Rs1.EOF
                                                    ySJB_IDX = Rs1(0)
                                                    ySJB_TYPE_NAME = Rs1(1)
                                            %>
                                                <option value="<%=ySJB_IDX%>" <% If CInt(SJB_IDX) = CInt(ySJB_IDX) Then Response.Write "selected" %>><%=ySJB_IDX%>/<%=ySJB_TYPE_NAME%></option>
                                            <%
                                                    Rs1.MoveNext
                                                Loop
                                            End If
                                            Rs1.Close
                                            %>
                                            </select>
                                            </td>

                                            <!-- QTYIDX  SELECT 박스 -->
                                            <td>
                                            <select name="QTYIDX" class="input-field">
                                            <%
                                            sql = "SELECT QTYIDX, QTYNAME FROM tk_qty ORDER BY QTYIDX ASC"
                                            Rs1.Open sql, Dbcon, 1, 1
                                            If Not Rs1.EOF Then
                                                Do Until Rs1.EOF
                                                    yQTYIDX = Rs1(0)
                                                    yQTYNAME = Rs1(1)
                                            %>
                                                <option value="<%=yQTYIDX%>" <% If CInt(QTYIDX) = CInt(yQTYIDX) Then Response.Write "selected" %>><%=yQTYIDX%>/<%=yQTYNAME%></option>
                                            <%
                                                    Rs1.MoveNext
                                                Loop
                                            End If
                                            Rs1.Close
                                            %>
                                            </select>
                                            </td>

                                            <!-- price 당 단가 -->
                                            <td>
                                                <div style="display:flex; align-items:center;">
                                                    <input type="text" name="price " id="price "
                                                        value="<%=price %>"
                                                        style="width:80px; text-align:right;"
                                                        onkeypress="handleKeyPress(event, 'price ', 'price ')" />
                                                    <span style="margin-left:4px;">원</span>
                                                </div>
                                            </td>

                                            <!-- ✅❌ -->
                                            <td>
                                                <select class="input-field" name="upstatus" id="upstatus" onchange="handleSelectChange(event, 'upstatus', 'upstatus')">
                                                    <option value="0" <% If upstatus = "0" Then Response.Write "selected" %> >❌</option>
                                                    <option value="1" <% If upstatus = "1" Then Response.Write "selected" %> >✅</option>
                                                </select>
                                            </td>
                                        </tr>


                                            <% else %>
                                        <tr> 
                                            <!--  <td style="text-align:center; vertical-align:middle;"><%=i%></td> -->
                                            <!-- uptidx 번호 -->
                                            <td style="text-align:center;">
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=uptidx%>" 
                                                    onclick="location.replace('unitprice_t.asp?kgotopage=<%=kgotopage%>&uptidx=<%=uptidx%>&SearchWord=<%=rSearchWord%>#<%=uptidx%>');" />
                                            </td>

                                            <!-- bfwidx -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=bfwidx%>" 
                                                    onclick="location.replace('unitprice_t.asp?kgotopage=<%=kgotopage%>&uptidx=<%=uptidx%>&SearchWord=<%=rSearchWord%>#<%=uptidx%>');" />
                                            </td>

                                            <!-- bfidx -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=bfidx%>" 
                                                    onclick="location.replace('unitprice_t.asp?kgotopage=<%=kgotopage%>&uptidx=<%=uptidx%>&SearchWord=<%=rSearchWord%>#<%=uptidx%>');" />
                                            </td>

                                            <!-- sjbtidx -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=sjbtidx%>" 
                                                    onclick="location.replace('unitprice_t.asp?kgotopage=<%=kgotopage%>&uptidx=<%=uptidx%>&SearchWord=<%=rSearchWord%>#<%=uptidx%>');" />
                                            </td>

                                            <!-- qtyco_idx -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=qtyco_idx%>" 
                                                    onclick="location.replace('unitprice_t.asp?kgotopage=<%=kgotopage%>&uptidx=<%=uptidx%>&SearchWord=<%=rSearchWord%>#<%=uptidx%>');" />
                                            </td>

                                            <!-- SJB_IDX -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=SJB_IDX%>" 
                                                    onclick="location.replace('unitprice_t.asp?kgotopage=<%=kgotopage%>&uptidx=<%=uptidx%>&SearchWord=<%=rSearchWord%>#<%=uptidx%>');" />
                                            </td>

                                            <!-- QTYIDX -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=QTYIDX%>" 
                                                    onclick="location.replace('unitprice_t.asp?kgotopage=<%=kgotopage%>&uptidx=<%=uptidx%>&SearchWord=<%=rSearchWord%>#<%=uptidx%>');" />
                                            </td>

                                            <!-- price (원) -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=price%>원" 
                                                    onclick="location.replace('unitprice_t.asp?kgotopage=<%=kgotopage%>&uptidx=<%=uptidx%>&SearchWord=<%=rSearchWord%>#<%=uptidx%>');" />
                                            </td>

                                            <!-- upstatus (✅❌) -->
                                            <td style="text-align:center;">
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=upstatus_text%>" 
                                                    onclick="location.replace('unitprice_t.asp?kgotopage=<%=kgotopage%>&uptidx=<%=uptidx%>&SearchWord=<%=rSearchWord%>#<%=uptidx%>');" />
                                            </td>
                                        </tr>                                           
                                            <% end if %>
                                            <%
                                            upstatus_text =""
                                            cccc=""
                                            Rs.movenext
                                            Next
                                            End If 
                                            %>
                                        <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                                </form>
                            </tbody>
                        </table>
                                    </div>
                    <div class="row">
                      <div  class="col-10 py-3"> 
<!--#include Virtual = "/inc/kpaging.asp" -->
                      </div>
<%
Rs.Close
%>
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
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
