<%@ Codepage="65001" Language="VBScript" %>
<%
Session.CodePage = 65001
Response.Charset = "utf-8"
%>
<%
On Error Resume Next
%>

<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

sjsidx = Request("sjsidx")
    'response.write "sjsidx : " &sjsidx& "<br>" 
    'response.end
' ===========================================
' POST 저장 처리
' ===========================================
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then

    arrNote = Request.Form("item_note[]")

    If Not IsArray(arrNote) Then
        arrNote = Split(arrNote, ",")
    End If

    result = ""

    For i = 0 To UBound(arrNote)
        note = Trim(arrNote(i))

        ' 빈칸 저장 처리
        If note = "" Then
            note = """"    ' 빈 문자열 기호 "
        End If

        If result <> "" Then result = result & "||"
        result = result & note
    Next

    SQL = "UPDATE tk_wms_djnum SET memo='" & result & "' WHERE sjsidx='" & sjsidx & "'"
    Dbcon.Execute(SQL)
    'response.write "SQL : " &SQL& "<br>"
    'response.end
    call dbClose()
    Response.Write "<script>alert('저장되었습니다.');</script>"
    Response.Write "<script>window.opener.location.reload(); window.close();</script>"
    Response.End
End If


' ===========================================
' GET 요청: 단일 품목 조회
' ===========================================
SQL = ""
SQL = SQL & "SELECT A.sjidx, A.sjsidx, A.framename, B.memo "
SQL = SQL & "FROM tng_sjaSub AS A "
SQL = SQL & "LEFT JOIN tk_wms_djnum AS B ON A.sjsidx = B.sjsidx "
SQL = SQL & "WHERE A.sjsidx='" & sjsidx & "' AND A.astatus='1'"

Set Rs = Dbcon.Execute(SQL)

framename = ""
memo = ""

If Not Rs.EOF Then
    framename = Rs("framename")
    memo = Rs("memo")
End If

Rs.Close
Set Rs = Nothing

' ===========================================
' 기존 memo 분리
' ===========================================
memoText = ""

If Not IsNull(memo) And Trim(memo) <> "" Then
    arrMemo = Split(memo, "||")

    ' 첫 번째 비고 값만 사용 (단일 레코드 기준)
    If UBound(arrMemo) >= 0 Then
        memoText = Trim(arrMemo(0))
        If memoText = """" Then memoText = ""   ' "" → 빈칸
    End If
End If
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

<h3 style="margin:0 0 10px 0; color:#222;">📝 품목 비고 입력</h3>

<form method="post" action="TNG_WMS_Bigo_Djpopup.asp">

<table class="table">
<tr>
    <th style="width:45%;">품목명</th>
    <th>비고</th>
</tr>

<tr>
    <td><%= framename %></td>
    <td>
        <input type="text" name="item_note[]" placeholder="확인사항을 입력하세요"
               value="<%= memoText %>" style="width:100%;">
    </td>
</tr>
</table>

<input type="hidden" name="sjsidx" value="<%=sjsidx%>">

<button type="submit" class="btn">✔ 저장하기</button>

</form>

</body>
</html>
<%
Set Rs  = Nothing
call dbClose()
%>