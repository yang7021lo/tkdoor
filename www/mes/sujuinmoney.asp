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
	Set Rs = Server.CreateObject ("ADODB.Recordset")

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 


gubun=Request("gubun")
rcidx=Request("cidx") '아이디 키
rsjaidx=Request("sjaidx")  'sujuinA 키
sjmoneyidx=Request("rsjmoneyidx")'sjmoneyidx 키

SQL=" Insert into tk_sujumoney (sjwondanga, sjchugageum, sjgonggeumgaaek, sjDCdanga, sjseaek, sjdanga, sjgeumaek "
SQL=SQL&" ,sjbpummyoungPRICE, sjbkukyukPRICE,sjbjaejilPRICE, sjbwidePRICE,sjbhighPRICE "
SQL=SQL&" ,sjbglassPRICE, sjbpaintPRICE,sjbkeyPRICE, sjbtagongPRICE,sjbhingeupPRICE, sjbhingedownPRICE  "
SQL=SQL&" ,sjbkyukjaPRICE1, sjbkyukjaPRICE2,sjbkyukjaPRICE3, sjbkyukjaPRICE4,sjbkyukjaPRICE5  "
SQL=SQL&" ,sjaidx, sjbidx,sjcidx, sjdidx,sjeidx, sjfidx  "
SQL=SQL&" ,sujumoneymidx,sujumoneymdate,sujumoneymeidx,sujumoneymedate ) "
SQL=SQL&" Values ( '"&sjwondanga&"','"&sjchugageum&"','"&sjgonggeumgaaek&"','"&sjDCdanga&"','"&sjseaek&"','"&sjdanga&"','"&sjgeumaek&"' "
SQL=SQL&" ,'"&sjbpummyoungPRICE&"','"&sjbkukyukPRICE&"','"&sjbjaejilPRICE&"','"&sjbwidePRICE&"','"&sjbhighPRICE&"' "
SQL=SQL&" ,'"&sjbglassPRICE&"','"&sjbpaintPRICE&"','"&sjbkeyPRICE&"','"&sjbtagongPRICE&"','"&sjbhingeupPRICE&"','"&sjbhingedownPRICE&"' "
SQL=SQL&" ,'"&sjbkyukjaPRICE1&"','"&sjbkyukjaPRICE2&"','"&sjbkyukjaPRICE3&"','"&sjbkyukjaPRICE4&"','"&sjbkyukjaPRICE5&"' "
SQL=SQL&" ,'"&sjaidx&"','"&sjbidx&"','"&sjcidx&"','"&sjdidx&"','"&sjeidx&"','"&sjfidx&"'   "
SQL=SQL&" ,'"&sujumoneymidx&"',getdate(),'"&sujumoneymeidx&"',getdate() )  "
'Response.write (SQL)&"<br>"
'response.end
Dbcon.Execute (SQL)
 
'Response.write "<script>window.parent.location.replace('sujuinmoney.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>&sjmoneyidx=<%=rsjmoneyidx%>');</script>"
'response.end 

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
        function validateForm(){document.frmMainC.submit();}
    </script>     
    </head>    
    <body>
        <form  method="post" action="sujuinmoney.asp" name="frmMainC">         
<!--합계 시작 -->
            <div class="row mb-1">
                <div class="col-md-1 card card-body mb-1  ">
                    <div class="row">
                        <div class="col-md-5 text-start">
                            <label for="name">합계</label>
                        </div>
                    </div>
                    <div class="row">                       
                        <div class="col-md-3">
                            <label for="name">원단가</label>
                            <input type="text" class="form-control" id="" name="sjwondanga" placeholder="" value="<%=sjwondanga%>">
                        </div> 
                        <div class="col-md-3 text-end">
                            <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>                            
                        </div>
                    </div>                        
                        <div class="col-md-3">
                            <label for="name">추가금</label>
                            <input type="text" class="form-control" id="" name="sjchugageum" placeholder="" value="<%=sjchugageum%>"  >
                        </div> 
                        <div class="col-md-3">
                            <label for="name">공급가액</label>
                            <input type="text" class="form-control" id="" name="sjgonggeumgaaek" placeholder="" value="<%=sjgonggeumgaaek%>"  >
                        </div> 
                    </div>
                    <div class="row">
                        <div class="col-md-1 text-end">
                            
                        </div>
                        <div class="col-md-51">
                            <label for="name">할인단가</label>
                            <input type="text" class="form-control" id="" name="sjDCdanga" placeholder="" value="<%=sjDCdanga%>"  >
                        </div> 
                        <div class="col-md-1">
                            <label for="name">세액</label>
                            <input type="text" class="form-control" id="" name="sjseaek" placeholder="" value="<%=sjseaek%>"  >
                        </div> 
                    </div>
                    <div class="row">
                        <div class="col-md-1 text-end">
                            
                        </div>
                        <div class="col-md-1">
                            <label for="name">단가</label>
                            <input type="text" class="form-control" id="" name="sjdanga" placeholder="" value="<%=sjdanga%>"  >
                        </div> 
                        <div class="col-md-1">
                            <label for="name">금액</label>
                            <input type="text" class="form-control" id="" name="sjgeumaek" placeholder="" value="<%=sjgeumaek%>"  >
                        </div> 
                    </div>                
                </div>           
            </div>
        </form>
    </body>
</html>
<%

%>
<%
set Rs=Nothing
call dbClose()
%>
<!--합계 끝 -->