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
projectname="절곡등록"
%>
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 

DDD=Request("DDD")    '삭제 구분값

rbfidx=Request("bfidx")

if rbfidx="" then
Response.Write "<script>alert('세부자재 코드가 없습니다.');window.close();</script>"
response.end
end if

'Response.Write "rbfidx : " & rbfidx & "<br>"
'response.end

rbaidx=Request("baidx")
'Response.Write "rbaidx : " & rbaidx & "<br>"
'response.end

rSJB_IDX=Request("SJB_IDX")
if rbaidx="" then
    rbaidx=0
end if

If rg_bogang = "" Then rg_bogang = "0"
If rg_busok = "" Then rg_busok = "0"

rbasidx=Request("rbasidx")
part=Request("part")

sql = "SELECT baname, bastatus, xsize, ysize, sx1, sx2, sy1, sy2, bachannel, bfidx, g_bogang, g_busok "
sql = sql & "FROM tk_barasi WHERE bfidx='" & rbfidx & "' AND baidx='" & rbaidx & "'"
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
    bachannel=rs(8)
    bfidx=rs(9)
    rg_bogang   = Rs(10)
    rg_busok    = Rs(11)
    if xsize="0" then xsize="1" end if

    ratev=FormatNumber(300/xsize,0)
'response.write ratev&"/<br>"
    end if
    Rs.close

if rbasidx<>"" then 

    SQL="Delete from tk_barasisub where basidx='"&rbasidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    SQL="Update tk_barasi set xsize=0, ysize=0, sx1=0, sx2=0, sy1=0, sy2=0  Where baidx='"&rbaidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

end if

SQL=" select bfimg1, bfimg2 from tk_barasiF where bfidx='"&rbfidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    bfimg1=Rs(0)
    bfimg2=Rs(1)
    End if
    Rs.Close

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
    <script> src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
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
        /* 🔹 버튼 크기 조정 */
        .btn-small {
            font-size: 18px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 39px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
    </style>
    <script>  
        // 공통 키프레스 핸들러
        
        // Select 박스나 라디오 버튼 변경 이벤트 핸들러
        function handleChange(selectElement) {
        const selectedValue = selectElement.value;
        console.log(`선택 변경됨 값: ${selectedValue}`);
        document.getElementById("hiddenSubmit").click();
        }
        // ✅ 폼 전체 Enter 이벤트 감지
        document.getElementById("barasi")?.addEventListener("keydown", function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            console.log("barasi에서 Enter 감지");
            document.getElementById("hiddenSubmit").click();
        }
        });
        document.getElementById("barasi_table")?.addEventListener("keydown", function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            console.log("barasi_table에서 Enter 감지");
            document.getElementById("hiddenSubmit").click();
        }
        });
        document.getElementById("barasisub")?.addEventListener("keydown", function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            console.log("barasisub에서 Enter 감지");
            document.getElementById("hiddenSubmit").click();
        }
        });
        function basins(basdirection){
            if(document.barasisub.bassize.value==""){
                alert("사이즈 입력");
                return
            }
            else{
                document.barasisub.submit();
            }
        }
        function del(sTR){
            if (confirm("삭제 하시겠습니까?")) {
                var sjb_idx = "<%=rsjb_idx%>";
                var bfidx = "<%=rbfidx%>";
                location.href = "TNG1_JULGOK_IN_SUB_DB.asp?sjb_idx=" + sjb_idx + "&bfidx=" + bfidx + "&DDD=delete&baidx=" + sTR;
            }
        }
    </script>
