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
%>
<%
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

listgubun="two"
projectname="단가관리" 
part=Request("part")
rupmidx=Request("upmidx")
rsjb_idx=Request("sjb_idx")


if rupmidx="" then rupmidx="0" end if

rsjb_type_no=Request("sjb_type_no") '수신받은 타입/unitprice_popA.asp 가 닫히면서 보내 준다.




if part="sdate" then '날짜 생성
  rsdate=Request("sdate")
  rfdate=Request("fdate")

  SQL="Insert into unitprice (sdate, fdate, midx, wdate, meidx, wedate) "
  SQL=SQL&" values ('"&rsdate&"','"&rfdate&"','"&C_midx&"',getdate(),'"&C_midx&"',getdate()) "
  'Response.write (SQL)&"/"&i&"<br>"
  dbcon.Execute (SQL)
  

  SQL="update tng_sjb set upstatus=0 , unitpriceCnt=0"
  'Response.write (SQL)&"/"&i&"<br>"
  dbcon.Execute (SQL)


  SQL="update tng_whichitype set upstatus=0 "
  'Response.write (SQL)&"/"&i&"<br>"
  dbcon.Execute (SQL)

  SQL="update tk_qtyco set upstatus=0"
  'Response.write (SQL)&"/"&i&"<br>"
  dbcon.Execute (SQL)

  SQL="Select max(upmidx) From unitprice "
  Rs.Open SQL,dbcon
  if not (Rs.EOF or Rs.BOF ) then
    upmidx=Rs(0)
    Response.write "<script>alert('단가 적용 기간이 생성되었습니다.');location.replace('unitprice3.asp?upmidx="&upmidx&"');</script>"
    response.end
  end if
  Rs.Close  

end if

if part="fmake" then '단가레코드 생성
  SQL="Select sjb_idx, sjb_type_no, sjb_fa From tng_sjb where upstatus=0"
  'Response.write (SQL)&"<br>"
  Rs.Open SQL,dbcon
  if not (Rs.EOF or Rs.BOF ) then
    sjb_idx=Rs(0)
    sjb_type_no=Rs(1)
    sjb_fa=Rs(2)  '1: 수동 whichi_fix 2:자동 whichi_auto

   Response.write "<script>window.open('unitprice_popF1.asp?upmidx="&rupmidx&"&sjb_idx="&sjb_idx&"&sjb_type_no="&sjb_type_no&"&sjb_fa="&sjb_fa&"','"&sjb_idx&"','top=0, left=0, width=800, height=800');</script>"
    
  else
   
    Response.write "<script>alert('단가 레코드 생성이 완료 되었습니다.');location.replace('unitprice3.asp?upmidx="&rupmidx&"');</script>"
  end if
  Rs.Close
end if


if part="delunitprice" then   '단가레코드 삭제 및 초기화

  SQL="Delete From tng_unitprice_f Where upmidx='"&rupmidx&"' "
  Response.write (SQL)&"<br>"
  dbcon.Execute (SQL)

  SQL="UPdate tng_sjb set upstatus=0, unitpriceCnt = 0 "
  Response.write (SQL)&"<br>"
  dbcon.Execute (SQL)
  Response.write "<script>location.replace('unitprice3.asp?upmidx="&rupmidx&"');</script>"
end if


if part="smake" then '단가 적용
   Response.write "<script>window.open('unitprice_popF2.asp?upmidx="&rupmidx&"','"&rupmidx&"','top=0, left=0, width=800, height=800');</script>"
end if
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
  <style>
    .card-custom {
      width: 200px;
    }
  </style>
  <style>
  .pastel-mint {
    background-color: #d1f2eb; /* 고급스러운 민트톤 */
  }
  .pastel-rose {
    background-color: #fce4ec; /* 연한 로즈핑크 */
  }
  .pastel-lavender {
    background-color: #ede7f6; /* 라벤더 느낌 */
  }
  .pastel-lemon {
    background-color: #fff9c4; /* 연한 레몬 */
  }
</style>
<script>
  function fdateinput(){
    if(document.frmMain.sdate.value==""){
        alert("시작일을 입력해 주세요.");
        return
    }
    if(document.frmMain.fdate.value==""){
        alert("종료일을 입력해 주세요.");
        return
    }
    else{
        document.frmMain.submit();
    }
  }
  function fmake(rupmidx){
    if (confirm("단가 레코드를 생성 하시겠습니까?"))
    {
        location.href="unitprice3.asp?part=fmake&upmidx="+rupmidx;
    }
  }
  function smake(rupmidx){
    if (confirm("단가 적용을 시작 하시겠습니까?"))
    {
        location.href="unitprice3.asp?part=smake&upmidx="+rupmidx;
    }
  }
  
  function delunitprice(rupmidx){
    if (confirm("단가 레코드를 삭제 하시겠습니까?"))
    {
        location.href="unitprice3.asp?part=delunitprice&upmidx="+rupmidx;
    }
  }
  
