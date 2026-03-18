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
projectname="샘플"
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


rbaidx=Request("rbaidx")
rbasidx=Request("rbasidx")
part=Request("part")
if part="update" then
sql="select baname , bastatus from tk_barasi where baidx='"&rbaidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then  

    rbaname=Rs(0)
    rbastatus=Rs(1)
    end if
    rs.close

end if



if rbasidx<>"" then 
    SQL="Delete from tk_barasisub where basidx='"&rbasidx&"' "
    Dbcon.Execute (SQL)

    SQL="Update tk_barasi set xsize=0, ysize=0 Where baidx='"&rbaidx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if

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
      function basins(basdirection){
        if(document.barasisub.bassize.value==""){
            alert("사이즈 입력");
            return
        }
        else{
            document.barasisub.submit();
        }
      }
    </script>
 
  </head>
  <body class="sb-nav-fixed">



<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!--화면시작-->

    <div class="py-5 container text-center  card card-body">
      <div class="row">
        <div class="col-3">
            <div class="row">
            <!-- 제목 나오는 부분 시작-->
            <div class="input-group mb-3">
                <h3>절곡 등록</h3>
            </div>
<!-- 제목 나오는 부분 끝-->
<!-- input 형식 시작--> 
            <form name="barasi" action="barasikdb.asp" method="post">
            <% if part="update" then %>
            <input type="hidden" name="part" value="bupdate">
            <input type="hidden" name="rbaidx" value="<%=rbaidx%>">
            <% else %>
            <input type="hidden" name="part" value="binsert">
            <% end if %>
            <div class="col-12">
                <div class="input-group mb-3">
                    <span class="input-group-text">이름</span>
                    <input type="text" class="form-control" name="baname" value="<%=rbaname%>">
                    <button type="button" class="btn btn-danger" Onclick="submit();">등록</button>      
                </div>
            
                <div class="input-group mb-3">
                <span class="input-group-text">사용</span>
                    <div class="card col-10">
                        <div class=" text-start ms-0" style="width:50%;padding:5 5 5 5;">
                            <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="bastatus" value="1" <% if rbastatus="1" or rbastatus=""  then %> checked <% end if %>>
                            <label class="form-check-label" >Y</label>
                            </div>
                            <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="bastatus" value="0" <% if rbastatus="0"  then %> checked <% end if %>>
                            <label class="form-check-label" >N</label>
                            </div>
                        </div>    
                    </div>
                </div>
           






            </div>
            </form>
            <!-- input 형식 끝--> 
            </div>
            <div class="row">
                <div class="card card-body mb-4">
                    <table id="datatablesSimple" class="table table-hover">
                    <thead>
                        <tr>
                            <th>명칭</th>
                            <th>규격</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    SQL="select baidx, baname ,bastatus from tk_barasi "
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF
                    baidx=Rs(0)
                    baname=Rs(1)
                    bastatus=Rs(2)

                    %>
                        <tr>
                            <td><%=baidx%></td>
                            <td><a href="barasik.asp?rbaidx=<%=baidx%>&part=update"><% if bastatus="0" then response.write "<s>" end if%><%=baname%><% if bastatus="0" then response.write "</s>" end if%></a></td>
                        </tr>
                    <%
                    Rs.movenext
                    Loop
                    End if
                    Rs.close
                    %> 
                    </tbody>
                    </table>
            </div>
            </div>
        </div>
        <div class="col-9">
<!-- 절곡설정 제목 시작-->
          <div class="input-group mb-3">
            <h3>절곡 설정</h3>
          </div>
<!-- 절곡설정 제목 끝-->
<%
if rbaidx<>"" then 
%>
<!-- 절곡설정 시작-->

      <div class="row">
<form name="barasisub" action="barasikdb.asp" method="post">

<input type="hidden" name="part" value="bisnsert">

<input type="hidden" name="rbaidx" value="<%=rbaidx%>">
        <div class="col-10">
        <div class="input-group mb-3">
