<%@ Language="VBScript" CodePage="65001" %>
<%
' =========================================================
' OCR 업로드 API (DEXT.FileUpload)
'
' - 이미지 → /img/door/
' - JSON  → /TNG2/ocr/ocr_mvp3/asp/results/
' - profile_api_upload.asp 와 동일한 DEXT 방식
' =========================================================

Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "application/json"

Function JSEncode(v)
    If IsNull(v) Then v = ""
    v = CStr(v)
    v = Replace(v, "\", "\\")
    v = Replace(v, """", "\""")
    v = Replace(v, vbCrLf, "\n")
    v = Replace(v, vbCr, "\n")
    v = Replace(v, vbLf, "\n")
    JSEncode = v
End Function

If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    Response.Write "{""success"":false,""error"":""POST_ONLY""}"
    Response.End
End If

' =========================================================
' DEXT 컴포넌트 생성
' =========================================================
On Error Resume Next
Set uploadform = Server.CreateObject("DEXT.FileUpload")
If Err.Number <> 0 Then
    Response.Write "{""success"":false,""error"":""DEXT_NOT_FOUND"",""detail"":""" & JSEncode(Err.Description) & """}"
    Response.End
End If
On Error GoTo 0

Dim ImageSaved, JsonSaved
Dim imgFileName, jsonFileName
ImageSaved = False
JsonSaved  = False

' =========================================================
' 이미지 저장
' =========================================================
imgSavePath = Server.MapPath("/img/door/")
uploadform.DefaultPath = imgSavePath
uploadform.AutoMakeFolder = True

On Error Resume Next
Set imgFile = uploadform("image")
If Not imgFile Is Nothing Then
    imgFile.Save , False
    imgFileName = imgFile.LastSavedFileName
    If imgFileName <> "" Then
        ImageSaved = True
    End If
End If
On Error GoTo 0

' =========================================================
' JSON 저장
' =========================================================
jsonSavePath = Server.MapPath("/TNG2/ocr/ocr_mvp3/asp/results/")
uploadform.DefaultPath = jsonSavePath

On Error Resume Next
Set jsonFile = uploadform("json")
If Not jsonFile Is Nothing Then
    jsonFile.Save , False
    jsonFileName = jsonFile.LastSavedFileName
    If jsonFileName <> "" Then
        JsonSaved = True
    End If
End If
On Error GoTo 0

' =========================================================
' 응답
' =========================================================
If ImageSaved And JsonSaved Then
    Response.Write "{""success"":true,""message"":""upload ok"",""image"":""" & JSEncode(imgFileName) & """,""json"":""" & JSEncode(jsonFileName) & """}"
ElseIf ImageSaved Then
    Response.Write "{""success"":true,""message"":""image only"",""image"":""" & JSEncode(imgFileName) & """}"
ElseIf JsonSaved Then
    Response.Write "{""success"":true,""message"":""json only"",""json"":""" & JSEncode(jsonFileName) & """}"
Else
    Response.Write "{""success"":false,""error"":""NO_FILE_SAVED""}"
End If

Set imgFile = Nothing
Set jsonFile = Nothing
Set uploadform = Nothing
%>
