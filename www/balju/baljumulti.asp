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
    projectname="???"
%>
<%
    function encodestr(str)
        if str = "" then exit function
        str = replace(str,chr(34),"&#34")
        str = replace(str,"'","''")
        encodestr = str
    end Function

    page_name="baljumulti.asp?"

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
    .colcolor{
        background-color: gray;
    }
</style>

<iframe id="printFrame" style="display:none;"></iframe>

<script>
function printOtherPage() {
  const frame = document.getElementById('printFrame');
  frame.src = 'baljumultiprint.asp';
  
  frame.onload = function() {
    frame.contentWindow.focus();
    frame.contentWindow.print();
  };
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
                <!--내용입력시작-->
                    <div class=" py-5 container text-center">
                        <div class="mb-3 d-flex flex-row-reverse">
                            <button type="button" class="btn btn-primary" Onclick="printOtherPage()">프린트</button>
                        </div>

                        <table class="table table-bordered align-middle">
                            <tr>
                                <td rowspan="2" style="width:16%;background-color:f5f5f5;">20250812</td>
                                <td rowspan="2" style="width:17%">경산하나</td>
                                <td rowspan="2" style="width:17%;background-color:f5f5f5;">헤어라인1.2</td>
                                <td rowspan="2" style="width:16%">100*45</td>
                                <td style="width:17%;background-color:f5f5f5;">목 용차(경산하나로)</td>
                                <td style="width:17%">금요일 시공</td>
                            </tr>       
                        </table>
<style>
  .square {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap; 
  }
  .numbsize{
    font-size: 16px;
  }

@media (max-width: 650px) {
  .numbsize{
    font-size: 8px;
  }
}
</style>
                <div class="square justify-content-center" style="width:100%;">

                    <%
                    '임의의 DB 루프임
                    SQL=" Select A.snidx, A.sndate, C.mname, A.sncidx, A.snreadstatus"
                    SQL=SQL&" from tk_reportsend A "
                    SQL=SQL&" Join tk_reportsendcorpSub B On B.snidx=A.snidx "
                    SQL=SQL&" Left Outer Join tk_member C On A.snmidx=C.midx "
                    SQL=SQL&" Where A.sndate Is Not NULL "
                    SQL=SQL&"and snsendstatus='1'"

                    if Request("SearchWord")<>"" then
                        SQL=SQL&" and (B.cname like '%"&request("SearchWord")&"%' or C.mname like '%"&request("SearchWord")&"%' or A.mtitle like '%"&request("SearchWord")&"%' or A.filename like '%"&request("SearchWord")&"%' or A.report like '%"&request("SearchWord")&"%' or A.reportg like '%"&request("SearchWord")&"%' ) "  
                    end if

                    SQL=SQL&" Order by A.sndate DESC "

                    'Response.write (SQL)

                    Rs.open Sql,Dbcon,1,1,1
                    Rs.PageSize = 12                     

                    if not (Rs.EOF or Rs.BOF ) then

                    no = Rs.recordcount - (Rs.pagesize * (gotopage-1))+1
                    i=1

                    for j=i to Rs.RecordCount
                    if i>Rs.PageSize then exit for end if
                    if no=j-0 then exit for end if

                    snidx=Rs(0)
                    sndate=Rs(1)
                    mname=Rs(2)
                    sncidx=Rs(3)
                    snreadstatus=Rs(4)
                    %>

                        <div class="m-3 row border p-3 bg-white box-area" style="width:45%">        
                                <div class="d-flex justify-content-start" style="color:black;width:40%">
                                    <div style="width:100%;">도면</div>
                                </div>
                                <div class="d-flex justify-content-start" style="color:black;width:60%">
                                    <div class="text-start" style="word-break:break-all;">
                                        <div style="width:100%;"><%=i%>번<br><br></div>
                                        <div style="width:100%;">품목정보<br><br></div>
                                        <div style="width:100%;">도어유리<br>도어유리수량<br><br></div>
                                        <div style="width:100%;">픽스유리<br>픽스유리수량<br><br></div>
                                    </div>                                 
                                </div>
                        </div>

                    <%
                    i=i+1
                    Rs.MoveNext
                    Next
                    End If
                    %>

                </div>

                    </div>
                    <!--입력종료-->
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

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()

%>