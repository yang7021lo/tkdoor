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
    Set RsC = Server.CreateObject("ADODB.Recordset")
    Set Rs = Server.CreateObject("ADODB.Recordset")
    Set Rs1 = Server.CreateObject("ADODB.Recordset")
    Set Rs2 = Server.CreateObject("ADODB.Recordset")
    Set Rs3 = Server.CreateObject("ADODB.Recordset")

    listgubun = "four"
    projectname = "자재등록"
%>

<%
function encodestr(str)
    if str = "" then exit function
    str = replace(str, chr(34), "&#34")
    str = replace(str, "'", "''")
    encodestr = str
end function

SearchWord = Request("SearchWord")
gubun = Request("gubun")
filterDept = Request("filterDept") 

if request("gotopage") = "" then
    gotopage = 1
else
    gotopage = request("gotopage")
end if

page_name = "tts.asp?listgubun=" & listgubun & "&"



SQL = "SELECT order_idx, order_name, order_length, order_type, Convert(varchar(10),order_date,121), order_status , order_fdate , order_dept "
SQL = SQL & "FROM tk_khyorder "


whereClause = ""

' 부서 필터 
If filterDept <> "" Then
    whereClause = whereClause & "order_dept = " & filterDept
End If

' 자재명 검색 
If SearchWord <> "" Then
    If whereClause <> "" Then
        whereClause = whereClause & " and "
    End If
    whereClause = whereClause & "CHARINDEX('" & encodestr(SearchWord) & "', order_name) > 0"
End If

' WHERE 절이 있다면 
If whereClause <> "" Then
    SQL = SQL & " WHERE " & whereClause
End If

' 정렬 조건 
SQL = SQL & " ORDER BY order_idx DESC"


Rs.Open SQL, Dbcon, 1, 1, 1
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title><%=projectname%></title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <style>
      a:link, a:visited, a:hover {
        color: #070707;
        text-decoration: none;
      }

      .container-flex {
        display: flex;
        justify-content: space-between;
      }

      .left-section {
        width: 36%;
        padding: 10px;
        border-right: 2px solid #ddd;
      }

      .right-section {
        width: 64%;
        padding: 10px;
      }

      .input-group-text {
        width: 120px;
      }
    </style>
    <script>
        function validateForm() {
            if (document.frmMain.order_name.value == "") {
                alert("자재명을 입력하세요.");
                return;
            }
            if (document.frmMain.order_type.value == "") {
                alert("자재 재질을 선택하세요.");
                return;
            }
            if (document.frmMain.order_length.value == "") {
                alert("자재 길이를 선택하세요.");
                return;
            } else {
                document.frmMain.submit();
            }
        }

        // 부서 필터링
        function filterByDept() {
            const selectedDept = document.getElementById("deptFilter").value;
            location.href = "<%= page_name %>" + "filterDept=" + selectedDept;
        }

        // 자재명 검색
        function searchByName() {
            const searchWord = document.getElementById("searchWord").value;
            const selectedDept = document.getElementById("deptFilter").value;
            location.href = "<%= page_name %>" + "filterDept=" + selectedDept + "&SearchWord=" + encodeURIComponent(searchWord);
        }
    </script>
  </head>
  <body class="sb-nav-fixed">
    <!--#include virtual="/inc/top.asp"-->
    <!--#include virtual="/inc/left.asp"-->

    <div id="layoutSidenav_content">
      <main>
        <div class="container-fluid px-4">
          <div class="container-flex">
            <!-- 왼쪽 섹션: 자재 등록 폼 -->
            <div class="left-section">
              <div class="py-5 container text-center">
                <h3>자재등록</h3>
                <form name="frmMain" action="khorderdb.asp" method="post">
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <div class="input-group">
                        <span class="input-group-text">부서</span>
                        <select class="form-select" name="order_dept">
                          <option value="1">도어</option>
                          <option value="2">프레임</option>
                          <option value="3">시스템도어</option>
                          <option value="4">자동문</option>
                          <option value="5">보호대</option>
                          <option value="6">기타</option>
                        </select>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="input-group">
                        <span class="input-group-text">자재명&nbsp;&nbsp;&nbsp;</span>
                        <input type="text" class="form-control" name="order_name" value="">
                      </div>
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <div class="input-group">
                        <span class="input-group-text">자재길이</span>
                        <select class="form-select" name="order_length">
                          <option value="0">없음</option>
                          <option value="1">2,200mm</option>
                          <option value="2">2,400mm</option>
                          <option value="3">2,500mm</option>
                          <option value="4">2,800mm</option>
                          <option value="5">3,000mm</option>
                          <option value="6">3,200mm</option>
                        </select>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="input-group">
                        <span class="input-group-text">자재재질</span>
                        <select class="form-select" name="order_type">
                          <option value="0">없음</option>
                          <option value="1">무피</option>
                          <option value="2">백피</option>
                          <option value="3">블랙</option>
                        </select>
                      </div>
                    </div>
                  </div>
                  <div class="input-group mb-3">
                    <button type="button" class="btn btn-outline-primary" onclick="validateForm();">등록</button>
                    <button type="button" class="btn btn-outline-danger" onclick="location.replace('khorderlist.asp');">리스트</button>
                  </div>
                </form>
              </div>
            </div>

            <!-- 오른쪽 섹션: 자재 목록 -->
            <div class="right-section">
              <div class="py-1 container text-center card card-body">
                <h3>자재 목록</h3>

                <!-- 부서 및 자재명 필터 -->
                <div class="py-3" style="text-align: right;">
                  <label for="deptFilter" class="form-label" style="font-size: 12px; margin-right: 10px;">부서 필터:</label>
                  <select id="deptFilter" class="form-select" style="width: 150px; font-size: 12px; padding: 3px 5px; display: inline-block;" onchange="filterByDept()">
                    <option value="" <% If filterDept = "" Then Response.Write("selected") %>>전체</option>
                    <option value="1" <% If filterDept = "1" Then Response.Write("selected") %>>도어</option>
                    <option value="2" <% If filterDept = "2" Then Response.Write("selected") %>>프레임</option>
                    <option value="3" <% If filterDept = "3" Then Response.Write("selected") %>>시스템도어</option>
                    <option value="4" <% If filterDept = "4" Then Response.Write("selected") %>>자동문</option>
                    <option value="5" <% If filterDept = "5" Then Response.Write("selected") %>>보호대</option>
                    <option value="6" <% If filterDept = "6" Then Response.Write("selected") %>>기타</option>
                  </select>
                  <input type="text" id="searchWord" class="form-control d-inline" style="width: 200px; display: inline-block; margin-left: 10px;" placeholder="자재명 검색" value="<%=SearchWord%>">
                  <button type="button" class="btn btn-outline-secondary" onclick="searchByName()">검색</button>
                </div>

                <!-- 자재 테이블 -->
                <div class="input-group mb-3">
                  <table id="datatablesSimple" class="table table-hover">
                    <thead>
                      <tr>
                        <th align="center">번호</th>
                        <th align="center">부서</th>
                        <th align="center">자재명</th>
                        <th align="center">자재길이</th>
                        <th align="center">재질</th>
                        <th align="center">사용여부</th>
                        <th align="center">등록일</th>
                        <th align="center">종료일</th>
                        <th align="center">관리</th>
                      </tr>
                    </thead>
                    <tbody>
