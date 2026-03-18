<!--
주요 테이블
tk_report (성적서 메인 DB)

ridx:성적서 idx
ron:접수번호
rname:시료명(모델명)
ruse:성적서 사용 용도
rtdate:성적서 발급일자
rotype:개폐방식(미사용) tk_reportm에 있음
rwtype:창호타입(미사용) tk_reportm에 있음
rwidth:프레임폭
rftexture:프레임재질(미사용) tk_reportm에 있음
rbtexture:미사용
rgthickness:유리사양(미사용) tk_reportm에 있음
rginfo:유리상세(미사용) tk_reportm에 있음
rinsp:단열성능
rherp:기밀성능
rwatp:수밀성능
rpa:내풍압성능
roc:개폐력(개폐반복)
rsizelabel:치수 표시사항
rverticalw:연직하중
rtorsion:비틀림강도
rimpactr:내충격성
rsafe:안전성
rwdate:등록일자
rmidx:등록자 idx
rstatus:사용유무
rfile:첨부된 성적서 파일
remidx:수정자 idx
rewdate: 수정일자
kname:간봉재질(미사용) tk_reportm에 있음
reportnote:특이사항
nfile:미사용
rfixtop:즐겨찾기 추가 유무
depth:깊이(미사용) tk_reportm에 있음
width:너비(미사용) tk_reportm에 있음
sjb_type_no:성적서&sjb 연결키                                 
                                
                                
-----------------------------------중요한 내용-----------------------------------------------------------                               
성적서 수정시, 깊이, 너비, 개폐방식, 프레임재질, 유리사양, 유리상세, 창호타입, 간봉재질을 선택하는데, 
이를 선택할때 뜨는 항목들을 "성적서 품목"이라고 명칭하고 tk_reportm이라는 테이블에 값들을 저장해줌.



서브 테이블 (tk_reportsub, tk_reportm)

tk_reportsub (성적서 품목과 성적서 연결 DB)

rsidx:tk_reportsub idx
ridx:성적서 idx
rftype:성적서 품목 타입
rfidx:성적서 품목 idx

---------------------------

tk_reportm (성적서 품목 DB)
fidx:성적서 품목 idx
fname:성적서 품목명
fstatus:성적서 품목 사용유무
ftype:성적서 품목 타입
fmidx:성적서 품목 등록자(수정자)
fdate:성적서 품목 등록일자(수정일자)
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
    projectname="성적서 수정"
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
    ridx=request("ridx")
    clickacfidx=Request("clickacfidx")
    clickaacfidx=Request("clickaacfidx")

    if ridx<>"" then
    SQL=" Select ron, rname, ruse, rtdate, rwtype, rwidth, rinsp, rherp, rwatp, rpa, roc, kname, rsizelabel, rverticalw, rtorsion, rimpactr, rsafe, rfile, rstatus, reportnote, nfile, rtype"
    SQL=SQL&" from tk_report where ridx='"&ridx&"' "
    
    Rs.open SQL,Dbcon
        If not (Rs.BOF or Rs.EOF) then

            ron=Rs(0)
            rname=Rs(1)
            ruse=Rs(2)
            rtdate=Rs(3)
            rwtype=Rs(4)
            rwidth=Rs(5)
            rinsp=Rs(6)
            rherp=Rs(7)
            rwatp=Rs(8)
            rpa=Rs(9)
            roc=Rs(10)
            kname=Rs(11)
            rsizelabel=Rs(12)
            rverticalw=Rs(13)
            rtorsion=Rs(14)
            rimpactr=Rs(15)
            rsafe=Rs(16)
            rfile=Rs(17)
            rstatus=Rs(18)
            reportnote=Rs(19)
            nfile=Rs(20)
            rtype=Rs(21)

            select case rstatus
                case "0"
                    rstatus_text = "사용중지"
                case "1"
                    rstatus_text = "사용중"   
            end select
        
        End if
    Rs.Close

    end if
    page_name="remain2.asp?"
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
<link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f8e7375b143214↩_fe6aacc29b2d266d396%7Emv2.png/v1/fill/w32%2Ch__32%2Clg_1%2Cusm0.661.00___0.01/76309f8e7375b143214↩_fe6aacc29b2d266d396%7Emv2.png" />
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
<style>
    a:link {
        color: #070707;
        text-decoration: none;
    }
    a:visited{
        color: #070707;
        text-decoration: none;  
    }
    a:hover{
        color: #070707;
        text-decoration: none;         
    }
