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
 
projectname="제품관리"
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


SearchWord=Request("SearchWord")


	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="frmmgnt.asp?"

gubun=Request("gubun")
doc_type=Request("doc_type")
oidx=REquest("oidx")
if doc_type="" then 
  doc_type="e"
end if

Select case doc_type
  case "e"
    doc_type_text="견적서"
  case "o"
    doc_type_text="발주서"
  case "w"
    doc_type_text="작업지시서"
End select

'업무기본 순서
'검측-견적서+발주서(소량의 경우 동시진행 많이함)생성-발주처 컨펌-작업지시서 전송 
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
    <script>
        function check(sTR)
        {
            if (confirm("해당 자재를 삭제 하시겠습니까?"))
            {
                location.href="frmmgnt.asp?gubun=del&tidx=<%=Request("tidx")%>&sbdepth=<%=Request("sbdepth")%>&ssidx="+sTR;
            }
        }
    </script>


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
%>            
                <main>
                    <div class="container-fluid px-4">
                        <div class="row justify-content-between">

                            <div class="col-12 mt-4 mb-2 text-end">
                            <button type="button" class="btn btn-primary" onclick="location.replace('frmmgnt.asp?gubun=make');">등록</button>
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
                                            <h1 class="modal-title fs-5" id="exampleModalLabel">발주사 조회</h1>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="order.asp?listgubun=two&subgubun=two1" name="searchForm">
                                                <div class="input-group">
                                                    <input class="form-control" type="text" placeholder="검색" aria-label="검색" aria-describedby="btnNavbarSearch" name="SearchWord" />
                                                    <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="searchForm.submit();"><i class="fas fa-search"></i></button>&nbsp;
                                                    <button type="button" class="btn btn-primary" onClick="location.replace('customer.asp?gubun=insert')">발주사 추가</button>
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
                        <div class="card card-body mb-4">
                                <table id="datatablesSimple"  class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th align="center">번호</th>
                                            <th align="center">제품명</th>
                                            <th align="center">제품타입</th>
                                            <th align="center">재질</th>
                                            <th align="center">도장</th>
                                            <th align="center">상태</th>
                                            <th align="center">관리</th>  
                                        </tr>
                                    </thead>

                                    <tbody>
<%

SQL=" Select A.tidx, A.tname, A.ttype, A.gtype, A.aidx, A.tprice, A.tstatus, A.timg, A.tsvg, A.twidx, A.twdate "
SQL=SQL&" , B.mname, C.atitle "
SQL=SQL&" From tk_Frm A "
SQL=SQL&" Join tk_member B On A.twidx=B.midx "
SQL=SQL&" Join tk_FrmMat C On A.aidx=C.aidx "
SQL=SQL&" Order By A.tidx desc "
'Response.write (SQL)	
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 8

if not (Rs.EOF or Rs.BOF ) then
	no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
	totalpage=Rs.PageCount '		
	Rs.AbsolutePage =gotopage
	i=1
	for j=1 to Rs.RecordCount 
	if i>Rs.PageSize then exit for end if
	if no-j=0 then exit for end if

    tidx=Rs(0)
    tname=Rs(1)
    ttype=Rs(2)
    gtype=Rs(3)
    aidx=Rs(4)
    tprice=Rs(5)
    tstatus=Rs(6)
    timg=Rs(7)
    tsvg=Rs(8)
    twidx=Rs(9)
    wdate=Rs(10)
    mname=Rs(11)
    atitle=Rs(12)

    if ttype="1" then 
        ttype_text="알루미늄 단열"
    elseif ttype="2" then 
        ttype_text="알루미늄 비단열"
    elseif ttype="3" then 
        ttype_text="스텐레스"
    end If

    select case gtype
        case "1"
            gtype_text="자동프레임"
        case "2"
            gtype_text="고정프레임"
        case "3"
            gtype_text="도어"
    end select 

    if tstatus="0" then 
        tstatus_text="중지"
    elseif tstatus="1" then 
        tstatus_text="사용"
    end if
%> 
                                        <tr>
                                            <td><%=no-i%></td>
                                            <td><%=tname%></td>
                                            <td><%=gtype_text%></td>
                                            <td><%=ttype_text%></td>
                                            <td><%=atitle%></td>
                                            <td><%=tstatus_text%></td>
                                            <td><button type="button" class="btn btn-primary" onClick="location.replace('frmmgnt.asp?gubun=join&tidx=<%=tidx%>')">관리</button></td>
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
<% elseif gubun="make" or gubun="edit" then %>
<%



