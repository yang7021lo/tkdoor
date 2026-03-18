

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

rcname=Request("cname")

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
    <script>
        document.getElementById("dataForm").addEventListener("keypress", function (event) {
            if (event.key === "Enter") { // Enter 키를 감지
                event.preventDefault(); // 기본 Enter 동작 방지
                document.getElementById("hiddenSubmit").click(); // 폼 제출
            }
        });
    </script>
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작-->
        <div class="input-group mb-3">
            <h3>거래처 검색</h3>
        </div>
<!-- 제목 나오는 부분 끝-->
<form id="dataForm" action="TNG1_B_choicecorp.asp" method="POST">   
<!-- input 형식 시작--> 
        <div class="input-group mb-3">
            <span class="input-group-text">거래처&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="cname" value="<%=rcname%>">
        </div>
<!-- input 형식 끝--> 
<button type="submit" id="hiddenSubmit" style="display: none;"></button>
</form>
<!-- 거래처 리스트 시작-->
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">번호</th>
                      <th align="center">거래처명</th>
                      <th align="center">대표자</th>
                      <th align="center">사업자번호</th>
                      <th align="center">담당자</th>
                      <th align="center">관리</th>  
                  </tr>
              </thead>
              <tbody>
<%
SQL=" Select A.cidx, A.cstatus, A.cname, A.cceo,  A.ctkidx, A.caddr1, A.cmemo,  A.cwdate, A.ctel, A.cfax, A.cnumber,B.mname, B.midx "
SQL=SQL&" From tk_customer A "
SQL=SQL&" left outer Join tk_member B On A.cidx=B.cidx "
SQL=SQL&" Where A.cname like '%"&Request("cname")&"%' or A.cnumber like '%"&Request("cname")&"%' or A.cceo like '%"&Request("cname")&"%' "
SQl=SQL&" or  A.cmemo like '%"&Request("cname")&"%' or  A.caddr1 like '%"&Request("cname")&"%' "
SQL=SQL&"  Order by A.cname asc "
'Response.write (SQL)
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF

  cidx=Rs(0)
  cstatus=Rs(1)
    select case cstatus
      case "0"
        cstatus_text="미사용"
      case "1"
        cstatus_text="사용"
    end select
  cname=Rs(2)
  cceo=Rs(3)
  ctkidx=Rs(4)
    If ctkidx="1" then 
      ctkidx_text="태광도어"
    Elseif ctkidx="2" then 
      ctkidx_text="티엔지단열프레임"
    Elseif ctkidx="3" then
      ctkidx_text="태광인텍"
    End If 

  caddr1=Rs(5)
  cmemo=Rs(6)
  cwdate=Rs(7)
  ctel=Rs(8)
  cfax=Rs(9)
  cnumber=Rs(10)
  cnumtext=Left(cnumber,3)&"-"&Mid(cnumber,4,2)&"-"&Right(cnumber,5)
  mname=Rs(11)
  midx=Rs(12)

  if cmemo<>"" then cmemo=replace(cmemo, chr(13)&chr(10),"<br>")

  if rcname<>"" then
  i=i+1
%>             
                  <tr>
                      <td><%=i%></td>
                      <td><%=cname%></td>
                      <td><%=cceo%></td>
                      <td><%=cnumber%></td>
                      <td><%=mname%></td>
                      <td><button type="button" class="btn btn-primary" onClick="opener.location.replace('TNG1_B.asp?sjcidx=<%=cidx%>&sjmidx=<%=midx%>');window.close();">선택</button></td>
                  </tr>
<%
  end if
  cstatus_text=""
  ctkidx_text=""
  cgubun_text=""
  cmove_text=""

Rs.movenext
Loop
End if
Rs.close
%>
              </tbody>
          </table>
        </div>
<!-- 거래처 리스트 끝-->
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
