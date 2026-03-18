 
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
Set Rs = Server.CreateObject("ADODB.Recordset")
%>
<%
order_idx=Request("order_idx")

SQL="Select order_name, order_length, order_type, order_date From khyorder where order_idx='"&order_idx&"'  "
Rs.open SQL,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
order_name=Rs(0)
order_length=Rs(1)
order_type=Rs(2)

    if order_length<>"" then order_length=replace(order_length, chr(13) & chr(10),"<br>")
    order_date=Rs(3)
end if
Rs.Close

%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" >
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" >
    <meta name="description" content="고객문의 접수 웹 사이트 만들기 기초과정" >
    <meta name="author" content="케빈샘" >
    <title>자재발주</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/webbasic/inc/favicon.ico" >
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    <script>
      function del(order_idx){
        if (confirm("삭제할거니??"))
        {
         location.href="/khy/korderdel_db.asp?idx="+order_idx;
        } 
        }


    </script>
</head>
<body class="bg-light">
    <div class="py-5 container text-center">
     <form name="frmMain" action="/khy/orderdb.asp" method="post">
      <div class="input-group mb-3">
<h3>자재 발주 목록</h3>
    </div>
    <div class="input-group mb-3">
       <span class="input-group-text">자재명&nbsp;&nbsp;&nbsp;</span>
         <div class="card text-start ms-2" style="width:80%;padding:5 5 5 5;"><%=order_name%></div>
    </div>
    <div class="input-group mb-3">
       <span class="input-group-text">자재길이&nbsp;&nbsp;&nbsp;</span>
         <div class="card text-start ms-2" style="width:80%;padding:5 5 5 5;"><%=order_length%></div>
    </div> 
    <div class="input-group mb-3">
       <span class="input-group-text">자재재질</span>
         <div class="card text-start ms-2" style="width:80%;padding:5 5 5 5;"><%=order_type%></div>          
    </div>
    <div class="input-group mb-3">
       <span class="input-group-text">날짜</span>
         <div class="card text-start ms-2" style="width:80%;padding:5 5 5 5;"><%=order_date%></div>          
    </div>
    <div class="input-group mb-3">
         <button type="button" class="btn btn-outline-primary" onclick="location.replace('/khy/korder_udt.asp?order_idx=<%=order_idx%>');">수정</button>
         <button type="button" class="btn btn-outline-secondary" onclick="del('<%=order_idx%>');">삭제</button>
    </div>    
      </form>
    </div>

Coded By 호영


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
<%
set Rs=Nothing
call dbClose()
%>