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
mode    = Request("mode")    ' img / cad

Dim uploadform, uploadedFile, fileName
Dim savePath, fso
Dim spl, ext, newName, SQL

'==== 저장 경로 분기 ====
If mode = "img" Then
    savePath = Server.MapPath("/img/bom/img/")
Else
    savePath = Server.MapPath("/img/bom/file/")
End If

'==== 폴더 없으면 생성 ====
Set fso = Server.CreateObject("Scripting.FileSystemObject")
If Not fso.FolderExists(savePath) Then
    fso.CreateFolder(savePath)
End If
Set fso = Nothing

'==== DEXT 시작 ====
Set uploadform = Server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath = savePath
uploadform.AutoMakeFolder = True

Set uploadedFile = uploadform("pasteImage")

If Not uploadedFile Is Nothing Then

    uploadedFile.Save , False
    fileName = uploadedFile.LastSavedFileName

    If fileName <> "" Then

        spl = Split(fileName, ".")
        ext = spl(UBound(spl))

        newName = Replace(Replace(CStr(Now()),"-",""),":","")
        newName = Replace(newName," ","") & "." & ext

        uploadform.SaveAs newName, False

        '==== DB 업데이트 ====
        If mode = "img" Then
            SQL = "UPDATE bom_mold SET img_path='" & newName & "', udate=getdate() WHERE mold_id='" & mold_id & "' "
        Else
            SQL = "UPDATE bom_mold SET cad_path='" & newName & "', udate=getdate() WHERE mold_id='" & mold_id & "' "
        End If

        Dbcon.Execute SQL

        ' 🔥 성공 후 원래 창 새로고침 + 팝업 닫기
                Response.Write "<script>"
                Response.Write "if (opener) opener.location.reload();"
                Response.Write "window.close();"
                Response.Write "</script>"
                Response.End
    End If

Else
     Response.Write "<script>alert('❌ 이미지 없음');window.close();</script>"
End If

call dbClose()
%>
