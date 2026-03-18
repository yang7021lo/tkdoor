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
rksearchWord=Request("ksearchWord")
rsearchword=Request("SearchWord")
kgotopage=Request("kgotopage") 
kkgotopage=Request("kkgotopage") 
gotopage=Request("gotopage") 
projectname="절곡바라시"
rSJB_IDX=Request("SJB_IDX") 
rbaidx=Request("baidx")
rbasidx=Request("basidx")
rpart=Request("part")

rbfidx=Request("bfidx")
mode=Request("mode")

SQL = "SELECT set_name_FIX,set_name_AUTO "
SQL = SQL & " FROM tk_barasiF  "
If rSJB_IDX <> "" Then
SQL = SQL & " WHERE bfidx = '" & rbfidx & "' "
end if
'Response.write (SQL)&"<br>"
'response.end
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then

  set_name_FIX  = Rs(0)
  set_name_AUTO = Rs(1)

end if
Rs.close

sql="select baname , bastatus, xsize, ysize, sx1, sx2, sy1, sy2, bachannel, g_bogang, g_busok from tk_barasi where baidx='"&rbaidx&"' "
'response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then  

    baname=Rs(0)
    bastatus=Rs(1)
    xsize=Rs(2)
    ysize=Rs(3)
    sx1=Rs(4)
    sx2=Rs(5)
    sy1=Rs(6)
    sy2=Rs(7)
    bachannel=Rs(8)
    g_bogang=Rs(9)
    g_busok=Rs(10)
  if xsize="0" then xsize="1" end if

  ratev=FormatNumber(300/xsize,0)
  'response.write ratev&"/<br>"
end if
Rs.close



if request("kkgotopage")="" then
kkgotopage=1
else
kkgotopage=request("kkgotopage")
end if

	page_name = "tng1_julgok_in_sub3.asp?gotopage=" & gotopage & "&kgotopage=" & kgotopage & "&kkgotopage=" & kkgotopage & "&rbfidx=" & rbfidx & "&sjb_idx=" & rsjb_idx & "&ksearchword=" & rksearchword & "&SearchWord=" & Request("SearchWord") & "&mode=" & Request("mode") & "&"

if rpart="" then 
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><%=projectname%></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

    .form-check-label {
    font-weight: bold;
    color: #000;
    font-size: 20px;
    }
    input[type="radio"] {
    width: 25px;
    height: 25px;
    accent-color: #007bff; /* 진한 파란색 (Bootstrap 기본 색상) */
    cursor: pointer;
    }
input[type="radio"] {
  appearance: none; /* 기본 스타일 제거 */
  width: 18px;
  height: 18px;
  border: 2px solid #555; /* 진한 윤곽 */
  border-radius: 50%;
  outline: none;
  cursor: pointer;
  position: relative;
}

input[type="radio"]:checked::before {
  content: '';
  position: absolute;
  top: 3px;
  left: 3px;
  width: 10px;
  height: 10px;
  background-color: #007bff;
  border-radius: 50%;
}
  </style>
  
  <script>  
    function barasi(){
      if(document.frmMain.baname.value==""){
          alert("절곡이름을 입력해 주세요.");
          return
      }
      else{
          document.frmMain.submit();
      }
    }
    function barasisub(){
      if(document.frmMain2.baidx.value==""){
          alert("왼쪽에서 절곡을 선택해 주세요.");
          return
      }
      if(document.frmMain2.bassize.value==""){
          alert("치수를 입력해 주세요.");
          return
      }
      else{
          document.frmMain2.submit();
      }
    }
    function del(rbaidx)
    {
        if (confirm("절곡을 삭제 하시겠습니까?"))
        {
            location.href="tng1_julgok_in_sub3.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&kkgotopage=<%=kkgotopage%>&sjb_idx=<%=rsjb_idx%>&part=badel&bfidx=<%=rbfidx%>&baidx="+rbaidx;
        }
    }
  </script>

  <!-- iframe: tx, ty 업데이트 프로그램 실행용 -->
  <iframe id="updateFrame" 
  src="TNG1_B_baljuSTPROGRAM.asp?update_all=1"
  style="display:none;"
  ' style="width:100%; height:250px; border:1px solid #ccc; border-radius:5px;"
  >
  </iframe>

</head>
<body class="p-4">

<div class="container-fluid">
  <div class="row">
    <!-- 왼쪽 패널: 절곡 이름 등록 및 리스트 -->
    <div class="col-md-3 border-end mb-2">
    <div class="card">
      <div class="card-header">
        <h5 >절곡바라시</h5>
      </div>    
      <div class="card-body">
<form name="frmMain" action="tng1_julgok_in_sub3.asp" method="post">
<% if rbaidx<>"" then %>
    <input type="hidden" name="part" value="bupdate">
    <input type="hidden" name="baidx" value="<%=rbaidx%>">
<% else %>
    <input type="hidden" name="part" value="binsert">


