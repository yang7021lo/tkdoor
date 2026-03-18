
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
%>
<%
    sjidx = Request("sjidx")


Dim uploadform, uploadedFile, fileName, savePath
savePath = Server.MapPath("/img/frame/pufile/" & sjidx) 

' 폴더가 없다면 생성
Dim fso
Set fso = Server.CreateObject("Scripting.FileSystemObject")
If Not fso.FolderExists(savePath) Then
  fso.CreateFolder(savePath)
End If
Set fso = Nothing

' 업로드 처리 (DEXTUpload 기준)
Set uploadform = Server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath = savePath
uploadform.AutoMakeFolder = True

' *** Set upload path to the new folder


Set uploadedFile = uploadform("pufile")

If Not uploadedFile Is Nothing Then
  uploadedFile.Save ,False
  fileName = uploadedFile.LastSavedFileName
  'Response.Write fileName

'=================
if fileName<>"" then 

  splcyj=split(fileName,".")

  afilename=splcyj(0) 'aaaa'
  bfilename=splcyj(1) 'pdf/jpg/hwp'

  board_file_name1=ymdhns&"."&bfilename
  board_file_name0 = uploadform.SaveAs(board_file_name1, False)        

  SQL="Insert into tk_picupload (pufile, pumidx, pudate, sjidx, pustatus) Values('"&board_file_name1&"', '"&c_midx&"', getdate(), '"&sjidx&"', '1') "

'response.write (SQL)&"<br>"
  dbCon.execute (SQL)

  delfileName=DefaultPath_pu&"\"&fileName  '원본파일 삭제를 위한 전체 경로 변수 설정
  uploadform.DeleteFile delfileName   ' 
end if 


'=================


Else
  Response.Write "❌ 이미지 없음"
End If
%>
<%
set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>