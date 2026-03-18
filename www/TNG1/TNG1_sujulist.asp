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


  if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
  end if
  
  listgubun="one" 
  projectname="견적목록"

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
	' page_name="TNG1_sujulist.asp?SearchWord="&SearchWord&"&

SearchWord = Trim(Request("SearchWord"))
startDate  = Trim(Request("startDate"))
endDate    = Trim(Request("endDate"))
searchItem = Trim(Request("searchItem"))
qtyFilter = Trim(Request("qtyFilter"))

page_name = "TNG1_sujulist.asp?listgubun=" & listgubun _
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

          <form id="dataForm" action="TNG1_sujulist.asp" method="GET">   

        <input type="hidden" name="writerSort" id="writerSort" value="<%=Request("writerSort")%>">
        <input type="hidden" name="wdateSort" id="wdateSort" value="<%=Request("wdateSort")%>">
            
            <div class="input-group">

                <span class="input-group-text">검색</span>
                <input type="text" class="form-control" name="SearchWord" id="SearchWord"
                placeholder="업체명,사업자번호,현장명"
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

                <!-- 견적서 생성: suju_kyun_status=1 로 견적 생성 페이지 오픈 -->
                <button type="button" class="btn btn-primary"
                        onclick="location.replace('/tng1/TNG1_B.asp?suju_kyun_status=1');"
                        gap-2>
                  견적서생성
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
                      <th class="text-center">견적번호</th>
                      <th class="text-center">거래처</th>
                      <th class="text-center">출고일</th>
                      <th class="text-center">도장출고일</th> 
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
                      <th class="text-center">수주</th>
                      <th class="text-center">견적서</th> 
                      <th class="text-center">WMS</th> 
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
qtyFilter = Trim(Request("qtyFilter"))

SQL=" Select A.sjidx, A.sjdate, A.sjnum, Convert(Varchar(10),A.cgdate,121), Convert(Varchar(10),A.djcgdate,121) "
SQL=SQL&" , A.cgtype, A.cgaddr, A.cgset, A.sjmidx, A.sjcidx "
SQL=SQL&" , A.midx, Convert(Varchar(10),A.wdate,121), A.meidx, Convert(Varchar(10),A.mewdate,121) "
SQL=SQL&" , B.cname, C.mname, D.mname, E.mname, A.suju_kyun_status, A.move "
SQL=SQL&" From tng_sja A "
SQL=SQL&" Join tk_customer B On A.sjcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.sjmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "

' SQL = SQL & " WHERE A.suju_kyun_status = '1' "

' 제품 검색이 있을 때만 JOIN
If SearchItem <> "" Then
    SQL = SQL _
        & " JOIN ( " _
        & "     SELECT DISTINCT F.sjidx " _
        & "     FROM tk_framek F " _
        & "     JOIN tng_sjbtype T ON F.sjb_type_no = T.sjb_type_no " _
        & "     WHERE T.sjb_type_name LIKE '%" & SearchItem & "%' " _
        & " ) F ON A.sjidx = F.sjidx "
End If

SQL = SQL & " WHERE 1 = 1 "
SQL = SQL & " AND A.suju_kyun_status = '1' "

' 업체 검색 (업체명, 사업자번호, 현장명)
If SearchWord <> "" Then
    SQL = SQL _
        & " AND ( B.cname   LIKE '%" & SearchWord & "%' " _
        & " OR B.cnumber   LIKE '%" & SearchWord & "%' " _
        & " OR A.cgaddr   LIKE '%" & SearchWord & "%' ) " 
        ' & " OR B.cmemo     LIKE '%" & SearchWord & "%' ) "
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
    SQL = SQL & " ORDER BY A.mewdate ASC   "

ElseIf wdateSort = "2" Then
    SQL = SQL & " ORDER BY A.mewdate DESC "

Else
    ' 기본정렬
    SQL = SQL & " ORDER BY A.sjidx DESC "
End If



' 실행
Rs.open SQL, Dbcon, 1,1,1