<% end if %>
    <input type="hidden" name="bfidx" value="<%=rbfidx%>">
    <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
    <input type="hidden" name="kkgotopage" value="<%=kkgotopage%>">
    <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
    <input type="hidden" name="gotopage" value="<%=gotopage%>">
    <input type="hidden" name="kSearchWord" value="<%=kSearchWord%>">
    <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
        <div class="input-group mb-2">
          <span for="bendName" class="input-group-text">절곡이름</span>         
          <% 
            If set_name_FIX <> "" And baname = "" Then
                baname = set_name_FIX
            ElseIf set_name_AUTO <> "" And baname = "" Then
                baname = set_name_AUTO
            End If
          %>
          <input type="text" class="form-control" name="baname" id="baname" placeholder="예: 절곡 A"  value="<%=baname%>">
        </div>
        <div class="input-group mb-2">

          <span for="bendName" class="input-group-text">채널넘버</span>
          <%
            if bachannel= "0" then
                ybachannel = "❌"
            else
                ybachannel = bachannel 
            end if

          %>
          <input type="text" class="form-control" name="bachannel" id="bachannel" placeholder="채널넘버"  value="<%=ybachannel%>">
        </div>
        <div class="card">
        <label  class="form-label">갈바선택정보</label>
        
            <div class="input-group mb-2">
            
            <span for="bendName" class="input-group-text">보강자재</span>
            <select class="form-control" name="g_bogang" id="g_bogang">
                <option value="0" <% If g_bogang = "0" or g_bogang="" Then Response.Write "selected" %> >안함</option>
                <option value="1" style="color: red;" <% If g_bogang = "1" Then Response.Write "selected" %> >적용</option>
            </select>
            </div>


            <div class="input-group mb-2">
            <span for="bendName" class="input-group-text">부속보강자재</span>
            <select class="form-control" name="g_busok" id="g_busok">
                <option value="0" <% If g_busok = "0" or g_bogang="" Then Response.Write "selected" %> >안함</option>
                <option value="1"  style="color: red;" <% If g_busok = "1" Then Response.Write "selected" %> >적용</option>
            </select>
            </div>
        </div>
        <div class="input-group mb-2">
          <span for="bendName" class="input-group-text">절곡사용여부</span>
          <select class="form-control" name="bastatus" id="bastatus">
              <option value="0" <% If bastatus = "0" Then Response.Write "selected" %> >안함</option>
              <option value="1" <% If bastatus = "1"  or bastatus="" Then Response.Write "selected" %> >적용</option>
          </select>
        </div>

        <div class="mb-0 text-end d-flex flex-wrap gap-2 justify-content-end">
          <% if rbaidx<>"" then %>
          <button type="button" class="btn btn-outline-danger w-25"  Onclick="del('<%=rbaidx%>');">삭제</button>                             
          <button type="button" class="btn btn-outline-success w-25"  Onclick="location.replace('tng1_julgok_in_sub3.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&kkgotopage=<%=kkgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>');">신규</button>
          <button type="button" class="btn btn-outline-primary w-25"  Onclick="barasi();">저장</button>
          <button type="button" class="btn btn-outline-primary w-25"  Onclick="window.open('julgok_movexy.asp?kkgotopage=<%=kkgotopage%>&SJB_IDX=<%=rSJB_IDX%>&baidx=<%=rbaidx%>&bfidx=<%=rbfidx%>', '_blank');">출력값 <br>위치변경</button>
          <% else %>
          <button type="button" class="btn btn-outline-primary w-25"  Onclick="barasi();">등록</button>
          <% end if %>
        </div>
        <div>
        
        </div>
      </div>

    </div>


      <table class="table table-sm table-bordered mt-2">
        <thead class="table-light">
          <tr>
            <th style="width: 12%" class="text-center"><i class="fa-solid fa-hashtag"></i></th>
            <th class="text-center">
                이름
            </th>
            <th style="width: 10%" class="text-center"><i class="fa-solid fa-check-double"></i></th>
          </tr>
        </thead>
        <tbody>
          <!-- 예시 데이터 -->
<%
SQL = "SELECT baidx, baname, bastatus, g_bogang, g_busok FROM tk_barasi "
SQL=SQL&" WHERE bfidx='" & rbfidx & "'"
SQL=SQL&" Order by baidx desc"
'response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 15
if not (Rs.EOF or Rs.BOF ) then
Do until Rs.EOF

ybaidx=Rs(0)
ybaname=Rs(1)
ybastatus=Rs(2)
yg_bogang = Rs(3)
yg_busok = Rs(4)

i=i+1
if ybastatus="0" then 
  ybastatus_text="사용안함"
elseif ybastatus="1" then 
  ybastatus_text="사용"
end if

%>   
          <tr>
            <td class="text-center">
                <%=i%>
                <button type="button" class="btn btn-sm btn-warning ms-2"
                onclick="location.href='tng1_julgok_in_sub3_copy.asp?copy_baidx=<%=ybaidx%>&bfidx=<%=rbfidx%>&SJB_IDX=<%=rSJB_IDX%>'">
                <i class="fa-solid fa-copy"></i>
                </button>
            </td>
            <td class="text-start"><a href="tng1_julgok_in_sub3.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&kkgotopage=<%=kkgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=rsjb_idx%>&baidx=<%=ybaidx%>&bfidx=<%=rbfidx%>">
            <% if ybastatus="0" then response.write "<s>" end if%>
            <% If ybastatus = "0" Then Response.Write "<s>" %>
            <%=ybaname%>
            <% If yg_bogang = "1" Then %>
            <span class="border border-danger rounded px-2 py-1 d-inline-flex align-items-center text-danger fw-bold" style="white-space: nowrap;">
                <i class="fa-solid fa-hand-dots fa-2x me-1"></i>갈바보강
            </span>
            <% End If %>
            <% If yg_busok = "1" Then %>
            <span class="border border-danger rounded px-2 py-1 d-inline-flex align-items-center text-danger fw-bold" style="white-space: nowrap;">
                <i class="fa-solid fa-hand-dots fa-2x me-1"></i>부속보강:200절단
            </span>
            <% End If %>
            <% If ybastatus = "0" Then Response.Write "</s>" %>
            </a>
            </td>
            <td class="text-center"><a href="tng1_julgok_in_sub3.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&kkgotopage=<%=kkgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=rsjb_idx%>&baidx=<%=ybaidx%>&bfidx=<%=rbfidx%>"><%=ybastatus_text%></a></td>
          </tr>
<%
Rs.MoveNext 

bastatus_text=""
Loop

%> 
          <tr>
            <td class="text-center" colspan="3">

            </td>
          </tr>
<%
End If  
Rs.close
  
%>
        </tbody>
      </table>




   
      </form>
      <p class="mb-2">

    <button type="button" class="btn btn-outline-danger"  onclick="window.close();">창닫기</button>
    
    </div>


  <!-- 오른쪽 패널: 절곡 설정 (카드 안으로 감쌈) -->
  <div class="col-md-9">
    <div class="card">
      <div class="card-header">
        <h5 class="mb-0">절곡 설정</h5>
      </div>
      <div class="card-body">