%>
<main>
    <div class="container-fluid px-4 mt-4 mb-2"> 
        <div class="card card-body mb-4"> 
            <div class="row">

            </div>

            <div class="row mt-2">
<% if gubun="make" then 
rttype=Request("ttype")
if rttype="" then 
    rttype="1"
end if 
if rttype="1" or rttype="2" then 
    atype="1"
elseif rttype="3" then 
    atype="3"
end if

if rgtype="" then 
    rgtype="1"
end if


if rtstatus="" then 
    rtstatus="1"
end if 


%>            
    <form name="frmMain" action="frmmgnt.asp?gubun=insert" method="post"   ENCTYPE="multipart/form-data">	
<% elseif gubun="edit" then 
tidx=Request("tidx")
%>
    <%
    SQL=" Select tname, ttype, gtype, aidx, tprice, tstatus, timg, tsvg, twidx, twdate "
    SQL=SQL&" From tk_Frm "
    SQL=SQL&" Where tidx='"&tidx&"'"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        rtname=Rs(0)
        rttype=Rs(1)
        rgtype=Rs(2)
        raidx=Rs(3)
        rtprice=Rs(4)
        rtstatus=Rs(5)
        rtimg=Rs(6)
        rtsvg=Rs(7)
        rtwidx=Rs(8)
        rtwdate=Rs(9)

        if rttype="1" or rttype="2" then 
            atype="1"
        elseif rttype="3" then 
            atype="3"
        end if


    End If
    Rs.Close
    %>
    <form name="frmMain" action="frmmgnt.asp?gubun=update" method="post"   ENCTYPE="multipart/form-data">	
    <input type="hidden" name="tidx" value="<%=tidx%>">
<% end if %>
<input type="hidden" name="twidx" value="<%=twidx%>">

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="name">재질</label><p>
                        <input type="radio" name="ttype" class="form-check-input" value="1" <% if rttype="1" then %>checked<% end if %> onclick="location.replace('frmmgnt.asp?gubun=make&ttype=1');">알루미늄 단열
                        <input type="radio" name="ttype" class="form-check-input" value="2" <% if rttype="2" then %>checked<% end if %> onclick="location.replace('frmmgnt.asp?gubun=make&ttype=2');">알루미늄 비단열
                        <input type="radio" name="ttype" class="form-check-input" value="3" <% if rttype="3" then %>checked<% end if %> onclick="location.replace('frmmgnt.asp?gubun=make&ttype=3');">스텐레스
 
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="name">상품구분</label><p>
                        <input type="radio" name="gtype" class="form-check-input" value="1" <% if rgtype="1" then %>checked<% end if %>>자동프레임
                        <input type="radio" name="gtype" class="form-check-input" value="2" <% if rgtype="2" then %>checked<% end if %>>고정프레임
                        <input type="radio" name="gtype" class="form-check-input" value="3" <% if rgtype="3" then %>checked<% end if %>>도어

 
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="name">프레임명</label>
                        <input type="text" class="form-control" id="tname" name="tname" placeholder="<%=rtname%>" value="<%=rtname%>" required>
                    </div>

                    <div class="col-md-2 mb-3">
                        <label for="name">도장</label>

                        <select name="aidx" class="form-control" id="aidx" required>
                        <%
                        SQL=" Select aidx, atitle, atype, astatus, awidx, awdate "
                        SQL=SQL&" From tk_FrmMat "
                        SQL=SQL&" Where atype='"&atype&"' and astatus=1 "
                        
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do until Rs.EOF
                            aidx=Rs(0)
                            atitle=Rs(1)
                            atype=Rs(2)
                            astatus=Rs(3)
                            awidx=Rs(4)
                            awdate=Rs(5)
                        %>                
                            <option value="<%=aidx%>" <% if Cint(aidx)=Cint(raidx) Then %>selected<% end if %>><%=atitle%></option>
                        <%
                        Rs.MoveNext
                        Loop
                        End If
                        Rs.close
                        %>
                        </select>
                    </div>


                </div>
                <div class="row">
                    <div class="col-md-2 mb-3">
                        <label for="name">상태</label><p>
                        <input type="radio" name="tstatus" class="form-check-input" value="1" <% if rtstatus="1" then %>checked<% end if %> >사용중
                        <input type="radio" name="tstatus" class="form-check-input" value="0" <% if rtstatus="0" then %>checked<% end if %> >중지
 
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="name">도면이미지</label>
                        <input type="file" class="form-control" id="timg" name="timg" placeholder="<%=timg%>" value="<%=timg%>" >
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="name">SVG</label>
                        <input type="file" class="form-control" id="tsvg" name="tsvg" placeholder="<%=tsvg%>" value="<%=tsvg%>" >
                    </div>
                    <div class="col-md-2 mb-3">
                        <label for="nickname">평당단가</label>
                        <input type="text" class="form-control" id="tprice" name="tprice" placeholder="" value="<%=rtprice%>" >
                    </div>
                </div>
                <div class="row">
                    <button class="btn btn-primary"  type="submit" >저장</button>
                </div>
            </div>
