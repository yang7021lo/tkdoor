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
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

rupidx = request("upidx")
gubun = request("gubun")
astep = Request("astep")
sdate = Request("sdate")
fdate = Request("fdate")
fdate_set = Request("fdate_set")
fdate_update = Request("fdate_update")

Response.Write "gubun : " & gubun & "<br>"
Response.Write "astep : " & astep & "<br>"
Response.Write "sdate : " & sdate & "<br>"

'response.end



%>

<%
' 🔹 서버 측 스크립트 실행 최대 시간을 600초(10분)로 설정
'    - 기본은 90초인데, 루프가 길어지면 자동 중단되므로 늘려줘야 함
Server.ScriptTimeout = 600

' 🔹 ASP 출력 버퍼링을 활성화 (응답을 메모리에 모았다가 한 번에 출력)
'    - 중간중간 Response.Write로 너무 많은 출력이 있으면 브라우저가 느려지거나 오류 발생
'    - 이걸 True로 하면 성능 안정성 ↑
Response.Buffer = True
%>

<%


If gubun = "win" Then

    ' ✅ Step 별로 i_max 계산
    Select Case astep
        Case "astep1"
            sql = "SELECT COUNT(*) FROM tng_sjbtype WHERE sjbtstatus = 1"
            Rs.Open sql, dbcon
            i_max = Rs(0)
            Rs.Close

        Case "astep2"
            sql = "SELECT COUNT(*) FROM tng_unitprice WHERE sdate = '" & sdate & "' AND sjbtidx IS NOT NULL"
            Rs.Open sql, dbcon
            sjbt_count = Rs(0)
            Rs.Close

            sql = "SELECT COUNT(*) FROM TNG_SJB WHERE SJB_IDX IS NOT NULL"
            Rs.Open sql, dbcon
            sjb_count = Rs(0)
            Rs.Close

            i_max = sjbt_count * sjb_count

        Case "astep3"
            sql = "SELECT COUNT(*) FROM tng_unitprice WHERE sdate = '" & sdate & "' AND sjbtidx IS NOT NULL AND SJB_IDX IS NOT NULL"
            Rs.Open sql, dbcon
            sjb_combo_count = Rs(0)
            Rs.Close

            sql = "SELECT COUNT(*) FROM tng_whichitype WHERE bfwstatus = 1 AND glassselect = 0"
            Rs.Open sql, dbcon
            bfwidx_count = Rs(0)
            Rs.Close

            i_max = sjb_combo_count * bfwidx_count

        Case "astep4"
            sql = "SELECT COUNT(*) FROM tng_unitprice WHERE sdate = '" & sdate & "' AND sjbtidx IS NOT NULL AND SJB_IDX IS NOT NULL AND bfwidx IS NOT NULL"
            Rs.Open sql, dbcon
            bfw_combo_count = Rs(0)
            Rs.Close

            sql = "SELECT COUNT(*) FROM tk_qty WHERE QTYSTATUS = 1"
            Rs.Open sql, dbcon
            qtyidx_count = Rs(0)
            Rs.Close

            i_max = bfw_combo_count * qtyidx_count

        Case "astep5"
            sql = "SELECT COUNT(*) FROM tng_unitprice WHERE sdate = '" & sdate & "' AND qtyco_idx IS NOT NULL AND bfwidx IS NOT NULL AND sjbtidx IS NOT NULL AND SJB_IDX IS NOT NULL"
            Rs.Open sql, dbcon
            qty_combo_count = Rs(0)
            Rs.Close

            sql = "SELECT COUNT(*) FROM tk_barasiF"
            Rs.Open sql, dbcon
            bfidx_count = Rs(0)
            Rs.Close

            i_max = qty_combo_count * bfidx_count

        Case Else
            i_max = 0
    End Select

    ' ✅ 15개씩 새창 열기
    For i = 1 To i_max
        aleft = 100 + (30 * ((i-1) Mod 15))
        atop = 100 + (30 * ((i-1) Mod 15))
        winname = "pop" & ((i-1) Mod 15) + 1

        Response.Write "<script>"
        Response.Write "window.open('unitpricedb.asp?i=" & i & "&astep=" & astep & "&sdate=" & sdate & "','"
        Response.Write winname & "','top=" & atop & ", left=" & aleft & ", width=300, height=300');"
        Response.Write "</script>"
    Next

    ' ✅ 전부 연 후 메인창 리다이렉트
    Response.Write "<script>alert('" & astep & " 완료');location.replace('unitprice.asp?sdate=" & sdate & "&astep=" & astep & "');</script>"

