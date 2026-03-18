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

rgidx=Request("rgidx")

SQL=" Select A.rgname, A.rgtype, A.gstatus From tk_reportg A where rgidx='"&rgidx&"' "
Rs.open SQL,Dbcon
if not (Rs.EOF or Rs.BOF) then
  rgname=Rs(0)
  rgtype=Rs(1)
  gstatus=Rs(2)
End if
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
            <h3>성적서 그룹관리</h3>
        </div>
<!-- 제목 나오는 부분 끝-->
<form name="shr" action="rggudtdb.asp" method="post" ENCTYPE="multipart/form-data">
<input type="hidden" name="rgidx" value="<%=rgidx%>">
<!-- input 형식 시작--> 
        <div class="input-group mb-3">
            <span class="input-group-text">대분류&nbsp;&nbsp;&nbsp;</span>
            <select name="rgtype" class="form-control">
                <option value="1" <% If rgtype="1" Then Response.write "selected" End if %>>단열세이프</option>
                <option value="2" <% If rgtype="2" Then Response.write "selected" End if %>>단열자동프레임</option>
                <option value="3" <% If rgtype="3" Then Response.write "selected" End if %>>단열수동프레임</option>
                <option value="4" <% If rgtype="4" Then Response.write "selected" End if %>>시스템도어</option>
                <option value="5" <% If rgtype="5" Then Response.write "selected" End if %>>기타</option>
              </select>
        </div>
        <div class="input-group mb-3">
            <span class="input-group-text">그룹명&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="rgname" value="<%=rgname%>">
        </div>

        <div class="input-group text-left">
            <h6>그룹 압축파일 등록</h6>
        </div>

        <div class="input-group mb-3">
            <input type="file" class="form-control" name="file1" value="">
        </div>

        <div class="input-group mb-2">
            <span class="input-group-text">상태</span>
            <div class="form-control text-start" style="width:80%;padding:5 5 5 5;">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="gstatus" value="0" <% if gstatus="0" then %>checked <% end if %>>
                    <label class="form-check-label" >사용안함</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="gstatus" value="1" <% if gstatus="1" then %>checked <% end if %>>
                    <label class="form-check-label" >사용함</label>
                </div>          
            </div>
        </div> 
<!-- input 형식 끝--> 

<!-- 버튼 형식 시작--> 
        <div class="d-flex">
            <div class="input-group mb-3">
                <button type="button" class="btn btn-outline-success" Onclick="shr1();">저장</button>      
            </div>
            <div class="input-group mb-3 float-right justify-content-end">
                <button type="button" class="btn btn-outline-danger" Onclick="window.close();">취소</button>
            </div>           
        </div>
<!-- 버튼 형식 끝--> 
</form>
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
