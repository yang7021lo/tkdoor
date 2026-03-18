
if sjbglass<>"" then 
    SQL="Insert into tk_sujubSub (sjbSubidx, sjbidx, gubunkey, busokkey, sjbSubstatus, sjbSubqty, pummokGubun, sjbSubmidx, sjbSubwdate "
    SQL=SQL&" ,sjbSubemidx, sjbSubewdate, sjaidx , sjbSubchongaek,sjbSubdanga) "
    SQL=SQL&" Values ( '"&sjbSubidx&"', '"&sjbidx&"', '1', '"&sjbglass&"', '1','"&sjbqty&"','"&sjbkukyuk&"','"&c_midx&"',getdate() "
    SQL=SQL&" ,'"&c_midx&"',getdate(),'"&sjaidx&"','"&sjbSubchongaek&"','"&glprice&"') "

    Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)
end if

if sjbsangbar<>"" then 
    SQL="Insert into tk_sujubSub (sjbSubidx, sjbidx, gubunkey, busokkey, sjbSubstatus, sjbSubqty, pummokGubun, sjbSubmidx, sjbSubwdate "
    SQL=SQL&" ,sjbSubemidx, sjbSubewdate, sjaidx , sjbSubchongaek,sjbSubdanga) "
    SQL=SQL&" Values ( '"&sjbSubidx&"', '"&sjbidx&"', '2', '"&sjbsangbar&"', '1','"&sjbqty&"','"&sjbkukyuk&"','"&c_midx&"',getdate() "
    SQL=SQL&" ,'"&c_midx&"',getdate(),'"&sjaidx&"','"&sjbSubchongaek&"','"&sjbSubdanga&"') "

    Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)
end if

if sjbpaint<>"" then 
    SQL="Insert into tk_sujubSub (sjbSubidx, sjbidx, gubunkey, busokkey, sjbSubstatus, sjbSubqty, pummokGubun, sjbSubmidx, sjbSubwdate "
    SQL=SQL&" ,sjbSubemidx, sjbSubewdate, sjaidx , sjbSubchongaek,sjbSubdanga) "
    SQL=SQL&" Values ( '"&sjbSubidx&"', '"&sjbidx&"', '3', '"&sjbpaint&"', '1','"&sjbqty&"','"&sjbkukyuk&"','"&c_midx&"',getdate() "
    SQL=SQL&" ,'"&c_midx&"',getdate(),'"&sjaidx&"','"&sjbSubchongaek&"','"&sjbSubdanga&"') "

    Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)
end if

if sjbhabar<>"" then 
    SQL="Insert into tk_sujubSub (sjbSubidx, sjbidx, gubunkey, busokkey, sjbSubstatus, sjbSubqty, pummokGubun, sjbSubmidx, sjbSubwdate "
    SQL=SQL&" ,sjbSubemidx, sjbSubewdate, sjaidx , sjbSubchongaek,sjbSubdanga) "
    SQL=SQL&" Values ( '"&sjbSubidx&"', '"&sjbidx&"', '4', '"&sjbhabar&"', '1','"&sjbqty&"','"&sjbkukyuk&"','"&c_midx&"',getdate() "
    SQL=SQL&" ,'"&c_midx&"',getdate(),'"&sjaidx&"','"&sjbSubchongaek&"','"&sjbSubdanga&"') "

    Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)
end if

if sjbhabar<>"" then 
    SQL="Insert into tk_sujubSub (sjbSubidx, sjbidx, gubunkey, busokkey, sjbSubstatus, sjbSubqty, pummokGubun, sjbSubmidx, sjbSubwdate "
    SQL=SQL&" ,sjbSubemidx, sjbSubewdate, sjaidx , sjbSubchongaek,sjbSubdanga) "
    SQL=SQL&" Values ( '"&sjbSubidx&"', '"&sjbidx&"', '5', '"&sjbglass&"', '1','"&sjbqty&"','"&sjbkukyuk&"','"&c_midx&"',getdate() "
    SQL=SQL&" ,'"&c_midx&"',getdate(),'"&sjaidx&"','"&sjbSubchongaek&"','"&sjbSubdanga&"') "

    Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)