</style>
<script>
    function validateform1(){
        if(document.shr2.ron.value == "" ){
            alert("접수번호를 입력해주십시오.")
        return
        }
        if(document.shr2.rname.value == "" ){
            alert("시료명을 입력해주십시오.")
        return
        }
        if(document.shr2.ruse.value == "" ){
            alert("성적서 용도를 입력해주십시오.")
        return
        }
        if(document.shr2.rtdate.value == "" ){
            alert("발급일자를 입력해주십시오.")
        return
        }         
        if(document.shr2.rtype.value == "" ){
            alert("시료명을 입력해주십시오.")
        return
        }               
        else {
            document.shr2.submit();
        }
    }
    function validateform2(){
        if(document.shr2.ruse.value == "" ){
            alert("성적서 용도를 입력해주십시오.")
        return
        }
        if(document.shr2.rtdate.value == "" ){
            alert("발급일자를 입력해주십시오.")
        return
        } 
        if(document.shr2.otype.value == "" ){
            alert("계폐방식을 선택해주십시오.")
        return
        } 
        if(document.shr2.rwtype.value == "" ){
            alert("창호타입을 선택해주십시오.")
        return
        } 
        if(document.shr2.rwidth.value == "" ){
            alert("프레임 폭을 입력해주십시오.")
        return
        }
        if(document.shr2.frametype.value == "" ){
            alert("프레임재질을 선택해주십시오.")
        return
        } 
        if(document.shr2.ginfo.value == "" ){
            alert("유리사양을 선택해주십시오.")
        return
        } 
        if(document.shr2.gspecific.value == "" ){
            alert("유리상세를 선택해주십시오.")
        return
        }                  
        if(document.shr2.rinsp.value == "" ){
            alert("단열성능을 입력해주십시오.")
        return
        } 
        if(document.shr2.rherp.value == "" ){
            alert("기밀성능을 입력해주십시오.")
        return
        } 
        if(document.shr2.rwatp.value == "" ){
            alert("수밀성능을 선택해주십시오.")
        return
        } 
        if(document.shr2.rpa.value == "" ){
            alert("내풍압성능을 선택해주십시오.")
        return
        }
        if(document.shr2.roc.value == "" ){
            alert("개폐력/개폐반복을 선택해주십시오.")
        return
        }
        if(document.shr2.rsizelabel.value == "" ){
            alert("치수/표시사항을 선택해주십시오.")
        return
        }      
        if(document.shr2.rverticalw.value == "" ){
            alert("연직하중을 선택해주십시오.")
        return
        } 
        if(document.shr2.rtorsion.value == "" ){
            alert("비틀림강도를 선택해주십시오.")
        return
        } 
        if(document.shr2.rimpactr.value == "" ){
            alert("내충격성을 선택해주십시오.")
        return
        } 
        if(document.shr2.rsafe.value == "" ){
            alert("안정성을 선택해주십시오.")
        return
        }
        else {
            document.shr2.submit();
        }
    }

        
    function smwindow(str){
        newwin=window.open(str,'win1','scrollbars=yes,menubar=no,statusbar=no,status=no,width=500,height=400,top=50,left=50');
        newwin.focus();    
    }

    function smwindow2(str){
        newwin=window.open(str,'win2','scrollbars=yes,menubar=no,statusbar=no,status=no,width=1000,height=700,top=50,left=50');
        newwin.focus();    
    }

    function rfdel(ridx){
        if(confirm('정말로 삭제하시겠습니까?')) {
            location.href="reportfiledeldb.asp?ridx="+ridx;
        }
    }

    function nfdel(ridx){
        if(confirm('정말로 삭제하시겠습니까?')) {
            location.href="reportfiledeldb2.asp?ridx="+ridx;
        }
    }