End If

If astep <> "" And sdate <> "" Then
  sql = "SELECT ISNULL(MAX(upidx), 0) + 1 FROM tng_unitprice"
  Rs.Open sql, dbcon
  upidx = Rs(0)
  Rs.Close

    Select Case astep
        Case "astep1"
        sql = "SELECT DISTINCT A.sjbtidx "
        sql = sql & "FROM tng_sjbtype A "
        sql = sql & "WHERE A.sjbtstatus = 1"
        Rs.Open sql, dbcon
        Do Until Rs.EOF
            sjbtidx = Rs(0)

            sql1 = "INSERT INTO tng_unitprice (upidx, sjbtidx, price, upstatus, sdate, fdate) "
            sql1 = sql1 & "VALUES (" & upidx & ", " & sjbtidx & ", 0, 1, '" & sdate & "', NULL)"
            dbcon.Execute sql1

            upidx = upidx + 1
            Rs.MoveNext
        Loop
        Rs.Close

        Case "astep2"
            sql = "SELECT sjbtidx FROM tng_unitprice "
            sql = sql & "WHERE sdate = '" & sdate & "' "
            sql = sql & "AND sjbtidx IS NOT NULL "
            Rs1.Open sql, dbcon, 1, 1

            If Not (Rs1.EOF Or Rs1.BOF) Then
                Do While Not Rs1.EOF
                    sjbtidx = Rs1(0)

                    sql2 = "SELECT SJB_IDX FROM TNG_SJB WHERE SJB_IDX IS NOT NULL "
                    Rs2.Open sql2, dbcon, 1, 1

                    If Not (Rs2.EOF Or Rs2.BOF) Then
                        Do While Not Rs2.EOF
                            SJB_IDX = Rs2(0)

                            sql3 = "INSERT INTO tng_unitprice (upidx, sjbtidx,SJB_IDX, price, upstatus, sdate, fdate) "
                            sql3 = sql3 & "VALUES (" & upidx & ", " & sjbtidx & ", " & SJB_IDX & ", 0, 1, '" & sdate & "', NULL)"
                            dbcon.Execute sql3

                            upidx = upidx + 1
                        Rs2.MoveNext
                        Loop
                    End If
                    Rs2.Close

                Rs1.MoveNext
                Loop
            End If
            Rs1.Close

        Case "astep3"
        ' 🔹 astep2에서 만든 sjbtidx + SJB_IDX 기준 데이터 가져오기
        sql0 = "SELECT sjbtidx, SJB_IDX FROM tng_unitprice "
        ' 🔹 astep2에서 만든  SJB_IDX 에 NULL이 포함되어있음 그래서 웨어절에 AND SJB_IDX IS NOT NULL 이걸 추가했음
        sql0 = sql0 & "WHERE sdate = '" & sdate & "' "
        sql0 = sql0 & "AND sjbtidx IS NOT NULL AND SJB_IDX IS NOT NULL "
        Rs.Open sql0, dbcon
        If Not (Rs.EOF Or Rs.BOF) Then
            Do Until Rs.EOF
                sjbtidx = Rs(0)
                SJB_IDX = Rs(1)

                ' 🔹 bfwidx 전체 루프
                sql1 = "SELECT bfwidx FROM tng_whichitype WHERE bfwstatus = 1 AND glassselect = 0"
                Rs1.Open sql1, dbcon
                If Not (Rs1.EOF Or Rs1.BOF) Then
                    Do Until Rs1.EOF
                        bfwidx = Rs1(0)

                        ' 🔹 astep3 INSERT
                        sql2 = "INSERT INTO tng_unitprice (upidx, bfwidx, sjbtidx, SJB_IDX, price, upstatus, sdate, fdate) "
                        sql2 = sql2 & "VALUES (" & upidx & ", " & bfwidx & ", " & sjbtidx & ", " & SJB_IDX & ", 0, 1, '" & sdate & "', NULL)"
                        'Response.Write sql2 & "<br>"
                        'Response.End
                        dbcon.Execute sql2
                        upidx = upidx + 1
                        ' 🔹 인서트 수를 하나씩 카운팅
                        insertCount = insertCount + 1
                        ' 🔹 100건마다 브라우저에 중간 결과를 강제로 Flush
                        '    - 루프가 너무 길어질 때 서버/브라우저가 멈추는 걸 방지
                        '    - 중간에 서버가 "응답하고 있다"는 신호를 줘서 안정성 확보
                        If insertCount Mod 100 = 0 Then
                            Response.Flush
                        End If

                        Rs1.MoveNext
                    Loop
                End If
                Rs1.Close

                Rs.MoveNext
            Loop
        End If
        Rs.Close


        Case "astep4"
            ' 🔹 astep3 결과 기반 루프 (sjbtidx + SJB_IDX + bfwidx 조합)
            sql = "SELECT sjbtidx, SJB_IDX, bfwidx FROM tng_unitprice "
            sql = sql & "WHERE sdate = '" & sdate & "' "
            sql = sql & "AND sjbtidx IS NOT NULL AND SJB_IDX IS NOT NULL AND bfwidx IS NOT NULL"
            Rs.Open sql, dbcon
            If Not (Rs.EOF Or Rs.BOF) Then
                Do Until Rs.EOF
                    sjbtidx = Rs(0)
                    SJB_IDX = Rs(1)
                    bfwidx = Rs(2)

                    ' 🔹 QTYIDX 루프 (tk_qty)
                    sql1 = "SELECT QTYIDX FROM tk_qty WHERE QTYSTATUS = 1"
                    Rs1.Open sql1, dbcon
                    If Not (Rs1.EOF Or Rs1.BOF) Then
                        Do Until Rs1.EOF
                            qtyco_idx = Rs1(0)

                            sql2 = "INSERT INTO tng_unitprice (upidx, qtyco_idx, bfwidx, sjbtidx, SJB_IDX, price, upstatus, sdate, fdate) "
                            sql2 = sql2 & "VALUES (" & upidx & ", " & qtyco_idx & ", " & bfwidx & ", " & sjbtidx & ", " & SJB_IDX & ", 0, 1, '" & sdate & "', NULL)"
                            dbcon.Execute sql2
                            upidx = upidx + 1
                            ' 🔹 인서트 수를 하나씩 카운팅
                            insertCount = insertCount + 1
                            ' 🔹 100건마다 브라우저에 중간 결과를 강제로 Flush
                            '    - 루프가 너무 길어질 때 서버/브라우저가 멈추는 걸 방지
                            '    - 중간에 서버가 "응답하고 있다"는 신호를 줘서 안정성 확보
                            If insertCount Mod 100 = 0 Then
                                Response.Flush
                            End If

                            Rs1.MoveNext
                        Loop
                    End If
                    Rs1.Close

                    Rs.MoveNext
                Loop
            End If
            Rs.Close

        Case "astep5"
            ' 🔹 astep4 결과 기반 루프 (qtyco_idx + bfwidx + sjbtidx + SJB_IDX)
            sql = "SELECT qtyco_idx, bfwidx, sjbtidx, SJB_IDX FROM tng_unitprice "
            sql = sql & "WHERE sdate = '" & sdate & "' "
            sql = sql & "AND qtyco_idx IS NOT NULL AND bfwidx IS NOT NULL AND sjbtidx IS NOT NULL AND SJB_IDX IS NOT NULL"
            Rs.Open sql, dbcon
            If Not (Rs.EOF Or Rs.BOF) Then
                Do Until Rs.EOF
                    qtyco_idx = Rs(0)
                    bfwidx = Rs(1)
                    sjbtidx = Rs(2)
                    SJB_IDX = Rs(3)

                    ' 🔹 bfidx 루프 (tk_barasiF 테이블)
                    sql1 = "SELECT bfidx FROM tk_barasiF"
                    Rs1.Open sql1, dbcon
                    If Not (Rs1.EOF Or Rs1.BOF) Then
                        Do Until Rs1.EOF
                            bfidx = Rs1(0)

                            sql2 = "INSERT INTO tng_unitprice (upidx, bfidx, qtyco_idx, bfwidx, sjbtidx, SJB_IDX, price, upstatus, sdate, fdate) "
                            sql2 = sql2 & "VALUES (" & upidx & ", " & bfidx & ", " & qtyco_idx & ", " & bfwidx & ", " & sjbtidx & ", " & SJB_IDX & ", 0, 1, '" & sdate & "', NULL)"
                            dbcon.Execute sql2
                            upidx = upidx + 1
                            ' 🔹 인서트 수를 하나씩 카운팅
                            insertCount = insertCount + 1
                            ' 🔹 100건마다 브라우저에 중간 결과를 강제로 Flush
                            '    - 루프가 너무 길어질 때 서버/브라우저가 멈추는 걸 방지
                            '    - 중간에 서버가 "응답하고 있다"는 신호를 줘서 안정성 확보
                            If insertCount Mod 100 = 0 Then
                                Response.Flush
                            End If

                            Rs1.MoveNext
                        Loop
                    End If
                    Rs1.Close

                    Rs.MoveNext
                Loop
            End If
            Rs.Close
    End Select

    Response.Write "<script>alert('" & astep & " 완료');location.replace('unitprice.asp?sdate=" & sdate & "');</script>"
    
