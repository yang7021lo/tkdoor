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
    projectname="성적서리스트"
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
    

    page_name="remainlistorg.asp?"
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
<link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f8e7375b143214↩_fe6aacc29b2d266d396%7Emv2.png/v1/fill/w32%2Ch__32%2Clg_1%2Cusm0.661.00___0.01/76309f8e7375b143214↩_fe6aacc29b2d266d396%7Emv2.png" />
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
<style>
    a:link {
        color: #070707;
        text-decoration: none;
    }
    a:visited{
        color: #070707;
        text-decoration: none;  
    }
    a:hover{
        color: #070707;
        text-decoration: none;         
    }
</style>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG2.asp"-->

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                <!--내용입력시작-->
                    <div class=" py-5 container text-center card card-body">
                        <!--버튼형식 시작-->
                        <div class="input-group mb-3">
                            <div class="col-10 text-end">
                                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="remainlist.asp"name="form1">
                                    <div class="mb-3 d-flex flex-row">
                                        <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해 주세요." name="SearchWord">  
                                        <button type="button" class="btn btn-primary" style="width:6%" Onclick="submit();">검색</button>
                                    </div>
                                </form> 
                            </div>                               
                            <div class="col-2 text-end">        
                                <button type="button" class="btn btn-outline-danger" Onclick="location.replace('remain.asp');">성적서 등록</button>
                            </div>
                        </div>
                        <!--버튼형식 끝-->

                        <%
                        SQL=" Select fname, fidx from tk_reportm where ftype=8 "
                        Rs2.open Sql,Dbcon,1,1,1
                        if not (Rs2.EOF or Rs2.BOF) then
                        for j=1 to Rs2.RecordCount
                        if no-j=0 then exit for end if
                        acfname=Rs2(0)
                        acfidx=Rs2(1)
                        %>
                        <!--표형식 시작-->
                        <div class="input-group mb-3">
                            <div class="accordion-item" style="width:100%" >
                                <h2 class="accordion-header" id="first">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%=acfidx%>" aria-expanded="false" aria-controls="collapseorder">
                                        <div class="sb-nav-link-icon"></div>&nbsp;&nbsp;<%=acfname%>
                                    </button>
                                </h2>
                                <div id="collapse<%=acfidx%>" class="accordion-collapse collapse" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
                                    <div class="accordion-body">
                                        <%
                                        SQL=" Select fname, fidx from tk_reportm where ftype=1 "
                                        Rs1.open Sql,Dbcon,1,1,1
                                        if not (Rs1.EOF or Rs1.BOF) then
                                        for jj=1 to Rs1.RecordCount
                                        if no-jj=0 then exit for end if
                                        aacfname=Rs1(0)
                                        aacfidx=Rs1(1)
                                        %>
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="headingOne">
                                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#acollapse<%=acfidx%><%=aacfidx%>" aria-expanded="false" aria-controls="collapseorder">
                                                <div class="sb-nav-link-icon"></div>&nbsp;&nbsp;<%=aacfname%>
                                            </button>
                                            </h2>
                                            <div id="acollapse<%=acfidx%><%=aacfidx%>" class="accordion-collapse collapse <%=aacfidx%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
                                                <div class="accordion-body">
                                                    <div class="input-group mb-3">
                                                        <table id="datatablesSimple" class="table table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th align="center">접수번호</th>
                                                                    <th align="center">시료명</th>
                                                                    <th align="center">유리사양</th>
                                                                    <th align="center">유리상세</th>
                                                                    <th align="center">단열성능</th>
                                                                    <th align="center">수정자</th>
                                                                    <th align="center">수정일</th>
                                                                    <th align="center">사용여부</th>
                                                                    <th align="center">관리</th>
                                                                    <th></th>
                                                                </tr>                               
                                                            </thead>

                                                            <tbody>
                                                                <%
                                                                    SQL= "select a.ridx, a.ron, a.rname, a.ruse, a.rtdate, a.rwtype, a.rwidth "
                                                                    SQL=SQL&",a.rinsp, a.rherp, a.rwatp, a.rpa, a.roc, a.rwdate, a.rmidx, b.mname, a.rstatus, a.rfile, a.remidx, c.mname, Convert(varchar(10), a.rewdate,121), a.rgthickness, a.rfixtop "
                                                                    SQL=SQL&" from tk_report A "
                                                                    SQL=SQL&" Join tk_member B on A.rmidx=B.midx "
                                                                    SQL=SQL&" left outer join tk_member C on A.remidx=C.midx "
                                                                    SQL=SQL&" Join tk_reportSub D On D.ridx=A.ridx "
                                                                    SQL=SQL&" Where D.rfidx='"&acfidx&"' or D.rfidx='"&aacfidx&"' "


                                                                    SQL=SQL&" Order by A.ridx desc "   
                                                                    'Response.write (SQL)& "<br>"
                                                                    Rs.open Sql,Dbcon,1,1,1
                                                                    Rs.Pagesize=15

                                                                    if not (Rs.EOF or Rs.BOF) then
                                                                    no = Rs.recordcount - (Rs.pagesize * (gotopage-1))+1
                                                                    totalpage=Rs.PageCount
                                                                    i=1

                                                                    for jjj=1 to Rs.RecordCount
                                                                    if i>Rs.PageSize then exit for end if
                                                                    if no-jjj=0 then exit for end if

                                                                        ridx=Rs(0)
                                                                        ron=Rs(1)
                                                                        rname=Rs(2)
                                                                        ruse=Rs(3)
                                                                        rtdate=Rs(4)
                                                                        rwtypw=Rs(5)
                                                                        rwidth=Rs(6)
                                                                        rinsp=Rs(7)
                                                                        rherp=Rs(8)
                                                                        rwatp=Rs(9)
                                                                        rpa=Rs(10)
                                                                        roc=Rs(11)
                                                                        rwdate=Rs(12)
                                                                        rmidx=Rs(13)
                                                                        mname=Rs(14)
                                                                        rstatus=Rs(15)
                                                                        rfile=Rs(16)
                                                                        remidx=Rs(17)
                                                                        cmname=Rs(18)
                                                                        rewdate=Rs(19)
                                                                        rgthickness=Rs(20)
                                                                        rfixtop=Rs(21)

                                                                    SQL=" select A.rsidx, B.fname "
                                                                    SQL=SQL&" from Tk_reportsub A "
                                                                    SQL=SQL&" join tk_reportm B on A.rfidx = B.fidx "
                                                                    SQL=SQL&" where A.ridx='"&ridx&"' and A.rftype=4 "
                                                                    SQL=SQL&" Order by A.rsidx desc "
                                                                    
                                                                    Rs3.open Sql,Dbcon
                                                                    if not (Rs3.EOF or Rs3.BOF) then
                                                                    do while not Rs3.EOF

                                                                        rsidx =Rs3(0)
                                                                        fname =Rs3(1)

                                                                        k = k + 1
                                                                        if k = 1 then 
                                                                        afname=fname
                                                                        else
                                                                        afname=fname&" + "&afname
                                                                        end if
                                                                        
                                                                    Rs3.Movenext
                                                                    Loop
                                                                    End if
                                                                    Rs3.Close



                                                                    select case rstatus
                                                                        case "0"
                                                                            rstatus_text="사용중지"
                                                                        case "1"
                                                                            rstatus_text="사용중"
                                                                    end select                                   
                                                                %>

                                                                <tr>
                                                                    <td><%=ron%></td>               <!--접수번호-->
                                                                    <td><%=rname%></td>             <!--시료명-->
                                                                    <td><%=rgthickness%></td>       <!--유리사양-->
                                                                    <td><%=afname%></td>            <!--유리상세-->
                                                                    <td><%=rinsp%></td>             <!--단열성능-->
                                                                    <td><%=cmname%></td>             <!--수정자-->
                                                                    <td><%=rewdate%></td>           <!--수정일-->
                                                                    <td><%=rstatus_text%></td>      <!--사용여부-->
                                                                    <td><button type="button" class="btn btn-primary" onClick="location.replace('remain2.asp?ridx=<%=ridx%>&gotopage=<%=gotopage%>');">수정</button></td><!--관리-->
                                                                    <td>
                                                                    <% if rfixtop=1 then %>
                                                                    <button type="button" class="btn btn-outline-danger" onClick="location.replace('rsendfixtopdb.asp?ridx=<%=ridx%>&gotopage=<%=gotopage%>&SearchWord=<%=SearchWord%>');">즐겨찾기 삭제</button>                                       
                                                                    <% else %>
                                                                    <button type="button" class="btn btn-outline-warning" onClick="location.replace('rsendfixtopdb.asp?ridx=<%=ridx%>&gotopage=<%=gotopage%>&SearchWord=<%=SearchWord%>&added=1');">즐겨찾기 추가</button>
                                                                    <% end if %>
                                                                    </td><!--관리-->                                    
                                                                </tr>

                                                                <%
                                                                afname=""
                                                                k=0
                                                                i=i+1
                                                                Rs.MoveNext
                                                                Next
                                                                End If 
                                                                Rs.Close                              
                                                                %>
                                                                <div class="row col-12 py-0">
                                                                    <!--#include Virtual = "/inc/paging.asp"-->
                                                                </div> 
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <%
                                        Rs1.MoveNext
                                        Next
                                        End If
                                        Rs1.Close    
                                        %>
                                    </div>
                                </div>
                            </div>
                            <%
                            Rs2.MoveNext
                            Next
                            End If
                            Rs2.Close
                            %>

                        </div>
                        <!--표형식 끝-->  
                    </div>
                </div>
                <!--입력종료-->
            </div>
            
            <!--Footer 시작-->
            <div class="text-center">Coded By 원준</div>
            <!--Footer 끝-->

        </main>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>

</body>
</html>

<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()

%>