<%
if not (Rs.EOF or Rs.BOF) then

Rs.PageSize = 12
totalpage = Rs.PageCount
' gotopage 값 검증
If gotopage < 1 Then gotopage = 1
If gotopage > totalpage Then gotopage = totalpage
                        
' 현재 페이지 첫 번째 레코드 번호 계산
no = Rs.recordcount - (Rs.pagesize * (gotopage - 1)) + 1
Rs.AbsolutePage = gotopage
                        
i = 1
for j = i to Rs.RecordCount
if i > Rs.PageSize then exit for end if
                        
order_idx = Rs(0)
order_name = Rs(1)
order_length = Rs(2)
order_type = Rs(3)
order_date = Rs(4)
order_status = Rs(5)
order_fdate = Rs(6)
order_dept = Rs(7)
                        

select case order_length
    case "0": length_text = "없음"
    case "1": length_text = "2,200mm"
    case "2": length_text = "2,400mm"
    case "3": length_text = "2,500mm"
    case "4": length_text = "2,800mm"
    case "5": length_text = "3,000mm"
    case "6": length_text = "3,200mm"
end select 
select case order_type
    case "0": type_text = "없음"
    case "1": type_text = "무피"
    case "2": type_text = "백피"
    case "3": type_text = "블랙"
end select                        
select case order_status
    case "0": order_status_text = "사용안함"
    case "1": order_status_text = "사용중"
end select                        
select case order_dept
    case "1": dept_text = "도어"
    case "2": dept_text = "프레임"
    case "3": dept_text = "시스템도어"
    case "4": dept_text = "자동문"
    case "5": dept_text = "보호대"
    case "6": dept_text = "기타"
end select
%>
        <tr>
            <td><%=no - j%></td>
            <td><%=dept_text%></td>
            <td><%=order_name%></td>
            <td><%=length_text%></td>
            <td><%=type_text%></td>
            <td><%=order_status_text%></td>
            <td><%=order_date%></td>
            <td><% if order_fdate <> "1900-01-01" then %><%=order_fdate%><% end if %></td>
            <td>
                <button type="button" class="btn btn-primary" onclick="location.replace('khorderudt.asp?order_idx=<%=order_idx%>')">관리</button>
            </td>
        </tr>
<%
i = i + 1
Rs.MoveNext
next
Else
' 결과가 없을 경우 메시지 출력
%>
        <tr>
            <td colspan="9" style="text-align:center;">검색 결과가 없습니다.</td>
        </tr>
<%
end if
%>
                        
                    </tbody>
                  </table>
                </div>
                <div class="row col-12 py-3">
                  <nav aria-label="Page navigation example">
                    <!--#include Virtual = "/inc/paging1.asp"-->
                  </nav>
                </div>
              </div>
            </div>
          </div>
          Coded By 호영
        </main>
<%
set RsC = Nothing
set Rs = Nothing
set Rs1 = Nothing
set Rs2 = Nothing
set Rs3 = Nothing
call dbClose()
%>
      </body>
    </html>