<%
SQL="Select top 1 kak, basidx, basdirection, final, x2, y2  From tk_barasisub where baidx='"&rbaidx&"' order by ody desc"
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  kak=Rs(0) '뒷각 1/ 앞각2
  basidx=Rs(1)
  basdirection=Rs(2)
  final=Rs(3) '최종처리여부 1: 진행중 0: 최종, 최종일때 각을 설정한다.
  x2=Rs(4)  '최종x좌표
  y2=Rs(5)  '최종y좌표

Else
  startv="1"  '첫시작 변수 초기화
  kak="2"

End if
Rs.Close
%>

        <form class="row gy-2 align-items-center" name="frmMain2" action="tng1_julgok_in_sub3.asp?part=bisnsert" method="post">
        <input type="hidden" name="baidx" value="<%=rbaidx%>">  
        <input type="hidden" name="bfidx" value="<%=rbfidx%>">  
        <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">  
        <input type="hidden" name="kkgotopage" value="<%=kkgotopage%>">
          <div class="col-auto">
          <div class="input-group">

<!-- 첫 등록시 시작좌표 설정 시작 -->
            <input type="hidden" class="form-control" name="x2" size="4" value="200" >
            <input type="hidden" class="form-control" name="y2" size="4" value="100" >
<!-- 첫 등록시 시작좌표 설정 끝 -->


          </div>
          </div>

          <div class="col-auto">
            <!--<label class="form-label">각도</label><br>-->
              <div class=" text-start ms-0" style="width:200px;padding:10 5 5 5;">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="kak" value="2"  
                    <% If kak = "2" or kak = "" or kak = "0" Then Response.Write "checked" %>>
                    <label class="form-check-label" >앞각(-0.5 내경)</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="kak" value="1" <% if kak="1" then response.write "checked" end if %>>
                    <label class="form-check-label" >뒷각(0.5 외경)</label>
                </div>

              </div>
          </div>
          <div class="col-auto">
            <!--<label for="sizeInput" class="form-label">치수</label>-->
            <input type="number" class="form-control" id="bassize" placeholder="치수(mm)" name="bassize" value="<%=bassize%>" size="4" 
            onkeypress="if(event.keyCode==13){event.preventDefault(); barasisub();}" autofocus>
          </div>
          <div class="col-auto">
              <div class=" text-start ms-0" style="width:300px;padding:10 5 5 5;">
<% if basdirection="2" or basdirection="4" or basdirection="" then %>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="basdirection" value="1" <% if basdirection="2"   then %> checked <% end if %>>
                    <label class="form-check-label" >→</label>
                </div>
<% end if %>
<% if basdirection="1" or basdirection="3" or basdirection="" then %>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="basdirection" value="2" <% if basdirection="3" then %> checked <% end if %>>
                    <label class="form-check-label" >↓</label>
                </div>
<% end if %>
<% if basdirection="2" or basdirection="4" or basdirection="" then %>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="basdirection" value="3" <% if basdirection="4"  then %> checked <% end if %>>
                    <label class="form-check-label" >←</label>
                </div>
<% end if %>
<% if basdirection="1" or basdirection="3" or basdirection="" then %>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="basdirection" value="4" <% if basdirection="1" or basdirection="" then %> checked <% end if %>>
                    <label class="form-check-label" >↑</label>
                </div>
<% end if %>
              </div>
          </div>

          <div class="col-auto">
            <!--<label for="statusSelect" class="visually-hidden">상태</label>-->
            <select class="form-select" id="final" name="final">
              <option value="1" selected>진행중</option>
              <option value="0">종료</option>
            </select>
          </div>

          <div class="col-auto">
<%
If rbaidx<>"" or final="1" then 
%>          
            <button type="button" class="btn btn-success" onclick="barasisub();">저장</button>
<%
end if 
%>

          </div>
          <div class="col-auto">
            <label for="sizeInput" class="form-label">꺽임설정</label>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="kangle" value="1">
                    <label class="form-check-label" >오른쪽</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="kangle" value="2">
                    <label class="form-check-label" >왼쪽</label>
                </div> 
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="kangle" value="">
                    <label class="form-check-label" >취소</label>
                </div>             
          </div>
        </form>




 
      </div>
 
    </div>
<!-- 절곡값 통합 시작-->
      <div class="row mt-2">
        <div class="input-group mb-3">
          <div class="text-start">
            <div class="col">
<%
                SQL="Select count(*) from tk_barasisub where baidx='"&rbaidx&"'"
                Rs.open Sql,Dbcon
                    ccnt=Rs(0)*2  '절곡값의 갯수 중간선을 위한 colspan 갯수 정의
                Rs.Close
%>
            <table class="table" border="1">
                <tbody>
                <tr>
                    <th>출력값2</th>
                <%
                SQL="Select basidx, bassize, basdirection, accsize, idv, final from tk_barasisub where baidx='"&rbaidx&"' order by basidx asc"
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do while not Rs.EOF
                basidx=Rs(0)
                bassize=Rs(1)
                basdirection=Rs(2)
                accsize=Rs(3)
                idv=Rs(4)
                final=Rs(5)

                g=g+1
                if basdirection="1" then
                basdirection_text="→"
                elseif basdirection="2" then
                basdirection_text="↓"
                elseif basdirection="3" then
                basdirection_text="←"
                elseif basdirection="4" then
                basdirection_text="↑"
                end if

                if idv="0" then 
                    if g>"1" then 
                    btn_text="btn-primary"
                    end if
                else
                    btn_text="btn-light"
                end if 

                if final="0" then 
                    btn_text="btn-danger"
                end if
                %>
                    <td></td>
                    <td>
<button type="button" class="btn <%=btn_text%> btn-sm"><%=accsize%></button>

                    </td>
                <%
                pba=basdirection
                Rs.movenext
                Loop
                End if
                Rs.close
                %> 
                </tr>
                <tr>
                    <th>출력값1</th>
            <%
            SQL="Select basidx, bassize, basdirection,idv from tk_barasisub where baidx='"&rbaidx&"' order by basidx asc"
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then 
            Do while not Rs.EOF
            basidx=Rs(0)
            bassize=Rs(1)
            basdirection=Rs(2)
            idv=Rs(3)
            if basdirection="1" then
            basdirection_text="→"
            elseif basdirection="2" then
            basdirection_text="↓"
            elseif basdirection="3" then
            basdirection_text="←"
            elseif basdirection="4" then
            basdirection_text="↑"
            end if
            bassize=bassize+idv
            %>
                    <td>