End If

    if fdate_set="fdate_set" then
        If fdate = "" Then
            Response.Write "<script>alert('종료일자를 입력해주세요');history.back();</script>"
            Response.End
        End If

        sql = "UPDATE tng_unitprice "
        sql = sql & "SET fdate = '" & fdate & "' "
        sql = sql & "WHERE fdate IS NULL "
        sql = sql & "AND sdate = '" & sdate & "'"
        dbcon.Execute sql

        Response.Write "<script>alert('fdate 설정 완료');location.replace('unitprice.asp?fdate=" & fdate & "');</script>"
    end if

    if fdate_set="fdate_update" then
        If fdate = "" Then
            Response.Write "<script>alert('종료일자를 입력해주세요');history.back();</script>"
            Response.End
        End If

        sql = "UPDATE tng_unitprice "
        sql = sql & "SET fdate = '" & fdate & "' "
        sql = sql & "WHERE sdate = '" & sdate & "'"
        dbcon.Execute sql

        Response.Write "<script>alert('fdate 수정 완료');location.replace('unitprice.asp?fdate=" & fdate & "');</script>"
    end if
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/clear_button/clear_button.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/clear_button/clear_button.css">
    <!-- TUI Calendar 스타일 -->
    <link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />

    <!-- TUI Calendar 스크립트 -->
    <script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>


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
        function validateform() {
            if(document.frmMain.sdate.value == "" ) {
                alert("생성일자를 입력해주세요.");
            return
            }
            else {
                document.frmMain.submit();s
            }
        }
    
    </script>
        <script>
        function validateform1() {

            if(document.frmMain1.fdate.value == "" ) {
                alert("종료일자를 입력해주세요.");
            return
            }
            else {
                document.frmMain1.submit();
            }
        }
    </script>
    <!--
    <script>
        function validateForm(fdate_set) {
        if (confirm("종료일을 입력하시겠습니까?"))
            {
                location.href="unitprice.asp?fdate_set="+fdate_set;
            }
    }
    </script>
    -->
    
    <script>
        function del(upidx){
            if (confirm("삭제 하시겠습니까?"))
            {
                location.href="unitpricedb.asp?part=delete&searchWord=<%=rsearchword%>&upidx="+upidx;
            }
        }
    </script>

