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
    projectname="성적서 다운로드"
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
    ecount=request("ecount")

    If ecount=1 then

        SQl=" Select snreadstatus from tk_reportsend Where snidx='"&snidx&"' "
        Rs.open Sql,Dbcon
            
            csnreadstatus=Rs(0)

        Rs.close

        plusone=csnreadstatus + 1

        SQL=" Update tk_reportsend set snreadstatus='"&plusone&"' Where snidx='"&snidx&"'"
        Dbcon.Execute (SQL)

    End if

	page_name="sendmaildownload.asp?"

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
        width: 160px;
      }
    </style>
<script>

</script>
 
  </head>
<body class="sb-nav-fixed">

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                <!--내용입력시작-->
                    <div class=" py-5 container text-center card card-body">
                            
                            <!--<div class="input-group mb-2">
                                <button type="button" class="btn btn-outline-success" Onclick="location.replace('sendmaildownloadtotaldb.asp?snidx=<%=snidx%>');">전체 다운로드</button>
                            </div>-->

                            <div class="input-group mb-2">
                                <span id="box" class="input-group-text">성적서 다운로드</span>
                                <div class="card form-control">
                                    <table id="datatablesSimple"  class="table table-hover">
                                        <%
                                        SQL=" Select A.ridx, A.rname, A.rfile, B.snsidx, A.nfile "
                                        SQL=SQL&" From tk_report A "
                                        SQL=SQL&" Join tk_reportsendsub B on B.ridx=A.ridx where B.snidx='"&snidx&"' "

                                        'response.write (SQL)
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do while not Rs.EOF
                                            ridx=Rs(0)
                                            rname=Rs(1)
                                            rfile=Rs(2)
                                            snsidx=Rs(3)
                                            nfile=Rs(4)
                                        %>
                                            <tr>
                                                <td><button type="button" class="btn btn-border-success "><%=rname%></button></td>
                                                <td><button type="button" class="btn btn-outline-success" Onclick="window.open('/report/rfile/<%=rfile%>');">성적서 파일 다운로드</button></td>
                                                <!-- <td><button type="button" class="btn btn-outline-success" Onclick="window.open('/report/rfile/<%=nfile%>');">납품확인서 파일 다운로드</button></td> -->
                                            </tr>
                                           
                                        <%
                                        Rs.movenext
                                        Loop
                                        End if
                                        Rs.close
                                        %>
                                                                                
                                        <%
                                        SQL="select A.snidx, C.rname, C.ron, C.rfile, C.nfile "
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
                                            nnfile=Rs(4)
                                        %>
                                            <tr>
                                                <td><button type="button" class="btn btn-border-success "><%=rrname%></button></td>
                                                <td><button type="button" class="btn btn-outline-success" Onclick="window.open('/report/rfile/<%=rrfile%>');">성적서 파일 다운로드</button></td>
                                                <!-- <td><button type="button" class="btn btn-outline-success" Onclick="window.open('/report/rfile/<%=nnfile%>');">납품확인서 파일 다운로드</button></td>    -->                                        
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
                                <span id="box" class="input-group-text">추가 파일 다운로드</span>
                                <div class="card form-control">
                                    <table id="datatablesSimple"  class="table table-hover">
                                        <%
                                        SQL=" Select efname from tk_emailatfile "
                                        SQL=SQL&" Where snidx='"&snidx&"' "

                                        'response.write (SQL)
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do while not Rs.EOF
                                            efname=Rs(0)
                                        %>
                                            <tr>
                                                <td><button type="button" class="btn btn-border-success "><%=efname%></button></td>
                                                <td><button type="button" class="btn btn-outline-success" Onclick="window.open('/report/rfile/<%=efname%>');">추가 파일 다운로드</button></td>
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
