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
  projectname="품목구성"

  rsjb_idx=request("sjb_idx")
  rsjb_type_no=Request("sjb_type_no")
  rsjbsub_Idx=Request("sjbsub_Idx")
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
 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="tng1b.asp?listgubun="&listgubun&"&"


SQL=" Select sjb_type_name, SJB_barlist "
SQL=SQL&" From TNG_SJB "
SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
  sjb_type_name=Rs(0)
  sjb_barlist=Rs(1)
End If
Rs.Close
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
    .box {
      border: 0px solid #ccc;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #ffffff;
    }

    .row-border {
      border-bottom: 1px solid #999;
      margin-bottom: 5px;
      padding-bottom: 5px;
    }

  .card-title-bg {
    background-color: #f1f1f1;
    padding: 10px;
    margin: -1rem -1rem 0 -1rem; /* 카드 내부 여백을 덮기 위해 마이너스 마진 */
    border-bottom: 1px solid #ddd;
  }
      .btn-spacing > .btn {
      margin-right: 1px;
    }

    /* 마지막 버튼 오른쪽 여백 제거 */
    .btn-spacing > .btn:last-child {
      margin-right: 0;
    }
  </style>
    <script>
        function validateform() {
            if(document.frmMain.SJBsub_TYPE_NAME2.value == "" ) {
                alert("품목의 이름을 입력하세요.");
            return
            }
            else {
                document.frmMain.submit();
            }
        }
        function pummoksub(){
            if(document.frmMainsub.sjbsub_Idx.value == "" ) {
                alert("품목의 이름을 입력하세요.");
            return
            }
            else {
                document.frmMainsub.submit();
            }
        }
      
    </script>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  


<div class="container-fluid">
  <div class="row">
    <!-- 왼쪽 패널: 절곡 이름 등록 및 리스트 -->
    <div class="col-md-3 border-end mb-2">
<form id="Search" name="Search" action="tng1_greemlist3.asp" method="POST">  
      <div class="input-group mb-2">
        <input type="text" class="form-control" name="SearchWord" id="SearchWord" placeholder="예: 케빈"  value="<%=Request("SearchWord")%>">
        <button type="submit" class="btn btn-outline-primary w-25"  >검색</button>
      </div>
</form>
<% if rsjb_idx<>"" then %>
      <div class="input-group mb-2">
        <span for="bendName" class="input-group-text">품목</span> 
        <input type="text" class="form-control" value="<%=sjb_type_name%>&nbsp;<%=SJB_barlist%>">
      </div>
<% else %>
      <div class="card">
        <div class="card-header">
          <h5 >품목</h5>
        </div>    
        <div class="card-body">
          <div class="row row-border">
            <div class="col-md-4 box">번호</div>
            <div class="col-md-4 box">품명</div>
            <div class="col-md-4 box">규격</div>
          </div>
<% 
SQL=" Select sjb_idx, sjb_type_name, SJB_barlist,sjb_type_no "
SQL=SQL&" From TNG_SJB "
SQL=SQL&" Where sjb_type_name  like '%" & Request("SearchWord") & "%' or SJB_barlist  like '%" & Request("SearchWord") & "%' "
'response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 15

if not (Rs.EOF or Rs.BOF ) then
no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
totalpage=Rs.PageCount '		
Rs.AbsolutePage=gotopage
i=1
for j=1 to Rs.RecordCount 
if i>Rs.PageSize then exit for end if
if no-j=0 then exit for end if

  sjb_idx=Rs(0)
  sjb_type_name=Rs(1)
  SJB_barlist=Rs(2)
  sjb_type_no=Rs(3)

%>
          <div class="row row-border">
            <div class="col-md-2 box"><%=no-j%></div>
            <div class="col-md-7 box"><a href="tng1_greemlist3.asp?sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&SearchWord=<%=Request("SearchWord")%>"><%=sjb_type_name%></a></div>
            <div class="col-md-3 box"><%=SJB_barlist%></div>
          </div>
<% 
Rs.MoveNext 
i=i+1

Next 
'
%>

<%
End If  
Rs.close
  
%>
        </div>
      </div>
<%
end if
%>      
    </div>


  <!-- 오른쪽 패널: 자재 (카드 안으로 감쌈) -->
  <div class="col-md-9">
    <div class="card">
      <div class="card-header">
<form name="frmMain" action="tng1_greemlist3subdb.asp" method="POST">  
  <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
  <input type="hidden" name="sjbsub_Idx" value="<%=rsjbsub_Idx%>">
  
  <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
  <input type="hidden" name="gotopage" value="<%=gotopage%>">
  <input type="hidden" name="SearchWord" value="<%=Request("SearchWord")%>">
        <div class="input-group mb-2">
  <div class="btn-spacing">
<%
SQL=" Select sjbsub_Idx, sjbsub_type_no, sjbsub_type_name2 "
SQL=SQL&" From TNG_SJBsub "
SQL=SQL&" Where sjb_idx='"&rsjb_Idx&"' "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
  Do while not Rs.EOF
    sjbsub_Idx=Rs(0)
    sjbsub_type_no=Rs(1)
    sjbsub_type_name2=Rs(2)

  rsjbsub_Idx=Request("sjbsub_Idx")
    if Cint(sjbsub_Idx)=Cint(rsjbsub_Idx) then 
      class_name="btn btn-success w-10"
    else
      class_name="btn btn-outline-success w-10"
    end if
