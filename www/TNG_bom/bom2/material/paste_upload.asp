<%@ Language="VBScript" CodePage="65001" %>
<!--#include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
Response.ContentType = "application/json"

' ========== DEXT 업로드 ==========
Set uploadForm = Server.CreateObject("DEXT.FileUpload")
uploadForm.AutoMakeFolder = True
uploadForm.DefaultPath = "F:\HOME\tkdr002\www\img\bom2"

' 업로드된 이미지 받기
Set file = uploadForm("uploadFile")

If file Is Nothing Then
    Response.Write "{""result"":""error""}"
    Response.End
End If

' 저장 (랜덤 이름 생성)
Dim savedName
savedName = uploadForm("uploadFile").Save(, False)

' 실제 저장된 파일명
Dim fname
fname = uploadForm("uploadFile").LastSavedFileName

' 웹에서 접근 가능한 경로로 변환
Dim webUrl
webUrl = "/img/bom2/" & fname

' 응답 반환
Response.Write "{""result"":""success"", ""url"":""" & webUrl & """}"

%>
