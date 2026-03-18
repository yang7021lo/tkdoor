<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

call DbOpen()

Dim material_id
If IsNumeric(Request("material_id")) Then
    material_id = CLng(Request("material_id"))
Else
    Response.Write "INVALID MATERIAL_ID"
    call DbClose(): Response.End
End If

' ===============================
' DEXT Upload (베이스 코드 방식)
' ===============================
Dim uploadForm, fileObj, savedName, savePath, file
Set uploadForm = Server.CreateObject("DEXT.FileUpload")
uploadForm.AutoMakeFolder = True

' /img/bom2 로 저장 (네 화면 src 경로와 일치)
savePath = Server.MapPath("/img/bom2")
uploadForm.DefaultPath = savePath

Set fileObj = uploadForm("pufile")

If fileObj Is Nothing Then
    Response.Write "no-file"
    call DbClose(): Response.End
End If

If fileObj.FileLen = 0 Then
    Response.Write "file-empty"
    call DbClose(): Response.End
End If

' 저장
file = fileObj.Save(, False)
savedName = fileObj.LastSavedFileName

' ===============================
' DB INSERT (bom2_material_img)
' - sort_no: material별 다음 번호
' - is_main: 기존 대표 없으면 첫 업로드를 대표로
' ===============================
Dim rsChk, sqlChk, nextSort, hasMain, is_main

nextSort = 1
hasMain = 0

Set rsChk = Server.CreateObject("ADODB.Recordset")
sqlChk = "SELECT " & _
         "ISNULL(MAX(sort_no),0)+1 AS nextSort, " & _
         "ISNULL(SUM(CASE WHEN is_main=1 AND is_active=1 THEN 1 ELSE 0 END),0) AS mainCnt " & _
         "FROM bom2_material_img " & _
         "WHERE material_id=" & material_id
rsChk.Open sqlChk, Dbcon

If Not rsChk.EOF Then
    nextSort = CLng(rsChk("nextSort"))
    hasMain = CLng(rsChk("mainCnt"))
End If

rsChk.Close
Set rsChk = Nothing

If hasMain = 0 Then
    is_main = 1
Else
    is_main = 0
End If

Dim sqlIns
sqlIns = "INSERT INTO bom2_material_img (material_id, img_name, sort_no, is_main, is_active) VALUES (" & _
         material_id & ", '" & Replace(savedName, "'", "''") & "', " & nextSort & ", " & is_main & ", 1)"

Dbcon.Execute sqlIns

Response.Write "OK"

call DbClose()
%>
