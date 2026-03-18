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
    projectname="성적서 메일 전송"
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
 

	page_name="sendemailre.asp?"

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
    </style>
<script>
    function validateForm(){
        if(document.frmMain.amemail.value == "" ){
            alert("수신 메일 주소를 먼저 등록해주십시오")
        return
        }
        if(document.frmMain.sendadd.value == "" ){
            alert("발신 메일 주소를 먼저 등록해주십시오")
        return
        }
        if(document.frmMain.mtitle.value == "" ){
            alert("제목을 입력해 주십시오")
        return
        } 
        if(document.frmMain.mmaintext.value == "" ){
            alert("메일 내용을 입력해 주십시오")
        return
        }                
        else {
            document.frmMain.submit();
        }
    }

    function smwindow(str){
        newwin=window.open(str,'_blank', 'scrollbars=yes,menubar=no,statusbar=no,status=no,width=600,height=1000,top=70,left=50');
        newwin.focus();
    }

    function smwindow2(str){
        newwin=window.open(str,'_blank', 'scrollbars=yes,menubar=no,statusbar=no,status=no,width=600,height=1000,top=70,left=50');
        newwin.focus();
    }
    
    function smwindow3(str){
        newwin=window.open(str,'win1', 'scrollbars=yes,menubar=no,statusbar=no,status=no,width=800,height=800,top=200,left=200');
        newwin.focus();
    }    
</script>
 
  </head>
<body class="sb-nav-fixed">

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                <!--내용입력시작-->
                    <div class=" py-5 container text-center card card-body">

                        <form name="frmMain" action="sendemaildb.asp" method="post">
                            <input type="hidden" name="snidx" value="<%=snidx%>">
                            <input type="hidden" name="cidx" value="<%=cidx%>">
                            <input type="hidden" name="midx" value="<%=midx%>">
                            <input type="hidden" name="popup" value="1">

                            <div class="input-group mb-3">
                                <h6>메일 발송</h6>
                                <%'response.write snidx%>
                            </div>

                            <div class="input-group mb-2">
                                <button type="button" class="btn btn-outline-secondary" onclick="smwindow3('mailtemplist.asp?re=1');">임시저장 불러오기</button>
                            </div>
                            
                            <div class="input-group mb-2">
                                <span class="input-group-text">거래처</span>
                                <div class="card form-control">
                                    <table id="datatablesSimple" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th align="center">거래처명</th>
                                                <th align="center" width="100px">삭제</th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                            <%
                                            SQL=" Select A.cname, B.cidx, B.snsidx "
                                            SQL=SQL&" From tk_customer A "
                                            SQL=SQL&" Join tk_reportsendcorpSub B on B.cidx=A.cidx where B.snidx='"&snidx&"' "

                                            'response.write (SQL)
                                            Rs.open Sql,Dbcon
                                            If Not (Rs.bof or Rs.eof) Then 

                                            Do while not Rs.EOF
                                                cname=Rs(0)
                                                cidx=Rs(1)
                                                snsidx=Rs(2)
                                            %>
                                                            <tr>
                                                                <td><%=cname%></td>
                                                                <td><button type="button" class="btn btn-outline-danger" Onclick="location.replace('rsendcorpselectdeldb.asp?snsidx=<%=snsidx%>&snidx=<%=snidx%>&cidx=<%=cdix%>&udt=1');">삭제</button></td>
                                                            </tr>
                                            <%
                                            Rs.movenext
                                            Loop
                                            End if
                                            Rs.close
                                            %>
                                        </tbody>  
                                    </table> 
                                    <div class="container item-left">
                                        <button type="button" class="btn btn-outline-success" onclick="smwindow2('rsendcorpselect.asp?snidx=<%=snidx%>&udt=1');">+&nbsp;거래처 추가</button>
                                    </div>                                    
                                    </div>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">수신 메일 주소</span>
                                    <div class="form-control text-start " style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start " style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT cidx, memail from tk_emailselect Where snidx='"&snidx&"'"
                                            
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
                                    <button type="button" class="btn btn-outline-primary" Onclick="smwindow('emailselectre.asp?snidx=<%=snidx%>');">추가</button>    
                                    <input type="hidden" name="amemail" value="<%=amemail%>">
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">발송 메일 주소</span>
                                <input type="text" class="card form-control" name="sendadd" value="tkdoor0516@gmail.com" >
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">메일 제목</span>
                                <input type="text" class="card form-control" name="mtitle" value="성적서 파일 다운로드 링크">
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">첨부된 성적서</span>
                                <div class="card form-control">
                                    <table id="datatablesSimple" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th align="center">시료명</th>
                                                <th align="center" width="100px">삭제</th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                                <% 
                                                SQL="Select A.ridx, A.ron, A.rname, A.rfile, B.snsidx "
                                                SQL=SQL&" From tk_report A"
                                                SQL=SQL&" Join tk_reportsendsub B on B.ridx=A.ridx where B.snidx='"&snidx&"'"

                                                'response.write (SQL)
                                                Rs.open Sql,Dbcon
                                                If Not (Rs.bof or Rs.eof) Then 
                                                Do while not Rs.EOF
                                                    ridx=Rs(0)
                                                    ron=Rs(1)
                                                    rname=Rs(2)
                                                    rfile=Rs(3)
                                                    snsidx=Rs(4)
                                                %>

                                                <tr>
                                                    <td><%=rname%><br>(<%=ron%>)</td>
                                                    <td><button type="button" class="btn btn-outline-danger" onclick="location.replace('rsendselectdeldb.asp?snsidx=<%=snsidx%>&ridx=<%=ridx%>&snidx=<%=snidx%>&cidx=<%=cidx%>&udt=1');">삭제</button></td>
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
                                                        <td><%=rrname%><br>(<%=rron%>)</td>
                                                        <td>그룹을 삭제하여주십시오</td>
                                                    </tr>
                                                <%
                                                Rs.movenext
                                                Loop
                                                End if
                                                Rs.close
                                                %>

                                        </tbody>  
                                    </table> 
                                    <div class="container item-left">
                                        <button type="button" class="btn btn-outline-success" onclick="smwindow2('rsendselect.asp?snidx=<%=snidx%>&udt=1');">+&nbsp;성적서 추가</button>
                                    </div>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">첨부된 성적서 그룹</span>
                                <div class="card form-control">
                                    <table id="datatablesSimple" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th align="center">그룹명</th>
                                                <th align="center">파일명</th>
                                                <th align="center" width="100px">삭제</th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                            <%
                                            SQL=" Select A.rgidx, A.rgname, A.rgfile, B.snsidx "
                                            SQL=SQL&" From tk_reportg A "
                                            SQL=SQL&" Join tk_reportsendgsub B on B.rgidx=A.rgidx where B.snidx='"&snidx&"' "

                                            'response.write (SQL)
                                            Rs.open Sql,Dbcon
                                            If Not (Rs.bof or Rs.eof) Then 
                                            Do while not Rs.EOF
                                                rgidx=Rs(0)
                                                rgname=Rs(1)
                                                rgfile=Rs(2)
                                                snsidx=Rs(3)
                                            %>
                                                <tr>
                                                    <td><%=rgname%></td>
                                                    <td><%=rgfile%></td>
                                                    <td><button type="button" class="btn btn-outline-danger" Onclick="location.replace('rsendgselectdeldb.asp?snsidx=<%=snsidx%>&rgidx=<%=rgidx%>&snidx=<%=snidx%>&udt=1');">삭제</button></td>
                                                </tr>
                                            <%
                                            Rs.movenext
                                            Loop
                                            End if
                                            Rs.close
                                            %>
                                        </tbody>  
                                    </table> 
                                    <div class="container item-left">
                                        <button type="button" class="btn btn-outline-success" onclick="smwindow2('rsendgselect.asp?snidx=<%=snidx%>&udt=1');">+&nbsp;그룹 추가</button>
                                    </div>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">메일 내용</span>
                                <textarea id="mmaintext" class="card form-control" name="mmaintext">요청하신 서류 보내드립니다. 첨부된 링크를 접속하시면 성적서를 다운로드 할 수 있습니다.

