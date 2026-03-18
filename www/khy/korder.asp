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
    
listgubun="four"
projectname="자재발주"

kidx=Request("kidx")
%>
 
<%
   function encodestr(str)
      if str = "" then exit function
      str = replace(str,chr(34),"&#34")
      str = replace(str,"'","''")
      encodestr = str
   end Function


SearchWord=Request("SearchWord")
gubun=Request("gubun")
 

   if request("gotopage")="" then
   gotopage=1
   else
   gotopage=request("gotopage")
   end if
   page_name="korder.asp?kidx="&kidx&"&"

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
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
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
function save(selectElement, kidx, ksidx) {
    const selectedValue = selectElement.value;
    if (selectedValue) {
        location.replace('kordersubdb2.asp?kidx='+kidx+'&ksidx='+ksidx+'&odrkkg='+selectedValue+'');
    }

}
function saveone(selectElement, kidx, ksidx) {
    const selectedValue = selectElement.value;
    if (selectedValue) {
        location.replace('kordersubdb2.asp?kidx='+kidx+'&ksidx='+ksidx+'&odrea='+selectedValue+'');
    }

}

    </script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left.asp"-->


<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!-- 내용 입력 시작 -->  
    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작 -->

<% if kidx="" then %>
<!-- kidx가 없다면 매입처 선택 및 등록 화면이 나온다 -->
        <div class="input-group mb-3">
            <h3>매입처선택</h3>
        </div>
<!-- 제목 나오는 부분 끝 -->  
<form name="frmMain" action="korderdb.asp" method="post">

        <div class="input-group mb-3">
            <span class="input-group-text">매입처&nbsp;&nbsp;&nbsp;</span>
            <select class="form-select" name="kcidx">

<%
SQL="select cidx, cname from tk_customer "
Rs.open Sql,dbcon
If Not (Rs.bof or Rs.eof) then
Do until Rs.eof
    cidx=Rs(0)
    cname=Rs(1)

    
%>
               <option value="<%=cidx%>"><%=cname%></option>
<%
Rs.MoveNext
Loop
End If
Rs.close                 
%>
            </select>
            <span class="input-group-text">담당자&nbsp;&nbsp;&nbsp;</span>      
            <select class="form-select" name="kmidx">
<%
SQL=" select A.midx, A.mname, A.mpos "
SQL=SQL&" from tk_member A "
SQL=SQL&" Join tk_customer B On A. cidx=B.cidx "
SQL=SQL&" where  B.cidx='1' "  

Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then
Do until Rs.EOF
    midx=Rs(0)
    mname=Rs(1)
    mpos=Rs(2)
 
%>
               <option value="<%=midx%>" ><%=mname%>&nbsp;<%=mpos%></option>   
 <%
Rs.MoveNext
Loop
End If
Rs.close                 
%>
            </select>
            <button type="button" class="btn btn-outline-danger" onclick="submit();">발주등록</button>
        </div>
</form>

<% else %>

<%
SQL=" select A.kcidx, A.kmidx, A.midx, kstatus, B.cname, C.mname, D.mname "
SQL=SQL&" from tk_korder A "
SQL=SQL&" Join tk_customer B On A.kcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.kmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" where A.kidx='"&kidx&"' "
'Response.write  (SQL)
Rs.open sql,Dbcon
if not (Rs.EOF or Rs.BOF ) then
    kcidx=Rs(0)
    kmidx=Rs(1)
    midx=Rs(2)
    kststus=Rs(3)
    cname=Rs(4)
    cmname=Rs(5)
    mname=Rs(6)
end if
Rs.close 


%>
<!-- kidx가 있다면 매입 자재 등록 화면이 나온다 -->
        <div class="input-group mb-3">
             <h3>자재선택</h3>      
        </div> 
<!-- view 형식 시작-->        
        <div class="input-group mb-3">
          <span class="input-group-text">매입처&nbsp;&nbsp;&nbsp;</span>
          <div class="card text-start" style="width:25%;padding:5 5 5 5;"><%=cname%></div>
          <span class="input-group-text">담당자&nbsp;&nbsp;&nbsp;</span>
          <div class="card text-start" style="width:25%;padding:5 5 5 5;"><%=cmname%></div>
          <span class="input-group-text">관리자&nbsp;&nbsp;&nbsp;</span>
          <div class="card text-start" style="width:25%;padding:5 5 5 5;"><%=mname%></div>          
        </div>
<!-- view 형식 끝 -->    
<div class="row mb-2">
    <div class="col-9 text-start">
    </div>
    <div class="col-3">
<form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="korder.asp" name="form1">    
<input type="hidden" name="kidx" value="<%=kidx%>">  
        <div class="input-group">
          <input class="form-control" type="text" placeholder="자재조회" aria-label="자재조회" aria-describedby="btnNavbarSearch" name="SearchWord" />
          <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i></button>
        </div>
</form>        
    </div>   
 </div>


<!-- 숙제 시작-->

<!-- 버튼 정보 시작 -->

