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
subgubun="one2"
projectname="샘플"
%>
<%

SearchWord=Request("SearchWord")
gubun=Request("gubun")

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"
%>
<%

part = Request("part")

If part = "edit" Then
    edit = part
ElseIf part = "balju" Then
    balju = part
End If


addbar = Request("addbar")
showLobbyBox = False

If addbar = "1" Then 
    showLobbyBox = True 
End If



rfidx=request("rfidx")
'Response.Write "<br><br><br><br><br><br><br><br><br><br><br><br>"
'Response.Write "rfidx : " & rfidx & "<br>"
'response.end

sql = " SELECT  GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, fmidx, fwdate, fmeidx, fewdate ,greem_o_type, greem_habar_type, greem_lb_type, GREEM_MBAR_TYPE "
sql = sql & " FROM tk_frame "
sql = sql & " WHERE fidx='"&rfidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
greem_f_a         = rs(0)
greem_basic_type  = rs(1)
greem_fix_type    = rs(2)
fmidx             = rs(3)
fwdate            = rs(4)
fmeidx            = rs(5)
fewdate           = rs(6)
greem_o_type      = rs(7)
greem_habar_type  = rs(8)
greem_lb_type     = rs(9)
greem_mbar_type   = rs(10)
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

End If
Rs.Close
%> 

<%
'rsfidx=request("rsfidx")
rfsidx=request("rfsidx")

SQL=" select fname from tk_frame where fidx='"&rfidx&"' "
Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    afname=Rs(0)
  End If
Rs.Close
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>프레임 그리기</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .resize-handle {
        fill: red;
        cursor: pointer;
        r: 5;
        }
        .svg-container {
        border: 2px solid #000; /* 캔버스 테두리 */
        margin-top: 20px;
        width: 1000px;
        height: 600px;
        }
        .dimension-label {
        font-size: 12px;
        fill: black;
        }
        .canvas-container {
        flex: 1;
        display: flex;
        justify-content: center;
        align-items: center;
        }
        .controls-container {
        max-width: 300px;
        padding: 20px;
        border-left: 1px solid #ccc;
        }
        .btn-group button {
        margin-bottom: 10px;
        }
        .btn-left {
        background-color: lightblue;
        }
        .btn-up {
        background-color: lightgreen;
        }
        .btn-right {
        background-color: lightcoral;
        }
        .btn-down {
        background-color: lightyellow;
        }
    </style>
    <style>
    .button-container {
        position: relative;
        display: inline-block;
    }

    .label-text {
        position: static;
        top: 0px;
        left: 0%;
        transform: translateX(0%);
        /* background-color: rgba(0, 0, 0, 0.7); */
        color: #ff; /* 더 선명한 흰색 */
        padding: 0px 0px;
        border-radius: 5px;
        font-weight: 900; /* bold보다 더 두꺼움 */
        font-size: 15px;
        white-space: nowrap;
        /* text-shadow: 1px 1px 2px rgba(0,0,0,0.5); */ /* 글자 외곽 또렷하게 */
    }
    .font-strong-large {
        font-weight: 700;
        font-size: 15px;
        color: #222; /* 글씨 색도 더 진하게 */
        text-align: right; /* 숫자 정렬에 좋음 */
    }
    </style>
    <script>
    document.addEventListener("DOMContentLoaded", function () {
        // 공통 키프레스 핸들러
        function handleKeyPress(event, elementId1, elementId2) {
        if (event.key === "Enter") {
            event.preventDefault();
            console.log(`Enter 눌림: ${elementId1}, ${elementId2}`);
            document.getElementById("hiddenSubmit").click();
        }
        }

        // 셀렉트 변경 시
        function handleSelectChange(event, elementId1, elementId2) {
        console.log(`선택 변경됨: ${elementId1}, ${elementId2}`);
        document.getElementById("hiddenSubmit").click();
        }

        // 간단 셀렉트 처리
        function handleChange(selectElement) {
        console.log("선택값:", selectElement.value);
        document.getElementById("hiddenSubmit").click();
        }

        // 전역 폼 Enter 감지
        const form = document.getElementById("dataForm");
        if (form) {
        form.addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
            event.preventDefault();
            console.log("폼 전체에서 Enter 감지");
            document.getElementById("hiddenSubmit").click();
            }
        });
        }
        // 전역으로 함수 노출
        window.handleKeyPress = handleKeyPress;
        window.handleSelectChange = handleSelectChange;
        window.handleChange = handleChange;
    });
    </script>
    <script>
    function del(fsidx) {
        if (confirm("이 항목을 삭제하시겠습니까?")) {
        location.href = "TNG1_FRAME_A_BAJUdb.asp?part=fmdel&rfidx=<%=rfidx%>&rfsidx=" + fsidx;
        }
    }
    </script> 


    <script src="//code.jquery.com/jquery-1.12.0.min.js"></script>

    <script>
            function validateForm() {
                {
                    document.frmMain1.submit();
                }
            }
        </script>
