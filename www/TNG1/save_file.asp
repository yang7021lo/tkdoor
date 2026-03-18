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
    Set Rs = Server.CreateObject ("ADODB.Recordset")
%>

<%
' DextUpload 시작
'==============================
Set uploadform = Server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath = DefaultPath_pu
uploadform.AutoMakeFolder = True

rsjidx=encodestr(uploadform("sjidx"))
rcidx=encodestr(uploadform("cidx"))
pfname=encodestr(uploadform("pfname"))

response.write pfname
response.write uploadform("pfname").Count
response.end

' *** Create folder path based on sjidx
Dim targetFolder
targetFolder = Server.MapPath("/img/frame/pufile/" & rsjidx)

' *** Ensure folder exists using FileSystemObject
Dim fso
Set fso = Server.CreateObject("Scripting.FileSystemObject")
If Not fso.FolderExists(targetFolder) Then
    fso.CreateFolder(targetFolder)
End If
Set fso = Nothing

' *** Set upload path to the new folder
uploadform.DefaultPath = targetFolder

Dim i, fileObj, savedName
Dim fileCount

fileCount = uploadform("pfname").Count

For i = 1 To fileCount
    Set fileObj = uploadform("pfname")(i)

Dim fullName, fileNameOnly, fileExtension

fullName = fileObj.FileName  ' Example: "photo.jpg"

' Find the last dot in the filename
Dim dotPos
dotPos = InStrRev(fullName, ".")

If dotPos > 0 Then
    fileNameOnly = Left(fullName, dotPos - 1)         ' "photo"
        fileExtension = LCase(Mid(fullName, dotPos + 1)) ' *** lowercase for comparison
Else
    fileNameOnly = fullName                           ' No extension
    fileExtension = ""                                ' Empty
End If
    ' Check if file was uploaded (filename is not empty)
    If fileObj.FileName <> "" Then

        If fileExtension <> "" Then
            newFileName = ymdhns & "." & fileExtension
        Else
            newFileName = ymdhns
        End If

        fileObj.SaveAs newFileName
        savedName = newFileName
    
        If fileExtension="jpg" Or fileExtension="jpeg" Or fileExtension="png" Or fileExtension="svg" Then
            SQL = "INSERT INTO tk_picfiles (sjidx, pfname, pfmidx, pfdate, pffiletype, pfstatus) " & _
                "VALUES ('" & rsjidx & "', '" & savedName & "', '" & c_midx & "', getdate(), '0', '1')"
            Dbcon.Execute SQL
        Elseif fileExtension="pdf" then
            SQL = "INSERT INTO tk_picfiles (sjidx, pfname, pfmidx, pfdate, pffiletype, pfstatus) " & _
                "VALUES ('" & rsjidx & "', '" & savedName & "', '" & c_midx & "', getdate(), '1', '1')"
            Dbcon.Execute SQL
        Else 
            SQL = "INSERT INTO tk_picfiles (sjidx, pfname, pfmidx, pfdate, pffiletype, pfstatus, extension) " & _
                "VALUES ('" & rsjidx & "', '" & savedName & "', '" & c_midx & "', getdate(), '2', '1', '"&fileExtension&"')"
            Dbcon.Execute SQL
        End if
    End If

    Set fileObj = Nothing
Next

'Response.write snidx&"<br>"
'Response.write file3&"<br>"
'Response.end
'Respose.write(SQL)&"<br>
'Response.end

response.write "<script>location.replace('TNG1_B_data.asp?cidx="&rcidx&"&sjidx="&rsjidx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>
