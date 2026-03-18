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
	Set Rs = Server.CreateObject ("ADODB.Recordset")

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 


gubun=Request("gubun")
rgoidx=Request("rgoidx")



if gubun<>"" then 
    gocode=Request("gocode")
    gocword=Request("gocword")
    goname=Request("goname")

    SQL=" select * From tk_goods Where goname='"&goname&"' "
    Rs.open Sql,Dbcon,1,1,1
    if not (Rs.EOF or Rs.BOF ) then
        Response.write "<script>alert('동일한 이름의 품명은 등록할 수 없습니다.');location.replace('goods.asp');</script>"
        response.end
    else 
    SQL=" Insert into tk_goods (gotype, gocode, gocword, goname, gomidx, gowdate) values  ('1','"&gocode&"','"&gocword&"','"&goname&"', '"&C_midx&"', getdate()) "
    'response.write (SQL)
    'response.end
    DbCon.Execute (SQL)
        Response.write "<script>window.parent.location.replace('mes3.asp');</script>"
        response.end
    end if
else
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
        function validateForm(){
            if(document.frmMain.gocode.value==""){
                alert("품목코드를 입력해 주세요.");
                return
            }
            
            if(document.frmMain.gocword.value==""){
                alert("축약어를 입력해 주세요.");
                return
            }
            if(document.frmMain.goname.value==""){
                alert("품명을 입력해 주세요.");
                return
            }
            else{
                document.frmMain.submit();
            }

            
        }
    </script>
    </head>
    <body class="sb-nav-fixed">
            <div id="layoutSidenav_content">
                <main>
                    <div class="container-fluid px-3 mt-3">
                        <div class="row">
                            <div class="col-10"></div>
                            <div class="col-2 text-end">
                  
<!--modal start -->
                                <!-- Button trigger modal -->
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">품목등록</button>

                                <!-- Modal -->
                                <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="exampleModalLabel">품목등록</h1>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="goods.asp?gubun=insert" name="frmMain">
                                                <div class="input-group mb-3">
                                                    <input class="form-control" type="text" placeholder="코드" aria-label="코드" aria-describedby="btnNavbarSearch" name="gocode" />
                                                </div>
                                                <div class="input-group mb-3">
                                                    <input class="form-control" type="text" placeholder="축약어" aria-label="축약어" aria-describedby="btnNavbarSearch" name="gocword" />
                                                </div>
                                                <div class="input-group mb-3">
                                                    <input class="form-control" type="text" placeholder="품명" aria-label="품명" aria-describedby="btnNavbarSearch" name="goname" />
                                                </div>
                                                <div class="row">
                                                    <div class="col-10"></div>
                                                    <div class="col-2 text-end">
                                                        <button type="button" class="btn btn-primary" onClick="validateForm();">등록</button>
                                                    </div>
                                                </div>
                                            </form>

                                        </div>
                  
                                    </div>
                                </div>
                                </div>
                                

                            </div>
                            <div></div>
<!--modal end -->
                            </div>
                        </div>
                        <div class="row justify-content-between">
                        <div  >
                                <table id="datatablesSimple"  class="table" >
                                    <thead>
                                        <tr>
                                            <th align="center">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
                                                </div>
                                            </th>
                                            <th align="center">No</th>
                                            <th align="center">코드</th>
                                            <th align="center">축약어</th>
                                            <th align="center">품명</th>
<!--
                                            <th align="center">도장</th>
                                            <th align="center">복층</th>
-->
                                            <th align="center">중키</th>
                                            <th align="center">단위</th>
                                            <th align="center">사용</th>
                                            <th align="center">작성자</th>
                                            <th align="center">작성일시</th>
                                            <th align="center">수정자</th>
                                            <th align="center">수정일시</th>
                                        </tr>
                                    </thead>
                                    <tbody>
<%
SQL=" Select A.goidx, A.gotype, A.gocode, A.gocword, A.goname, A.gopaint, A.gosecfloor, A.gomidkey, A.gounit, A.gostatus "
SQL=SQL&" , A.gomidx, B.mname, B.mpos, Convert(varchar(16),A.gowdate,121), A.goemidx, C.mname, C.mpos, A.goewdate "
SQL=SQL&" From tk_goods A "
SQL=SQL&" Left Outer Join tk_member B On A.gomidx=B.midx "
SQL=SQL&" Left Outer Join tk_member C On A.goemidx=C.midx "
SQL=SQL&" Order by A.goname desc "
'Response.write (SQL)	
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF

    goidx=Rs(0)
    gotype=Rs(1)
    gocode=Rs(2)
    gocword=Rs(3)
    goname=Rs(4)
    gopaint=Rs(5)
    gosecfloor=Rs(6)
    gomidkey=Rs(7)
    gounit=Rs(8)
    gostatus=Rs(9)
    gomidx=Rs(10)
    fmname=Rs(11)
    fmpos=Rs(12)
    gowdate=Rs(13)
    goemidx=Rs(14)
    smname=Rs(15)
    smpos=Rs(16)    
    goewdate=Rs(17)                    
    i=i+1
    if gostatus="0" then 
        gostatus_text="중지"
    elseif gostatus="1" then 
        gostatus_text="사용"
    end if

%> 
                                        <tr <% if Cint(goidx)=Cint(rgoidx) then %>class="bg-warning"<% end if %> >
                                            <td >
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" value="" readonly>
                                                </div>
                                            </td>
                                            <td><%=i%></td>
                                            <td><%=gocode%></td>
                                            <td><%=gocword%></td>
                                            <td><a onclick="window.parent.location.replace('mes3.asp?rgoidx=<%=goidx%>');"><%=goname%></a></td>
<!--
                                            <td><input class="form-check-input" type="checkbox" value="" checked ></td>
                                            <td><input class="form-check-input" type="checkbox" value="" readonly></td>
-->
                                            <td><input class="form-check-input" type="checkbox" value="" readonly></td>
                                            <td><%=gounit%></td>
                                            <td><input class="form-check-input" type="checkbox" value="" readonly></td>
                                            <td><%=fmname%>&nbsp;<%=fmpos%></td>
                                            <td><%=gowdate%></td>
                                            <td><%=smname%>&nbsp;<%=smpos%></td>
                                            <td><%=goewdate%></td>
                                        </tr>
<%
Rs.movenext
Loop
End If 
Rs.Close   
%> 
                                     </tbody>
                                </table>
                        </div>
                    </div>
                    </div>
                </main>
<!-- footer 시작 -->                
<!-- footer 끝 --> 
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
    </body>
</html>
<%
end if 
%>
<%
set Rs=Nothing
call dbClose()
%>

<!-- 표 부속자재 형식 끝--> 