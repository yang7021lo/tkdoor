<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()

Set Rs  = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")
Set Rs3 = Server.CreateObject("ADODB.Recordset")
Set RsC = Server.CreateObject("ADODB.Recordset")

if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 
'--쿠키정보
'     c_midx = request.cookies("tk")("c_midx")	  '회원키값
'     c_cidx = request.cookies("tk")("c_cidx")		'회원 소속사 키
'     c_mname = request.cookies("tk")("c_mname")		'회원 이름
'     c_cname = request.cookies("tk")("c_cname")		'회원 소속사 이름



rmode = Request("mode")          ' add / edit
rmold_id = Request("mold_id")
rsearchword=Request("SearchWord")

mold_id    = ""
mold_no    = ""
mold_name  = ""
vendor_id  = ""
location_mold   = ""
cad_path   = ""
img_path   = ""
status     = "1"
memo       = ""
title_text = "추가"

' ============================================================
' 데이터 로딩
' ============================================================

SQL = ""
SQL = SQL & " SELECT "
SQL = SQL & "   A.mold_id, "
SQL = SQL & "   A.mold_no, "
SQL = SQL & "   A.mold_name, "
SQL = SQL & "   A.vendor_id, "
SQL = SQL & "   A.location_mold, "
SQL = SQL & "   A.cad_path, "
SQL = SQL & "   A.img_path, "
SQL = SQL & "   A.status, "
SQL = SQL & "   A.memo, "
SQL = SQL & "   B.mname AS create_user, "
SQL = SQL & "   C.mname AS update_user, "
SQL = SQL & "   Convert(varchar(10), A.cdate, 121) AS c_date, "
SQL = SQL & "   Convert(varchar(10), A.udate, 121) AS u_date "
SQL = SQL & " FROM bom_mold A "
SQL = SQL & " LEFT OUTER JOIN tk_member B ON A.midx = B.midx "
SQL = SQL & " LEFT OUTER JOIN tk_member C ON A.meidx = C.midx "
SQL = SQL & " WHERE 1=1 "
If rmold_id <> "" And rmold_id <> "0" Then
    SQL = SQL & " AND A.mold_id = '" & rmold_id & "' "
End If

' 검색어 필터
If Request("SearchWord") <> "" Then
    s = Request("SearchWord")
    SQL = SQL & " AND ( "
    SQL = SQL & "       A.mold_no   LIKE '%" & s & "%' "
    SQL = SQL & "    OR A.mold_name        LIKE '%" & s & "%' "
    SQL = SQL & "    OR A.location_mold  LIKE '%" & s & "%' "
    SQL = SQL & "    OR A.memo LIKE '%" & s & "%' "
    SQL = SQL & " ) "
End If
SQL = SQL & " ORDER BY A.mold_id ASC "
response.write "[bom_mold LIST] <br> " & SQL & "<br>"
Rs.open Sql,Dbcon
if not (Rs.EOF or Rs.BOF ) then
    mold_id     = Rs("mold_id")
    mold_no     = Rs("mold_no")
    mold_name   = Rs("mold_name")
    vendor_id   = Rs("vendor_id")
    location_mold    = Rs("location_mold")
    cad_path    = Rs("cad_path")
    img_path    = Rs("img_path")
    status      = Rs("status")
    memo        = Rs("memo")
    create_user = Rs("create_user")
    update_user = Rs("update_user")
    c_date      = Rs("c_date")
    u_date      = Rs("u_date")
End If
Rs.Close



if request("gotopage")="" then
    gotopage=1
else
    gotopage=request("gotopage")
end if

	page_name = "bom_mold_popup.asp?SearchWord=" & Request("SearchWord") & "&mold_id=" & Request("mold_id") & "&"

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>BOM 금형 관리</title>
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

</head>
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
            if (confirm("삭제 하시겠습니까?"))
            {
                location.href="bom_mold_popupDb.asp?part=delete&searchWord=<%=rsearchword%>&mold_id="+sTR;
            }
        }
    </script>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_BOM.asp"-->


