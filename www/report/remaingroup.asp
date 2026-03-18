<!--
주요 테이블
tk_reportg

rgidx:성적서 그룹 idx
rgname:그룹명
rgmidx:그룹 등록자 idx
rgdate:등록일자
rgemidx:수정자 idx
rgedate:수정일자
rgtype:대분류
1-단열세이프         
2-단열자동프레임      
3-단열수동프레임   
4-시스템도어            
5-기타           

rgfile:첨부파일
rgstatus:사용유무
-->

<!--
서브 테이블
tk_reportgSub -> 한 그룹내의 여러 성적서를 연결해주는 DB

rgsidx:tk_reportgSub idx
rgidx:그룹 idx
ridx:성적서 idx
rgsmidx:등록자(수정자) idx
rgsdate:등록일자(수정일자)
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

    listgubun="one"
    projectname="성적서 그룹 리스트"
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
 
rgsidx=Request("rgsidx")
if rgsidx<>"" then 
    SQL="Delete From tk_reportgsub where rgsidx='"&rgsidx&"' "
    Dbcon.Execute (SQL)
end if



	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="remaingroup.asp?"

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
    function del(rgsidx){
        if (confirm("포함된 성적서를 삭제 하시겠습니까?"))
        {
        location.href="remaingroup.asp?rgsidx="+rgsidx;
        }
    }
</script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG2.asp"-->


<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!--화면시작-->

    <div class="py-5 container text-center  card card-body">
<!-- 버튼 형식 시작--> 
    <div class="row mb-3">
        <div class="col-12 text-end">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">그룹 검색</button>
       
        <button type="button" class="btn btn-success" Onclick="smwindow('rgg.asp');">새그룹추가</button>    
        </div>
    </div>
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
                      <th align="center">#</th>
                      <th align="center">그룹명</th>
                      <th align="center" width="20%">성적서</th>
                      <th></th>
                      <th align="center">등록자</th>
                      <th align="center">등록일</th>
                      <th align="center">수정자</th>
                      <th align="center">수정일</th>  
                      <th align="center">사용여부</th>  
                      <th align="center">파일</th>  
                      <th align="center">성적서</th>  
                      <th align="center">관리</th>  
                  </tr>
              </thead>
              <tbody>
<%

SQL="Select A.rgidx, A.rgname, A.rgmidx, Convert(varchar(10),A.rgdate,121), A.rgemidx, Convert(varchar(10),A.rgedate,121), A.rgtype, A.rgfile "
SQL=SQL&", B.mname, C.mname, A.gstatus "
SQL=SQL&" from tk_reportg A"
SQL=SQL&" join tk_member B on A.rgmidx=B.midx "
SQL=SQL&" left outer join tk_member C on A.rgemidx=C.midx "

If Request("SearchWord")<>"" Then
    SQL=SQL&" Where (A.rgname like '%"&request("SearchWord")&"%' or B.mname like '%"&request("SearchWord")&"%' or C.mname like '%"&request("SearchWord")&"%')"
End if

SQL=SQL&" order by rgidx desc "
 

'Response.write (SQL)& "<br>"
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 15

if not (Rs.EOF or Rs.BOF) then

no = Rs.recordcount - (Rs.pagesize * (gotopage-1)) +1
totalpage=Rs.PageCount
Rs.AbsolutePage =gotopage

i=1
for j=1 to Rs.RecordCount
if i>Rs.PageSize then exit for end if
if no-j=0 then exit for end if

    rgidx=Rs(0)
    rgname=Rs(1)
    rgmidx=Rs(2)
    rgdate=Rs(3)
    rgemidx=Rs(4)
    rgedate=Rs(5)
    rgtype=Rs(6)
    rgfile=Rs(7)
    mname=Rs(8)
    mename=Rs(9)
    gstatus=Rs(10)

    Select case  gstatus
        case "0"
            gstatus_text="사용안함"
        case "1"
            gstatus_text="사용함"
    End Select
%>              
                  <tr>
                    <td><%=no-j%></td>
                    <td><%=rgname%></td>
                    <td>
                    <%
                    SQL="select A.rgsidx, A.ridx, B.rname, B.ron "
                    SQL=SQL&" From tk_reportgSub A "
                    SQL=SQL&" Join tk_report B On A.ridx=B.ridx "
                    SQL=SQL&" where A.rgidx='"&rgidx&"' "
                    Rs1.open Sql,Dbcon
                    If Not (Rs1.bof or Rs1.eof) Then 
                    Do while not Rs1.EOF
                        rgsidx=Rs1(0)
                        ridx=Rs1(1)
                        rname=Rs1(2)
                        ron=Rs1(3)
                    %>
                    <div class="row">
                            <button class="btn btn-outline-warning" onclick="del('<%=rgsidx%>');"><span id="text"><%=rname%>(<%=ron%>)</span></button>
                    </div>
                    <%
                    Rs1.movenext
                    Loop
                    End if
                    Rs1.close
                    %>
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <td><%=mname%></td>
                    <td><%=rgdate%></td>
                    <td><%=mename%></td>
                    <td><%=rgedate%></td>
                    <td><%=gstatus_text%></td>
                    <td><button type="button" class="btn btn-success" Onclick="window.open('/report/rfile/<%=rgfile%>');">다운로드</button></td>
                    <td><button type="button" class="btn btn-success" Onclick="smwindow('remaingropview.asp?rgidx=<%=rgidx%>');">성적서추가</button></td>
                    <td>
                        <button type="button" class="btn btn-success" Onclick="smwindow('rggudt.asp?rgidx=<%=rgidx%>');">수정</button>
                    </td>
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
        <div class="row py-3">
        <!--#include Virtual = "/inc/paging.asp" -->
        </div>
<%
Rs.close
%>

<!-- 표 형식 끝--> 

 
    </div>    
<!-- footer 시작 -->    
 
Coded By 림
 
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