end if
<!-- 
 SUJUINDB 1차
    rsjbidx=Request("sjbidx")
    sjbpummyoung=Request("sjbpummyoung")
    sjbkukyuk=Request("sjbkukyuk")
    sjbjaejil=Request("sjbjaejil")
    sjbqty=Request("sjbqty")
    sjbwide=Request("sjbwide")
    sjbhigh=Request("sjbhigh")
    sjbbanghyang=Request("sjbbanghyang")
    sjbwitch=Request("sjbwitch")
    sjbbigo=Request("sjbbigo")
    sjbglass=Request("sjbglass")
    sjbpaint=Request("sjbpaint")
    sjbkey1=Request("sjbkey1")
    sjbkey2=Request("sjbkey2")
    sjbkey3=Request("sjbkey3")
    sjbkey4=Request("sjbkey4")
    sjbkey5=Request("sjbkey5")
    sjbkey6=Request("sjbkey6")
    sjbkey7=Request("sjbkey7")
    sjbtagong1=Request("sjbtagong1")
    sjbtagong2=Request("sjbtagong2")
    sjbtagong3=Request("sjbtagong3")
    sjbtagong4=Request("sjbtagong4")
    sjbtagong5=Request("sjbtagong5")
    sjbtagong6=Request("sjbtagong6")
    sjbtagong7=Request("sjbtagong7")
    sjbtagong8=Request("sjbtagong8")
    sjbtagong9=Request("sjbtagong9")
    sjbtagong10 =Request("sjbtagong10")
    sjbhingeup=Request("sjbhingeup")
    sjbhingeup1=Request("sjbhingeup1")
    sjbhingeup2=Request("sjbhingeup2")
    sjbhingeup3=Request("sjbhingeup3")
    sjbhingedown=Request("sjbhingedown")
    sjbhingedown1=Request("sjbhingedown1")
    sjbhingedown2=Request("sjbhingedown2")
    sjbhingedown3=Request("sjbhingedown3")
    sjbkyukja1=Request("sjbkyukja1")
    sjbkyukja2=Request("sjbkyukja2")
    sjbkyukja3=Request("sjbkyukja3")
    sjbkyukja4=Request("sjbkyukja4")
    sjbkyukja5=Request("sjbkyukja5")
    sjbkyukja6=Request("sjbkyukja6")
    sjbkyukja7=Request("sjbkyukja7")
    sjbkyukja8=Request("sjbkyukja8")
    sjaidx =Request("sjaidx")

                  SQL="select sjbidx, sjbpummyoung, sjbkukyuk, sjbjaejil, sjbqty, sjbwide, sjbhigh, sjbbanghyang, sjbwitch, sjbbigo, sjbglass, sjbpaint, "
                  SQL=SQL&"  sjbkey1,sjbkey2,sjbkey3,sjbkey4,sjbkey5,sjbkey6,sjbkey7,sjbtagong1,sjbtagong2,sjbtagong3,sjbtagong4,sjbtagong5, "
                  SQL=SQL&"  sjbtagong6,sjbtagong7,sjbtagong8,sjbtagong9,sjbtagong10, "
                  SQL=SQL&"  sjbhingeup,sjbhingeup1,sjbhingeup2,sjbhingeup3,sjbhingedown,sjbhingedown1,sjbhingedown2,sjbhingedown3, "
                  SQL=SQL&"  sjbkyukja1,sjbkyukja2,sjbkyukja3,sjbkyukja4,sjbkyukja5,sjbkyukja6,sjbkyukja7,sjbkyukja8,sjaidx  "   
                  SQL=SQL&" from tk_sujub "
                  SQL=SQL&" where sjbidx='"&sjbidx&"' "
                  Rs.open Sql,Dbcon
                  If Not (Rs.bof or Rs.eof) Then 
                  Do until Rs.EOF
                  rsjbidx=Rs(1)
                  sjbpummyoung=Rs(2)
                  sjbkukyuk=Rs(3)
                  sjbjaejil=Rs(4)
                  sjbqty=Rs(5)
                  sjbwide=Rs(6)
                  sjbhigh=Rs(7)
                  sjbbanghyang=Rs(8)
                  sjbwitch=Rs(9)
                  sjbbigo=Rs(10)
                  sjbglass=Rs(11)
                  sjbpaint=Rs(12)
                  sjbkey1=Rs(13)
                  sjbkey2=Rs(14)
                  sjbkey3=Rs(15)
                  sjbkey4=Rs(16)
                  sjbkey5=Rs(17)
                  sjbkey6=Rs(18)
                  sjbkey7=Rs(19)
                  sjbtagong1=Rs(20)
                  sjbtagong2=Rs(21)
                  sjbtagong3=Rs(22)
                  sjbtagong4=Rs(23)
                  sjbtagong5=Rs(24)
                  sjbtagong6=Rs(25)
                  sjbtagong7=Rs(26)
                  sjbtagong8=Rs(27)
                  sjbtagong9=Rs(28)
                  sjbtagong10 =Rs(29)
                  sjbhingeup=Rs(30)
                  sjbhingeup1=Rs(31)
                  sjbhingeup2=Rs(32)
                  sjbhingeup3=Rs(33)
                  sjbhingedown=Rs(34)
                  sjbhingedown1=Rs(35)
                  sjbhingedown2=Rs(36)
                  sjbhingedown3=Rs(37)
                  sjbkyukja1=Rs(38)
                  sjbkyukja2=Rs(39)
                  sjbkyukja3=Rs(40)
                  sjbkyukja4=Rs(41)
                  sjbkyukja5=Rs(42)
                  sjbkyukja6=Rs(43)
                  sjbkyukja7=Rs(44)
                  sjbkyukja8=Rs(45)
                  sjaidx =Rs(46)
                  %> 
                  <%
                  End If
                  Rs.Close
                  %>
 SUJUINDB 2차