</form>
        </div>
    </div>
</main>                  

<% elseif gubun="join" then %>
<%
tidx=Request("tidx")
bidx=Request("bidx")
sbdepth=Request("sbdepth")
if sbdepth="" then 
'    sbdepth="100"
end if


If bidx<>"" then 
SQL=" Insert into tk_FrmSub (tidx, bidx, fswdate, midx) "
SQL=SQL&" Values ('"&tidx&"', '"&bidx&"', getdate(), '"&midx&"') "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)	
Response.write "<script>location.replace('frmmgnt.asp?gubun=join&tidx="&tidx&"&sbdepth="&sbdepth&"');</script>"
End if

SQL=" Select A.tname, A.ttype, A.gtype, A.aidx, A.tprice, A.tstatus, A.timg, A.tsvg, A.twidx, Convert(Varchar(10),A.twdate,121) "
SQL=SQL&" , B.atitle, B.atype "
SQL=SQL&" From tk_Frm A"
SQL=SQL&" Join tk_FrmMat B On A.aidx=B.aidx "
SQL=SQL&" Where A.tidx='"&tidx&"'"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
    tname=Rs(0)
    ttype=Rs(1)
    gtype=Rs(2)
    aidx=Rs(3)
    tprice=Rs(4)
    tstatus=Rs(5)
    timg=Rs(6)
    tsvg=Rs(7)
    twidx=Rs(8)
    twdate=Rs(9)
    atitle=Rs(10)
    atype=Rs(11)

    if ttype="1" then 
        ttype_text="알루미늄 단열"
    elseif ttype="2" then 
        ttype_text="알루미늄 비단열"
    elseif ttype="3" then 
        ttype_text="스텐레스"
    end If

    select case gtype
        case "1"
            gtype_text="자동프레임"
        case "2"
            gtype_text="고정프레임"
        case "3"
            gtype_text="도어"
    end select 

    select case tstatus
        case "0"
            tstatus="중지"
            class_text="btn-danger"
        case "1"
            tstatus="사용중"
            class_text="btn-primary"
    end select 

End If
Rs.Close
%>
<main>
    <div class="container-fluid px-4 mt-4 mb-2"> 
        <h2><%=tname%><button type="button" class="btn btn-sm <%=class_text%>"><%=tstatus%></button>
        &nbsp;<button type="button" class="btn btn-sm btn-danger" onclick="location.replace('frmmgnt.asp?gubun=edit&tidx=<%=tidx%>');">수정</button></h2>
        <div class="row">
        <!-- 제품 자재 보기 시작-->
            <div class="col-8">
                <div class="card card-body mb-4"> 
                    <div class="row mt-2">
                        <div class="col-md-3 mb-3">
                            <label for="cname"><strong>재질구분</strong></label>
                            <font class="text-secondary"><%=ttype_text%></font>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="cname"><strong>상품구분</strong></label>
                            <font class="text-secondary"><%=gtype_text%></font>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="name"><strong><% if ttype="1" or ttype="2" then %>도장<% elseif ttype="3" then %>재질<% end if %></strong></label>
                            <font class="text-secondary"><%=atitle%></font>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="cname"><strong>평당단가</strong></label>
                            <font class="text-secondary"><%=tprice%></font>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="cname"><strong>상태</strong></label>
                            <font class="text-secondary"><%=tstatus%></font>
                        </div>
                    </div>

                    <div class="row mt-2">
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th class="text-start">번호</th>
                                    <th class="text-start">자재명</th>
                                    <th class="text-end">깊이</th>
                                    <th class="text-end">너비</th>
                                    <th class="text-end">높이</th>
                                    <th class="text-end">단가</th>
                                </tr>
                            </thead>
                            <tbody>
