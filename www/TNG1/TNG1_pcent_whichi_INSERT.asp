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
Set Rs1 = Server.CreateObject("ADODB.Recordset")

mode       = Request("mode")


part=Request("part")
rpidx=Request("pidx")
' 파일 및 폼 데이터 읽기
gotopage = Request("gotopage")
rWHICHI_FIX       = Request("WHICHI_FIX")
rWHICHI_FIXname   = Request("WHICHI_FIXname")
rWHICHI_AUTO      = Request("WHICHI_AUTO")
rWHICHI_AUTOname  = Request("WHICHI_AUTOname")
rmin_ysize        = Request("min_ysize")
rmax_ysize        = Request("max_ysize")
rpcent            = Request("pcent")
pstatus         = Request("pstatus")
rSearchWord       = Request("SearchWord")
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "rSJB_TYPE_NO : " & rSJB_TYPE_NO & "<br>"
'Response.Write "rSJB_TYPE_NAME : " & rSJB_TYPE_NAME & "<br>"
'Response.Write "rSJB_barlist : " & rSJB_barlist & "<br>"
'Response.end

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

        
        function del(rpidx, mode){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href = "TNG1_pcent_whichi_INSERTdb.asp?part=delete&pidx=" + rpidx + "&mode=" + mode;
            }
        }
    </script>
</head>
<body class="sb-nav-sudonged">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
            <div class="py-5 container text-center">
            <!-- 제목 나오는 부분 시작-->
                    <div class="row mb-3">
                        <div class="col-1">
                            <h3>자재위치별 할증 설정</h3>
                        </div>
                        <div class="col-2">
                            <button type="button" class="btn btn-outline-dark" Onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?mode=sudong');">수동위치</button>
                            <button type="button" class="btn btn-outline-dark" Onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?mode=auto');">자동위치</button>
                        </div>
                        <div class="col text-end">
                            <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG1_pcent_whichi_INSERTdb.asp?pidx=0&mode=slt');">전체 업데이트 조회하기</button>
                            <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=0&mode=udt');">전체 업데이트 반영하기</button>

                        <% if mode="sudong" then %>
                            <button type="button" class="btn btn-outline-dark" Onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=0&mode=sudong');">수동등록</button>
                        <% elseif mode="auto" then %>
                            <button type="button" class="btn btn-outline-dark" Onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=0&mode=auto');">자동등록</button>
                        <% end if %>
                            
                        </div>
                    </div>
            <!-- 제목 나오는 부분 끝-->
            
<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">품목번호</th>
                      <% if mode="sudong" then %>
                      <th align="center">수동위치번호</th>
                      <th align="center">수동위치명</th>
                       <% elseif mode="auto" then %>
                      <th align="center">자동위치번호</th>
                      <th align="center">자동위치명</th>
                      <% end if %>
                      <th align="center">최소사이즈 </th>
                      <th align="center">최대사이즈 </th>
                      <th align="center">할증 % </th>
                      <th align="center">사용유무</th>
                  </tr>
              </thead>
              <tbody>
<form id="dataForm" action="TNG1_pcent_whichi_INSERTdb.asp" method="POST">   
<input type="hidden" name="pidx" value="<%=rpidx%>">
<input type="hidden" name="mode" value="<%=mode%>">