<script>
        const canvas = document.getElementById('canvas');
        const rectangle = document.getElementById('rectangle');
        const resizeHandle = document.getElementById('resize-handle');
        const widthLabel = document.getElementById('width-label');
        const heightLabel = document.getElementById('height-label');
        const xInput = document.getElementById('x-input');
        const yInput = document.getElementById('y-input');
        const widthInput = document.getElementById('width-input');
        const heightInput = document.getElementById('height-input');

        let isDrawing = false;
        let isResizing = false;
        let isMoving = false;
        let startX, startY, startMouseX, startMouseY;

        // 사각형 그리기
        canvas.addEventListener('mousedown', (e) => {
        if (!isResizing && !isMoving) {
            startX = e.offsetX;
            startY = e.offsetY;
            isDrawing = true;
            rectangle.setAttribute('x', startX);
            rectangle.setAttribute('y', startY);
            rectangle.setAttribute('width', 0);
            rectangle.setAttribute('height', 0);
            resizeHandle.setAttribute('cx', startX);
            resizeHandle.setAttribute('cy', startY);
        }
        });

        // 사각형 크기 조정
        canvas.addEventListener('mousemove', (e) => {
        if (isDrawing || isResizing) {
            const width = e.offsetX - startX;
            const height = e.offsetY - startY;
            rectangle.setAttribute('width', width);
            rectangle.setAttribute('height', height);
            resizeHandle.setAttribute('cx', startX + width);
            resizeHandle.setAttribute('cy', startY + height);
            widthLabel.textContent = `${Math.abs(width)}mm`;
            heightLabel.textContent = `${Math.abs(height)}mm`;
            widthLabel.setAttribute('x', startX + width / 2);
            widthLabel.setAttribute('y', startY - 5);
            heightLabel.setAttribute('x', startX + width + 5);
            heightLabel.setAttribute('y', startY + height / 2);
        } else if (isMoving) {
            const dx = e.offsetX - startMouseX;
            const dy = e.offsetY - startMouseY;
            const x = startX + dx;
            const y = startY + dy;
            rectangle.setAttribute('x', x);
            rectangle.setAttribute('y', y);
            resizeHandle.setAttribute('cx', x + parseInt(rectangle.getAttribute('width')));
            resizeHandle.setAttribute('cy', y + parseInt(rectangle.getAttribute('height')));
            widthLabel.setAttribute('x', x + parseInt(rectangle.getAttribute('width')) / 2);
            widthLabel.setAttribute('y', y - 5);
            heightLabel.setAttribute('x', x + parseInt(rectangle.getAttribute('width')) + 5);
            heightLabel.setAttribute('y', y + parseInt(rectangle.getAttribute('height')) / 2);
        }
        updateInputs();
        });

        // 마우스 놓기
        canvas.addEventListener('mouseup', () => {
        isDrawing = false;
        isResizing = false;
        isMoving = false;
        });

        // 리사이즈 핸들 클릭 시 리사이징 시작
        resizeHandle.addEventListener('mousedown', (e) => {
        e.stopPropagation(); // 부모 이벤트로 전파되지 않도록
        startX = parseInt(rectangle.getAttribute('x'));
        startY = parseInt(rectangle.getAttribute('y'));
        startMouseX = e.offsetX;
        startMouseY = e.offsetY;
        isResizing = true;
        });

        // 사각형 클릭 시 이동 시작
        rectangle.addEventListener('mousedown', (e) => {
        startX = parseInt(rectangle.getAttribute('x'));
        startY = parseInt(rectangle.getAttribute('y'));
        startMouseX = e.offsetX;
        startMouseY = e.offsetY;
        isMoving = true;
        });

        // 이동 버튼 기능
        //document.getElementById('move-left').addEventListener('click', () => moveRectangle(-10, 0));
        //document.getElementById('move-up').addEventListener('click', () => moveRectangle(0, -10));
        //document.getElementById('move-right').addEventListener('click', () => moveRectangle(10, 0));
        //document.getElementById('move-down').addEventListener('click', () => moveRectangle(0, 10));

        // 사각형 위치 이동
        function moveRectangle(dx, dy) {
        const x = parseInt(rectangle.getAttribute('x')) + dx;
        const y = parseInt(rectangle.getAttribute('y')) + dy;
        rectangle.setAttribute('x', x);
        rectangle.setAttribute('y', y);
        resizeHandle.setAttribute('cx', x + parseInt(rectangle.getAttribute('width')));
        resizeHandle.setAttribute('cy', y + parseInt(rectangle.getAttribute('height')));
        widthLabel.setAttribute('x', x + parseInt(rectangle.getAttribute('width')) / 2);
        widthLabel.setAttribute('y', y - 5);
        heightLabel.setAttribute('x', x + parseInt(rectangle.getAttribute('width')) + 5);
        heightLabel.setAttribute('y', y + parseInt(rectangle.getAttribute('height')) / 2);
        updateInputs();
        }

        // 입력 값 업데이트
        function updateInputs() {
        xInput.value = rectangle.getAttribute('x');
        yInput.value = rectangle.getAttribute('y');
        widthInput.value = rectangle.getAttribute('width');
        heightInput.value = rectangle.getAttribute('height');
        }

        // 입력값 변경 시 사각형 반영
        function onInputChange() {
        const x = parseInt(xInput.value);
        const y = parseInt(yInput.value);
        const width = parseInt(widthInput.value);
        const height = parseInt(heightInput.value);

        rectangle.setAttribute('x', x);
        rectangle.setAttribute('y', y);
        rectangle.setAttribute('width', width);
        rectangle.setAttribute('height', height);
        resizeHandle.setAttribute('cx', x + width);
        resizeHandle.setAttribute('cy', y + height);
        widthLabel.setAttribute('x', x + width / 2);
        widthLabel.setAttribute('y', y - 5);
        heightLabel.setAttribute('x', x + width + 5);
        heightLabel.setAttribute('y', y + height / 2);
        }

        // 입력값 변화 감지
        xInput.addEventListener('input', onInputChange);
        yInput.addEventListener('input', onInputChange);
        widthInput.addEventListener('input', onInputChange);
        heightInput.addEventListener('input', onInputChange);
    </script> 
    </head>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <h5><%=greem_f_a_name%>,<%=greem_habar_type_name%>,<%=greem_lb_type_name%>,<%=GREEM_MBAR_TYPE_name%>,<%=greem_o_type_name%>,<%=greem_fix_type_name%>,<%=greem_basic_type_name%></h5>
        </div>
        <div style="margin-bottom: 10px;">
            <button onclick="location.reload();" class="btn btn-danger">새로고침</button>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <!--화면시작-->
            <% if gubun="" then %>
                    <form name="frmMain" action="order.asp" method="post"  >	
                    <% if gubun="insert" then %> 
                    <input type="hidden" name="gubun" value="input">
                    <% elseif gubun="edit" then %>
                    <input type="hidden" name="gubun" value="update">
                    <input type="hidden" name="oidx" value="<%=oidx%>">
                    <input type="hidden" name="ostatus" value="<%=ostatus%>">
                    <% end if %>
                    <input type="hidden" name="cidx" value="<%=cidx%>">
                    <input type="hidden" name="omidx" value="<%=midx%>">
                    <input type="hidden" name="oftype" value="<%=oftype%>">
                    <div class="row">
                        <div class="col-2" style=" border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                            <!-- 제목 나오는 부분 시작-->
                            <div class="input-group mb-3">
                                <h3><%=Year(date())%>.<%=Month(date())%>.<%=Day(date())%>&nbsp;티엔지발주서</h3>
                            </div>
                            <!-- 제목 나오는 부분 끝-->
                            <!-- 내용 시작-->
                            <!-- 입력값 시작 -->
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                <label for="name">검축가로</label>
                                <input type="number" class="form-control" id="oinsw" name="oinsw" placeholder="너비(mm)" value="<%=oinsw%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');oinswf();" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                <label for="nickname">검축높이</label>
                                <input type="number" class="form-control" id="oinsh" name="oinsh" placeholder="높이(mm)" value="<%=oinsh%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');oinshf();" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                <label for="nickname">바닥묻힘</label>
                                <input type="number" class="form-control" id="obitg" name="obitg" placeholder="높이(mm)" value="<%=obitg%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');obitgf();" required>
                                </div>
                            </div>
                            <!-- 입력값 끝 -->
                        </div>  
                        <div class="col-8" style=" border: 2px solid #535353; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                            <!-- SVG 시작 -->
                            <!-- 버튼 영역 -->
                            <div class="mb-3 text-center">
                                <button class="btn btn-primary" type="button" onclick="zoom(1.1)">확대</button>
                                <button class="btn btn-primary" type="button" onclick="zoom(0.9)">축소</button>
                                <button class="btn btn-secondary" type="button" onclick="pan(-50, 0)">← 좌</button>
                                <button class="btn btn-secondary" type="button" onclick="pan(50, 0)">우 →</button>
                                <button class="btn btn-secondary" type="button" onclick="pan(0, -50)">상 ↑</button>
                                <button class="btn btn-secondary" type="button" onclick="pan(0, 50)">↓ 하</button>
                            </div>

                            <!-- 반응형 SVG -->
                            <div style="width: 100%; overflow: auto; border: 0px solid #cacaca;">
                                <svg id="frameCanvas" viewBox="0 0 1500 800" preserveAspectRatio="xMidYMid meet" width="100%" height="auto">
                                    <g id="mainGroup">
                                        <!-- 예시 도형 -->
                                        <rect x="500" y="250" width="400" height="50" fill="#cacaca" /> <!--박스 -->
                                        <text x="700" y="280" font-size="10" text-anchor="middle" fill="black">박스</text>
                                        <rect x="690" y="300" width="20" height="200" fill="#cacaca" /> <!--중간소대 -->
                                        <text x="700" y="400" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 700,400)">중간소대</text>
                                        <rect x="480" y="200" width="20" height="300" fill="#cacaca" /> <!--왼쪽다대 -->
                                        <text x="490" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 490,360)">왼쪽다대</text>
                                        <rect x="900" y="200" width="20" height="300" fill="#cacaca" /> <!--오른쪽다대 -->
                                        <text x="910" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(+90 910,360)">오른쪽다대</text>
                                        <rect x="710" y="480" width="190" height="20" fill="#cacaca" /> <!--하바 -->
                                        <text x="805" y="495" font-size="10" text-anchor="middle" fill="black">하바</text>
                                        <rect x="500" y="200" width="400" height="20" fill="#cacaca" /> <!--가로남마 -->
                                        <text x="700" y="215" font-size="10" text-anchor="middle" fill="black">가로남마</text>
                                        <rect x="690" y="220" width="20" height="30" fill="#cacaca" /> <!--상부 중간소대 -->
                                        <text x="700" y="240" font-size="10" text-anchor="middle" fill="black">상부 중간소대</text>

                                            <% If addbar = "1" Then %> <!--로비폰박스 -->
                                            <rect x="710" y="350" width="190" height="50" fill="#de0a4f" />
                                            <text x="805" y="380" font-size="14" text-anchor="middle" fill="black">로비폰박스</text>
                                            <% End If %>

                                            <% If addbar = "2" Then %> <!--세로바 왼쪽 -->
                                            <rect x="410" y="200" width="20" height="300" fill="#de0a4f" />
                                            <text x="420" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 420,360)">세로다대바</text>

                                            <rect x="430" y="200" width="50" height="20" fill="#de0a4f" />
                                            <text x="455" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>

                                            <rect x="430" y="250" width="50" height="20" fill="#de0a4f" />
                                            <text x="455" y="265" font-size="10" text-anchor="middle" fill="black">중간바</text>

                                            <rect x="430" y="480" width="50" height="20" fill="#de0a4f" />
                                            <text x="455" y="495" font-size="10" text-anchor="middle" fill="black">하바</text>
                                            <% End If %>

                                            <% If addbar = "3" Then %>
                                            <rect x="970" y="200" width="20" height="300" fill="#de0a4f" />
                                            <text x="980" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 980,360)">세로다대바</text>

                                            <rect x="920" y="200" width="50" height="20" fill="#de0a4f" />
                                            <text x="945" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>

                                            <rect x="920" y="250" width="50" height="20" fill="#de0a4f" />
                                            <text x="945" y="265" font-size="10" text-anchor="middle" fill="black">중간바</text>

                                            <rect x="920" y="480" width="50" height="20" fill="#de0a4f" />
                                            <text x="945" y="495" font-size="10" text-anchor="middle" fill="black">하바</text>
                                            <% End If %>

                                            <% If addbar = "4" Then %>
                                            
                                            <rect x="710" y="480" width="190" height="20" fill="#ffffff" /> <!--하바 -->
                                            <rect x="500" y="480" width="190" height="20" fill="#cacaca" /> <!--하바 -->
                                            <text x="600" y="495" font-size="10" text-anchor="middle" fill="black">하바</text>
                                           
                                            <% End If %>

                                            <% If addbar = "5" Then %>
                                            
                                            <rect x="410" y="200" width="20" height="300" fill="#de0a4f" />  
                                            <text x="420" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 420,360)">세로다대바</text>
                                            <rect x="430" y="200" width="50" height="20" fill="#de0a4f" />
                                            <text x="455" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>
                                            <rect x="430" y="250" width="50" height="50" fill="#de0a4f" />
                                            <text x="455" y="275" font-size="10" text-anchor="middle" fill="black">박스라인</text>
                                            <rect x="430" y="480" width="50" height="20" fill="#de0a4f" />
                                            <text x="455" y="495" font-size="10" text-anchor="middle" fill="black">하바</text>


                                            <rect x="970" y="200" width="20" height="300" fill="#de0a4f" />
                                            <text x="980" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 980,360)">세로다대바</text>

                                            <rect x="920" y="200" width="50" height="20" fill="#de0a4f" />
                                            <text x="945" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>

                                            <rect x="920" y="250" width="50" height="50" fill="#de0a4f" />
                                            <text x="945" y="275" font-size="10" text-anchor="middle" fill="black">박스라인</text>

                                            <rect x="920" y="480" width="50" height="20" fill="#de0a4f" />
                                            <text x="945" y="495" font-size="10" text-anchor="middle" fill="black">하바</text>

                                            <% End If %>

                                            <% If addbar = "6" Then %>
                                            
                                            <rect x="310" y="200" width="20" height="300" fill="#de0a4f" />
                                            <text x="320" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 320,360)">세로다대바</text>

                                            <rect x="330" y="200" width="150" height="20" fill="#de0a4f" />
                                            <text x="405" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>

                                            <rect x="330" y="250" width="150" height="20" fill="#de0a4f" />
                                            <text x="405" y="265" font-size="10" text-anchor="middle" fill="black">롯트바</text>

                                            <!-- 손잡이 모양 라인 -->
                                            <line x1="450" y1="325" x2="450" y2="425" stroke="black" stroke-width="2" />
                                            <line x1="450" y1="425" x2="400" y2="425" stroke="black" stroke-width="2" />
                                            <text x="380" y="285" font-size="14" text-anchor="middle" fill="black">좌힌지(센터65)</text>
                                            <circle cx="360" cy="260" r="12" stroke="black" stroke-width="2" fill="none" />


                                            <rect x="1070" y="200" width="20" height="300" fill="#de0a4f" />
                                            <text x="1080" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 1080,360)">세로다대바</text>

                                            <rect x="920" y="200" width="150" height="20" fill="#de0a4f" />
                                            <text x="995" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>

                                            <rect x="920" y="250" width="150" height="20" fill="#de0a4f" />
                                            <text x="995" y="265" font-size="10" text-anchor="middle" fill="black">중간바</text>

                                            <rect x="920" y="480" width="150" height="20" fill="#de0a4f" />
                                            <text x="995" y="495" font-size="10" text-anchor="middle" fill="black">하바</text>

                                            <% End If %>

                                            <% If addbar = "7" Then %>
                                            
                                            <rect x="310" y="200" width="20" height="300" fill="#de0a4f" />
                                            <text x="320" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 320,360)">세로다대바</text>

                                            <rect x="330" y="200" width="150" height="20" fill="#de0a4f" />
                                            <text x="405" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>

                                            <rect x="330" y="250" width="150" height="20" fill="#de0a4f" />
                                            <text x="405" y="265" font-size="10" text-anchor="middle" fill="black">롯트바</text>

                                            <!-- 손잡이 모양 라인 -->
                                            <line x1="350" y1="325" x2="350" y2="425" stroke="black" stroke-width="2" />
                                            <line x1="350" y1="425" x2="400" y2="425" stroke="black" stroke-width="2" />
                                            <text x="450" y="285" font-size="14" text-anchor="middle" fill="black">우힌지(센터65)</text>
                                            <circle cx="460" cy="260" r="12" stroke="black" stroke-width="2" fill="none" />

                                            <rect x="1070" y="200" width="20" height="300" fill="#de0a4f" />
                                            <text x="1080" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 1080,360)">세로다대바</text>

                                            <rect x="920" y="200" width="150" height="20" fill="#de0a4f" />
                                            <text x="995" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>

                                            <rect x="920" y="250" width="150" height="20" fill="#de0a4f" />
                                            <text x="995" y="265" font-size="10" text-anchor="middle" fill="black">중간바</text>

                                            <rect x="920" y="480" width="150" height="20" fill="#de0a4f" />
                                            <text x="995" y="495" font-size="10" text-anchor="middle" fill="black">하바</text>
                                            
                                            <% End If %>

                                            <% If addbar = "8" Then %>
                                            
                                            <rect x="210" y="200" width="20" height="300" fill="#de0a4f" />
                                            <text x="220" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 220,360)">세로다대바</text>

                                            <rect x="230" y="200" width="250" height="20" fill="#de0a4f" />
                                            <text x="355" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>

                                            <rect x="230" y="250" width="250" height="20" fill="#de0a4f" />
                                            <text x="355" y="265" font-size="10" text-anchor="middle" fill="black">롯트바</text>


                                            <!-- 손잡이 모양 라인 -->
                                            <line x1="340" y1="325" x2="340" y2="425" stroke="black" stroke-width="2" />
                                            <line x1="340" y1="425" x2="300" y2="425" stroke="black" stroke-width="2" />
                                            <text x="280" y="285" font-size="14" text-anchor="middle" fill="black">좌힌지(센터65)</text>
                                            <circle cx="260" cy="260" r="12" stroke="black" stroke-width="2" fill="none" />

                                            <line x1="370" y1="325" x2="370" y2="425" stroke="black" stroke-width="2" />
                                            <line x1="370" y1="425" x2="415" y2="425" stroke="black" stroke-width="2" />
                                            <text x="450" y="285" font-size="14" text-anchor="middle" fill="black">우힌지(센터65)</text>
                                            <circle cx="460" cy="260" r="12" stroke="black" stroke-width="2" fill="none" />

                                            <rect x="1070" y="200" width="20" height="300" fill="#de0a4f" />
                                            <text x="1080" y="360" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 1080,360)">세로다대바</text>

                                            <rect x="920" y="200" width="150" height="20" fill="#de0a4f" />
                                            <text x="995" y="215" font-size="10" text-anchor="middle" fill="black">가로바</text>

                                            <rect x="920" y="250" width="150" height="20" fill="#de0a4f" />
                                            <text x="995" y="265" font-size="10" text-anchor="middle" fill="black">중간바</text>

                                            <rect x="920" y="480" width="150" height="20" fill="#de0a4f" />
                                            <text x="995" y="495" font-size="10" text-anchor="middle" fill="black">하바</text>
                                            <% End If %>

                                            <% If addbar = "9" Then %>
                                            <rect x="790" y="300" width="20" height="200" fill="#de0a4f" /> <!--중간소대 -->
                                            <text x="800" y="400" font-size="10" text-anchor="middle" fill="black" transform="rotate(-90 800,400)">중간소대</text>

                                            <% End If %>

                                            <% If addbar = "10" Then %>
                                            <rect x="790" y="300" width="20" height="180" fill="#de0a4f" /> <!--중간소대 -->
                                            <% End If %>
                                        <line x1="80" y1="5" x2="80" y2="28" />
                                        <line x1="80" y1="15" x2="230" y2="15" stroke-dasharray="5" />
                                        <text x="700" y="100" font-size="14" fill="black" text-anchor="middle">가로외경 : <tspan id="result">0</tspan></text>
                                        <text x="360" y="20"  fill="#000000" font-size="14" text-anchor="left"  id="result" >0</text>
                                        <line x1="570" y1="5" x2="570" y2="28" />
                                        <line x1="400" y1="15" x2="570" y2="15" stroke-dasharray="5" />

                                        <line x1="90" y1="55" x2="230" y2="55" stroke-dasharray="5" />
                                        <text x="700" y="150" font-size="14" fill="black" text-anchor="middle">가로내경 : <tspan id="result1">0</tspan></text>  
                                        <text x="300" y="60"  fill="#000000" font-size="14" text-anchor="left"  id="result1" >0</text>
                                        <line x1="400" y1="55" x2="550" y2="55" stroke-dasharray="5" />

                                        <text x="30" y="150" fill="#000000" font-size="14" text-anchor="middle">외경높이</text> 
                                        <text x="30" y="170"  fill="#000000" font-size="14" text-anchor="middle"  id="kkk" >0</text>

                                        <text x="30" y="250" fill="#000000" font-size="14" text-anchor="middle">묻힘</text> 
                                        <text x="30" y="270"  fill="#000000" font-size="14" text-anchor="middle"  id="ggg" >0</text>

                                        <text x="500" y="170" font-size="14" fill="black" text-anchor="middle" id="kkk">0</text>
                                        <text x="30" y="270" font-size="14" fill="black" text-anchor="middle" id="ggg">0</text>
                                    </g>
                                </svg>
                            </div>
                            <script>
                                let scale = 1;
                                let offsetX = 0;
                                let offsetY = 0;

                                function updateTransform() {
                                    const g = document.getElementById("mainGroup");
                                    g.setAttribute("transform", `translate(${offsetX}, ${offsetY}) scale(${scale})`);
                                }

                                function zoom(factor) {
                                    scale *= factor;
                                    updateTransform();
                                }

                                function pan(dx, dy) {
                                    offsetX += dx;
                                    offsetY += dy;
                                    updateTransform();
                                }
                            </script>
                        </div> 
                            <script>
                                $(document).ready(function() {
                                    $('input').on('input', function() {
                                        let oinsw = parseFloat($('#oinsw').val()) || 0;
                                        let oinsh = parseFloat($('#oinsh').val()) || 0;
                                        let obitg = parseFloat($('#obitg').val()) || 0;
                                        let sum = oinsw + oinsh;
                                        let hei = oinsw - 20;
                                        let kkk = oinsh - obitg;
                                        let ggg  = obitg;
                                        $('#result').text(oinsw+'mm');
                                        $('#result1').text(hei+'mm');
                                        $('#kkk').text(kkk + 'mm');
                                        $('#ggg').text(ggg + 'mm');
                                    });
                                });
                            </script>
                        </form>
                            <!-- 내용 끝-->
                        <% elseif gubun="input" then  %>

                        <% end if %>
                        <!--화면 끝-->
                        <div class="col-2" style=" border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                            <form id="frmMain1" name="frmMain1" method="post" action="TNG1_FRAME_A_BAJU.asp">
                            <input type="hidden" name="rfidx" value="<%=rfidx%>" />
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="1">1 로비폰박스 추가</button>
                                <button class="btn btn-primary  w-100" type="button" data-bs-toggle="collapse" data-bs-target="#corpCollapse">
                                    로비폰 입력구간 보기/숨기기
                                </button>
                                <div class="collapse mt-2" id="corpCollapse">
                                    <div class="row">
                                        <div class="col-6">
                                            <label for="loby_w" class="label-text">로비폰 가로치수</label>
                                            <input type="text" class="form-control font-strong-large" id="loby_w" name="loby_w" value="T_loby_w">
                                        </div>
                                        <div class="col-6">
                                            <label for="loby_h" class="label-text">로비폰 세로치수</label>
                                            <input type="text" class="form-control font-strong-large" id="loby_h" name="loby_h" value="T_loby_h">
                                        </div>
                                        <div class="col-6">
                                            <label for="loby_d" class="label-text">로비폰 깊이치수</label>
                                            <input type="text" class="form-control font-strong-large" id="loby_d" name="loby_d" value="T_loby_d">
                                        </div>
                                    </div>
                                </div>
                                <!-- 추가 버튼들 -->
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="2">2 세로바 추가(왼쪽)</button>
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="3">3 세로바 추가(오른쪽)</button>
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="4">4 자동문 방향 변경</button>
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="5">5 중간바→박스라인 변경</button>
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="6">6 롯트바 추가(좌도어)</button>
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="7">7 롯트바 추가(우도어)</button>
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="8">8 롯트바 추가(양개도어)</button>
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="9">9 하부분할_중간소대 2개</button>
                                <button type="submit" class="btn btn-dark w-100" name="addbar" value="10">10 하바1개 중간소대 2개</button>
                            </form>
                        </div>
                    </div>
        </div>
    </div>
    <div class="row">
        <div class="col-12" style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">

        </div>
    </div>
</div>




<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
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
