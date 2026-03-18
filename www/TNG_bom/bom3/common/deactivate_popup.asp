<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Call DbOpen()

' ===============================
' NULL 안전 처리
' ===============================
Function Nz(v)
    If IsNull(v) Then
        Nz = ""
    Else
        Nz = CStr(v)
    End If
End Function

' ===============================
' 파라미터
' ===============================
Dim pType, pId
pType = LCase(Trim(Request("type")))
pId   = Trim(Request("id"))

If pType = "" Or Not IsNumeric(pId) Then
    Response.Write "INVALID PARAMETER"
    Call DbClose()
    Response.End
End If
pId = CLng(pId)

' ===============================
' 에러 처리(트랜잭션 롤백)
' ===============================
Sub FailTx()
    Dim eNo, eDesc
    eNo = Err.Number
    eDesc = Err.Description

    On Error Resume Next
    Dbcon.RollbackTrans
    On Error GoTo 0

    Call DbClose()
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ERROR</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-3">
<div class="alert alert-danger">오류 발생으로 ROLLBACK 처리됨</div>
<div>Err.Number: <b><%=eNo%></b></div>
<div>Err.Description: <b><%=Server.HTMLEncode(eDesc)%></b></div>
<div class="text-end mt-3">
  <button class="btn btn-secondary" onclick="window.close()">닫기</button>
</div>
</body>
</html>
<%
    Response.End
End Sub

' =========================================================
' ✅ POST 처리 (비활성화 버튼 하나로 통일)
' =========================================================
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then

    On Error Resume Next
    Dbcon.BeginTrans
    Err.Clear

    If pType = "title" Then

        Dim isSub, isCommon
        isSub = 0 : isCommon = 0

        Dim rsFlag
        Set rsFlag = Server.CreateObject("ADODB.Recordset")
        rsFlag.Open _
            "SELECT ISNULL(is_sub,0) AS is_sub, ISNULL(is_common,0) AS is_common " & _
            "FROM dbo.bom3_list_title WHERE list_title_id=" & pId, Dbcon

        If rsFlag.EOF Then
            rsFlag.Close : Set rsFlag = Nothing
            Dbcon.RollbackTrans
            Call DbClose()
            Response.Write "NOT_FOUND"
            Response.End
        End If

        isSub    = CLng(rsFlag("is_sub"))
        isCommon = CLng(rsFlag("is_common"))
        rsFlag.Close : Set rsFlag = Nothing

        If Err.Number <> 0 Then Call FailTx()

        ' ✅ is_sub=1 : 연관된 값 전부 비활성화
        If isSub = 1 Then

            Dbcon.Execute _
                "UPDATE dbo.bom3_table_value SET is_active=0 " & _
                "WHERE title_sub_value_id IN ( " & _
                "   SELECT sub_value_id FROM dbo.bom3_title_sub_value " & _
                "   WHERE title_sub_id IN (SELECT title_sub_id FROM dbo.bom3_list_title_sub WHERE list_title_id=" & pId & ") " & _
                ") AND is_active=1;"
            If Err.Number <> 0 Then Call FailTx()

            Dbcon.Execute "UPDATE dbo.bom3_list_title SET is_active=0 WHERE list_title_id=" & pId & ";"
            If Err.Number <> 0 Then Call FailTx()

            Dbcon.Execute "UPDATE dbo.bom3_list_title_sub SET is_active=0 WHERE list_title_id=" & pId & ";"
            If Err.Number <> 0 Then Call FailTx()

            Dbcon.Execute _
                "UPDATE dbo.bom3_title_sub_value SET is_active=0 " & _
                "WHERE title_sub_id IN (SELECT title_sub_id FROM dbo.bom3_list_title_sub WHERE list_title_id=" & pId & ");"
            If Err.Number <> 0 Then Call FailTx()

        ' ✅ is_common=1 (또는 둘다0) : table_value + list_title 비활성화
        Else
            Dbcon.Execute _
                "UPDATE dbo.bom3_table_value SET is_active=0 " & _
                "WHERE list_title_id=" & pId & " AND is_active=1;"
            If Err.Number <> 0 Then Call FailTx()

            Dbcon.Execute "UPDATE dbo.bom3_list_title SET is_active=0 WHERE list_title_id=" & pId & ";"
            If Err.Number <> 0 Then Call FailTx()
        End If

    ElseIf pType = "master" Then

        ' ✅ 버튼 하나로 처리: 사용중 material도 먼저 비활성화(강제 포함)
        Dbcon.Execute _
            "UPDATE dbo.bom3_material SET is_active=0 " & _
            "WHERE material_id IN ( " & _
            "  SELECT DISTINCT m.material_id " & _
            "  FROM dbo.bom3_list_title t " & _
            "  JOIN dbo.bom3_table_value v ON t.list_title_id=v.list_title_id " & _
            "  JOIN dbo.bom3_material m ON v.material_id=m.material_id " & _
            "  WHERE t.master_id=" & pId & " AND t.is_active=1 AND v.is_active=1 AND m.is_active=1 " & _
            ");"
        If Err.Number <> 0 Then Call FailTx()

        Dbcon.Execute "UPDATE dbo.bom3_master SET is_active=0 WHERE master_id=" & pId & ";"
        If Err.Number <> 0 Then Call FailTx()

    Else
        Dbcon.RollbackTrans
        Call DbClose()
        Response.Write "INVALID TYPE"
        Response.End
    End If

    Dbcon.CommitTrans
    On Error GoTo 0
    Call DbClose()
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<script>
alert("비활성화가 완료되었습니다.");
if (window.opener && window.opener.reloadCurrentTab){
  window.opener.reloadCurrentTab();
}else if (window.opener){
  window.opener.location.reload();
}
window.close();
</script>
</head>
<body></body>
</html>
<%
    Response.End