<a href="tng1_julgok_in_sub3.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&kkgotopage=<%=kkgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&SJB_IDX=<%=rSJB_IDX%>&part=subdel&baidx=<%=rbaidx%>&basidx=<%=basidx%>&bfidx=<%=rbfidx%>" onclick="return confirm('정말로 삭제하시겠습니까?');"><%=bassize%></a>
                    </td>
                    <td></td>
            <%
            Rs.movenext
            Loop
            End if
            Rs.close
            %> 
                </tr>
                <tr>
                    <th>보정값</th>
            <%
            SQL="Select basidx, ysr2, ysr1, idv, bassize from tk_barasisub where baidx='"&rbaidx&"'  order by basidx asc"
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then 
            Do while not Rs.EOF
            basidx=Rs(0)
            ysr2=Rs(1)
            ysr1=Rs(2)
            idv=Rs(3)
            bassize=Rs(4)
            %>
                    <td>
                        <%=ysr2%><br><%=ysr1%><br><%=idv%>
                    </td>
                    <td></td>
            <%
            Rs.movenext
            Loop
            End if
            Rs.close
            %> 
                </tr>
              <tbody>
        </table>
            </div>
          </div>
        </div>
      </div>
<!-- 절곡값 통합 끝-->

                            <div class="row"><!-- *svg 시작-->
                                
                                <div class="col-6"> 
                                    <h6 class="text-center mb-2">기본 절곡 화면</h6>
                                    <div class="card card-body text-start"><!-- *SVG 코드 시작 -->
                                        <svg id="mySVG" width="600" height="400"  fill="none" stroke="#000000" stroke-width="1" style="cursor: pointer;"  >
                                            <%
                                            SQL="Select basidx, bassize, basdirection, x1, y1, x2, y2, accsize,idv from tk_barasisub where baidx='"&rbaidx&"' order by basidx asc "
                                            'response.write (SQL)&"<br>"
                                            Rs.open Sql,Dbcon
                                            If Not (Rs.bof or Rs.eof) Then 
                                            Do while not Rs.EOF
                                            basidx=Rs(0)
                                            bassize=Rs(1)
                                            basdirection=Rs(2)
                                            x1=Rs(3)
                                            y1=Rs(4)
                                            x2=Rs(5)
                                            y2=Rs(6)
                                            accsiz=Rs(7)
                                            idv=Rs(8)
                                        
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
                                            <text 
                                                x="<%=tx1%>" 
                                                y="<%=ty1%>" 
                                                fill="#000000" 
                                                font-size="8" 
                                                font-family="Roboto Thin", sans-serif" 
                                                font-weight="100" 
                                                letter-spacing="0.5px"
                                                opacity="0.8"
                                                text-anchor="middle">
                                                <%=bassize_int%>
                                            </text>   
                                            <%
                                            Rs.movenext
                                            Loop
                                            End if
                                            Rs.close
                                            %> 
                                        </svg>
                                        
                                    </div><!-- * SVG코드 끝 -->
                                </div><!-- <div class="col-6">  끝 -->
                                





  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!--[svg-pan-zoom.js](https://github.com/ariutta/svg-pan-zoom)는 SVG 요소에 드래그 이동과 마우스 휠 확대/축소 기능을 쉽게 붙일 수 있는 라이브러리입니다. -->
<script src="https://cdn.jsdelivr.net/npm/svg-pan-zoom@3.6.1/dist/svg-pan-zoom.min.js"></script>
<script>
  let currentEditor = null;
  let currentBasidx = null;

  // 고정 위치 에디터 보이기
  function showPositionEditor(textElement, event) {
    event.stopPropagation();
    
    const basidx = textElement.getAttribute('data-basidx');
    const currentTx = Math.round(parseFloat(textElement.getAttribute('data-tx')));
    const currentTy = Math.round(parseFloat(textElement.getAttribute('data-ty')));
    
    currentBasidx = basidx;
    
    // 고정 컨테이너에 에디터 생성
    const container = document.getElementById('fixedEditorContainer');
    container.innerHTML = `
      <div style="background: white; border: 2px solid #007bff; border-radius: 8px; padding: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.3); min-width: 180px;" onclick="event.stopPropagation();">
        <div style="margin-bottom: 15px; font-weight: bold; text-align: center; color: #007bff; font-size: 14px;">위치 조정</div>
        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
          <span style="min-width: 20px; font-weight: bold; color: #666;">X:</span>
          <input type="number" id="txInput" value="${currentTx}" step="1" style="width: 80px; padding: 6px; border: 1px solid #ddd; border-radius: 4px; text-align: center; font-size: 13px;" onclick="event.stopPropagation();" oninput="previewPosition()">
        </div>
        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 15px;">
          <span style="min-width: 20px; font-weight: bold; color: #666;">Y:</span>
          <input type="number" id="tyInput" value="${currentTy}" step="1" style="width: 80px; padding: 6px; border: 1px solid #ddd; border-radius: 4px; text-align: center; font-size: 13px;" onclick="event.stopPropagation();" oninput="previewPosition()">
        </div>
        <div style="text-align: center; display: flex; gap: 8px; justify-content: center;">
          <button onclick="savePosition()" style="background: #28a745; color: white; border: none; padding: 6px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">저장</button>
          <button onclick="hidePositionEditor()" style="background: #6c757d; color: white; border: none; padding: 6px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">취소</button>
        </div>
      </div>
    `;
     
    currentEditor = { container, textElement, basidx };
  }

  // 에디터 숨기기 (취소 시 원래 위치로 복원)
  function hidePositionEditor() {
    if (currentEditor) {
      // 원래 위치로 복원
      const textElement = currentEditor.textElement;
      const originalTx = textElement.getAttribute('data-tx');
      const originalTy = textElement.getAttribute('data-ty');
      
      textElement.setAttribute('x', originalTx);
      textElement.setAttribute('y', originalTy);
      
      currentEditor.container.innerHTML = '';
      currentEditor = null;
      currentBasidx = null;
    }
  }

  // 실시간 위치 프리뷰 (DB 저장 없이 화면에만 반영)
  function previewPosition() {
    if (!currentEditor) return;
    
    const txInput = document.getElementById('txInput');
    const tyInput = document.getElementById('tyInput');
    
    if (!txInput || !tyInput) return;
    
    const newTx = Math.round(parseFloat(txInput.value)) || 0;
    const newTy = Math.round(parseFloat(tyInput.value)) || 0;
    
    const textElement = currentEditor.textElement;
    
    // 화면상에만 텍스트 위치 업데이트 (임시)
    textElement.setAttribute('x', newTx);
    textElement.setAttribute('y', newTy);
  }

  // 저장 버튼 클릭 시 위치 업데이트
  function savePosition() {
    if (!currentEditor || !currentBasidx) return;
    
    const txInput = document.getElementById('txInput');
    const tyInput = document.getElementById('tyInput');
    
    if (!txInput || !tyInput) return;
    
    const newTx = Math.round(parseFloat(txInput.value)) || 0;
    const newTy = Math.round(parseFloat(tyInput.value)) || 0;
    
    const textElement = currentEditor.textElement;
    
    // 텍스트 위치 업데이트
    textElement.setAttribute('x', newTx);
    textElement.setAttribute('y', newTy);
    textElement.setAttribute('data-tx', newTx);
    textElement.setAttribute('data-ty', newTy);
    
    // 데이터베이스 업데이트 (AJAX)
    updateDatabase(currentBasidx, newTx, newTy);
    
    // 저장 후 에디터 숨기기
    hidePositionEditor();
  }

  // 데이터베이스 업데이트
  function updateDatabase(basidx, tx, ty) {
    fetch('tng1_julgok_in_sub3.asp', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: `part=update_position&basidx=${basidx}&tx=${tx}&ty=${ty}`
    })
    .then(response => response.text())
    .then(data => {
      console.log('위치 업데이트 완료:', basidx, tx, ty);
    })
    .catch(error => {
      console.error('위치 업데이트 실패:', error);
    });
  }

  // 다른 곳 클릭 시 에디터 숨기기
  document.addEventListener('click', function(event) {
    if (!event.target.closest('#fixedEditorContainer') && !event.target.closest('text[data-basidx]')) {
      hidePositionEditor();
    }
  });

  window.addEventListener('load', () => {
    // 기본 절곡 화면 (mySVG) - svg-pan-zoom 적용
    svgPanZoom('#mySVG', {
      zoomEnabled: true,
      controlIconsEnabled: true,
      fit: true,
      center: true
    });
    
    // 텍스트 최적화 화면 (mySVG2) - 발주화면과 동일한 viewBox 조정
    const svg2 = document.getElementById('mySVG2');
    if (svg2) {
      svg2.setAttribute('preserveAspectRatio', 'xMinYMin meet');
      try {
        const bb = svg2.getBBox();
        svg2.setAttribute('viewBox', `${bb.x - 20} ${bb.y - 20} ${bb.width + 40} ${bb.height + 40}`);
      } catch (e) {
        console.log('SVG2 viewBox 조정 실패:', e);
      }
    }
  });
