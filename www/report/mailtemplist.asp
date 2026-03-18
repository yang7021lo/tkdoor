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

    listgubun="one"
    projectname="발송된 성적서"
    developername="원준"
 
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
re=Request("re")


    if request("gotopage")="" then
        gotopage=1
    else
        gotopage=request("gotopage")
    end if

    page_name="mailtemplist.asp?"


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
    function smwindow(str){
        newwin=window.open(str,'win1', 'scrollbars=yes,menubar=no,statusbar=no,status=no,width=990,height=800,top=200,left=200');
        newwin.focus();
    }

    </script>
 
  </head>
  <body class="sb-nav-fixed">    
    <div id="layoutSidenav_content">            
    <main>   

      <div class="container-fluid px-4">
       <div class="row justify-content-between py-3 "> 
            <div class=" py-5 container text-center card card-body">
<!--화면시작-->

<!-- 회원 정보 시작 -->
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">성적서 수신 거래처</th>
                      <th align="center">저장자</th>
                      <th align="center">수신이메일</th>
                      <th align="center">불러오기</th>
                      <th align="center">삭제</th>
                  </tr>
              </thead>
              <tbody>
<%
SQL=" Select A.snidx, A.sndate, C.mname, A.sncidx, A.snreadstatus "
SQL=SQL&" from tk_reportsend A "
SQL=SQL&" Left Outer Join tk_reportsendcorpSub B On B.snidx=A.snidx "
SQL=SQL&" Left Outer Join tk_member C On A.snmidx=C.midx "
SQL=SQL&" Where A.sndate Is NULL and snsendstatus='1' "

if Request("SearchWord")<>"" then
    SQL=SQL&" and (B.cname like '%"&request("SearchWord")&"%' or C.mname like '%"&request("SearchWord")&"%' or A.mtitle like '%"&request("SearchWord")&"%' or A.filename like '%"&request("SearchWord")&"%' or A.report like '%"&request("SearchWord")&"%' or A.reportg like '%"&request("SearchWord")&"%' ) "  
end if

SQL=SQL&" Order by A.sndate DESC "

Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 10                     

if not (Rs.EOF or Rs.BOF ) then

no = Rs.recordcount - (Rs.pagesize * (gotopage-1))+1
totalpage=Rs.PageCount
Rs.AbsolutePage=gotopage
i=1

for j=i to Rs.RecordCount
if i>Rs.PageSize then exit for end if
if no=j-0 then exit for end if

snidx=Rs(0)
sndate=Rs(1)
mname=Rs(2)
sncidx=Rs(3)
snreadstatus=Rs(4)
%>


                  <tr>
                      <td>
                        <% 
                        SQL="Select cname from tk_reportsendcorpSub A "
                        SQL=SQL&" Where A.snidx='"&snidx&"' "

                        Rs1.open Sql,Dbcon,1,1,1

                        if not (Rs1.EOF or Rs1.BOF ) then
                        k=1
                        
                        for t=k to Rs1.RecordCount
                        
                        cname=Rs1(0)
                        
                        %>

                            <%=cname%><br>
                    
                        <%
                        k=k+1
                        Rs1.MoveNext
                        Next
                        End If
                        Rs1.Close
                        %>
                      </td>
                      <td><%=mname%></td>
                      <td>
                      <% 
                        SQL="Select memail from tk_emailselect "
                        SQL=SQL&" Where snidx='"&snidx&"' "

                        Rs1.open Sql,Dbcon,1,1,1

                        if not (Rs1.EOF or Rs1.BOF ) then
                        k=1
                        
                        for t=k to Rs1.RecordCount
                        
                        memail=Rs1(0)
                        
                        %>

                            <%=memail%><br>
                    
                        <%
                        k=k+1
                        Rs1.MoveNext
                        Next
                        End If
                        Rs1.Close
                        %>
                      </td>

                      <td>
                      <% if re<>"" then %>
                        <button type="button" class="btn btn-outline-primary" onclick="window.close();opener.location.replace('sendmailre.asp?snidx=<%=snidx%>');">불러오기</button>
                      <% else %>
                        <button type="button" class="btn btn-outline-primary" onclick="location.replace('sendmail.asp?snidx=<%=snidx%>');">불러오기</button>
                      <% end if %>
                      </td>

                      <td><button type="button" class="btn btn-outline-primary" onclick="location.replace('rsenddeldb.asp?snidx=<%=snidx%>&temp=1&gotopage=<%=gotopage%>');">삭제</button></td>
                  </tr>
<%
    i=i+1
    Rs.MoveNext
    Next
    End If
%>
              </tbody>
          </table>
<!-- 회원 정보 끝 -->
        </div>
<!--화면 끝-->
      </div>
    </div>
                <div class="row col-12 py-0">    
                    <!--#include virtual = "/inc/paging.asp"-->
                </div>

                <% Rs.Close %>    
    </main>                          
     
    
    <!-- footer 시작 -->    
     
    Coded By 원준
     
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

