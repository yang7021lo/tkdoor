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
    projectname="자재발주 목록"
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
	page_name="korderlistm.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"


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
           function del(kidx) {
        if (confirm("이 항목을 삭제하시겠습니까?")) {
           location.href = "korderlistmdel.asp?kidx=" + kidx;
           }
        }
        function deleteAll(kidx) {
            if (confirm("모든 항목을 삭제하시겠습니까?")) {
                 location.href = "korderlistm_alldel.asp";
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

    <div class="py-5 container text-center  card card-body">
 
<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                <tr>
                    <th scope="col">순번</th>
                    <th scope="col">주문번호</th>
                    <th scope="col">납품처</th>
                    <th scope="col">납품처담당</th>
                    <th scope="col">입고담당</th>
                    <th scope="col">발주일</th>
                    <th scope="col">납품처확인</th>
                    <th scope="col">입고완료일</th>
                    <th scope="col">상태</th>
                    <th scope="col">내역보기</th>
  
                </tr>
              </thead>
              <tbody>
                <%

                SQL=" Select A.kidx, A.kcidx, B.cname, A.kmidx, C.mname, A.midx, D.mname, Convert(varchar(10),A.kwdate,121), Convert(varchar(10),A.kidate,121), Convert(varchar(10),A.krdate,121), A.kstatus "
                SQL=SQL&" From tk_korder A "
                SQL=SQL&" Join tk_customer B On A.kcidx=B.cidx "
                SQL=SQL&" Join tk_member C On A.kmidx=C.midx "
                SQL=SQL&" Join tk_member D On A.midx=D.midx "
                SQL=SQL&" Order by A.kidx DESC "
                'Response.write (SQL)
                Rs.open Sql,Dbcon,1,1,1
                Rs.PageSize = 20

                if not (Rs.EOF or Rs.BOF ) then
                no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                totalpage=Rs.PageCount '
                Rs.AbsolutePage =gotopage
                i=1
                for j=i to Rs.RecordCount
                if i>Rs.PageSize then exit for end if
                if no=j-0 then exit for end if
            
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
            
            
                select case kstatus
                    case "0"
                        kstatus_text="발주중"
                    case "1"
                        kstatus_text="납품처확인"
                    case "2"
                        kstatus_text="입고완료"
                end select
             
            
                if odrstatus="1" then 
                    classname="btn btn-primary"
                    status_text="확인"
                    odrv="2"
                elseif odrstatus="2"  then 
                    classname="btn btn-danger"
                    status_text="확인완료"
                    odrv="1"
                end if

            
                %>
                <tr>
                    <th><%=no-j%></th>
                    <th><%=kidx%></th>
                    <td><%=cname%></td>
                    <td><%=fmname%></td>
                    <td><%=smname%></td>
                    <td><%=kwdate%></td>
                    <td><%=kidate%></td>
                    <td><%=krdate%></td>      
                    <td><%=kstatus_text%></td>  
                    <td><button class="btn btn-primary" type="button" onclick="location.replace('korderlist.asp?kidx=<%=kidx%>');">보기</button></td>

                </tr>
            
<%
                i=i+1
                Rs.MoveNext
                Next
                End If
%>
              </tbody>
            </table>
   
        <div class="row col-12 py-3">

<!--#include virtual="/inc/paging.asp"-->
    <div class="col-12 text-end">
        <button type="button" class="btn btn-danger" onclick="deleteAll();">전체 삭제</button>
    </div>
        </div>
<%
Rs.Close
%>
        </div>
</div>
Coded By 호영
                <!--화면 끝-->
        </div>
</div>
            <!--Bootstrap core JS-->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            <!--Core theme JS--> 


            </body>

            </html>
            
            <%
            set Rs=Nothing
            call dbClose()
            %>
            