</script>
<script>
  document.querySelectorAll('a').forEach(function(link) {
    // 휠 클릭 막기: 마우스 눌렀을 때
    link.addEventListener('mousedown', function(e) {
      if (e.button === 1) {
        e.preventDefault();
      }
    });

    // 휠 클릭 막기: 마우스 뗄 때
    link.addEventListener('mouseup', function(e) {
      if (e.button === 1) {
        e.preventDefault();
      }
    });

    // 휠 클릭 막기: 브라우저 전용 이벤트
    link.addEventListener('auxclick', function(e) {
      if (e.button === 1) {
        e.preventDefault();
      }
    });
  });
</script>


</body>
</html>
<%
'========================
'절곡 등록
elseif rpart="binsert" then   
  rbaname=encodestr(Request("baname"))    '절곡이름
  ybachannel=Request("bachannel")  '채널넘버

    If ybachannel = "❌" Then
        rbachannel = 0
    ElseIf IsNumeric(ybachannel) Then
        rbachannel = CInt(ybachannel)
    Else
        rbachannel = 0  ' 잘못된 값은 0 처리
    End If

  rg_bogang=Request("g_bogang") '갈바보강자재
  rg_busok=Request("g_busok")  '갈바부속보강자재
  rbastatus=Request("bastatus")    '절곡상태
  rbfidx=Request("bfidx")
  rSJB_IDX=Request("SJB_IDX")
  'Response.write rSJB_IDX
  'Response.end
  
  SQL="Insert into tk_barasi (baname,bamidx, bawdate, bachannel, g_bogang, g_busok, bastatus, bfidx) values ('"&rbaname&"','"&c_midx&"',getdate(),'"&rbachannel&"', '"&rg_bogang&"', '"&rg_busok&"' ,'"&rbastatus&"','"&rbfidx&"' ) "
  'Response.write (SQL)&"<br>"
  
  Dbcon.Execute (SQL)

  SQL="Select max(baidx) From tk_barasi "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
      rbaidx=Rs(0)
  End if
  Rs.Close

  ' tx, ty 업데이트 프로그램을 iframe으로 실행
  response.write "<html><body>"
  response.write "<iframe id='updateFrame' style='width:100%; height:400px; border:1px solid #ccc;'></iframe>"
  response.write "<script>"
  response.write "document.getElementById('updateFrame').src = 'TNG1_B_baljuSTPROGRAM.asp?update_all=1';"
  response.write "setTimeout(function() {"
  response.write "  location.replace('tng1_julgok_in_sub3.asp?kkgotopage=" & kkgotopage & "&SJB_IDX="&rSJB_IDX&"&baidx="&rbaidx&"&bfidx="&rbfidx&"');"
  response.write "}, 3000);"
  response.write "</script>"
  response.write "</body></html>"
