<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
If c_midx = "" Then
    Response.Write "<script>alert('login 먼저해주세요');window.close();</script>"
    Response.End
End If

call dbOpen()

Dim mode
mode = Trim(Request("mode") & "")

' SQL 인젝션 방지
Function SafeStr(s)
    SafeStr = Replace(s, "'", "''")
End Function
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>페인트 pname 마이그레이션</title>
<style>
body { font-family:'Segoe UI',sans-serif; padding:20px; background:#f5f5f5; }
h1 { font-size:18px; color:#1565C0; }
table { border-collapse:collapse; width:100%; margin:10px 0; background:#fff; }
th,td { border:1px solid #ddd; padding:6px 10px; font-size:12px; }
th { background:#E3F2FD; font-weight:700; }
.old { color:#999; }
.new { color:#1565C0; font-weight:700; }
.skip { color:#999; font-style:italic; }
.btn { display:inline-block; padding:10px 24px; margin:10px 4px; border:none; border-radius:6px; font-size:14px; font-weight:700; cursor:pointer; text-decoration:none; color:#fff; }
.btn-preview { background:#1976D2; }
.btn-run { background:#E53935; }
.btn-run:hover { background:#C62828; }
.result { padding:12px; margin:10px 0; border-radius:6px; font-weight:700; font-size:14px; }
.result-ok { background:#E8F5E9; color:#2E7D32; }
.result-err { background:#FFEBEE; color:#C62828; }
.warn { background:#FFF3E0; color:#E65100; padding:10px; border-radius:6px; margin:10px 0; }
</style>
</head>
<body>
<h1>페인트 pname 마이그레이션 (pcode + pname)</h1>
<p>pcode가 있는 페인트의 pname 앞에 pcode를 붙입니다. 이미 붙어있는 건 스킵합니다.</p>

<%
' ===== 미리보기 =====
If mode = "" Or mode = "preview" Then

    Dim sqlPreview, rsPreview, cnt
    sqlPreview = "SELECT pidx, pcode, pname, " & _
                 "RTRIM(LTRIM(pcode)) + ' ' + ISNULL(pname,'') AS new_pname " & _
                 "FROM tk_paint " & _
                 "WHERE pcode IS NOT NULL " & _
                 "AND RTRIM(LTRIM(pcode)) <> '' " & _
                 "AND RTRIM(LTRIM(pcode)) <> '0' " & _
                 "AND ( " & _
                 "  pname IS NULL " & _
                 "  OR pname = '' " & _
                 "  OR ( " & _
                 "    pname NOT LIKE RTRIM(LTRIM(pcode)) + ' %' " & _
                 "    AND pname NOT LIKE RTRIM(LTRIM(pcode)) + '%' " & _
                 "    AND pname <> RTRIM(LTRIM(pcode)) " & _
                 "  ) " & _
                 ") " & _
                 "ORDER BY pidx"

    Set rsPreview = DbCon.Execute(sqlPreview)
    cnt = 0
%>
    <h2>미리보기 (UPDATE 대상)</h2>
    <table>
        <thead>
            <tr><th>pidx</th><th>pcode</th><th>현재 pname</th><th>변경 후 pname</th></tr>
        </thead>
        <tbody>
<%
    Do While Not rsPreview.EOF
        cnt = cnt + 1
        Response.Write "<tr>"
        Response.Write "<td>" & rsPreview("pidx") & "</td>"
        Response.Write "<td>" & Server.HTMLEncode(rsPreview("pcode") & "") & "</td>"
        Response.Write "<td class='old'>" & Server.HTMLEncode(rsPreview("pname") & "") & "</td>"
        Response.Write "<td class='new'>" & Server.HTMLEncode(rsPreview("new_pname") & "") & "</td>"
        Response.Write "</tr>"
        rsPreview.MoveNext
    Loop
    rsPreview.Close
    Set rsPreview = Nothing

    If cnt = 0 Then
        Response.Write "<tr><td colspan='4' class='skip'>변경 대상이 없습니다 (이미 모두 적용됨)</td></tr>"
    End If
%>
        </tbody>
    </table>
    <p><b>총 <%=cnt%>건</b> 변경 예정</p>

<%  If cnt > 0 Then %>
    <div class="warn">실행 후 되돌릴 수 없습니다. 미리보기를 꼼꼼히 확인하세요.</div>
    <a class="btn btn-preview" href="migrate_pname.asp?mode=preview">새로고침</a>
    <a class="btn btn-run" href="migrate_pname.asp?mode=run" onclick="return confirm('정말 <%=cnt%>건을 UPDATE 하시겠습니까?');">UPDATE 실행</a>
<%  End If %>

<%
End If


' ===== 실행 =====
If mode = "run" Then

    Dim sqlUpdate, affected
    sqlUpdate = "UPDATE tk_paint " & _
                "SET pname = RTRIM(LTRIM(pcode)) + ' ' + ISNULL(pname,'') " & _
                "WHERE pcode IS NOT NULL " & _
                "AND RTRIM(LTRIM(pcode)) <> '' " & _
                "AND ( " & _
                "  pname IS NULL " & _
                "  OR pname = '' " & _
                "  OR ( " & _
                "    pname NOT LIKE RTRIM(LTRIM(pcode)) + ' %' " & _
                "    AND pname NOT LIKE RTRIM(LTRIM(pcode)) + '%' " & _
                "    AND pname <> RTRIM(LTRIM(pcode)) " & _
                "  ) " & _
                ") "

    On Error Resume Next
    DbCon.Execute sqlUpdate
    If Err.Number <> 0 Then
        Response.Write "<div class='result result-err'>오류: " & Server.HTMLEncode(Err.Description) & "</div>"
        Err.Clear
    Else
        ' 영향받은 행 수 확인
        Dim rsCount
        Set rsCount = DbCon.Execute("SELECT @@ROWCOUNT AS cnt")
        affected = rsCount("cnt")
        rsCount.Close
        Set rsCount = Nothing
        Response.Write "<div class='result result-ok'>UPDATE 완료! " & affected & "건 변경됨</div>"
    End If
    On Error GoTo 0

    Response.Write "<a class='btn btn-preview' href='migrate_pname.asp?mode=preview'>결과 확인</a>"

End If
%>

<hr style="margin-top:30px">
<p style="color:#999;font-size:11px;">이 파일은 마이그레이션 완료 후 삭제하세요.</p>

</body>
</html>
<%
call dbClose()
%>
