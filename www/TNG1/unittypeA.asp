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
runittype_qtyco_idx  = Request("unittype_qtyco_idx")
runittype_bfwidx   = Request("unittype_bfwidx")
rSJB_IDX   = Request("SJB_IDX")
rSJB_TYPE_NAME   = Request("SJB_TYPE_NAME")
rsjbtidx   = Request("sjbtidx")
rSJB_barlist  = Request("SJB_barlist")

If rSJB_IDX = "" OR isnull(rSJB_IDX) Then 
    rSJB_IDX = "0"
End If
If runittype_qtyco_idx = "" OR isnull(runittype_qtyco_idx)  Then
    runittype_qtyco_idx = "0"
End If
If runittype_bfwidx = "" OR isnull(runittype_bfwidx) Then
    runittype_bfwidx = "0"
End If
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
	page_name="unittypeA.asp?SearchWord="&Request("SearchWord")&"&"

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
            zoom: 0.8;
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
                location.href="unittypedba.asp?part=delete&searchWord=<%=rsearchword%>&uptidx="+sTR;
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

<!-- 표 형식 시작--> 
<form id="dataForm" action="unittypedba.asp" method="POST">
    <div class="input-group mb-3">
        <table id="datatablesSimple"  class="table table-hover">
            <h3><%=rsjb_type_name%>_<%=rSJB_barlist%> 단가 입력 <%=rsjbtidx%></h3>
                <tbody>
                    <tr>
                        <th>bfwidx // qtyco_idx</th>
                            <%
                            ' 🔹 unittype_qtyco_idx 목록 출력 가로축 헤더
                            sql = "SELECT DISTINCT unittype_qtyco_idx FROM tk_qtyco "
                            SQL = SQL & " WHERE unittype_qtyco_idx <> '' "
                            SQL = SQL & " ORDER BY unittype_qtyco_idx asc "
                            'response.write (Sql)&"<br>"
                            Rs1.open Sql,Dbcon,1,1,1
                            i = 0
                            if not (Rs1.EOF or Rs1.BOF ) then
                            Do until Rs1.EOF
                                unittype_qtyco_idx        = rs1(0)

                                select case unittype_qtyco_idx
                                    case "0"
                                        unittype_qtyco_idx_text="❌"
                                    case "1"
                                        unittype_qtyco_idx_text="H/L"
                                    case "2"
                                        unittype_qtyco_idx_text="P/L"
                                    case "3"
                                        unittype_qtyco_idx_text="갈바"    
                                    case "4"
                                        unittype_qtyco_idx_text="블랙H/L"
                                    case "5"
                                        unittype_qtyco_idx_text="블랙,골드"
                                    case "6"
                                        unittype_qtyco_idx_text="바이브_등"
                                    case "7"
                                        unittype_qtyco_idx_text="브론즈_등"
                                    case "8"
                                        unittype_qtyco_idx_text="지급판"
                                    case "9"
                                        unittype_qtyco_idx_text="AL/도장"
                                    case "10"
                                        unittype_qtyco_idx_text="AL/블랙"
                                    case "11"
                                        unittype_qtyco_idx_text="헤어1.5"        
                                    case else
                                        unittype_qtyco_idx_text="(없음)"
                                end select 
                            %>   
                                <th width="50" style="text-align:center; vertical-align:middle;"><%=unittype_qtyco_idx_text%></th>
                            <%    
                                i = i + 1
                            Rs1.MoveNext
                            Loop
                            End If
                            Rs1.Close
                            %>
                    </tr>
                            <%
                            ' 🔹 unittype_bfwidx 목록 출력 (WHICHI_FIX 기준)
                            sql = "SELECT DISTINCT unittype_bfwidx FROM tng_whichitype "
                            SQL = SQL & " WHERE bfwstatus = 1 "
                            'sql = sql & " AND unittype_bfwidx BETWEEN 1 AND 10"
                            sql = sql & " AND WHICHI_auto IS NOT NULL"
                            sql = sql & " AND WHICHI_auto <> 0"
                            sql = sql & " AND WHICHI_auto <> ''"
                            SQL = SQL & " ORDER BY unittype_bfwidx asc "
                            'response.write (Sql)&"<br>"
                            Rs1.open Sql,Dbcon,1,1,1
                            i = 0
                            if not (Rs1.EOF or Rs1.BOF ) then
                            Do until Rs1.EOF
                                unittype_bfwidx        = rs1(0)
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
                            %>   
                                        <tr>
                                            <th width="50" style="text-align:center; vertical-align:middle;"><%=unittype_bfwidx_text%></th>
                                            <%
                                                ' 🔹 다시 qtyco 루프 돌면서 input 필드 출력
                                                sql = "SELECT DISTINCT unittype_qtyco_idx FROM tk_qtyco "
                                                sql = sql & " WHERE unittype_qtyco_idx <> '' "
                                                sql = sql & " ORDER BY unittype_qtyco_idx ASC "
                                                'Response.write (SQL)
                                                Rs2.Open sql, Dbcon, 1, 1
                                                If Not (Rs2.EOF Or Rs2.BOF) Then
                                                    Do While Not Rs2.EOF
                                                        unittype_qtyco_idx = Rs2(0)

                                                            sql = "SELECT  uptidx,price  "
                                                            sql = sql & "FROM tng_unitprice_t "
                                                            sql = sql & "WHERE SJB_IDX=" & rSJB_IDX & " and unittype_bfwidx = " & unittype_bfwidx & " and  unittype_qtyco_idx = " & unittype_qtyco_idx & ""
                                                            'response.write(sql)&"<br><br>"
                                                            Rs.Open sql, Dbcon
                                                            If Not (Rs.EOF Or Rs.BOF) Then
                                                                uptidx = Rs(0)
                                                                price = Rs(1)
                                                            End If
                                                            Rs.Close
                                                %>   
                                                    <td>
                                                    <% if cint(runittype_qtyco_idx)=cint(unittype_qtyco_idx) and cint(runittype_bfwidx)=cint(unittype_bfwidx) then %>
                                                        <%= rSJB_TYPE_NAME %>
                                                        <input type="hidden" name="uptidx" value="<%=uptidx%>">
                                                        <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
                                                        <input type="hidden" name="sjbtidx" value="<%=rsjbtidx%>">
                                                        <input type="hidden" name="SJB_TYPE_NAME" value="<%=rSJB_TYPE_NAME%>">
                                                        <input type="hidden" name="unittype_qtyco_idx" value="<%=runittype_qtyco_idx%>">
                                                        <input type="hidden" name="unittype_bfwidx" value="<%=runittype_bfwidx%>">
                                                        <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                                                        <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
                                                        <input type="hidden" name="SJB_barlist" value="<%=rSJB_barlist%>">
                                                        <a name="<%=ruptidx%>">
                                                        <input class="input-field" type="text"  width="50" name="price" id="price" value="<%=price%>" onkeypress="handleKeyPress(event, 'price', 'price')"/>
                                                        <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                                                    </form>
                                                    <% else %>   
                                                        <%= rSJB_TYPE_NAME %>
                                                              
                                                        <input class="input-field" type="text" width="50" value="<%= price %>" readonly
                                                        onclick="location.replace('unittypeA.asp?unittype_qtyco_idx=<%=unittype_qtyco_idx%>&unittype_bfwidx=<%=unittype_bfwidx%>&sjbtidx=<%=sjbtidx%>&SJB_barlist=<%=rSJB_barlist%>&SJB_IDX=<%=rSJB_IDX%>&SJB_TYPE_NAME=<%=rSJB_TYPE_NAME%>&uptidx=<%=ruptidx%>#<%=ruptidx%>');"
                                                        />
                                                    <% end if %>
                                                    </td>
                                                <%
                                                        price="0"
                                                        uptidx=""
                                                        Rs2.MoveNext
                                                    Loop
                                                End If
                                                Rs2.Close
                                                %>
                                        </tr>
                                    <%    
                                        i = i + 1
                                    Rs1.MoveNext
                                    Loop
                                    End If
                                    Rs1.Close
                                    %>


                                    
                        
                            </tbody>
                        </table>
<button type="submit" id="hiddenSubmit" style="display: none;"></button>
</form>        
                                    </div>

                    </div>




<!-- 표 형식 끝--> 
    </div>    

    <!--화면 끝-->
        
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
