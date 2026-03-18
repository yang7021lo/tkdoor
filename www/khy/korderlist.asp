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

    listgubun="four"
    projectname="자재발주 상세보기"
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

kidx=Request("kidx")

SQL=" Select A.kidx, A.kcidx, B.cname, A.kmidx, C.mname, A.midx, D.mname, Convert(varchar(10),A.kwdate,121)"
SQL=SQL&" , Convert(varchar(10),A.kidate,121), Convert(varchar(10),A.krdate,121), A.kstatus "
SQL=SQL&" ,E.mname, F.mname "
SQL=SQL&" From tk_korder A "
SQL=SQL&" Join tk_customer B On A.kcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.kmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Left Outer Join tk_member E On A.imidx=E.midx "
SQL=SQL&" Left Outer Join tk_member F On A.rmidx=F.midx "
SQL=SQL&" Where A.kidx='"&kidx&"' "
'Response.write "<br><br><br><br><br>"
'Response.write (SQL)
Rs.open Sql,dbcon
if not (Rs.EOF or Rs.BOF ) then
    kidx=Rs(0)
    kcidx=Rs(1)
    cname=Rs(2)
    kmidx=Rs(3)
    fmname=Rs(4)
    midx=Rs(5)
    smname=Rs(6)
    kwdate=Rs(7)
    kidate=Rs(8)
    krdate=Rs(9)
    kstatus=Rs(10)
    imname=Rs(11)
    rmname=Rs(12)
select case kstatus
    case "0"
        kstatus_text="발주중"
    case "1"
        kstatus_text="납품처확인"
    case "2"
        kstatus_text="입고완료"
end select
end if
Rs.close





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
        function del(ksidx) {
            if (confirm("이 항목을 삭제하시겠습니까?")) {
                location.href = "korderlistdel.asp?kidx=<%=kidx%>&ksidx=" + ksidx;
            }
        }
        function deleteAll() {
            if (confirm("모든 항목을 삭제하시겠습니까?")) {
                 location.href = "korderlist_alldel.asp?kidx=<%=kidx%>";
            }
        }

        function odrmsg() {
            if (confirm("발주 전송을 하시겠습니까?")) {
                 location.href = "odrmsg.asp?kidx=<%=kidx%>";
            }
        }
        function check() {
            if (confirm("입고완료 선택을 하시겠습니까?")) {
                 location.href = "check.asp?kidx=<%=kidx%>";
            }
        }
    </script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left.asp"-->


<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!--화면시작-->

    <div class="py-2 container text-center  card card-body">
<!-- 표 형식 시작--> 
       <div class="row  mb-2">
<!-- 거래처 정보 시작 -->

            <table class="table table-bordered">
            <tbody>
                <tr>
                    <th width="80px;" class="bg-light">주문번호</th>
                    <td><%=kidx%></td>
                    <th class="bg-light">납품처</th>
                    <td><%=cname%></td>
                    <th class="bg-light">납품처담당</th>
                    <td><%=fmname%></td>
                    <th class="bg-light">입고담당</th>
                    <td><%=smname%></td>

                </tr>
                <tr>
                    <th class="bg-light">발주일</th>
                    <td><%=kwdate%><br><small><%=smname%></small></td>
                    <th class="bg-light">납품처확인</th>
                    <td><%=kidate%><br><small><%=imname%></small></td>
                    <th class="bg-light">입고완료일</th>
                    <td><%=krdate%><br><small><%=rmname%></small></td>
                    <th class="bg-light">상태</th>
                    <td><%=kstatus_text%></td>
                </tr>

            </tbody>
            </table>
<!-- 거래처 정보 끝 -->
        </div>
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                    <th scope="col">순번</th>
                    <th scope="col">주문번호</th>
                    <th scope="col">구분</th>
                    <th scope="col">자재명</th>
                    <th scope="col">길이</th>
                    <th scope="col">중량</th>
                    <th scope="col">수량</th>
                    <th scope="col">파일</th>
                    <th scope="col">발주자</th>
                    <th scope="col">발주일</th>
                    <th scope="col">확인자</th>
                    <th scope="col">확인일</th>
                    <th scope="col">관리</th>
                  </tr>
              </thead>
              <tbody>
                <%

