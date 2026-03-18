<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "text/plain"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

On Error Resume Next

' 테이블 존재 확인
Dim rsCheck, tableExists
Set rsCheck = Dbcon.Execute("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tk_paint_sample'")
tableExists = CLng(rsCheck(0))
rsCheck.Close
Set rsCheck = Nothing

If tableExists > 0 Then
  Response.Write "tk_paint_sample 이미 존재합니다." & vbCrLf

  ' pidx NULL 허용으로 변경 (부분 저장 가능하게)
  Dim rsCol
  Set rsCol = Dbcon.Execute("SELECT IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='tk_paint_sample' AND COLUMN_NAME='pidx'")
  If Not rsCol.EOF Then
    If rsCol(0) = "NO" Then
      Dbcon.Execute "ALTER TABLE dbo.tk_paint_sample ALTER COLUMN pidx INT NULL"
      If Err.Number <> 0 Then
        Response.Write "pidx ALTER 오류: " & Err.Description & vbCrLf
        Err.Clear
      Else
        Response.Write "pidx → NULL 허용으로 변경 완료!" & vbCrLf
      End If
    Else
      Response.Write "pidx 이미 NULL 허용 상태" & vbCrLf
    End If
  End If
  rsCol.Close
  Set rsCol = Nothing

Else
  Dim createSQL
  createSQL = "CREATE TABLE dbo.tk_paint_sample (" & _
    "psidx INT NOT NULL, " & _
    "pidx INT NULL, " & _
    "sample_type INT DEFAULT 1, " & _
    "sjidx INT NULL, " & _
    "company_name NVARCHAR(100) NULL, " & _
    "recipient NVARCHAR(50) NULL, " & _
    "qty INT DEFAULT 1, " & _
    "sample_date DATETIME DEFAULT GETDATE(), " & _
    "memo NVARCHAR(200) NULL, " & _
    "psmidx INT NULL, " & _
    "pswdate DATETIME NULL, " & _
    "psemidx INT NULL, " & _
    "psewdate DATETIME NULL, " & _
    "CONSTRAINT PK_tk_paint_sample PRIMARY KEY (psidx)" & _
    ")"

  Dbcon.Execute createSQL
  If Err.Number <> 0 Then
    Response.Write "ERROR: " & Err.Description
    Err.Clear
  Else
    Response.Write "tk_paint_sample 테이블 생성 완료!" & vbCrLf
  End If
End If

On Error GoTo 0
call dbClose()
%>