<%
SQL="Select * From tk_barasisub where baidx='"&rbaidx&"' "
Rs.open Sql,Dbcon
If (Rs.bof or Rs.eof) Then 
%>
<!-- 첫 등록시 시작좌표 설정 시작 -->
            <span class="input-group-text">치수</span>
            <input type="text" class="form-control" name="x2" value="200" >
            <input type="text" class="form-control" name="y2" value="200" >
<!-- 첫 등록시 시작좌표 설정 끝 -->
<%
End if
Rs.Close
%>
            <span class="input-group-text">치수</span>
            <input type="text" class="form-control" name="bassize" value="<%=bassize%>" autofocus>
            <span class="input-group-text">방향</span>
            <div class="card col-6">
              <div class=" text-start ms-0" style="width:80%;padding:5 5 5 5;">

                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="basdirection" value="1" <% if basdirection="1" or basdirection=""  then %> checked <% end if %>>
                    <label class="form-check-label" >→</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="basdirection" value="2" <% if basdirection="2" then %> checked <% end if %>>
                    <label class="form-check-label" >↓</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="basdirection" value="3" <% if basdirection="3"  then %> checked <% end if %>>
                    <label class="form-check-label" >←</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="basdirection" value="4" <% if basdirection="4" then %> checked <% end if %>>
                    <label class="form-check-label" >↑</label>
                </div>
              </div>
            </div>
            <span class="input-group-text">최종</span>
            <div class="card col-1">
              <div class=" text-start ms-0" style="width:=30%;padding:5 5 5 5;">

                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="final" value="1" >
                </div>
              </div>
            </div>
        <button type="button" class="btn btn-success" Onclick="basins();">저장</button>   
        </div>
</form>
      </div>
<!-- 절곡설정 끝-->
<!-- 절곡값 통합 시작-->
      <div class="row">
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

                if final="1" then 
                    btn_text="btn-danger"
                elseif idv="-1" then 
                    btn_text="btn-primary"
                elseif idv="1" then 
                    btn_text="btn-success"
                else
                    btn_text="btn-light"
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
<a href="barasik.asp?rbaidx=<%=rbaidx%>&rbasidx=<%=basidx%>"><%=bassize%></a>
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


<!-- svg 시작-->
      <div class="row">
<!-- 도면 시작-->
        <div class="col-4">
            <div class="input-group mb-3">
            <div class="card card-body text-start">

<!-- SVG 코드 시작 -->
        <svg width="600" height="600"  fill="none" stroke="#000000" stroke-width="1" >
    <%
    SQL="Select basidx, bassize, basdirection, x1, y1, x2, y2, accsize,idv from tk_barasisub where baidx='"&rbaidx&"' order by basidx asc "
    ''response.write (SQL)&"<br>"
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
        ty1=y1-5
    elseif basdirection="2" then 
        tx1=x1+10
        ty1=y1+(bassize/2)+bojngv
    elseif basdirection="3" then 
        tx1=x1-(bassize/2)
        ty1=y1-5
    elseif basdirection="4" then 
        tx1=x1+10
        ty1=y1-(bassize/2)+bojngv
    end if

    
    %>
<line x1="<%=x1%>" y1="<%=y1%>" x2="<%=x2%>" y2="<%=y2%>" />
<text x="<%=tx1%>" y="<%=ty1%>" fill="#000000" font-size="10" text-anchor="middle"><%=FormatNumber(bassize,0)%></text>   
    <%
    Rs.movenext
    Loop
    End if
    Rs.close
    %> 
        </svg>

        
<!-- SVG코드 끝 -->


            </div>
            </div>
        </div>
<!-- 도면 끝-->
<!-- 수치 시작-->
        <div class="col-4">
        </div>
<!-- 수치 끝-->
<!-- 절단수량 시작-->
        <div class="col-4">
        </div>
<!-- 절단수량 끝-->
      </div>
<!-- svg 끝-->
<%
end if
%>
        </div>
      </div>
    </div>    

<!--화면 끝-->
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 이름
 
<!-- footer 끝 --> 
            </div>
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
