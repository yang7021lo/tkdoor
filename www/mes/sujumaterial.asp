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
listgubun="one"
subgubun="one2"
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
rgoidx=Request("rgoidx")
rsidx=Request("rsidx")
rbuidx=Request("rbuidx")
smidx=Request("smidx")
baridx=Request("baridx")
barNAME=Request("barNAME")
goname=Request("goname")

'Response.write "rgoidx;"&rgoidx&"<br>"
'Response.write "rsidx;"&rsidx&"<br>"
'Response.write "rbuidx;"&rbuidx&"<br>"
'Response.write "smidx;"&smidx&"<br>"
'Response.write "baridx;"&baridx&"<br>"
'Response.write "barNAME;"&barNAME&"<br>"
'Response.write "goname;"&goname&"<br>"
'response.end


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
                            <th align="center">부속자재</th>
                            <th align="center">AL</th>
                            <th align="center">수량(AL)</th>
                            <th align="center">ST</th>  
                            <th align="center">수량(ST)</th>
                            <th align="center">유리</th>
                            <th align="center">격자</th>
                            <th align="center">손잡이폭</th>
                            <th align="center">손잡이높이</th>
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
                    SQL=" select A.smidx, A.buidx, B.buname, A.smtype, A.smproc, A.smal, A.smalqu, A.smst, A.smstqu, A.smglass, A.smgrid, A.tagongfok, A.tagonghigh, A.smnote, A.smcomb "
                    SQL=SQL&" , A.smmidx, C.mname, Convert(varchar(16),A.smwdate,121), A.smemidx, D.mname, Convert(varchar(16),A.smewdate,121) "
                    SQL=SQL&" From tk_material A "
                    SQL=SQL&" Join tk_busok B  On A.buidx=B.buidx "
                    SQL=SQL&" Join tk_member C On A.smmidx=C.midx "
                    SQL=SQL&" Left Outer Join tk_member D On A.smemidx=D.midx "
                    SQL=SQL&" Where A.smidx='"&smidx&"' "
                    'Response.write (SQL)	
                    Rs.open Sql,Dbcon,1,1,1
                    if not (Rs.EOF or Rs.BOF ) then
                    Do while not Rs.EOF

                    smidx=Rs(0) '기본키
                    buidx=Rs(1) 'tk_busok TB 키
                    buname=Rs(2)    '품명
                    smtype=Rs(3)    '구분
                    Select Case smtype
                    Case "1"
                    smtype_Text = "W"
                    Case "2"
                    smtype_Text = "H"
                    Case "3"
                    smtype_Text = "W1"
                    Case "4"
                    smtype_Text = "H1"
                    Case Else
                    smtype_Text = "" ' 기본값
                    End Select
                    smproc=Rs(4)    '공정
                    Select Case smproc
                    Case "1"
                    smproc_Text = "H바"
                    Case "2"
                    smproc_Text = "다대"
                    Case "3"
                    smproc_Text = "출몰바"
                    Case Else
                    smproc_Text = "" ' 기본값
                    End Select
                    smal=Rs(5)  'AL
                    smalqu=Rs(6)    '수량(AL)
                    smst=Rs(7)  'ST
                    smstqu=Rs(8)    '수량(ST)
                    smglass=Rs(9)   '유리
                    smgrid=Rs(10)   '격자
                    tagongfok=Rs(11)   '손잡이폭
                    tagonghigh=Rs(12)   '손잡이높이
                    smnote=Rs(13)   '비고
                    smcomb=Rs(14)   '결합제외여부
                    smmidx=Rs(15)   '작성자키
                    fmname=Rs(16)   '작성자명
                    smwdate=Rs(17)   '작성일
                    smemidx=Rs(18)   '수정자키
                    smname=Rs(19)   '수정자명
                    smewdate=Rs(20)   '수정일

                    %>
                        <tr>
                            <td><input type="checkbox" name=""></td>
                            <td><%=smidx%></td>
                            <td><%=smtype_Text%></td>
                            <td><%=smproc_Text%></td>
                            <td><a onclick="window.open('pop_mat.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>&rbuidx=<%=rbuidx%>&smidx=<%=smidx%>','_blank','width=1000, height=600, top=200, left=500' );"><%=buname%></a></td>
                            <td><%=smal%></td>
                            <td><%=smalqu%></td>
                            <td><%=smst%></td>
                            <td><%=smstqu%></td>
                            <td><%=smglass%></td>
                            <td><%=smgrid%></td> 
                            <td><%=tagongfok%></td>
                            <td><%=tagonghigh%></td>       
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