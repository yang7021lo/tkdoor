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
projectname="프레임그리기"
%>
<%
rfidx=request("rfidx")
rSJB_IDX=Request("SJB_IDX")
rSearchWord=Request("SearchWord")

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
            width: 100%;
            height: 600px;
            border: 2px solid #000;
            background-color: #c8cbe7;
            overflow: hidden;
            margin: 0 auto;
        }
        svg {
            width: 100%;
            height: 100%;
            cursor: grab;
        }
        .dimension-label {
        font-size: 12px;
        fill: black;
        }
        .canvas-container {
        flex: 1;
        display: flex;
        justify-content: flex-start; /* ← 왼쪽 정렬로 변경 */
        align-items: center;
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
    .resize-handle {
        fill: red;
        cursor: pointer;
        r: 5;
    }
    .svg-container {
        border: 2px solid #000;
        margin-top: 20px;
        width: 1000px;
        height: 600px;
        overflow: hidden;
    }
    .dimension-label {
        font-size: 12px;
        fill: black;
    }
    </style>
    <style>
        .svg-container {
            width: 1000px; height: 600px; border: 1px solid #000; overflow: hidden;
        }
        svg {
            width: 100%; height: 100%;
            cursor: grab;
        }
    </style>
    <style>
  #datatablesSimple {
    width: 100%;
    table-layout: fixed;
  }
  #datatablesSimple th,
  #datatablesSimple td {
    padding: 5px;
    vertical-align: middle;
    text-align: center;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  #datatablesSimple input,
  #datatablesSimple select {
    width: 100%;
    box-sizing: border-box; /* padding 포함해서 너비 계산 */
    font-size: 0.85rem;
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
                location.href = "TNG1_GREEMLIST3_recdb.asp?part=fmdel&rfidx=<%=rfidx%>&rfsidx=" + fsidx;
            }
        }
    </script>  
    <script>
        function del(fsidx) {
        if (confirm("이 항목을 삭제하시겠습니까?")) {
            location.href = "TNG1_GREEMLIST3_recdb.asp?part=fmdel&rfidx=<%=rfidx%>&rfsidx=" + fsidx;
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

    </head>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
        <h1><%=greem_f_a_name%>,<%=greem_habar_type_name%>,<%=greem_lb_type_name%>,<%=GREEM_MBAR_TYPE_name%>,<%=greem_o_type_name%>,<%=greem_fix_type_name%>,<%=greem_basic_type_name%></h1>
        </div>
    </div>
    <div class="row">
        <div class="col-8">
            <div class="canvas-container" style="width: 100%; height: 700px;">
                <div class="svg-container" style="width: 100%; height: 100%; border: 2px solid #000;">
                    <svg id="canvas" viewBox="0 0 1000 600" preserveAspectRatio="xMidYMid meet">
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
        </div>
        <div class="col-4">
            <div class="row">
                <div class="controls-container ">
                    <form name="lyh" action="TNG1_GREEMLIST3_recdb.asp" method="post">
                        <input type="hidden" name="rfidx" value="<%=rfidx%>">
                        <input type="hidden" name="part" value="fminsert">
                        <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
                        <input type="hidden" name="SearchWord" value="<%=rSearchWord%>">
                        <input type="hidden" name="gotopage" value="<%=gotopage%>">

                        <!-- 입력 필드 및 버튼 영역 -->
                        <div class="controls-container ">
                        <!--    <h2 class="my-4">부속 추가</h2>  -->
                            <div class="form-group row">
                                <div class="col-sm-8">
                                    <input type="hidden" class="form-control" id="x-input" name="x-input" placeholder="X">
                                    <input type="hidden" class="form-control" id="y-input" name="y-input" placeholder="Y">
                                    <input type="hidden" class="form-control" id="width-input" name="width-input" placeholder="W">
                                    <input type="hidden" class="form-control" id="height-input" name="height-input" placeholder="H">
                                </div>
                            </div>
                            <!-- fidx가 있을 때에만 전송버튼 활성 시작 -->
                            <% if rfidx<>"" then %>
                            <div style="margin-bottom: 10px;">
                            <button class="btn btn-primary" id="move-down" onclick="submit();">추가</button>
                            <button onclick="location.replace('TNG1_GREEMLIST3.asp?gotopage=<%=gotopage%>&SJB_IDX=<%=SJB_IDX%>&SearchWord=<%=rSearchWord%>#<%=SJB_IDX%>');" class="btn btn-danger">이전 화면으로</button>
                            <%= "TNG1_GREEMLIST3.asp?gotopage=" & gotopage & "&SJB_IDX=" & SJB_IDX & "&SearchWord=" & rSearchWord & "#" & SJB_IDX %>
                            <% end if %>

                            <!-- fidx가 있을 때에만 전송버튼 활성 끝 -->
                        </div>
                    </form>
                    <div class="col-12" style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                        <form id="dataForm" name="dataForm" action="TNG1_GREEMLIST3_recdb.asp" method="post">
                            <input type="hidden" name="rfidx" value="<%=rfidx%>">
                            <input type="hidden" name="rfsidx" value="<%=rfsidx%>">
                            <input type="hidden" name="part" value="fmupdate">
                                <table id="datatablesSimple" class="table table-hover" style="table-layout: fixed; width: 100%; margin-bottom: 0;">
                                    <thead>
                                        <tr>
                                            <th style="width: 10%;">No</th>
                                            <th style="width: 15%;">기타</th>
                                            <th style="width: 20%;">자동</th>
                                            <th style="width: 20%;">수동</th>
                                            <th style="width: 10%;">X</th>
                                            <th style="width: 10%;">Y</th>
                                            <th style="width: 10%;">W</th>
                                            <th style="width: 10%;">H</th>
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
                                            </tr>
                                                <% end if %>    
                                                <%
                                                i=0
                                                SQL="select fsidx, xi, yi, wi, hi,WHICHI_AUTO,WHICHI_FIX from tk_frameSub Where fidx='"&rfidx&"' "
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
                                                    WHICHI_AUTO=Rs(5)
                                                    WHICHI_FIX=Rs(6)

                                                    Select Case WHICHI_FIX
                                                        Case "1"
                                                            WHICHI_FIX_text = "가로바"
                                                        Case "2"
                                                            WHICHI_FIX_text = "가로바 길게"
                                                        Case "3"
                                                            WHICHI_FIX_text = "중간바"
                                                        Case "4"
                                                            WHICHI_FIX_text = "롯트바"
                                                        Case "5"
                                                            WHICHI_FIX_text = "하바"
                                                        Case "6"
                                                            WHICHI_FIX_text = "세로바"
                                                        Case "7"
                                                            WHICHI_FIX_text = "세로중간통바"
                                                        Case "8"
                                                            WHICHI_FIX_text = "180도 코너바"
                                                        Case "9"
                                                            WHICHI_FIX_text = "90도 코너바"
                                                        Case "10"
                                                            WHICHI_FIX_text = "비규격 코너바"
                                                        Case Else
                                                            WHICHI_FIX_text = "선택 안됨"
                                                    End Select

                                                    Select Case WHICHI_AUTO
                                                        Case "1"
                                                            WHICHI_AUTO_text = "박스세트"
                                                        Case "2"
                                                            WHICHI_AUTO_text = "박스커버"
                                                        Case "3"
                                                            WHICHI_AUTO_text = "가로남마"
                                                        Case "4"
                                                            WHICHI_AUTO_text = "상부중간소대"
                                                        Case "5"
                                                            WHICHI_AUTO_text = "중간소대"
                                                        Case "6"
                                                            WHICHI_AUTO_text = "자동홈바"
                                                        Case "7"
                                                            WHICHI_AUTO_text = "세로픽스바"
                                                        Case "8"
                                                            WHICHI_AUTO_text = "픽스하바"
                                                        Case "9"
                                                            WHICHI_AUTO_text = "픽스상바"
                                                        Case "10"
                                                            WHICHI_AUTO_text = "코너바"
                                                        Case Else
                                                            WHICHI_AUTO_text = "선택 안됨"
                                                    End Select
                                                %>
                                                <% if int(fsidx)=int(rfsidx) then  
                                                cccc="#f1592c" 
                                                %>
                                            <tr bgcolor="<%=cccc%>">
                                                <td ><button type="button" class="btn btn-outline-danger" Onclick="del('<%=fsidx%>');"><%=i%></button></td>
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
                                                <td><input class="input-field" type="number"  name="yi" id="yi" value="<%=yi%>"
                                                onkeypress="handleKeyPress(event, 'yi', 'yi')"/></td>
                                                <td><input class="input-field" type="number" name="wi" id="wi" value="<%=wi%>"
                                                onkeypress="handleKeyPress(event, 'wi', 'wi')"/></td>
                                                <td><input class="input-field" type="number"  name="hi" id="hi" value="<%=hi%>"
                                                onkeypress="handleKeyPress(event, 'hi', 'hi')"/></td>
                                                <!--<td><button class="btn btn-primary" onclick="alert('부속을 선택합니다.논의');">선택</button></td>-->
                                            </tr>
                                                <% else 
                                                cccc="#CCCCCC"
                                                %>
                                            <tr bgcolor="<%=cccc%>">
                                                <td ><%=i%></td>
                                                <td></td>
                                                <td><input class="input-field" type="text"  value="<%=WHICHI_AUTO_text%>  " 
                                                onclick="location.replace('TNG1_GREEMLIST3_REC.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" readonly/></td> 
                                                
                                                <td><input class="input-field" type="text"  value="<%=WHICHI_FIX_text%>" 
                                                onclick="location.replace('TNG1_GREEMLIST3_REC.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" /></td> 
                                                
                                                <td><input class="input-field" type="number"  value="<%=xi%>" onclick="location.replace('TNG1_GREEMLIST3_REC.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" />
                                                <td><input class="input-field" type="number"  value="<%=yi%>" onclick="location.replace('TNG1_GREEMLIST3_REC.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" />
                                                <td><input class="input-field" type="number" value="<%=wi%>" onclick="location.replace('TNG1_GREEMLIST3_REC.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" />
                                                <td><input class="input-field" type="number"  value="<%=hi%>" onclick="location.replace('TNG1_GREEMLIST3_REC.asp?rfidx=<%=rfidx%>&rfsidx=<%=fsidx%>&part=fmupdate');" />
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
                        </form>        
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

                            // 드래그용
                            let isPanning = false;
                            let panStart = { x: 0, y: 0 };
                            let viewBoxX = 0;
                            let viewBoxY = 0;
                            let viewBoxW = 1000;
                            let viewBoxH = 600;

                            // 줌 인/아웃 (휠 이벤트)
                            canvas.addEventListener('wheel', (e) => {
                            e.preventDefault();
                            const scaleFactor = e.deltaY < 0 ? 0.9 : 1.1;
                            viewBoxW *= scaleFactor;
                            viewBoxH *= scaleFactor;
                            canvas.setAttribute("viewBox", `${viewBoxX} ${viewBoxY} ${viewBoxW} ${viewBoxH}`);
                            });

                            canvas.addEventListener('mousedown', (e) => {
                            if (e.button === 1 || e.ctrlKey) {
                                isPanning = true;
                                panStart.x = e.clientX;
                                panStart.y = e.clientY;
                                canvas.style.cursor = "grabbing";
                            } else if (!isResizing && !isMoving) {
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

                            canvas.addEventListener('mousemove', (e) => {
                            if (isPanning) {
                                const dx = (e.clientX - panStart.x) * (viewBoxW / canvas.clientWidth);
                                const dy = (e.clientY - panStart.y) * (viewBoxH / canvas.clientHeight);
                                viewBoxX -= dx;
                                viewBoxY -= dy;
                                panStart.x = e.clientX;
                                panStart.y = e.clientY;
                                canvas.setAttribute("viewBox", `${viewBoxX} ${viewBoxY} ${viewBoxW} ${viewBoxH}`);
                            } else if (isDrawing || isResizing) {
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

                            canvas.addEventListener('mouseup', () => {
                            isDrawing = false;
                            isResizing = false;
                            isMoving = false;
                            isPanning = false;
                            canvas.style.cursor = "default";
                            });

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
