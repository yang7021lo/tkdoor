
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
%>
<%
    rpidx=request("pidx")
    gotopage = Request("gotopage")
    SearchWord   = Request("SearchWord")
    rtype  = Request("type")

    'REsponse.write "rsjb_idx:"&rsjb_idx&"<br>"
    'REsponse.write "rbfidx:"&rbfidx&"<br>"
    'REsponse.write "rbftype:"&rbftype&"<br>"

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
uploadform.DefaultPath = DefaultPath_paint
uploadform.AutoMakeFolder = True

Set uploadedFile = uploadform("pasteImage")

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

    SQL = "SELECT  p_image, p_sample_image "
    SQL = SQL & " FROM tk_paint "
    SQL = SQL & "  WHERE pidx = '"&rpidx&"' "
    'Response.write (SQL)&"<br>"
    Rs.Open SQL, Dbcon 
    if not (Rs.EOF or Rs.BOF) then 

        ap_image = Rs(0)
        ap_sample_image = Rs(1)

    end if
    rs.close    

    if rtype="p_image" then
    SQL="Update tk_paint set p_image='"&board_file_name1&"' where pidx='"&rpidx&"' "
    elseif rtype="p_sample_image" then
    SQL="Update tk_paint set p_sample_image='"&board_file_name1&"' where pidx='"&rpidx&"' "
    end if
response.write (SQL)&"<br>"
  dbCon.execute (SQL)

  delfileName=DefaultPath_paint&"\"&fileName  '원본파일 삭제를 위한 전체 경로 변수 설정
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