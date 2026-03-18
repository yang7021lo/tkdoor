<!--#include virtual="/bom2/common/deactivate_config.asp"-->

<%
type = LCase(Request.Form("type"))
id   = CLng(Request.Form("id"))

Set cfg = GetDeactivateConfig(type)
If cfg Is Nothing Then
    Response.Write "INVALID"
    Response.End
End If

Dbcon.BeginTrans

' 1. Material 비활성화
If Request.Form("material_id[]").Count > 0 Then
    For Each mid In Request.Form("material_id[]")
        If IsNumeric(mid) Then
            Dbcon.Execute _
              "UPDATE bom2_material SET is_active=0 WHERE material_id=" & CLng(mid)
        End If
    Next
End If

' 2. 대상 비활성화
Dbcon.Execute _
  "UPDATE " & cfg("table") & _
  " SET is_active=0 WHERE " & cfg("pk") & "=" & CLng(id)

Dbcon.CommitTrans

Response.Write "<script>alert('비활성화 완료');location.href='../bom2_main.asp';</script>"
%>
