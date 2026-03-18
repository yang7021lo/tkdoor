<%@ codepage="65001" language="vbscript"%>
<%
' ============================================================
' 페인트 이미지 업로드 (붙여넣기)
' - 요청: POST multipart/form-data
'   - 쿼리: ?pidx=숫자&type=p_image|p_sample_image
'   - 폼필드: pasteImage (이미지 파일)
' - 응답: JSON {"result":"ok","fileName":"..."} 또는 {"result":"fail","msg":"..."}
' ============================================================
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

Dim rpidx, rtype
rpidx = Request.QueryString("pidx")
rtype = Request.QueryString("type")
If rtype = "" Then rtype = "p_image"

' pidx 검증
If rpidx = "" Or Not IsNumeric(rpidx) Then
  Response.Write "{""result"":""fail"",""msg"":""pidx 필요""}"
  call dbClose()
  Response.End
End If

' type 검증 (허용된 컬럼만)
If rtype <> "p_image" And rtype <> "p_sample_image" Then
  Response.Write "{""result"":""fail"",""msg"":""type은 p_image 또는 p_sample_image만 허용""}"
  call dbClose()
  Response.End
End If

' DEXTUpload로 파일 수신
Dim uploadform, uploadedFile, fileName
Set uploadform = Server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath = DefaultPath_paint
uploadform.AutoMakeFolder = True

Set uploadedFile = uploadform("pasteImage")

If Not uploadedFile Is Nothing Then
  uploadedFile.Save, False
  fileName = uploadedFile.LastSavedFileName

  If fileName <> "" Then
    ' 확장자 추출 + 고유 파일명 생성
    Dim splcyj, bfilename, newFileName
    splcyj = Split(fileName, ".")
    bfilename = splcyj(UBound(splcyj))
    newFileName = ymdhns & "." & bfilename
    uploadform.SaveAs newFileName, False

    ' DB 업데이트
    Dim SQL
    SQL = "UPDATE tk_paint SET [" & rtype & "] = N'" & Replace(newFileName, "'", "''") & "'"
    SQL = SQL & ", pemidx = '" & C_midx & "', pewdate = GETDATE()"
    SQL = SQL & " WHERE pidx = " & CLng(rpidx)

    On Error Resume Next
    Dbcon.Execute SQL
    If Err.Number <> 0 Then
      Response.Write "{""result"":""fail"",""msg"":""DB 오류: " & Replace(Err.Description, """", "'") & """}"
      Err.Clear
      On Error GoTo 0
      call dbClose()
      Response.End
    End If
    On Error GoTo 0

    ' 원본 파일 삭제
    uploadform.DeleteFile DefaultPath_paint & "\" & fileName

    Response.Write "{""result"":""ok"",""fileName"":""" & newFileName & """}"
  Else
    Response.Write "{""result"":""fail"",""msg"":""파일명 없음""}"
  End If
Else
  Response.Write "{""result"":""fail"",""msg"":""이미지 없음""}"
End If

call dbClose()
%>
