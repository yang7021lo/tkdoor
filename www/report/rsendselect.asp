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
    Set RsC = Server.CreateObject ("ADODB.Recordset")
    Set Rs = Server.CreateObject ("ADODB.Recordset")
    Set Rs1 = Server.CreateObject ("ADODB.Recordset")
    Set Rs2 = Server.CreateObject ("ADODB.Recordset")
    Set Rs3 = Server.CreateObject ("ADODB.Recordset")

    snidx=request("snidx")
    SearchWord=request("SearchWord")
    udt=request("udt")
    clickacfidx=Request("clickacfidx")
    clickaacfidx=Request("clickaacfidx")

'response.write keyWord&"<br>"
'response.write rgidx&"<br>"


if request("desc")<>"" then
    desc=request("desc")
else
    desc=0
end if

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
      #update {
        color: red;
      } 
    </style>
    <script>


    </script>
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작-->
        <div class="input-group mb-3">
            <h3>전송할 성적서 선택<br></h3>
            <h6 id="update" >*성적표 즐겨찾기 등록은 성적서 현황에서 설정 부탁드립니다.</h6>
        </div>
<!-- 제목 나오는 부분 끝-->
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-danger" Onclick="window.close();">창닫기</button>      
        </div>
<!-- input 형식 시작--> 
<!--
            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="rsendselect.asp?snidx=<%=snidx%>" name="form1">
                <div class="row">
                    <div class="col-10">
                    <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해 주세요." name="SearchWord" value="<%=SearchWord%>">
                    </div>
                    <div class="col-2">
                        <button type="submit" class="btn btn-primary" onclick="submit();">검색</button>
                    </div>
                </div>
            </form>
-->

<!-- input 형식 끝--> 
            
<!-- 검색된 목록 나오기 시작 -->
        <div class="input-group mb-3">
            <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">즐겨찾기</th>
                      <th align="center" width="100px">관리</th>
                  </tr>
              </thead>
              <tbody>
                <%
                SQL="SELECT A.ridx, A.ron, A.rname from tk_report A " 
                SQL=SQL&" where A.ridx not in (Select B.ridx From tk_reportsendsub B where B.snidx='"&snidx&"') and A.rstatus=1 and rfixtop='1' "
                SQL=SQL&" Order by A.rtdate DESC "


                'response.write (SQL)
                'response.write desc

                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do while not Rs.EOF
                    ridx=Rs(0)
                    ron=Rs(1)
                    rname=Rs(2)
                %>
                                <tr>
                                    <td><%=rname%>(<%=ron%>)</td>
                                    <td><button type="button" class="btn btn-outline-danger" Onclick="location.replace('rsendselectdb.asp?ridx=<%=ridx%>&SearchWord=<%=SearchWord%>&snidx=<%=snidx%>&cidx=<%=cidx%>&desc=<%=desc%>&udt=<%=udt%>');">추가</button></td>
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


                        <div class="d-flex flex-row justify-content-start">
                            <div class="d-flex flex-column justify-content-start me-3" style="width:21%;">
                                <%
                                SQL=" Select fname, fidx from tk_reportm where ftype=8 "
                                Rs2.open Sql,Dbcon,1,1,1
                                if not (Rs2.EOF or Rs2.BOF) then
                                for j=1 to Rs2.RecordCount
                                if no-j=0 then exit for end if
                                acfname=Rs2(0)
                                acfidx=Rs2(1)
                                %>
                                    <button class="btn btn-outline-primary mb-3" type="button" Onclick="location.replace('rsendselect.asp?clickacfidx=<%=acfidx%>&snidx=<%=snidx%>');">
                                        <%=acfname%>
                                    </button>
                                <%
                                Rs2.MoveNext
                                Next
                                End If
                                Rs2.Close
                                %>
                            </div>

                            <% if clickacfidx<>"" then %>
                                <div class="d-flex flex-column justify-content-start me-3" style="width:19%;">
                                    <%
                                    SQL=" Select fname, fidx from tk_reportm where ftype=1 "
                                    Rs1.open Sql,Dbcon,1,1,1
                                    if not (Rs1.EOF or Rs1.BOF) then
                                    for jj=1 to Rs1.RecordCount
                                    if no-jj=0 then exit for end if
                                    aacfname=Rs1(0)
                                    aacfidx=Rs1(1)
                                    %>
                                        <button class="btn btn-outline-primary mb-3" type="button" Onclick="location.replace('rsendselect.asp?clickaacfidx=<%=aacfidx%>&clickacfidx=<%=clickacfidx%>&snidx=<%=snidx%>');">
                                            <%=aacfname%>
                                        </button>
                                    <%
                                    Rs1.MoveNext
                                    Next
                                    End If
                                    Rs1.Close
                                    %>
                                </div>
                            <% End if %>

                            <% if clickaacfidx<>"" then %>
                                <div class="input-group mb-3">
                                    <table id="datatablesSimple" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th align="center">접수번호(시료명)</th>
                                                <th align="center">관리</th>
                                            </tr>                               
                                                </thead>

                                            <tbody>
                                                <%
                                                SQL= "Select a.ridx, a.ron, a.rname, a.rfixtop "
                                                SQL=SQL&" from tk_report A "
                                                SQL=SQL&" Join tk_reportSub D On D.ridx=A.ridx "
                                                SQL=SQL&" Where Exists ( Select D.rfidx from tk_reportsub D Where D.ridx = A.ridx and D.rfidx='"&clickacfidx&"' ) and Exists ( Select D.rfidx from tk_reportsub Where D.ridx = A.ridx and D.rfidx='"&clickaacfidx&"' ) "
                                                SQL=SQL&" and A.ridx not in (Select B.ridx From tk_reportsendsub B where B.snidx='"&snidx&"') and A.rstatus=1 "
                                                SQL=SQL&" Order by A.ridx desc "   
                                                'Response.write (SQL)& "<br>"
                                                Rs.open Sql,Dbcon,1,1,1
                                                Rs.Pagesize=10000

                                                if not (Rs.EOF or Rs.BOF) then
                                                no = Rs.recordcount - (Rs.pagesize * (gotopage-1))+1
                                                totalpage=Rs.PageCount
                                                i=1

                                                for jjj=1 to Rs.RecordCount
                                                if i>Rs.PageSize then exit for end if
                                                if no-jjj=0 then exit for end if

                                                    ridx=Rs(0)
                                                    ron=Rs(1)
                                                    rname=Rs(2)
                                                    rfixtop=Rs(3)                                   
                                                %>

                                            <tr>
                                                <td><%=ron%>(<%=rname%>)</td>               <!--시료명(접수번호)-->
                                                <td>
                                                <button type="button" class="btn btn-outline-danger" Onclick="location.replace('rsendselectdb.asp?ridx=<%=ridx%>&SearchWord=<%=SearchWord%>&snidx=<%=snidx%>&cidx=<%=cidx%>&desc=<%=desc%>&udt=<%=udt%>');">추가</button>                                       
                                                </td><!--관리-->                                    
                                            </tr>

                                            <%
                                            afname=""
                                            k=0
                                            i=i+1
                                            Rs.MoveNext
                                            Next
                                            End If      
                                            Rs.Close                         
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            <% End if %>
                        </div>
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

