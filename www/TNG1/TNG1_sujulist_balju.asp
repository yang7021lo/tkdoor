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
  projectname="수주목록"

  rsjcidx=request("sjcidx")
  rsjmidx=request("sjmidx")
  rsjidx=request("sjidx")
%>

<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


SearchWord=Request("SearchWord")
gubun=Request("gubun")


	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	' page_name="TNG1_sujulist_balju.asp?listgubun="&listgubun&"&"


SearchWord = Trim(Request("SearchWord"))
startDate  = Trim(Request("startDate"))
endDate    = Trim(Request("endDate"))
searchItem = Trim(Request("searchItem"))
qtyFilter = Trim(Request("qtyFilter"))

page_name = "TNG1_sujulist_balju.asp?listgubun=" & listgubun _
            & "&SearchWord=" & Server.URLEncode(SearchWord) _
            & "&startDate=" & startDate _
            & "&endDate=" & endDate _
            & "&searchItem=" & searchItem _
            & "&qtyFilter=" & qtyFilter & "&"

Dim RsQty, SQLQty
Set RsQty = Server.CreateObject("ADODB.Recordset")

SQLQty = "SELECT DISTINCT A.qtyidx, B.QTYNo, B.qtyname " _
      & "FROM tk_qty A " _
      & "JOIN tk_qtyco B ON A.QTYNo = B.QTYNo " _
      & "WHERE B.qtyname <> '' AND A.qtystatus = '1' " _
      & "ORDER BY B.QTYNo ASC"


RsQty.Open SQLQty, Dbcon, 1, 1

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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        .btn-small {
            font-size: 14px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 22px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
        .btn-running {
                background-color: #dc3545 !important;
                border-color: #dc3545 !important;
                color: #fff !important;
        }
        #datatablesSimple thead th,
        #datatablesSimple tbody td {
            white-space: nowrap;
        }
    </style>

</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->

<div id="layoutSidenav_content">
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->

<div class="row mb-3">

    <div class="col-12">

        <form id="dataForm" action="TNG1_sujulist_balju.asp" method="GET">

        <input type="hidden" name="writerSort" id="writerSort" value="<%=Request("writerSort")%>">
        <input type="hidden" name="wdateSort" id="wdateSort" value="<%=Request("wdateSort")%>">

            <div class="input-group">

                <!-- 검색어 -->
                <span class="input-group-text">검색</span>
                <input type="text" class="form-control" name="SearchWord" id="SearchWord"
                    placeholder="업체명,사업자번호,현장명으로 검색"
                    value="<%=Request("SearchWord")%>">

                <span class="input-group-text">제품명</span>
                <input type="text" class="form-control" name="searchItem" id="searchItem" style="min-width:200px; max-width:200px;"
                    placeholder=""
                    value="<%=Request("searchItem")%>">

                <span class="input-group-text">재질</span>
                <select class="form-select w-auto" name="qtyFilter" id="qtyFilter"
                style="min-width:150px; max-width:150px;">

                    <option value="" <% If qtyFilter = "" Then Response.Write("selected") %>>전체</option>

                    <%
                        If Not (RsQty.EOF Or RsQty.BOF) Then
                        Do Until RsQty.EOF
                        qNo   = RsQty("QTYNo")
                        qName = RsQty("qtyname")
                    %>

                    <option value="<%=qNo%>" <% If CStr(qtyFilter) = CStr(qNo) Then Response.Write("selected") %>>
                        <%=qName%>
                    </option>

                    <%
                        RsQty.MoveNext
                        Loop
                        End If
                    %>

                </select>
                <!-- 시작일 -->
                <span class="input-group-text">시작일</span>
                <input type="date" class="form-control" name="startDate" id="startDate"
                    value="<%=Request("startDate")%>">

                <!-- 종료일 -->
                <span class="input-group-text">종료일</span>
                <input type="date" class="form-control" name="endDate" id="endDate"
                    value="<%=Request("endDate")%>">

                <!-- 날짜 초기화 버튼 -->
                <button class="btn btn-secondary" type="button" onclick="resetAll()">
                초기화
                </button>

                <!-- 검색 실행 -->
                <button class="btn btn-primary" type="submit">
                    검색
                </button>

                <!-- 수주서 생성 -->
                <button type="button" class="btn btn-success"
                    onclick="location.replace('/tng1/TNG1_B.asp?mode=suju_kyun_status');">
                    수주서생성
                </button>

            </div>

        </form>
    </div>