<% if rpidx="0" then 
rWHICHI_FIX=0
rWHICHI_AUTO=0
rmin_ysize =0
rmax_ysize =0
rpcent =0
rpstatus=1
%>

                  <tr>
                      <td></td>
                      <% if mode="sudong" then %>
                        <%
                         '🔹 마지막 WHICHI_FIX 구하기
                        SQL = "SELECT ISNULL(MAX(WHICHI_FIX), 0) + 1 FROM tng_whichipcent"
                        Rs.Open SQL, Dbcon
                        If Not (Rs.EOF Or Rs.BOF) Then
                            rWHICHI_FIX = Rs(0) 
                            rWHICHI_AUTO = 0
                        End if
                        Rs.Close
                        %>
                        <td><input class="input-field" type="text" name="WHICHI_FIX" id="WHICHI_FIX" value="<%=rWHICHI_FIX%>" onkeypress="handleKeyPress(event, 'WHICHI_FIX', 'WHICHI_FIX')"/></td> 
                        <td><input class="input-field" type="text" name="WHICHI_FIXname" id="WHICHI_FIXname" value="<%=rWHICHI_FIXname%>" onkeypress="handleKeyPress(event, 'WHICHI_FIXname', 'WHICHI_FIXname')"/></td>
                        <td><input class="input-field" type="text" name="min_ysize" id="min_ysize" value="<%=rmin_ysize %>" onkeypress="handleKeyPress(event, 'min_ysize', 'min_ysize')"/></td>
                        <td><input class="input-field" type="text" name="max_ysize" id="max_ysize" value="<%=rmax_ysize %>" onkeypress="handleKeyPress(event, 'max_ysize', 'max_ysize')"/></td>
                        <td><input class="input-field" type="text" name="pcent" id="pcent" value="<%=rpcent %>" onkeypress="handleKeyPress(event, 'pcent', 'pcent')"/></td>
                        <td>
                            <select class="input-field" name="pstatus" id="pstatus"  onchange="handleSelectChange(event, 'pstatus', 'pstatus')">
                                <option value="1" <% If pstatus = "1" Then Response.Write "selected" %> >✅</option>
                            </select>
                        </td> 

                      <% elseif mode="auto" then %>
                      <%
                        ' 🔹 마지막 WHICHI_AUTO 구하기
                        SQL = "SELECT ISNULL(MAX(WHICHI_AUTO), 0) + 1 FROM tng_whichipcent"
                        Rs.Open SQL, Dbcon
                        If Not (Rs.EOF Or Rs.BOF) Then
                            rWHICHI_AUTO = Rs(0) 
                            rWHICHI_FIX = 0
                        End if
                        Rs.Close
                        %>
                        <td><input class="input-field" type="text" name="WHICHI_AUTO" id="WHICHI_AUTO" value="<%=rWHICHI_AUTO%>" onkeypress="handleKeyPress(event, 'WHICHI_AUTO', 'WHICHI_AUTO')"/></td> 
                        <td><input class="input-field" type="text" name="WHICHI_AUTOname" id="WHICHI_AUTOname" value="<%=rWHICHI_AUTOname%>"  onkeypress="handleKeyPress(event, 'WHICHI_AUTOname', 'WHICHI_AUTOname')"/></td>
                        <td><input class="input-field" type="text" name="min_ysize" id="min_ysize" value="<%=rmin_ysize%>" onkeypress="handleKeyPress(event, 'min_ysize', 'min_ysize')"/></td>
                        <td><input class="input-field" type="text" name="max_ysize" id="max_ysize" value="<%=rmax_ysize%>" onkeypress="handleKeyPress(event, 'max_ysize', 'max_ysize')"/></td>
                        <td><input class="input-field" type="text" name="pcent" id="pcent" value="<%=rpcent%>" onkeypress="handleKeyPress(event, 'pcent', 'pcent')"/></td>
                        <td>
                            <select class="input-field" name="pstatus" id="pstatus"  onchange="handleSelectChange(event, 'pstatus', 'pstatus')">
                                <option value="1" <% If pstatus = "1" Then Response.Write "selected" %> >✅</option>
                            </select>
                        </td> 

                      <% end if %>  
                       

                  </tr>
<% end if %>
<%
sql = "SELECT A.pidx, A.WHICHI_FIX, B.WHICHI_FIXname "
sql = sql & " , A.WHICHI_AUTO, C.WHICHI_AUTOname "
sql = sql & " , A.min_ysize, A.max_ysize, A.pcent, A.pstatus "
sql = sql & " , A.WHICHI_FIXname, A.WHICHI_AUTOname "
sql = sql & " FROM tng_whichipcent A "
sql = sql & " LEFT OUTER JOIN tng_whichitype B ON A.WHICHI_FIX = B.WHICHI_FIX "
sql = sql & " LEFT OUTER JOIN tng_whichitype C ON A.WHICHI_AUTO  = C.WHICHI_AUTO "
    if mode = "sudong" then
        sql = sql & "WHERE A.WHICHI_FIX IS NOT NULL "
    elseif mode = "auto" then
        sql = sql & "WHERE A.WHICHI_AUTO IS NOT NULL "
    end if
sql = sql & "ORDER BY pidx ASC "
Rs.open Sql,Dbcon,1,1,1
'Response.write sql & "<br>"
'Response.End
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
    pidx             = Rs(0)
    WHICHI_FIX       = Rs(1)
    WHICHI_FIXname   = Rs(2)
    WHICHI_AUTO      = Rs(3)
    WHICHI_AUTOname  = Rs(4)
    min_ysize        = Rs(5)
    max_ysize        = Rs(6)
    pcent            = Rs(7)
    pstatus          = Rs(8)
    kWHICHI_FIXname            = Rs(9)
    kWHICHI_AUTOname          = Rs(10)
    select case pstatus
        case "0"
            pstatus_text="❌"
        case "1"
            pstatus_text="✅"
    end select

    i=i+1
