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
    
    if request("gotopage")="" then
        gotopage=1
    else
        gotopage=request("gotopage")
    end if

    page_name="remain.asp?"
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
        if(document.frmMain.ron.value == "" ){
            alert("접수번호를 입력해주십시오.")
        return
        }
        if(document.frmMain.rname.value == "" ){
            alert("시료명을 입력해주십시오.")
        return
        }
        if(document.frmMain.ruse.value == "" ){
            alert("성적서 용도를 입력해주십시오.")
        return
        }
        if(document.frmMain.rtdate.value == "" ){
            alert("발급일자를 입력해주십시오.")
        return
        }         
        if(document.frmMain.rname.value == "" ){
            alert("시료명을 입력해주십시오.")
        return
        }               
        else {
            document.frmMain.submit();
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
                        <form name="frmMain" action="remaindb.asp" method="post" ENCTYPE="multipart/form-data">
                            
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
                                    <option value="1">품질관리용</option>
                                    <option value="2">효율관기자재 인리증용</option>
                                    <option value="3">건축용고효율에너지기자재 인증용</option>
                                    <option value="4">기타서류</option>
                                </select>
                                
                                <span class="input-group-text">품목</span>
                                <div class="form-control text-start " style="width:2%;height:100%;padding:5 5 5 5;">    
                                    <select class="form-control" name="sjb_type_no">
                                        <option value="">선택</option>
                                        <option value="1" <% If sjb_type_no="1" Then Response.write "selected" End if %>>일반 AL자동</option>
                                        <option value="2" <% If sjb_type_no="2" Then Response.write "selected" End if %>>복층 AL자동</option>
                                        <option value="3" <% If sjb_type_no="3" Then Response.write "selected" End if %>>단열 AL자동</option>
                                        <option value="4" <% If sjb_type_no="4" Then Response.write "selected" End if %>>삼중 AL자동</option>
                                        <option value="5" <% If sjb_type_no="5" Then Response.write "selected" End if %>>일반 100바  AL자동</option>
                                        <option value="6" <% If sjb_type_no="6" Then Response.write "selected" End if %>>일반 AL프레임</option>
                                        <option value="7" <% If sjb_type_no="7" Then Response.write "selected" End if %>>단열 AL프레임</option>
                                        <option value="8" <% If sjb_type_no="8" Then Response.write "selected" End if %>>단열 스텐자동</option>
                                        <option value="9" <% If sjb_type_no="9" Then Response.write "selected" End if %>>삼중 스텐자동</option>
                                        <option value="10" <% If sjb_type_no="10" Then Response.write "selected" End if %>>단열 이중스텐자동</option>
                                        <option value="11" <% If sjb_type_no="11" Then Response.write "selected" End if %>>단열 스텐프레임</option>
                                        <option value="12" <% If sjb_type_no="12" Then Response.write "selected" End if %>>삼중 스텐프레임</option>
                                        <option value="13" <% If sjb_type_no="13" Then Response.write "selected" End if %>>일반 절곡</option>
                                        <option value="14" <% If sjb_type_no="14" Then Response.write "selected" End if %>>기타</option>
                                        <option value="15" <% If sjb_type_no="15" Then Response.write "selected" End if %>>포켓 단열 스텐자동</option>
                                    </select>
                                </div>

                                <span class="input-group-text">발급일자</span>
                                <input type="date" class="form-control" name="rtdate" value="<%=rtdate%>"> 
                                <button type="button" class="btn btn-outline-primary" Onclick="validateform1();">등록 시작</button>
                            </div>
                        </form>
                    </div>
                    <!--입력종료-->
                </div>
            </div>
        </main>

        <!--Footer 시작-->
        Coded By 림 
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