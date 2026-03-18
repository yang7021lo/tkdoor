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

rmidx=Request("rmidx")
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
    <style>
        /* 스타일 정의 */
        .input-field {
            width: 100%; /* 너비를 100%로 설정 */
            //padding: 10px; /* 안쪽 여백 */
            //margin-bottom: 15px; /* 아래 여백 */
            border: none; /* 테두리 제거 */
            //border-bottom: 2px solid #ccc; /* 하단 경계선만 추가 */
            //font-size: 16px; /* 글꼴 크기 */
            outline: none; /* 포커스 시 아웃라인 제거 */
        }

        .input-field:focus {
         //   border-bottom: 2px solid #007bff; /* 포커스 시 하단 경계선 강조 */
        }
    </style>
    <script>
        document.getElementById("dataForm").addEventListener("keypress", function (event) {
            if (event.key === "Enter") { // Enter 키를 감지
                event.preventDefault(); // 기본 Enter 동작 방지
                document.getElementById("hiddenSubmit").click(); // 폼 제출
            }
        });
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="test0123db.asp?part=delete&midx="+sTR;
            }
        }
    </script>
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작-->
        <div class="row mb-3">
            <div class="col text-start">
                <h3>화면제목</h3>
            </div>
            <div class="col text-end">
                <button type="button" class="btn btn-outline-danger" Onclick="location.replace('test0123.asp?rmidx=0');">등록</button>
            </div>
        </div>
<!-- 제목 나오는 부분 끝-->

<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">번호</th>
                      <th align="center">이름</th>
                      <th align="center">전화번호</th>
                      <th align="center">휴대폰</th>
                      <th align="center">팩스</th>
                      <th align="center">이메일</th> 
                      <th align="center">등록일</th>  
                  </tr>
              </thead>
              <tbody>
<form id="dataForm" action="test0123db.asp" method="POST">   
<input type="hidden" name="midx" value="<%=rmidx%>">
<% if rmidx="0" then %>
                  <tr>
                      <td></td>
                      <td><input class="input-field" type="text" size="3" placeholder="이름" aria-label="이름" name="mname" id="mname" value="<%=mname%>" onkeypress="handleKeyPress(event, 'mname', 'mname')"/></td>
                      <td><input class="input-field" type="text" size="16" placeholder="전화번호" aria-label="전화번호" name="mtel" id="mtel" value="<%=mtel%>"  onkeypress="handleKeyPress(event, 'mtel', 'mtel')"/></td>
                      <td><input class="input-field" type="text" placeholder="휴대폰" aria-label="휴대폰" name="mhp" id="mhp" value="<%=mhp%>"  onkeypress="handleKeyPress(event, 'mhp', 'mhp')"/></td>
                      <td><input class="input-field" type="text" placeholder="팩스" aria-label="팩스" name="mfax" id="mfax" value="<%=mfax%>"  onkeypress="handleKeyPress(event, 'mfax', 'mfax')"/></td>
                      <td><input class="input-field" type="text" placeholder="이메일" aria-label="이메일" name="memail" id="memail" value="<%=memail%>"  onkeypress="handleKeyPress(event, 'memail', 'memail')"/></td>
                      <td><%=mwdate%></td>
                  </tr>
<% end if %>
<%
SQL="select midx, mname, mpos, mtel, mhp, mfax, memail, Convert(varchar(10),mwdate,121) "
SQL=SQL&" from tk_member "
SQL=SQL&" order by midx desc "
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
    midx=Rs(0)
    mname=Rs(1)
    mpos=Rs(2)
    mtel=Rs(3)
    mhp=Rs(4)
    mfax=Rs(5)
    memail=Rs(6)
    mwdate=Rs(7)
    i=i+1
%>              
<% if int(midx)=int(rmidx) then %>
                  <tr>
                      <td align="center"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=midx%>');"><%=i%></button></td>
                      <td><input class="input-field" type="text" size="3" placeholder="이름" aria-label="이름" name="mname" id="mname" value="<%=mname%>" onkeypress="handleKeyPress(event, 'mname', 'mname')"/></td>
                      <td><input class="input-field" type="text" size="16" placeholder="전화번홓" aria-label="전화번홓" name="mtel" id="mtel" value="<%=mtel%>"  onkeypress="handleKeyPress(event, 'mtel', 'mtel')"/></td>
                      <td><input class="input-field" type="text" placeholder="휴대폰" aria-label="휴대폰" name="mhp" id="mhp" value="<%=mhp%>"  onkeypress="handleKeyPress(event, 'mhp', 'mhp')"/></td>
                      <td><input class="input-field" type="text" placeholder="팩스" aria-label="팩스" name="mfax" id="mfax" value="<%=mfax%>"  onkeypress="handleKeyPress(event, 'mfax', 'mfax')"/></td>
                      <td><input class="input-field" type="text" placeholder="이메일" aria-label="이메일" name="memail" id="memail" value="<%=memail%>"  onkeypress="handleKeyPress(event, 'memail', 'memail')"/></td>
                      <td><%=mwdate%></td>
                  </tr>

<% else %>
                  <tr>
                      <td align="center"><%=i%></td>
                      <td><input class="input-field" type="text" size="8" value="<%=mname%>" onclick="location.replace('test0123.asp?rmidx=<%=midx%>');"/></td>
                      <td><input class="input-field" type="text" value="<%=mtel%>" onclick="location.replace('test0123.asp?rmidx=<%=midx%>');"/></td>
                      <td><input class="input-field" type="text" value="<%=mhp%>" onclick="location.replace('test0123.asp?rmidx=<%=midx%>');"/></td>
                      <td><input class="input-field" type="text" value="<%=mfax%>" onclick="location.replace('test0123.asp?rmidx=<%=midx%>');"/></td>
                      <td><input class="input-field" type="text" value="<%=memail%>" onclick="location.replace('test0123.asp?rmidx=<%=midx%>');"/></td>
                      <td><input class="input-field" type="text" value="<%=mwdate%>" onclick="location.replace('test0123.asp?rmidx=<%=midx%>');"/></td>
                  </tr>
<% end if %>
<%
Rs.movenext
Loop
End If 
Rs.Close 
%>
<button type="submit" id="hiddenSubmit" style="display: none;"></button>
</form>
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
