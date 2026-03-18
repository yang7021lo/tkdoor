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
rmaster_id = Request("master_id")  
rsearchword=Request("SearchWord")

item_name   = ""   ' 자재명
item_type   = ""   ' 자재 대분류
origin_type = ""   ' 공급/생산 방식
origin_name = ""   ' 공급/생산 방식
status      = "1"  ' 기본값
memo        = ""   ' 비고
title_text  = "추가"

' ============================================================
' 데이터 로딩
' ============================================================

SQL = SQL & " SELECT "
SQL = SQL & "   A.master_id, "
SQL = SQL & "   A.item_name, "
SQL = SQL & "   A.item_type, "
SQL = SQL & "   A.origin_type, "
SQL = SQL & "   A.origin_name, "
SQL = SQL & "   A.status, "
SQL = SQL & "   A.memo, "
SQL = SQL & "   B.midx AS midx, "     ' 생성자 이름
SQL = SQL & "   C.midx AS meidx, "     ' 수정자 이름
SQL = SQL & "   B.mname AS create_user, "     ' 생성자 이름
SQL = SQL & "   C.mname AS update_user, "     ' 수정자 이름
SQL = SQL & "   Convert(varchar(10), A.cdate, 121) AS c_date , "     ' 생성일
SQL = SQL & "   Convert(varchar(10), A.udate, 121)  AS u_date "     ' 수정일
SQL = SQL & " FROM bom_master A "
SQL = SQL & " LEFT OUTER JOIN tk_member B ON A.midx = B.midx "
SQL = SQL & " LEFT OUTER JOIN tk_member C ON A.meidx = C.midx "
SQL = SQL & " WHERE 1=1 "

' 검색어 필터
If Request("SearchWord") <> "" Then
    s = Request("SearchWord")
    SQL = SQL & " AND ( "
    SQL = SQL & "       A.item_name   LIKE '%" & s & "%' "
    SQL = SQL & "    OR A.memo        LIKE '%" & s & "%' "
    SQL = SQL & "    OR A.origin_name LIKE '%" & s & "%' "
    SQL = SQL & " ) "
End If
SQL = SQL & " ORDER BY A.master_id ASC "
'response.write "[BOM_MASTER LIST] <br> " & SQL & "<br>"
Rs.open Sql,Dbcon
if not (Rs.EOF or Rs.BOF ) then
    master_id   = Rs("master_id")
    item_name   = Rs("item_name")
    item_type   = Rs("item_type")
    origin_type = Rs("origin_type")
    origin_name = Rs("origin_name")
    status      = Rs("status")
    memo        = Rs("memo")
    midx   = Rs("midx")
    meidx   = Rs("meidx")
    create_user   = Rs("create_user")
    update_user   = Rs("update_user")
    c_date   = Rs("c_date")
    u_date   = Rs("u_date")
End If
Rs.Close



if request("gotopage")="" then
    gotopage=1
else
    gotopage=request("gotopage")
end if

	page_name = "tng1_julgok_in_sub3.asp?gotopage=" & gotopage & "&SearchWord=" & Request("SearchWord") & "&master_id=" & Request("master_id") & "&"

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>BOM 마스터 관리</title>
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
                location.href="bom_master_popupDb.asp?part=delete&searchWord=<%=rsearchword%>&master_id="+sTR;
            }
        }
    </script>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_BOM.asp"-->


