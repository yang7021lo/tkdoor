<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"

projectname="인증번호 재발급"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->
<%
	call dbOpen()
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")

mem_mbrname=Request("mem_mbrname")
gubun=Request("gubun")

if gubun="" then 
%>
<!DOCTYPE html>
<html lang="en">
  <head>

    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=projectname%></title>
    <!-- Favicon-->
    <link rel="icon" sizes="image/x-icon" href="/inc/tkico.png">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    <!-- 나의 스타일 추가 -->
    <link rel="stylesheet" href="/css/login.css?v=1234">
<script>
function validateFormlo()
{
   if (document.frmMainlo.mname.value=="")
   {
      alert("이름을 입력해 주시기 바랍니다.");
      document.frmMainlo.mname.focus();
      return
   }
   if (document.frmMainlo.mhp.value=="")
   {
      alert("등록된 휴대폰 번호를 입력해 주시기 바랍니다.");
      document.frmMainlo.mhp.focus();
      return
   }
	  document.frmMainlo.submit();
}

function ipboxfcs() {
var tbox = document.getElementById('tbox');
tbox.focus();
}
window.onload = ipboxfcs;

    //휴대번호
    function inputPhoneNumber(obj) {

    var number = obj.value.replace(/[^0-9]/g, "");
    var phone = "";


    if(number.length < 4) {
        return number;
    } else if(number.length < 7) {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3);
    } else if(number.length < 11) {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3, 3);
        phone += "-";
        phone += number.substr(6);
    } else {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3, 4);
        phone += "-";
        phone += number.substr(7);
    }
    obj.value = phone;
}

</script>
  </head>

<body class="bg-light">
    <div class="container d-flex justify-content-center align-items-center min-vh-100">
        <div class="row border rounded-5 p-3 bg-white shadow box-area">     

            <div class="col-md-6 rounded-4 d-flex justify-content-center align-items-center flex-column left-box" style="background-image: ;">
                <!--<img src="taekwang_logo.jpg" class="col-md-11 rounded-4 d-flex justify-content-center align-items-center flex-column left-box" alt="/etc/s1/signin.jpg">-->
                <img src="taekwang_logo.jpg" class="img-fluid" style="max-width:50%;">
            </div>

            <form name="frmMainlo" action="joinudt.asp" method="post" class="col-md-6 right-box">

                <div class="input-group mb-3"><br></div>

                <div class="header-text mb-4">
                    <h2 style="font-family: 'GmarB', sans-serif;">태광도어</h2>
                    <p>인증번호 재발급</p>
                </div>            

                <div class="input-group mb-2"><br></div>

                <input name="gubun" type="hidden" value="inju">	
                <div class="input-group mb-3">
                <input type="text" class="form-control form-control-lg bg-light fs-6" placeholder="이름" style="font-family: 'GmarM', sans-serif !important;" name="mname" required>
                </div>
                <div class="input-group mb-3">
                    <input type="tel" class="form-control form-control-lg bg-light fs-6" onkeyup="inputPhoneNumber(this);" placeholder="전화번호" name="mhp" maxlength="13" value="" required>
                </div>
                
                <div class="input-group mb-4"></div>

                <div class="input-group mb-3">
                    <button type="button" class="btn btn-outline-primary" onclick="validateFormlo();" >인증번호 재발급</button>
                    <button type="button" class="btn btn-outline-secondary" onclick="location.replace('/index.asp');">취 소</button>
                </div>

            </form>
        </div>
    </div>

            <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384- YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

</body>
</html>

<%
elseif gubun="inju" then 
    mname=Request("mname")
    mhp=Request("mhp")



    SQL="Select midx From tk_member where mname='"&mname&"' and mhp='"&mhp&"' "
    'Response.write (SQL)
    'response.end
    Set Rs = Dbcon.execute(SQL)
    If Not (Rs.bof or Rs.eof) Then 
        midx=Rs(0)
  

    '인증코드
    Randomize
    scode=Int(Rnd() * 9999) + 1

    if Len(scode)="1" then 
    scode="000"&scode
    elseif Len(scode)="2" then 
    scode="00"&scode
    elseif Len(scode)="3" then 
    scode="0"&scode
    end if 

    mdscode = md5(scode)  '암호화적용'
    '인증코드 '


    SQL="Update tk_member set mpw='"&mdscode&"'  Where midx='"&midx&"' "
    'Response.write (SQL)&"/"
    Dbcon.Execute (SQL)

    '카카오 알림톡 시작
    
    telno=mhp
    telno=replace(telno,"-","") 
    telno="82"&Right(telno,10)

    atid="tkdoor1"
    atdeptcode="N6-3Q0-TV"
    sch="04650d631a8daf41c3b4667282ff7b340acbc27a"
    template_code="visit_001"
    message_id=ymdhns

    message=""&mname&"님의 인증코드는 "&scode&"입니다."

    Private Sub Command2_Click()
    jsonData = " {""usercode"":"""&atid&""",""deptcode"":"""&atdeptcode&""", "
    jsonData = jsonData & " ""yellowid_key"":"""&sch&""", "
    jsonData = jsonData & " ""messages"":[ "
    jsonData = jsonData & " {""type"":""at"",""message_id"":"""&message_id&""", "
    jsonData = jsonData & " ""to"" :"""&telno&""", "
    jsonData = jsonData & " ""template_code"" :"""&template_code&""", "  
    jsonData = jsonData & " ""text"":"""&message&"""}"    
    jsonData = jsonData & " ]} "
    url = "https://api.surem.com/alimtalk/v1/json"
        Dim objXMLHttp
        Set objXMLHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")
        objXMLHttp.Open "POST", url, False
        objXMLHttp.SetRequestHeader "Content-Type", "application/json"
        objXMLHttp.Send jsonData
        retJSON = CStr(objXMLHttp.ResponseText)
        Set objXMLHttp = Nothing
    '   MsgBox (retJSON)

    End Sub

    Call Command2_Click()  

    '카카오 알림톡 끝
%>
<script>alert('인증번호가 재발급 되었습니다. 카카오톡 메시지를 확인해 주세요.');location.replace('/index.asp?mname=<%=mname%>');</script>
<%
    '회원 정보가 있다면 끝
    Else
    '회원 정보가 없다면
        response.write "<script>alert('일치하는 정보가 없습니다. 고객센터로 문의해 주세요.');history.back('-1');</script>"
        response.end
    End If
    Rs.close



        
end if 
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>