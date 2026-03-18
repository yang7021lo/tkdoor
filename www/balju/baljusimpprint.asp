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
    projectname="발주서 요약"
%>
<%
    function encodestr(str)
        if str = "" then exit function
        str = replace(str,chr(34),"&#34")
        str = replace(str,"'","''")
        encodestr = str
    end Function

    page_name="baljusimpprint.asp?"
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
    .a4container {
            width: 297mm;
            height: 210mm;
            padding: 20mm;
            box-sizing: border-box;
        }
</style>

<iframe id="printFrame" style="display:none;"></iframe>

<script>
function printOtherPage() {
  const frame = document.getElementById('printFrame');
  frame.src = 'baljusimpprint.asp';
  
  frame.onload = function() {
    frame.contentWindow.focus();
    frame.contentWindow.print();
  };
}
</script>
</head>
<body class="sb-nav-fixed">
    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                <!--내용입력시작-->
                    <div class=" py-5 container text-center">

                        <style>
                        .card-table {
                        border: 1px solid #dee2e6;
                        border-radius: 0.25rem;
                        overflow: hidden;
                        font-size: 11px;
                        }
                        .card-table-row {
                        display: flex;
                        border-bottom: 1px solid #dee2e6;
                        }
                        .card-table-row:last-child {
                        border-bottom: none;
                        }
                        .card-table-cell {
                        padding: 0.5rem;
                        border-right: 1px solid #dee2e6;
                        flex: 0 0 auto;
                        display: flex;
                        align-items: center; /* vertically center content */  
                        }
                        .card-table-cell:last-child {
                        border-right: none;
                        }
                        .invisible-cell {
                        border: none !important;
                        outline: none !important;
                        background: transparent !important;
                        padding: 0.5rem !important;  /* keep padding same as others */
                        margin: 0 !important;
                        color: transparent !important;
                        user-select: none; /* optional */
                        }
                        </style>

                        <div class="card card-table">
                        <!-- Row 1 -->
                        <div class="card-table-row">
                            <div class="card-table-cell" style="width:8%">도어가로:</div>
                            <div class="card-table-cell" style="width:17%"></div>
                            <div class="card-table-cell" style="width:8%">도어유리가로:</div>
                            <div class="card-table-cell" style="width:17%"></div>
                            <div class="card-table-cell" style="width:8%">검측가로:</div>
                            <div class="card-table-cell" style="width:17%"></div>
                            <div class="card-table-cell" style="width:8%">원가:</div>
                            <div class="card-table-cell" style="width:17%"></div>
                        </div>

                        <!-- Row 2 -->
                        <div class="card-table-row">
                            <div class="card-table-cell" style="width:8%">도어세로:</div>
                            <div class="card-table-cell" style="width:17%"></div>
                            <div class="card-table-cell" style="width:8%">도어유리세로:</div>
                            <div class="card-table-cell" style="width:17%"></div>
                            <div class="card-table-cell" style="width:8%">검측세로:</div>
                            <div class="card-table-cell" style="width:17%"></div>
                            <div class="card-table-cell" style="width:8%">부가세:</div>
                            <div class="card-table-cell" style="width:17%"></div>
                        </div>

                        <!-- Row 3 -->
                        <div class="card-table-row">
                            <div class="card-table-cell invisible-cell" style="width:8%"></div>
                            <div class="card-table-cell invisible-cell" style="width:17%"></div>
                            <div class="card-table-cell invisible-cell" style="width:8%"></div>
                            <div class="card-table-cell invisible-cell" style="width:17%"></div>
                            <div class="card-table-cell invisible-cell" style="width:8%"></div>
                            <div class="card-table-cell" style="width:17%"></div>
                            <div class="card-table-cell" style="width:8%">총액:</div>
                            <div class="card-table-cell" style="width:17%"></div>
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