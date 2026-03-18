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
    projectname="sujuin"
    gubun=Request("gubun")
    rgoidx=Request("goidx")
    rcidx=Request("cidx")
    roidx=Request("oidx")
    serdate=Request("serdate")
    rsjaidx=Request("sjaidx")

    if request("gotopage")="" then
    gotopage=1
    else
    gotopage=request("gotopage")
    end if 
    page_name="sujunow.asp?"

    if serdate="" then 
        serdate=date()
    end if


    if rgoidx<>"" then 
    SQL=" Select gotype, gocode, gocword, goname, gopaint, gosecfloor ,gomidkey ,gounit,gostatus , gomidx, gowdate, goemidx"
    SQL=SQL&" From tk_goods "
    SQL=SQL&" Where gotype=1 and goidx='"&rgoidx&"' "
    'RESPONSE.WRITE (SQL)
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 

        gotype=rs(0)
        gocode=rs(1)
        gocword=rs(2)
        goname=rs(3)
        gopaint=rs(4)
        gosecfloor=rs(5)
        gomidkey=rs(6)
        gounit=rs(7)
        gostatus=rs(8)
        gomidx=rs(9)
        gowdate=rs(10)
        goemidx=rs(11)

    end if 
    rs.close    
    end if 


    SQL=" Select A.cstatus, A.cname, A.cceo,  A.ctkidx, A.caddr1, A.cmemo,  A.cwdate, A.ctel, A.cfax, A.cnick"
    SQL=SQL&" From tk_customer A "
    SQL=SQL&" Where cidx='"&rcidx&"' "
    Rs.open SQL,Dbcon
    if not (Rs.EOF or Rs.BOF ) then
        cstatus=Rs(0)
        cname=Rs(1)
        cceo=Rs(2)
        ctkidx=Rs(3)
        caddr1=Rs(4)
        cmemo=Rs(5)
        cwdate=Rs(6)
        ctel=Rs(7)
        cfax=Rs(8)
        cnick=Rs(9)
    End If
    Rs.Close


    SQL=" select sjaddress, sjnumber, sjtatus, sjqty, Convert(varchar(10),sujudate,121), sjchulgo, Convert(varchar(10),sjchulgodate,121), sjamidx, Convert(varchar(10),sjamdate,121), sjameidx, Convert(varchar(10),sjamedate,121) "
    SQL=SQL&" from tk_sujua "
    SQL=SQL&" where sjaidx='"&rsjaidx&"'"
    Rs.open SQL,Dbcon
    if not (Rs.EOF or Rs.BOF ) then
        rsjaddress=Rs(0)
        rsjnumber=Rs(1)
        rsjtatus=Rs(2)
        rsjqty=Rs(3)
        rsujudate=Rs(4)
        rsjchulgo=Rs(5)
        rsjchulgodate=Rs(6)
        rsjamidx=Rs(7)
        rsjamdate=Rs(8)
        rsjameidx=Rs(9)
        rsjamedate=Rs(10)
    End If
    Rs.Close

'if gubun="new" then     '신규 수주등록
 '   otitle=cnick&"_"&ymdhns
'    ocode=ymdhns

'    SQL="Select max(oidx) From tk_odr where cidx='"&rcidx&"' "
'    Rs.open SQL,Dbcon
'    if not (Rs.EOF or Rs.BOF ) then
 '       oidx=Rs(0)+1
 '   End if
 '   Rs.Close


 '   SQL="Insert into tk_odr (oidx, cidx, otitle, ocode, ostatus, owidx, owdate)"
'    SQL=SQL&" Values('"&oidx&"','"&rcidx&"', '"&otitle&"', '"&ocode&"', 0, '"&c_midx&"', getdate())"
'    Response.write (SQL)&"<br>"
'    Dbcon.execute (SQL)
 '   response.write "<script>location.replace('sujuin.asp?cidx="&rcidx&"&oidx="&oidx&"');</script>"

'End if
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
        function validateForm(){
                document.frmMain.submit();
            }
        function validateFormb(){
                document.frmMainb.submit();
            }            
    </script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_mes1.asp"-->


