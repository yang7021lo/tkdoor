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
%>
<%
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 
 
rupmidx=Request("upmidx") '단가적용기간 기준키


SQL=" Select top 100 A.upidx, B.price "
SQL=SQL&" From tng_unitprice_f A "
SQL=SQL&" Left Outer Join tng_unitprice_t B On A.sjb_idx=B.sjb_idx and A.unittype_bfwidx=B.unittype_bfwidx and A.unittype_qtyco_idx=B.unittype_qtyco_idx "
SQL=SQL&" where A.upmidx='"&rupmidx&"' and A.upstatus=0 "

  'Response.write (SQL)&"<br><br>"
  Rs.Open sql, dbcon
    Do Until Rs.EOF
      upidx=Rs(0)
      price=Rs(1)

  

      SQL=" Update tng_unitprice_f set price='"&price&"', upstatus=1  where upidx='"&upidx&"' "
      'Response.write (SQL)&"/"&i&"<br>"
      dbcon.Execute (SQL)

 
  
  Rs.MoveNext
  Loop
  Rs.Close



SQL="Select "
SQL=SQL&" (select count(*) From tng_unitprice_f where upmidx='"&rupmidx&"' )"
SQL=SQL&", (select count(*) From tng_unitprice_f where upmidx='"&rupmidx&"' and upstatus=0)"
'Response.write (SQL)&"<br><br>"
Rs.Open sql, dbcon
  totcnt=Rs(0)
  rcnt=Rs(1)

  fcnt=totcnt-rcnt
 
  percent=100-(rcnt/totcnt*100)
Rs.Close
'response.write rcnt&"/"

if rcnt = "0" then '적용해야 할 남은 레코드가 없다면 
response.write "<script>alert('완료되었습니다.');opener.location.replace('unitprice3.asp?upmidx="&rupmidx&"');window.close();</script>"
 
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
    <title>단가적용</title>
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
  <script>
    // 페이지가 로드되면 실행
    window.onload = function () {
      // 2000ms(1초) 후에 이동
      setTimeout(function () {
        location.replace('unitprice_popF2.asp?upmidx=<%=rupmidx%>');
      }, 2000);
    };
  </script>

</head>


<body class="p-5">

  <div class="container">
    <h4>작업 현황</h4>

    <!-- 진행 현황 숫자 표시 -->
    <div class="row mb-2">
      <div class="col-md-3">전체 수: <strong><%=FormatNumber(totcnt,0)%>건</strong></div>
      <div class="col-md-3">완료건: <strong><%=FormatNumber(fcnt,0)%>건</strong></div>
      <div class="col-md-3">남은건: <strong><%=FormatNumber(rcnt,0)%>건</strong></div>
      <div class="col-md-3">진행률: <strong><%=formatnumber(percent,0)%>%</strong></div>
    </div>

    <!-- 상태바 (Progress Bar) -->
    <div class="progress" style="height: 25px;">
      <div class="progress-bar progress-bar-striped bg-success" role="progressbar" style="width: <%=formatnumber(percent,0)%>%;" aria-valuenow="<%=formatnumber(percent,0)%>" aria-valuemin="0" aria-valuemax="100">
        <%=formatnumber(percent,0)%>%
      </div>
    </div>
  </div>

</body>
</html>
<%


%>
<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>