'========================
'절곡이름 수정
elseif rpart="bupdate" then 

  rbaname=encodestr(Request("baname"))    '절곡이름
  rbastatus=Request("bastatus")    '절곡상태
  ybachannel=Request("bachannel")  '채널넘버

    If ybachannel = "❌" Then
        rbachannel = 0
    ElseIf IsNumeric(ybachannel) Then
        rbachannel = CInt(ybachannel)
    Else
        rbachannel = 0  ' 잘못된 값은 0 처리
    End If

  rg_bogang=Request("g_bogang") '갈바보강자재
  rg_busok=Request("g_busok")  '갈바부속보강자재
  rbfidx=Request("bfidx")
  sql="update tk_barasi set baname='"&rbaname&"' , bachannel='"&rbachannel&"', g_bogang='"&rg_bogang&"', g_busok='"&rg_busok&"', bastatus='"&rbastatus&"' where baidx='"&rbaidx&"' "
  'Response.write (SQL)&"<br>"
  'response.end
  Dbcon.Execute (SQL)
  response.write "<script>location.replace('tng1_julgok_in_sub3.asp?kkgotopage=" & kkgotopage & "&SJB_IDX="&rSJB_IDX&"&baidx="&rbaidx&"&bfidx="&rbfidx&"');</script>"

'========================
'절곡삭제
elseif rpart="badel" then 
  SQL="Delete From tk_barasiSub Where baidx='"&rbaidx&"' "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)

  SQL="Delete From tk_barasi Where baidx='"&rbaidx&"' "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
  response.write "<script>location.replace('tng1_julgok_in_sub3.asp?kkgotopage=" & kkgotopage & "&SJB_IDX="&rSJB_IDX&"&bfidx="&rbfidx&"');</script>"

'=========================
'절곡Sub 삭제
elseif rpart="subdel" then 

  if rbasidx<>"" then 
    SQL="Delete from tk_barasisub where basidx='"&rbasidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    '가로세로 최소좌표 최대좌표 구해서 업데이트 시작
    '==========================================
    SQL="select min(x1), max(x1), min(x2), max(x2), min(y1), max(y1), min(y2), max(y2) "
    SQL=SQL&" From tk_barasisub "
    SQL=SQL&" Where baidx='"&rbaidx&"' "
    'response.write (SQL)&"<BR>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        min_x1=Rs(0)
        max_x1=Rs(1)
        min_x2=Rs(2)
        max_x2=Rs(3)
        min_y1=Rs(4)
        max_y1=Rs(5)
        min_y2=Rs(6)
        max_y2=Rs(7)

If isNUll(min_x1) Then min_x1=0 end if
If isNUll(min_x2) Then min_x2=0 end if
If isNUll(max_x1) Then max_x1=0 end if
If isNUll(max_x2) Then max_x2=0 end if
If isNUll(min_y1) Then min_y1=0 end if
If isNUll(min_y2) Then min_y2=0 end if
If isNUll(max_y1) Then max_y1=0 end if
If isNUll(max_y2) Then max_y2=0 end if


        if Cint(min_x1) <= Cint(min_x2) then  
            sx1=min_x1
        else
            sx1=min_x2
        end if
        if Cint(max_x1) >= Cint(max_x2) then  
            sx2=max_x1
        else
            sx2=max_x2
        end if

        if Cint(min_y1) <= Cint(min_y2) then  
            sy1=min_y1
        else
            sy1=min_y2
        end if
        if Cint(max_y1) >= Cint(max_y2) then  
            sy2=max_y1
        else
            sy2=max_y2
        end if

        xsize=sx2-sx1
        ysize=sy2-sy1
        

        SQL="Update tk_barasi set xsize='"&xsize&"', ysize='"&ysize&"', sx1='"&sx1&"', sx2='"&sx2&"' "
        SQL=SQL&" , sy1='"&sy1&"', sy2='"&sy2&"' Where baidx='"&rbaidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    End If
    Rs.Close

  end if
response.write "<script>location.replace('tng1_julgok_in_sub3.asp?kkgotopage=" & kkgotopage & "&SJB_IDX="&rSJB_IDX&"&baidx="&rbaidx&"&bfidx="&rbfidx&"');</script>"

'=========================
'절곡수치 입력
elseif rpart="bisnsert" then 

rbassize=Request("bassize")  '치수입력값
rbasdirection=Request("basdirection")    '방향
rkak=Request("kak")  '앞각 뒷각
rfinal=Request("final")  '샤링값 적용여부
rcx2=Request("x2")   '시작점 x좌표
rcy2=Request("y2")   '시작점 y좌표
rkangle=Request("kangle")  '꺽임
'response.write "rbaidx : "&rbaidx&"<br>"
'response.write "rbassize : "&rbassize&"<br>"
'response.write "rbasdirection : "&rbasdirection&"<br>"
'response.write "rfinal : "&rfinal&"<br>"
 
'response.write "rcx2 : "&rcx2&"<br>"
'response.write "rcy2 : "&rcy2&"<br>"

If rkangle<>"" then '꺽임설정 이동
  response.write "<script>location.replace('tng1_julgok_in_sub3.asp?kkgotopage=" & kkgotopage & "&SJB_IDX="&rSJB_IDX&"&part=angle&baidx="&rbaidx&"&bfidx="&rbfidx&"&kangle="&rkangle&"&bassize="&rbassize&"');</script>"
  response.end
