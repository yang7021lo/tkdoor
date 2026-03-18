<%@ Codepage="65001" Language="VBScript" %>


<%
Session.CodePage = 65001
Response.Charset = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

sjidx = Request("sjidx")
'response.write "sjidx :" &sjidx& "<br>"
    ' 💾 저장 요청 (POST)
    If Request.ServerVariables("REQUEST_METHOD") = "POST" Then

        arrNote = Request.Form("item_note[]")

        If Not IsArray(arrNote) Then
            arrNote = Split(arrNote, ",")
        End If

        result = ""

        For i = 0 To UBound(arrNote)
            note = Trim(arrNote(i))
            ' 🧩 빈칸도 "" 추가
            If note = "" Then
                note = """" ' 빈 문자열 기호 저장 → "
            End If
            If note <> "" Then
                If result <> "" Then result = result & "||"
                result = result & note
            End If
        Next

        SQL = "UPDATE tk_wms_meta SET memo='" & result & "' WHERE sjidx='" & sjidx & "'"
        Dbcon.Execute(SQL)

        call dbClose()
        Response.Write "<script>alert('저장되었습니다.');</script>"
        Response.Write "<script>window.opener.location.reload(); window.close();</script>"
        Response.End
    End If

' 📌 GET 요청일 때 품목 목록 조회
SQL = ""
SQL = SQL & "SELECT A.sjidx, A.sjsidx, A.framename, B.memo "
SQL = SQL & "FROM tng_sjaSub AS A "
SQL = SQL & "LEFT JOIN tk_wms_meta AS B ON A.sjidx = B.sjidx "
SQL = SQL & "WHERE A.sjidx='" & sjidx & "' AND A.astatus='1'"
'response.write "SQL : " &SQL& "<br>" 
Set Rs = Dbcon.Execute(SQL)
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
* { box-sizing:border-box; font-family:"Pretendard","Segoe UI",sans-serif; }
body { padding:20px; background:#f5f7fa; }

.table { width:100%; border-collapse:collapse; margin-top:10px; }
.table th, .table td { border:1px solid #cfd5e3; padding:8px; font-size:14px; }
.table th { background:#e5ecff; font-weight:bold; color:#005bbb; }

input[type=text] { width:100%; padding:6px 8px; border:1px solid #c2cad8; border-radius:4px; }

.btn {
    margin-top:15px; width:100%; padding:10px 12px;
    background:#005bbb; color:white; border:none; border-radius:6px;
    font-size:15px; font-weight:600; cursor:pointer;
}
.btn:hover { background:#004b9b; }
</style>
</head>

<body>

<h3 style="margin:0 0 10px 0; color:#222;">📝 품목별 비고 입력</h3>

<form method="post" action="TNG_WMS_Bigo_popup.asp">

<table class="table">
<tr>
    <th style="width:45%;">품목명</th>
    <th>비고</th>
</tr>

<%
If Not (Rs.BOF Or Rs.EOF) Then
    Do Until Rs.EOF
%>
<tr>
    <td><%=Rs("framename")%></td>
    <td>
    <%         ' === 메모 분리 ===
        memo = Rs("memo")
        
        If Not IsNull(memo) Then
            arrMemo = Split(memo, "||")
        Else
            c = Array("")
        End If
        
        ' === 메모 출력 ===
        memoText = ""

        If Trim(memo) <> "" Then
            If rowCounter <= UBound(arrMemo) Then
                memoText = Trim(arrMemo(rowCounter))

                ' "" → 빈칸 처리
                If memoText = """" Then memoText = ""
            End If
        End If 
        
    %>
      <input type="text" name="item_note[]" placeholder="확인사항을 입력하세요" value="<%= memoText %>" style="width:100%;">
    </td>
</tr>
<%
        rowCounter = rowCounter + 1
        Rs.MoveNext
    Loop
End If
Rs.Close
Set Rs = Nothing
%>

</table>

<input type="hidden" name="sjidx" value="<%=sjidx%>">
<button type="submit" class="btn">✔ 저장하기</button>
<script>

</script>
</form>

</body>
</html>