</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
            <div class="py-5 container text-center">
                    <!-- 제목 나오는 부분 시작-->
                    <div class="row mb-3">
                        <div class="col text-start">
                            <h3>단가설정</h3>
                        </div>
                        <div class="col-3 text-start">
                            <form id="Search" name="Search" action="unitprice.asp" method="POST">
                                <div class="input-group mb-3">
                                    <button type="button"
                                        class="btn btn-outline-danger"
                                        onclick="location.replace('TNG1b.asp');">돌아가기
                                    </button>
                                    <input type="text" class="form-control"   style="height: 36px;" name="SearchWord" value="<%=Request("SearchWord")%>">
                                    <button type="button" class="btn btn-outline-success"  onclick="submit();">검색</button>
                                    <button type="button" class="btn btn-outline-danger" Onclick="location.replace('unitprice.asp?upidx=0');">등록</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!-- 제목 나오는 부분 끝-->
                    <!-- 표 형식 시작--> 
                    <form name="frmMain" id="validateform" action="unitprice.asp" method="POST">
                        <input type="hidden" name="gubun" value="win">
                        <div class="row mb-3">
                            <div class="col-2">
                                <label>시작일자</label>
                                <input type="text" id="sdate" name="sdate" class="form-control" value="<%=sdate%>">
                                <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('unitprice.asp?sdate=<%=""%>');">지우기</button>
                            </div>
                            <div class="col-10 d-flex align-items-end">
                            <% if astep="" then %>
                                <input type="hidden" id="astep" name="astep" class="form-control" value="astep1">
                                <button type="button" name="astep"  value="astep1" class="btn btn-danger me-2" Onclick="validateform('astep1');" >1차 생성</button>
                            <% elseif astep="astep1" then %>    
                                <input type="hidden" id="astep" name="astep" class="form-control" value="astep2">
                                <button type="button" name="astep"  class="btn btn-danger me-2" Onclick="validateform('astep2');" >2차 생성</button>
                            <% elseif astep="astep2" then %>
                                <input type="hidden" id="astep" name="astep" class="form-control" value="astep3">
                                <button type="button" name="astep"  class="btn btn-danger me-2" Onclick="validateform('astep3');" >3차 생성</button>
                            <% elseif astep="astep3" then %>
                            <input type="hidden" id="astep" name="astep" class="form-control" value="astep4">
                                <button type="button" name="astep"  class="btn btn-danger me-2" Onclick="validateform('astep4');" >4차 생성</button>
                            <% elseif astep="astep4" then %>
                                <input type="hidden" id="astep" name="astep" class="form-control" value="astep5">
                                <button type="button" name="astep"  class="btn btn-danger me-2" Onclick="validateform('astep5');" >5차 생성</button>
                            <% end if %>
                            </div>
                            <!--
                            <div class="col-md-1">
                                <label for="name">수정/저장/삭제</label><p>
                                <button class="btn btn-success" type="button" Onclick="validateform();"><% if sdate="" then %>저장<% else %>수정<% end if %></button>
                                <% if sdate<>"" then %><button class="btn btn-danger btn-small" type="button" onclick="del();">삭제</button><% end if %>
                            </div>
                            -->
                        </div>
                    </form>
                    <form name="frmMain1" id="validateform1" action="unitprice.asp" method="POST" enctype="multipart/form-data">
                        <div class="row mb-3">
                            <div class="col-2">
                                <label>종료일자</label>
                                <input type="text" id="fdate" name="fdate" class="form-control" value="<%=fdate%>">
                                <button type="submit" name="fdate_set" value="fdate_set" class="btn btn-warning me-2 mb-2">설정하기</button>
                                <button type="submit" name="fdate_update" value="fdate_update" class="btn btn-warning me-2 mb-2">수정하기</button>
                                <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('unitprice.asp?fdate=<%=""%>');">지우기</button>
                            </div>
                            <div class="col-md-1">
                                <label for="name">수정/저장/삭제</label><p>
                                <button class="btn btn-success" type="button" Onclick="validateform();"><% if rupidx="" then %>저장<% else %>수정<% end if %></button>
                                <% if rupidx<>"" then %><button class="btn btn-danger btn-small" type="button" onclick="del();">삭제</button><% end if %>
                            </div>
                        </div>
                    </form>
                    
                    
    <!--화면 끝-->
        
