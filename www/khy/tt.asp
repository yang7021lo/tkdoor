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

Set RsC = Server.CreateObject("ADODB.Recordset")
Set Rs = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")
Set Rs3 = Server.CreateObject("ADODB.Recordset")

listgubun = "four"
projectname = "자재등록"

' 검색 및 필터 변수
SearchWord = Request("SearchWord")
filterDept = Request("filterDept")
gotopage = Request("gotopage")

' 페이지 값 검증 (수정된 부분)
If gotopage = "" Then
    gotopage = 1
Else
    gotopage = cint(gotopage)
End If

' 기본 SQL 쿼리 생성
SQL = "SELECT order_idx, order_name, order_length, order_type, Convert(varchar(10), order_date, 121), order_status, order_fdate, order_dept FROM tk_khyorder"

' WHERE 조건 추가
whereClause = ""

If filterDept <> "" Then
    whereClause = whereClause & "order_dept = " & filterDept
End If

If SearchWord <> "" Then
    If whereClause <> "" Then
        whereClause = whereClause & " AND "
    End If
    whereClause = whereClause & "CHARINDEX('" & Replace(SearchWord, "'", "''") & "', order_name) > 0"
End If

If whereClause <> "" Then
    SQL = SQL & " WHERE " & whereClause
End If

SQL = SQL & " ORDER BY order_idx DESC"

' 쿼리 실행
Rs.Open SQL, Dbcon, 1, 1

' 페이지네이션 로직 (수정된 부분)
If Rs.EOF And Rs.BOF Then
    totalpage = 0
Else
    Rs.PageSize = 12
    totalpage = Rs.PageCount

    ' gotopage 값 검증
    If gotopage < 1 Then gotopage = 1
    If gotopage > totalpage Then gotopage = totalpage

    Rs.AbsolutePage = gotopage
End If

' 페이징 URL 생성 (수정된 부분)
page_name = "tts.asp?listgubun=" & listgubun & "&filterDept=" & filterDept & "&SearchWord=" & Server.URLEncode(SearchWord) & "&"
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title><%=projectname%></title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script>
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
  <body>
    <div class="container-fluid px-4">
      <div class="container-flex">
        <!-- 자재 목록 -->
        <div class="right-section">
          <h3>자재 목록</h3>
          <div>
            <!-- 부서 및 자재명 필터 -->
            <label for="deptFilter">부서 필터:</label>
            <select id="deptFilter" onchange="filterByDept()">
              <option value="" <% If filterDept = "" Then Response.Write("selected") %>>전체</option>
              <option value="1" <% If filterDept = "1" Then Response.Write("selected") %>>도어</option>
              <option value="2" <% If filterDept = "2" Then Response.Write("selected") %>>프레임</option>
              <option value="3" <% If filterDept = "3" Then Response.Write("selected") %>>시스템도어</option>
              <option value="4" <% If filterDept = "4" Then Response.Write("selected") %>>자동문</option>
              <option value="5" <% If filterDept = "5" Then Response.Write("selected") %>>보호대</option>
              <option value="6" <% If filterDept = "6" Then Response.Write("selected") %>>기타</option>
            </select>
            <input type="text" id="searchWord" placeholder="자재명 검색" value="<%=SearchWord%>" />
            <button onclick="searchByName()">검색</button>
          </div>

          <table>
            <thead>
              <tr>
                <th>번호</th>
                <th>부서</th>
                <th>자재명</th>
                <th>자재길이</th>
                <th>재질</th>
                <th>사용여부</th>
                <th>등록일</th>
                <th>종료일</th>
                <th>관리</th>
              </tr>
            </thead>
            <tbody>
<%
If Not (Rs.EOF Or Rs.BOF) Then
    no = Rs.RecordCount - (Rs.PageSize * (gotopage - 1))
    For i = 1 To Rs.PageSize
        If Rs.EOF Then Exit For

        order_idx = Rs("order_idx")
        order_name = Rs("order_name")
        order_length = Rs("order_length")
        order_type = Rs("order_type")
        order_date = Rs("order_date")
        order_status = Rs("order_status")
        order_fdate = Rs("order_fdate")
        order_dept = Rs("order_dept")

        ' 데이터 변환 로직
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
            case "0": status_text = "사용안함"
            case "1": status_text = "사용중"
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
                <td><%=no%></td>
                <td><%=dept_text%></td>
                <td><%=order_name%></td>
                <td><%=length_text%></td>
                <td><%=type_text%></td>
                <td><%=status_text%></td>
                <td><%=order_date%></td>
                <td><%=order_fdate%></td>
                <td><button onclick="location.replace('khorderudt.asp?order_idx=<%=order_idx%>')">관리</button></td>
              </tr>
<%
        no = no - 1
        Rs.MoveNext
    Next
Else
%>
              <tr>
                <td colspan="9">검색 결과가 없습니다.</td>
              </tr>
<%
End If
%>
            </tbody>
          </table>

          <!-- 페이징 네비게이션 -->
          <nav>
            <ul class="pagination">
<%
If gotopage > 1 Then
%>
              <li><a href="<%=page_name%>gotopage=<%=gotopage - 1%>">&laquo;</a></li>
<%
End If

For i = 1 To totalpage
    If i = gotopage Then
%>
              <li class="active"><a href="#"><%=i%></a></li>
<%
    Else
%>
              <li><a href="<%=page_name%>gotopage=<%=i%>"><%=i%></a></li>
<%
    End If
Next

If gotopage < totalpage Then
%>
              <li><a href="<%=page_name%>gotopage=<%=gotopage + 1%>">&raquo;</a></li>
<%
End If
%>
            </ul>
          </nav>
        </div>
      </div>
    </div>
<%
Set Rs = Nothing
call dbClose()
%>
  </body>
</html>
