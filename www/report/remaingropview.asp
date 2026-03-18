<!--
웹사이트개발시 사용되는 언어
html : 무대와 같은 존대 화면을 꾸미는 , 보여지는
asp :  DB와의 연동
css : html 꾸며주는 역할 / 색을 입히거나 글체 크기 등등  :데코레이션
js : html을 동적이게 만들어 준다.(움직임을 준다) :데이터의 이동,버튼 기능



bootstrap : 템플릿 사용으로 디자인적인 감각이 없어도 기본이상의 화면을 만들어 준다.
css : <head></head>영역에 삽입: <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
/ js : </body>바로 위에 삽입: <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

-->

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

rgidx=request("rgidx")
SearchWord=request("SearchWord")
'response.write keyWord&"<br>"
'response.write rgidx&"<br>"
SQL=" Select rgname from tk_reportg where rgidx='"&rgidx&"' "
Rs.open SQL,Dbcon
If not (Rs.BOF or Rs.EOF) then 
    rgname=Rs(0)
End  if
Rs.Close

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
        function shr1() {
            if(document.shr.rgname.value == "" ) {
                alert("그룹이름을 입력해주십시오.");
            return
            }        
            else {
                document.shr.submit();
            }
        }
    </script>
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작-->
            <div class="input-group mb-3">
                <h3>그룹 성적서 추가</h3>
            </div>
<!-- 제목 나오는 부분 끝-->

<!-- input 형식 시작--> 
            <div class="input-group mb-3">
                <button type="button" class="btn btn-outline-danger" Onclick="window.close();">창닫기</button>      
            </div>

            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="remaingropview.asp" name="form1">
                <input name="rgidx" type="hidden" value="<%=rgidx%>">
                <div class="row">
                    <div class="col-10">
                    <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해 주세요." name="SearchWord" value="<%=SearchWord%>">
                    </div>
                    <div class="col-2">
                        <button type="submit" class="btn btn-primary"  onclick="submit();">검색</button>
                    </div>
                </div>
            </form>

<!-- input 형식 끝--> 
            
<!-- 검색된 목록 나오기 시작 -->
            <div class="input-group mb-3">
                <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th align="center">시료명</th>
                        <th align="center" width="100px">선택</th>
                    </tr>
                </thead>
                <tbody>

                    <%
                    SQL="SELECT A.ridx, A.ron, A.rname from tk_report A " 
                    SQL=SQL&" where A.ridx not in (Select B.ridx From tk_reportgsub B where B.rgidx='"&rgidx&"') and A.rstatus=1"
                    if SearchWord<>"" then
                        SQL=SQL&" and A.rname like '%"&SearchWord&"%'  "
                    end if
                    'response.write (SQL)
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF
                        ridx=Rs(0)
                        ron=Rs(1)
                        rname=Rs(2)
                    %>

                    <tr>
                        <td><%=rname%>(<%=ron%>)</td>
                        <td><button type="button" class="btn btn-outline-danger" Onclick="location.replace('remaingropviewdb.asp?rgidx=<%=rgidx%>&ridx=<%=ridx%>&SearchWord=<%=SearchWord%>');">추가</button></td>
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
<!-- 버튼 형식 시작--> 
<!-- 버튼 형식 끝--> 
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
