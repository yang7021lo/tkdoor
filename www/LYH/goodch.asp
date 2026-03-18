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

<!--화면시작-->

    <div class="py-2 container text-center">
<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">번호</th>
                      <th align="center">코드</th>
                      <th align="center">축약어</th>
                      <th align="center">품목</th>
                      <th align="center">선택</th>
                  </tr>
              </thead>
              <tbody>
<%
    SQL=" Select goidx, gotype, gocode, gocword, goname, gopaint, gosecfloor ,gomidkey ,gounit,gostatus , gomidx, gowdate, goemidx"
    SQL=SQL&" From tk_goods "
    SQL=SQL&" Where gotype=1 "
    'RESPONSE.WRITE (SQL)
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do until Rs.EOF
    goidx=Rs(0)
    gotype=Rs(1)
    gocode=Rs(2)
    gocword=Rs(3)
    goname=Rs(4)
    gopaint=Rs(5)
    gosecfloor=Rs(6)
    gomidkey=Rs(7)
    gounit=Rs(8)
    gostatus=Rs(9)
    gomidx=Rs(10)
    gowdate=Rs(11)
    goemidx=Rs(12)
    i=i+1
%>                 
                  <tr>
                      <td><%=i%></td>
                      <td><%=gocode%></td>
                      <td><%=gocword%></td>
                      <td><%=goname%></td>
                      <td><button class="btn btn-primary"  type="button" onclick="opener.location.replace('sujuin.asp?goidx=<%=goidx%>&cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>');window.close();">선택</button></td>
                  </tr>
<%
    Rs.MoveNext
    Loop
    End If
    Rs.close
%>
              </tbody>
          </table>
        </div>
<!-- 표 형식 끝--> 

 
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
