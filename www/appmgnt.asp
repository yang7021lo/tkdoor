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
	page_name="appmgnt.asp?SearchWord="&request("SearchWord")&"&"

gubun=Request("gubun")
projectname="자재관리"
SearchWord=Request("SearchWord")
 

if gubun="unit" then 
  bdepth=Request("bdepth")
  bwidth=Request("bwidth")

  utitle=bdepth&"&times;"&bwidth&"&nbsp;단가표"
  SQL="Insert into tk_mUnit (utitle, ustatus, udate )"
  SQL=SQL&" Values ('"&utitle&"', '1', getdate())"
  'Response.write (SQL)&"<br>"
  'Response.end
  Dbcon.Execute (SQL)	
  Response.write "<script>location.replace('appmgnt.asp');</script>"
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
        <script src="https://code.jquery.com/jquery-1.12.0.min.js"></script>
    <!-- Custom styles for this template -->
    <link href="sidebars.css" rel="stylesheet">
    <script>
    function check(sTR)
    {
      if (confirm("취소 하시겠습니까?"))
      {
        location.href="mgnt.asp?part=delete&uidx="+sTR;
      }
    }
    </script
    </head>
    <body class="sb-nav-fixed">




            <div id="layoutSidenav_content">
<%
if gubun="" then 
%>            
                <main>
                    <div class="container-fluid px-4">
                        <div class="row justify-content-between">

                            <div class="col-12 mt-4 mb-2 text-end">
                            <button type="button" class="btn btn-primary" onclick="location.replace('appmgnt.asp?tgubun=input');">자재등록</button>
<!--modal start -->
                                <!-- Button trigger modal -->
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
                                자재검색
                                </button>

                                <!-- Modal -->
                                <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="exampleModalLabel">자재 조회</h1>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="appmgnt.asp" name="searchForm">
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
if Request("tgubun")="input" or Request("tgubun")="edit"  then 

tbidx=Request("tbidx")

SQL="Select A.btitle, A.bdepth, A.bwidth, A.bheight, A.bstatus, A.buprice, A.aidx, A.gtype "
SQL=SQL&" From tk_FrmBra A "
SQL=SQL&" Where bidx='"&tbidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
    rbtitle=Rs(0)
    rbdepth=Rs(1)
    rbwidth=Rs(2)
    rbheight=Rs(3)
    rbstatus=Rs(4)
    rbuprice=Rs(5)
    raidx=Rs(6)
    rgtype=Rs(7)
else
    rbdepth="0"
    rbwidth="0"
    rbheight="0"
    rbuprice="0"
End if
Rs.Close

%>                        
                        <div class="card card-body mb-4">
            <div class="row">
<% if tbidx<>"" then %>
    <form name="frmMain" action="appmgnt.asp?gubun=update&gotopage=<%=gotopage%>" method="post" ENCTYPE="multipart/form-data">	
    <input type="hidden" name="tbidx" value="<%=tbidx%>">
<% else %>
    <form name="frmMain" action="appmgnt.asp?gubun=insert" method="post" ENCTYPE="multipart/form-data">	
<% end if %>

<input type="hidden" name="SearchWord" value="<%=SearchWord%>">
                <div class="row">
                
                    <div class="col-md-2">
                    <label for="nickname">제품타입</label>
                        <select name="gtype" class="form-control" id="gtype" required>
                        <option value="1" <% if rgtype="1"  or rgtype="" Then %>selected<% end if %>>자동프레임</option>
                        <option value="2" <% if rgtype="2" Then %>selected<% end if %>>고정프레임</option>
                        <option value="3" <% if rgtype="3" Then %>selected<% end if %>>도어</option>
                        </select>	
                    </div>
                    <div class="col-md-2">
                        <label for="cname">자재명</label>
                        <input type="text" class="form-control" id="btitle" name="btitle" placeholder="" value="<%=rbtitle%>" required>
                    </div>
                    <div class="col-md-2">
                        <label for="cname">깊이</label>
                        <input type="number" class="form-control text-end" id="bdepth" name="bdepth" placeholder="깊이" value="<%=rbdepth%>" required>
                    </div>
                    <div class="col-md-2">
                        <label for="cname">너비</label>
                        <input type="number" class="form-control text-end" id="bwidth" name="bwidth" placeholder="너비" value="<%=rbwidth%>" required>
                    </div>
                    <div class="col-md-2">
                        <label for="cname">높이</label>
                        <input type="number" class="form-control text-end" id="bheight" name="bheight" placeholder="높이" value="<%=rbheight%>" required>
                    </div>
                    <div class="col-md-2 text-start">
                        <label for="cname">단가</label>
                        <input type="number" class="form-control text-end" id="buprice" name="buprice" placeholder="단가" value="<%=rbuprice%>" required>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-2">
                        <label for="cname">상태</label>
                        <select name="bstatus" class="form-control" id="bstatus" required>
                            <option value="1" <% if rbstatus="1" or rbstatus="" Then %>selected<% end if %>>사용중</option>
                            <option value="0" <% if rbstatus="0"  Then %>selected<% end if %>>중지</option>
                        </select>	
                    </div>
                    <div class="col-md-2">
                        <label for="cname">재질</label>
                        <select name="aidx" class="form-control" id="aidx" required>
