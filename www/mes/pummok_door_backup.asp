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


    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 
    listgubun="one"
    projectname="품목관리"
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

rgoidx=Request("rgoidx")    '품목 키
rsidx=Request("rsidx")  '규격키



if rgoidx="" then rgoidx="0" end if 


	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"


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

    </script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_pummok.asp"-->


<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between">
<!-- 내용 입력 시작 -->  
            <div class="col-11">
                <div class="row card mb-2" style="height:400px;">
                    <iframe name="goods" width="100%" height="100%" src="goods.asp?rgoidx=<%=rgoidx%>" border="0" scrolling="no"></iframe>
                </div>
            <div class="row " >
                <div class="col-2 card">
<!-- 표 부속자재 형식 시작--> 
                    <div class="mt-1"><h5>부속자재</h5></div>
                    <iframe name="hide" width="100%" height="300" src="busok.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>" border="0"></iframe> 
<!-- 표 부속자재 형식 끝--> 
                </div>
                <div class="col-10 card">
<!-- 표 형식 시작--> 
                    <div class="mt-1"><h5>공정구성</h5></div>
                    <div class="input-group mb-3">
                        <table id="datatablesSimple"  class="table table-border">
                            <thead>
                                <tr>
                                    <th align="center"><input type="checkbox" name=""></th>                  
                                    <th align="center">순번</th>
                                    <th align="center">구분</th>
                                    <th align="center">공정</th>
                                    <th align="center">품명</th>
                                    <th align="center">AL</th>
                                    <th align="center">수량(AL)</th>
                                    <th align="center">ST</th>  
                                    <th align="center">수량(ST)</th>
                                    <th align="center">유리</th>
                                    <th align="center">격자</th>
                                    <th align="center">비고</th>
                                    <th align="center">결합제외여부</th>
                                    <th align="center">작성자</th>
                                    <th align="center">작성일시</th>
                                    <th align="center">수정자</th>
                                    <th align="center">수정일시</th>                      
                                </tr>
                            </thead>
                            <tbody>
<%
SQL=" select A.smidx, A.buidx, B.buname, A.smtype, A.smproc, A.smal, A.smalqu, A.smst, A.smstqu, A.smglass, A.smgrid, A.smnote, A.smcomb "
SQL=SQL&" , A.smmidx, C.mname, Convert(varchar(16),A.smwdate,121), A.smemidx, D.mname, Convert(varchar(16),A.smewdate,121) "
SQL=SQL&" From tk_material A "
SQL=SQL&" Join tk_busok B  On A.buidx=B.buidx "
SQL=SQL&" Join tk_member C On A.smmidx=C.midx "
SQL=SQL&" Left Outer Join tk_member D On A.smemidx=D.midx "
SQL=SQL&" Where A.sidx='"&rsidx&"' "
'Response.write (SQL)	
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF

smidx=Rs(0)
buidx=Rs(1)
buname=Rs(2)
smtype=Rs(3)
smproc=Rs(4)
smal=Rs(5)
smalqu=Rs(6)
smst=Rs(7)
smstqu=Rs(8)
smglass=Rs(9)
smgrid=Rs(10)
smnote=Rs(11)
smcomb=Rs(12)
smmidx=Rs(13)
fmname=Rs(14)
smwdate=Rs(15)
smemidx=Rs(16)
smname=Rs(17)
smewdate=Rs(18)

%>              
                                <tr>
                                    <td><input type="checkbox" name=""></td>
                                    <td><%=smidx%></td>
                                    <td><%=smtype%></td>
                                    <td><%=smproc%></td>
                                    <td><%=buname%></td>
                                    <td><%=smal%></td>
                                    <td><%=smalqu%></td>
                                    <td><%=smst%></td>
                                    <td><%=smstqu%></td>
                                    <td><%=smglass%></td>
                                    <td><%=smgrid%></td>      
                                    <td><%=smnote%></td>
                                    <td><%=smcomb%></td>
                                    <td><%=fmname%></td> 
                                    <td><%=smwdate%></td>
                                    <td><%=smname%></td>
                                    <td><%=smewdate%></td>                       
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
<!-- 표 형식 끝--> 
                </div>
            </div>
        </div>
            <div class="col-1" >
                <div class="row card" style="height:300;">
<!-- 표 형식 시작--> 

                    <div class="input-group mb-3">
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th align="center">사용규격</th>
                                </tr>
                            </thead>
                            <tbody>
<%
SQL=" select A.sidx, A.baridx, B.barNAME "
SQL=SQL&" from tk_stand A "
SQL=SQL&" Join tk_barlist  B On  A.baridx=B.baridx "
SQL=SQL&" Where A.goidx='"&rgoidx&"' "
'Response.write (SQL)	
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
    sidx=Rs(0)
    baridx=Rs(1)
    barNAME=Rs(2)

if cint(rsidx)=cint(sidx) then 
cccc="#f1592c"
else 
cccc="#ffffff"

end if
%>              
                                <tr bgcolor="<%=cccc%>"> 
                                    <td><a onclick="window.parent.location.replace('mes3.asp?rgoidx=<%=rgoidx%>&rsidx=<%=sidx%>');"><%=barNAME%><% if cint(rsidx)=cint(sidx) then %>fffffff<% end if %> </a></td>
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
</form>
<!-- 표 형식 끝--> 
                </div>
                <div class="row card" > 
                <!-- 표 형식 시작--> 
                <iframe name="hide"  height="550" src="barlist.asp?rgoidx=<%=rgoidx%>" border="0"></iframe>  
                <!-- 표 형식 끝--> 
                </div>
            </div>









<!-- 내용입력 끝 -->
        </div>
    </div>
</main>                          


<!-- footer 시작 -->    

Coded By 양양

<!-- footer 끝 --> 
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
