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
 
projectname="금속/재질/도장관리"
gubun=Request("gubun")

%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="matmgnt.asp?"


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
        <link href="css/styles.css" rel="stylesheet" />
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
        <script src="//code.jquery.com/jquery-1.12.0.min.js"></script>



    <!-- Custom styles for this template -->
    <link href="sidebars.css" rel="stylesheet">
    </head>
    <body class="sb-nav-fixed">


<!--#include virtual="/inc/top.asp"-->
<!-- -->        

<!--#include virtual="/inc/left3.asp"-->
<!-- -->

            <div id="layoutSidenav_content">
<%
if gubun="" then 

mtype=Request("mtype")
if mtype="" then 
  mtype="2"
end if
%>            
                <main>
                    <div class="container-fluid px-4">
                        <div class="row justify-content-between">
                            <div class="col-4  mt-4 mb-2 text-start">
<button type="button" <% if mtype="1" then %>class="btn btn-success"<% else %>class="btn btn-secondary"<% end if %> onclick="location.replace('matmgnt.asp?mtype=1');">금속</button>
<button type="button" <% if mtype="2" then %>class="btn btn-danger"<% else %>class="btn btn-secondary"<% end if %> onclick="location.replace('matmgnt.asp?mtype=2');">재질</button>
<button type="button" <% if mtype="3" then %>class="btn btn-warning"<% else %>class="btn btn-secondary"<% end if %> onclick="location.replace('matmgnt.asp?mtype=3');">도장</button>

                            </div>
                            <div class="col-8 mt-4 mb-2 text-end">
                            <button type="button" class="btn btn-primary" onclick="location.replace('matmgnt.asp?tgubun=input');">등록</button>
<!--modal start -->
                                <!-- Button trigger modal -->
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
                                검색
                                </button>

                                <!-- Modal -->
                                <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="exampleModalLabel">재질 조회</h1>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="matmgnt.asp" name="searchForm">
                                                <div class="input-group">
                                                    <input class="form-control" type="text" placeholder="검색" aria-label="검색" aria-describedby="btnNavbarSearch" name="SearchWord" />
                                                    <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="searchForm.submit();"><i class="fas fa-search"></i></button>&nbsp;
                                                </div>
                                            </form>

                                        </div>
                  
                                    </div>
                                </div>
                                </div>
                                

                            </div>
                            <div></div>
<!--modal end -->

                        </div>
<%
'if Request("tgubun")="input" or Request("tgubun")="edit"  then 

taidx=Request("taidx")

SQL="Select atitle, atype, astatus, awidx, awdate "
SQL=SQL&" From tk_FrmMat "
SQL=SQL&" Where aidx='"&taidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
    ratitle=Rs(0)
    ratype=Rs(1)
    rastatus=Rs(2)
    rawidx=Rs(3)
    rawdate=Rs(4)
End if
Rs.Close
%>                        
                        <div class="card card-body mb-4">
            <div class="row">
<% if taidx<>"" then %>
    <form name="frmMain" action="matmgnt.asp?gubun=update&gotopage=<%=gotopage%>" method="post" ENCTYPE="multipart/form-data">	
    <input type="hidden" name="taidx" value="<%=taidx%>">
<% else %>
    <form name="frmMain" action="matmgnt.asp?gubun=insert" method="post" ENCTYPE="multipart/form-data">	
<% end if %>
    <input type="hidden" name="mtype" value="<%=mtype%>">
                <div class="row">
                    <div class="col-md-4">
                        <input type="text" class="form-control" id="atitle" name="atitle" placeholder="도장명" value="<%=ratitle%>" required>
                    </div>
                    <div class="col-md-2">
                        <input type="radio" name="astatus" class="form-check-input" value="1" <% if rastatus="1" or rastatus=""  then %>checked<% end if %> >사용
                        <input type="radio" name="astatus" class="form-check-input" value="0" <% if rastatus="0" then %>checked<% end if %> >중지
                    </div>
                    

                    <div class="col-md-2">
                        <button class="btn btn-primary"  type="submit" >저장</button>
                    </div>
                </div>

</form>
        </div>

                        </div>