</head>
<body class="sb-nav-fixed">
<div id="layoutSidenav_content">            
    <main>
        <div class="container-fluid px-4">
            <div class="row justify-content-between">
                <div class="row" >
                    <div class="col-5 " style="overflow-y: auto;">
                        <div class="container p-3">
                            <div class="input-group mb-3">
                                <h5>절곡 등록</h5>
                            </div>
                            <form name="barasi" id="barasi" action="TNG1_JULGOK_IN_SUB_DB.asp" method="post">
                                <% if part="update" then %>
                                    <input type="hidden" name="part" value="bupdate">
                                    <input type="hidden" name="baidx" value="<%=rbaidx%>">
                                    <input type="hidden" name="bfidx" value="<%=rbfidx%>">
                                    <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
                                <% else %>
                                    <input type="hidden" name="part" value="binsert">
                                    <input type="hidden" name="bfidx" value="<%=rbfidx%>">
                                    <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
                                <% end if %>
                                <div class="row mb-3">
                                    <div class="col-10">
                                        <div class="d-flex align-items-center">
                                          <div class="input-group mb-3">
                                            <span class="input-group-text">이 름</span>
                                            <input type="text" class="form-control" name="baname" value="<%=rbaname%>"
                                                onkeypress="handleKeyPress(event, 'baname', 'baname')">
                                                <button type="submit" class="btn btn-danger btn-small">저장</button>
                                                <% if rbaidx<>"" then %>
                                                <button type="button" class="btn btn-success btn-small"
                                                        onclick="location.replace('TNG1_JULGOK_IN_SUB.asp?sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>&baidx=0');">
                                                신규
                                                </button>
                                                <% end if %>
                                          </div>
                                        </div>
                                        <div class="d-flex align-items-center">
                                          <div class="input-group mb-3">
                                            <span class="input-group-text">채널넘버</span>
                                            <input type="number" class="form-control" name="bachannel" value="<%=bachannel%>"
                                                onkeypress="handleKeyPress(event, 'bachannel', 'bachannel')">
                                          </div>     
                                        </div>
                                    </div>
              
                                </div>
                                <div class="input-group align-items-center">
                                    <span class="input-group-text">갈바 보강 자재</span>
                                    <div class="d-flex ms-2">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="g_bogang" value="1"
                                                <% if rg_bogang = "1" then %> checked <% end if %>
                                                onchange="handleChange(this);">
                                            <label class="form-check-label">선택</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="g_bogang" value="0"
                                                <% if rg_bogang = "0" or rg_bogang = "" then %> checked <% end if %>
                                                onchange="handleChange(this);">
                                            <label class="form-check-label">안함</label>
                                        </div>
                                    </div>
                                    <div class="input-group align-items-center">
                                        <span class="input-group-text">갈바 부속 보강 자재</span>
                                        <div class="d-flex ms-2">
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="g_busok" value="1"
                                                    <% if rg_busok = "1" then %> checked <% end if %>
                                                    onchange="handleChange(this);">
                                                <label class="form-check-label">선택</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="g_busok" value="0"
                                                    <% if rg_busok = "0" or rg_busok = "" then %> checked <% end if %>
                                                    onchange="handleChange(this);">
                                                <label class="form-check-label">안함</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="input-group align-items-center">
                                    <span class="input-group-text">사용</span>
                                    <div class="d-flex ms-2">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="bastatus" value="1"
                                                <% if rbastatus="1" or rbastatus="" then %> checked <% end if %>
                                                onchange="handleChange(this);">
                                            <label class="form-check-label">Y</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="bastatus" value="0"
                                                <% if rbastatus="0" then %> checked <% end if %>
                                                onchange="handleChange(this);">
                                            <label class="form-check-label">N</label>
                                        </div>
                                    </div>
                                </div>
                                <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                            </form>
                        </div>
                        <div class="row">
                            <div class="card card-body mb-4">
                                <form name="barasi_table" id="barasi_table" action="TNG1_JULGOK_IN_DB.asp" method="POST">
                                    <table id="datatablesSimple" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>No</th>
                                                <th>품명</th>
                                                <th>채널명</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%
                                        SQL = "SELECT baidx, baname, bastatus, bachannel, bfidx, g_bogang, g_busok "
                                        SQL = SQL & "FROM tk_barasi WHERE bfidx='" & rbfidx & "'"
                                        Rs.open Sql,Dbcon
                                        If Not (Rs.bof or Rs.eof) Then 
                                        Do while not Rs.EOF
                                        baidx=Rs(0)
                                        baname=Rs(1)
                                        bastatus=Rs(2)
                                        bachannel=Rs(3)
                                        bfidx=Rs(4)
                                        g_bogang = Rs(5)
                                        g_busok  = Rs(6)
                                        %>
                                            <tr <% if Cint(baidx)=Cint(rbaidx) then %>class="bg-warning" <% end if %> >
                                                <td align="center"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=baidx%>');"><%=baidx%></button></td>
                                                <td>
                                                    <a href="#" onclick="location.replace('TNG1_JULGOK_IN_SUB.asp?sjb_idx=<%=rsjb_idx%>&baidx=<%=baidx%>&part=update&bfidx=<%=rbfidx%>');">
                                                    <% if bastatus="0" then response.write "<s>" end if%>
                                                    <%=baname%>
                                                    <% if bastatus="0" then response.write "</s>" end if%>
                                                    </a>
                                                </td>
                                                <td>
                                                    <a href="#" onclick="location.replace('TNG1_JULGOK_IN_SUB.asp?sjb_idx=<%=rsjb_idx%>&baidx=<%=baidx%>&part=update&bfidx=<%=rbfidx%>');">
                                                    <% if bastatus="0" then response.write "<s>" end if%>
                                                    <%=bachannel%>
                                                    <% if bastatus="0" then response.write "</s>" end if%>
                                                    </a>
                                                </td>
                                            </tr>
                                        <%
                                        Rs.movenext
                                        Loop
                                        End if
                                        Rs.close
                                        %> 
                                        </tbody>
                                    </table>
                                </FORM>    
                            </div>
                        </div>
                    </div>  
                    <div class="col-7" >

                            <%
                            if rbaidx > "0" then 
                            %>
                        <div class="row">
                            <div class="col-10">
                                <div class="input-group mb-3">
                                    <%
                                    SQL="Select top 1 basidx, basdirection From tk_barasisub where baidx='"&rbaidx&"' order by ody desc "
                                    'Response.write (SQL)&"<br>"
                                    Rs.open Sql,Dbcon
                                    If Not (Rs.bof or Rs.eof) Then 
                                        basidx=Rs(0)
                                        basdirection=Rs(1)
                                    %>                    <!-- !가로 사이즈 시작 -->
                                    <%
                                    End if
                                    Rs.Close
                                    %>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <form name="barasisub" id="barasisub" action="TNG1_JULGOK_IN_SUB_DB.asp" method="post" ><!-- *절곡설정 시작-->
                                    <input type="hidden" name="part" value="bisnsert">
                                    <input type="hidden" name="baidx" value="<%=rbaidx%>">
                                    <input type="hidden" name="bfidx" value="<%=bfidx%>">
                                    <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
                                    <div class="col-10">
                                        <div class="input-group mb-3">
                                            <%
                                            %>
                                            <span class="input-group-text">시작좌표</span> <!-- !첫 등록시 시작좌표 설정 시작 -->
                                            <input type="text" class="form-control" name="x2" style="width: 50px;" value="200" >
                                            <input type="text" class="form-control" name="y2" style="width: 50px;" value="100" >  <!-- !첫 등록시 시작좌표 설정 끝 -->
                                            <%
                                            %>
                                            <span class="input-group-text">치수</span>
                                            <input type="text" class="form-control" name="bassize" id="bassize" value="<%=bassize%>" style="width: 50px;"
                                            onkeypress="handleKeyPress(event, 'bassize', 'bassize')">
                                            <div class="btn-group">
                                            <input type="radio" class="btn-check" name="final" value="1" id="final_1"
                                                <% If final = "1" or final = "" Then %> checked <% end if %>>
                                            <label class="btn btn-outline-dark" for="final_1">진행중</label>
                                            <input type="radio" class="btn-check" name="final" value="0" id="final_0"
                                                <% If final = "0" Then %> checked <% end if %>>
                                            <label class="btn btn-danger" for="final_0">최 종</label>
                                            </div>
                                            <span class="input-group-text">방향</span>
                                            <div class="card">
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
                                        </div>
                                    </div>
                                    <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                                </form><!-- *절곡설정 끝-->
                            </div>  
                            <div class="col-4"><!-- *  tk_barasi 입력값 출력 시작 -->
                                <div class="input-group">
                                    <%
                                    SQL="Select top 1 basidx, basdirection From tk_barasisub where baidx='"&rbaidx&"' order by ody desc "
                                    'Response.write (SQL)&"<br>"
                                    Rs.open Sql,Dbcon
                                    If Not (Rs.bof or Rs.eof) Then 
                                        basidx=Rs(0)
                                        basdirection=Rs(1)
                                    %>
                                    <table class="table table-bordered" border="1"><!-- * 가로 사이즈 시작 -->
                                        <tbody>
                                            <tr>
                                                <th class="table-light">측면폭</th>
                                                <td><%=xsize%></td>
                                                <th class="table-light">정면폭</th>
                                                <td><%=ysize%></td>
                                            </tr>
                                        </tbody>
                                    </table><!-- * 가로 사이즈 끝 -->
                                    <%
                                    End if
                                    Rs.Close
                                    %>
                                </div>
                            </div><!-- *  tk_barasi 입력값 출력 끝 -->  
                        </div>
                        <div class="row">
                            <div class="row"><!-- *절곡값 통합 시작-->
                                <div class="input-group ">
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
                                                        <th>V_cut</th>
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
                                                        <td><button type="button" class="btn <%=btn_text%> btn-sm"><%=accsize%></button></td>
                                                        <%
                                                        pba=basdirection
                                                        Rs.movenext
                                                        Loop
                                                        End if
                                                        Rs.close
                                                        %> 
                                                    </tr>
                                                    <tr>
                                                        <th>내경</th>
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
                                                        <td><a href="TNG1_JULGOK_IN_SUB.asp?bfidx=<%=bfidx%>&baidx=<%=rbaidx%>&basidx=<%=basidx%>"><%=bassize%></a></td>
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
                            </div><!-- *절곡값 통합 끝-->
                            <div class="row"><!-- *svg 시작-->
                                <% if xsize>=160 or ysize>=160 then %>
                                <div class="col-6" >
                                    <div class="card card-body text-start">
                                        <svg id="mySVG" width="600" height="400"  fill="none" stroke="#000000" stroke-width="1" >
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
                                                ty1=y1-1
                                            elseif basdirection="2" then 
                                                tx1=x1+5
                                                ty1=y1+(bassize/2)+bojngv+10
                                            elseif basdirection="3" then 
                                                tx1=x1-(bassize/2)
                                                ty1=y1+5
                                            elseif basdirection="4" then 
                                                tx1=x1+5
                                                ty1=y1-(bassize/2)+bojngv+10
                                            end if

                                            vx1=(x1*ratev)-(sx1*ratev)
                                            vy1=(y1*ratev)-(sy1*ratev)
                                            vx2=(x2*ratev)-(sx1*ratev)
                                            vy2=(y2*ratev)-(sy1*ratev)

                                            tx1=(tx1*ratev)-(sx1*ratev)
                                            ty1=(ty1*ratev)-(sy1*ratev)

                                            if ty1<10 then
                                            ty1=20
                                            end if
                                            %>
                                            <line x1="<%=vx1%>" y1="<%=vy1%>" x2="<%=vx2%>" y2="<%=vy2%>" /> <!-- !<line x1="<%=x1%>" y1="<%=y1%>" x2="<%=x2%>" y2="<%=y2%>" />-->
                                            <%
                                            if bassize=int(bassize) then
                                            bassize_int=FormatNumber(bassize,0)
                                            else 
                                            bassize_int=FormatNumber(bassize,1)
                                            end if
                                            %>
                                            <text x="<%=tx1%>" y="<%=ty1%>" fill="#000000" font-size="18" text-anchor="middle"><%=bassize_int%></text>   
                                            <%
                                            Rs.movenext
                                            Loop
                                            End if
                                            Rs.close
                                            %> 
                                        </svg><!-- * SVG코드 끝 -->
                                    </div>
                                </div>
                                <% else %>
                                <div class="col-6"> 
                                    <div class="card card-body text-start"><!-- *SVG 코드 시작 -->
                                        <svg id="mySVG" width="600" height="400"  fill="none" stroke="#000000" stroke-width="1" >
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
                                            Rs.movenext
                                            Loop
                                            End if
                                            Rs.close
                                            %> 
                                        </svg>
                                    </div><!-- * SVG코드 끝 -->
                                </div>
                                <% end if %>
                                <%
                                end if
                                %>
                            </div>
                        </div>
                    </div>    
                </div> 
                <div class="row">
                    <div class="col text-center">
                        <button type="button" class="btn btn-outline-danger"  onclick="opener.location.replace('/tng1/TNG1_JULGOK_PUMMOK_LIST1.asp?SJB_IDX=<%=rSJB_IDX%>#<%=rSJB_IDX%>');window.close();">창닫기</button>
                    </div>
                </div>
            </div>
        </div>    
    </main>                     
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
