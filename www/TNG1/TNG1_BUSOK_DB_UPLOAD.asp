
<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
gubun=request("gubun")


if gubun="" then
rTNG_Busok_idx=Request("TNG_Busok_idx")
rbftype=Request("bftype")
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

    <script>
        function validateForm() {
            if(document.frmMain.bfimg.value == "" ) {
                alert("파일을 선택하세요.");
            return

            }           
            else {
                document.frmMain.submit();
            }
        }
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_BUSOK_DB_UPLOAD.asp?gubun=delete&bftype=<%=rbftype%>&TNG_Busok_idx=<%=rTNG_Busok_idx%>"
            }
        }
    </script>    
</head>
 
<body>

<!--화면시작-->
<form name="frmMain" action="TNG1_BUSOK_DB_UPLOAD.asp?gubun=input" method="post" enctype="multipart/form-data">   
    <input type="hidden" class="form-control" name="TNG_Busok_idx" value="<%=rTNG_Busok_idx%>">
    <input type="hidden" class="form-control" name="bftype" value="<%=rbftype%>">

    <div class="py-5 container text-center">


<!-- input 형식 시작--> 
        <div class="input-group mb-3">
            <input type="file" class="form-control" name="bfimg" value="">
        </div>
<!-- input 형식 끝--> 

<!-- 버튼 형식 시작--> 
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-primary" Onclick="validateForm();">등록</button>
            <button type="button" class="btn btn-outline-secondary" onclick="del();">삭제</button>
            <button type="button" class="btn btn-outline-secondary" onclick="window.close();">창닫기</button>
        </div>
<!-- 버튼 형식 끝--> 
 
    </div>    
</form>
    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>
<%
elseif gubun="input" then
' DextUpload 시작
'==============================
Set uploadform = Server.CreateObject("DEXT.FileUpload") 
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_bfimg

rTNG_Busok_idx = encodesTR(uploadform("TNG_Busok_idx"))
rbftype = encodesTR(uploadform("bftype"))
Response.write rbftype&"/<br>"
bfimg = uploadform("bfimg")

uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_bfimg

bfimg = uploadform("bfimg").Save( ,false)   '실질적인 파일 저장

board_file_name1 = uploadform("bfimg").LastSavedFileName '파일저장 경로에서 파일명과 확장자만 board_file_name1변수에 저장한다.
Response.write buidx&"<br>"
Response.write board_file_name1&"<br>"

if bfimg<>"" then 

    splcyj=split(board_file_name1,".")

    afilename=splcyj(0) 'aaaa'
    bfilename=splcyj(1) 'pdf/jpg/hwp'

    board_file_name1=ymdhns&"."&bfilename
    board_file_name0 = uploadform.SaveAs(board_file_name1, False)        
    
end if 

uploadform.DeleteFile bfimg 


if rbftype="bfimg1" then 
SQL="Update TNG_Busok set TNG_Busok_images='"&board_file_name1&"' where TNG_Busok_idx='"&rTNG_Busok_idx&"' "
response.write (SQL)&"<br>"
elseif rbftype="bfimg2" then 
SQL="Update TNG_Busok set TNG_Busok_CAD='"&board_file_name1&"' where TNG_Busok_idx='"&rTNG_Busok_idx&"' "
response.write (SQL)&"<br>"
end if
dbCon.execute (SQL)

response.write "<script>opener.location.replace('TNG1_BUSOK.asp?TNG_Busok_idx="&rTNG_Busok_idx&"#"&rTNG_Busok_idx&"');window.close();</script>"

elseif gubun="delete" then 

rTNG_Busok_idx=Request("TNG_Busok_idx")
rbftype=Request("bftype")

response.write "rTNG_Busok_idx:"&rTNG_Busok_idx&"<br>"
response.write "rbftype:"&rbftype&"<br>"

if rbftype="bfimg1" then 
    SQL="Update TNG_Busok set TNG_Busok_images='' where TNG_Busok_idx='"&rTNG_Busok_idx&"' "
    response.write (SQL)&"<br>"
    dbCon.execute (SQL)
elseif rbftype="bfimg2" then 
    SQL="Update TNG_Busok set TNG_Busok_CAD='' where TNG_Busok_idx='"&rTNG_Busok_idx&"' "
    response.write (SQL)&"<br>"
    dbCon.execute (SQL)
end if

response.write "<script>opener.location.replace('TNG1_BUSOK.asp?TNG_Busok_idx="&rTNG_Busok_idx&"#"&rTNG_Busok_idx&"');window.close();</script>"

end if
%>
<%
set Rs=Nothing
call dbClose()
%>