End If
' ===================== POST END =====================


' =========================================================
' ✅ GET 화면 구성
' =========================================================

Dim titleText, warnText, okText
titleText = ""
warnText  = ""
okText    = ""

Dim ltIsSub, ltIsCommon, ltMasterId
ltIsSub = 0 : ltIsCommon = 0 : ltMasterId = 0

Dim RsList, sqlList
Set RsList = Nothing
sqlList = ""

If pType = "master" Then
    titleText = "카테고리"
    warnText  = "⚠ 사용 중 Material 이 존재합니다."
    okText    = "사용 중인 Material 이 없습니다.<br>바로 비활성화할 수 있습니다."

    sqlList = _
        "SELECT DISTINCT m.material_id, m.material_name " & _
        "FROM dbo.bom3_list_title t " & _
        "JOIN dbo.bom3_table_value v ON t.list_title_id = v.list_title_id " & _
        "JOIN dbo.bom3_material m ON v.material_id = m.material_id " & _
        "WHERE t.master_id=" & pId & " AND t.is_active=1 AND v.is_active=1 AND m.is_active=1 " & _
        "ORDER BY m.material_id"

    Set RsList = Server.CreateObject("ADODB.Recordset")
    RsList.CursorLocation = 3
    RsList.CursorType = 3
    RsList.LockType = 1
    RsList.Open sqlList, Dbcon

ElseIf pType = "title" Then
    titleText = "타이틀"

    ' list_title flags
    Dim rsLt
    Set rsLt = Server.CreateObject("ADODB.Recordset")
    rsLt.Open _
        "SELECT ISNULL(master_id,0) AS master_id, ISNULL(is_sub,0) AS is_sub, ISNULL(is_common,0) AS is_common " & _
        "FROM dbo.bom3_list_title WHERE list_title_id=" & pId, Dbcon

    If Not rsLt.EOF Then
        ltMasterId = CLng(rsLt("master_id"))
        ltIsSub    = Abs(CLng(rsLt("is_sub")))
        ltIsCommon = Abs(CLng(rsLt("is_common")))
    End If
    rsLt.Close : Set rsLt = Nothing

    ' is_common=1일 때 문구
    If ltIsCommon = 1 And ltIsSub = 0 Then
        warnText = "⚠ 사용 중인 값(value)이 존재합니다."
        okText   = "사용 중인 값(value)이 없습니다.<br>바로 비활성화할 수 있습니다."
    Else
        warnText = "⚠ 해당 카테고리의 리스트 항목이 존재합니다."
        okText   = "해당 카테고리의 리스트 항목이 없습니다.<br>바로 비활성화할 수 있습니다."
    End If

    ' (표시용) 기존 리스트 조회는 is_common=1이면 숨길거라서 유지해도 됨
    sqlList = _
        "SELECT ISNULL(m.item_name, N'공통') AS master_name, v.sub_value " & _
        "FROM dbo.bom3_title_sub_value v " & _
        "JOIN dbo.bom3_list_title_sub s ON v.title_sub_id = s.title_sub_id " & _
        "LEFT JOIN dbo.bom3_master m ON v.master_id = m.master_id " & _
        "WHERE s.list_title_id=" & pId & " AND s.is_active=1 AND s.is_select=1 AND v.is_active=1 " & _
        "ORDER BY v.row_id, v.title_sub_id"

    Set RsList = Server.CreateObject("ADODB.Recordset")
    RsList.CursorLocation = 3
    RsList.CursorType = 3
    RsList.LockType = 1
    RsList.Open sqlList, Dbcon

