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
%>
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function
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
        <link href="css/styles.css" rel="stylesheet" />
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
            <div id="layoutSidenav_content">
                <main>
                    <div class="container-fluid px-0">
                        <div class="row justify-content-between">
                        <div  >
                                <table id="datatablesSimple"  class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th align="center">No</th>
                                            <th align="center">품명</th>
                                            <!--<th align="center">구분</th>-->
                                        </tr>
                                    </thead>
                                    <tbody>
<%
SQL=" Select A.BARIDX, A.barNAME, A.atype, A.barSTATUS, A.barmidx, Convert(Varchar(10),A.barwdate,121), B.mname , Convert(Varchar(10),A.barewdate,121), C.mname "
SQL=SQL&" From tk_barlist A "
SQL=SQL&" Join tk_member B On A.barmidx=B.midx "
SQL=SQL&" left outer join tk_member c on A.baremidx=C.midx "
SQL=SQL&" Where A.barIDX<>''  "
SQL=SQL&"Order By A.BARIDX asc "

'Response.write (SQL)	
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF

    yyy=yyy+1
    barIDX=Rs(0)
    barNAME=Rs(1)
    atype=Rs(2)
    barSTATUS=Rs(3)
    barmidx=Rs(4)
    barwdate=Rs(5)
    mname=Rs(6)
    barewdate=rs(7)
    emname=rs(8)                                    

    if barSTATUS="0" then 
        barSTATUS_text="중지"
    elseif barSTATUS="1" then 
        barSTATUS_text="사용"
    end if
%> 
                                        <tr>
                                            <td><%=yyy%></td>
                                            <td><%=barNAME%></td>
                                            <!--<td><%=atype_text%></td>-->
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
set Rs=Nothing
call dbClose()
%>

<!-- 표 부속자재 형식 끝--> 