%>              
<% if int(pidx)=int(rpidx) then %>
                    <tr>
                        <td align="center"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=pidx%>','<%=mode%>');"><%=i%></button></td>
                    <% if mode="sudong" then %>
                            <td><a name="<%=pidx%>">-><input class="input-field" type="text"  placeholder="수동위치번호" aria-label="수동위치번호" name="WHICHI_FIX" id="WHICHI_FIX" value="<%=WHICHI_FIX%>" onkeypress="handleKeyPress(event, 'WHICHI_FIX', 'WHICHI_FIX')"/></td>
                            <td>
                                <%
                                sql = "SELECT WHICHI_FIX,WHICHI_FIXname "
                                sql = sql & "FROM tng_whichitype "
                                sql = sql & "WHERE WHICHI_FIX='" & WHICHI_FIX & "' "
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
                                    <input class="input-field" type="text"  name="WHICHI_FIXname" id="WHICHI_FIXname" 
                                    value="<% If cint(yWHICHI_FIX) = cint(WHICHI_FIX) Then Response.Write yWHICHI_FIXname end if %>"
                                    onkeypress="handleKeyPress(event, 'WHICHI_FIXname', 'WHICHI_FIXname')"/>
                                    <%
                                    End If
                                    Rs1.MoveNext
                                    Loop
                                    End If
                                    Rs1.close
                                    %>
                                
                            </td>
                            <td><input class="input-field" type="text" name="min_ysize" id="min_ysize" value="<%=min_ysize%>" onkeypress="handleKeyPress(event, 'min_ysize', 'min_ysize')"/></td>
                            <td><input class="input-field" type="text" name="max_ysize" id="max_ysize" value="<%=max_ysize%>" onkeypress="handleKeyPress(event, 'max_ysize', 'max_ysize')"/></td>
                            <td><input class="input-field" type="text" name="pcent" id="pcent" value="<%=pcent%>" onkeypress="handleKeyPress(event, 'pcent', 'pcent')"/></td>
                            <td>
                                <select class="input-field" name="pstatus" id="pstatus"  onchange="handleSelectChange(event, 'pstatus', 'pstatus')">
                                    <option value="0" <% If pstatus = "0" Then Response.Write "selected" %> >❌</option>
                                    <option value="1" <% If pstatus = "1" Then Response.Write "selected" %> >✅</option>
                                </select>
                            </td> 
                    <% elseif mode="auto" then %>
                            <td><a name="<%=pidx%>">-><input class="input-field" type="text" name="WHICHI_AUTO" id="WHICHI_AUTO" value="<%=WHICHI_AUTO%>" onkeypress="handleKeyPress(event, 'WHICHI_AUTO', 'WHICHI_AUTO')"/></td> 
                            <td>
                                <%
                                sql = "SELECT WHICHI_AUTO,WHICHI_AUTOname "
                                sql = sql & "FROM tng_whichitype "
                                sql = sql & "WHERE WHICHI_AUTO='" & WHICHI_AUTO & "' "
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
                                    <input class="input-field" type="text"  name="WHICHI_AUTOname" id="WHICHI_AUTOname" 
                                    value="<% If cint(yWHICHI_AUTO) = cint(WHICHI_AUTO) Then Response.Write yWHICHI_AUTOname end if %>"
                                    onkeypress="handleKeyPress(event, 'WHICHI_AUTOname', 'WHICHI_AUTOname')"/>
                                    <%
                                    End If
                                    Rs1.MoveNext
                                    Loop
                                    End If
                                    Rs1.close
                                    %>
                                
                            </td>
                            <td><input class="input-field" type="text" name="min_ysize" id="min_ysize" value="<%=min_ysize%>" onkeypress="handleKeyPress(event, 'min_ysize', 'min_ysize')"/></td>
                            <td><input class="input-field" type="text" name="max_ysize" id="max_ysize" value="<%=max_ysize%>" onkeypress="handleKeyPress(event, 'max_ysize', 'max_ysize')"/></td>
                            <td><input class="input-field" type="text" name="pcent" id="pcent" value="<%=pcent%>" onkeypress="handleKeyPress(event, 'pcent', 'pcent')"/></td>
                            <td>
                                <select class="input-field" name="pstatus" id="pstatus"  onchange="handleSelectChange(event, 'pstatus', 'pstatus')">
                                    <option value="0" <% If pstatus = "0" Then Response.Write "selected" %> >❌</option>
                                    <option value="1" <% If pstatus = "1" Then Response.Write "selected" %> >✅</option>
                                </select>
                            </td>                          
                    <% end if %>  
                        
                    </tr>
<% else %>
                  <tr> 
                    <td align="center"><%=i%></td>
                    <%
                    'Response.Write "unittype_pidx=" & unittype_pidx & "<br>"
                    %>
                    <% if mode="sudong" then %>
                    <td><input class="input-field" type="text"  value="<%=WHICHI_FIX%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=sudong#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=kWHICHI_FIXname%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=sudong#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=min_ysize%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=sudong#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=max_ysize%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=sudong#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=pcent%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=sudong#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=pstatus_text%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=sudong#<%=pidx%>');"/></td>
                    <% elseif mode="auto" then %>
                    <td><input class="input-field" type="text"  value="<%=WHICHI_AUTO%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=auto#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=kWHICHI_AUTOname%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=auto#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=min_ysize%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=auto#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=max_ysize%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=auto#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=pcent%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=auto#<%=pidx%>');"/></td>
                    <td><input class="input-field" type="text"  value="<%=pstatus_text%>" onclick="location.replace('TNG1_pcent_whichi_INSERT.asp?pidx=<%=pidx%>&mode=auto#<%=pidx%>');"/></td>
                    
                    <% end if %>
                  </tr>
<% end if %>
<%
yWHICHI_FIX="0"
yWHICHI_FIXname="0"
yWHICHI_AUTO="0"
yWHICHI_AUTOname="0"
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
set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>