Else
    Response.Write "INVALID TYPE"
    Call DbClose()
    Response.End
End If

' =========================================================
' ✅ 사용중 판단(useCount/hasUse)
' - title: is_sub이면 title_sub_value 기준 / is_common이면 table_value(value) 기준
' - master: RsList 존재 여부
' =========================================================
Dim useCount, hasUse
useCount = 0 : hasUse = False

If pType = "title" Then
    Dim rsCnt, sqlCnt
    Set rsCnt = Server.CreateObject("ADODB.Recordset")

    If ltIsSub = 1 Then
        sqlCnt = _
            "SELECT COUNT(DISTINCT v.row_id) AS cnt " & _
            "FROM dbo.bom3_title_sub_value v " & _
            "JOIN dbo.bom3_list_title_sub s ON v.title_sub_id=s.title_sub_id " & _
            "WHERE s.list_title_id=" & pId & " AND v.is_active=1"
    Else
        sqlCnt = _
            "SELECT COUNT(*) AS cnt " & _
            "FROM dbo.bom3_table_value v " & _
            "WHERE v.list_title_id=" & pId & " AND v.is_active=1 AND v.value IS NOT NULL"
    End If

    rsCnt.Open sqlCnt, Dbcon
    If Not rsCnt.EOF Then useCount = CLng(rsCnt("cnt"))
    rsCnt.Close : Set rsCnt = Nothing

    hasUse = (useCount > 0)
Else
    If Not (RsList Is Nothing) Then
        hasUse = Not RsList.EOF
    Else
        hasUse = False
    End If
End If

' =========================================================
' ✅ title: 사용중 원자재(RsUsedMat)
' - is_sub=1  : value_text = svName.sub_value
' - is_common : value_text = tv.value (요청 쿼리 형태)
' =========================================================
Dim RsUsedMat, sqlUsedMat
Set RsUsedMat = Nothing
sqlUsedMat = ""

Dim codeSubId, nameSubId
codeSubId = 0 : nameSubId = 0