<div id="layoutSidenav_content">            
  <main>
    <div class="container-fluid px-4">
      <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
        <div class="card card-body mb-1">

          <div class="row ">

            <div class="col-md-2">
              <label for="name">거래처</label><p>
              <input type="text" class="form-control" id="" name="" placeholder="" value="<%=cname%>" onclick="location.replace('/mem/corplist.asp');">
            </div>
            <div class="col-md-6">
              <label for="name">사업장</label><p>
              <input type="text" class="form-control" id="" name="" placeholder="" value="<%=caddr1%>" readonly>
            </div> 
            <div class="col-md-2">
              <label for="name">TEL</label><p>
              <input type="text" class="form-control" id="" name="" placeholder="" value="<%=ctel%>" readonly>
            </div> 
            <div class="col-md-2">
              <label for="name">FAX</label><p>
              <input type="text" class="form-control" id="" name="" placeholder="" value="<%=cfax%>" readonly>
            </div> 

          </div>

        <div class="row ">
      
          <div class="col-md-4">
            <label for="name">비고</label><p>
            <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
          </div>
          <div class="col-md-4">
            <label for="name">참고사항</label><p>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
          <div class="col-md-2">
            <label for="name">관리등급</label><p>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
          <div class="col-md-2">
            <button type="button" class="btn btn-info" onClick="location.replace('/mes/sujuin.asp?cidx=<%=rcidx%>&gubun=new')">수주등록</button>
          </div> 
        </div>
      </div>
<!--거래처 끝 -->
<!--수주일자 시작 -->
<% if rsjaidx="" then  %>
<form name="frmMain" action="sujuindbA.asp" method="post">
<% else %>
<form name="frmMain" action="sujuindbAU.asp" method="post">
<input type="hidden" name="sjaidx" value="<%=rsjaidx%>">
<% end if%>


<input type="hidden" name="cidx" value="<%=rcidx%>">
    <div class="card card-body mb-1">
      <div class="row ">

        <div class="col-md-2">
          <label for="name">수주일자</label>
          <input type="date" class="form-control" id="" name="sujudate" placeholder="" value="<%=rsujudate%>" >
        </div>
        <div class="col-md-2">
          <label for="name">수주번호</label><p>
            <%
            SQL="Select max(sjnumber) From tk_sujua where Convert(Varchar(10),sujudate,121)='"&serdate&"' "
            'response.write (SQL)
            Rs.open SQL,Dbcon
            if not (Rs.EOF or Rs.BOF ) then
                sjnumber=Rs(0)

                if isnull(sjnumber) then 
                    nsjnumber="1"
                else
                    nsjnumber=sjnumber+1
                end if  
                vsjnmber=yy&mm&dd&"-"&nsjnumber
            End if
            Rs.Close


            %>
          <input type="hidden" class="form-control" id="" name="sjnumber" placeholder="" value="<%=nsjnumber%>" >
          <input type="text" class="form-control" id="" name="" placeholder="" value="<%=vsjnmber%>" <% if rsjaidx<>"" then response.write "readonly" end if %>>


        </div> 
        <div class="col-md-1">
          <label for="name">&nbsp;</label><p>
          <i class="fa-solid fa-plus fa-lg"></i>
          <i class="fa-solid fa-minus  fa-lg"></i>
          <i class="fa-solid fa-calendar-days fa-lg"></i>
          <i class="fa-solid fa-building fa-lg fa-beat-fade"></i>
        </div> 
        <div class="col-md-2">
          <label for="name">현장</label><p>
          <input type="text" class="form-control" id="" name="sjaddress" placeholder="" value="<%=rsjaddress%>" >
        </div> 
        <div class="col-md-2">
          <label for="name">출고구분</label><p>
          <select class="form-select" name="sjchulgo">
            <option value="1" <% if rsjchulgo="1" or rsjchulgo="" then  %>selected<% end if %>>배달</option>
            <option value="2" <% if rsjchulgo="2" then  %>selected<% end if %>>화물</option>
            <option value="3" <% if rsjchulgo="3" then  %>selected<% end if %>>용차</option>
            <option value="4" <% if rsjchulgo="4" then  %>selected<% end if %>>도장</option>
        </select>          
        </div> 
        <div class="col-md-2">
          <label for="name">출고일자</label><p>
          <input type="date" class="form-control" id="" name="sjchulgodate" placeholder="" value="<%=rsjchulgodate%>" >
        </div> 
        <div class="col-md-1">
          <label for="name">세율</label><p>
          <input type="text" class="form-control" id="" name="" placeholder="" value="" >
        </div> 

      </div>
      <div class="row ">
      
        <div class="col-md-2">
          <label for="name">품목</label><p>
            <select class="form-select" name="sjqty">
                <option value="1" <% if rsjqty="1" or rsjqty="" then  %>selected<% end if %>>도어</option>
                <option value="2" <% if rsjqty="2" then  %>selected<% end if %>>프레임</option>
                <option value="3" <% if rsjqty="3" then  %>selected<% end if %>>보호대</option>
                <option value="4" <% if rsjqty="4" then  %>selected<% end if %>>자동문</option>
            </select>
        </div>
        <div class="col-md-4">
          <div class="input-group mb-3">
          <% if rsjaidx="" then  %>
            <button type="button" class="btn btn-outline-primary" onclick="validateForm();">저장</button>
        <% else %>
            <button type="button" class="btn btn-outline-secondary" onclick="validateForm();">수정</button>
        <% end if %>
        </div>     

          <button class="btn btn-primary"  type="submit" >외주발주</button>
          <button class="btn btn-success"  type="submit" >문자전송</button>
          <button class="btn btn-danger"  type="submit" >복사</button>
          <button class="btn btn-warning"  type="submit" >견적읽기</button>
        </div> 
        <div class="col-md-6 card card-body mb-1  ">
        <div class="row">
          <div class="col-md-1 text-end">
          <label for="name">합계</label>
          </div>
          <div class="col-md-4">
            <label for="name">공급가액</label>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
          <div class="col-md-3">
            <label for="name">세액</label>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
          <div class="col-md-4">
            <label for="name">금액</label>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
        </div>
        </div>

      </div>
    </div>
