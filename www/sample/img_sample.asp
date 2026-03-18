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
    sjb_idx=Request("rsjb_idx")
    bfidx=Request("rbfidx")
    bftype=Request("rbftype")
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>파일 업로드</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function validateForm() {
            let fileInput = document.frmMain.bfimg;
            if (!fileInput.files.length) {
                alert("파일을 선택하세요.");
                return;
            }
            document.frmMain.submit();
        }
        function del() {
            if (confirm("삭제하시겠습니까?")) {
                location.href = `TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD.asp?gubun=delete&rbftype=<%=bftype%>&rsjb_idx=<%=sjb_idx%>&rbfidx=<%=bfidx%>`;
            }
        }
    </script>
</head>
<body>
<form name="frmMain" action="TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD.asp?gubun=input" method="post" enctype="multipart/form-data">   
    <input type="hidden" name="rsjb_idx" value="<%=sjb_idx%>">
    <input type="hidden" name="rbfidx" value="<%=bfidx%>">
    <input type="hidden" name="rbftype" value="<%=bftype%>">

    <div class="py-5 container text-center">
        <div class="input-group mb-3">
            <input type="file" class="form-control" name="bfimg">
        </div>
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-primary" onclick="validateForm();">등록</button>
            <button type="button" class="btn btn-outline-secondary" onclick="del();">삭제</button>
            <button type="button" class="btn btn-outline-secondary" onclick="window.close();">창닫기</button>
        </div>
    </div>    
</form>
</body>
</html>
<%
elseif gubun="input" then
    Set uploadform = Server.CreateObject("DEXT.FileUpload") 
    uploadform.AutoMakeFolder = True
    uploadform.DefaultPath = DefaultPath_bfimg
    
    sjb_idx = encodesTR(uploadform("rsjb_idx"))
    bfidx = encodesTR(uploadform("rbfidx"))
    bftype = encodesTR(uploadform("rbftype"))
    
    bfimg = uploadform("bfimg")
    
    ymdhns = Year(Now) & Right("0" & Month(Now),2) & Right("0" & Day(Now),2) & Right("0" & Hour(Now),2) & Right("0" & Minute(Now),2) & Right("0" & Second(Now),2)
    
    if bfimg<>"" then 
        splcyj = Split(uploadform("bfimg").LastSavedFileName, ".")
        bfilename = splcyj(1)
        board_file_name1 = ymdhns & "." & bfilename
        uploadform("bfimg").SaveAs board_file_name1, False
    end if 
    
    Set cmd = Server.CreateObject("ADODB.Command")
    cmd.ActiveConnection = dbCon
    
    if bftype="bfimg1" then 
        cmd.CommandText = "UPDATE tk_barasif SET bfimg1 = ? WHERE bfidx = ?"
    elseif bftype="bfimg2" then 
        cmd.CommandText = "UPDATE tk_barasif SET bfimg2 = ? WHERE bfidx = ?"
    end if
    
    cmd.Parameters.Append cmd.CreateParameter(, 200, 1, 255, board_file_name1)
    cmd.Parameters.Append cmd.CreateParameter(, 200, 1, 255, bfidx)
    cmd.Execute
    
    Set cmd = Nothing
    
    response.write "<script>opener.location.replace('TNG1_JULGOK_PUMMOK_LIST.asp?rsjb_idx="&sjb_idx&"&rbfidx="&bfidx&"');window.close();</script>"
elseif gubun="delete" then 
    sjb_idx=Request("rsjb_idx")
    bfidx=Request("rbfidx")
    bftype=Request("rbftype")
    
    Set cmd = Server.CreateObject("ADODB.Command")
    cmd.ActiveConnection = dbCon
    
    if bftype="bfimg1" then 
        cmd.CommandText = "UPDATE tk_barasif SET bfimg1 = '' WHERE bfidx = ?"
    elseif bftype="bfimg2" then 
        cmd.CommandText = "UPDATE tk_barasif SET bfimg2 = '' WHERE bfidx = ?"
    end if
    
    cmd.Parameters.Append cmd.CreateParameter(, 200, 1, 255, bfidx)
    cmd.Execute
    
    Set cmd = Nothing
    
    response.write "<script>opener.location.replace('TNG1_JULGOK_PUMMOK_LIST.asp?rsjb_idx="&sjb_idx&"&rbfidx="&bfidx&"');window.close();</script>"
end if
%>
<%
set Rs=Nothing
call dbClose()
%>
