<!-- 

[aidx] 사용자 기본키
[acidx] 거래처
[acheorigubun] 상담처리구분(대기0,완료1,전달2)
[aform] 상담형태(견적1,배송2,,부자재관련3.결재4, 내역서5, 성적서6, 기타7)
[agubun]  상담구분(in 1, out2)
[aclaim] 클레임(유1,무2)
[aname] 입력자
[adate] 입력일
[adetails] 상담내용
[acheoriname] 처리자
[acheoridate] 처리일
[acheorimemo] 처리내용
    
-->

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

    If c_midx="" then 
    Response.write "<script>alert('로그인 하세요.');location.replace('/index.asp');</script>"
    End If
   

  projectname="상담일지"
  developername="오소리"

  cidx=Request("cidx")
   
   SQL="SELECT cname from tk_customer where cidx='"&cidx&"'"
   Rs.open SQL,Dbcon
   if not(rs.eof or rs.bof) then
        ocname=rs(0)
   end if
   Rs.close
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
    <link rel="icon" type="image/x-icon" href="/inc/tkico.png" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
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
        function validateform() {
            if(document.ad.adetails.value == "" ) {
                alert("상담내용을 입력해주세요.");
            return
            }
            else {
                document.ad.submit();
            }
            
           
        }
    </script>
 
  </head>
  <body class="sb-nav-fixed">
 
    
    
    <div id="layoutSidenav_content">            
    <main>
      <div class="container-fluid px-2 ">
       <div class="row justify-content-between py-1 ">

<!--화면시작-->

<div class="py-0 mt-3 mb-3 container text-start  card card-body">
    <form name="ad" action="advicedb.asp" method="post">
    <input name="acidx" type="hidden" value="<%=cidx%>" >
<div class="row mb-2 px-2 py-2">

 <table class="table table-bordered">
    <tbody>
        <tr>
            <th width="80px;" class="bg-light">거래처</th>
            <td><%=ocname%></td>
            <th width="80px;" class="bg-light">상담자</th>
            <td><%=c_mname%></td>
            <th width="90px;" class="bg-light">상담날짜</th>
            <td><%=date()%></td>
        </tr>
       <tr> 
            <th width="110px;" class="bg-light">상담구분</th>
            <td colspan="5">
                <input type="radio" name="agubun" value="0" checked>
                <label class="form-check-label" > 고객->회사</label>
                <input type="radio" name="agubun" value="1" >
                <label class="form-check-label" > 회사->고객</label>
            </td>
        </tr>
        <tr>
            <th width="90px;" class="bg-light">상담형태</th>
            <td colspan="5">
                <input type="radio" name="aform" value="1">
                <label class="form-check-label" >견적</label>
                <input type="radio" name="aform" value="2">
                <label class="form-check-label" >부자재</label>
                <input type="radio" name="aform" value="3">
                <label class="form-check-label" >배송</label>
                <input type="radio" name="aform" value="4">
                <label class="form-check-label" >결재</label>
                <input type="radio" name="aform" value="5">
                <label class="form-check-label" >내역서</label>
                <input type="radio" name="aform" value="6">
                <label class="form-check-label" >성적서</label>
                <input type="radio" name="aform" value="7" checked>
                <label class="form-check-label" >기타</label>
            </td>
        </tr>
        <tr>
            <th width="80px;" class="bg-light">상담내용</th>
            <td colspan="5">
            <textarea name="adetails" class="form-control" rows="6"></textarea>
            </td>
        </tr>
        <tr> 
            <th width="110px;" class="bg-light">처리자</th>
            <td>
              
                    <select class="form-select" id="acheoriname" name="acheoriname">
                       
<%
SQL="select midx, mname from tk_member where cidx='1' or cidx='2' or cidx='3'"
Rs.open sql,dbcon    
if not (Rs.bof or rs.eof) then   

do until rs.eof
    midx=rs(0)
    mname=rs(1)
%> 
                       <option value="<%=midx%>" <% if cint(midx)=cint(c_midx) then %>selected<% end if %>><%=mname%></option>                        
<%
Rs.MoveNext
loop


end if
Rs.close
%>
                        
                    </select>                    

            </td>
            <th width="90px;" class="bg-light">처리일</th>
            <td colspan="3"><%=acheoridate%></td>
        </tr>
        <tr> 
            <th width="90px;" class="bg-light">처리구분</th>
            <td>
                <input type="radio" name="acheorigubun" value="0" checked>
                <label class="form-check-label" >대기 &nbsp&nbsp</label>
                <input type="radio" name="acheorigubun" value="1" >
                <label class="form-check-label" >완료 &nbsp&nbsp</label>

            </td>
            <th width="110px;" class="bg-light">클레임</th>
            <td colspan="3">
                <input type="radio" name="aclaim" value="0" >
                <label class="form-check-label" >유 &nbsp&nbsp</label>
                <input type="radio" name="aclaim" value="1" checked >
                <label class="form-check-label" >무 &nbsp&nbsp</label>
            </td>
        </tr> 
        <tr>
            <th width="80px;" class="bg-light">처리내용</th>
            <td colspan="5">
            <textarea name="acheorimemo" class="form-control" rows="6"></textarea>
            </td>
        </tr>
  
  
    </tbody>
 </table>

 <div class="col text-end ">
    <button type="button" class="btn btn-outline-danger" Onclick="validateform();">저장</button>    
   
</div>
<!--화면 끝-->

    </div>
    </form>
    </div>
</div>
       </div>
     
      
    </main>                          

    
    <!-- footer 시작 -->    
     
    Coded By <%=developername%>
     
    <!-- footer 끝 --> 
               
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
            <script src="/js/scripts.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
     
        </body>
    </html>
    
</html>
<%
 
%>
<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>

