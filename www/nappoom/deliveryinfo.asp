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
    projectname="배송 정보"
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
    
    if request("gotopage")="" then
        gotopage=1
    else
        gotopage=request("gotopage")
    end if

    page_name="remain.asp?"
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
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG2.asp"-->

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                <!--내용입력시작-->
                    <div class=" py-5 container text-center">

                            <div class="input-group mb-2">
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h4>상차지</h4></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                                <div style="width:10%;height:100%;padding:5 5 5 5;"></div>
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h4>상차지</h4></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                            </div>

                            <div class="input-group mb-2">
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h1>하차지</h1></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                                <div style="width:10%;height:100%;padding:5 5 5 5;"></div>
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h1>하차지</h1></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                            </div> 

                            <div class="input-group mb-2">                                
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h2>주소</h2></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                                <div style="width:10%;height:100%;padding:5 5 5 5;"></div>
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h2>주소</h2></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                           </div>

                            <div class="input-group mb-2">                                
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h2>연락처</h2></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                                <div style="width:10%;height:100%;padding:5 5 5 5;"></div>
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h2>연락처</h2></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                            </div>

                            <div class="input-group mb-2">    
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h2>...</h2></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                                <div style="width:10%;height:100%;padding:5 5 5 5;"></div>
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h2>...</h2></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                            </div>

                            <div class="input-group mb-2">                                
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h2>...</h2></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                </div>
                                <div style="width:10%;height:100%;padding:5 5 5 5;"></div>
                                <div class="input-group mb-2" style="width:45%;height:100%;padding:5 5 5 5;">
                                    <span class="input-group-text"><h2>...</h2></span>
                                    <input type="text" class="form-control" name="ron" value="<%=ron%>">
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