<%
SQL=" Select A.sidx, A.bidx, B.btitle, B.bdepth, B.bwidth, B.bheight, B.buprice"
SQL=SQL&" From tk_FrmSub A "
SQL=SQL&" Join tk_FrmBra B On A.bidx=B.bidx "
SQL=SQL&" Where A.tidx='"&tidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  Do until Rs.EOF

  sidx=Rs(0)
  bidx=Rs(1)
  btitle=Rs(2)
  bdepth=Rs(3)
  bwidth=Rs(4)
  bheight=Rs(5)
  buprice=Rs(6)

  i=i+1
%>
                                <tr>
                                    <td class="text-start"><%=i%></th>
                                    <td class="text-start"><a onclick="check('<%=sidx%>')"><%=btitle%></a></th>
                                    <td class="text-end"><%=bdepth%></th>
                                    <td class="text-end"><%=bwidth%></th>
                                    <td class="text-end"><%=bheight%></th>
                                    <td class="text-end"><%=buprice%></th>
                                </tr>
<%
  Rs.MoveNext
  Loop
End If
Rs.close
%>
                            </tbody>
                        </table>

                    </div>
<!-- 도면 부분 시작 -->
             
                    <div class="row">
<% if tsvg<>"" then %>                    
                        <iframe src="./img/frame/<%=tsvg%>" title="내용" width="1000" height="600" scrolling="no"></iframe>
<% elseif timg<>"" then %>
                        <img src="./img/frame/<%=timg%>">
<% end if%>                        
                    </div>
<!-- 도면 부분 끝 -->
                </div>
            </div>
        <!-- 제품 자재 보기 끝 -->
        <!-- 자재 고르기 시작 -->
            <div class="col-4">
                <div class="card card-body mb-4"> 
                    <div class="row">
                    <div class="col-12"><b>깊이선택 : </b>
<%
SQL=" Select distinct bdepth "
SQL=SQL&" From tk_FrmBra "
SQL=SQL&" Where aidx='"&aidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  Do until Rs.EOF
  bdepth=Rs(0)

  if sbdepth="" then sbdepth=bdepth end if
%>    

                        <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="bdepth" id="bdepth" value="<%=bdepth%>" Onclick="location.replace('frmmgnt.asp?gubun=join&tidx=<%=tidx%>&sbdepth=<%=bdepth%>');" <% if Cint(sbdepth)=Cint(bdepth) then %>checked<% end if %>>
                        <label class="form-check-label" for="bdepth"><%=bdepth%></label>
                        </div>
<%
  Rs.MoveNext
  Loop
End If
Rs.close
%>
                    </div>
                    </div>
                    <table id="datatablesSimple"  class="table table-hover">
                        <thead>
                            <tr>
                                <th align="center">자재명</th>
                                <th align="center">깊이</th>
                                <th align="center">너비</th>
                                <th align="center">높이</th>

                            </tr>
                        </thead>
                        <tbody>
<%
SQL=" Select A.bidx, A.btitle, A.bdepth, A.bwidth, A.bheight, A.bstatus, A.bwidx, Convert(Varchar(10),A.bwdate,121), A.buprice, A.gtype , B.mname "
SQL=SQL&" , C.atitle, C.astatus  "
SQL=SQL&" From tk_FrmBra A  "
SQL=SQL&" Join tk_member B On A.bwidx=B.midx  "
SQL=SQL&" Join tk_FrmMat C On A.aidx=C.aidx "
SQL=SQL&" Where A.aidx='"&aidx&"' and A.bdepth='"&sbdepth&"' "
SQL=SQL&" and A.bidx not in (select D.bidx from tk_Frmsub D where D.tidx='"&tidx&"' ) "
SQL=SQL&" Order By A.btitle asc "
'response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  Do until Rs.EOF
  bidx=Rs(0)
  btitle=Rs(1)
  bdepth=Rs(2)
  bwidth=Rs(3)
  bheight=Rs(4)
  bstatus=Rs(5)
  bwidx=Rs(6)
  bwdate=Rs(7)
  buprice=Rs(8)
  gtype=Rs(9)
  mname=Rs(10)
  atitle=Rs(11)
  astatus=Rs(12)

  if sbdepth="" then 
    sbdepth=bdepth
  end if 