' 📌 검색 결과 없음 처리
If Rs.EOF Then
%>
    <tr>
        <td colspan="14" class="text-center text-danger fw-bold py-4">
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
	totalpage=Rs.PageCount '		
	Rs.AbsolutePage =gotopage
	i=1
	for j=1 to Rs.RecordCount 
	if i>Rs.PageSize then exit for end if
	if no-j=0 then exit for end if

  sjidx=Rs(0) '발주키
  sjdate=Rs(1)  '발주일
  sjnum=Rs(2) '발주번호
  cgdate=Rs(3)  '출고일
  djcgdate=Rs(4)  '도장출고일
  cgtype=Rs(5)  '출고방식
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
        Case 13
            cgtype_text = "용차"
        Case 14
            cgtype_text = "방문"
        Case 15
            cgtype_text = "1공장"
        Case 16
            cgtype_text = "인천항"
        Case Else
            cgtype_text = "미지정"
    End Select
                       

  cgaddr=Rs(6)  '출고현장
  cgset = Rs(7) '입금후출고설정
  Select Case cgset
    Case "1"
      cgset_text = "O"
    Case Else
      cgset_text = "X"
  End Select
    


  sjmidx=Rs(8)  '거래처담당자키
  sjcidx=Rs(9)  '거래처 키
  midx=Rs(10) '작성자키
  wdate=Rs(11)  '작성일
  meidx=Rs(12)  '수정자키
  mewdate=Rs(13)  '수정일
  cname=Rs(14)  '거래처명
  amname=Rs(15) '거래처담당자명
  bmname=Rs(16) '작성자명
  cmname=Rs(17) '수정자명
  suju_kyun_status=Rs(18) '수주/견적 구분 (0:수주, 1:견적)
  move=Rs(19) '연결된 수주/견적 idx


%>              

                  <tr>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=Left(sjdate,4)%><%=Mid(sjdate,6,2)%><%=Right(sjdate,2)%>-<%=sjnum%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cname%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=Mid(cgdate,6,2)%>/<%=Mid(cgdate,9,2)%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=Mid(djcgdate,6,2)%>/<%=Mid(djcgdate,9,2)%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cgtype_text%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cgaddr%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cgset_text%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=amname%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=cmname%></a></td>
                      <td class="text-center"><a href="TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>&suju_kyun_status=<%=suju_kyun_status%>"><%=Mid(mewdate,6,2)%>/<%=Mid(mewdate,9,2)%></a></td>
                      <td class="text-center">
                          <% If move <> "" And Not IsNull(move) Then %>
                              <a href="TNG1_B.asp?sjidx=<%=move%>&suju_kyun_status=0" class="btn btn-outline-primary btn-small">→</a>
                          <% Else %>
                              -
                          <% End If %>
                      </td>
                      <td class="text-center"><button class="btn btn-success btn-small" type="button" onclick="window.open('/TNG_WMS/TNG_WMS_Debug.asp?sjidx=<%=sjidx%>');">WMS_Debug</button></td>
                      <td class="text-center"><button class="btn btn-success btn-small" type="button" onclick="window.open('/TNG_WMS/TNG_WMS_List_all.asp?sjidx=<%=sjidx%>');">WMS_list</button></td>
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
function resetAll() {
    // 입력창 리셋
    document.getElementById("SearchWord").value = "";
    document.getElementById("searchItem").value = "";
    document.getElementById("startDate").value = "";
    document.getElementById("endDate").value = "";

    // 페이지 파라미터 초기화하여 새로고침
    location.href = "TNG1_sujulist_balju.asp";

}
    
function sortWriter() {
    let now = parseInt(document.getElementById("writerSort").value) || 0;
    let next = (now + 1) % 3; // 0→1→2→0
    document.getElementById("writerSort").value = next;

    // 다른 정렬 초기화
    document.getElementById("wdateSort").value = 0;

    document.getElementById("dataForm").submit();
}

function sortWdate() {
    let now = parseInt(document.getElementById("wdateSort").value) || 0;
    let next = (now + 1) % 3; // 0→1→2→0
    document.getElementById("wdateSort").value = next;

    // 다른 정렬 초기화
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