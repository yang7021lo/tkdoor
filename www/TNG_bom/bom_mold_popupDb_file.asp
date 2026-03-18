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

Dim mold_id, mode
mold_id = Request("mold_id")
mode    = Request("mode")     ' img / cad

Dim uploadform, uploadedFile, fileName
Dim savePath, fso
Dim ext, newName, SQL

'==============================
' 저장경로 분기
'==============================
If mode = "img" Then
    savePath = Server.MapPath("/img/bom/img/")
Else
    savePath = Server.MapPath("/img/bom/file/")
End If

'==============================
' 폴더 없으면 생성
'==============================
Set fso = Server.CreateObject("Scripting.FileSystemObject")
If Not fso.FolderExists(savePath) Then
    fso.CreateFolder(savePath)
End If
Set fso = Nothing

' =============================
' 업로드 폼 화면 출력부
' =============================
If Request.ServerVariables("REQUEST_METHOD") = "GET" Then
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>파일 업로드</title>
</head>
<body style="padding:20px; font-size:16px;">

<h3>파일 업로드</h3>

<form method="post" enctype="multipart/form-data">
    <input type="file" name="upfile" style="font-size:16px;">
    <br><br>
    <button type="submit" style="padding:10px 20px;">업로드</button>
</form>

</body>
</html>

<%
Response.End
End If
' =============================
'  ⬆ GET이면 폼을 띄우고 끝남
' =============================


' =============================
' 여기부터 POST(실제 업로드 처리)
' =============================

Set uploadform = Server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath = savePath
uploadform.AutoMakeFolder = True

Set uploadedFile = uploadform("upfile")    ' ★ 파일 input name = upfile

If uploadedFile Is Nothing Then
    Response.Write "❌ 업로드된 파일 없음"
    Response.End
End If

uploadedFile.Save , False
fileName = uploadedFile.LastSavedFileName

If fileName = "" Then
    Response.Write "❌ 파일 저장 실패"
    Response.End
End If

' 확장자 추출
Dim sp
sp = Split(fileName, ".")
ext = sp(UBound(sp))

' 새로운 파일명 생성
newName = Replace(Replace(Replace(CStr(Now()),"-",""),":","")," ","")
newName = newName & "." & ext

uploadform.SaveAs newName, False

' -----------------------------
' DB 업데이트
' -----------------------------
If mode = "img" Then
    SQL = "UPDATE bom_mold SET img_path='" & newName & "', udate=getdate() WHERE mold_id='" & mold_id & "'"
Else
    SQL = "UPDATE bom_mold SET cad_path='" & newName & "', udate=getdate() WHERE mold_id='" & mold_id & "'"
End If
Dbcon.Execute SQL

' -----------------------------
' 창 닫고 부모창 새로고침
' -----------------------------
%>
<script>
alert("업로드 완료!");
opener.location.reload();
window.close();
</script>

<%
call dbClose()
%>
