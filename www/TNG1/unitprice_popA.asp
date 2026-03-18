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

rsjb_idx=Request("sjb_idx")
rsjb_type_no=Request("sjb_type_no")
rsjb_fa=Request("sjb_fa")
rupmidx=Request("upmidx") '단가적용기간 기준키

SQL="Select sjbtidx from tng_sjbtype where SJB_TYPE_NO='"&rsjb_type_no&"' "
  Rs.Open SQL,dbcon
  if not (Rs.EOF or Rs.BOF ) then
    sjbtidx=Rs(0)
  end if
  Rs.Close

SQL="Select sdate, fdate From unitprice where upmidx='"&rupmidx&"' "
  Rs.Open SQL,dbcon
  if not (Rs.EOF or Rs.BOF ) then
    sdate=Rs(0)
    fdate=Rs(1)
  end if
  Rs.Close

if rsjb_fa<>"0" then 
  if rsjb_fa="1" then '수동이라면
  SQL=" select A.bfwidx, A.whichi_fix, A.whichi_auto, B.bfidx "
  SQL=SQL&" from tng_whichitype A "
  SQL=SQL&" Join tk_barasiF B On A.whichi_fix=B.whichi_fix "
  SQL=SQL&" where A.whichi_fix<>'0'"
  elseif rsjb_fa="2" then '자동이라면
  SQL=" select A.bfwidx, A.whichi_fix, A.whichi_auto, B.bfidx "
  SQL=SQL&" from tng_whichitype A "
  SQL=SQL&" Join tk_barasiF B On A.whichi_auto=B.whichi_auto "
  SQL=SQL&" where A.whichi_auto<>'0'"

  end if
  Response.write (SQL)&"<br>"
  Rs1.Open sql, dbcon
    Do Until Rs1.EOF
      bfwidx=Rs1(0)
      whichi_fix=Rs1(1)
      whichi_auto=Rs1(2)
      bfidx=Rs1(3)

      i=i+1
      SQL="Insert into unitpriceA (upmidx, sjb_idx, sjb_type_no, sjbtidx, sjb_fa, bfwidx, whichi_fix, whichi_auto, bfidx, status, wdate, upstatus, sdate, fdate )"
      SQL=SQL&" Values ('"&rupmidx&"', '"&rsjb_idx&"', '"&rsjb_type_no&"', '"&sjbtidx&"', '"&rsjb_fa&"', '"&bfwidx&"', '"&whichi_fix&"', '"&whichi_auto&"', '"&bfidx&"', 0, getdate(), 0, '"&sdate&"', '"&fdate&"')"
      Response.write (SQL)&"/"&i&"<br>"
      dbcon.Execute (SQL)

    Rs1.MoveNext
    Loop
  Rs1.Close
end if
'tng_sjb TB upstatus column을 1로 업데이트
SQL="update tng_sjb set upstatus=1 where sjb_idx='"&rsjb_idx&"' "
Response.write (SQL)&"/"&i&"<br>"
dbcon.Execute (SQL)



%>
  <script>
    // 페이지가 로드되면 실행
    window.onload = function () {
      // 2000ms(1초) 후에 이동
      setTimeout(function () {
        opener.location.replace('unitprice2.asp?part=fmake&sjb_type_no=<%=rsjb_type_no%>&upmidx=<%=rupmidx%>');window.close();
      }, 1000);
    };
  </script>


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


</head>
<body>

<div id="layoutSidenav_content">            
<main>
<div class="container-fluid px-4">
  <div class="row justify-content-between">
    <div class="py-5 container text-center  card card-body">
      <div class="row">

      </div>
    <div>
  </div>
</div>    
        
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
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