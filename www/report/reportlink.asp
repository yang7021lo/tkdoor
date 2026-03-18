<!--
주요 테이블 
reportlink *(tk_reportlink가 아니라 그냥 reportlink임) ->  TNG_SJB와 tk_report를 연결시켜줌

rlisx:reportlink idx
sjbidx: TNG_SJB idx
ridx: 성적서 idx
midx:연결 생성자(수정자) idx
rldate:연결 생성일(수정일)
-->
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

    projectname="품목 연결"
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


ridx=Request("ridx")
gotopage=Request("gotopage")

SQL=" Select C.fname from tk_report A Left Outer Join tk_reportsub B On B.ridx=A.ridx Left Outer Join tk_reportm C On C.fidx=B.rfidx where A.ridx='"&ridx&"' and C.ftype='6' "
Rs1.open Sql,Dbcon
if not (Rs1.EOF or Rs1.BOF) then
rdepth=Rs1(0)
end if
Rs1.close

SQL=" Select C.fname from tk_report A Left Outer Join tk_reportsub B On B.ridx=A.ridx Left Outer Join tk_reportm C On C.fidx=B.rfidx where A.ridx='"&ridx&"' and C.ftype='7' "
Rs1.open Sql,Dbcon
if not (Rs1.EOF or Rs1.BOF) then
rwidth=Rs1(0)
end if
Rs1.close

'maxvalue 와 minvalue를 통해 성적서가 갖고 있는 깊이와 너비에 따라 유사한 SJB를 찾아주는 코드이다.
'허나 간혹 깊이와 너비가 해당하지 않는 성적서도 존재할 수 있기에 일단 20000과 10000 사이라는 비정상적인 값이 뜨지 않도록 해 놓았다(성적서와 SJB를 연결 못 시키게)
'현재는 성적서의 유사도를 tk_reportm에 해당하는 깊이, 너비, 그리고 tk_report의 sjb_type_no을 사용하여 TNG_SJB의 레코드셋들과 비교하여 유사도가 1 이상인 
'것들 만 연결 가능하도록 코드로 구현해 놓았다
'조건이 일치할 시 유사도가 1 올라감 자세한 것은 밑의 쿼리 참고
'ex) 만약 깊이와 너비가 없는 성적서들을 막무가내인 SJB와 연결하고 싶다면 elseif CDbl(rdepth 혹은 rwidth)<>"" then 조건 밑의 
'maxvalue 와 minvalue를 10000과 0 사이처럼 유사도가 무조건 오르도록 해주면 된다.


if CDbl(rdepth)>=100 and CDbl(rdepth)<130 then
dmaxvalue=129.99 
dminvalue=100
elseif CDbl(rdepth)>=130 and CDbl(rdepth)<150 then
dmaxvalue=149.99 
dminvalue=130
elseif CDbl(rdepth)>=150 then
dmaxvalue=100000
dminvalue=150
elseif CDbl(rdepth)<100 and CDbl(rdepth)>1 then
dmaxvalue=99.99
dminvalue=0
elseif CDbl(rdepth)<>"" then
dmaxvalue=20000
dminvalue=10000
end if

if CDbl(rwidth)>=45 and CDbl(rwidth)<60 then
wmaxvalue=59.99 
wminvalue=45
elseif CDbl(rwidth)>=60 then
wmaxvalue=10000 
wminvalue=60
elseif CDbl(rwidth)<45 and CDbl(rwidth)>1 then
wmaxvalue=44.99
wminvalue=0
elseif CDbl(rwidth)<>"" then
wmaxvalue=20000
wminvalue=10000
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
      #text {
        color: #070707;
      }
    </style>
<script>
    function smwindow(str){
        newwin=window.open(str,'win1', 'scrollbars=yes,menubar=no,statusbar=no,status=no,width=500,height=1000,top=50,left=50');
        newwin.focus();
    }
</script>
 
  </head>
  <body class="sb-nav-fixed">

<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!--화면시작-->

    <div class="py-5 container text-center  card card-body">
<!-- 버튼 형식 시작--> 
    <div class="text-end mb-1">
    <!--Modal-->
        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">검색</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="remaingroup.asp" name="form1">
                <div class="mb-3">
                    <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해 주세요." name="SearchWord">
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary"  onclick="submit();">검색</button>
                </div>
                </form>
                </div>
            </div>
            </div>
        </div>
    <!--modal end-->
        </div>
<!-- 버튼 형식 끝--> 

