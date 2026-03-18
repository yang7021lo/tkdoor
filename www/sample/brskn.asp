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


projectname="절곡바라시"
 
rbaidx=Request("baidx")
rbasidx=Request("basidx")
rpart=Request("part")

sql="select baname , bastatus, xsize, ysize, sx1, sx2, sy1, sy2 from tk_barasi where baidx='"&rbaidx&"' "
'response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then  

  rbaname=Rs(0)
  rbastatus=Rs(1)
  xsize=Rs(2)
  ysize=Rs(3)
  sx1=Rs(4)
  sx2=Rs(5)
  sy1=Rs(6)
  sy2=Rs(7)
  if xsize="0" then xsize="1" end if

  ratev=FormatNumber(300/xsize,0)
  'response.write ratev&"/<br>"
end if
Rs.close



if request("gotopage")="" then
gotopage=1
else
gotopage=request("gotopage")
end if
page_name="brskn.asp?"

if rpart="" then 
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><%=projectname%></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
            location.href="brskn.asp?part=badel&baidx="+rbaidx;
        }
    }
  </script>
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
<form name="frmMain" action="brskn.asp" method="post">
<% if rbaidx<>"" then %>
    <input type="hidden" name="part" value="bupdate">
    <input type="hidden" name="baidx" value="<%=rbaidx%>">
<% else %>
    <input type="hidden" name="part" value="binsert">
<% end if %>
        <div class="mb-2">
          <label for="bendName" class="form-label">절곡 이름</label>
          <input type="text" class="form-control" name="baname" id="baname" placeholder="예: 절곡 A"  value="<%=rbaname%>">
        </div>

        <div class="mb-2">
          <label class="form-label">사용 여부</label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="bastatus" id="bastatus" value="1"  <% if rbastatus="1" or rbastatus=""  then %> checked <% end if %>>
              <label class="form-check-label" for="useY">사용</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="bastatus" id="bastatus" value="0" <% if rbastatus="0"  then %> checked <% end if %>>
              <label class="form-check-label" for="useN">사용안함</label>
            </div>
          </div>
        </div>

        <div class="mb-2 text-end">
          <% if rbaidx<>"" then %>
          <button type="button" class="btn btn-outline-danger w-25" style="margin-right:5px;" Onclick="del('<%=rbaidx%>');">삭제</button>
          <button type="button" class="btn btn-outline-success w-25" style="margin-right:5px;"  Onclick="location.replace('brskn.asp');">신규</button>
          <button type="button" class="btn btn-outline-primary w-25"  Onclick="barasi();">저장</button>
          <% else %>
          <button type="button" class="btn btn-outline-primary w-25"  Onclick="barasi();">등록</button>
          <% end if %>
          

        </div>
      </div>
    </div>
      </form>
      <p class="mb-2">

      <table class="table table-sm table-bordered mt-2">
        <thead class="table-light">
          <tr>
            <th style="width: 20%" class="text-center">순번</th>
            <th class="text-center">이름</th>
            <th style="width: 30%" class="text-center">사용 여부</th>
          </tr>
        </thead>
        <tbody>
          <!-- 예시 데이터 -->
<%
SQL="select baidx, baname ,bastatus from tk_barasi order by baidx desc"
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

baidx=Rs(0)
baname=Rs(1)
bastatus=Rs(2)

if bastatus="0" then 
  bastatus_text="사용안함"
elseif bastatus="1" then 
  bastatus_text="사용"
end if
%>   
          <tr>
            <td class="text-center"><%=no-j%></td>
            <td class="text-start"><a href="brskn.asp?baidx=<%=baidx%>"><% if bastatus="0" then response.write "<s>" end if%><%=baname%><% if bastatus="0" then response.write "</s>" end if%></a></td>
            <td class="text-center"><a href="brskn.asp?baidx=<%=baidx%>"><%=bastatus_text%></a></td>
          </tr>
<%
Rs.MoveNext 
i=i+1
bastatus_text=""
Next 

%> 
        </tbody>
      </table>

      <!-- 페이지네이션 -->
<!--#include Virtual = "/inc/paging1.asp" -->
<%
Rs.close
End If    
%>

    </div>

  <!-- 오른쪽 패널: 절곡 설정 (카드 안으로 감쌈) -->
  <div class="col-md-9">
    <div class="card">
      <div class="card-header">
        <h5 class="mb-0">절곡 설정</h5>
      </div>
      <div class="card-body">
        <form class="row gy-2 align-items-center" name="frmMain2" action="brskn.asp?part=bisnsert" method="post">
        <input type="hidden" name="baidx" value="<%=rbaidx%>">      
          <div class="col-auto">
          <div class="input-group">
<%
SQL="Select kak From tk_barasisub where baidx='"&rbaidx&"' order by ody desc"
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  kak=Rs(0) '뒷각 1/ 앞각2

Else
  startv="1"  '첫시작 변수 초기화
  kak="1"
%>
<!-- 첫 등록시 시작좌표 설정 시작 -->
            <input type="text" class="form-control" name="x2" size="4" value="200" >
            <input type="text" class="form-control" name="y2" size="4" value="100" >
