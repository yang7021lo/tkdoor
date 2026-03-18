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
    projectname="알루미늄 발주서"
%>
<%
    function encodestr(str)
        if str = "" then exit function
        str = replace(str,chr(34),"&#34")
        str = replace(str,"'","''")
        encodestr = str
    end Function

    page_name="baljuAL.asp?"
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
  frame.src = 'baljuALprint.asp';
  
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
                                <td rowspan="2" style="width:10%;background-color:f5f5f5;">날짜:</td>
                                <td rowspan="2" style="width:23%"></td>
                                <td rowspan="2" style="width:12%;background-color:f5f5f5;">발주처:</td>
                                <td rowspan="2" style="width:21%">울산화성특수</td>
                                <td style="width:14%;background-color:f5f5f5;">도장일자:</td>
                                <td style="width:20%">datetime</td>
                            </tr>

                            <tr>
                                <td style="background-color:f5f5f5;">납기일:</td>
                                <td>datetime</td>
                            </tr>

                            <tr>
                                <td style="background-color:f5f5f5;">수량:</td>
                                <td>1틀</td>
                                <td style="background-color:f5f5f5;">검측:</td>
                                <td>3000x2600</td>
                                <td style="background-color:f5f5f5;">도어유리:</td>
                                <td>897x2240</td>
                            </tr>

                            <tr>
                                <td style="background-color:f5f5f5;">색상:</td>
                                <td>블랙</td>
                                <td style="background-color:f5f5f5;">도어제작:</td>
                                <td>997x2380</td>
                                <td style="background-color:f5f5f5;">픽스유리:</td>
                                <td>918x2265</td>                            
                            </tr>

                            <tr>
                                <td colspan="2" class="text-center" style="background-color:f5f5f5;">도어와 같이 제작</td>
                                <td style="background-color:f5f5f5;">바닥묻힘:</td>
                                <td></td>
                                <td style="background-color:f5f5f5;">도어 검측 높이:</td>
                                <td></td>                          
                            </tr>         

                        </table>
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