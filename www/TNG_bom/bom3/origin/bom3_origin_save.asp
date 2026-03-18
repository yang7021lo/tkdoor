<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<!-- #include virtual="/inc/cookies.asp" -->
<%
Response.Buffer = True
Response.CharSet = "utf-8"
Response.ContentType = "text/plain"

Call DbOpen()

Dim origin_name
origin_name = Trim(Request("origin_name"))

If origin_name = "" Then
  Response.Write "EMPTY"
  Call DbClose()
  Response.End
End If

' (선택) 중복 체크
Dim Rs, sqlCheck
Set Rs = Server.CreateObject("ADODB.Recordset")

sqlCheck = "SELECT 1 FROM dbo.bom3_origin_type " & _
           "WHERE LTRIM(RTRIM(origin_name)) = N'" & Replace(origin_name,"'","''") & "'"

Rs.Open sqlCheck, Dbcon
If Not Rs.EOF Then
  Rs.Close : Set Rs = Nothing
  Response.Write "DUPLICATE"
  Call DbClose()
  Response.End
End If
Rs.Close : Set Rs = Nothing

' ✅ INSERT 하면서 새 ID 받기 (가장 깔끔/안전)
Dim sql, RsNew, newId
newId = 0

sql = "SET NOCOUNT ON; " & _
      "DECLARE @t TABLE(id BIGINT); " & _
      "INSERT INTO dbo.bom3_origin_type (origin_name) " & _
      "OUTPUT INSERTED.origin_type_no INTO @t(id) " & _
      "VALUES (N'" & Replace(origin_name, "'", "''") & "'); " & _
      "SELECT id FROM @t;"

On Error Resume Next
Set RsNew = Dbcon.Execute(sql)

If Err.Number <> 0 Then
  ' UNIQUE 충돌(2601, 2627) 처리
  Dim isDup, adoErr
  isDup = False
  For Each adoErr In Dbcon.Errors
    If adoErr.NativeError = 2601 Or adoErr.NativeError = 2627 Then
      isDup = True
      Exit For
    End If
  Next

  Err.Clear
  Call DbClose()

  If isDup Then
    Response.Write "DUPLICATE"
  Else
    Response.Write "ERROR"
  End If
  Response.End
End If
On Error GoTo 0

If Not (RsNew Is Nothing) Then
  If Not RsNew.EOF Then
    If Not IsNull(RsNew("id")) Then newId = CLng(RsNew("id"))
  End If
  RsNew.Close
  Set RsNew = Nothing
End If

If newId <= 0 Then
  Response.Write "ERROR"
  Call DbClose()
  Response.End
End If

Response.Write "OK|" & newId
Call DbClose()
%>
