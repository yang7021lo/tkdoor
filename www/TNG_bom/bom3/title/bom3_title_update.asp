<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
Response.ContentType = "text/plain"
Call DbOpen()

Dim list_title_id, master_id, title_name, density, type_id
list_title_id = Trim(Request("list_title_id"))
master_id     = Trim(Request("master_id"))
title_name    = Trim(Request("title_name"))
density       = Trim(Request("density"))  ' 단위
type_id       = Trim(Request("type_id"))

' ===============================
' 공통 유효성
' ===============================
If Not IsNumeric(list_title_id) Then
  Response.Write "INVALID_ID"
  Call DbClose()
  Response.End
End If

If title_name = "" Then
  Response.Write "EMPTY_TITLE"
  Call DbClose()
  Response.End
End If

' ===============================
' 현재 타이틀이 SUB/공통인지 확인
' ===============================
Dim rsInfo, sqlInfo, is_sub, is_common
Set rsInfo = Server.CreateObject("ADODB.Recordset")

sqlInfo = "SELECT is_sub, is_common FROM dbo.bom3_list_title WHERE list_title_id=" & CLng(list_title_id)
rsInfo.Open sqlInfo, Dbcon, 1, 1

If rsInfo.EOF Then
  rsInfo.Close : Set rsInfo = Nothing
  Response.Write "NOT_FOUND"
  Call DbClose()
  Response.End
End If

is_sub    = CLng(rsInfo("is_sub"))
is_common = CLng(rsInfo("is_common"))
rsInfo.Close : Set rsInfo = Nothing

' ===============================
' 분기 UPDATE
' ===============================
Dim sql
sql = ""

If is_sub = 1 Then
  ' ✅ is_sub: 타이틀명만
  sql = _
    "UPDATE dbo.bom3_list_title SET " & _
    " title_name = N'" & Replace(title_name,"'","''") & "', " & _
    " udate = GETDATE() " & _
    "WHERE list_title_id = " & CLng(list_title_id)

ElseIf is_common = 1 Then
  ' ✅ is_common: 타이틀명 + 타입 + 단위
  If Not IsNumeric(type_id) Then
    Response.Write "INVALID_TYPE"
    Call DbClose()
    Response.End
  End If

  sql = _
    "UPDATE dbo.bom3_list_title SET " & _
    " title_name = N'" & Replace(title_name,"'","''") & "', " & _
    " type_id = " & CLng(type_id) & ", " & _
    " density = N'" & Replace(density,"'","''") & "', " & _
    " udate = GETDATE() " & _
    "WHERE list_title_id = " & CLng(list_title_id)

Else
  ' ✅ 일반: master + 타이틀명 + 타입 + 단위
  If Not IsNumeric(master_id) Then
    Response.Write "INVALID_MASTER"
    Call DbClose()
    Response.End
  End If

  If Not IsNumeric(type_id) Then
    Response.Write "INVALID_TYPE"
    Call DbClose()
    Response.End
  End If

  sql = _
    "UPDATE dbo.bom3_list_title SET " & _
    " master_id = " & CLng(master_id) & ", " & _
    " title_name = N'" & Replace(title_name,"'","''") & "', " & _
    " type_id = " & CLng(type_id) & ", " & _
    " density = N'" & Replace(density,"'","''") & "', " & _
    " udate = GETDATE() " & _
    "WHERE list_title_id = " & CLng(list_title_id)
End If

Dbcon.Execute sql
Response.Write "OK"
Call DbClose()
%>