<%
SQL=" Select aidx, atitle, atype From tk_FrmMat Where astatus=1 and mtype=2 "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
    aidx=Rs(0)
    atitle=Rs(1)
    atype=Rs(2)
%>
                            <option value="<%=aidx%>" <% if Cint(raidx)=Cint(aidx)  Then %>selected<% end if %>><%=atitle%></option>
<%
Rs.movenext
Loop
End if
Rs.close
%> 
                        </select>	
                    </div>
                    <div class="col-md-8 text-end">
                        <br>
                        <button class="btn btn-primary"  type="submit" >저장</button>
                        <button class="btn btn-primary"  type="button" Onclick="location.replace('appmgnt.asp');">닫기</button>
                    </div>
                </div>

</form>
        </div>

                        </div>
<% end if%>  
<!--                      
<%
SQL=" Select uidx, utitle From tk_mUnit "
SQL=SQL&" Order by utitle asc"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
    uidx=Rs(0)
    utitle=Rs(1)

%>

<button type="button" class="btn btn-primary" onclick="location.replace('appmgnt.asp?gubun=make&uidx=<%=uidx%>');"><%=utitle%></button>
                        <div class="card card-body mb-4">
                          <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                              <tr>
                                <th>명칭</th>
                                <th>규격</th>
<%
SQL=" Select aidx, atitle From tk_FrmMat where mtype=2 and astatus=1"
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
Do while not Rs1.EOF
    aidx=Rs1(0)
    atitle=Rs1(1)
%>
                                <th><%=atitle%></th>
<%
Rs1.movenext
Loop
End if
Rs1.close
%>
                    
                              </tr>
                            </thead>

                            <tbody>
                              <tr>
                                <td>명칭</td>
                                <td>규격</td>
<%
SQL=" Select aidx, atitle From tk_FrmMat where mtype=2 and astatus=1"
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
Do while not Rs1.EOF
    aidx=Rs1(0)
    atitle=Rs1(1)
%>
                                <td><%=atitle%></td>
<%
Rs1.movenext
Loop
End if
Rs1.close
%>
                              </tr>
                            </tbody>
                          </table>
                        </div>


<%
Rs.movenext
Loop
End if
Rs.close
%>
-->

                        <div class="card card-body mb-4">
                                <table id="datatablesSimple"  class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th align="center">번호</th>
                                            <th align="center">구분</th>
                                            <th align="center">재질</th>
                                            <th align="center">자재명</th>
                                            <th align="center">깊이</th>
                                            <th align="center">너비</th>
                                            <th align="center">높이</th>
                                            <th align="center">단가</th>
                                            <th align="center">상태</th>
                                            <th align="center">생성자</th>
                                            <th align="center">생성일</th>                                          
                                            <th align="center">관리</th>  
                                        </tr>
                                    </thead>

                                    <tbody>
<%
SQL=" Select A.bidx, A.btitle, A.bdepth, A.bwidth, A.bheight, A.bstatus, A.bwidx, Convert(Varchar(10),A.bwdate,121), A.buprice, A.gtype "
SQL=SQL&" , B.mname, C.atitle, C.astatus "
SQL=SQL&" From tk_FrmBra A "
SQL=SQL&" Join tk_member B On A.bwidx=B.midx "
SQL=SQL&" Join tk_FrmMat C On A.aidx=C.aidx "
SQL=SQL&" Where A.bstatus='1' "
if request("SearchWord")<>"" then 
SQL=SQL&" and (A.btitle like '%"&request("SearchWord")&"%' or B.mname like '%"&request("SearchWord")&"%' "
SQL=SQL&" or C.atitle like '%"&request("SearchWord")&"%')"
end if
SQL=SQL&" Order By A.bidx desc "
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

    tbidx=Rs(0)
    btitle=Rs(1)
    bdepth=Rs(2)
    bwidth=Rs(3)
    bheight=Rs(4)
    bstatus=Rs(5)
    bwidx=Rs(6)
    bwdate=Rs(7)
    buprice=Rs(8)
    bgtype=Rs(9)
    mname=Rs(10)
    atitle=Rs(11)
    astatus=Rs(12)

    if bstatus="0" then 
        bstatus_text="중지"
    elseif bstatus="1" then 
        bstatus_text="사용"
    end if

    if bgtype="1" then 
        bgtype_text="자동프레임"
    elseif bgtype="2" then 
        bgtype_text="고정프레임"
    elseif bgtype="3" then 
        bgtype_text="도어"
    end if 
