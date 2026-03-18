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
rfidx=request("rfidx")

sql = " SELECT A.GREEM_F_A, A.GREEM_BASIC_TYPE, A.GREEM_FIX_TYPE, A.fmidx, A.fwdate, A.fmeidx, A.fewdate," & vbcrlf
sql = sql & " A.greem_o_type, A.greem_habar_type, A.greem_lb_type, A.GREEM_MBAR_TYPE," & vbcrlf
sql = sql & " B.GREEM_BASIC_TYPEname, C.GREEM_FIX_TYPEname, D.greem_o_typename" & vbcrlf
sql = sql & " FROM tk_frame A" & vbcrlf
sql = sql & " LEFT JOIN tk_frametype B ON A.GREEM_BASIC_TYPE = B.GREEM_BASIC_TYPE" & vbcrlf
sql = sql & " LEFT JOIN tk_frametype C ON A.GREEM_FIX_TYPE = C.GREEM_FIX_TYPE" & vbcrlf
sql = sql & " LEFT JOIN tk_frametype D ON A.greem_o_type = D.greem_o_type" & vbcrlf
sql = sql & " WHERE A.fidx = '" & rfidx & "'"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
    greem_f_a         = Rs(0)
    greem_basic_type  = Rs(1)
    greem_fix_type    = Rs(2)
    fmidx             = Rs(3)
    fwdate            = Rs(4)
    fmeidx            = Rs(5)
    fewdate           = Rs(6)
    greem_o_type      = Rs(7)
    greem_habar_type  = Rs(8)
    greem_lb_type     = Rs(9)
    greem_mbar_type   = Rs(10)
    
    GREEM_BASIC_TYPEname = Rs(11)
    GREEM_FIX_TYPEname   = Rs(12)
    greem_o_typename     = Rs(13)
