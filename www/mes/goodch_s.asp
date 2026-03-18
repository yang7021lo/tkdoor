<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
Set Rs = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")

rgoidx=Request("goidx")
rcidx=Request("cidx")
rsjaidx=Request("sjaidx") 
rsjbidx=Request("sjbidx") 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
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
    </style>
</head>
<body>
<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between">
            <!--화면시작-->
            <div class="row " >
                <div class="col-6 card">
                    <div class="mt-1"><h5>통도장</h5></div>
                    <iframe name="hide" width="400" height="300" src="goodch1.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>&goidx=<%=goidx%>" border="0"></iframe> 
                    <div class="mt-1"><h5>통도장 단열</h5></div>
                    <iframe name="hide" width="400" height="300" src="goodch2.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>&goidx=<%=goidx%>" border="0"></iframe> 
                </div>
                <div class="col-4 card">
                    <div class="mt-1"><h5>스텐</h5></div>
                    <iframe name="hide" width="400" height="300" src="goodch3.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>&goidx=<%=goidx%>" border="0"></iframe> 
                    <div class="mt-1"><h5>스텐 단열</h5></div>
                    <iframe name="hide" width="400" height="300" src="goodch4.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>&goidx=<%=goidx%>" border="0"></iframe> 
                </div>
                <div class="col-4 card">
                    <div class="mt-1"><h5>통도장 자동</h5></div>
                    <iframe name="hide" width="400" height="300" src="goodch5.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>&goidx=<%=goidx%>" border="0"></iframe> 
                    <div class="mt-1"><h5>스텐 자동</h5></div>
                    <iframe name="hide" width="400" height="300" src="goodch6.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>&goidx=<%=goidx%>" border="0"></iframe> 
                </div>
            </div>
        </div>
    </div>
</main>
</div>

    

    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>
