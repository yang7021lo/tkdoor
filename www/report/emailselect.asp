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
            <h3>수신 이메일 선택</h3>
        </div>
<!-- 제목 나오는 부분 끝-->
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-danger" Onclick="window.close();">창닫기</button>      
        </div>
<!-- input 형식 시작--> 
            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="emailselectdb.asp" name="form2">
            <input type="hidden" name="snidx" value="<%=snidx%>">
            <input type="hidden" name="SearchWord" value="<%=SearchWord%>">
                <div class="input-group mb-2">
                    <span class="input-group-text">직접 입력</span>
                    <input type="text" class="card form-control" name="memail" value="" >
                    <button type="button" class="btn btn-outline-danger" Onclick="submit();">추가</button>
                </div>        
            </form>
            
            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="emailselect.asp?snidx=<%=snidx%>" name="form1">
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
        <h6>선택된 수신 이메일 주소</h6>
            <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th align="center">거래처명</th>
                        <th align="center">직원명</th>
                        <th align="center">이메일 주소</th>
                        <th align="center" width="100px">선택</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    SQL="SELECT A.cidx, A.memail, A.esidx, B.cname, A.mname from tk_emailselect A "
                    SQL=SQL&" Left Outer Join tk_customer B On B.cidx=A.cidx "
                    SQL=SQL&" Left Outer Join tk_member C On C.midx=A.midx "                    
                    SQL=SQL&" Where A.snidx='"&snidx&"' "

                    if SearchWord<>"" then
                        SQL=SQL&" and C.mname like '%"&SearchWord&"%'  "
                    end if

                    'response.write (SQL)
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF

                        cidx=Rs(0)
                        memail=Rs(1)
                        esidx=Rs(2)
                        cname=Rs(3)
                        mname=Rs(4)

                    %>
                     <tr>
                        <td><%=cname%></td>
                        <td><%=mname%></td>
                        <td><%=memail%></td>
                        <td><button type="button" class="btn btn-outline-danger" Onclick="location.replace('emailselectdeldb.asp?SearchWord=<%=SearchWord%>&snidx=<%=snidx%>&esidx=<%=esidx%>');">삭제</button></td>
                    </tr>
                    <%
                    Rs.movenext
                    Loop
                    End if
                    Rs.close
                    %>
                </tbody>  
            </table> 
            
            <h6>수신 이메일 주소</h6>
            <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th align="center">거래처명</th>
                        <th align="center">직원명</th>
                        <th align="center">이메일 주소</th>
                        <th align="center" width="100px">선택</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    SQL="SELECT A.cname, B.cemail1, A.cidx from tk_reportsendcorpSub A " 
                    SQL=SQL&" Join tk_customer B On B.cidx=A.cidx "
                    SQL=SQL&" Where A.snidx='"&snidx&"' and B.cemail1 not in (Select C.memail from tk_emailselect C where C.snidx='"&snidx&"') and B.cemail1 is not NULL and B.cemail1 <> ''"

                    if SearchWord<>"" then
                        SQL=SQL&" and A.cname like '%"&SearchWord&"%' "
                    end if

                    'response.write (SQL)
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF

                        mcname=Rs(0)
                        cemail=Rs(1)
                        mcidx=Rs(2)

                        mmname="대표 이메일"
                    %>
                     <tr>
                        <td><%=mcname%></td>
                        <td><%=mmname%></td>
                        <td><%=cemail%></td>
                        <td><button type="button" class="btn btn-outline-success" Onclick="location.replace('emailselectdb.asp?SearchWord=<%=SearchWord%>&snidx=<%=snidx%>&cidx=<%=mcidx%>&memail=<%=cemail%>&mname=<%=mmname%>');">추가</button></td>
                    </tr>
                    <%
                    Rs.movenext
                    Loop
                    End if
                    Rs.close
                    %>

                    <%
                    SQL="SELECT A.cname, B.memail, B.midx, B.mname, B.cidx from tk_reportsendcorpSub A " 
                    SQL=SQL&" Join tk_member B On B.cidx=A.cidx "
                    SQL=SQL&" Where A.snidx='"&snidx&"' and B.midx not in (Select C.midx from tk_emailselect C where C.snidx='"&snidx&"') and B.memail is not NULL and B.memail <> '' "

                    if SearchWord<>"" then
                        SQL=SQL&" and (A.cname like '%"&SearchWord&"%' or B.mname like '%"&SearchWord&"%') "
                    end if

                    'response.write (SQL)
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF

                        cname=Rs(0)
                        memail=Rs(1)
                        midx=Rs(2)
                        mname=Rs(3)
                        cidx=Rs(4)

                    %>
                     <tr>
                        <td><%=cname%></td>
                        <td><%=mname%></td>
                        <td><%=memail%></td>
                        <td><button type="button" class="btn btn-outline-success" Onclick="location.replace('emailselectdb.asp?SearchWord=<%=SearchWord%>&snidx=<%=snidx%>&cidx=<%=cidx%>&memail=<%=memail%>&midx=<%=midx%>&mname=<%=mname%>');">추가</button></td>
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
