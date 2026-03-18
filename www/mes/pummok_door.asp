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
      body {
            zoom: 0.8;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <script>

    function toggleAllCheckboxes(source) {
        const checkboxes = document.querySelectorAll('.rowCheckbox');
        checkboxes.forEach(checkbox => checkbox.checked = source.checked);
    }
    function del(rsidx)
    {
      if (confirm("공정구성까지 삭제할까요?"))
      {
        location.href="delete_stand.asp?rgoidx=<%=rgoidx%>&rsidx="+rsidx;
      }
    }
     function del1(smidx)
    {
      if (confirm("정말 삭제할까요?"))
      {
        location.href="delete_material.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>&smidx="+smidx;
      }
    }
    del1
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
                <div class="row card mb-2" >
                    <iframe name="goods" width="100%" height="400" src="goods.asp?rgoidx=<%=rgoidx%>" border="0" ></iframe>
                </div>
                <div class="row " >
                    <div class="col-2 card">
    <!-- 표 부속자재 형식 시작--> 
                        <div class="mt-1"><h5>출몰바</h5></div>
                        <iframe name="hide" width="100%" height="300" src="busok_chulmolbar.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>" border="0"></iframe> 
                        <div class="mt-1"><h5>부자재</h5></div>
                        <iframe name="hide" width="100%" height="300" src="busok_bujajae.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>" border="0"></iframe>
                        <div class="mt-1"><h5>알루미늄보강</h5></div>
                        <iframe name="hide" width="100%" height="300" src="busok_bogang.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>" border="0"></iframe>
    <!-- 표 부속자재 형식 끝--> 
                    </div>
                    <div class="col-2 card">
    <!-- 표 부속자재 형식 시작--> 
                        <div class="mt-1"><h5>알루미늄 바</h5></div>
                        <iframe name="hide" width="100%" height="300" src="busok_AL.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>" border="0"></iframe> 
                        <div class="mt-1"><h5>스텐 바</h5></div>
                        <iframe name="hide" width="100%" height="300" src="busok_ST.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>" border="0"></iframe>
    <!-- 표 부속자재 형식 끝--> 
                    </div>
                    <div class="col-8 card" style="height: 1000px;"> <!-- 높이 조정 -->
    <!-- 표 형식 시작--> 
                        <div class="mt-1" style="display: flex; align-items: center;">
                        <h5 style="margin: 0;">공정구성</h5>
                        </div>
                         <div class="input-group mb-3" > <!-- 스크롤 추가 -->
                            <table id="datatablesSimple"  class="table table-border"  >
                                <thead>
                                    <tr>
                                        <th align="center">삭제</th>
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
                                        <th align="center">타공폭</th>
                                        <th align="center">타공높이</th>
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
                                SQL=" select A.smidx, A.buidx, B.buname, A.smtype, A.smproc, A.smal, A.smalqu, A.smst, A.smstqu, A.smglass, A.smgrid,tagongfok,tagonghigh, A.smnote, A.smcomb "
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
                                        <td>
                                        <button type="button" class="btn btn-danger" onClick="del1('<%=smidx%>');">D</button>
                                        </td>
                                        <td><%=smidx%></td>
                                        <td><%=smtype_Text%></td>
                                        <td><%=smproc_Text%></td>
                                        <td><a onclick="window.open('pop_mat.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>&rbuidx=<%=rbuidx%>&smidx=<%=smidx%>','_blank','width=500, height=400, top=200, left=500' );"><%=buname%></a></td>
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
                                        <td><%=fmname%>///</td> 
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
                <div class="row card" style="height:400;">
<!-- 표 형식 시작--> 
                    <div class="input-group mb-3">
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th align="center">사용규격</th>
                                    <th align="center" style="text-align: right;">
                                    <button type="submit" style="color: red; font-weight: bold; background: none; border: none; cursor: pointer;"
                                    onclick="del('<%=rsidx%>');">삭제</button>
                                    
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
                                    <td><a onclick="window.parent.location.replace('pummok_door.asp?rgoidx=<%=rgoidx%>&rsidx=<%=sidx%>&baridx=<%=baridx%>');"><%=barNAME%><% if cint(rsidx)=cint(sidx) then %><% end if %> </a></td>
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
                    <input type="hidden" name="smidx" value="<%=smidx%>">
                    <input type="hidden" name="rgoidx" value="<%=rgoidx%>">
                    <input type="hidden" name="rsidx" value="<%=rsidx%>">
                    <input type="hidden" name="rbuidx" value="<%=rbuidx%>">
                    <input type="hidden" name="baridx" value="<%=baridx%>">
                    <input type="hidden" name="barNAME" value="<%=barNAME%>">
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