SQL=" Select A.odrdate, A.odrstatus, A.midx, A.odrkkg, A.odridx, B.mname, A.filedet, C.Order_name, C.Order_length, C.order_type, A.ksidx, A.odrdate "
SQL=SQL&" , A.cdate, D.mname, A.odrea "
SQL=SQL&" From tk_korderSub A "
SQL=SQL&" Join tk_member B On A.midx=B.midx "
SQL=SQL&" Join tk_khyorder C On A.odridx=C.order_idx "
SQL=SQL&" Left Outer Join tk_member D On A.Cmidx=D.midx "
SQL=SQL&" Where A.kidx='"&kidx&"' "
SQL=SQL&" Order by Order_name asc "
            
'Response.write (SQL)
 Rs.open SQL,Dbcon,1,1,1
Rs.PageSize = 20
            
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
            
     khy=khy+1
     odrdate=Rs(0)
     odrstatus=Rs(1)
     omidx=Rs(2)
     odrkkg=Rs(3)
     odridx=Rs(4)
     omname=Rs(5)
     filedet=Rs(6)
     Order_name=Rs(7)
     Order_length=Rs(8)
     order_type=Rs(9)
     ksidx=Rs(10)
     odrdate=Rs(11)
     ccdate=Rs(12)
     cmname=Rs(13)
     odrea=Rs(14)
            
            
select case order_type
    case "1"
        order_type_text="무피"
    case "2"
        order_type_text="백피"
    case "3"
        order_type_text="블랙"
end select
            
select case Order_length
    case "1"
        Order_length_text="2,200mm"
    case "2"
        Order_length_text="2,400mm"
    case "3"
        Order_length_text="2,500mm"
    case "4"
        Order_length_text="2,800mm"
    case "5"
        Order_length_text="3,000mm"
    case "6"
        Order_length_text="3,200mm"
            
end select
            
if odrstatus="1" then 
    classname="btn btn-primary"
    status_text="확인"
    drv="2"
    classname="btn btn-danger"
    status_text="확인완료"
    odrv="1"
end if
            
            
%>
        <tr>
            <th><%=khy%></th>
            <th><%=ksidx%></th>
            <td><%=order_type_text%></td>
            <td><%=order_name%></td>
            <td><%=Order_length_text%></td>
            <td class="text-start"><% if odrkkg<>"" then %><%=odrkkg%>kg<% end if %></td>
            <td class="text-start"><% if odrea<>"" then %><%=odrea%>ea<% end if %></td>
            <td>
                <% if not isnull(filedet) and filedet <> "" then %>
                    <button class="btn btn-danger" type="button" onclick="window.open('/khy/orderfile/<%=server.urlencode(filedet)%>','khy','top=0, left=300, width=800, height=1000');">파일 보기</button>
                <% else %>
                    없음
                <% end if %>
            </td>
            <td><%=omname%></td>
            <td><%=odrdate%></td>
            <td><%=cmname%></td>
            <td><%=ccdate%></td>
            <td>
<%
If Cint(omidx)=Cint(C_midx) and kstatus="0" then 
%>
                <button type="button" class="btn btn-danger" onclick="del('<%= ksidx %>');">삭제</button>
<%
End if
%>
            </td>      
        </tr>
            
<%
Order_length_text=""
order_type_text=""
Rs.movenext
Loop
End if
Rs.close
%>
                              </tbody>
                            </table>
            <!-- view 형식 끝--> 
             
                </div>    
                <div class="row">
                    <div class="col-12 text-end">
                     <button class="btn btn-primary" type="button" onclick="location.replace('korderlistm.asp');">목록보기</button>

<%
If Cint(midx)=Cint(C_midx) and kstatus="0"  then 
%>
                     <button type="button" class="btn btn-danger" onclick="deleteAll();">전체 삭제</button>
                     <button type="button" class="btn btn-warning" onclick="odrmsg();">발주전송</button>
<%
end if
%>
<% if kstatus="0" then %>
                     <button type="button" class="btn btn-success" onclick="location.replace('korder.asp?kidx=<%=kidx%>');">자재추가</button>
<% end if %>
                     <button type="button" class="btn btn-dark" onclick="<% if kidate<>"" then %>check('<%=kidx%>');<% else %>alert('입고확인은 발주확인 이 있어야 등록 할수있습니다');<% end if %>">입고확인</button>
                     
                    </div>
                </div>

Coded By 호영
                <!--화면 끝-->
            
            <!--Bootstrap core JS-->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            <!--Core theme JS--> 


            </body>

            </html>

            <%
            set Rs=Nothing
            call dbClose()
            %>