</div>
          <!-- input 형식 끝-->
          <button type="submit" id="hiddenSubmit" style="display: none;"></button>
          </form>
        </div>
      </div>
<!-- 표 형식 시작-->
        <div class="table-responsive mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th class="text-center">수주일자</th>
                      <th class="text-center">수주번호</th>
                      <th class="text-center">거래처</th>
                      <th class="text-center">출고일</th>
                      <th class="text-center">도어출고</th>
                      <th class="text-center">재질</th>
                      <th class="text-center">출고방식</th>
                      <th class="text-center">현장명</th>
                      <th class="text-center">설정</th>
                      <th class="text-center">거래처담당자</th>
                      <th class="text-center">
                          <button type="button" onclick="sortWriter()" style="background : none; border : none;">
                              최종작성자
                              <% If Request("writerSort") = "0" Then %> =<% End If %>
                              <% If Request("writerSort") = "" Then %> =<% End If %>
                              <% If Request("writerSort") = "1" Then %> ▲<% End If %>
                              <% If Request("writerSort") = "2" Then %> ▼<% End If %>
                          </button>
                      </th>

                      <th class="text-center">
                          <button type="button" onclick="sortWdate()" style="background : none; border : none;">
                              최종작성일
                              <% If Request("wdateSort") = "0" Then %> =<% End If %>
                              <% If Request("wdateSort") = "" Then %> =<% End If %>
                              <% If Request("wdateSort") = "1" Then %>▲<% End If %>
                              <% If Request("wdateSort") = "2" Then %>▼<% End If %>
                          </button>
                      </th>

                      <!-- ✅ (추가) 견적 컬럼 -->
                      <th class="text-center">견적</th>

                      <th class="text-center">수주서</th>
                      <th class="text-center">스티커출력</th>
                  </tr>
              </thead>
              <tbody>
<form id="dataForm" action="test0123db.asp" method="POST">
<input type="hidden" name="midx" value="<%=rmidx%>">

<%
SearchWord = Trim(Request("SearchWord"))
startDate  = Trim(Request("startDate"))
endDate    = Trim(Request("endDate"))
searchItem = Trim(Request("searchItem"))
qtyFilter  = Trim(Request("qtyFilter"))

SQL = " SELECT " _
    & " A.sjidx, A.sjdate, A.sjnum, " _
    & " CONVERT(VARCHAR(10), A.cgdate, 121) AS cgdate, " _
    & " CONVERT(VARCHAR(10), A.djcgdate, 121) AS djcgdate, " _
    & " A.cgtype, A.cgaddr, A.cgset, A.sjmidx, A.sjcidx, " _
    & " A.midx, CONVERT(VARCHAR(10), A.wdate, 121) AS wdate, " _
    & " A.meidx, CONVERT(VARCHAR(10), A.mewdate, 121) AS mewdate, " _
    & " B.cname, C.mname, D.mname, E.mname, " _
    & " A.suju_kyun_status, ISNULL(A.balju_status, 0) AS balju_status, ISNULL(A.sticker_status, 0) AS sticker_status, " _
    & " ISNULL(FK.sjb_type_no, 0) AS sjb_type_no, " _
    & " ISNULL(A.move, '') AS move " _ 
    & " FROM tng_sja A " _
    & " JOIN tk_customer B ON A.sjcidx = B.cidx " _
    & " JOIN tk_member C ON A.sjmidx = C.midx " _
    & " JOIN tk_member D ON A.midx = D.midx " _
    & " JOIN tk_member E ON A.meidx = E.midx " _
    & " OUTER APPLY ( " _
    & "     SELECT TOP 1 F.sjb_type_no " _
    & "     FROM tk_framek F " _
    & "     WHERE F.sjidx = A.sjidx " _
    & "     ORDER BY F.sjb_type_no ASC  " _
    & " ) FK " _
    & " WHERE A.suju_kyun_status = '0' "

' 제품명 검색 (JOIN 말고 EXISTS)
If SearchItem <> "" Then
    SQL = SQL _
        & " AND EXISTS ( " _
        & "     SELECT 1 " _
        & "     FROM tk_framek F2 " _
        & "     JOIN tng_sjbtype T ON F2.sjb_type_no = T.sjb_type_no " _
        & "     WHERE F2.sjidx = A.sjidx " _
        & "       AND T.sjb_type_name LIKE '%" & SearchItem & "%' " _
        & " ) "
