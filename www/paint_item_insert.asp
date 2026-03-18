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


gotopage = Request("gotopage")
rSearchWord    = Request("SearchWord")

rpbidx = Request("pbidx")
rpname_brand = Request("pname_brand")
mode = Request("mode")
part = Request("part")
'Response.Write "rpidx : " & rpidx & "<br>"
Response.Write "rpbidx : " & rpbidx & "<br>"
'Response.Write "rpname_brand : " & rpname_brand & "<br>"
'Response.Write "rSJB_barlist : " & rSJB_barlist & "<br>"
'Response.end

if rpbidx="0" then 

    ' 🔹 새로운 pbidx 번호 구하기
    SQL = "SELECT ISNULL(MAX(pbidx), 0) + 1 FROM tk_paint_brand"
    Rs.Open SQL, Dbcon
    If Not (Rs.EOF Or Rs.BOF) Then
        new_pbidx = Rs(0)
    End If
    Rs.Close

    ' 🔹 INSERT 실행
    sql = "INSERT INTO tk_paint_brand (pbidx, pidx, pname_brand) "
    sql = sql & "VALUES ( '" & new_pbidx & "' , 0 , '" & rpname_brand & "' ) "
    Response.write sql & "<br>"
    'Response.End
    Dbcon.Execute(sql)

    response.write "<script>location.replace('paint_item_insert.asp');</script>"

end if     

if part="delete" then 

    sql = "DELETE FROM tk_paint_brand WHERE pbidx = " & rpbidx & " "

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)

    response.write "<script>location.replace('paint_item_insert.asp');</script>"      

end if 

if mode = "insert" then 
        
            sql = "UPDATE tk_paint_brand SET "
            sql = sql & " pname_brand = '" & rpname_brand & "' "
            sql = sql & " WHERE pbidx = " & rpbidx & " "
            Response.Write sql & "<br>"
            'Response.End
            Dbcon.Execute (SQL)
            response.write "<script>location.replace('paint_item_insert.asp');</script>"
    
end if


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
                location.href="paint_item_insert.asp?part=delete&pbidx="+sTR;
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
                            <h3>제조사 추가</h3>
                        </div>
                        <div class="col text-end">
                            <button type="button"
                                class="btn btn-outline-danger"
                                style="writing-mode: horizontal-tb; letter-spa
                                g: normal; white-space: nowrap;"
                                onclick="location.replace('paint_itemin.asp');">돌아가기
                            </button>
                            <button type="button" class="btn btn-outline-danger" Onclick="location.replace('paint_item_insert.asp?pbidx=0');">등록</button>
                        </div>
                    </div>
                    <!-- 제목 나오는 부분 끝-->
                        
                    <!-- 표 형식 시작--> 
                    <div class="input-group mb-3">
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th >번호</th>
                                    <th  >제조사번호</th>
                                    <th   >제조사</th>
                                </tr>
                            </thead>
                            <tbody>
                                <form id="dataForm" action="paint_item_insert.asp" method="POST">   
                                    <input type="hidden" name="mode" value="insert">

                                    <% if rpbidx="0" then %>
                                        <tr>
                                            <%
                                            ' 🔹 마지막 pbidx 구하기
                                            sql = "SELECT ISNULL(MAX(pbidx), 0) + 1 FROM tk_paint_brand"
                                            Rs.open sql, Dbcon, 1, 1
                                            If Not (Rs.EOF Or Rs.BOF) Then
                                                pbidx = Rs(0)
                                            End If
                                            Rs.Close
                                            %>
                                            <td ><input class="input-field" type="text"  placeholder="품목번호" aria-label="품목번호" name="pbidx" id="pbidx" value="<%=pbidx%>" onkeypress="handleKeyPress(event, 'pbidx', 'pbidx')"/></td> 
                                            <td ><input class="input-field" type="text"  placeholder="제조사" name="pname_brand" id="pname_brand" value="<%=rpname_brand%>"  onkeypress="handleKeyPress(event, 'pname_brand', 'pname_brand')"/></td>
                                        </tr>
                                    <% end if %>
                                            <%
                                            sql = "SELECT pbidx, pidx, pname_brand "
                                            sql = sql & " FROM tk_paint_brand "
                                            sql = sql & " ORDER BY pbidx DESC "
                                            Rs.open Sql,Dbcon,1,1,1
                                            if not (Rs.EOF or Rs.BOF ) then
                                            Do while not Rs.EOF
                                                pbidx       = Rs(0)
                                                pidx   = Rs(1)
                                                pname_brand = Rs(2)
                                                
                                                i=i+1
                                            %>              
                                            <% if int(pbidx)=int(rpbidx) then %>
                                        <tr>
                                            <td >
                                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="del('<%=pbidx%>');">삭제</button>
                                            </td>    
                                            <td >
                                                <input class="input-field" type="text"  name="pbidx" id="pbidx" 
                                                    value="<%=pbidx%>" 
                                                    onkeypress="handleKeyPress(event, 'pbidx', 'pbidx')"/>
                                            </td>
                                            <td ><input class="input-field" type="text"  name="pname_brand" id="pname_brand" value="<%=pname_brand%>"  onkeypress="handleKeyPress(event, 'pname_brand', 'pname_brand')"/></td>
                                        </tr>
                                            <% else %>
                                        <tr> 
                                            <td ><%=i%></td> 
                                            <td ><input class="input-field" type="text"   value="<%=pbidx%>" onclick="location.replace('paint_item_insert.asp?pbidx=<%=pbidx%>');"/></td> 
                                            <td ><input class="input-field" type="text"  value="<%=pname_brand%>" onclick="location.replace('paint_item_insert.asp?pbidx=<%=pbidx%>');"/></td>
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