goidx=Request("goidx")
sjaidx=Request("sjaidx")   
rcidx=Request("cidx")
sujuinmoneyidx=Request("sujuinmoneyidx")   
sjbpummyoung=encodestr(Request("sjbpummyoung"))
sjbpummyoungPRICE=encodestr(Request("sjbpummyoungPRICE"))
sjbkukyuk=encodestr(Request("sjbkukyuk"))
sjbkukyukPRICE=encodestr(Request("sjbkukyukPRICE"))
sjbjaejil=encodestr(Request("sjbjaejil"))
sjbjaejilPRICE=encodestr(Request("sjbjaejilPRICE"))
sjbqty=encodestr(Request("sjbqty"))
sjbwide=encodestr(Request("sjbwide"))
sjbwidePRICE=encodestr(Request("sjbwidePRICE"))
sjbhigh=encodestr(Request("sjbhigh"))
sjbhighPRICE=encodestr(Request("sjbhighPRICE"))
sjbbanghyang=encodestr(Request("sjbbanghyang"))
sjbwitch=encodestr(Request("sjbwitch"))
sjbbigo=encodestr(Request("sjbbigo"))
sjbglass=encodestr(Request("sjbglass"))
sjbglassPRICE=encodestr(Request("sjbglassPRICE"))
sjbpaint=encodestr(Request("sjbpaint"))
sjbpaintPRICE=encodestr(Request("sjbpaintPRICE"))
sjbkey1=encodestr(Request("sjbkey1"))
sjbkey2=encodestr(Request("sjbkey2"))
sjbkey3=encodestr(Request("sjbkey3"))
sjbkey4=encodestr(Request("sjbkey4"))
sjbkey5=encodestr(Request("sjbkey5"))
sjbkey6=encodestr(Request("sjbkey6"))
sjbkey7=encodestr(Request("sjbkey7"))
sjbkeyPRICE=encodestr(Request("sjbkeyPRICE"))
sjbtagong1=encodestr(Request("sjbtagong1"))
sjbtagong2=encodestr(Request("sjbtagong2"))
sjbtagong3=encodestr(Request("sjbtagong3"))
sjbtagong4=encodestr(Request("sjbtagong4"))
sjbtagong5=encodestr(Request("sjbtagong5"))
sjbtagong6=encodestr(Request("sjbtagong6"))
sjbtagong7=encodestr(Request("sjbtagong7"))
sjbtagong8=encodestr(Request("sjbtagong8"))
sjbtagong9=encodestr(Request("sjbtagong9"))
sjbtagong10=encodestr(Request("sjbtagong10"))
sjbtagongPRICE=encodestr(Request("sjbtagongPRICE"))
sjbhingeup=encodestr(Request("sjbhingeup"))
sjbhingeup1=encodestr(Request("sjbhingeup1"))
sjbhingeup2=encodestr(Request("sjbhingeup2"))
sjbhingeup3=encodestr(Request("sjbhingeup3"))
sjbhingeupPRICE=encodestr(Request("sjbhingeupPRICE"))
sjbhingedown=encodestr(Request("sjbhingedown"))
sjbhingedown1=encodestr(Request("sjbhingedown1"))
sjbhingedown2=encodestr(Request("sjbhingedown2"))
sjbhingedown3=encodestr(Request("sjbhingedown3"))
sjbhingedownPRICE=encodestr(Request("sjbhingedownPRICE"))
sjbkyukja1=encodestr(Request("sjbkyukja1"))
sjbkyukja2=encodestr(Request("sjbkyukja2"))
sjbkyukja3=encodestr(Request("sjbkyukja3"))
sjbkyukja4=encodestr(Request("sjbkyukja4"))
sjbkyukja5=encodestr(Request("sjbkyukja5"))
sjbkyukja6=encodestr(Request("sjbkyukja6"))
sjbkyukja7=encodestr(Request("sjbkyukja7"))
sjbkyukja8=encodestr(Request("sjbkyukja8"))
sjbkyukjaPRICE1=encodestr(Request("sjbkyukjaPRICE1))
sjbkyukjaPRICE2=encodestr(Request("sjbkyukjaPRICE2"))
sjbkyukjaPRICE3=encodestr(Request("sjbkyukjaPRICE3"))
sjbkyukjaPRICE4=encodestr(Request("sjbkyukjaPRICE4"))
sjbkyukjaPRICE5=encodestr(Request("sjbkyukjaPRICE5"))

'Response.write "rcidx:"&rcidx&"<br>"
'Response.write "sjbpummyoung:"&sjbpummyoung&"<br>"
'Response.write "sjbkukyuk:"&sjbkukyuk&"<br>"
'Response.write "sjbjaejil:"&sjbjaejil&"<br>"
'Response.write "sjbqty:"&sjbqty&"<br>"
'Response.write "sjbwide:"&sjbwide&"<br>"
'Response.write "sjbhigh:"&sjbhigh&"<br>"

SQL="Insert into tk_sujub (sjbidx, sjbpummyoung,sjbpummyoungPRICE, sjbkukyuk,sjbkukyukPRICE, sjbjaejil,sjbjaejilPRICE "
SQL=SQL&"  ,sjbqty, sjbwide,sjbwidePRICE, sjbhigh,sjbhighPRICE, sjbbanghyang, sjbwitch, sjbbigo "
SQL=SQL&"  ,sjbglass,sjbglassPRICE, sjbpaint,sjbpaintPRICE "
SQL=SQL&"  ,sjbkey1,sjbkey2,sjbkey3,sjbkey4,sjbkey5,sjbkey6,sjbkey7.sjbkeyPRICE "
SQL=SQL&"  ,sjbtagong1,sjbtagong2,sjbtagong3,sjbtagong4,sjbtagong5 "
SQL=SQL&"  ,sjbtagong6,sjbtagong7,sjbtagong8,sjbtagong9,sjbtagong10,sjbtagongPRICE "
SQL=SQL&"  ,sjbhingeup,sjbhingeup1,sjbhingeup2,sjbhingeup3,sjbhingeupPRICE "
SQL=SQL&"  ,sjbhingedown,sjbhingedown1,sjbhingedown2,sjbhingedown3,sjbhingedownPRICE "
SQL=SQL&"  ,sjbkyukja1,sjbkyukja2,sjbkyukja3,sjbkyukja4,sjbkyukja5,sjbkyukja6,sjbkyukja7,sjbkyukja8 "
SQL=SQL&"  ,sjbkyukjaPRICE1,sjbkyukjaPRICE2,sjbkyukjaPRICE3,sjbkyukjaPRICE4,sjbkyukjaPRICE5,sjaidx,goidx,sujuinmoneyidx ) "

SQL=SQL&" Values ( '"&sjbidx&"','"&sjbpummyoung&"','"&sjbpummyoungPRICE&"', '"&sjbkukyuk&"','"&sjbkukyukPRICE&"', '"&sjbjaejil&"','"&sjbjaejilPRICE&"' "
SQL=SQL&" ,'"&sjbqty&"','"&sjbwide&"','"&sjbwidePRICE&"','"&sjbhigh&"','"&sjbhighPRICE&"','"&sjbbanghyang&"','"&sjbwitch&"','"&sjbbigo&"' "
SQL=SQL&" ,'"&sjbglass&"','"&sjbglassPRICE&"','"&sjbpaint&"','"&sjbpaintPRICE&"' "
SQL=SQL&" ,'"&sjbkey1&"','"&sjbkey2&"','"&sjbkey3&"','"&sjbkey4&"','"&sjbkey5&"','"&sjbkey6&"', '"&sjbkey7&"', '"&sjbkeyPRICE&"' "
SQL=SQL&" ,'"&sjbtagong1&"','"&sjbtagong2&"','"&sjbtagong3&"','"&sjbtagong4&"','"&sjbtagong5&"' "
SQL=SQL&" ,'"&sjbtagong6&"', '"&sjbtagong7&"','"&sjbtagong8&"','"&sjbtagong9&"','"&sjbtagong10&"','"&sjbtagongPRICE&"' "
SQL=SQL&" ,'"&sjbhingeup&"','"&sjbhingeup1&"','"&sjbhingeup2&"','"&sjbhingeup3&"','"&sjbhingeupPRICE&"' "
SQL=SQL&" ,'"&sjbhingedown&"','"&sjbhingedown1&"', '"&sjbhingedown2&"','"&sjbhingedown3&"','"&sjbhingedownPRICE&"' "
SQL=SQL&" ,'"&sjbkyukja1&"','"&sjbkyukja2&"','"&sjbkyukja3&"','"&sjbkyukja4&"','"&sjbkyukja5&"','"&sjbkyukja6&"', '"&sjbkyukja7&"','"&sjbkyukja8&"' "
SQL=SQL&" ,'"&sjbkyukjaPRICE1&"','"&sjbkyukjaPRICE2&"','"&sjbkyukjaPRICE3&"','"&sjbkyukjaPRICE4&"','"&sjbkyukjaPRICE5&"','"&sjaidx&"','"&goidx&"','"&sujuinmoneyidx&"'  ) "
Dbcon.Execute (SQL)                  
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
<!--#include virtual="/inc/left1.asp"-->


<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between">
<!-- 내용 입력 시작 -->  
            <div class="col-11">
                <div class="row card mb-2" style="height:400px;">
                    <iframe name="goods" width="100%" height="100%" src="goods.asp?rgoidx=<%=rgoidx%>" border="0" scrolling="none"></iframe>
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
%>              
                                <tr>
                                    <td><a onclick="window.parent.location.replace('TESTmes2.asp?rgoidx=<%=rgoidx%>&rsidx=<%=sidx%>');"><%=barNAME%></a></td>
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