<!--
        <div class="input-group mb-3">
            <div class="input-group mb-3">
                <%' if desc = 0 then %>
                    <button type="button" class="btn btn-outline-primary" Onclick="location.replace('rsendselect.asp?snidx=<%=snidx%>&desc=1');">오래된 등록일 순</button>
                <%' else %>
                    <button type="button" class="btn btn-outline-primary" Onclick="location.replace('rsendselect.asp?snidx=<%=snidx%>&desc=0');">최근 등록일 순</button>
                <%' end if %>      
            </div>

            <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th align="center">시료명</th>
                        <th align="center" width="100px">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    'SQL="SELECT A.ridx, A.ron, A.rname from tk_report A " 
                    'SQL=SQL&" where A.ridx not in (Select B.ridx From tk_reportsendsub B where B.snidx='"&snidx&"') and A.rstatus=1"

                    'if SearchWord<>"" then
                    '    SQL=SQL&" and (A.rname like '%"&SearchWord&"%' or A.ron like '%"&request("SearchWord")&"%') "
                    'end if

                    'if desc=0 then 
                    '    SQL=SQL&" Order by A.rtdate DESC "
                    'else
                    '    SQL=SQL&" Order by A.rtdate ASC "
                    'end if

                    'response.write (SQL)
                    'response.write desc

                    'Rs.open Sql,Dbcon
                    'If Not (Rs.bof or Rs.eof) Then 
                    'Do while not Rs.EOF
                    '    ridx=Rs(0)
                    '    ron=Rs(1)
                    '    rname=Rs(2)
                    %>
                                    <tr>
                                        <td><%=rname%>(<%=ron%>)</td>
                                        <td><button type="button" class="btn btn-outline-danger" Onclick="location.replace('rsendselectdb.asp?ridx=<%=ridx%>&SearchWord=<%=SearchWord%>&snidx=<%=snidx%>&cidx=<%=cidx%>&desc=<%=desc%>&udt=<%=udt%>');">추가</button></td>
                                    </tr>
                    <%
                    'Rs.movenext
                    'Loop
                    'End if
                    'Rs.close
                    %>
                </tbody>  
            </table> 
            </div>
 검색된 목록 나오기 끝-->