</script>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG2.asp"-->
    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                <!--내용입력시작-->
                    <div class=" py-5 container text-center">
                    <%
                    if ridx<>"" then
                    %>
                        <form name="shr2" action="rmain2db.asp" method="post" ENCTYPE="multipart/form-data">
                            <input type="hidden" class="form-control" name="ridx" value="<%=ridx%>">
                            <input type="hidden" class="form-control" name="clickacfidx" value="<%=clickacfidx%>">
                            <input type="hidden" class="form-control" name="clickaacfidx" value="<%=clickaacfidx%>">

                            <div class="input-group mb-2">
                                <span class="input-group-text">접수번호</span>
                                <input type="text" class="form-control" name="ron" value="<%=ron%>">
                                <span class="input-group-text">시료명</span>
                                <input type="text" class="form-control" name="rname" value="<%=rname%>">                                
                            </div>

                            <div class="input-group mb-2">                              
                                <span class="input-group-text">성적서 용도</span>
                                <select  name="ruse" class="form-control">
                                    <option value="">선택</option>
                                    <option value="1" <% If ruse="1" Then Response.write "selected" End if %>>품질관리용</option>
                                    <option value="2" <% If ruse="2" Then Response.write "selected" End if %>>효율관기자재 인리증용</option>
                                    <option value="3" <% If ruse="3" Then Response.write "selected" End if %>>건축용고효율에너지기자재 인증용</option>
                                    <option value="4" <% If ruse="4" Then Response.write "selected" End if %>>기타서류</option>
                                </select>
                                
                                <span class="input-group-text">품목</span>
                                <div class="form-control text-start" style="width:2%;height:100%;padding:5 5 5 5;">    
                                    <select class="form-control" name="rtype">
                                        <option value="">선택</option>
                                        <option value="1" <% If rtype="1" Then Response.write "selected" End if %>>일반 AL자동</option>
                                        <option value="2" <% If rtype="2" Then Response.write "selected" End if %>>복층 AL자동</option>
                                        <option value="3" <% If rtype="3" Then Response.write "selected" End if %>>단열 AL자동</option>
                                        <option value="4" <% If rtype="4" Then Response.write "selected" End if %>>삼중 AL자동</option>
                                        <option value="5" <% If rtype="5" Then Response.write "selected" End if %>>일반 100바  AL자동</option>
                                        <option value="6" <% If rtype="6" Then Response.write "selected" End if %>>일반 AL프레임</option>
                                        <option value="7" <% If rtype="7" Then Response.write "selected" End if %>>단열 AL프레임</option>
                                        <option value="8" <% If rtype="8" Then Response.write "selected" End if %>>단열 스텐자동</option>
                                        <option value="9" <% If rtype="9" Then Response.write "selected" End if %>>삼중 스텐자동</option>
                                        <option value="10" <% If rtype="10" Then Response.write "selected" End if %>>단열 이중스텐자동</option>
                                        <option value="11" <% If rtype="11" Then Response.write "selected" End if %>>단열 스텐프레임</option>
                                        <option value="12" <% If rtype="12" Then Response.write "selected" End if %>>삼중 스텐프레임</option>
                                        <option value="13" <% If rtype="13" Then Response.write "selected" End if %>>일반 절곡</option>
                                        <option value="14" <% If rtype="14" Then Response.write "selected" End if %>>기타</option>
                                        <option value="15" <% If rtype="15" Then Response.write "selected" End if %>>포켓 단열 스텐자동</option>
                                    </select>
                                </div>

                                <span class="input-group-text">발급일자</span>
                                <input type="date" class="form-control" name="rtdate" value="<%=rtdate%>"> 
                                <span class="input-group-text">사용여부</span>
                                <div class="form-control text-start" style="width:1%;padding:5 5 5 5;">  
                                    <select  name="rstatus" class="form-control"> 
                                        <option value="1" <% If rstatus="1" Then Response.write "selected" End if %>>사용중</option>               
                                        <option value="0" <% If rstatus="0" Then Response.write "selected" End if %>>사용안함</option>
                                    </select>                                                                  
                                </div>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">깊이</span>
                                    <div class="form-control text-start" style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start" style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT A.rsidx, B.fname from Tk_reportsub A Join tk_reportm B on A.rfidx = B.fidx Where A.ridx='"&ridx&"' and A.rftype=6"
                                            
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                rsidx=RS(0)
                                                fname=RS(1)
                                            %>
                                            
                                                <%=fname%> &nbsp;

                                            <%
                                            Rs.MoveNext
                                            Loop
                                            End If
                                            Rs.Close
                                            %>
                                        </div>
                                    </div>
                                <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shrsing.asp?ridx=<%=ridx%>&ftype=6&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">수정</button>

                                    <span class="input-group-text">너비</span>
                                    <div class="form-control text-start" style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start" style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT A.rsidx, B.fname from Tk_reportsub A Join tk_reportm B on A.rfidx = B.fidx Where A.ridx='"&ridx&"' and A.rftype=7"
                                            
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                rsidx=RS(0)
                                                fname=RS(1)
                                            %>

                                                <%=fname%> &nbsp;

                                            <%
                                            Rs.MoveNext
                                            Loop
                                            End If
                                            Rs.Close
                                            %>
                                        </div>
                                    </div>
                                <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shrsing.asp?ridx=<%=ridx%>&ftype=7&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">수정</button>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">개폐방식</span>
                                    <div class="form-control text-start" style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start" style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT A.rsidx, B.fname from Tk_reportsub A Join tk_reportm B on A.rfidx = B.fidx Where A.ridx='"&ridx&"' and A.rftype=8"
                                            
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                rsidx=RS(0)
                                                fname=RS(1)
                                            %>
                                            
                                                <%=fname%> &nbsp;

                                            <%
                                            Rs.MoveNext
                                            Loop
                                            End If
                                            Rs.Close
                                            %>
                                        </div>
                                    </div>
                                <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shr.asp?ridx=<%=ridx%>&ftype=8&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">추가</button>

                                    <span class="input-group-text">프레임재질</span>
                                    <div class="form-control text-start" style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start" style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT A.rsidx, B.fname from Tk_reportsub A Join tk_reportm B on A.rfidx = B.fidx Where A.ridx='"&ridx&"' and A.rftype=1"
                                            
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                rsidx=RS(0)
                                                fname=RS(1)
                                            %>

                                                <%=fname%> &nbsp;

                                            <%
                                            Rs.MoveNext
                                            Loop
                                            End If
                                            Rs.Close
                                            %>
                                        </div>
                                    </div>
                                <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shr.asp?ridx=<%=ridx%>&ftype=1&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">추가</button>
                                      
                            </div>

                            <div class="input-group mb-2">                                      
                                    <span class="input-group-text">유리사양</span>
                                    <div class="form-control text-start" style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start" style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT A.rsidx, B.fname from Tk_reportsub A Join tk_reportm B on A.rfidx = B.fidx Where A.ridx='"&ridx&"' and A.rftype=3"
                                            
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                rsidx=RS(0)
                                                fname=RS(1)
                                            %>

                                                <%=fname%> &nbsp;

                                            <%
                                            Rs.MoveNext
                                            Loop
                                            End If
                                            Rs.Close
                                            %> 
                                        </div>
                                    </div>      
                                    <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shrsing.asp?ridx=<%=ridx%>&ftype=3&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">추가</button>
                                    
                                    <span class="input-group-text">유리상세</span>
                                    <div class="form-control text-start" style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start" style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT A.rsidx, B.fname from Tk_reportsub A Join tk_reportm B on A.rfidx = B.fidx Where A.ridx='"&ridx&"' and A.rftype=4"

                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                rsidx=RS(0)
                                                rfname=RS(1)
                                            

                                            k = k + 1

                                            if k = 1 then 
                                              afname=rfname
                                            else
                                              afname=afname&" + "&rfname
                                            end if 

                                            
                                            Rs.MoveNext
                                            Loop
                                            End If
                                            Rs.Close
                                            %>   

                                            <%=afname%>

                                        </div>
                                    </div> 
                                    <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shr.asp?ridx=<%=ridx%>&ftype=4&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">추가</button>
                            </div>  
                                
                            <div class="input-group mb-2"> 
                                <span class="input-group-text">창호타입</span>
                                    <div class="form-control text-start" style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start " style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT B.fname from tk_reportsub A Join tk_reportm B On A.rfidx=B.fidx Where ridx='"&ridx&"' and rftype='5' "
                                            
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                                rwtype=RS(0)
                                            %>

                                                <%=rwtype%>

                                            <%
                                            End If
                                            Rs.Close
                                            %> 
                                        </div>
                                    </div>      
                                    <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shrsing.asp?ridx=<%=ridx%>&ftype=5&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">수정</button>                                     
                                
                                <span class="input-group-text">프레임폭</span>   
                                    <div class="form-control text-start" style="width:13%;height:100%;padding:5 5 5 5;">
                                        <input type="text" class="form-control" name="rwidth" value="<%=rwidth%>"> 
                                    </div>       
                    
                                <span class="input-group-text">간봉재질</span>
                                    <div class="form-control text-start" style="width:22%;padding:5 5 5 5;">
                                        <div class="form-control text-start " style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT B.fname from tk_reportsub A Join tk_reportm B On A.rfidx=B.fidx Where ridx='"&ridx&"' and rftype='2'"
                                            
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                                kname=RS(0)
                                            %>

                                                <%=kname%>

                                            <%
                                            End If
                                            Rs.Close
                                            %> 
                                        </div>
                                    </div>      
                                    <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shrsing.asp?ridx=<%=ridx%>&ftype=2&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">수정</button> 
                            </div> 
                                
                            <div class="input-group mb-2">    
                                <span class="input-group-text">단열성능</span>  
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;">     
                                    <input type="text" class="form-control" name="rinsp" value="<%=rinsp%>">
                                </div>
                                    
                                <span class="input-group-text">기밀성능</span>
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;">   
                                    <input type="text" class="form-control" name="rherp" value="<%=rherp%>"> 
                                </div>

                                <span class="input-group-text">수밀성능</span>
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;">   
                                    <select class="form-control" name="rwatp">
                                        <option value="">선택</option>
                                        <option value="X" <% If rwatp="X" Then Response.write "selected" End if %>>X</option>
                                        <option value="10등급 이상없음" <% If rwatp="10등급 이상없음" Then Response.write "selected" End if %>>10등급 이상없음</option>
                                    </select>
                                </div> 

                                <span class="input-group-text">내풍압성능</span>
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;">   
                                    <select class="form-control" name="rpa">
                                        <option value="">선택</option>
                                        <option value="X" <% If rpa="X" Then Response.write "selected" End if %>>X</option>
                                        <option value="80등급 이상없음" <% If rpa="80등급 이상없음" Then Response.write "selected" End if %>>80등급 이상없음</option>
                                        <option value="160등급 이상없음" <% If rpa="160등급 이상없음" Then Response.write "selected" End if %>>160등급 이상없음</option>
                                    </select>
                                </div>
                                    
                                <span class="input-group-text">개폐력/개폐반복</span>
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;">   
                                    <select class="form-control" name="roc">
                                        <option value="">선택</option>
                                        <option value="X" <% If roc="X" Then Response.write "selected" End if %>>X</option>
                                        <option value="이상없음/이상없음" <% If roc="이상없음/이상없음" Then Response.write "selected" End if %>>이상없음/이상없음</option>
                                        <option value="이상없음/10만회" <% If roc="이상없음/10만회" Then Response.write "selected" End if %>>이상없음/10만회</option>
                                    </select>
                                </div>
                            </div>

                            <div class="input-group mb-2">    
                                <span class="input-group-text">치수/표시사항</span>   
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;"> 
                                    <select class="form-control" name="rsizelabel">
                                        <option value="">선택</option>
                                        <option value="X" <% If rsizelabel="X" Then Response.write "selected" End if %>>X</option>
                                        <option value="이상없음/이상없음" <% If rsizelabel="이상없음/이상없음" Then Response.write "selected" End if %>>이상없음/이상없음</option>
                                    </select>      
                                </div>  

                                <span class="input-group-text">연직하중</span>
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;">    
                                    <select class="form-control" name="rverticalw">
                                        <option value="">선택</option>
                                        <option value="X" <% If rverticalw="X" Then Response.write "selected" End if %>>X</option>
                                        <option value="50등급 이상없음" <% If rverticalw="50등급 이상없음" Then Response.write "selected" End if %>>50등급 이상없음</option>
                                    </select>
                                </div>

                                <span class="input-group-text">비틀림강도</span>
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;">    
                                    <select class="form-control" name="rtorsion">
                                        <option value="">선택</option>
                                        <option value="X" <% If rtorsion="X" Then Response.write "selected" End if %>>X</option>
                                        <option value="20등급 이상없음" <% If rtorsion="20등급 이상없음" Then Response.write "selected" End if %>>20등급 이상없음</option>
                                    </select> 
                                </div>

                                <span class="input-group-text">내충격성</span>
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;">    
                                    <select class="form-control" name="rimpactr">
                                        <option value="">선택</option>
                                        <option value="X" <% If rimpactr="X" Then Response.write "selected" End if %>>X</option>
                                    </select>   
                                </div>

                                <span class="input-group-text">안정성</span>
                                <div class="form-control text-start" style="width:10%;height:100%;padding:5 5 5 5;">    
                                    <select class="form-control" name="rsafe">
                                        <option value="">선택</option>
                                        <option value="X" <% If rsafe="X" Then Response.write "selected" End if %>>X</option>
                                        <option value="손끼임 방지 장치 보유" <% If rsafe="손끼임 방지 장치 보유" Then Response.write "selected" End if %>>손끼임 방지 장치 보유</option>
                                    </select>
                                </div>
                            </div>

                            <div class="input-group mb-2"> 
                                <span class="input-group-text">성적서 파일 첨부</span>
                                <input type="file" class="form-control" name="file1">
                            </div> 

                            <div class="input-group mb-2"> 
                                <span class="input-group-text">첨부된 파일</span>
                                <div class="form-control text-start " style="width:10%;height:100%;padding:5 5 5 5;">
                                    <button type="button" class="btn btn-outline-danger" Onclick="rfdel(<%=ridx%>);"><%=rfile%></button>
                                </div>
                            </div> 