<!-- 첫 등록시 시작좌표 설정 끝 -->

<%
End if
Rs.Close
%>
          </div>
          </div>

          <div class="col-auto">
            <!--<label class="form-label">각도</label><br>-->
              <div class=" text-start ms-0" style="width:150px;padding:10 5 5 5;">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="kak" value="1" <% if kak="1" then response.write "checked" end if %>>
                    <label class="form-check-label" >뒷각</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="kak" value="2"  <% if kak="2" then response.write "checked" end if %>>
                    <label class="form-check-label" >앞각</label>
                </div>
              </div>
          </div>
          <div class="col-auto">
            <!--<label for="sizeInput" class="form-label">치수</label>-->
            <input type="number" class="form-control" id="bassize" placeholder="치수(mm)" name="bassize" value="<%=bassize%>" size="4" autofocus>
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
If rbaidx<>"" then 
%>          
            <button type="button" class="btn btn-success" onclick="barasisub();">저장</button>
<%
end if 
%>
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
<a href="brskn.asp?part=subdel&baidx=<%=rbaidx%>&basidx=<%=basidx%>"><%=bassize%></a>
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
            SQL="Select basidx, ysr2, ysr1, idv, bassize from tk_barasisub where baidx='"&rbaidx&"' order by basidx asc"
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
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%
'========================
'절곡 등록
elseif rpart="binsert" then   
  rbaname=encodestr(Request("baname"))    '절곡이름
  rbastatus=Request("bastatus")    '절곡상태

  SQL="Insert into tk_barasi (baname,bamidx, bawdate,bastatus) values ('"&rbaname&"','"&c_midx&"',getdate(),'"&rbastatus&"' ) "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)

  SQL="Select max(baidx) From tk_barasi "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
      rbaidx=Rs(0)
  End if
  Rs.Close

  response.write "<script>location.replace('brskn.asp?baidx="&rbaidx&"');</script>"
'========================
'절곡이름 수정
elseif rpart="bupdate" then 

  rbaname=encodestr(Request("baname"))    '절곡이름
  rbastatus=Request("bastatus")    '절곡상태

  sql="update tk_barasi set baname='"&rbaname&"' , bastatus='"&rbastatus&"' where baidx='"&rbaidx&"' "
  Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
  response.write "<script>location.replace('brskn.asp?baidx="&rbaidx&"');</script>"

'========================
'절곡삭제
elseif rpart="badel" then 
  SQL="Delete From tk_barasiSub Where baidx='"&rbaidx&"' "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)

  SQL="Delete From tk_barasi Where baidx='"&rbaidx&"' "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
  response.write "<script>location.replace('brskn.asp');</script>"

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
    response.write (SQL)&"<BR>"
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
        Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    End If
    Rs.Close

  end if
response.write "<script>location.replace('brskn.asp?baidx="&rbaidx&"');</script>"

'=========================
'절곡수치 입력
elseif rpart="bisnsert" then 

rbassize=Request("bassize")  '치수입력값
rbasdirection=Request("basdirection")    '방향
rkak=Request("kak")  '앞각 뒷각
rfinal=Request("final")  '샤링값 적용여부
rcx2=Request("x2")   '시작점 x좌표
rcy2=Request("y2")   '시작점 y좌표

response.write "rbaidx : "&rbaidx&"<br>"
response.write "rbassize : "&rbassize&"<br>"
response.write "rbasdirection : "&rbasdirection&"<br>"
response.write "rfinal : "&rfinal&"<br>"
 
response.write "rcx2 : "&rcx2&"<br>"
response.write "rcy2 : "&rcy2&"<br>"
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

response.write ysr1&"<br>"
response.write ysr2&"<br>"


SQL="Insert into tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection "
SQL=SQL&" , basmidx, baswdate, final, ysr1, ysr2, ody, idv, accsize, kak) "
SQL=SQL&" values ('"&rbaidx&"', '"&x1&"', '"&y1&"', '"&x2&"', '"&y2&"', '"&rbassize&"', '"&rbasdirection&"'"
SQL=SQL&" , '"&c_midx&"', getdate(), '"&rfinal&"', '"&ysr1&"', "&ysr2&", '"&ody&"', '"&idv&"', '"&accsize&"', '"&rkak&"')"
Response.write (SQL)&"<br><br>"
Dbcon.Execute (SQL)
'Response.end
'==========================================
'절곡값 입력 끝


'가로세로 최소좌표 최대좌표 구해서 업데이트 시작
'==========================================
SQL="select min(x1), max(x1), min(x2), max(x2), min(y1), max(y1), min(y2), max(y2) "
SQL=SQL&" From tk_barasisub "
SQL=SQL&" Where baidx='"&rbaidx&"' "
response.write (SQL)&"<BR>"
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
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
End If
Rs.Close

'==========================================
'가로세로 최소좌표 최대좌표 구해서 업데이트 끝

response.write "<script>location.replace('brskn.asp?baidx="&rbaidx&"');</script>"

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
