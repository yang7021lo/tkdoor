<!--성적서 등록-->
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
    projectname="성적서 품목등록"
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

    page_name="reg.asp"
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
    function validateform(){
        if(document.frmMain.fname.value == "" ){
            alert("이름을 입력해주십시오.")
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
                    <div class=" py-5 container text-center card card-body">
                        <form name="frmMain" action="regdb.asp" method="post" ENCTYPE="multipart/form-data">
                        <!--파일 업로드를 위해서 ENCTYPE="multipart/form-data"가 선언됨-->
                            <div class="input-group mb-3">
                                <h6>page_name</h6>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">이름</span>
                                <input type="text" class="form-control" name="fname" value="">
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">상태</span>&nbsp;&nbsp;
                                <div class=" text-start ms-0" style="width:80%;padding:5 5 5 5;">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="fstatus" value="0" <% if rfstatus="0" then %>checked <% end if %>>
                                        <label class="form-check-label" >사용안함</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="fstatus" value="1" <% if rfstatus="1" then %>checked <% end if %>>
                                        <label class="form-check-label" >사용</label>
                                    </div>          
                                </div>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">구분</span>&nbsp;&nbsp;
                                <div class=" text-start ms-0" style="width:80%;padding:5 5 5 5;">
                                    <div class="form-check form-check-inline">       
                                        <input class="form-check-input" name="ftype" type="radio" value="1" <% if rftype="1" or rftype="" then %> checked <% end if %>>           
                                        <label class="form-check-label" >프레임</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" name="ftype" type="radio" value="2" <% if rftype="2" then %> checked <% end if %>>
                                        <label class="form-check-label" >간봉</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" name="ftype" type="radio" value="3" <% if rftype="3" then %> checked <% end if %>>
                                        <label class="form-check-label" >유리사양</label>
                                    </div>  
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" name="ftype" type="radio" value="4" <% if rftype="4" then %> checked <% end if %>>
                                        <label class="form-check-label" >유리상세A</label>
                                    </div>                         
                                    <!-- 
                                    <div class="form-check form-check-inline">       
                                        <input class="form-check-input" name="ftype" type="radio" value="5" <% if rftype="5" or rftype="" then %> checked <% end if %>>           
                                        <label class="form-check-label" >유리상세B</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" name="ftype" type="radio" value="6" <% if rftype="6" then %> checked <% end if %>>
                                        <label class="form-check-label" >유리상세C</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" name="ftype" type="radio" value="7" <% if rftype="7" then %> checked <% end if %>>
                                        <label class="form-check-label" >유리상세D</label>
                                    </div>  
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" name="ftype" type="radio" value="8" <% if rftype="8" then %> checked <% end if %>>
                                        <label class="form-check-label" >유리상세E</label>
                                    </div>  
                                    -->    
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" name="ftype" type="radio" value="9" <% if rftype="9" then %> checked <% end if %>>
                                        <label class="form-check-label" >개폐방식</label>
                                    </div> 
                                </div>
                            </div>

                            <div class="input-group mb-3">
                                <button type="button" class="btn btn-outline-primary" Onclick="validateForm();">등록</button>
                                <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('reglist.asp');">목록보기</button>
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