발신전용메일입니다.

www.tkdoor.kr</textarea>
                            </div>
                        </form>

                            <div class="input-group mb-2">
                                <span class="input-group-text">첨부된 파일</span>
                                <div class="card form-control">
                                    <table id="datatablesSimple" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th align="center">추가 파일명</th>
                                                <th align="center" width="100px">삭제</th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                            <%
                                            SQL=" Select efidx, snidx, efname from tk_emailatfile Where snidx='"&snidx&"' "

                                            'response.write (SQL)
                                            Rs.open Sql,Dbcon
                                            If Not (Rs.bof or Rs.eof) Then 

                                            Do while not Rs.EOF
                                                efidx=Rs(0)
                                                ksnidx=Rs(1)
                                                efname=Rs(2)
                                            %>
                                                <tr>
                                                    <td><%=efname%></td>
                                                    <td><button type="button" class="btn btn-outline-danger" Onclick="location.replace('emailatfiledeldb.asp?efidx=<%=efidx%>&snidx=<%=ksnidx%>&udt=1');">삭제</button></td>
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

                            <div class="input-group mb-2">
                                <div class="card form-control border-0">
                                    <form name="shr2" action="emailatfiledb.asp" method="post" ENCTYPE="multipart/form-data">
                                        <div class="input-group mb-2">
                                            <input type="hidden" name="snidx" value="<%=snidx%>">
                                            <input type="hidden" name="udt" value="1">
                                            <input type="file" class="form-control" name="file3">
                                            <button type="button" class="btn btn-outline-primary" Onclick="submit();">추가 파일 첨부</button>
                                        </div>
                                        <div class="text-left">
                                            <span>추가적인 파일을 업로드해주세요.</span> 
                                        </div>
                                    </form> 
                                </div>
                            </div>  

                            <div class="card form-control border-0">
                                <div class="d-flex">
                                    <div class="input-group mb-3">
                                        <button type="button" class="btn btn-outline-primary" Onclick="validateForm();">메일 보내기</button>
                                    <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('rsenddeldb.asp?snidx=<%=snidx%>&udt=1');">저장하지 않고 나가기</button>      
                                    </div>
                                    <div class="input-group mb-3 float-right justify-content-end">
                                        <button type="button" class="btn btn-outline-danger" Onclick="location.replace('sendmailtempsave.asp?snidx=<%=snidx%>&udt=1');">임시저장</button>
                                    </div>           
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