End if
'==========================================
'첫 입력 여부 확인 및 초기 변수 설정 시작
  SQL="Select top 1 basidx, x1, y1, x2, y2, accsize, ysr1, ody "
  SQL=SQL&" From tk_barasisub Where baidx='"&rbaidx&"' "
  SQL=SQL&" Order by basidx Desc"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then '입력값이 하나라도 있다면
      basidx=Rs(0)    '최근 절곡 서브키값
      x1=Rs(1)    '최근 시작점 x좌표
      y1=Rs(2)    '최근 시작저 y좌표
      x2=Rs(3)    '최근 종점 x좌표
      y2=Rs(4)    '최근 종점 y좌표
      accsize=Rs(5)   '최근 결과값2
      ysr2=Rs(6)    '최근 연신율 이전 ysr1이 다음 연신율 값이 레코드에서는 ysr2로 입력됨
      pody=Rs(7)

  else  '입력값이 없다면 초기 변수 설정
      x1=Cint(rcx2)    '시작점 x좌표를 입력값으로 설정
      y1=Cint(rcy2)    '시작점 y좌표를 입력값으로 설정
      x2=Cint(rcx2)    '종점 x좌표를 입력값으로 설정
      y2=Cint(rcy2)    '종점 y좌표를 입력값으로 설정
      accsize=0   '결과값2 0으로 초기화
      ody="0" ' 순번 0으로 초기화
      ysr2=0
  End if
  Rs.Close
'첫 입력 여부 확인 및 초기 변수 설정 끝
'==========================================
'==========================================
' 방향에 대한 x2좌표 적용 시작
  if rbasdirection="1" then 
      x1=x2
      y1=y2
      x2=x1+rbassize
      y2=y1

  elseif rbasdirection="2" then 
      x1=x2
      y1=y2
      x2=x1
      y2=y1+rbassize

  elseif rbasdirection="3" then 
      x1=x2
      y1=y2
      x2=x1-rbassize
      y2=y1

  elseif rbasdirection="4" then 
      x1=x2
      y1=y2
      x2=x1
      y2=y1-rbassize

  end if
'방향에 대한 x2좌표 적용 끝
'==========================================
'==========================================
'앞각/뒷각 적용 시작

    If rkak="1" then        '뒷각이라면
      ysr1=0.5              '뒷각 이번 연신율
    Elseif  rkak="2" Then   '앞각이라면
      ysr1=-0.5              '뒷각 이번 연신율
    End If

'앞각/뒷각 적용 시작
'==========================================

'절곡값 입력 시작
'==========================================


if ody="0" then '첫번째 입력이라면 idv값은 1로 초기화
  idv=0
Else    '2번째 이상 입력
  if rfinal="1" Then  '진행중이라면
    idv=ysr1+ysr2
  elseif rfinal="0" Then  '최종이라면
    idv=0
  end if
end if

ody=pody+1  '순번증가하기

accsize=accsize+rbassize+idv  '결과값2(누적길이))

'response.write ysr1&"<br>"
'response.write ysr2&"<br>"


SQL="Insert into tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection "
SQL=SQL&" , basmidx, baswdate, final, ysr1, ysr2, ody, idv, accsize, kak, tx, ty) "
SQL=SQL&" values ('"&rbaidx&"', '"&x1&"', '"&y1&"', '"&x2&"', '"&y2&"', '"&rbassize&"', '"&rbasdirection&"'"
SQL=SQL&" , '"&c_midx&"', getdate(), '"&rfinal&"', '"&ysr1&"', '"&ysr2&"', '"&ody&"', '"&idv&"', '"&accsize&"', '"&rkak&"', NULL, NULL)"
'Response.write (SQL)&"<br><br>"
Dbcon.Execute (SQL)
'Response.end
'==========================================
'절곡값 입력 끝


'가로세로 최소좌표 최대좌표 구해서 업데이트 시작
'==========================================
SQL="select min(x1), max(x1), min(x2), max(x2), min(y1), max(y1), min(y2), max(y2) "
SQL=SQL&" From tk_barasisub "
SQL=SQL&" Where baidx='"&rbaidx&"' "
'response.write (SQL)&"<BR>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
    min_x1=Rs(0)
    max_x1=Rs(1)
    min_x2=Rs(2)
    max_x2=Rs(3)
    min_y1=Rs(4)
    max_y1=Rs(5)
    min_y2=Rs(6)
    max_y2=Rs(7)

    if Cint(min_x1) <= Cint(min_x2) then  
        sx1=min_x1
    else
        sx1=min_x2
    end if
    if Cint(max_x1) >= Cint(max_x2) then  
        sx2=max_x1
    else
        sx2=max_x2
    end if

    if Cint(min_y1) <= Cint(min_y2) then  
        sy1=min_y1
    else
        sy1=min_y2
    end if
    if Cint(max_y1) >= Cint(max_y2) then  
        sy2=max_y1
    else
        sy2=max_y2
    end if

    xsize=sx2-sx1
    ysize=sy2-sy1
    

    SQL="Update tk_barasi set xsize='"&xsize&"', ysize='"&ysize&"', sx1='"&sx1&"', sx2='"&sx2&"' "
    SQL=SQL&" , sy1='"&sy1&"', sy2='"&sy2&"' Where baidx='"&rbaidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
End If
Rs.Close

'==========================================
'가로세로 최소좌표 최대좌표 구해서 업데이트 끝

response.write "<script>location.replace('tng1_julgok_in_sub3.asp?kkgotopage=" & kkgotopage & "&SJB_IDX="&rSJB_IDX&"&baidx="&rbaidx&"&bfidx="&rbfidx&"');</script>"

'마지막 꺽임 적용
'===========================================
elseif rpart="angle" then 
rbaidx=Request("baidx")
rbfidx=Request("bfidx")
rkangle=Request("kangle")
rbassize=Request("bassize")

SQL=" Select basdirection, x2, y2, accsize"
SQL=SQL&" from tk_barasiSub "
SQL=SQL&" where baidx='"&rbaidx&"' "
SQL=SQL&" order by basidx desc "
'response.write (SQL)&"<BR>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  rbasdirection=Rs(0)
  rx2=Rs(1)
  ry2=Rs(2)
  raccsize=Rs(3)
End If
Rs.Close

 

response.write "rbaidx : "&rbaidx&"<br>"
response.write "rbfidx : "&rbfidx&"<br>"
response.write "rkangle : "&rkangle&"<br>"
response.write "rbassize : "&rbassize&"<br>"




