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
    
listgubun="two"
projectname="자재관리-수정"
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
    
    order_idx=Request("order_idx")

    SQL="Select  order_name, order_length, order_type, Convert(varchar(10),order_date,121), order_status, kg_m "
    SQL=SQL&" From tk_khyorder "
    SQL=SQL&" where order_idx='"&order_idx&"' "
    Rs.open Sql,Dbcon
    if not (Rs.EOF or Rs.BOF ) then
        order_name=Rs(0)
        order_length=Rs(1)
        order_type=Rs(2)
        order_date=Rs(3)
        order_status=Rs(4)
        kg_m=Rs(5)
    end if
    Rs.Close



	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"


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

 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left.asp"-->


<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!-- 내용 입력 시작 -->  
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="자재 발주 양식" />
    <meta name="author" content="케빈샘" />
    <title>자재 발주</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/webbasic/inc/favicon.ico" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    
    <script>
        function orderMaterials() {
            if (document.orderForm.order_name.value == "") {
                alert("자재명을 입력하세요.");
                return false;
            }
            if (document.orderForm.order_length.value == "" || isNaN(document.orderForm.order_length.value)) {
                alert("자재 길이를 숫자로 입력하세요.");
                return false;
            }
            if (document.orderForm.order_type.value == "") {
                alert("자재 재질을 입력하세요.");
                return false;
            }
            if (document.orderForm.kg_m.value == "") {
                alert("자재 단중중을 입력하세요.");
                return false;
            }
            document.orderForm.submit();
        }
        function del(order_idx) {
            if (confirm("삭제할거니??"))
            {
                location.href="khorderdeldb.asp?order_idx="+order_idx;
            } 
        }
    </script>
</head>
<body class="bg-light">
    <!-- 자재 발주 양식 -->
    <div class="py-5 container text-center">
        <form name="orderForm" action="/khy/khorderudtdb.asp" method="post">
 <input type="hidden" name="order_idx" value="<%=order_idx%>">
            <!-- 자재명 -->
            <div class="input-group mb-3">
                <span class="input-group-text">자재명</span>
                <input type="text" class="form-control" name="order_name" value="<%=order_name%>">
            </div>
            
            <!-- 자재 길이 -->
            <div class="input-group mb-3">
                <span class="input-group-text">자재 길이</span>
                    <select class="form-select" name="order_length">
                        <option value="1" <% if order_length="1" then %>selected<% end if %>>2200mm</option>
                        <option value="2" <% if order_length="2" then %>selected<% end if %>>2400mm</option>
                        <option value="3" <% if order_length="3" then %>selected<% end if %>>2500mm</option>
                        <option value="4" <% if order_length="4" then %>selected<% end if %>>2800mm</option>
                        <option value="5" <% if order_length="5" then %>selected<% end if %>>3000mm</option>
                        <option value="6" <% if order_length="6" then %>selected<% end if %>>3200mm</option>
                    </select>
            </div>

            <!-- 자재 재질 -->
            <div class="input-group mb-3">
                <span class="input-group-text">자재 재질</span>
                    <select class="form-select" name="order_type">
                        <option value="1" <% if order_type="1" then %>selected<% end if %>>무피</option>
                        <option value="2" <% if order_type="2" then %>selected<% end if %>>백피</option>
                        <option value="3" <% if order_type="3" then %>selected<% end if %>>블랙</option>
                    </select>
            </div>
            <div class="input-group mb-3">
                <span class="input-group-text">단중</span>
                <input type="text" class="form-control" name="kg_m" value="<%=kg_m%>">
            </div>
            <div class="input-group mb-3">
                <span class="input-group-text">사용여부 </span>
                    <select class="form-select" name="order_status">
                        <option value="1" <% if order_status="1" then %>selected<% end if %>>사용</option>
                        <option value="0" <% if order_status="0" then %>selected<% end if %>>미사용</option>
                    </select>
            </div>

            <!-- 등록 버튼 -->
            <div class="input-group mb-3">
                <button type="button" class="btn btn-outline-primary" onclick="orderMaterials();">수정</button>
                <button type="button" class="btn btn-outline-secondary" onclick="del('<%=order_idx%>');">삭제</button>
                <button type="button" class="btn btn-outline-secondary" onclick="location.replace('/khy/khorderlist.asp');">리스트</button>
            </div>    
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
 
</body>



<!-- 내용입력 끝 -->
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 호영
 
<!-- footer 끝 --> 
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
 
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