%> 
                                        <tr>
                                            <td><%=no-i%></td>
                                            <td><%=bgtype_text%></td>
                                            <td><%=atitle%></td>
                                            <td><%=btitle%></td>
                                            <td><%=bdepth%></td>
                                            <td><%=bwidth%></td>
                                            <td><%=bheight%></td>
                                            <td><%=buprice%></td>
                                            <td><% if bstatus="0" then %><p class="text-danger"><% end if %><%=bstatus_text%></td>
                                            <td><%=mname%></td>
                                            <td><%=bwdate%></td>
                                            <td><button type="button" class="btn btn-primary" onClick="location.replace('appmgnt.asp?tgubun=edit&SearchWord=<%=Request("SearchWord")%>&tbidx=<%=tbidx%>&gotopage=<%=gotopage%>')">관리</button></td>
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
<% elseif gubun="make" then 
uidx=Request("uidx")
tbidx=Request("tbidx")
subgubun=Request("subgubun")
SearchWord=Request("SearchWord")
sbdepth=Request("bdepth")
sbwidth=Request("bwidth")
'response.write sbdepth&"<br>"
'response.write sbwidth&"<br>"

if subgubun="add" then 
  SQL="Insert into tk_mUnitSub (uidx, bidx, usdate, usstatus ) "
  SQL=SQL&" Values ('"&uidx&"','"&tbidx&"', getdate(), 1) "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)	
  Response.write "<script>location.replace('appmgnt.asp?gubun=make&uidx="&uidx&"&bdepth="&sbdepth&"&bwidth="&sbwidth&"&SearchWord="&SearchWord&"');</script>"
end if

SQL=" Select utitle "
SQL=SQL&" From tk_mUnit "
SQL=SQL&" Where uidx='"&uidx&"'"
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  utitle=Rs(0)
End If
Rs.Close



%>
                <main>
                  <div class="container-fluid px-4">
                      
                      <div class="row mt-4">
                      <h3><%=utitle%></h3>
                      </div>

                      <div class="row justify-content-between">

                        <div class="card card-body mb-4 mt-4 ms-3 me-3">
                          <table id="datatablesSimple"  class="table table-hover">
                            <thead>

                              <tr>
                                <th class="text-center">명칭</th>
                                <th class="text-center">규격</th>
<%
SQL=" Select aidx, atitle From tk_FrmMat where mtype=2 and astatus=1"
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
Do while not Rs1.EOF
    aidx=Rs1(0)
    atitle=Rs1(1)
%>
                                <th class="text-center"><%=atitle%></th>
<%
Rs1.movenext
Loop
End if
Rs1.close
%>
                    
                              </tr>
                            </thead>

                            <tbody>
<%
SQL=" Select distinct btitle, bdepth, bwidth "
SQL=SQL&" From tk_mUnit A "
SQL=SQL&" Join tk_mUnitSub B On A.uidx=B.uidx "
SQL=SQL&" Join tk_FrmBra C On B.bidx=C.bidx "
SQL=SQL&" Where C.bstatus='1' and A.uidx='"&uidx&"' "
Rs.open Sql,Dbcon
Response.write (SQL)&"<br><br>"
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
    btitle=Rs(0)
    bdepth=Rs(1)
    bwidth=Rs(2)
%>
                              <tr>
                                <td class="text-center"><%=btitle%></td>
                                <td class="text-center"><%=bdepth%>&times;<%=bwidth%></td>
<%
SQL=" Select aidx, atitle From tk_FrmMat where mtype=2 and astatus=1"

Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
Do while not Rs1.EOF
    aidx=Rs1(0)
    atitle=Rs1(1)

SQL=" Select B.bidx, B.buprice From tk_mUnitSub A "
SQL=SQL&" Join tk_FrmBra B On A.bidx=B.bidx "
SQL=SQL&" Where B.bstatus=1 and B.btitle='"&btitle&"' and A.uidx='"&uidx&"' and B.aidx='"&aidx&"' "
'Response.write (SQL)&"<br><br>"
Rs2.open Sql,Dbcon
If Not (Rs2.bof or Rs2.eof) Then 
    bidx=Rs2(0)
    buprice=Rs2(1)
