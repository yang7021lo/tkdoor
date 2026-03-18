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
Set Rs = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")




smidx=Request("smidx")

'Response.write "rgoidx;"&rgoidx&"<br>"
'Response.write "rsidx;"&rsidx&"<br>"
'Response.write "rbuidx;"&rbuidx&"<br>"
'Response.write "smidx;"&smidx&"<br>"
'Response.write "baridx;"&baridx&"<br>"
'Response.write "barNAME;"&barNAME&"<br>"
'Response.write "goname;"&goname&"<br>"
'response.end    

SQL=" select A.smidx, A.buidx, B.buname, A.smtype, A.smproc, A.smal, A.smalqu, A.smst, A.smstqu, A.smglass, A.smgrid, A.tagongfok, A.tagonghigh, A.smnote, A.smcomb "
SQL=SQL&" , A.smmidx, C.mname, Convert(varchar(16),A.smwdate,121), A.smemidx, D.mname, Convert(varchar(16),A.smewdate,121), E.baridx, F.goidx, F.goname,  G.barNAME"
SQL=SQL&" From tk_material A "
SQL=SQL&" Join tk_busok B  On A.buidx=B.buidx "
SQL=SQL&" Join tk_member C On A.smmidx=C.midx "
SQL=SQL&" Join tk_member D On A.smemidx=D.midx "
SQL=SQL&" Join tk_stand E On A.sidx=E.sidx "
SQL=SQL&" Join tk_goods F On E.goidx=F.goidx "
SQL=SQL&" Join tk_barlist G On E.baridx=G.baridx "
SQL=SQL&" Where A.smidx='"&smidx&"' "
'Response.write (SQL)&"<br>"
'response.end
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then

smidx=Rs(0) '기본키
buidx=Rs(1) 'tk_busok TB 키
buname=Rs(2)    '품명
smtype=Rs(3)    '구분
smproc=Rs(4)    '공정
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
baridx=Rs(21)   '바리스트
rgoidx=Rs(22)   '사용규격 이름
goname=Rs(23)   '사용규격 이름
barNAME=Rs(24)   '바리스트

'Response.write (smidx)
'Response.write (buidx)
'Response.write (buname)
'Response.write (smtype)

End If
rs.Close
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
        function validateForm(){
                document.frmMain.submit();
        }
    </script>    
</head>
<body>

<!--화면시작-->

    <div class="py-1 container ">
<!-- 제목 나오는 부분 시작--> <!-- 버튼 형식 시작-->
        <div class="input-group mb-3">
            <h3><%=buname%></h3> <button type="button" class="btn btn-outline-primary" onclick="validateForm();">저장</button>
        </div>
<!-- 제목 나오는 부분 끝-->

<!-- input 형식 시작--> 

<form name="frmMain" action="pop_matudtdb.asp" method="post">
<input type="hidden" name="smidx" value="<%=smidx%>">
<input type="hidden" name="rgoidx" value="<%=rgoidx%>">
<input type="hidden" name="rsidx" value="<%=rsidx%>">
        <div class="input-group mb-3">
            <span class="input-group-text">품명</span>
            <input type="text" class="form-control" name="goname" value="<%=goname%>">
            <span class="input-group-text">사용규격</span>
            <input type="text" class="form-control" name="barNAME" value="<%=barNAME%>">
        </div>  
        <div class="input-group mb-3">  
            <span class="input-group-text">구분</span>
            <select class="form-select" name="smtype">
                <option value="1" <% if smtype="1" or smtype="" then  %>selected<% end if %>>W</option>
                <option value="2" <% if smtype="2" then  %>selected<% end if %>>H</option>
                <option value="3" <% if smtype="3" then  %>selected<% end if %>>W1</option>
                <option value="4" <% if smtype="4" then  %>selected<% end if %>>H1</option>
            </select>
            <span class="input-group-text">공정</span>
            <select class="form-select" name="smproc">
                <option value="1" <% if smproc="1" or smproc="" then  %>selected<% end if %>>H바</option>
                <option value="2" <% if smproc="2" then  %>selected<% end if %>>다대</option>
                <option value="3" <% if smproc="3" then  %>selected<% end if %>>출몰바</option>
            </select>
            <span class="input-group-text">AL</span>
            <input type="NUMBER" class="form-control" name="smal" value="<%=smal%>">
            <span class="input-group-text">수량(AL)</span>
            <input type="NUMBER" class="form-control" name="smalqu" value="<%=smalqu%>">
        </div>
        <div class="input-group mb-3">
            <span class="input-group-text">ST</span>
            <input type="NUMBER" class="form-control" name="smst" value="<%=smst%>">
            <span class="input-group-text">수량(ST)</span>
            <input type="NUMBER" class="form-control" name="smstqu" value="<%=smstqu%>">
            <span class="input-group-text">유리</span>
            <input type="NUMBER" class="form-control" name="smglass" value="<%=smglass%>">
            <span class="input-group-text">격자</span>
            <input type="NUMBER" class="form-control" name="smgrid" value="<%=smgrid%>">
        </div>
        <div class="input-group mb-3">
            <span class="input-group-text">손잡이폭</span>
            <input type="text" class="form-control" name="tagongfok" value="<%=tagongfok%>">
            <span class="input-group-text">손잡이높이</span>
            <input type="text" class="form-control" name="tagonghigh" value="<%=tagonghigh%>">
        </div>
        <div class="input-group mb-3">    
            <span class="input-group-text">비고</span>
            <input type="text" class="form-control" name="smnote" value="<%=smnote%>">
            <span class="input-group-text">결합제외여부</span>
            <input type="text" class="form-control" name="smcomb" value="<%=smcomb%>">
        </div>
        <div class="input-group mb-3">
            <span class="input-group-text">작성자&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control"  value="<%=fmname%>"> 
            <input type="hidden" class="form-control" name="smmidx" value="<%=smmidx%>">
            <span class="input-group-text">작성일&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="smwdate" value="<%=smwdate%>">
        </div>    
        <div class="input-group mb-3">
            <span class="input-group-text">수정자&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control"  value="<%=smname%>"> 
            <input type="hidden" class="form-control" name="smemidx" value="<%=smemidx%>">
            <span class="input-group-text">수정일&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="smewdate" value="<%=smewdate%>">
   
        </div>
       
<!-- input 형식 끝--> 


  

</form> 
 
    </div>    

    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>

<%
set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>
