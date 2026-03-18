<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

json = Request.BinaryRead(Request.TotalBytes)
json = StrConv(json, vbUnicode)

Function J(key)
  pos = InStr(1, json, """" & key & """", 1)
  If pos = 0 Then J = "" : Exit Function
  pos = InStr(pos + Len(key) + 2, json, ":")
  If pos = 0 Then J = "" : Exit Function
  tmp = Trim(Mid(json, pos + 1))
  If Left(tmp,1) = """" Then
    tmp = Mid(tmp,2)
    If InStr(tmp, """") > 0 Then tmp = Left(tmp, InStr(tmp, """")-1)
  Else
    For i = 1 To Len(tmp)
      c = Mid(tmp, i, 1)
      If c = "," Or c = "}" Then
        tmp = Left(tmp, i - 1)
        Exit For
      End If
    Next
    tmp = Trim(tmp)
  End If
  J = tmp
End Function

qtyco_idx = J("qtyco_idx")

If qtyco_idx <> "" And IsNumeric(qtyco_idx) Then
  sql = "DELETE FROM tk_qtyco WHERE qtyco_idx='" & qtyco_idx & "'"
  Dbcon.Execute sql
  Response.Write "{""result"":""ok""}"
Else
  Response.Write "{""result"":""fail"",""msg"":""invalid idx""}"
End If

call dbClose()
%>