End If
Rs2.Close
%>
                                <td class="text-end"><a onClick="del('<%=usidx%>');"><%=FormatNumber(buprice, 0)%></a></td>
<%
bidx=""
buprice=0
aidx=""
atitle=""
Rs1.movenext
Loop
End if
Rs1.close
%>
                              </tr>
<%
 
Rs.movenext
Loop
End if
Rs.close
%>

                            </tbody>
                          </table>
                        </div>



                      </div>
                      <div class="row mb-4 text-end">
                        <div class="col-6">
                        </div>
                        <div class="col-5 ">
                          <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="appmgnt.asp?gubun=make" name="searchForm">
                          <input type="hidden" name="uidx" value="<%=uidx%>">
      

  
                            <div class="input-group">
<!-- 깊이 선택 시작 -->
                        <select name="bdepth" class="form-control" id="bdepth" required>
                         <option value="" <% if sbdepth="" Then %>selected<% end if %>>깊이</option>
                        <%
                          SQL="select distinct bdepth from tk_FrmBra where bstatus=1 "
                          Rs1.open Sql,Dbcon
                          If Not (Rs1.bof or Rs1.eof) Then 
                          Do while not Rs1.EOF
                              bdepth=Rs1(0)
                        %>
                        <option value="<%=bdepth%>" <% if Cint(bdepth)=Cint(sbdepth) Then %>selected<% end if %>><%=bdepth%></option>
                        <%
                          Rs1.movenext
                          Loop
                          End if
                          Rs1.close
                        %>
                        </select>	
<!-- 깊이 선택 끝 -->
<!-- 너비 선택 시작 -->
                        <select name="bwidth" class="form-control" id="bwidth" required>
                         <option value="" <% if sbwidth="" Then %>selected<% end if %>>너비</option>
                        <%
                          SQL="select distinct bwidth from tk_FrmBra where bstatus=1 "
                          Rs1.open Sql,Dbcon
                          If Not (Rs1.bof or Rs1.eof) Then 
                          Do while not Rs1.EOF
                              bwidth=Rs1(0)
                        %>
                        <option value="<%=bwidth%>" <% if Cint(bwidth)=Cint(sbwidth) Then %>selected<% end if %>><%=bwidth%></option>
                        <%
                          Rs1.movenext
                          Loop
                          End if
                          Rs1.close
                        %>
                        </select>	
<!-- 깊이 선택 끝 -->
                              <input class="form-control" type="text" placeholder="검색" aria-label="검색" aria-describedby="btnNavbarSearch" name="SearchWord" value="<%=request("SearchWord")%>"/>
                              <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="searchForm.submit();"><i class="fas fa-search"></i></button>&nbsp;
                            </div>
                          </form>
                        </div>
                      </div>
<%
if request("SearchWord")<>"" then 
%>

                        <div class="card card-body mb-4">
                                <table id="datatablesSimple"  class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th align="center">번호</th>
                                            <th align="center">구분</th>
                                            <th align="center">재질</th>
                                            <th align="center">자재명</th>
                                            <th align="center">깊이</th>
                                            <th align="center">너비</th>
                                            <th align="center">높이</th>
                                            <th align="center">단가</th>
                                            <th align="center">상태</th>
                                            <th align="center">생성자</th>
                                            <th align="center">생성일</th>                                          
                                            <th align="center">관리</th>  
                                        </tr>
                                    </thead>

                                    <tbody>
<%
SQL=" Select A.bidx, A.btitle, A.bdepth, A.bwidth, A.bheight, A.bstatus, A.bwidx, Convert(Varchar(10),A.bwdate,121), A.buprice, A.gtype "
SQL=SQL&" , B.mname, C.atitle, C.astatus "
SQL=SQL&" From tk_FrmBra A "
SQL=SQL&" Join tk_member B On A.bwidx=B.midx "
SQL=SQL&" Join tk_FrmMat C On A.aidx=C.aidx "

SQL=SQL&" Where bdepth='"&sbdepth&"' and bwidth='"&sbwidth&"' "
SQL=SQL&" and A.bidx not in (Select bidx From tk_mUnitSub where uidx='"&uidx&"') "
SQL=SQL&" and (A.btitle like '%"&request("SearchWord")&"%' or B.mname like '%"&request("SearchWord")&"%' "
SQL=SQL&" or C.atitle like '%"&request("SearchWord")&"%' or A.bdepth like '%"&request("SearchWord")&"%' or A.bwidth like '%"&request("SearchWord")&"%') "