End If


' 업체 검색 (업체명, 사업자번호, 현장명)
If SearchWord <> "" Then
    SQL = SQL _
        & " AND ( B.cname   LIKE '%" & SearchWord & "%' " _
        & " OR B.cnumber   LIKE '%" & SearchWord & "%' " _
        & " OR A.cgaddr   LIKE '%" & SearchWord & "%' ) "
End If

' 재질 검색
If qtyFilter <> "" Then
    SQL = SQL _
        & " AND A.sjidx IN ( " _
        & "     SELECT DISTINCT F.sjidx " _
        & "     FROM tk_framek F " _
        & "     JOIN tk_qty Q ON F.qtyidx = Q.qtyidx " _
        & "     WHERE Q.QTYNo = '" & qtyFilter & "' " _
        & " ) "
End If

' 날짜 조건
If startDate <> "" Then
    SQL = SQL & " AND A.sjdate >= '" & startDate & "' "
End If

If endDate <> "" Then
    SQL = SQL & " AND A.sjdate <= '" & endDate & "' "
End If

writerSort = Request("writerSort")
wdateSort  = Request("wdateSort")

If writerSort = "1" Then
    SQL = SQL & " ORDER BY D.mname ASC "
ElseIf writerSort = "2" Then
    SQL = SQL & " ORDER BY D.mname DESC "

ElseIf wdateSort = "1" Then
    SQL = SQL & " ORDER BY A.mewdate ASC "

ElseIf wdateSort = "2" Then
    SQL = SQL & " ORDER BY A.mewdate DESC "

Else
    SQL = SQL & " ORDER BY A.sjidx DESC "
End If

Rs.open SQL, Dbcon, 1,1,1

If Rs.EOF Then
%>
    <tr>
        <!-- ✅ (변경) 컬럼 15개로 늘어서 colspan=15 -->
        <td colspan="15" class="text-center text-danger fw-bold py-4">
            일치하는 검색 결과가 없습니다.
        </td>
    </tr>
<%
Else
    Rs.PageSize = 20
    no = Rs.recordcount - (Rs.pagesize * (gotopage-1)) + 1
    totalpage = Rs.PageCount
    Rs.AbsolutePage = gotopage
    i = 1

    end if
    Rs.PageSize = 20

    if not (Rs.EOF or Rs.BOF ) then
    no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
    totalpage=Rs.PageCount
    Rs.AbsolutePage =gotopage
    i=1
    for j=1 to Rs.RecordCount
    if i>Rs.PageSize then exit for end if
    if no-j=0 then exit for end if

  sjidx=Rs(0)
  sjdate=Rs(1)
  sjnum=Rs(2)
  cgdate=Rs(3)
  djcgdate=Rs(4)
  cgtype=Rs(5)
    Select Case CInt(cgtype)
        Case 1
            cgtype_text = "화물"
        Case 2
            cgtype_text = "낮1배달"
        Case 3
            cgtype_text = "낮2배달"
        Case 4
            cgtype_text = "밤1배달"
        Case 5
            cgtype_text = "밤2배달"
        Case 6
            cgtype_text = "대구창고"
        Case 7
            cgtype_text = "대전창고"
        Case 8
            cgtype_text = "부산창고"
        Case 9
            cgtype_text = "양산창고"
        Case 10
            cgtype_text = "익산창고"
        Case 11
            cgtype_text = "원주창고"
        Case 12
            cgtype_text = "제주창고"
        Case Else
            cgtype_text = "미지정"
    End Select

  cgaddr=Rs(6)
  cgset=Rs(7)
  select case cgset
  case "0"
    cgset_text="X"
  case "1"
    cgset_text="O"
  end select

  sjmidx=Rs(8)
  sjcidx=Rs(9)
  midx=Rs(10)
  wdate=Rs(11)
  meidx=Rs(12)
  mewdate=Rs(13)
  cname=Rs(14)
  amname=Rs(15)
  bmname=Rs(16)
  cmname=Rs(17)
  suju_kyun_status=Rs(18)
  balju_status=Rs(19)
  sticker_status=Rs(20)
  sjb_type_no=Rs(21)
  move=Rs(22) ' ✅ (추가) 견적으로 이동용 sjidx