If pType = "title" Then

    ' is_sub일 때 codeSubId/nameSubId 감지
    If ltIsSub = 1 Then
        Dim rsTmp, q1, q2
        Set rsTmp = Server.CreateObject("ADODB.Recordset")

        q1 = _
            "SELECT TOP 1 s.title_sub_id AS codeSubId " & _
            "FROM dbo.bom3_list_title_sub s " & _
            "WHERE s.list_title_id=" & pId & " AND s.is_active=1 AND s.is_select=1 " & _
            "  AND EXISTS(SELECT 1 FROM dbo.bom3_title_sub_value v WHERE v.title_sub_id=s.title_sub_id AND v.is_active=1) " & _
            "ORDER BY s.title_sub_id DESC"

        rsTmp.Open q1, Dbcon
        If Not rsTmp.EOF Then
            If Not IsNull(rsTmp("codeSubId")) Then codeSubId = CLng(rsTmp("codeSubId"))
        End If
        rsTmp.Close

        q2 = _
            "SELECT TOP 1 s2.title_sub_id AS nameSubId " & _
            "FROM dbo.bom3_list_title_sub s2 " & _
            "WHERE s2.list_title_id=" & pId & " AND s2.is_active=1 AND ISNULL(s2.is_select,0)=0 " & _
            "  AND EXISTS(SELECT 1 FROM dbo.bom3_title_sub_value v2 WHERE v2.title_sub_id=s2.title_sub_id AND v2.is_active=1) " & _
            "ORDER BY s2.title_sub_id ASC"

        rsTmp.Open q2, Dbcon
        If Not rsTmp.EOF Then
            If Not IsNull(rsTmp("nameSubId")) Then nameSubId = CLng(rsTmp("nameSubId"))
        End If
        rsTmp.Close

        Set rsTmp = Nothing
        If nameSubId = 0 Then nameSubId = codeSubId
    End If

    ' ✅ 쿼리 생성
    If ltIsSub = 1 And codeSubId > 0 Then

        sqlUsedMat = _
            "SELECT " & _
            "  m.item_name, " & _
            "  bm.material_name, " & _
            "  svName.sub_value AS value_text " & _
            "FROM dbo.bom3_material bm " & _
            "JOIN dbo.bom3_master m " & _
            "  ON m.master_id=bm.master_id AND m.is_active=1 " & _
            "OUTER APPLY ( " & _
            "  SELECT TOP 1 v.title_sub_value_id " & _
            "  FROM dbo.bom3_table_value v " & _
            "  WHERE v.material_id=bm.material_id " & _
            "    AND v.is_active=1 " & _
            "    AND v.title_sub_id=" & codeSubId & _
            "  ORDER BY v.table_value_id DESC " & _
            ") tv " & _
            "LEFT JOIN dbo.bom3_title_sub_value svCode " & _
            "  ON svCode.sub_value_id=tv.title_sub_value_id " & _
            " AND svCode.is_active=1 AND svCode.title_sub_id=" & codeSubId & _
            "LEFT JOIN dbo.bom3_title_sub_value svName " & _
            "  ON svName.is_active=1 " & _
            " AND svName.title_sub_id=" & nameSubId & _
            " AND svName.row_id=svCode.row_id " & _
            " AND ISNULL(svName.master_id,-1)=ISNULL(svCode.master_id,-1) " & _
            "WHERE bm.is_active=1 " & _
            "  AND bm.master_id=" & ltMasterId & _
            "  AND tv.title_sub_value_id IS NOT NULL " & _
            "ORDER BY m.master_id, bm.material_id;"

    Else
        ' ✅ is_common=1 또는 둘다 0 : 요청 쿼리 사용 (value_text = tv.value)
        sqlUsedMat = _
            "SELECT " & _
            "  m.item_name, " & _
            "  bm.material_name, " & _
            "  tv.value AS value_text " & _
            "FROM dbo.bom3_material bm " & _
            "JOIN dbo.bom3_master m " & _
            "  ON m.master_id = bm.master_id " & _
            " AND m.is_active = 1 " & _
            "OUTER APPLY ( " & _
            "    SELECT TOP 1 " & _
            "      v.title_sub_value_id, " & _
            "      v.value " & _
            "    FROM dbo.bom3_table_value v " & _
            "    JOIN dbo.bom3_list_title lt " & _
            "      ON m.master_id = lt.master_id " & _
            "    WHERE v.material_id = bm.material_id " & _
            "      AND v.is_active = 1 " & _
            "      AND v.list_title_id = " & pId & _
            "    ORDER BY v.table_value_id DESC " & _
            ") tv " & _
            "WHERE bm.is_active = 1 " & _
            "  AND tv.value IS NOT NULL " & _
            "ORDER BY m.master_id, bm.material_id;"
    End If

    Set RsUsedMat = Server.CreateObject("ADODB.Recordset")
    RsUsedMat.CursorLocation = 3
    RsUsedMat.CursorType = 3
    RsUsedMat.LockType = 1
    RsUsedMat.Open sqlUsedMat, Dbcon
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%=titleText%> 비활성화</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background:#f1f3f5; }
.popup-box{
    background:#fff;
    border-radius:8px;
    padding:20px;
    box-shadow:0 10px 25px rgba(0,0,0,.1);
}
</style>
</head>
<body class="p-3">
<div class="popup-box">

<h5 class="mb-3 text-danger">🔒 <%=titleText%> 비활성화</h5>

<% If pType="title" Then %>
  <% If hasUse Then %>
    <div class="alert alert-warning mb-3">
      <strong><%=warnText%> (총 <%=useCount%>건)</strong>
    </div>
  <% Else %>
    <div class="alert alert-success mb-3"><%=okText%></div>
  <% End If %>
<% Else %>
  <% If hasUse Then %>
    <div class="alert alert-warning mb-3"><strong><%=warnText%></strong></div>
  <% Else %>
    <div class="alert alert-success mb-3"><%=okText%></div>
  <% End If %>
<% End If %>