</div>
</div>
</main>                          
                <!-- footer 시작 -->    
                Coded By 양양
                <!-- footer 끝 --> 
</div>
        <script>
            const koreaHolidays = [
            "2025-01-01", "2025-03-01", "2025-05-05", "2025-06-06", "2025-08-15", "2025-10-03", "2025-10-09", "2025-12-25",
            "2026-01-01", "2026-03-01", "2026-05-05", "2026-06-06", "2026-08-15", "2026-10-03", "2026-10-09", "2026-12-25",
            "2027-01-01", "2027-03-01", "2027-05-05", "2027-06-06", "2027-08-15", "2027-10-03", "2027-10-09", "2027-12-25",
            "2028-01-01", "2028-03-01", "2028-05-05", "2028-06-06", "2028-08-15", "2028-10-03", "2028-10-09", "2028-12-25",
            "2029-01-01", "2029-03-01", "2029-05-05", "2029-06-06", "2029-08-15", "2029-10-03", "2029-10-09", "2029-12-25",
            "2030-01-01", "2030-03-01", "2030-05-05", "2030-06-06", "2030-08-15", "2030-10-03", "2030-10-09", "2030-12-25",
            "2031-01-01", "2031-03-01", "2031-05-05", "2031-06-06", "2031-08-15", "2031-10-03", "2031-10-09", "2031-12-25",
            "2032-01-01", "2032-03-01", "2032-05-05", "2032-06-06", "2032-08-15", "2032-10-03", "2032-10-09", "2032-12-25",
            "2033-01-01", "2033-03-01", "2033-05-05", "2033-06-06", "2033-08-15", "2033-10-03", "2033-10-09", "2033-12-25",
            "2034-01-01", "2034-03-01", "2034-05-05", "2034-06-06", "2034-08-15", "2034-10-03", "2034-10-09", "2034-12-25",
            "2035-01-01", "2035-03-01", "2035-05-05", "2035-06-06", "2035-08-15", "2035-10-03", "2035-10-09", "2035-12-25",
            "2036-01-01", "2036-03-01", "2036-05-05", "2036-06-06", "2036-08-15", "2036-10-03", "2036-10-09", "2036-12-25",
            "2037-01-01", "2037-03-01", "2037-05-05", "2037-06-06", "2037-08-15", "2037-10-03", "2037-10-09", "2037-12-25",
            "2038-01-01", "2038-03-01", "2038-05-05", "2038-06-06", "2038-08-15", "2038-10-03", "2038-10-09", "2038-12-25",
            "2039-01-01", "2039-03-01", "2039-05-05", "2039-06-06", "2039-08-15", "2039-10-03", "2039-10-09", "2039-12-25",
            "2040-01-01", "2040-03-01", "2040-05-05", "2040-06-06", "2040-08-15", "2040-10-03", "2040-10-09", "2040-12-25",
            "2041-01-01", "2041-03-01", "2041-05-05", "2041-06-06", "2041-08-15", "2041-10-03", "2041-10-09", "2041-12-25",
            "2042-01-01", "2042-03-01", "2042-05-05", "2042-06-06", "2042-08-15", "2042-10-03", "2042-10-09", "2042-12-25",
            "2043-01-01", "2043-03-01", "2043-05-05", "2043-06-06", "2043-08-15", "2043-10-03", "2043-10-09", "2043-12-25",
            "2044-01-01", "2044-03-01", "2044-05-05", "2044-06-06", "2044-08-15", "2044-10-03", "2044-10-09", "2044-12-25",
            "2045-01-01", "2045-03-01", "2045-05-05", "2045-06-06", "2045-08-15", "2045-10-03", "2045-10-09", "2045-12-25"
            ];


            flatpickr("#sdate", {
            dateFormat: "Y-m-d",
            locale: "ko",
            onChange: function(selectedDates, dateStr) {
                if (koreaHolidays.includes(dateStr)) {
                    alert("선택한 날짜는 공휴일입니다!");
                }
            },
            onDayCreate: function(dObj, dStr, fp, dayElem) {
                if (dayElem && dayElem.dateObj) {
                    var year = dayElem.dateObj.getFullYear();
                    var month = String(dayElem.dateObj.getMonth() + 1).padStart(2, '0');
                    var day = String(dayElem.dateObj.getDate()).padStart(2, '0');
                    var date = year + '-' + month + '-' + day;

                    var weekday = dayElem.dateObj.getDay(); // 🔥 요일 가져오기

                    if (weekday === 0) { // 일요일
                        dayElem.style.color = "#ff0000";  // 빨간색
                    } else if (weekday === 6) { // 토요일
                        dayElem.style.color = "#0000ff";  // 파란색
                    }

                    if (koreaHolidays.includes(date)) { // 공휴일은 항상 빨간색 덮어쓰기
                        dayElem.style.backgroundColor = "#ffdddd";
                        dayElem.style.color = "#d00";
                    }
                }
            }
        });

        flatpickr("#fdate", {
            dateFormat: "Y-m-d",
            locale: "ko",
            onChange: function(selectedDates, dateStr) {
                if (koreaHolidays.includes(dateStr)) {
                    alert("선택한 날짜는 공휴일입니다!");
                }
            },
            onDayCreate: function(dObj, dStr, fp, dayElem) {
                if (dayElem && dayElem.dateObj) {
                    var year = dayElem.dateObj.getFullYear();
                    var month = String(dayElem.dateObj.getMonth() + 1).padStart(2, '0');
                    var day = String(dayElem.dateObj.getDate()).padStart(2, '0');
                    var date = year + '-' + month + '-' + day;

                    var weekday = dayElem.dateObj.getDay(); // 🔥 요일 가져오기

                    if (weekday === 0) { // 일요일
                        dayElem.style.color = "#ff0000";  // 빨간색
                    } else if (weekday === 6) { // 토요일
                        dayElem.style.color = "#0000ff";  // 파란색
                    }

                    if (koreaHolidays.includes(date)) { // 공휴일은 항상 빨간색 덮어쓰기
                        dayElem.style.backgroundColor = "#ffdddd";
                        dayElem.style.color = "#d00";
                    }
                }
            }
        });


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
