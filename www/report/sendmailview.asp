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
    projectname="성적서 메일 상세보기"
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function

    snidx=request("snidx")
    midx=request("c_midx")
    gotopage=request("gotopage")
 

	page_name="sendmailview.asp?"

    SQL="Select sndate, mtitle, mmaintext, sncemail1, snmemail, snreadstatus from tk_reportsend where snidx='"&snidx&"'"
    Rs.open Sql,Dbcon
        sndate=Rs(0)
        mtitle=Rs(1)
        mmaintext=Rs(2)
        sncemail1=Rs(3)
        snmemail=Rs(4)
        snreadstatus=Rs(5)
    Rs.Close

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
      #mmaintext {
        height: 200px;
      }      
      #download {
        width: 100px;
      }
      #box {
        width: 140px;
      }
    </style>
<script>

</script>
 
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
                            <div class="input-group">
                                <h6>발송된 메일 #<%=snidx%></h6>
                            </div>

                            <div class="input-group">
                                <h6><br>조회수: <%=snreadstatus + 1%></h6>
                            </div>

                            <div class="input-group mb-2">
                                <span id="box" class="input-group-text">발송 일시</span>
                                <span class="card form-control text-start"><%=sndate%></span>
                            </div>

                            <div class="input-group mb-2">
                                <span id="box" class="input-group-text">수신 거래처</span>
                                <span class="card form-control text-start">
                                
                                <% 
                                SQL=" Select A.cname, B.cidx, B.snsidx "
                                SQL=SQL&" From tk_customer A "
                                SQL=SQL&" Join tk_reportsendcorpSub B on B.cidx=A.cidx where snidx='"&snidx&"' "

                                'response.write (SQL)
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                Do while not Rs.EOF
                                
                                    cname=Rs(0)
                                    cidx=Rs(1)
                                    snsidx=Rs(2)
                                %>

                                <%=cname%>&nbsp;
                                
                                <%
                                Rs.movenext
                                Loop
                                End if
                                Rs.close
                                %>
                                </span>
                            </div>
                            
                            <div class="input-group mb-2">
                                <span class="input-group-text">수신 메일 주소</span>
                                    <div class="form-control text-start " style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start " style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT A.cidx, A.memail from tk_emailselect A Where A.snidx='"&snidx&"'"
                                            
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                cidx=Rs(0)
                                                memail=Rs(1)

                                                k = k + 1
                                                if k = 1 then 
                                                    amemail=memail
                                                else
                                                    amemail=memail&", "&amemail
                                                end if

                                                Rs.MoveNext
                                                Loop
                                                End If
                                                Rs.Close                                            
                                            %>

                                                <%=amemail%>

                                        </div>
                                    </div>      
                                    <input type="hidden" name="amemail" value="<%=amemail%>">
                            </div>

                            <div class="input-group mb-2">
                                <span id="box" class="input-group-text">발송 메일 주소</span>
                                <span class="card form-control text-start"><%=snmemail%></span>
                            </div>

                            <div class="input-group mb-2">
                                <span id="box" class="input-group-text">메일 제목</span>
                                <span type="text" class="card form-control text-start"><%=mtitle%></span>
                            </div>

                            <div class="input-group mb-2">
                                <span id="box" class="input-group-text">첨부된 성적서</span>
                                <div class="card form-control">
                                    <table id="datatablesSimple"  class="table table-hover">
                                        <%
                                        SQL=" Select A.ridx, A.rname, A.rfile, B.snsidx "
                                        SQL=SQL&" From tk_report A "
                                        SQL=SQL&" Join tk_reportsendsub B on B.ridx=A.ridx where snidx='"&snidx&"' "

                                        'response.write (SQL)
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do while not Rs.EOF
                                            ridx=Rs(0)
                                            rname=Rs(1)
                                            donotusergfile=Rs(2)
                                            snsidx=Rs(3)
                                        %>
                                            <tr>
                                                <td><button type="button" class="btn btn-border-success "><%=rname%></button></td>
                                                <td><button type="button" class="btn btn-outline-success" Onclick="window.open('/report/rfile/<%=rfile%>');">성적서 파일 다운로드</button></td>
                                            </tr>
                                        <%
                                        Rs.movenext
                                        Loop
                                        End if
                                        Rs.close
                                        %>

                                        <%
                                        SQL="select A.snidx, C.rname, C.ron, C.rfile "
                                        SQL=SQL&" From tk_reportsendgSub A "
                                        SQL=SQL&" Join tk_reportgsub B On B.rgidx=A.rgidx "
                                        SQL=SQL&" Join tk_report C On B.ridx=C.ridx "
                                        SQL=SQL&" where A.snidx='"&snidx&"' and B.ridx not in (Select C.ridx From tk_report C Join tk_reportsendsub D on D.ridx=C.ridx where D.snidx='"&snidx&"')"

                                        'response.write (SQL)
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do while not Rs.EOF
                                            ssnidx=Rs(0)
                                            rrname=Rs(1)
                                            rron=Rs(2)
                                            rrfile=Rs(3)
                                        %>
                                            <tr>
                                                <td><button type="button" class="btn btn-border-success "><%=rrname%></button></td>
                                                <td><button type="button" class="btn btn-outline-success" Onclick="window.open('/report/rfile/<%=rrfile%>');">성적서 파일 다운로드</button></td>
                                            </tr>
                                        <%
                                        Rs.movenext
                                        Loop
                                        End if
                                        Rs.close
                                        %>

                                    </table>
                                </div>
                            </div> 

                            <div class="input-group mb-2">
                                <span id="box" class="input-group-text">첨부된 성적서 그룹</span>
                                <div class="card form-control">
                                    <table id="datatablesSimple"  class="table table-hover">
                                        <%
                                        SQL=" Select A.rgidx, A.rgname, A.rgfile, B.snsidx "
                                        SQL=SQL&" From tk_reportg A "
                                        SQL=SQL&" Join tk_reportsendgsub B on B.rgidx=A.rgidx where snidx='"&snidx&"' "

                                        'response.write (SQL)
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do while not Rs.EOF
                                            rgidx=Rs(0)
                                            rgname=Rs(1)
                                            donotusergfile=Rs(2)
                                            snsidx=Rs(3)
                                        %>
                                            <tr>
                                                <td><button type="button" class="btn btn-border-success "><%=rgname%></button></td>
                                                <td><button type="button" class="btn btn-outline-success" Onclick="window.open('/report/rgfile/<%=rgfile%>');">성적서 그룹 파일 다운로드</button></td>
                                            </tr>
                                        <%
                                        Rs.movenext
                                        Loop
                                        End if
                                        Rs.close
                                        %>
                                    </table>
                                </div>
                            </div>                            


                            <div class="input-group mb-2">
                                <span class="input-group-text">첨부된 추가 파일</span>
                                <div class="card form-control">
                                    <%
                                    SQL=" Select efname from tk_emailatfile "
                                    SQL=SQL&" Where snidx='"&snidx&"' "

                                    'response.write (SQL)
                                    Rs.open Sql,Dbcon
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do while not Rs.EOF
                                        efname=Rs(0)

                                    %>
                                    <div class="card form-control">
                                        <button id="" type="button" class="btn btn-border-secondary" Onclick="window.open('/report/rfile/<%=efname%>');"><%=efname%></button>
                                    </div>
                                    <%
                                    Rs.movenext
                                    Loop
                                    End if
                                    Rs.close
                                    %>
                                    </div>
                            </div> 

                            <div class="input-group mb-2">
                                <span id="box" class="input-group-text">메일 내용</span>
                                <span id="mmaintext" class="card form-control text-start" name="mmaintext"><%=mmaintext%> <br><br> <a href='http://tkd001.cafe24.com/report/sendmaildownload.asp?snidx=<%=snidx%> '>다운로드</a> </span>
                                </textarea>
                            </div>                                                                                                      

                            <div class="input-group mb-3">
                                <button type="button" class="btn btn-outline-primary" Onclick="location.replace('sendmailredb.asp?snidx=<%=snidx%>');">수정 및 재전송</button>                            
                                <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('totalreport.asp?gotopage=<%=gotopage%>');">나가기</button>
                            </div>
                    </div>
                    <!--입력종료-->
                </div>
            </div>
        </main>

        <!--Footer 시작-->
        Coded By 원준 
        <!--Footer 끝-->

    </div>
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
