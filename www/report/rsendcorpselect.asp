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
Set Rs = Server.CreateObject("ADODB.Recordset")

snidx=request("snidx")
SearchWord=request("SearchWord")
udt=request("udt")
'response.write keyWord&"<br>"
'response.write rgidx&"<br>"

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

    <script>


    </script>
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작-->
        <div class="input-group mb-3">
            <h3>거래처 선택</h3>
        </div>
<!-- 제목 나오는 부분 끝-->
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-danger" Onclick="window.close();">창닫기</button>      
        </div>
<!-- input 형식 시작--> 

            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="rsendcorpselect.asp?snidx=<%=snidx%>" name="form1">
                <div class="row">
                    <div class="col-10">
                    <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해 주세요." name="SearchWord" value="<%=SearchWord%>">
                    </div>
                    <div class="col-2">
                        <button type="submit" class="btn btn-primary" onclick="submit();">검색</button>
                    </div>
                </div>
            </form>

<!-- input 형식 끝--> 
            
<!-- 검색된 목록 나오기 시작 -->
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">거래처명</th>
                      <th align="center" width="100px">선택</th>
                  </tr>
              </thead>
              <tbody>
<%
SQL="SELECT A.cname, A.cidx from tk_customer A " 
SQL=SQL&" Where A.cidx not in (Select C.cidx From tk_reportsendcorpSub C where C.snidx='"&snidx&"') "

if SearchWord<>"" then
    SQL=SQL&" and A.cname like '%"&SearchWord&"%'  "
end if

'response.write (SQL)
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
    cname=Rs(0)
    cidx=Rs(1)
%>
                  <tr>
                    <td><%=cname%></td>
                    <td><button type="button" class="btn btn-outline-danger" Onclick="location.replace('rsendcorpselectdb.asp?SearchWord=<%=SearchWord%>&snidx=<%=snidx%>&cidx=<%=cidx%>&cname=<%=cname%>&udt=<%=udt%>');">추가</button></td>
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
<!-- 검색된 목록 나오기 끝-->
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