<div id="layoutSidenav_content">            
    <div class="container-fluid px-4">
        <div class="row justify-content-between">
        <h3>BOM 금형 <%=title_text%></h3>
            <div class="py-5 container text-center  card card-body">
                <div class="col text-end">
                    <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="bom_mold_popup.asp" name="Search">   
                        <input type="hidden" name="mold_id" value="<%=mold_id%>">
                            <div style="display: flex; align-items: center; gap: 8px;"> 
                                <input class="form-control" type="text" placeholder="조회" aria-label="조회" aria-describedby="btnNavbarSearch" name="SearchWord" value="<%=rSearchWord%>"/>
                                <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i></button>
                                <button type="button"
                                    class="btn btn-outline-danger"
                                    style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;"
                                    onclick="location.replace('bom_mold_popup.asp?mold_id=0');">등록
                                </button>
                            </div>
                    </form> 
                                
                            
                </div>
            </div>
        </div>
        <div style="width: 100%; margin: 0; padding: 0;">
            <table style="width: 100%; border-collapse: collapse;" id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th style="text-align: center;">순번</th>
                        <th style="text-align: center;">mold_no  (금형번호)</th>
                        <th style="text-align: center;">mold_name  (금형명)</th>
                        <th style="text-align: center;">vendor_id  (공급자)</th>
                        <th style="text-align: center;">location_mold  (보관위치)</th>
                        <th style="text-align: center;">이미지</th>  
                        <th style="text-align: center;">파일</th>  
                        <th style="text-align: center;">사용/비사용</th>
                        <th style="text-align: center;">memo</th>                            
                        <th style="text-align: center;">작성자</th>
                        <th style="text-align: center;">작성일</th>
                        <th style="text-align: center;">수정자</th>
                        <th style="text-align: center;">수정일</th>
                    </tr>
                </thead>
                <tbody>
                    <form id="dataForm" action="bom_mold_popupDb.asp" method="POST" >   
                        <input type="hidden" name="mold_id" value="<%=rmold_id%>">
                        <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                        <input type="hidden" name="gotopage" value="<%=gotopage%>">
                        <% if rmold_id="0" then 
                            cccc="#ffeeee"
                        %>
                            <tr bgcolor="<%=cccc%>">
                                <!-- 순번 -->
                                <td></td>

                                <!-- mold_no -->
                                <td>
                                    <input class="input-field" type="number" name="mold_no" 
                                    value="<%=mold_no%>" 
                                    onkeypress="handleKeyPress(event, 'mold_no', 'mold_no')" />
                                </td>

                                <!-- mold_name -->
                                <td>
                                    <input class="input-field" type="text" name="mold_name" 
                                    value="<%=mold_name%>" 
                                    onkeypress="handleKeyPress(event, 'mold_name', 'mold_name')" />                                        
                                </td>

                                <!-- vendor_id -->
                                <td>
                                    <input class="input-field" type="number" name="vendor_id"
                                    value="<%=vendor_id%>" 
                                    onkeypress="handleKeyPress(event, 'vendor_id', 'vendor_id')" />
                                </td>

                                <!-- location_mold -->
                                <td>
                                    <input class="input-field" type="text" name="location_mold" 
                                    value="<%=location_mold%>" 
                                    onkeypress="handleKeyPress(event, 'location_mold', 'location_mold')" />
                                </td>

                                <!-- img_path -->
                                <td>

                                    <!-- 업로드 버튼 -->
                                    <button type="button" class="btn btn-outline-primary btn-sm"
                                        onclick="window.open(
                                            'bom_mold_popupDb_file.asp?mold_id=<%=mold_id%>&mode=img',
                                            'pasteUpload',
                                            'width=900,height=800,top=100,left=300,resizable=yes,scrollbars=yes'
                                        );">
                                        이미지 업로드
                                    </button>

                                    <!-- 파일명 표시 + 미리보기 툴팁 -->
                                    <div style="margin-top:5px; position: relative; display: inline-block;">
                                        <% If img_path <> "" Then %>

                                            <span 
                                                style="cursor:pointer; text-decoration:underline; color:#0066cc;"
                                                onmouseover="showPreview(this, '/img/bom/img/<%=img_path%>')"
                                                onmouseout="hidePreview()">
                                                <%=img_path%>
                                            </span>

                                        <% Else %>
                                            <span style="color:#888;">(이미지 없음)</span>
                                        <% End If %>
                                    </div>

                                </td>

                                <!-- cad_path -->
                                <td>

                                    <!-- 붙여넣기 업로드 (CAD 도 가능하게 유지) -->
                                    <button type="button" class="btn btn-outline-primary btn-sm"
                                        onclick="window.open('bom_mold_popupDb_paste.asp?mold_id=<%=mold_id%>&mode=cad',
                                        'pasteUpload', 'width=600,height=600');">
                                        붙여넣기(CAD)
                                    </button>

                                    <!-- 파일 업로드 -->
                                    <button type="button" class="btn btn-outline-success btn-sm"
                                        onclick="window.open('bom_mold_popupDb_file.asp?mold_id=<%=mold_id%>&mode=cad',
                                        'fileUpload', 'width=400,height=200');">
                                        파일 업로드(CAD)
                                    </button>

                                    <!-- 파일명 표시 -->
                                    <div style="margin-top:5px;">
                                        <% If cad_path <> "" Then %>
                                            <%=cad_path%>
                                        <% Else %>
                                            <span style="color:#888;">(CAD 없음)</span>
                                        <% End If %>
                                    </div>

                                    <!-- 다운로드 -->
                                    <% If cad_path <> "" Then %>
                                        <a href="/img/bom/file/<%=cad_path%>" download="<%=cad_path%>">
                                            <button type="button" class="btn btn-outline-success btn-sm">다운로드</button>
                                        </a>
                                    <% End If %>

                                </td>

                                <!-- status -->
                                <td>
                                    <input class="input-field" type="text" name="status" id="status" 
                                        value="<%=status%>"
                                        onkeypress="handleKeyPress(event, 'status', 'status')" />
                                </td>

                                <!-- memo -->
                                <td>
                                    <input class="input-field" type="text" name="memo" id="memo" 
                                        value="<%=memo%>"
                                        onkeypress="handleKeyPress(event, 'memo', 'memo')" />
                                </td>

                                <!-- midx (작성자) - READONLY -->
                                <td>
                                    <input class="input-field" type="text" 
                                        value="<%=create_user%>" readonly />
                                </td>

                                <!-- meidx (수정자) - READONLY -->
                                <td>
                                    <input class="input-field" type="text"  
                                        value="<%=update_user%>" readonly />
                                </td>
                            </tr>
                        <% end if %>       
                        <% 
                            i=0
                            cccc=""
                            SQL = ""
                            SQL = SQL & " SELECT "
                            SQL = SQL & "   A.mold_id, "
                            SQL = SQL & "   A.mold_no, "
                            SQL = SQL & "   A.mold_name, "
                            SQL = SQL & "   A.vendor_id, "
                            SQL = SQL & "   A.location_mold, "
                            SQL = SQL & "   A.cad_path, "
                            SQL = SQL & "   A.img_path, "
                            SQL = SQL & "   A.status, "
                            SQL = SQL & "   A.memo, "
                            SQL = SQL & "   B.mname AS create_user, "
                            SQL = SQL & "   C.mname AS update_user, "
                            SQL = SQL & "   Convert(varchar(10), A.cdate, 121) AS c_date, "
                            SQL = SQL & "   Convert(varchar(10), A.udate, 121) AS u_date "
                            SQL = SQL & " FROM bom_mold A "
                            SQL = SQL & " LEFT OUTER JOIN tk_member B ON A.midx = B.midx "
                            SQL = SQL & " LEFT OUTER JOIN tk_member C ON A.meidx = C.midx "
                            SQL = SQL & " WHERE 1=1 "

                            ' 특정 mold_id 필터
                            ' If rmold_id <> "" Then
                            '     SQL = SQL & " AND A.mold_id = '" & rmold_id & "' "
                            ' End If

                            ' 검색어 필터
                            If Request("SearchWord") <> "" Then
                                s = Request("SearchWord")
                                SQL = SQL & " AND ( "
                                SQL = SQL & "       A.mold_no   LIKE '%" & s & "%' "
                                SQL = SQL & "    OR A.mold_name        LIKE '%" & s & "%' "
                                SQL = SQL & "    OR A.location_mold  LIKE '%" & s & "%' "
                                SQL = SQL & "    OR A.memo LIKE '%" & s & "%' "
                                SQL = SQL & " ) "
                            End If

                            SQL = SQL & " ORDER BY A.mold_id ASC "

                            response.write "[BOM_mold LIST] <br> " & SQL & "<br>"
                            Rs.open Sql,Dbcon,1,1,1
                            Rs.PageSize = 10
                            If Not (Rs.EOF Or Rs.BOF) Then
                                no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                                totalpage=Rs.PageCount 
                                Rs.AbsolutePage =gotopage
                                for j=1 to Rs.RecordCount 
                                if i>Rs.PageSize then exit for end if
                                if no-j=0 then exit for end if

                                mold_id     = Rs("mold_id")
                                mold_no     = Rs("mold_no")
                                mold_name   = Rs("mold_name")
                                vendor_id   = Rs("vendor_id")
                                location_mold    = Rs("location_mold")
                                cad_path    = Rs("cad_path")
                                img_path    = Rs("img_path")
                                status      = Rs("status")
                                memo        = Rs("memo")
                                create_user = Rs("create_user")
                                update_user = Rs("update_user")
                                c_date      = Rs("c_date")
                                u_date      = Rs("u_date")
                                i=i+1

                            if clng(mold_id)=clng(rmold_id) then 
                            cccc="#ffff99"
                            %>
                                <tr bgcolor="<%=cccc%>">
                                    <!-- 순번 -->
                                    <td align="center"><a name="<%=mold_id%>"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=mold_id%>');"><%=i%></button></td> <!-- 삭제  -->

                                    <!-- mold_no -->
                                    <td>
                                        <input class="input-field" type="number" name="mold_no"
                                        value="<%=mold_no%>" 
                                        onkeypress="handleKeyPress(event, 'mold_no', 'mold_no')" />
                                    </td>

                                    <!-- mold_name -->
                                    <td>
                                        <input class="input-field" type="text" name="mold_name" 
                                        value="<%=mold_name%>" 
                                        onkeypress="handleKeyPress(event, 'mold_name', 'mold_name')" />                                        
                                    </td>

                                    <!-- vendor_id -->
                                    <td>
                                        <input class="input-field" type="number" name="vendor_id"
                                        value="<%=vendor_id%>" 
                                        onkeypress="handleKeyPress(event, 'vendor_id', 'vendor_id')" />
                                    </td>

                                    <!-- location_mold -->
                                    <td>
                                        <input class="input-field" type="text" name="location_mold" 
                                        value="<%=location_mold%>" 
                                        onkeypress="handleKeyPress(event, 'location_mold', 'location_mold')" />
                                    </td>

                                    <!-- img_path -->
                                    <td>

                                        <!-- 업로드 버튼 -->
                                        <button type="button" class="btn btn-outline-primary btn-sm"
                                            onclick="window.open(
                                                'bom_mold_popupDb_file.asp?mold_id=<%=mold_id%>&mode=img',
                                                'pasteUpload',
                                                'width=900,height=800,top=100,left=300,resizable=yes,scrollbars=yes'
                                            );">
                                            이미지 업로드
                                        </button>

                                        <!-- 파일명 표시 + 미리보기 툴팁 -->
                                        <div style="margin-top:5px; position: relative; display: inline-block;">
                                            <% If img_path <> "" Then %>

                                                <span 
                                                    style="cursor:pointer; text-decoration:underline; color:#0066cc;"
                                                    onmouseover="showPreview(this, '/img/bom/img/<%=img_path%>')"
                                                    onmouseout="hidePreview()">
                                                    <%=img_path%>
                                                </span>

                                            <% Else %>
                                                <span style="color:#888;">(이미지 없음)</span>
                                            <% End If %>
                                        </div>

                                    </td>

                                    <!-- cad_path -->
                                    <td>

                                        <!-- 붙여넣기 업로드 (CAD 도 가능하게 유지) -->
                                        <button type="button" class="btn btn-outline-primary btn-sm"
                                            onclick="window.open('bom_mold_popupDb_paste.asp?mold_id=<%=mold_id%>&mode=cad',
                                            'pasteUpload', 'width=600,height=600');">
                                            붙여넣기(CAD)
                                        </button>

                                        <!-- 파일 업로드 -->
                                        <button type="button" class="btn btn-outline-success btn-sm"
                                            onclick="window.open('bom_mold_popupDb_file.asp?mold_id=<%=mold_id%>&mode=cad',
                                            'fileUpload', 'width=600,height=400');">
                                            파일 업로드(CAD)
                                        </button>

                                        <!-- 파일명 표시 -->
                                        <div style="margin-top:5px;">
                                            <% If cad_path <> "" Then %>
                                                <%=cad_path%>
                                            <% Else %>
                                                <span style="color:#888;">(CAD 없음)</span>
                                            <% End If %>
                                        </div>

                                        <!-- 다운로드 -->
                                        <% If cad_path <> "" Then %>
                                            <a href="/img/bom/file/<%=cad_path%>" download="<%=cad_path%>">
                                                <button type="button" class="btn btn-outline-success btn-sm">다운로드</button>
                                            </a>
                                        <% End If %>

                                    </td>

                                    <!-- status -->
                                    <td>
                                        <input class="input-field" type="text" name="status" id="status" 
                                            value="<%=status%>"
                                            onkeypress="handleKeyPress(event, 'status', 'status')" />
                                    </td>

                                    <!-- memo -->
                                    <td>
                                        <input class="input-field" type="text" name="memo" id="memo" 
                                            value="<%=memo%>"
                                            onkeypress="handleKeyPress(event, 'memo', 'memo')" />
                                    </td>

                                    <!-- midx (작성자) - READONLY -->
                                    <td>
                                        <input class="input-field" type="text" 
                                            value="<%=create_user%>" readonly />
                                    </td>
                                    
                                    <!-- c_date (작성일) - READONLY -->
                                    <td>
                                        <input class="input-field" type="text" 
                                            value="<%=c_date%>" readonly />
                                    </td>

                                    <!-- meidx (수정자) - READONLY -->
                                    <td>
                                        <input class="input-field" type="text"  
                                            value="<%=update_user%>" readonly />
                                    </td>

                                    <!-- u_date (수정일) - READONLY -->
                                    <td>
                                        <input class="input-field" type="text" 
                                            value="<%=u_date%>" readonly />
                                    </td>
                                </tr>
                                <% else 
                                cccc="#CCCCCC"
                                %>
                                <tr bgcolor="<%=cccc%>">
                                    <td align="center"><%=i%><a name="<%=mold_id%>"><a name="<%=mold_id%>"></td><!-- 순번 -->

                                    <td><input class="input-field" type="text" value="<%=mold_no%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=mold_name%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=vendor_id%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=location_mold%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=img_path%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=cad_path%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>
                                    
                                    <td><input class="input-field" type="text" value="<%=status%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=memo%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=create_user%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=c_date%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=update_user%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                    <td><input class="input-field" type="text" value="<%=u_date%>" 
                                        onclick="location.replace('bom_mold_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&mold_id=<%=mold_id%>');"/> 
                                    </td>

                                </tr> 
                            <% end if %>
                            <%
                            Rs.MoveNext
                            Next
                            End If 
                            %>
                            <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                        </form>   
                    </tbody>
            </table>  
        <div class="row">
            <div  class="col-12 py-3"> 
                <!--#include Virtual = "/inc/paging.asp" -->
            </div>
        </div>
        <%
        Rs.Close
        %> 
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
    // 페이지 로드 후 앵커로 이동
    window.addEventListener("DOMContentLoaded", function () {
        const hash = window.location.hash;
        if (hash) {
            const target = document.querySelector(hash);
            if (target) {
                target.scrollIntoView({ behavior: "smooth", block: "center" });
            }
        }
    });
