
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
rsjb_idx=Request("sjb_idx")
rbfidx=Request("bfidx")
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
                location.href="TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD.asp?gubun=delete&bftype=<%=rbftype%>&sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>"
            }
        }
    </script>   


</head>

<body>

<!--화면시작-->
<form name="frmMain" action="TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD.asp?gubun=input" method="post" enctype="multipart/form-data">   
    <input type="hidden" class="form-control" name="sjb_idx" value="<%=rsjb_idx%>">
    <input type="hidden" class="form-control" name="bfidx" value="<%=rbfidx%>">
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

rsjb_idx = encodesTR(uploadform("sjb_idx"))
rbfidx = encodesTR(uploadform("bfidx"))
rbftype = encodesTR(uploadform("bftype"))

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
SQL="Update tk_barasif set bfimg1='"&board_file_name1&"' where bfidx='"&rbfidx&"' "
'response.write (SQL)&"<br>"
elseif rbftype="bfimg2" then 
SQL="Update tk_barasif set bfimg2='"&board_file_name1&"' where bfidx='"&rbfidx&"' "
elseif rbftype="bfimg3" then 
SQL="Update tk_barasif set bfimg3='"&board_file_name1&"' where bfidx='"&rbfidx&"' "
'response.write (SQL)&"<br>"
elseif rbftype="bfimg4" then 
SQL="Update tk_barasif set bfimg4='"&board_file_name1&"' where bfidx='"&rbfidx&"' "
'response.write (SQL)&"<br>"
end if
dbCon.execute (SQL)

response.write "<script>opener.location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?sjb_idx="&rsjb_idx&"&bfidx="&rbfidx&"');window.close();</script>"

elseif gubun="delete" then 

rsjb_idx=Request("sjb_idx")
rbfidx=Request("bfidx")
rbftype=Request("bftype")

'response.write "sjb_idx:"&rsjb_idx&"<br>"
'response.write "bfidx:"&rbfidx&"<br>"
'response.write "bftype:"&rbftype&"<br>"

if rbftype="bfimg1" then 
    SQL="Update tk_barasif set bfimg1='' where bfidx='"&rbfidx&"' "
    'response.write (SQL)&"<br>"
    dbCon.execute (SQL)
elseif rbftype="bfimg2" then 
    SQL="Update tk_barasif set bfimg2='' where bfidx='"&rbfidx&"' "
    'response.write (SQL)&"<br>"
    dbCon.execute (SQL)
elseif rbftype="bfimg3" then 
    SQL="Update tk_barasif set bfimg3='' where bfidx='"&rbfidx&"' "
    'response.write (SQL)&"<br>"   
    dbCon.execute (SQL) 
elseif rbftype="bfimg4" then 
    SQL="Update tk_barasif set bfimg4='' where bfidx='"&rbfidx&"' "
    'response.write (SQL)&"<br>"        
    dbCon.execute (SQL)
end if

response.write "<script>opener.location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?sjb_idx="&rsjb_idx&"&bfidx="&rbfidx&"');window.close();</script>"

end if
%>
<%
set Rs=Nothing
call dbClose()
%>
 