%>
<button type="button" class="<%=class_name%>" onclick="location.replace('TNG1_GREEMLIST3.asp?sjb_idx=<%=rsjb_idx%>&sjbsub_idx=<%=sjbsub_idx%>&sjb_type_no=<%=rsjb_type_no%>&gotopage=<%=gotopage%>&SearchWord=<%=Request("SearchWord")%>');" ><%=sjbsub_type_name2%></button>
<%
  Rs.movenext
  Loop
  End if
  Rs.close
%> 
</div>
          <input type="text" class="form-control  w-25" name="SJBsub_TYPE_NAME2" id="SJBsub_TYPE_NAME2" placeholder="품목구성의 이름"  value="<%%>">
          <button type="button" class="btn btn-primary w-10" onclick="validateform();">등록</button>
        </div>
</form>

      </div>
<form name="frmMainsub" action="tng1_greemlist3db.asp" method="POST">  
  <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
  <input type="hidden" name="sjbsub_Idx" value="<%=rsjbsub_Idx%>">
      <div class="card-body">
        <div class="container mt-4">
          <div class="row mb-4">

      <%
      SQL=" Select bfidx, set_name_fix, set_name_auto, whichi_fix, whichi_auto , bfimg1, bfimg2, bfimg3 "
      SQL=SQL&" From tk_barasiF "
      SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
      'response.write (SQL)
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
        Do while not Rs.EOF
          bfidx=Rs(0)
          set_name_fix=Rs(1)
          set_name_auto=Rs(2)
          whichi_fix=Rs(3)
          whichi_auto=Rs(4)
          bfimg1=Rs(5)
          bfimg2=Rs(6)
          bfimg3=Rs(7)

          if whichi_auto<>"0" then 
            set_name=set_name_auto
          elseif  whichi_fix<>"0" then 
            set_name=whichi_fix
          end if
      %>
            <div class="col-md-3 mt-2">
              <div class="card">
              <% if bfimg3<>"" then %>
                <img src="/img/frame/bfimg/<%=bfimg3%>" height="200" class="card-img-top" alt="...">
              <% elseif bfimg1<>"" then %>
                <img src="/img/frame/bfimg/<%=bfimg1%>" height="200" class="card-img-top" alt="...">
              <% else %>
                <!-- *SVG 코드 시작 -->
                <svg id="mySVG" viewbox="0 0 200 180ㄴ"  fill="none" stroke="#000000" stroke-width="1" >
                <%
                SQL="select baidx from tk_barasi A where bfidx='"&bfidx&"' "
                Rs1.open Sql,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then 
                    rbaidx=Rs1(0)
                End If
                Rs1.close


                SQL="Select basidx, bassize, basdirection, x1, y1, x2, y2, accsize,idv from tk_barasisub where baidx='"&rbaidx&"' order by basidx asc "
                'response.write (SQL)&"<br>"
                Rs1.open Sql,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then 
                Do while not Rs1.EOF
                  basidx=Rs1(0)
                  bassize=Rs1(1)
                  basdirection=Rs1(2)
                  x1=Rs1(3)
                  y1=Rs1(4)
                  x2=Rs1(5)
                  y2=Rs1(6)
                  accsiz=Rs1(7)
                  idv=Rs1(8)

                  textv=bassize+idv

                  'response.write  bassize&"/"&basdirection&"<br>"
                  if bassize>30 then 
                      bojngv=-10
                  end if  

                  if basdirection="1" then 
                      tx1=x1+(bassize/2)
                      ty1=y1-1
                  elseif basdirection="2" then 
                      tx1=x1-5
                      ty1=y1+(bassize/2)+bojngv+10
                  elseif basdirection="3" then 
                      tx1=x1-(bassize/2)
                      ty1=y1+5
                  elseif basdirection="4" then 
                      tx1=x1+5
                      ty1=y1-(bassize/2)+bojngv+10
                  end if
                %>
                <line x1="<%=x1%>" y1="<%=y1%>" x2="<%=x2%>" y2="<%=y2%>" />
                <%
                  if bassize=int(bassize) then
                  bassize_int=FormatNumber(bassize,0)
                  else 
                  bassize_int=FormatNumber(bassize,1)
                  end if
                %>
                <text x="<%=tx1%>" y="<%=ty1%>" fill="#000000" font-size="12" text-anchor="middle"><%=bassize_int%></text>   
                <%
                  Rs1.movenext
                  Loop
                  End if
                  Rs1.close
                %> 
                </svg>
      
              <% end if %>
                <div class="card-body">
                  <div class="card-title-bg">

                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" value="<%=bfidx%>" id="bfidx" name="bfidx">
                      <label class="form-check-label" for="checkbox1">
                        <%=set_name%>
                      </label>
                    </div>

                  </div>
                </div>
              </div>
            </div>
      <%
        Rs.movenext
        Loop
        End if
        Rs.close
      %> 

          </div>
        </div>

</form>
     

      </div>
 
    </div>
<!-- 절곡값 통합 시작-->
    <div class="mt-2 text-end">
    <button type="button" class="btn btn-primary w-10" onclick="pummoksub();">등록</button>
    </div>
<!-- 절곡값 통합 끝-->

  </div>

</div>
<!-- 내용 입력 끝 -->  
        </div>
    </div>
</main>                          
                <!-- footer 시작 -->    
                Coded By 양양
                <!-- footer 끝 --> 
</div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="/js/scripts.js"></script>

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
