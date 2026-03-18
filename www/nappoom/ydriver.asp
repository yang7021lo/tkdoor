운전자명
차량번호를
전번
지역
착불여부

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
    projectname="운전기사 정보등록"
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
    

    page_name="ydriver.asp?"
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
    function validateForm(){
        if(document.frmMain.dname.value == "" ){
            alert("운전자 성명을 입력해주십시오.")
        return
        }
        if(document.frmMain.dnum.value == "" ){
            alert("운전자 차량번호를 입력해주십시오.")
        return
        }
        if (frmMain.dtel.value.length < 13){
                alert("운전자 전화 번호는 13자리입니다. 모두 입력해 주세요");
        return
        }
        if(document.frmMain.dloc.value == "" ){
            alert("지역을 입력해주십시오.")
        return
        }
        if(document.frmMain.dcod.value == "" ){
            alert("착불여부를 선택해주십시오.")
        return
        }
        if(document.frmMain.dstatus.value == "" ){
            alert("상태를 선택해주십시오.")
        return
        }
        else {
            document.frmMain.submit();
        }
    }

        function inputPhoneNumber(obj){
            var number = obj.value.replace(/[^0-9]/g,"");
            var phone = "";

            if(number.length < 4) {
                return number;
            }else if(number.length < 7) {
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3);
            }else if(number.length < 11) {
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3,3);
                phone += "-";
                phone += number.substr(6);
            }else{
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3,4);
                phone += "-";
                phone += number.substr(7);
            }
            obj.value = phone;
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
                        <form name="frmMain" action="ydriverdb.asp" method="post" ENCTYPE="multipart/form-data">
                            <div class="input-group mb-3">
                                <h6>운전기사 등록</h6>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">성명</span>
                                <input type="text" class="card form-control" name="dname" value="">
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">차량번호</span>
                                <input type="text" class="card form-control" name="dnum" value="">
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">전화번호</span>
                                <input type="tel" class="card form-control" onkeyup="inputPhoneNumber(this);" maxlength="13" name="dtel" value="">
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">지역</span>
                                <input type="text" class="card form-control" name="dloc" value="">
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">착불 여부</span>
                                <div class="form-control text-start" style="width:80%;padding:5 5 5 5;">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="dcod" value="0" <% if dcod="0" then %>checked <% end if %>>
                                        <label class="form-check-label" >착불 아님</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="dcod" value="1" <% if dcod="1" then %>checked <% end if %>>
                                        <label class="form-check-label" >착불</label>
                                    </div>          
                                </div>
                            </div>

                            <div class="input-group mb-2">
                                <span class="input-group-text">상태</span>
                                <div class="form-control text-start" style="width:80%;padding:5 5 5 5;">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="dstatus" value="0" <% if dstatus="0" then %>checked <% end if %>>
                                        <label class="form-check-label" >비활성화</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="dstatus" value="1" <% if dstatus="1" then %>checked <% end if %>>
                                        <label class="form-check-label" >활성화</label>
                                    </div>          
                                </div>
                            </div>


                            <div class="input-group mb-3">
                                <button type="button" class="btn btn-outline-primary" Onclick="validateForm();">등록</button>
                                <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('ydriverlist.asp');">목록보기</button>
                            </div>
                        </form>
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
