<% If pType="title" Then %>
  <% If ltIsCommon <> 1 Then %>
    <div class="table-responsive mb-3">
      <table class="table table-bordered table-sm">
        <thead class="table-light">
          <tr>
            <th>카테고리</th>
            <th style="width:180px;">종류</th>
          </tr>
        </thead>
        <tbody>
        <%
          If RsList Is Nothing Then
        %>
          <tr><td colspan="2" class="text-center text-muted">표시할 데이터가 없습니다.</td></tr>
        <%
          ElseIf RsList.EOF Then
        %>
          <tr><td colspan="2" class="text-center text-muted">표시할 데이터가 없습니다.</td></tr>
        <%
          Else
            RsList.MoveFirst
            Do While Not RsList.EOF
        %>
          <tr>
            <td><%=Server.HTMLEncode(Nz(RsList("master_name")))%></td>
            <td><%=Server.HTMLEncode(Nz(RsList("sub_value")))%></td>
          </tr>
        <%
              RsList.MoveNext
            Loop
          End If
        %>
        </tbody>
      </table>
    </div>
  <% End If %>

  <div class="mt-4">
    <div class="alert alert-secondary py-2 mb-2">사용 중인 원자재</div>

    <div class="table-responsive mb-2">
      <table class="table table-bordered table-sm">
        <thead class="table-light">
          <tr>
            <th>카테고리</th>
            <th>원자재</th>
            <th style="width:220px;">값(value)</th>
          </tr>
        </thead>
        <tbody>
        <%
          If RsUsedMat Is Nothing Then
        %>
          <tr><td colspan="3" class="text-center text-muted">표시할 데이터가 없습니다.</td></tr>
        <%
          ElseIf RsUsedMat.EOF Then
        %>
          <tr><td colspan="3" class="text-center text-muted">표시할 데이터가 없습니다.</td></tr>
        <%
          Else
            RsUsedMat.MoveFirst
            Do While Not RsUsedMat.EOF
        %>
          <tr>
            <td><%=Server.HTMLEncode(Nz(RsUsedMat("item_name")))%></td>
            <td><%=Server.HTMLEncode(Nz(RsUsedMat("material_name")))%></td>
            <td><%=Server.HTMLEncode(Nz(RsUsedMat("value_text")))%></td>
          </tr>
        <%
              RsUsedMat.MoveNext
            Loop
          End If
        %>
        </tbody>
      </table>
    </div>

    <form method="post"
          action="<%=Request.ServerVariables("SCRIPT_NAME")%>?type=<%=pType%>&id=<%=pId%>"
          class="text-end mt-2"
          onsubmit="return confirm('정말 삭제 하시겠습니까?');">
      <button class="btn btn-danger">비활성화</button>
      <button type="button" class="btn btn-secondary" onclick="window.close()">취소</button>
    </form>

  </div>

<% Else  master %>

  <div class="table-responsive mb-3">
    <table class="table table-bordered table-sm">
      <thead class="table-light">
        <tr>
          <th style="width:80px;" class="text-center">상태</th>
          <th>Material 명</th>
        </tr>
      </thead>
      <tbody>
      <%
        If RsList Is Nothing Then
      %>
        <tr><td colspan="2" class="text-center text-muted">표시할 데이터가 없습니다.</td></tr>
      <%
        ElseIf RsList.EOF Then
      %>
        <tr><td colspan="2" class="text-center text-muted">표시할 데이터가 없습니다.</td></tr>
      <%
        Else
          RsList.MoveFirst
          Do While Not RsList.EOF
      %>
        <tr>
          <td class="text-center"><span class="badge bg-danger">사용중</span></td>
          <td><%=Server.HTMLEncode(Nz(RsList("material_name")))%></td>
        </tr>
      <%
            RsList.MoveNext
          Loop
        End If
      %>
      </tbody>
    </table>
  </div>

  <form method="post"
        action="<%=Request.ServerVariables("SCRIPT_NAME")%>?type=<%=pType%>&id=<%=pId%>"
        class="text-end"
        onsubmit="return confirm('정말 삭제 하시겠습니까?');">
    <button class="btn btn-danger">비활성화</button>
    <button type="button" class="btn btn-secondary" onclick="window.close()">취소</button>
  </form>

<% End If %>

</div>
</body>
</html>

<%
' ===============================
' cleanup
' ===============================
On Error Resume Next

If Not (RsList Is Nothing) Then
  If RsList.State = 1 Then RsList.Close
  Set RsList = Nothing
End If

If Not (RsUsedMat Is Nothing) Then
  If RsUsedMat.State = 1 Then RsUsedMat.Close
  Set RsUsedMat = Nothing
End If

On Error GoTo 0
Call DbClose()
%>
