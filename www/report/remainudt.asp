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
    projectname="성적서 등록"
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

    if ridx<>"" then
    SQL=" Select ron, rname, ruse, rtdate from tk_report where ridx='"&ridx&"' "
    Rs.open SQL,Dbcon
    If not (Rs.BOF or Rs.EOF) then

        ron=Rs(0)
        rname=Rs(1)
        ruse=Rs(2)
        rtdate=Rs(3)

        select case ruse
            
            case "1"
                ruse_text="품질관리용"
            case "2"
                ruse_text="효율관리 기자재 인증용"
            case "3"
                ruse_text="건축용 고효율 에너지기자재 인증용"
            case "4"
                ruse_text="기타서류"

        end select

    End if
    Rs.Close

    end if


    if request("gotopage")="" then
        gotopage=1
    else
        gotopage=request("gotopage")
    end if

    page_name="remainudt.asp?"
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
        if(document.shr2.rwidth.value == "" ){
            alert("프레임 폭을 입력해주십시오.")
        return
        }
        if(document.shr2.rinsp.value == "" ){
            alert("단열성능을 입력해주십시오.")
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
        function del(ridx){
        if(confirm('정말로 삭제하시겠습니까?')) {
            location.href="remaindeldb.asp?ridx="+ridx;
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
                            
                        <div class="input-group mb-2">
                            <span class="input-group-text">접수번호</span>
                            <input type="text" class="form-control" name="ron" value="<%=ron%>" readonly>
                            <span class="input-group-text">시료명</span>
                            <input type="text" class="form-control" name="rname" value="<%=rname%>" readonly>                                
                            <span class="input-group-text">성적서 용도</span>
                            <input type="text" class="form-control" name="ruse" value="<%=ruse_text%>" readonly>
                            <span class="input-group-text">발급일자</span>
                            <input type="date" class="form-control" name="rdate" value="<%=rdate%>" readonly> 
                        </div>

                        <%
                        if ridx="" then
                        %>

                        <form name="shr2" action="rmain2db.asp" method="post" ENCTYPE="multipart/form-data">
                            <input type="hidden" class="form-control" name="ridx" value="<%=ridx%>">

                            <div class="input-group mb-2">
                                <span class="input-group-text">개폐방식</span>
                                    <div class=" text-start ms-0" style="width:15%;padding:5 5 5 5;">
                                        <%
                                        SQL="SELECT A.rsidx, B.fname from Tk_reportsub A Join tk_reportm B on A.rfidx = B.fidx Where A.ridx='"&ridx&"' and A.rftype=9"
                                        
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

                                <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shr.asp?ridx=<%=ridx%>&ftype=9');">추가</button>
                                <span class="input-group-text">창호타입</span>
                                <div class=" card text-start ms-0" style="padding:5 5 5 5;">
                                    <!--창호타입은 하나만 선택해 등록하므로 tk_report TB의 rwtype 컬럼에 int 형식으로 등록한다.
                                    만약 복수의 선택이 필요하다면 tk_reportSub TB를 활용해야 한다.-->
                                    <select name="rwtype" class="form-control">
                                        <option value="1" <% If rwtype="1" Then Response.write "selected" End if %>>단창</option>
                                        <option value="2" <% If rwtype="2" Then Response.write "selected" End if %>>문(1.0*2.1)</option>
                                        <option value="3" <% If rwtype="3" Then Response.write "selected" End if %>>문(2.0*2.0)</option>
                                    </select>
                                </div>
                                    
                                <span class="input-group-text">프레임폭</span>      
                                <div class=" card text-start ms-0" style="padding:5 5 5 5;">
                                    <input type="text" class="form-control" name="rwidth" value=""> 
                                </div>
                                
                                <span class="input-group-text">간봉재질</span>
                                <div class=" card text-start ms-0" style="width:22%;padding:5 5 5 5;">
                                    <select name="" class="form-control">
                                        <% 
                                        SQL= "select fidx,fname from tk_reportm where ftype=2 and fstatus=1 "
                                        Set Rs=dbcon.execute (SQL)
                                        If not (Rs.BOF or Rs.EOF) then
                                        Do while not Rs.EOF
                                        rfidx=Rs(0)
                                        rfname=Rs(1)
                                        %>
                                    
                                        <option value="<%=rfidx%>"><%=rfname%></option>
                            
                                        <%
                                        Rs.MoveNext
                                        Loop
                                        End If
                                        Rs.Close
                                        %>
                                    </select>
                                </div>
                            </div>   
                            
                            <div class="input-group mb-2">
                                <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shr.asp?ridx=<%=ridx%>&ftype=9');">추가</button>
                                <span class="input-group-text">프레임재질</span>
                                <div class=" card text-start " style="width:15%;padding:5 5 5 5;">
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

                                    <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shr.asp?ridx=<%=ridx%>&ftype=1');">추가</button>
                                    <span class="input-group-text">유리사양</span>
                                    <div class=" card text-start " style="width:15%;padding:5 5 5 5;">
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

                                    <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shr.asp?ridx=<%=ridx%>&ftype=3');">추가</button>
                                    <span class="input-group-text">유리상세</span>
                                    <div class=" card text-start " style="width:15%;padding:5 5 5 5;">
                                        <%
                                        SQL="SELECT A.rsidx, B.fname from Tk_reportsub A Join tk_reportm B on A.rfidx = B.fidx Where A.ridx='"&ridx&"' and A.rftype=4"
                                        
                                        Set Rs=dbcon.execute (SQL)
                                        If not (Rs.BOF or Rs.EOF) then
                                        Do while not Rs.EOF
                                            rsidx=RS(0)
                                            fname=RS(1)
                                        %>

                                        <%=rfname%> &nbsp;

                                        <%
                                        Rs.MoveNext
                                        Loop
                                        End If
                                        Rs.Close
                                        %>   
                                    </div> 
                                    <button type="button" class="btn btn-outline-primary" Onclick="smwindow('shr.asp?ridx=<%=ridx%>&ftype=4');">추가</button>
                            </div>

                            <div class="input-group mb-2">    
                                <span class="input-group-text">단열성능</span>   
                                <input type="text" class="form-control" name="rinsp" value="<%=rinsp%>"> 
                                <span class="input-group-text">기밀성능</span>   
                                <input type="text" class="form-control" name="rherp" value="<%=rherp%>"> 
                                <span class="input-group-text">수밀성능</span>   
                                <input type="text" class="form-control" name="rwatp" value="<%=rwatp%>"> 
                                <span class="input-group-text">내풍압성능</span>   
                                <input type="text" class="form-control" name="rpa" value="<%=rpa%>"> 
                                <span class="input-group-text">개폐반복</span>   
                                <input type="text" class="form-control" name="roc" value="<%=roc%>"> 
                            </div>

                            <div class="input-group mb-2"> 
                                <input type="file" class="form-control" name="file1" value=""> 
                            </div>   

                            <div class="input-group mb-3">
                                <button type="button" class="btn btn-outline-secondary" Onclick="del('<%=ridx%>');">완전삭제</button>
                                <button type="button" class="btn btn-outline-primary" Onclick="validateForm();">등록</button>
                                <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('remainlist.asp');">목록보기</button>
                            </div>
                        </form>
                    <% End if %>
                    </div>
                    <!--입력종료-->
                </div>
            </div>
        </main>

        <!--Footer 시작-->
        Coded By 림 
        <!--Footer 끝-->

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