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

                        <table class="table table-bordered align-middle" style="width:100%">
                            <tr>
                                <td rowspan="2" style="width:8%">수주번호:</td>
                                <td rowspan="2" style="width:10%">2025-07-08</td>
                                <td style="width:8%">거래처:</td>
                                <td style="width:22%">케빈쌤랩</td>
                                <td style="width:8%">전화:</td>
                                <td style="width:22%">010-5064-9398</td>
                                <td style="width:8%">팩스:</td>
                                <td style="width:22%"></td>
                            </tr>

                            <tr>
                                <td>담당자:</td>
                                <td>이진호</td>
                                <td>휴대폰:</td>
                                <td>010-5064-9398</td>
                                <td>이메일:</td>
                                <td></td>
                            </tr>

                            <tr>
                                <td>전체가로:</td>
                                <td>5000</td>
                                <td>위치1:</td>
                                <td></td>
                                <td>추가사항1:</td>
                                <td colspan="4"></td>
                            </tr>

                            <tr>
                                <td>전체세로:</td>
                                <td>2000</td>
                                <td>위치2:</td>
                                <td></td>
                                <td>추가사항2:</td>
                                <td colspan="4"></td>                            
                            </tr>

                            <tr>
                                <td>비고1</td>
                                <td colspan="3"></td>
                                <td>비고2</td>
                                <td></td>
                                <td>비고3</td>  
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