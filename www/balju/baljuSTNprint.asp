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
    projectname="스테인리스 발주서"
%>
<%
    function encodestr(str)
        if str = "" then exit function
        str = replace(str,chr(34),"&#34")
        str = replace(str,"'","''")
        encodestr = str
    end Function

    page_name="baljuSTN.asp?"
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
<script>

</script>
</head>
<body class="sb-nav-fixed">
    <div id="layoutSidenav_content" style="width:210mm;height:297mm;">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                <!--내용입력시작-->
                    <div class=" py-5 container text-center">

                        <table class="table table-bordered align-middle" style="font-size:12px">
                            <tr>
                                <td style="width:8%">번호:</td>
                                <td style="width:16%">주문일:</td>
                                <td style="width:20%">거래처:</td>
                                <td style="width:16%">tel:<br>hp:</td>
                                <td style="width:21%">현장:</td>
                                <td style="width:16%">출고일:</td>
                            </tr>

                            <tr>
                                <td colspan='2'>총 절곡 수량 = 144</td>
                                <td colspan='2'>V컷팅 길이:</td>
                                <td>절곡:1017.60M</td>
                                <td>인쇄일:</td>
                            </tr>    
                        </table>

                        <table class="table table-bordered" style="font-size:12px">
                            <tr>
                                <td rowspan="2" style="width:3%">1</td>
                                <td rowspan="2" colspan="2" style="width:80%">도면</td>                                
                                <td style="width:17%">재질:</td>
                            </tr>

                            <tr>
                                <td style="width:20%">길이:600=16</td>
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