</script>
</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div id="layoutSidenav_content">            
<main>
<div class="container-fluid px-4 mt-2">
  <div class="row justify-content-between">
    <div class="py-5 container text-center  card card-body">
      <div class="row">
      <div class="col">

        <!-- 검색 및 버튼 영역 -->
<form name="frmMain" action="unitprice3.asp?part=sdate" method="post">
        <div class="d-flex justify-content-end mb-3">
<%
SQL=" Select upmidx, sdate, fdate From unitprice "
Rs.open Sql,Dbcon
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
  upmidx=Rs(0)
  sdate=Rs(1)
  fdate=Rs(2)

  if Cint(upmidx)=Cint(rupmidx) then 
    class_text="btn btn-success"
  else
    class_text="btn btn-outline-success"
  end if
%>    
<button type="button" class="<%=class_text%>" style="width: 250;" onclick="location.replace('unitprice3.asp?upmidx=<%=upmidx%>');"><%=sdate%></button>&nbsp;
<%        
Rs.movenext
Loop
End If
Rs.Close
%>
<% if rupmidx="0" then %>
          <div class="input-group me-2" style="width: 600px;">
            <span class="input-group-text">시작일</span>
            <input type="date" name="sdate" class="form-control">
            <span class="input-group-text">종료일</span>
            <input type="date" name="fdate" class="form-control">
            <button class="btn btn-secondary" type="button" onclick="fdateinput();">등록</button>
          </div>
<% else %>

          <button class="btn btn-primary" type="button" onclick="fmake('<%=upmidx%>');">단가생성</button>&nbsp;
          <button class="btn btn-danger" type="button" onclick="delunitprice('<%=upmidx%>');">단가삭제</button>&nbsp;
          <button class="btn btn-primary" type="button"  onclick="smake('<%=upmidx%>');">단가적용</button>
<% end if %>
        </div>
</form> 
      </div>
      <div class="row">
  <!-- 테이블 -->
  <table class="table table-bordered table-hover">
    <tbody>
<%
SQL=" Select sjbtidx, sjb_type_no, sjb_type_name From tng_sjbtype "
SQL=SQL&" Where sjb_type_no<>'14' "
if rsjb_type_no<>"" then 
SQL=SQL&" and sjb_type_no='"&rsjb_type_no&"' "
end if 
Rs.open Sql,Dbcon
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
  sjbtidx=Rs(0)
  sjb_type_no=Rs(1)
  sjb_type_name=Rs(2)

 
%>      
<a name="<%=sjb_type_no%>">
      <tr>
        <th scope="row" width="150"><%=sjb_type_name%>/<%=sjb_type_no%></th>
        <td scope="col">
  <div class="d-flex  mb-2">
<%
  SQL=" Select sjb_idx, sjb_barlist,unitpriceCnt from tng_sjb where sjb_type_no='"&sjb_type_no&"' "
  'response.write (SQL)&"<br>"
  Rs1.open Sql,Dbcon
  if not (Rs1.EOF or Rs1.BOF ) then
  Do while not Rs1.EOF
    sjb_idx=Rs1(0)
    sjb_barlist=Rs1(1)
    unitpriceCnt=Rs1(2)
    i = i + 1
    k = i mod 6
    


    if Cint(sjb_idx)=Cint(rsjb_idx) then 
      bgcolor="bg-warning"
    end if
%>

    <div class="card card-custom me-2">
      <div class="card-header <%=bgcolor%>"><%=sjb_barlist%></div>
      <div class="card-body p-2 text-center <% if unitpriceA_cnt=0 then %><% else %>pastel-mint<% end if %>">
    
      <button class="btn btn-success" type="button" <% if tng_unitprice_cnt<>"0" then %>onclick="reset2('<%=sjb_idx%>','<%=rupmidx%>');"<% else %> onclick="smake('<%=sjb_idx%>','<%=upmidx%>');" <% end if %>><%=unitpriceCnt%></button>
      </div>
    </div>
 <% if k=0 then %> </div><div class="d-flex  mb-2"><% end if %>


<%     
  bgcolor=""   

  Rs1.movenext
  Loop
  End If
  Rs1.Close
%>
  </div>
        </td>
 


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
    <div>
  </div>
</div>    
        
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
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