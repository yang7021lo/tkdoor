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
rfkidx=request("fkidx")
rfksidx=request("fksidx")
'response.write rfkidx&"<br>"
'response.write rfksidx&"<br>"


SQL = " SELECT  GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, fmidx, fwdate, fmeidx, fewdate ,greem_o_type, greem_habar_type "
SQL=SQL&" , greem_lb_type, GREEM_MBAR_TYPE, fknickname ,fname"
SQL=SQL&" FROM tk_framek "
SQL=SQL&" WHERE fkidx='"&rfkidx&"' "
'response.write (SQL)&"<br>"
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
fknickname        = rs(11)
afname            = rs(12)
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
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href = "tng1_greemlist3_framedb.asp?part=fmdel&fkidx=<%=rfkidx%>&rfksidx=" + fksidx;
            }
        }
    </script>  
  <script>
  function del(fsidx) {
    if (confirm("이 항목을 삭제하시겠습니까?")) {
      location.href = "tng1_greemlist3_framedb.asp?part=fmdel&fidx=<%=rfkidx%>&rfksidx=" + fksidx;
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
<!--        <h1><%=greem_f_a_name%>,<%=greem_habar_type_name%>,<%=greem_lb_type_name%>,<%=GREEM_MBAR_TYPE_name%>,<%=greem_o_type_name%>,<%=greem_fix_type_name%>,<%=greem_basic_type_name%></h1>-->
        </div>
    </div>
    <div class="row">
        <div class="col-10">
            <div class="canvas-container">
                <div class="svg-container">
                    <svg id="canvas" width="1000" height="1000" class="d-block">
                    <rect id="rectangle" fill="white" stroke="black" stroke-width="1" width="0" height="0"></rect>
                    <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                    <text id="width-label" class="dimension-label"></text>
                    <text id="height-label" class="dimension-label"></text>
                        <%
                        SQL="select fksidx, xi, yi, wi, hi from tk_framekSub Where fkidx='"&rfkidx&"' "
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            i=i+1
                            fksidx=Rs(0)
                            xi=Rs(1)
                            yi=Rs(2)
                            wi=Rs(3)
                            hi=Rs(4)
                        %>
                        <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="white" stroke="black" stroke-width="1" onclick="del('<%=fsidx%>');"/>
                        <text x="<%=xi+5%>" y="<%=yi+20%>" font-family="Arial" font-size="14" fill="#000000"><%=i%></text>
                        <%
                        Rs.movenext
                        Loop
                        End if
                        Rs.close
                        %>          
                    </svg>
                </div>
            </div>
        </div>
<!--
        <div class="col-2">
            <div class="row">
                <form name="lyh" action="tng1_greemlist3_framedb.asp" method="post">
                    <input type="hidden" name="rfidx" value="<%=rfidx%>">
                    <input type="hidden" name="part" value="fminsert">
                        <div class="controls-container ">
                            <h2 class="my-4">부속 추가</h2>
                            <div class="form-group row">
                                <div class="col-sm-8">
                                    <input type="number" class="form-control" id="x-input" name="x-input" placeholder="X">
                                    <input type="number" class="form-control" id="y-input" name="y-input" placeholder="Y">
                                    <input type="number" class="form-control" id="width-input" name="width-input" placeholder="W">
                                    <input type="number" class="form-control" id="height-input" name="height-input" placeholder="H">
                                </div>
                            </div>
                           
                            <% if rfkidx<>"" then %>
                            <div class="btn-group" role="group">
                            <button class="btn btn-primary" id="move-down" onclick="submit();">추가</button>
                            </div>
                            <% end if %>
                        </div>
                </form> 
            </div>
        </div>      
-->            
    <div class="row">
        <div class="col-12">
            <div class="btn-group" role="group">

            </div>
        </div>
    </div>
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
