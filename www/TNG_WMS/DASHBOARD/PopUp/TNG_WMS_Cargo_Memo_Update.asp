<%@ Language="VBScript" CodePage="65001" %>
<%

Session.CodePage = "65001"
Response.Charset = "utf-8"
Response.ContentType = "text/plain"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
Call dbOpen()

' =========================
' helpers
' =========================
Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = Trim(CStr(v))
End Function

Function SafeLong(v)
  On Error Resume Next
  SafeLong = CLng(0 & v)
  On Error GoTo 0
End Function

Function SqlEsc(s)
  s = Nz(s)
  SqlEsc = Replace(s, "'", "''")
End Function

Dim kind, wms_idx, manual_idx, cargo_memo
kind      = LCase(Nz(Request("kind")))          ' "meta" | "manual"
wms_idx    = Nz(Request("wms_idx"))
manual_idx = Nz(Request("manual_idx"))
cargo_memo = Nz(Request("cargo_memo"))

If kind <> "manual" Then kind = "meta"

If Trim(cargo_memo) = "" Then
  ' 빈값 허용할거면 이 블록 제거
  'Response.Write "ERR: cargo_memo required"
  'Response.End
End If

Dim SQL, idVal
SQL = ""

If kind = "manual" Then
  idVal = SafeLong(manual_idx)
  If idVal <= 0 Then
    Response.Write "ERR: manual_idx"
    Response.End
  End If

  SQL = ""
  SQL = SQL & "UPDATE dbo.tk_wms_cargo "
  SQL = SQL & "SET cargo_memo = N'" & SqlEsc(cargo_memo) & "' "
  SQL = SQL & "WHERE manual_idx = " & idVal & " "
  SQL = SQL & "  AND (wms_idx IS NULL OR wms_idx = 0) "  ' 방어: 수동건만

Else
  idVal = SafeLong(wms_idx)
  If idVal <= 0 Then
    Response.Write "ERR: wms_idx"
    Response.End
  End If

  SQL = ""
  SQL = SQL & "UPDATE dbo.tk_wms_cargo "
  SQL = SQL & "SET cargo_memo = N'" & SqlEsc(cargo_memo) & "' "
  SQL = SQL & "WHERE wms_idx = " & idVal & " "
  SQL = SQL & "  AND (manual_idx IS NULL OR manual_idx = 0) " ' 방어: meta건만
End If

DbCon.Execute SQL

Response.Write "OK"
%>