<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
            <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th align="center">품명</th>
                        <th align="center">규격</th>
                        <th align="center">폭(깊이)</th>
                        <th align="center">보이는면</th>
                        <th align="center">수동/자동</th>
                        <th align="center">도장</th>
                        <th align="center">스텐</th>  
                        <th align="center">AL</th>  
                        <th align="center">연결</th>
                    </tr>
                </thead>
            <tbody>
                    <%
                    SQL=" SELECT A.sjbidx, B.sjb_depth, B.sjb_width, B.SJB_TYPE_NO, B.SJB_barlist, B.SJB_Paint, B.SJB_St, B.SJB_Al, B.SJB_FA, A.rlisx "
                    SQL=SQL&" From reportlink A "
                    SQL=SQL&" Join TNG_SJB B On B.SJB_IDX=A.sjbidx "
                    SQL=SQL&" Where A.ridx='"&ridx&"' "
                    SQL=SQL&" ORDER BY A.rlisx DESC "
                    'Response.write (SQL)& "<br>"
                    Rs.open Sql,Dbcon,1,1,1
                    if not (Rs.EOF or Rs.BOF) then
                    i=1
                    for j=1 to Rs.RecordCount
                        rsjbidx=Rs(0)
                        rsjbdepth=Rs(1)
                        rsjbwidth=Rs(2)
                        rsjb_type_no=Rs(3)
                        rsjb_barlist=Rs(4)
                        rsjb_paint=Rs(5)
                        rsjb_st=Rs(6)
                        rsjb_al=Rs(7)
                        rsjb_fa=Rs(8)
                        rlisx=Rs(9)

                    Select case rsjb_type_no
                        case "1"
                            rsjb_type_name="일반 AL 자동"
                        case "2"
                            rsjb_type_name="복층 AL자동"
                        case "3"
                            rsjb_type_name="단열 AL자동"
                        case "4"
                            rsjb_type_name="삼중 AL자동"
                        case "5"
                            rsjb_type_name="일반 100바  AL자동"
                        case "6"
                            rsjb_type_name="일반 AL프레임"
                        case "7"
                            rsjb_type_name="단열 AL프레임"
                        case "8"
                            rsjb_type_name="단열 스텐자동"
                        case "9"
                            rsjb_type_name="삼중 스텐자동"
                        case "10"
                            rsjb_type_name="단열 이중스텐자동"
                        case "11"
                            rsjb_type_name="단열 스텐프레임"
                        case "12"
                            rsjb_type_name="삼중 스텐프레임"
                        case "13"
                            rsjb_type_name="일반 절곡"
                        case "14"
                            rsjb_type_name="기타"
                        case "15"
                            rsjb_type_name="포켓 단열 스텐자동"
                    End Select  

                    Select case rsjb_fa
                        case "0"
                            rsjb_fa_name="❌"
                        case "1"
                            rsjb_fa_name="수동"
                        case "2"
                            rsjb_fa_name="자동"
                    End Select     

                    Select case rsjb_paint
                        case "0"
                            rsjb_paint_name="❌"
                        case "1"
                            rsjb_paint_name="✅"
                    End Select   

                    Select case rsjb_st
                        case "0"
                            rsjb_st_name="❌"
                        case "1"
                            rsjb_st_name="✅"
                    End Select   

                    Select case rsjb_al
                        case "0"
                            rsjb_al_name="❌"
                        case "1"
                            rsjb_al_name="✅"
                    End Select     

                    %>              
                  <tr>
                    <td><%=rsjb_type_name%></td>
                    <td><%=rsjb_barlist%></td>
                    <td><%=rsjbdepth%></td>
                    <td><%=rsjbwidth%></td>
                    <td><%=rsjb_fa_name%></td>
                    <td><%=rsjb_paint_name%></td>
                    <td><%=rsjb_st_name%></td>
                    <td><%=rsjb_al_name%></td>
                    <td><button type="button" class="btn btn-warning" Onclick="location.replace('reportlinkdeldb.asp?rlisx=<%=rlisx%>&ridx=<%=ridx%>&sjbidx=<%=sjbidx%>&gotopage=<%=gotopage%>');">연결취소</button></td>
                  </tr>
                    <%
                    Rs.MoveNext
                    i=i+1
                    Next
                    End If
                    Rs.close
                    %>

                    <%
                    SQL=" SELECT A.SJB_IDX, A.sjb_depth, A.sjb_width, A.SJB_TYPE_NO, A.SJB_barlist, A.SJB_Paint, A.SJB_St, A.SJB_Al, A.SJB_FA,"
                    SQL=SQL&" (CASE WHEN A.sjb_depth BETWEEN "&dminvalue&" AND "&dmaxvalue&" THEN 1 ELSE 0 END + "
                    SQL=SQL&" CASE WHEN A.sjb_width BETWEEN "&wminvalue&" AND "&wmaxvalue&" THEN 1 ELSE 0 END + "
                    SQL=SQL&" CASE WHEN A.SJB_TYPE_NO IN (SELECT B.sjb_type_no FROM tk_report B Where B.ridx='"&ridx&"') THEN 1 ELSE 0 END) AS Relevance "
                    SQL=SQL&" FROM TNG_SJB A Where (CASE WHEN A.sjb_depth BETWEEN 0 AND 0 THEN 1 ELSE 0 END + CASE WHEN A.sjb_width BETWEEN 0 AND 1000 THEN 1 ELSE 0 END + CASE WHEN A.SJB_TYPE_NO IN (SELECT B.sjb_type_no FROM tk_report B Where B.ridx='246') THEN 1 ELSE 0 END) >= 1"
                    SQL=SQL&" and A.SJB_IDX NOT IN (Select C.sjbidx from reportlink C Where ridx='"&ridx&"' )"
                    SQL=SQL&" ORDER BY Relevance DESC "
                    'Response.write (SQL)& "<br>"
                    Rs.open Sql,Dbcon,1,1,1
                    if not (Rs.EOF or Rs.BOF) then
                    i=1
                    for j=1 to Rs.RecordCount
                        sjbidx=Rs(0)
                        sjbdepth=Rs(1)
                        sjbwidth=Rs(2)
                        sjb_type_no=Rs(3)
                        sjb_barlist=Rs(4)
                        sjb_paint=Rs(5)
                        sjb_st=Rs(6)
                        sjb_al=Rs(7)
                        sjb_fa=Rs(8)

                    Select case sjb_type_no
                        case "1"
                            sjb_type_name="일반 AL 자동"
                        case "2"
                            sjb_type_name="복층 AL자동"
                        case "3"
                            sjb_type_name="단열 AL자동"
                        case "4"
                            sjb_type_name="삼중 AL자동"
                        case "5"
                            sjb_type_name="일반 100바  AL자동"
                        case "6"
                            sjb_type_name="일반 AL프레임"
                        case "7"
                            sjb_type_name="단열 AL프레임"
                        case "8"
                            sjb_type_name="단열 스텐자동"
                        case "9"
                            sjb_type_name="삼중 스텐자동"
                        case "10"
                            sjb_type_name="단열 이중스텐자동"
                        case "11"
                            sjb_type_name="단열 스텐프레임"
                        case "12"
                            sjb_type_name="삼중 스텐프레임"
                        case "13"
                            sjb_type_name="일반 절곡"
                        case "14"
                            sjb_type_name="기타"
                        case "15"
                            sjb_type_name="포켓 단열 스텐자동"
                    End Select  

                    Select case sjb_fa
                        case "0"
                            sjb_fa_name="❌"
                        case "1"
                            sjb_fa_name="수동"
                        case "2"
                            sjb_fa_name="자동"
                    End Select     

                    Select case sjb_paint
                        case "0"
                            sjb_paint_name="❌"
                        case "1"
                            sjb_paint_name="✅"
                    End Select   

                    Select case sjb_st
                        case "0"
                            sjb_st_name="❌"
                        case "1"
                            sjb_st_name="✅"
                    End Select   

                    Select case sjb_al
                        case "0"
                            sjb_al_name="❌"
                        case "1"
                            sjb_al_name="✅"
                    End Select     

                    %>              
                  <tr>
                    <td><%=sjb_type_name%></td>
                    <td><%=sjb_barlist%></td>
                    <td><%=sjbdepth%></td>
                    <td><%=sjbwidth%></td>
                    <td><%=sjb_fa_name%></td>
                    <td><%=sjb_paint_name%></td>
                    <td><%=sjb_st_name%></td>
                    <td><%=sjb_al_name%></td>
                    <td><button type="button" class="btn btn-success" Onclick="location.replace('reportlinkdb.asp?ridx=<%=ridx%>&sjbidx=<%=sjbidx%>&gotopage=<%=gotopage%>');">연결하기</button></td>
                  </tr>
                    <%
                    Rs.MoveNext
                    i=i+1
                    Next
                    End If
                    %>
              </tbody>
          </table>
        </div>
                    <%
                    Rs.close
                    %>
    </div>    
<!-- footer 시작 -->    
Coded By 원준
<!-- footer 끝 --> 
    <!--화면 끝-->
  </div>
</div>
</main>                          

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