<!--
                            <div class="input-group mb-2">
                                <span class="input-group-text ">납품확인서 파일 첨부</span> 
                                <input type="file" class="form-control" name="file2"> 
                                <button type="button" class="btn btn-outline-secondary" Onclick="nfdel(<%=ridx%>);"><%=nfile%></button>
                            </div> 
-->

                            <div class="input-group mb-2">
                                <span class="input-group-text">특이사항</span>
                                    <div class="form-control text-start">    
                                        <textarea name="reportnote" style="width:100%;height:100%;padding:5 5 5 5;"><%=reportnote%></textarea>
                                    </div>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">연결된 품목</span>
                                    <div class="form-control text-start" style="width:15%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT B.SJB_TYPE_NO, B.SJB_barlist from reportlink A Join TNG_SJB B on A.sjbidx = B.SJB_IDX Where A.ridx='"&ridx&"'"
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                sjb_type_no=RS(0)
                                                sjb_barlist=RS(1)
                                            
                                            Select case sjb_type_no
                                                case 1
                                                    sjb_type_name="일반 AL 자동"
                                                case 2
                                                    sjb_type_name="복층 AL자동"
                                                case 3
                                                    sjb_type_name="단열 AL자동"
                                                case 4
                                                    sjb_type_name="삼중 AL자동"
                                                case 5
                                                    sjb_type_name="일반 100바  AL자동"
                                                case 6
                                                    sjb_type_name="일반 AL프레임"
                                                case 7
                                                    sjb_type_name="단열 AL프레임"
                                                case 8
                                                    sjb_type_name="단열 스텐자동"
                                                case 9
                                                    sjb_type_name="삼중 스텐자동"
                                                case 10
                                                    sjb_type_name="단열 이중스텐자동"
                                                case 11
                                                    sjb_type_name="단열 스텐프레임"
                                                case 12
                                                    sjb_type_name="삼중 스텐프레임"
                                                case 13
                                                    sjb_type_name="일반 절곡"
                                                case 14
                                                    sjb_type_name="기타"
                                                case 15
                                                    sjb_type_name="포켓 단열 스텐자동"
                                            End Select                                            
                                            
                                              nsjb_type_name = sjb_type_name
                                            %>
                                            
                                                <%=nsjb_type_name%>&nbsp;(<%=sjb_barlist%>)<br>

                                            <%
                                            Rs.MoveNext
                                            Loop
                                            End If
                                            Rs.Close
                                            %>   
                                    </div> 
                                    <button type="button" class="btn btn-outline-primary" Onclick="smwindow2('reportlink.asp?ridx=<%=ridx%>&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">설정</button>
                            </div>

                                <div class="input-group mb-3">
                                    <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('remainlistorg2.asp?clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">목록보기</button>
                                    <button type="button" class="btn btn-primary" Onclick="validateform1();">저장</button>
                                </div>

                            <% 
                            SQL="SELECT A.rsidx from Tk_reportsub A Where A.ridx='"&ridx&"' and A.rftype=9"
                                Set RsC=dbcon.execute (SQL)
                                    If not (RsC.BOF or RsC.EOF) then
                                        otype=RsC(0)
                                    else
                                        otype=""
                                    End If
                                RsC.Close
                            SQL="SELECT A.rsidx from Tk_reportsub A Where A.ridx='"&ridx&"' and A.rftype=1"
                                Set Rs1=dbcon.execute (SQL)
                                    If not (Rs1.BOF or Rs1.EOF) then
                                        frametype=Rs1(0)
                                    else 
                                        frametype=""
                                    End If
                                Rs1.Close
                            SQL="SELECT A.rsidx from Tk_reportsub A Where A.ridx='"&ridx&"' and A.rftype=3"
                                Set Rs2=dbcon.execute (SQL)
                                    If not (Rs2.BOF or Rs2.EOF) then
                                        ginfo=Rs2(0)
                                    else
                                        ginfo=""
                                    End If
                                Rs2.Close
                            SQL="SELECT A.rsidx from Tk_reportsub A Where A.ridx='"&ridx&"' and A.rftype=4"
                                Set Rs3=dbcon.execute (SQL)
                                    If not (Rs3.BOF or Rs3.EOF) then
                                        gspecific=Rs3(0)
                                    else
                                        gspecific=""
                                    End If
                                Rs3.Close
                            %>
                            <input type="hidden" class="form-control" name="otype" value="<%=otype%>">
                            <input type="hidden" class="form-control" name="frametype" value="<%=frametype%>">
                            <input type="hidden" class="form-control" name="ginfo" value="<%=ginfo%>">
                            <input type="hidden" class="form-control" name="gspecific" value="<%=gspecific%>">
                        </form>
                    <% End if %>
                    </div>
                    <!--입력종료-->
                </div>
            </div>
        </main>

        <!--Footer 시작-->
        Coded By 원준 
        <!--Footer 끝-->

    </div>
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