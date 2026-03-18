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
  function del(fsidx) {
    if (confirm("이 항목을 삭제하시겠습니까?")) {
      location.href = "frame4db.asp?part=fmdel&rfidx=<%=rfidx%>&rfsidx=" + fsidx;
    }
  }
  </script>  
</head>
<body>

<div class="container-fluid">
  <div class="row">
    <div class="col-2">
      <div class="row">
<!-- 프레임 만들기 시작 -->
 
        <form name="barasi" action="frame4db.asp" method="post">
<% if rfidx<>"" then %>
        <input type="hidden" name="part" value="fupdate">
        <input type="hidden" name="rfidx" value="<%=rfidx%>">
<% else %>
        <input type="hidden" name="part" value="finsert">
<% end if %>
        <div class="controls-container">
          <h2 >프레임 만들기</h2>
          <div class=" row">
            <div class="col-6">
              <input type="text" class="form-control"  placeholder="이름" id="fname" name="fname" value="<%=afname%>">
            </div>
            <div class="col-6">
                <button type="submit" class="btn btn-primary"><% if rfidx<>"" then %>수정<% else %>추가<% end if %></button>
            </div>
          </div>
        </div>
        </form>          
 
<!-- 프레임 만들기 끝 -->
      </div>
      <table id="datatablesSimple" class="table table-hover">
        <thead>
          <tr>
            <th>프레임명</th>
          </tr>
        </thead>
        <tbody>
<%
  SQL="select  fidx, fname, fstatus from tk_frame "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
  Do while not Rs.EOF
  fidx=Rs(0)
  fname=Rs(1)
  fstatus=Rs(2)

%>
          <tr>
            <td><a href="frame4.asp?rfidx=<%=fidx%>&part=update"><% if fstatus="0" then response.write "<s>" end if%><%=fname%><% if fstatus="0" then response.write "</s>" end if%></a></td>
          </tr>
<%
  Rs.movenext
  Loop
  End if
  Rs.close
%> 
        </tbody>
      </table>
 
    </div>
    <div class="col-8">

<!-- 캔버스 영역 시작 -->

      <div class="canvas-container">
          
        <div class="svg-container">
            <svg id="canvas" width="1000" height="600" class="d-block">
            <rect id="rectangle" fill="white" stroke="black" stroke-width="1" width="0" height="0"></rect>
            <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
            <text id="width-label" class="dimension-label"></text>
            <text id="height-label" class="dimension-label"></text>

<%
SQL="select fsidx, xi, yi, wi, hi from tk_frameSub Where fidx='"&rfidx&"' "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
  Do while not Rs.EOF
    i=i+1
    fsidx=Rs(0)
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
<!-- 캔버스 영역 끝 -->
    </div>
    <div class="col-2">

      <div class="row">
<!-- 부속 추가 시작 -->

<form name="lyh" action="frame4db.asp" method="post">
<input type="hidden" name="rfidx" value="<%=rfidx%>">
<input type="hidden" name="part" value="fminsert">
      <!-- 입력 필드 및 버튼 영역 -->
      <div class="controls-container col-md-3">
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
<!-- fidx가 있을 때에만 전송버튼 활성 끝 -->
        <div class="btn-group" role="group">
      <table id="datatablesSimple" class="table table-hover">
        <thead>
          <tr>
            <th>N</th>
            <th>X</th>
            <th>Y</th>
            <th>W</th>
            <th>H</th>
            <!--<th>선택</th>-->
          </tr>
        </thead>
        <tbody>
<%
  i=0
SQL="select fsidx, xi, yi, wi, hi from tk_frameSub Where fidx='"&rfidx&"' "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
  Do while not Rs.EOF
    i=i+1
    fsidx=Rs(0)
    xi=Rs(1)
    yi=Rs(2)
    wi=Rs(3)
    hi=Rs(4)
%>
          <tr>
            <td><%=i%></td>
            <td><%=xi%></td>
            <td><%=yi%></td>
            <td><%=wi%></td>
            <td><%=hi%></td>
            <!--<td><button class="btn btn-primary" onclick="alert('부속을 선택합니다.논의');">선택</button></td>-->
          </tr>
<%
  Rs.movenext
  Loop
  End if
  Rs.close
%> 
        </tbody>
      </table>
        </div>

<!-- 프레임 만들기 시작-->
 

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
</form>





      </div>
<!-- 부속 추가 끝 -->
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