%>

                  <tr>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=Mid(sjdate,6,2)%>/<%=Right(sjdate,2)%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=sjnum%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cname%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=Mid(cgdate,6,2)%>/<%=Right(cgdate,2)%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=Mid(djcgdate,6,2)%>/<%=Right(djcgdate,2)%></a></td>
                      <td class="text-center">재질</td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cgtype_text%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cgaddr%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cgset_text%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=amname%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cmname%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=Mid(mewdate,6,2)%>/<%=Right(mewdate,2)%></a></td>

                      <!-- ✅ (추가) 견적으로 이동 버튼 -->
                      <td class="text-center">
                        <% If move <> "" And Not IsNull(move) Then %>
                          <a href="TNG1_B.asp?sjidx=<%=move%>&suju_kyun_status=1" class="btn btn-outline-primary btn-small">→</a>
                        <% Else %>
                          -
                        <% End If %>
                      </td>

                    <td class="text-center">
                        <% If IsNull(balju_status) Or balju_status = 0 Then %>
                            <button
                                type="button"
                                class="btn btn-running btn-small"
                                onclick="openPopup(
                                '/tng1/TNG1_sujuCheck.asp?sjcidx=<%=sjcidx%>&sjidx=<%=sjidx%>&sjb_type_no=<%=sjb_type_no%>&balju_status=<%=balju_status%>'
                                );">
                                미출력
                            </button>
                            <% Else %>
                            <button
                                type="button"
                                class="btn btn-success btn-small"
                                onclick="openPopup(
                                '/tng1/TNG1_sujuCheck.asp?sjcidx=<%=sjcidx%>&sjidx=<%=sjidx%>&sjb_type_no=<%=sjb_type_no%>&balju_status=<%=balju_status%>'
                                );">
                                출력
                            </button>
                        <% End If %>
                    </td>
                      <%If sticker_status = 0 or IsNull(sticker_status) Then%>
                        <td class="text-center"><button class="btn btn-running btn-small" type="button" onclick="openPopup('/documents/sticker/35mm.asp?sjidx=<%= Server.URLEncode(CStr(sjidx)) %>&sticker_status=<%=sticker_status%>');">미출력</button></td>
                      <%Else%>
                        <td class="text-center"><button class="btn btn-success btn-small" type="button" onclick="openPopup('/documents/sticker/35mm.asp?sjidx=<%= Server.URLEncode(CStr(sjidx)) %>&sticker_status=<%=sticker_status%>');">출력</button></td>
                      <%End If%>
                  </tr>

<%
Rs.MoveNext
i=i+1
Next
End if

%>
<button type="submit" id="hiddenSubmit" style="display: none;"></button>
</form>
              </tbody>
          </table>

        </div>
        <div class="row">
          <div  class="col-12 py-3">
                <!--#include Virtual = "/inc/paging.asp" -->
          </div>
        </div>
<%
Rs.Close
%>
<!-- 표 형식 끝-->


    </div>

<!-- 내용 입력 끝 -->
        </div>
    </div>
</main>
<!-- footer 시작 -->
Coded By 양양
<!-- footer 끝 -->
</div>


<script>
function openPopup(url) {
  const opt = [
    'width=1200',
    'height=900',
    'top=80',
    'left=120',
    'resizable=yes',
    'scrollbars=yes'
  ].join(',');

  window.open(url, 'openPopup', opt);

  location.reload();
}

function resetAll() {
    document.getElementById("SearchWord").value = "";
    document.getElementById("searchItem").value = "";
    document.getElementById("startDate").value = "";
    document.getElementById("endDate").value = "";

    location.href = "TNG1_sujulist_balju.asp";
}

function sortWriter() {
    let now = parseInt(document.getElementById("writerSort").value) || 0;
    let next = (now + 1) % 3;
    document.getElementById("writerSort").value = next;

    document.getElementById("wdateSort").value = 0;

    document.getElementById("dataForm").submit();
}

function sortWdate() {
    let now = parseInt(document.getElementById("wdateSort").value) || 0;
    let next = (now + 1) % 3;
    document.getElementById("wdateSort").value = next;

    document.getElementById("writerSort").value = 0;

    document.getElementById("dataForm").submit();
}
</script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
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