response.write "rbasdirection : "&rbasdirection&"<br>"
response.write "rx2 : "&rx2&"<br>"
response.write "ry2 : "&ry2&"<br>"
response.write "raccsize : "&raccsize&"<br>"
response.write "rkangle : "&rkangle&"<br>"
'response.end
cx1=rx2
cy1=ry2

  if rbasdirection="1" then '1번방향일 경우
    if rkangle="1" then '오른쪽 꺽임
      cx2=cx1-10
      cy2=cy1+10
    elseif rkangle="2" then   '왼쪽 꺽임
      cx2=cx1-10
      cy2=cy1-10
    end if 
  elseif  rbasdirection="2" then '2번 방향일 경우
    if rkangle="1" then '오른쪽 꺽임
      cx2=cx1-10
      cy2=cy1-10
    elseif rkangle="2" then   '왼쪽 꺽임
      cx2=cx1+10
      cy2=cy1-10
    end if 
  elseif  rbasdirection="3" then '3번 방향일 경우
    if rkangle="1" then '오른쪽 꺽임
      cx2=cx1+10
      cy2=cy1-10
    elseif rkangle="2" then   '왼쪽 꺽임
      cx2=cx1+10
      cy2=cy1+10
    end if 
  elseif  rbasdirection="4" then '4번 방향일 경우
    if rkangle="1" then '오른쪽 꺽임
      cx2=cx1+10
      cy2=cy1+10
    elseif rkangle="2" then   '왼쪽 꺽임
      cx2=cx1-10
      cy2=cy1+10
    end if 
  end if 

rfinal=2  '최종여부 2로 초기화
ysr1=0
ysr2=0
ody=0
idv=0
accsize=raccsize+rbassize
rkak=0
SQL="Insert into tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection "
SQL=SQL&" , basmidx, baswdate, final, ysr1, ysr2, ody, idv, accsize, kak) "
SQL=SQL&" values ('"&rbaidx&"', '"&cx1&"', '"&cy1&"', '"&cx2&"', '"&cy2&"', '"&rbassize&"', '"&rbasdirection&"'"
SQL=SQL&" , '"&c_midx&"', getdate(), '"&rfinal&"', '"&ysr1&"', "&ysr2&", '"&ody&"', '"&idv&"', '"&accsize&"', '"&rkak&"')"
'Response.write (SQL)&"<br><br>"
Dbcon.Execute (SQL)
'Response.end
response.write "<script>location.replace('tng1_julgok_in_sub3.asp?kkgotopage=" & kkgotopage & "&SJB_IDX="&rSJB_IDX&"&baidx="&rbaidx&"&bfidx="&rbfidx&"');</script>"

end if
%>
<%

'======================================================================================
'절곡 전체 복사 기능
if Request("mode") = "copy" then

    copy_baidx = Request("copy_baidx")
    rbfidx = Request("bfidx")
    rSJB_IDX = Request("SJB_IDX")

    ' 1. tk_barasi 원본 조회
    SQL = "SELECT baname, bachannel, g_bogang, g_busok, bastatus "
    SQL = SQL & "FROM tk_barasi WHERE baidx = '" & copy_baidx & "'"
    Rs.Open SQL, Dbcon
    If Not (Rs.EOF Or Rs.BOF) Then
        baname = Rs(0)
        bachannel = Rs(1)
        g_bogang = Rs(2)
        g_busok = Rs(3)
        bastatus = Rs(4)
    End If
    Rs.Close

    ' 2. tk_barasi 새로 INSERT
    SQL = "INSERT INTO tk_barasi (baname, bamidx, bawdate, bachannel, g_bogang, g_busok, bastatus, bfidx) "
    SQL = SQL & "VALUES ('" & baname & " (복사)', '" & c_midx & "', getdate(), '" & bachannel & "', '" & g_bogang & "', '" & g_busok & "', '" & bastatus & "', '" & rbfidx & "')"
    Dbcon.Execute(SQL)

    ' 3. 새로 생성된 baidx 조회
    SQL = "SELECT MAX(baidx) FROM tk_barasi"
    Rs.Open SQL, Dbcon
    If Not (Rs.EOF Or Rs.BOF) Then
        new_baidx = Rs(0)
    End If
    Rs.Close

    ' 4. 관련된 tk_barasisub 전체 복사
    SQL = "SELECT x1, y1, x2, y2, bassize, basdirection, final, ysr1, ysr2, ody, idv, accsize, kak, bfidx "
    SQL = SQL & "FROM tk_barasisub WHERE baidx = '" & copy_baidx & "' ORDER BY basidx ASC"
    Rs.Open SQL, Dbcon
    Do Until Rs.EOF
        SQL2 = "INSERT INTO tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection, basmidx, baswdate, final, ysr1, ysr2, ody, idv, accsize, kak, bfidx, tx, ty) "
        SQL2 = SQL2 & "VALUES ('" & new_baidx & "', '" & Rs(0) & "', '" & Rs(1) & "', '" & Rs(2) & "', '" & Rs(3) & "', '" & Rs(4) & "', '" & Rs(5) & "', "
        SQL2 = SQL2 & "'" & c_midx & "', getdate(), '" & Rs(6) & "', '" & Rs(7) & "', '" & Rs(8) & "', '" & Rs(9) & "', '" & Rs(10) & "', '" & Rs(11) & "', '" & Rs(12) & "', '" & Rs(13) & "', NULL, NULL)"
        Dbcon.Execute SQL2
        Rs.MoveNext
    Loop
    Rs.Close

    ' 복사 후 페이지 이동
    response.write "<script>location.replace('tng1_julgok_in_sub3.asp?kkgotopage=" & kkgotopage & "&SJB_IDX=" & rSJB_IDX & "&baidx=" & new_baidx & "&bfidx=" & rbfidx & "');</script>"

'=========================
'텍스트 위치 업데이트
elseif rpart="update_position" then 
rbasidx=Request("basidx")
rtx=Request("tx")
rty=Request("ty")

SQL="UPDATE tk_barasisub SET tx='"&rtx&"', ty='"&rty&"' WHERE basidx='"&rbasidx&"' "
'Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)
Response.write "OK"
Response.End

end if

%>
<%


set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