<div id="layoutSidenav_content">            
    <div class="container-fluid px-4">
        <div class="row justify-content-between">
        <h3>BOM 마스터 <%=title_text%></h3>
            <div class="py-5 container text-center  card card-body">
                <div class="col text-end">
                    <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="bom_master_popup.asp" name="Search">   
                        <input type="hidden" name="master_id" value="<%=master_id%>">
                            <div style="display: flex; align-items: center; gap: 8px;"> 
                                <input class="form-control" type="text" placeholder="조회" aria-label="조회" aria-describedby="btnNavbarSearch" name="SearchWord" value="<%=rSearchWord%>"/>
                                <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i></button>
                                <button type="button"
                                    class="btn btn-outline-danger"
                                    style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;"
                                    onclick="location.replace('bom_master_popup.asp?master_id=0');">등록
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
                        <th style="text-align: center;">item_type (품목번호)</th>
                        <th style="text-align: center;">item_name (품목명)</th>
                        <th style="text-align: center;">origin_type (타입번호)</th>
                        <th style="text-align: center;">origin_name (타입명)</th>
                        <th style="text-align: center;">사용/비사용</th>
                        <th style="text-align: center;">memo</th>                            
                        <th style="text-align: center;">작성자</th>
                        <th style="text-align: center;">작성일</th>
                        <th style="text-align: center;">수정자</th>
                        <th style="text-align: center;">수정일</th>
                    </tr>
                </thead>
                <tbody>
                    <form id="dataForm" action="bom_master_popupDb.asp" method="POST" >   
                        <input type="hidden" name="master_id" value="<%=rmaster_id%>">
                        <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                        <input type="hidden" name="gotopage" value="<%=gotopage%>">
                        <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                        <% if rmaster_id="0" then 
                            cccc="#ffeeee"
                        %>
                            <tr bgcolor="<%=cccc%>">
                                <!-- 순번 -->
                                <td></td>

                                <!-- item_type -->
                                <td>
                                    <input class="input-field" type="number" name="item_type" id="item_type" 
                                        value="<%=item_type%>" 
                                        onkeypress="handleKeyPress(event, 'item_type', 'item_type')" />
                                </td>

                                <!-- item_name -->
                                <td>
                                    <input class="input-field" type="text" name="item_name" id="item_name" 
                                        value="<%=item_name%>" 
                                        onkeypress="handleKeyPress(event, 'item_name', 'item_name')" />
                                </td>

                                <!-- origin_type -->
                                <td>
                                    <input class="input-field" type="number" name="origin_type" id="origin_type" 
                                        value="<%=origin_type%>" 
                                        onkeypress="handleKeyPress(event, 'origin_type', 'origin_type')" />
                                </td>

                                <!-- origin_name -->
                                <td>
                                    <input class="input-field" type="text" name="origin_name" id="origin_name" 
                                        value="<%=origin_name%>" 
                                        onkeypress="handleKeyPress(event, 'origin_name', 'origin_name')" />
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
                            SQL = SQL & "   A.master_id, "
                            SQL = SQL & "   A.item_name, "
                            SQL = SQL & "   A.item_type, "
                            SQL = SQL & "   A.origin_type, "
                            SQL = SQL & "   A.origin_name, "
                            SQL = SQL & "   A.status, "
                            SQL = SQL & "   A.memo, "
                            SQL = SQL & "   B.mname AS create_user, "     ' 생성자 이름
                            SQL = SQL & "   C.mname AS update_user, "     ' 수정자 이름
                            SQL = SQL & "   Convert(varchar(10), A.cdate, 121) AS c_date , "     ' 생성일
                            SQL = SQL & "   Convert(varchar(10), A.udate, 121)  AS u_date "     ' 수정일
                            SQL = SQL & " FROM bom_master A "
                            SQL = SQL & " LEFT OUTER JOIN tk_member B ON A.midx = B.midx "
                            SQL = SQL & " LEFT OUTER JOIN tk_member C ON A.meidx = C.midx "
                            SQL = SQL & " WHERE 1=1 "

                            ' 특정 master_id 필터
                            ' If rmaster_id <> "" Then
                            '     SQL = SQL & " AND A.master_id = '" & rmaster_id & "' "
                            ' End If

                            ' 검색어 필터
                            If Request("SearchWord") <> "" Then
                                s = Request("SearchWord")
                                SQL = SQL & " AND ( "
                                SQL = SQL & "       A.item_name   LIKE '%" & s & "%' "
                                SQL = SQL & "    OR A.memo        LIKE '%" & s & "%' "
                                SQL = SQL & "    OR A.origin_name LIKE '%" & s & "%' "
                                SQL = SQL & " ) "
                            End If

                            SQL = SQL & " ORDER BY A.master_id ASC "

                            'response.write "[BOM_MASTER LIST] <br> " & SQL & "<br>"
                            Rs.open Sql,Dbcon,1,1,1
                            Rs.PageSize = 10
                            If Not (Rs.EOF Or Rs.BOF) Then
                            no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                            totalpage=Rs.PageCount 
                            Rs.AbsolutePage =gotopage
                            for j=1 to Rs.RecordCount 
                            if i>Rs.PageSize then exit for end if
                            if no-j=0 then exit for end if

                                master_id   = Rs("master_id")
                                item_name   = Rs("item_name")
                                item_type   = Rs("item_type")
                                origin_type = Rs("origin_type")
                                origin_name = Rs("origin_name")
                                status      = Rs("status")
                                memo        = Rs("memo")
                                create_user   = Rs("create_user")
                                update_user   = Rs("update_user")
                                c_date   = Rs("c_date")
                                u_date   = Rs("u_date")
                                i=i+1

                            if clng(master_id)=clng(rmaster_id) then 
                            cccc="#ffff99"
                            %>
                                <tr bgcolor="<%=cccc%>">
                                    <!-- 순번 -->
                                    <td align="center"><a name="<%=master_id%>"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=master_id%>');"><%=i%></button></td> <!-- 삭제  -->

                                    <!-- item_type -->
                                    <td>
                                        <input class="input-field" type="number" name="item_type" id="item_type" 
                                            value="<%=item_type%>" 
                                            onkeypress="handleKeyPress(event, 'item_type', 'item_type')" />
                                    </td>

                                    <!-- item_name -->
                                    <td>
                                        <input class="input-field" type="text" name="item_name" id="item_name" 
                                            value="<%=item_name%>" 
                                            onkeypress="handleKeyPress(event, 'item_name', 'item_name')" />
                                    </td>

                                    <!-- origin_type -->
                                    <td>
                                        <input class="input-field" type="number" name="origin_type" id="origin_type" 
                                            value="<%=origin_type%>" 
                                            onkeypress="handleKeyPress(event, 'origin_type', 'origin_type')" />
                                    </td>

                                    <!-- origin_name -->
                                    <td>
                                        <input class="input-field" type="text" name="origin_name" id="origin_name" 
                                            value="<%=origin_name%>" 
                                            onkeypress="handleKeyPress(event, 'origin_name', 'origin_name')" />
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
                                    <td align="center"><%=i%><a name="<%=master_id%>"><a name="<%=master_id%>"></td><!-- 순번 -->
                                    <td><input class="input-field" type="text" value="<%=item_type%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
                                    <td><input class="input-field" type="text" value="<%=item_name%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
                                    <td><input class="input-field" type="text" value="<%=origin_type%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
                                    <td><input class="input-field" type="text" value="<%=origin_name%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
                                    <td><input class="input-field" type="text" value="<%=status%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
                                    <td><input class="input-field" type="text" value="<%=memo%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
                                    <td><input class="input-field" type="text" value="<%=create_user%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
                                    <td><input class="input-field" type="text" value="<%=c_date%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
                                    <td><input class="input-field" type="text" value="<%=update_user%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
                                    <td><input class="input-field" type="text" value="<%=u_date%>" onclick="location.replace('bom_master_popup.asp?gotopage=<%=gotopage%>&searchword=<%=rsearchword%>&master_id=<%=master_id%>');"/> </td>  
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