%>
                            <tr>
                                <td><a onclick="location.replace('frmmgnt.asp?gubun=join&tidx=<%=tidx%>&bidx=<%=bidx%>&sbdepth=<%=sbdepth%>')"><%=btitle%></a></td>
                                <td><%=bdepth%></td>
                                <td><%=bwidth%></td>
                                <td><%=bheight%></td>
                            </tr>
<%
  Rs.MoveNext
  Loop
End If
Rs.close
%>
                        </tbody>
                    </table>
 

                </div>            
            </div>
        <!-- 자재 고르기 끝 -->    
        </div>

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
if gubun="insert" or gubun="update" then 
' DextUpload 시작
'==============================
Set uploadform = Server.CreateObject("DEXT.FileUpload") 

  
uploadform.AutoMakeFolder = True

uploadform.DefaultPath=DefaultPath&"\frame"
 
'response.end

    tname = uploadform("tname")
	ttype = uploadform("ttype")
    gtype = uploadform("gtype")
    aidx=uploadform("aidx") 

    tprice = uploadform("tprice")
    twidx = uploadform("twidx")
    tstatus =  uploadform("tstatus")

 
'response.end
timg = uploadform("timg").Save( ,false)
board_file_name1 = uploadform("timg").LastSavedFileName 

'response.write file1&"#<br>"
'response.write "#"&board_file_name1&"##<br>"

	if right(board_file_name1,4)="jpeg" then 
		tmpnamelat=right(board_file_name1,5)
	else
		tmpnamelat=right(board_file_name1,4)
	end if

'response.write filename&"/<br>"
'response.write tmpnamelat&"//<br>"

if tmpnamelat<>"" then 
board_file_name1= ymdhns&tmpnamelat
'response.write "/"&board_file_name1&"/<br>"
    if tmpnamelat<>"" then 
    board_file_name0 = uploadform.SaveAs(board_file_name1, False)        
    end if

end if

'tsvg입력
tsvg = uploadform("tsvg").Save( ,false)
board_file_name3 = uploadform("tsvg").LastSavedFileName 

'if right(board_file_name3,4)="html"  then 
'    tmpnamelat1=right(board_file_name3,5)
'else
'    tmpnamelat1=right(board_file_name3,4)
'end if
'if tmpnamelat1<>"" then 
'board_file_name3="s"&ymdhns&tmpnamelat1

'    if tmpnamelat1<>"" then 
'    board_file_name2 = uploadform.SaveAs(board_file_name3, False)        
'    end if

'end if

' DextUpload 끝
'============================== 
if twidx="" then 
    twidx="1"
end if 


    if gubun="insert" then 
        SQL=" Insert into tk_Frm (tname, ttype, gtype, aidx, tprice, tstatus, timg, tsvg, twidx, twdate) "
        SQL=SQL&" values ('"&tname&"', '"&ttype&"', '"&gtype&"', '"&aidx&"', '"&tprice&"', '"&tstatus&"', '"&board_file_name1&"', '"&board_file_name3&"', '"&twidx&"',getdate()) "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)	
        Response.write "<script>location.replace('frmmgnt.asp');</script>"
    elseif gubun="update" then 
        tidx = uploadform("tidx")

        SQL="Select timg, tsvg From tk_Frm Where tidx='"&tidx&"' "
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
          timg=Rs(0)
          tsvg=Rs(1)
        End If
        Rs.Close

        if board_file_name1="" then board_file_name1=timg end if
        if board_file_name3="" then board_file_name3=tsvg end if

        SQL=" Update tk_Frm set tname='"&tname&"', ttype='"&ttype&"', gtype='"&gtype&"', aidx='"&aidx&"' "
        SQL=SQL&" , tprice='"&tprice&"', tstatus='"&tstatus&"', timg='"&board_file_name1&"', tsvg='"&board_file_name3&"', twidx='"&twidx&"', twdate=getdate() "
        SQL=SQL&" Where tidx='"&tidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)	
        Response.write "<script>location.replace('frmmgnt.asp?gubun=join&tidx="&tidx&"');</script>"
    end if



elseif gubun="del" then 

ssidx=Request("ssidx")
tidx=Request("tidx")
sbdepth=Request("sbdepth")

SQL=" Delete From tk_FrmSub Where sidx='"&ssidx&"' "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)	
Response.write "<script>location.replace('frmmgnt.asp?gubun=join&tidx="&tidx&"&sbdepth="&sbdepth&"');</script>"

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