SQL=SQL&" Order By A.bidx desc "
'Response.write (SQL)	
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 80

if not (Rs.EOF or Rs.BOF ) then
	no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
	totalpage=Rs.PageCount	
	Rs.AbsolutePage = gotopage
	i=1
	for j=1 to Rs.RecordCount 
	if i>Rs.PageSize then exit for end if
	if no-j=0 then exit for end if

    tbidx=Rs(0)
    btitle=Rs(1)
    bdepth=Rs(2)
    bwidth=Rs(3)
    bheight=Rs(4)
    bstatus=Rs(5)
    bwidx=Rs(6)
    bwdate=Rs(7)
    buprice=Rs(8)
    bgtype=Rs(9)
    mname=Rs(10)
    atitle=Rs(11)
    astatus=Rs(12)

    if bstatus="0" then 
        bstatus_text="중지"
    elseif bstatus="1" then 
        bstatus_text="사용"
    end if

    if bgtype="1" then 
        bgtype_text="자동프레임"
    elseif bgtype="2" then 
        bgtype_text="고정프레임"
    elseif bgtype="3" then 
        bgtype_text="도어"
    end if 
%> 
                                        <tr>
                                            <td><%=no-i%></td>
                                            <td><%=bgtype_text%></td>
                                            <td><%=atitle%></td>
                                            <td><%=btitle%></td>
                                            <td><%=bdepth%></td>
                                            <td><%=bwidth%></td>
                                            <td><%=bheight%></td>
                                            <td><%=buprice%></td>
                                            <td><% if bstatus="0" then %><p class="text-danger"><% end if %><%=bstatus_text%></td>
                                            <td><%=mname%></td>
                                            <td><%=bwdate%></td>
                                            <td><button type="button" class="btn btn-primary" onClick="location.replace('appmgnt.asp?gubun=make&subgubun=add&uidx=<%=uidx%>&tbidx=<%=tbidx%>&bdepth=<%=sbdepth%>&bwidth=<%=sbwidth%>&SearchWord=<%=SearchWord%>&gotopage=<%=gotopage%>')">추가</button></td>
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
<% end if %>


                  </div>
                </main>
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

        gtype = uploadform("gtype")
        btitle = uploadform("btitle")
        bdepth = uploadform("bdepth")
        bwidth = uploadform("bwidth")
        bheight = uploadform("bheight")
        bwidx = uploadform("bwidx")
        buprice = uploadform("buprice")
        aidx = uploadform("aidx")
        bstatus = uploadform("bstatus")
    if bwidx="" then 
        bwidx="1"
    end if 

    SQL=" Insert into tk_FrmBra (gtype, btitle, bdepth, bwidth, bheight, bstatus, bwidx, bwdate, buprice, aidx)"
    SQL=SQL&" Values ('"&gtype&"','"&btitle&"', '"&bdepth&"', '"&bwidth&"', '"&bheight&"', '"&bstatus&"', '"&c_midx&"', getdate(), '"&buprice&"', '"&aidx&"')"
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)	
    Response.write "<script>location.replace('appmgnt.asp?tgubun=input');</script>"

elseif gubun="update" then  
 
    Set uploadform = Server.CreateObject("DEXT.FileUpload") 
    uploadform.AutoMakeFolder = True

    uploadform.DefaultPath=DefaultPath&"\frame"


        tbidx = uploadform("tbidx")
        gtype = uploadform("gtype")
        btitle = uploadform("btitle")
        bdepth = uploadform("bdepth")
        bwidth = uploadform("bwidth")
        bheight = uploadform("bheight")
        bstatus = uploadform("bstatus")
        bwidx = uploadform("bwidx")
        buprice = uploadform("buprice")
        aidx = uploadform("aidx")
        SearchWord = uploadform("SearchWord")
    if bwidx="" then 
        bwidx="1"
    end if 

    SQL="Update tk_FrmBra set gtype='"&gtype&"', btitle='"&btitle&"', bdepth='"&bdepth&"', bwidth='"&bwidth&"', bheight='"&bheight&"'"
    SQL=SQL&" , bstatus='"&bstatus&"', bwidx='"&c_midx&"', bwdate=getdate(), buprice='"&buprice&"',aidx='"&aidx&"' "
    SQL=SQL&" where bidx='"&tbidx&"' "
    'Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)	
    Response.write "<script>location.replace('appmgnt.asp?SearchWord="&SearchWord&"&gotopage="&gotopage&"');</script>"


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