<!-- 버튼 정보 끝 -->
<div class="row">
    <div class="col-6 card py-5 ">
      <table id="datatablesSimple"  class="table table-hover">
        <thead>
            <tr>
                <th align="center">번호</th>
                <th align="center">자재명</th>
                <th align="center">중량</th>
                <th align="center">kg</th>
                <th align="center">ea</th>
                <th align="center">수량</th>
                <th align="center">첨부 파일</th> <!-- 첨부 파일 추가 -->
            </tr>
        </thead>
        <tbody>
         
<%
SQL=" select A.ksidx,  B.order_idx, B.order_name, A.odrkkg, A.odrea, A.odrdate, A.filedet "
SQL=SQL&" from tk_korderSub A "
SQL=SQL&" Join tk_khyorder  B On A.odridx=B.order_idx "
SQL=SQL&" Where kidx='"&kidx&"' "
SQL=SQL&" Order by A.odrdate ASC "

Rs.open Sql,Dbcon

If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF


    ksidx=Rs(0)
    order_idx=Rs(1)
    order_name=Rs(2)
    odrkkg=Rs(3)
    odrea=Rs(4)
    odrdate=Rs(5) 
    filedet=Rs(6)  

    hy=hy+1

%>
          <tr>
            <td><%=hy%></td>
            <td><%=order_name%></td>
            <td><%=odrkkg%></td>
            <td>
                <select class="form-select" onchange="save(this, '<%=kidx%>', '<%=ksidx%>')">
                    <option value="">선택</option>
                    <option value="150">150</option>
                    <option value="250">250</option>
                    <option value="300">300</option>
                    <option value="500">500</option>
                    <option value="1000">1000</option>
                    <option value="2000">2000</option>
                </select>
            </td>
            <td><%=odrea%></td>
            <td>
                <select class="form-select" onchange="saveone(this, '<%=kidx%>', '<%=ksidx%>')">
                    <option value="">선택</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                    <option value="150">150</option>
                    <option value="200">200</option>
                    <option value="250">250</option>
                    <option value="300">300</option>
                </select>
            </td>
            <td>

                    <button type="button" class="btn btn-sm btn-success" onclick="window.open('korder_upload.asp?kidx=<%=kidx%>&ksidx=<%=ksidx%>','khy','top=200, left=300, width=800, height=200');">업로드</button>
                    <%=filedet%>
            </td>
          </tr>

<%
Rs.movenext
Loop
End if
Rs.close
%>

         </tbody>
      </table>
<div class="col-12 text-start">
    <button type="button" onclick="location.replace('korderlist.asp?kidx=<%=kidx%>');" class="btn btn-primary">발주관리보기</button>
  <button type="button" onclick="location.replace('korderlist.asp?kidx=<%=kidx%>');" class="btn btn-primary">전체발주목록</button>
</div>
    </div>
    <div class="col-6 card py-5 ">
    <div class="row">
      <table id="datatablesSimple"  class="table table-hover">
        <thead>
            <tr>
                <th align="center">번호</th>
                <th align="center">구분</th>
                <th align="center">자재명</th>
                <th align="center">길이</th>
                <th align="center">주문</th>
            </tr>
        </thead>
        <tbody>
<%
    SQL=" select order_idx, order_name, order_length, order_type "
    SQL=SQL&" from tk_khyorder "
    SQL=SQL&" Where order_status='1' "
    If Request("SearchWord")<>"" Then
    SQL=SQL &" and order_name like '%"&request("SearchWord")&"%' "
    End If
    SQL=SQL &" Order by order_name asc "
    'Response.write (SQL)
    Rs.open Sql,Dbcon,1,1,1
    Rs.PageSize = 10

    if not (Rs.EOF or Rs.BOF ) then
        no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
        totalpage=Rs.PageCount '
        Rs.AbsolutePage =gotopage
        i=1
        for j=i to Rs.RecordCount
        if i>Rs.PageSize then exit for end if
        if no=j-0 then exit for end if

        order_idx=Rs(0)
        order_name=Rs(1)
        order_length=Rs(2)
        order_type=Rs(3)

        Select case order_length
            case "0"
                order_length_text="없음"
            case "1"
                order_length_text="2,200mm"
            case "2"
                order_length_text="2,400mm"
            case "3"
                order_length_text="2,500mm"
            case "4"
                order_length_text="2,800mm"
            case "5"
                order_length_text="3,000mm"
            case "6"
                order_length_text="3,200mm"
        end select
        
        Select case order_type
            case "0"
                order_type_text="없음"
            case "1"
                order_type_text="무피"
            case "2"
                order_type_text="백피"
            case "3"
                order_type_text="블랙"
        end select
%>
          <tr>
            <td><%=no-j%></td>
            <td><%=order_type_text%></td>
            <td><%=order_name%></td>
            <td><%=order_length_text%></td>
            <td><button class="btn btn-primary" type="button" onclick="location.replace('kordersubdb.asp?kidx=<%=kidx%>&order_idx=<%=order_idx%>');">추가</button></td>
          </tr>
          <%
          Rs.MoveNext
          i=i+1
          Next
          
          End If
          %>
         </tbody>
      </table>
    </div>        
    <div class="row col-12 py-3">
        <!--#include Virtual = "/inc/paging.asp"-->
        
    </div>
<%
    Rs.Close
%>   

    </div>
</div>


<%
End if
%>

<!-- 내용입력 끝 -->
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 호영
 
<!-- footer 끝 --> 
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
 
    </body>
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
