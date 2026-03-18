<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "text/html"
Response.Buffer = True

Call DbOpen()

' ===============================
' 유틸
' ===============================
Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = CStr(v)
End Function

Function ToLng(v, def)
  If IsNumeric(v) Then ToLng = CLng(v) Else ToLng = def
End Function

Function SqlStr(s)
  SqlStr = Replace(Trim(Nz(s)), "'", "''")
End Function

Sub GoBackWithAlert(msg, url)
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<script>
  alert("<%=Replace(msg, """", "\""")%>");
  (function(){
    var u = "<%=Replace(url, """", "\""")%>";
    if(u && u !== "#"){
      location.replace(u);
    }else{
      if(document.referrer) location.replace(document.referrer);
      else history.back();
    }
  })();
</script>
</head>
<body></body>
</html>
<%
  Call DbClose()
  Response.End
End Sub

Sub FailTx(where)
  Dim eNo, eDesc
  eNo = Err.Number
  eDesc = Err.Description

  On Error Resume Next
  Dbcon.RollbackTrans
  On Error GoTo 0
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>ERROR</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-3">
  <div class="alert alert-danger">오류로 인해 ROLLBACK 처리됨</div>
  <div class="mb-2"><b>WHERE</b>: <%=Server.HTMLEncode(where)%></div>
  <div>Err.Number: <b><%=eNo%></b></div>
  <div>Err.Description: <b><%=Server.HTMLEncode(eDesc)%></b></div>
  <div class="text-end mt-3">
    <button class="btn btn-secondary" onclick="history.back()">뒤로</button>
  </div>
</body>
</html>
<%
  Call DbClose()
  Response.End
End Sub

' ===============================
' POST만 허용
' ===============================
If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
  Call GoBackWithAlert("잘못된 접근입니다.", "#")
End If

' ===============================
' 파라미터
' ===============================
Dim title_sub_id, list_title_id, sub_name
title_sub_id  = ToLng(Request.Form("title_sub_id"), 0)
list_title_id = ToLng(Request.Form("list_title_id"), 0)
sub_name      = Trim(Nz(Request.Form("sub_name")))

If title_sub_id <= 0 Or list_title_id <= 0 Then
  Call GoBackWithAlert("필수 값이 올바르지 않습니다.", "bom3_title_sub_manage.asp?list_title_id=" & list_title_id)
End If

If sub_name = "" Then
  Call GoBackWithAlert("서브명을 입력해 주세요.", "bom3_title_sub_manage.asp?list_title_id=" & list_title_id)
End If

' ===============================
' UPDATE
' ===============================
On Error Resume Next
Dbcon.BeginTrans
Err.Clear

Dim sql, rows
sql = "UPDATE dbo.bom3_list_title_sub " & _
      "SET sub_name = N'" & SqlStr(sub_name) & "', " & _
      "    udate = GETDATE() " & _
      "WHERE title_sub_id = " & title_sub_id & " " & _
      "  AND list_title_id = " & list_title_id & ";"

Dbcon.Execute sql, rows

If Err.Number <> 0 Then Call FailTx("UPDATE bom3_list_title_sub")

If CLng(rows) <= 0 Then
  Dbcon.RollbackTrans
  On Error GoTo 0
  Call GoBackWithAlert("저장할 대상이 없습니다. (이미 삭제/중지되었을 수 있어요)", "bom3_title_sub_manage.asp?list_title_id=" & list_title_id)
End If

Dbcon.CommitTrans
On Error GoTo 0

' ===============================
' 완료 후 복귀
' ===============================
Call GoBackWithAlert("저장되었습니다.", "bom3_title_sub_manage.asp?list_title_id=" & list_title_id)
%>
