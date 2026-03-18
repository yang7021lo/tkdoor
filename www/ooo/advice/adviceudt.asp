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

    listgubun="two"
    projectname="거래처 상담내용 수정"
   
%>
 
<%



    SearchWord=Request("SearchWord")
    gubun=Request("gubun")

    cidx=Request("cidx")
    aidx=Request("aidx")
   
    
    SQL=" select A.aidx, A.acidx, A.aform ,A.agubun, A.aclaim, A.adetails, A.acheorigubun, A.aname, A.adate, A.acheoriname, A.acheoridate, A.acheorimemo "
    SQL=SQL&" , B.mname, D.mname, C.cname "
    SQL=SQL&" From Tk_advice A"
    SQL=SQL&" Join tk_member B On A.aname=B.midx "
    SQL=SQL&" Join tk_customer C on A.acidx=C.cidx "
    SQL=SQL&" Left Outer Join tk_member D On A.acheoriname=D.midx "
    SQL=SQL&" where aidx='"&aidx&"'"
    'response.write (SQL)&"<br>"
    'Response.end
    Rs.open SQL,Dbcon,1,1,1

if not (Rs.EOF or Rs.BOF ) then
aidx=Rs(0)
acidx=Rs(1)
aform=Rs(2)
agubun=Rs(3)
aclaim=Rs(4)
adetails=Rs(5)
acheorigubun=Rs(6)
aname=Rs(7)
adate=Rs(8)
acheoriname=Rs(9)
acheoridate=Rs(10)
acheorimemo=Rs(11)
mname=RS(12)
bmname=Rs(13)
rcname=Rs(14)

End If
Rs.Close
%>



<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <title><%=projectname%></title>
    <link rel="icon"  sizes="image/x-icon" href="/inc/tkico.png">
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
        function del(afidx, cidx, aidx){
            if (confirm("정말 삭제하시겠습니까??"))
            {
                location.href="advicedeldb.asp?afidx="+afidx+"&cidx="+cidx+"&aidx="+aidx;
            } 
        }
        function delX(afidx, cidx, aidx){
            if (confirm("상담내용을 삭제하시겠습니까??"))
            {
                location.href="advicedelXdb.asp?afidx="+afidx+"&cidx="+cidx+"&aidx="+aidx;
            } 
        }
    </script>
 
  </head>
  <body class="sb-nav-fixed">

    
    
    <div id="layoutSidenav_content">            
    <main>
      <div class="container-fluid px-4">
       <div class="row justify-content-between py-3 ">

<!--화면시작-->

<div class="py-0 mt-3 mb-3 container text-start">
    <form name="ad" action="adviceudtdb.asp" method="post">
    <input name="aidx" type="hidden" value="<%=aidx%>" >
    <input name="acidx" type="hidden" value="<%=cidx%>" >
<div class="row mb-2 px-0 py-0">

 <table class="table table-bordered">
    <tbody>
        <tr>
            <th width="80px;" class="bg-light">거래처</th>
            <td><%=rcname%></td>
            <th width="80px;" class="bg-light">상담자</th>
            <td><%=c_mname%></td>
            <th width="90px;" class="bg-light">상담날짜</th>
            <td><%=adate%></td>
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
            <textarea name="adetails" class="form-control" rows="6" disabled><%=adetails%></textarea>
            </td>
        </tr>
        <tr> 
            <th width="110px;" class="bg-light">처리자</th>
            <td>
                
                    <select class="form-select" id="acheoriname" name="acheoriname">
                        <option value="">선택하세요.</option>
<%
SQL="select midx, mname from tk_member where cidx='1' or cidx='2' or cidx='3'"
Rs.open sql,dbcon    
if not (Rs.bof or rs.eof) then                
do until rs.eof
    midx=rs(0)
    mname=rs(1)
%> 

                       <option value="<%=midx%>" <% if acheoriname=midx then %>selected<% end if %> ><%=mname%></option>                        
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
                <input type="radio" name="acheorigubun" value="0" <% if acheorigubun="0" or acheorigubun="" then Response.write "checked" end if %>>
                <label class="form-check-label" >대기 &nbsp&nbsp</label>
                <input type="radio" name="acheorigubun" value="1" <% if acheorigubun="1" then Response.write "checked" end if %> >
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
            <textarea name="acheorimemo" class="form-control" rows="6"><%=acheorimemo%></textarea>
            </td>
        </tr>
        <tr>
            <th width="80px;" class="bg-light">
                <button type="button" class="btn btn-success" onclick="window.open('advice_upload.asp?cidx=<%=cidx%>&aidx=<%=aidx%>','oesadv','top=200, left=300, width=800, height=200');">파일추가</button>
            </th>
            <td colspan="5">
<%
SQL="Select A.afidx, A.afname, A.afmidx, B.mname, Convert(varchar(10),afdate,121) "
SQL=SQL&" From tk_advicefile A "
SQL=SQL&" Join tk_member B On A.afmidx=B.midx "
SQL=SQL&" where aidx='"&aidx&"' "
SQL=SQL&" Order by afidx desc "
Rs.open sql,dbcon    
if not (Rs.bof or rs.eof) then                
do until rs.eof
    afidx=Rs(0)
    afname=Rs(1)
    afmidx=Rs(2)
    mname=Rs(3)
    afdate=Rs(4)
   
%>      
<a href="/afile/advice/<%=afname%>" target="_blank"><%=afname%>&nbsp;<%=mname%>&nbsp;<%=afdate%></a><button type="button" class="btn btn-danger" onclick="del('<%=afidx%>','<%=cidx%>','<%=aidx%>');">X</button><br>
<%
Rs.MoveNext
loop
end if
Rs.close
%>
            </td>
        </tr>
  
  
    </tbody>
 </table>

 <div class="col text-end ">

    <% 
    if cint(aname)=cint(c_midx) then 
    %>
     <button type="button" class="btn btn-outline-danger" Onclick="delX('<%=afidx%>','<%=cidx%>', '<%=aidx%>');">삭제</button>
    <% 
    end if 
    %>
    
     <button type="button" class="btn btn-outline-danger" Onclick="validateform();">수정</button>  
      
                    
</div>
<!--화면 끝-->

    </div>
    </form>
    </div>
</div>
       </div>
     
      
    </main>                          

    
    <!-- footer 시작 -->    
     
    Coded By 오소리
     
    <!-- footer 끝 --> 
               
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