</form>
<!--수주일자 끝 -->
<!--수주현황 시작 -->
         <!--입력시작-->
         <div class="container py-5 text-center">
            <div class="input-group mb-1">
              <!--게시판 제목하고 검색 버튼-->
                    <div class="col-1 text-end">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">검색</button>
                    </div>
            </div>
            <div class="text-end mb-1">
                <!--modal-->
                <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5" id="exampleModalLabel">검색</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="close"></button>
                            </div>
                            <div class="modal-body">
                                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="/mes/sujunow.asp" name="form1">
                                <div class="mb-3">
                                    <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해주세요" name="SearchWord">
                        
                                </div>
                                <div class="col-12">
                                    <button type="button" onclick="submit();" class="btn btn-primary ">등록</button>
                                </div>
                                </form>
                            </div>
                        </div>
                </div>
                </div>
            <!--modal end-->
            </div>
            <div class="card mb-4 card-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">#</th>     <!--no-j--> 
                            <th scope="col">수주일자</th> <!--sujudate tk_sujua--> 
                            <th scope="col">거래처</th> <!--cname tk_customer--> 
                            <th scope="col">현장</th> <!--sjaddress tk_sujua--> 
                            <th scope="col">수번</th> <!--sjnumber tk_sujua--> 
                            <th scope="col">품번</th> <!--sjbidx tk_sujub--> 
                            <th scope="col">구분</th> <!--sjqty tk_sujua--> 
                            <th scope="col">품목</th> <!--sjbpummyoung tk_sujub--> 
                            <th scope="col">규격</th> <!--26개--> 
                            <th scope="col">수량</th> <!--sjbqty tk_sujua--> 
                            <th scope="col">세부정보</th> <!--26개--> 
                            <th scope="col">단가</th> <!--26개--> 
                            <th scope="col">공급가</th> <!--26개--> 
                            <th scope="col">세액</th><!--26개--> 
                            <th scope="col">금액</th><!--26개--> 
                            <th scope="col">출고일자</th><!--sjchulgodate tk_sujua--> 
                            <th scope="col">출고구분</th><!--sjchulgo tk_sujua--> 
                            <th scope="col">위치</th><!--sjbwitch tk_sujub--> 
                            <th scope="col">비고</th><!--sjbbigo tk_sujub--> 
                            <th scope="col">작성자</th><!--sjamidx tk_sujua--> 
                            <th scope="col">작성일시</th><!--sjamdate tk_sujua--> 
                            <th scope="col">수정자</th><!--sjameidx tk_sujua--> 
                            <th scope="col">수정일시</th><!--sjamedate tk_sujua--> 
                            <th scope="col">원단가</th><!-- --> 
                            <th scope="col">추가금</th><!-- --> 
                            <th scope="col">할인단가</th><!-- -->        <!--총26개-->                                           
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <%
                        SQL=" Select A.sjaidx, A.sjaddress, B.cname, A.sjnumber, A.sjtatus, A.sjqty, A.sujudate, A.sjchulgo, A.sjchulgodate, A.sjamidx, A.sjamdate, A.sjameidx, A.sjamedate ,C.sjbidx,C.sjbpummyoung,C.sjbwitch,C.sjbbigo "
                        SQL=SQL&" From tk_sujua A"
                        SQL=SQL&" Left Outer Join tk_customer B On  A.cidx=B.cidx "
                        SQL=SQL&" Left Outer Join tk_sujub c On  A.cidx=C.sjbidx "                        
                        If Request("SearchWord")<>"" Then 
                        SQL=SQL&" Where(sjaddress like '%"&request("SearchWord")&"%'  or sjnumber like '%"&request("SearchWord")&"%'  or sujudate like '%"&request("SearchWord")&"%'  or sjchulgo like '%"&request("SearchWord")&"%'  ) "
                        End If 
                        SQL=SQL&" Order by A.sjaidx asc "
                        'Response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon,1,1,1
                        Rs.PageSize = 10
                        
                        if not (Rs.EOF or Rs.BOF) then 
                        no = Rs.Recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                        totalpage=Rs.PageCount
                        Rs.AbsolutePage=gotopage
                        i=1
                        for j=1 to Rs.RecordCount 
                        if i>Rs.PageSize then exit for end if 
                        if no-j=0 then exit for end if 
                        
                        sjaidx=Rs(0)
                        sujudate=Rs(1)
                        cname=Rs(2)
                        sjaddress=Rs(3)
                        sjnumber=Rs(4)
                        sjbidx=Rs(5)
                        sjqty=Rs(6)
                        sjbpummyoung=Rs(7)
                        sjbqty=Rs(8)
                        sjchulgodate=Rs(9)
                        sjchulgo=Rs(10)
                        sjbwitch=Rs(11)
                        sjbbigo=Rs(12)
                        sjamidx=Rs(13)
                        sjamdate=Rs(14)
                        sjameidx=Rs(15)
                        sjamedate=Rs(16)
                         %> 
                         <tr>
                            <th scope="row" rowspan="2"><%=no-j%></th>
                            <td><%=sujudate%></td>
                            <td><%=cname%></td>
                            <td><%=sjaddress%></td>
                            <td><%=sjnumber%></td>
                            <td><%=sjbidx%></td>
                            <td><%=sjqty%></td>                            
                            <td><%=sjbpummyoung%></td>
                            <td></td>
                            <td><%=sjbqty%></td> 
                            <td></td>
                            <td></td>
                            <td></td>                             
                            <td></td>
                            <td></td>
                            <td><%=sjchulgodate%></td> 
                            <td><%=sjchulgo%></td>
                            <td><%=sjbwitch%></td>
                            <td><%=sjbbigo%></td> 
                            <td><%=sjamidx%></td> 
                            <td><%=sjamdate%></td>
                            <td><%=sjameidx%></td>
                            <td><%=sjamedate%></td>    
                            <td></td>                             
                            <td></td>
                            <td></td>                                                                                                              
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
            <div class="row col-12 py-3">
                <!--#include Virtual = "/inc/paging.asp"-->
            </div>
            
        </div>
<!--수주현황 끝 -->
<%
Rs.Close
%>
<!--  -->
<!-- 내용입력 끝 -->
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 양양
 
<!-- footer 끝 --> 
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