' ▼ greem_f_a 변환
Select Case greem_f_a
    Case "1"
        greem_f_a_name = "수동"
    Case "2"
        greem_f_a_name = "자동"
    Case Else
        greem_f_a_name = "기타"
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
                location.href = "TNG1_FRAMEdb.asp?part=fmdel&rfidx=<%=rfidx%>&rfsidx=" + fsidx;
            }
        }
    </script>  
  <script>
  function del(fsidx) {
    if (confirm("이 항목을 삭제하시겠습니까?")) {
      location.href = "TNG1_FRAMEdb.asp?part=fmdel&rfidx=<%=rfidx%>&rfsidx=" + fsidx;
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
        <h1><%=greem_f_a_name%> / <%=greem_fix_typename%> / <%=GREEM_BASIC_TYPEname%>/ <%=greem_o_typename%> </h1>
        </div>
    </div>
    <div class="row">
        <div class="col-10">
            <div class="canvas-container">
                <div class="svg-container">
                    <svg id="canvas" width="1000" height="600" class="d-block">
                    <rect id="rectangle" fill="white" stroke="black" stroke-width="1" width="0" height="0"></rect>
                    <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                    <text id="width-label" class="dimension-label"></text>
                    <text id="height-label" class="dimension-label"></text>
                        <%
                        SQL = "SELECT a.fsidx, a.xi, a.yi, a.wi, a.hi"
                        SQL = SQL & " , b.glassselect,a.WHICHI_AUTO,a.WHICHI_FIX, c.glassselect,a.sunstatus "     
                        SQL = SQL & " FROM tk_frameSub a "
                        SQL = SQL & " LEFT OUTER JOIN tng_whichitype b ON a.WHICHI_AUTO = b.WHICHI_AUTO  "
                        SQL = SQL & " LEFT OUTER JOIN tng_whichitype c ON a.WHICHI_FIX = c.WHICHI_FIX  "
                        SQL = SQL & " LEFT OUTER JOIN tk_frame d ON a.fidx = d.fidx  "
                        SQL = SQL & " WHERE a.fidx = '" & rfidx & "'"
                        'sql = sql & " and a.sunstatus=2 "
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            i = i + 1
                            fsidx        = Rs(0)
                            xi           = Rs(1)
                            yi           = Rs(2)
                            wi           = Rs(3)
                            hi           = Rs(4)
                            glassselect_auto       = Rs(5)
                            WHICHI_AUTO = Rs(6)
                            WHICHI_FIX = Rs(7)
                            glassselect_fix       = Rs(8)
                            sunstatus = Rs(9)
                            

                            if WHICHI_AUTO<>"" and WHICHI_FIX=0 then

                                If CInt(glassselect_auto) = 0 Then
                                    fillColor = "#DCDCDC" ' 회색

                                    if sunstatus = 1 then
                                        fillColor = "#800080" ' 회색
                                    elseif sunstatus = 2 then
                                        fillColor = "#f1592c" ' 회색
                                    elseif sunstatus = 3 then
                                        fillColor = "#a2132aaa" ' 회색
                                    elseif sunstatus = 4  then
                                        fillColor = "#013220" ' 회색
                                    elseif sunstatus = 5  then
                                        fillColor = "#DCDCDC" ' 회색
                                    end if
                                ElseIF CInt(glassselect_auto) = 1 Then
                                    fillColor = "#cce6ff" ' 투명 파랑 외도어
                                ElseIF CInt(glassselect_auto) = 2 Then
                                    fillColor = "#ccff" '  파랑 양개도어
                                ElseIF CInt(glassselect_auto) = 3 Then
                                    fillColor = "#FFFFE0" '  유리
                                End If

                            end if
                            if WHICHI_FIX<>"" and WHICHI_AUTO=0 then
                                If CInt(glassselect_fix) = 0 Then
                                    fillColor = "#FFFFFF" ' 기본 흰색
                                ElseIF CInt(glassselect_fix) = 1 Then
                                    fillColor = "#cce6ff" ' 투명 파랑 외도어
                                ElseIF CInt(glassselect_fix) = 2 Then
                                    fillColor = "#ccff" '  파랑 양개도어
                                ElseIF CInt(glassselect_fix) = 3 Then
                                    fillColor = "#FFFFE0" '  유리
                                ElseIF CInt(glassselect_fix) = 4 Then
                                    fillColor = "#FFFFE0" '  상부남마유리 
                                ElseIF CInt(glassselect_fix) = 5 Then
                                    fillColor = "#CCFFCC" '  박스라인하부픽스유리       
                                ElseIF CInt(glassselect_fix) = 6 Then
                                    fillColor = "#CCFFCC" '  박스라인상부픽스유리    
                                End If
                            end if
                        %>
                        <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fillColor%>" stroke="#333333" stroke-width="" onclick="del('<%=fsidx%>');"/>
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
        <div class="col-2">
            <div class="row">
                <form name="lyh" action="TNG1_FRAMEdb.asp" method="post">
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
                            <!-- fidx가 있을 때에만 전송버튼 활성 시작 -->
                            <% if rfidx<>"" then %>
                            <div class="btn-group" role="group">
                            <button class="btn btn-primary" id="move-down" onclick="submit();">추가</button>
                            </div>
                            <% end if %>
                        </div>
                </form> 
            </div>
        </div>                  
    <div class="row">
        <div class="col-12">
            <div class="btn-group" role="group">
            <form id="dataForm" name="dataForm" action="TNG1_FRAMEdb.asp" method="post">
                            <input type="hidden" name="rfidx" value="<%=rfidx%>">
                            <input type="hidden" name="rfsidx" value="<%=rfsidx%>">
                            <input type="hidden" name="part" value="fmupdate">
                <table id="datatablesSimple" class="table table-hover" style="table-layout: fixed; width: 100%;">
                    <thead>
                        <tr>
                            <th style="width: 5%;">No</th>
                            <th style="width: 10%;">기타사용자재</th>
                            <th style="width: 10%;">자동사용자재</th>
                            
                            <th style="width: 10%;">수동사용자재</th>
                            
                            
                            
                            <th style="width: 10%;">X</th>
                            <th style="width: 10%;">Y</th>
                            <th style="width: 10%;">W</th>
                            <th style="width: 10%;">H</th>
                            <th style="width: 10%;">sunstatus</th>
                        </tr>
                    </thead>
                    <tbody>
                            <% if rfsidx="0" then 
                            cccc="#800080" %>
                            <%
                            %>
                            <tr bgcolor="<%=cccc%>" >
                                <td></td>
                                <td></td>
                                
                                <td>
                                    <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                                        <option value="0" <% If WHICHI_AUTO = "0" Then Response.Write "selected" %> >없음</option>
                                        <option value="1" <% If WHICHI_AUTO = "1" Then Response.Write "selected" %> >박스세트</option>
                                        <option value="2" <% If WHICHI_AUTO = "2" Then Response.Write "selected" %> >박스커버</option>
                                        <option value="3" <% If WHICHI_AUTO = "3" Then Response.Write "selected" %> >가로남마</option>
                                        <option value="4" <% If WHICHI_AUTO = "4" Then Response.Write "selected" %> >상부중간소대</option>
                                        <option value="5" <% If WHICHI_AUTO = "5" Then Response.Write "selected" %> >중간소대</option>
                                        <option value="6" <% If WHICHI_AUTO = "6" Then Response.Write "selected" %> >자동홈바</option>
                                        <option value="7" <% If WHICHI_AUTO = "7" Then Response.Write "selected" %> >세로픽스바</option>
                                        <option value="8" <% If WHICHI_AUTO = "8" Then Response.Write "selected" %> >픽스하바</option>
                                        <option value="9" <% If WHICHI_AUTO = "9" Then Response.Write "selected" %> >픽스상바</option>
                                        <option value="10" <% If WHICHI_AUTO = "10" Then Response.Write "selected" %> >코너바</option>
                                    </select>
                                </td>
                                
                                <td>
                                    <select class="input-field" name="WHICHI_FIX" id="WHICHI_FIX"  onchange="handleChange(this)">
                                        <option value="0" <% If WHICHI_FIX = "0" Then Response.Write "selected" %> >없음</option>
                                        <option value="1" <% If WHICHI_FIX = "1" Then Response.Write "selected" %> >가로바</option>
                                        <option value="2" <% If WHICHI_FIX = "2" Then Response.Write "selected" %> >가로바 길게</option>
                                        <option value="3" <% If WHICHI_FIX = "3" Then Response.Write "selected" %> >중간바</option>
                                        <option value="4" <% If WHICHI_FIX = "4" Then Response.Write "selected" %> >롯트바</option>
                                        <option value="5" <% If WHICHI_FIX = "5" Then Response.Write "selected" %> >하바</option>
                                        <option value="6" <% If WHICHI_FIX = "6" Then Response.Write "selected" %> >세로바</option>
                                        <option value="7" <% If WHICHI_FIX = "7" Then Response.Write "selected" %> >세로중간통바</option>
                                        <option value="8" <% If WHICHI_FIX = "8" Then Response.Write "selected" %> >180도 코너바</option>
                                        <option value="9" <% If WHICHI_FIX = "9" Then Response.Write "selected" %> >90도 코너바</option>
                                        <option value="10" <% If WHICHI_FIX = "10" Then Response.Write "selected" %> >비규격 코너바</option>
                                    </select>
                                </td>
                                
                                <td><input class="input-field" type="number"  name="xi" id="xi" value="<%=xi%>"
                                onkeypress="handleKeyPress(event, 'xi', 'xi')"/></td> 
                                <td><input class="input-field" type="number" name="yi" id="yi" value="<%=yi%>"
                                onkeypress="handleKeyPress(event, 'yi', 'yi')"/></td>
                                <td><input class="input-field" type="number"  name="wi" id="wi" value="<%=wi%>"
                                onkeypress="handleKeyPress(event, 'wi', 'wi')"/></td>
                                <td><input class="input-field" type="number"  name="hi" id="hi" value="<%=hi%>"
                                onkeypress="handleKeyPress(event, 'hi', 'hi')"/></td>
                                <td>
                                    <select class="input-field" name="sunstatus" id="sunstatus"  onchange="handleChange(this)">
                                        <option value="0" <% If sunstatus = "0" Then Response.Write "selected" %> >없음</option>
                                        <option value="1" <% If sunstatus = "1" Then Response.Write "selected" %> >하바위에</option>
                                        <option value="2" <% If sunstatus = "2" Then Response.Write "selected" %> >상부도어위</option>
                                        <option value="3" <% If sunstatus = "3" Then Response.Write "selected" %> >상부픽스위</option>
                                        <option value="4" <% If sunstatus = "4" Then Response.Write "selected" %> >양개 중앙</option>
                                        <option value="5" <% If sunstatus = "5" Then Response.Write "selected" %> >T형_자동홈바</option>
                                    </select>
                                </td>

                            </tr>
                                <% end if %>    
                                <%
                                i=0
                                sunstatus=""
                                sql = "SELECT a.fsidx, a.xi, a.yi, a.wi, a.hi"
                                sql = sql & " , a.WHICHI_AUTO, b.WHICHI_AUTOname"
                                sql = sql & " , a.WHICHI_FIX, c.WHICHI_FIXname , a.sunstatus "
                                sql = sql & " FROM tk_frameSub a"
                                sql = sql & " LEFT JOIN tng_whichitype b ON a.WHICHI_AUTO = b.WHICHI_AUTO"
                                sql = sql & " LEFT JOIN tng_whichitype c ON a.WHICHI_FIX = c.WHICHI_FIX"
                                sql = sql & " WHERE a.fidx = '" & rfidx & "'"
                                'Response.write (SQL)
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                Do while not Rs.EOF
                                    i=i+1
                                    fsidx=Rs(0)
                                    xi=Rs(1)
                                    yi=Rs(2)
                                    wi=Rs(3)
                                    hi=Rs(4)
                                    WHICHI_AUTO     = Rs(5)
                                    WHICHI_AUTOname = Rs(6)
                                    WHICHI_FIX      = Rs(7)
                                    WHICHI_FIXname  = Rs(8)
                                    sunstatus = Rs(9)

                                    
                                %>
                                <% if int(fsidx)=int(rfsidx) then  
                                cccc="#f1592c" 
                                %>
                            <tr bgcolor="<%=cccc%>">
                                <td align="center"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=fsidx%>');"><%=i%></button></td>
                                <td></td>
                                <td>
                                    <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                                    <%
                                    sql = "SELECT WHICHI_AUTO,WHICHI_AUTOname "
                                    sql = sql & "FROM tng_whichitype "
                                    sql = sql & "WHERE bfwstatus=1 "
                                    'Response.write sql & "<br>"
                                    'Response.End
                                    Rs1.open sql, Dbcon, 1, 1, 1
                                    If Not (Rs1.bof Or Rs1.eof) Then 
                                        Do Until Rs1.EOF
                                            yWHICHI_AUTO  = Rs1(0)
                                            yWHICHI_AUTOname  = Rs1(1)
                                        ' 🔹 NULL 또는 빈값이 아니면 출력
                                        If Not IsNull(yWHICHI_AUTO)  Then
                                        %>
                                            <option value="<%=yWHICHI_AUTO%>" <% If cint(WHICHI_AUTO) = cint(yWHICHI_AUTO) Then Response.Write "selected" End If %> >
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
                                <select class="input-field" name="WHICHI_FIX" id="WHICHI_FIX"  onchange="handleChange(this)">
                                <%
                                sql = "SELECT WHICHI_FIX,WHICHI_FIXname "
                                sql = sql & "FROM tng_whichitype "
                                sql = sql & "WHERE bfwstatus=1 "
                                'Response.write sql & "<br>"
                                'Response.End
                                Rs1.open sql, Dbcon, 1, 1, 1
                                If Not (Rs1.bof Or Rs1.eof) Then 
                                    Do Until Rs1.EOF
                                        yWHICHI_FIX  = Rs1(0)
                                        yWHICHI_FIXname  = Rs1(1)
                                    ' 🔹 NULL 또는 빈값이 아니면 출력
                                    If Not IsNull(yWHICHI_FIX)  Then
                                    %>
                                        <option value="<%=yWHICHI_FIX%>" <% If cint(WHICHI_FIX) = cint(yWHICHI_FIX) Then Response.Write "selected" End If %> >
                                            <%=yWHICHI_FIXname%>
                                        </option>
                                    <%
                                    End If
                                    Rs1.MoveNext
                                    Loop
                                    End If
                                    Rs1.close
                                    %>
                                
                            </td>
                                
                                <td><input class="input-field" type="number"  name="xi" id="xi" value="<%=xi%>"
                                onkeypress="handleKeyPress(event, 'xi', 'xi')"/></td> 
                                <td><input class="input-field" type="number"  name="yi" id="yi" value="<%=yi%>"
                                onkeypress="handleKeyPress(event, 'yi', 'yi')"/></td>
                                <td><input class="input-field" type="number" name="wi" id="wi" value="<%=wi%>"
                                onkeypress="handleKeyPress(event, 'wi', 'wi')"/></td>
                                <td><input class="input-field" type="number"  name="hi" id="hi" value="<%=hi%>"
                                onkeypress="handleKeyPress(event, 'hi', 'hi')"/></td>
                                <td>
                                    <select class="input-field" name="sunstatus" id="sunstatus"  onchange="handleChange(this)">
                                        <option value="0" <% If sunstatus = "0" Then Response.Write "selected" %> >없음</option>
                                        <option value="1" <% If sunstatus = "1" Then Response.Write "selected" %> >하바위에</option>
                                        <option value="2" <% If sunstatus = "2" Then Response.Write "selected" %> >상부도어위</option>
                                        <option value="3" <% If sunstatus = "3" Then Response.Write "selected" %> >상부픽스위</option>
                                        <option value="4" <% If sunstatus = "4" Then Response.Write "selected" %> >양개 중앙</option>
                                        <option value="5" <% If sunstatus = "5" Then Response.Write "selected" %> >T형_자동홈바</option>
                                    </select>
                                </td>
                            </tr>
                                <% else 
                                cccc="#CCCCCC"
                                %>
                            <tr bgcolor="<%=cccc%>">
                                <td align="center"><%=i%></td>
                                <td></td>
                                <td><input class="input-field" type="text"  value="<%=WHICHI_AUTOname%>  " 
                                onclick="location.replace('TNG1_FRAME.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" readonly/></td> 
                                
                                <td><input class="input-field" type="text"  value="<%=WHICHI_FIXname%>" 
                                onclick="location.replace('TNG1_FRAME.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" /></td> 
                                
                                <td><input class="input-field" type="number"  value="<%=xi%>" onclick="location.replace('TNG1_FRAME.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" />
                                <td><input class="input-field" type="number"  value="<%=yi%>" onclick="location.replace('TNG1_FRAME.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" />
                                <td><input class="input-field" type="number" value="<%=wi%>" onclick="location.replace('TNG1_FRAME.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" />
                                <td><input class="input-field" type="number"  value="<%=hi%>" onclick="location.replace('TNG1_FRAME.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" />
                                <td><input class="input-field" type="number"  value="<%=sunstatus%>" onclick="location.replace('TNG1_FRAME.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" />

                            </tr>
                                <% end if %>
                                <%
                                Rs.movenext
                                Loop
                                End if
                                Rs.close
                                %> 
                            <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                        </form>
                    </tbody>
                </table>
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