<%' end if%>                        
                        <div class="card card-body mb-4">
                                <table id="datatablesSimple"  class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th align="center">번호</th>
                                            <th align="center">재질명</th>
                                            <!--<th align="center">구분</th>-->
                                            <th align="center">상태</th>
                                            <th align="center">생성자</th>
                                            <th align="center">생성일</th>                                          
                                            <th align="center">관리</th>  
                                        </tr>
                                    </thead>

                                    <tbody>
<%
SQL=" Select A.aidx, A.atitle, A.atype, A.astatus, A.awidx, Convert(Varchar(10),A.awdate,121), B.mname "
SQL=SQL&" From tk_FrmMat A"
SQL=SQL&" Join tk_member B On A.awidx=B.midx "
SQL=SQL&" Where A.mtype='"&mtype&"' "
if SearchWord<>"" then 
SQL=SQL&" and (A.atitle like '%"&request("SearchWord")&"%' or B.mname like '%"&request("SearchWord")&"%') "
end if
SQL=SQL&" Order By A.aidx desc "
'Response.write (SQL)	
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 8

if not (Rs.EOF or Rs.BOF ) then
	no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
	totalpage=Rs.PageCount	
	Rs.AbsolutePage = gotopage
	i=1
	for j=1 to Rs.RecordCount 
	if i>Rs.PageSize then exit for end if
	if no-j=0 then exit for end if

    taidx=Rs(0)
    atitle=Rs(1)
    atype=Rs(2)
    astatus=Rs(3)
    awidx=Rs(4)
    awdate=Rs(5)
    mname=Rs(6)

 

    if astatus="0" then 
        astatus_text="중지"
    elseif astatus="1" then 
        astatus_text="사용"
    end if
%> 
                                        <tr>
                                            <td><%=no-i%></td>
                                            <td><%=atitle%></td>
                                            <!--<td><%=atype_text%></td>-->
                                            <td><% if astatus="0" then %><p class="text-danger"><% end if %><%=astatus_text%></td>
                                            <td><%=mname%></td>
                                            <td><%=awdate%></td>
                                            <td><button type="button" class="btn btn-primary" onClick="location.replace('matmgnt.asp?taidx=<%=taidx%>&mtype=<%=mtype%>&gotopage=<%=gotopage%>')">관리</button></td>
                                        </tr>
<%
    Rs.MoveNext 
    i=i+1
    Next 
 
%>
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
End If    
%> 
                    </div>

                </main>
<% elseif gubun="make" then %>
               

<% end if %>            
               
 
<!-- footer 시작 -->                
 
<!-- footer 끝 --> 
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
        <script src="assets/demo/chart-area-demo.js"></script>
        <script src="assets/demo/chart-bar-demo.js"></script>
<!--
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
        <script src="js/datatables-simple-demo.js"></script>
-->
    </body>
</html>
<%
if gubun="insert" then 
    
    Set uploadform = Server.CreateObject("DEXT.FileUpload") 
    uploadform.AutoMakeFolder = True

    uploadform.DefaultPath=DefaultPath&"\frame"

 
        astatus = uploadform("astatus")
        atitle = uploadform("atitle")
        mtype = uploadform("mtype")
    
    if awidx="" then 
        awidx="1"
    end if 

    SQL=" Insert into tk_FrmMat ( atitle, atype, astatus, awidx, awdate, mtype ) "
    SQL=SQL&" Values ('"&atitle&"', '', '"&astatus&"', '"&awidx&"', getdate(), '"&mtype&"') "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)	
    Response.write "<script>location.replace('matmgnt.asp?mtype="&mtype&"&');</script>"

elseif gubun="update" then  
 
    Set uploadform = Server.CreateObject("DEXT.FileUpload") 
    uploadform.AutoMakeFolder = True

    uploadform.DefaultPath=DefaultPath&"\frame"
        taidx = uploadform("taidx")
 
        astatus = uploadform("astatus")
        atitle = uploadform("atitle")
        mtype = uploadform("mtype")
    if awidx="" then 
        awidx="1"
    end if 

    SQL="Update tk_FrmMat set atitle='"&atitle&"', atype='', astatus='"&astatus&"', awidx='"&awidx&"', awdate=getdate(), mtype='"&mtype&"' "
    SQL=SQL&" where aidx='"&taidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)	
    Response.write "<script>location.replace('matmgnt.asp?mtype="&mtype&"&gotopage="&gotopage&"');</script>"


end if
%>
<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
