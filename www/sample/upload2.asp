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
 

Dim uploadform, uploadedFile, fileName, savePath
savePath = Server.MapPath("uploads") & "\"

' 폴더가 없다면 생성
Dim fso
Set fso = Server.CreateObject("Scripting.FileSystemObject")
If Not fso.FolderExists(savePath) Then
  fso.CreateFolder(savePath)
End If
Set fso = Nothing

' 업로드 처리 (DEXTUpload 기준)
Set uploadform = Server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath = DefaultPath_bfimg
uploadform.AutoMakeFolder = True

Set uploadedFile = uploadform("pasteImage")

If Not uploadedFile Is Nothing Then
  uploadedFile.Save ,False
  fileName = uploadedFile.LastSavedFileName
  Response.Write fileName
Else
  Response.Write "❌ 이미지 없음"
End If
%>