</script>
<script>
    window.addEventListener("DOMContentLoaded", function () {
        const bfidx = "<%=rbfidx%>";
        if (bfidx && bfidx !== "0") {
            const target = document.getElementById(bfidx);
            if (target) {
                // 앵커 위치로 이동
                target.scrollIntoView({  block: "center" });

                // URL에 앵커 강제로 추가
                history.replaceState(null, null, "#" + bfidx);
            }
        }
    });
</script>
<style>
.preview-box {
    position: absolute;
    z-index: 9999;
    border: 1px solid #ccc;
    background: #fff;
    padding: 5px;
    border-radius: 5px;
    display: none;
    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
}
.preview-box img {
    max-width: 200px;
    max-height: 200px;
}
</style>

<div id="previewBox" class="preview-box"></div>

<script>
function showPreview(el, imgSrc) {
    const box = document.getElementById("previewBox");
    box.innerHTML = "<img src='" + imgSrc + "'>";
    box.style.display = "block";

    // 요소 좌표 계산
    const rect = el.getBoundingClientRect();

    // 미리보기 박스 크기 먼저 계산 (이미지 로드 후 반응)
    setTimeout(() => {
        const boxWidth  = box.offsetWidth;
        const boxHeight = box.offsetHeight;

        // X: 파일명 텍스트 가운데 정렬
        const leftPos = rect.left + window.scrollX + (rect.width/2) - (boxWidth/2);

        // Y: 요소 바로 위
        const topPos  = rect.top + window.scrollY - boxHeight - 10;

        box.style.left = leftPos + "px";
        box.style.top  = topPos + "px";
    }, 10);
}

function hidePreview() {
    document.getElementById("previewBox").style.display = "none";
}
</script>

</body>
</html>

<%
set RsC = Nothing
set Rs = Nothing
set Rs1 = Nothing
set Rs2 = Nothing
set Rs3 = Nothing
call dbClose()
%>
