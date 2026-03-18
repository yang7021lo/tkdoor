<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->
<%
'Option Explicit '사용 권장
Session.CodePage="65001"
Response.CharSet="utf-8"

call dbOpen()
Dim Rs, Rs1
Set Rs  = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")

' ==== 모든 변수는 상단에서 한 번만 선언 ====
Dim mode, rsjb_idx, rbfidx, rbftype, gubun
Dim rTNG_Busok_idx
Dim uploadform, uploadedFile, fileName, savePath, fso
Dim splcyj, afilename, bfilename, board_file_name0, board_file_name1, delfileName
Dim SQL, ymdhns

mode = Request("mode")  ' mode=busok

If mode <> "busok" Then
    ' ---------- 일반(바 이미지) 업로드 ----------
    rsjb_idx = Request("sjb_idx")
    rbfidx   = Request("bfidx")
    rbftype  = Request("bftype")
    gubun    = Request("gubun")

    savePath = Server.MapPath("uploads") & "\"

    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    If Not fso.FolderExists(savePath) Then fso.CreateFolder(savePath)
    Set fso = Nothing

    Set uploadform = Server.CreateObject("DEXT.FileUpload")
    uploadform.DefaultPath    = DefaultPath_bfimg
    uploadform.AutoMakeFolder = True

    Set uploadedFile = uploadform("pasteImage")

    If Not uploadedFile Is Nothing Then
        uploadedFile.Save , False
        fileName = uploadedFile.LastSavedFileName

        If fileName <> "" Then
            splcyj = Split(fileName, ".")
            afilename = splcyj(0)
            bfilename = splcyj(1)

            ' ymdhns 는 사용 전 어딘가에서 세팅되어 있어야 함 (예: FormatDateTime(Now, ...)로 생성)
            board_file_name1 = ymdhns & "." & bfilename
            board_file_name0 = uploadform.SaveAs(board_file_name1, False)

            If rbftype = "bfimg1" Then
                SQL = "UPDATE tk_barasif SET bfimg1='" & board_file_name1 & "' WHERE bfidx='" & rbfidx & "' "
            ElseIf rbftype = "bfimg2" Then
                SQL = "UPDATE tk_barasif SET bfimg2='" & board_file_name1 & "' WHERE bfidx='" & rbfidx & "' "
            ElseIf rbftype = "bfimg3" Then
                SQL = "UPDATE tk_barasif SET bfimg3='" & board_file_name1 & "' WHERE bfidx='" & rbfidx & "' "
            End If

            Dbcon.Execute SQL  ' 대소문자 일관: Dbcon/DbCon 혼용 주의

            delfileName = DefaultPath_bfimg & "\" & fileName
            uploadform.DeleteFile delfileName
        End If
    Else
        Response.Write "❌ 이미지 없음"
    End If

Else
    ' ---------- mode="busok" (버속 이미지) 업로드 ----------
    rTNG_Busok_idx = Request("TNG_Busok_idx")
    rbftype        = Request("bftype")
    gubun          = Request("gubun")

    savePath = Server.MapPath("uploads") & "\"

    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    If Not fso.FolderExists(savePath) Then fso.CreateFolder(savePath)
    Set fso = Nothing

    Set uploadform = Server.CreateObject("DEXT.FileUpload")
    uploadform.DefaultPath    = DefaultPath_bfimg
    uploadform.AutoMakeFolder = True

    Set uploadedFile = uploadform("pasteImage")

    If Not uploadedFile Is Nothing Then
        uploadedFile.Save , False
        fileName = uploadedFile.LastSavedFileName

        If fileName <> "" Then
            splcyj = Split(fileName, ".")
            afilename = splcyj(0)
            bfilename = splcyj(1)

            board_file_name1 = ymdhns & "." & bfilename
            board_file_name0 = uploadform.SaveAs(board_file_name1, False)

            If rbftype = "bfimg1" Then
                SQL = "UPDATE TNG_Busok SET TNG_Busok_images='" & board_file_name1 & "' WHERE TNG_Busok_idx='" & rTNG_Busok_idx & "' "
                'Response.Write SQL & "<br>"
                Dbcon.Execute SQL
            End If

            delfileName = DefaultPath_bfimg & "\" & fileName
            uploadform.DeleteFile delfileName
        End If
    Else
        Response.Write "❌ 이미지 없음"
    End If
End If

Set Rs  = Nothing
Set Rs1 = Nothing
call dbClose()
%>
