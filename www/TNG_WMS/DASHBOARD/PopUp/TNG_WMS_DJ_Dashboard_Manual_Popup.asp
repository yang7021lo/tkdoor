<%@ codepage="65001" language="vbscript" %>
<%
Session.CodePage = "65001"
Response.Charset = "utf-8"
Response.Buffer = True
On Error Resume Next
%>
<!-- DB / 쿠키 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()
Function SqlSafe(v)
    If IsNull(v) Then
        SqlSafe = ""
    Else
        SqlSafe = Replace(CStr(v), "'", "''")
    End If
End Function
Function SafeLong(v)
    If IsNumeric(v) Then
        SafeLong = CLng(v)
    Else
        SafeLong = 0
    End If
End Function
Dim action, djmanual_idx, ymd
action = LCase(Trim(Request("action")))
djmanual_idx = SafeLong(Request("djmanual_idx"))
ymd = Trim(Request("ymd"))
If ymd = "" Then ymd = Replace(Date(), "-", "")
ymd = Replace(ymd, "-", "")
Dim cname, item_name, meas_name, qtyname, pname
Dim coat, djnum, totalquan, spec_text, djmemo
If action = "save" Then
    cname = Trim(Request.Form("cname"))
    item_name = Trim(Request.Form("item_name"))
    meas_name = Trim(Request.Form("meas_name"))
    qtyname = Trim(Request.Form("qtyname"))
    pname = Trim(Request.Form("pname"))
    coat = SafeLong(Request.Form("coat"))
    djnum = Trim(Request.Form("djnum"))
    totalquan = SafeLong(Request.Form("totalquan"))
    spec_text = Request.Form("spec_text")
    djmemo = Request.Form("djmemo")
    Dim SQL
    If djmanual_idx > 0 Then
        SQL = ""
        SQL = SQL & "UPDATE dbo.tk_wms_dj_dashboard_manual SET "
        SQL = SQL & "ymd='" & SqlSafe(ymd) & "', "
        SQL = SQL & "cname=N'" & SqlSafe(cname) & "', "
        SQL = SQL & "item_name=N'" & SqlSafe(item_name) & "', "
        SQL = SQL & "meas_name=N'" & SqlSafe(meas_name) & "', "
        SQL = SQL & "qtyname=N'" & SqlSafe(qtyname) & "', "
        SQL = SQL & "pname=N'" & SqlSafe(pname) & "', "
        SQL = SQL & "coat=" & coat & ", "
        SQL = SQL & "djnum=N'" & SqlSafe(djnum) & "', "
        SQL = SQL & "totalquan=" & totalquan & ", "
        SQL = SQL & "spec_text=N'" & SqlSafe(spec_text) & "', "
        SQL = SQL & "djmemo=N'" & SqlSafe(djmemo) & "', "
        SQL = SQL & "upd_dt=GETDATE() "
        SQL = SQL & "WHERE djmanual_idx=" & djmanual_idx
        Dbcon.Execute SQL
    Else
        SQL = ""
        SQL = SQL & "INSERT INTO dbo.tk_wms_dj_dashboard_manual "
        SQL = SQL & "(ymd, cname, item_name, meas_name, qtyname, pname, coat, djnum, totalquan, spec_text, djmemo) "
        SQL = SQL & "VALUES ("
        SQL = SQL & "'" & SqlSafe(ymd) & "', "
        SQL = SQL & "N'" & SqlSafe(cname) & "', "
        SQL = SQL & "N'" & SqlSafe(item_name) & "', "
        SQL = SQL & "N'" & SqlSafe(meas_name) & "', "
        SQL = SQL & "N'" & SqlSafe(qtyname) & "', "
        SQL = SQL & "N'" & SqlSafe(pname) & "', "
        SQL = SQL & coat & ", "
        SQL = SQL & "N'" & SqlSafe(djnum) & "', "
        SQL = SQL & totalquan & ", "
        SQL = SQL & "N'" & SqlSafe(spec_text) & "', "
        SQL = SQL & "N'" & SqlSafe(djmemo) & "')"
        Dbcon.Execute SQL
    End If
    Response.Write "<script>alert('저장되었습니다.'); if (window.opener) { window.opener.location.reload(); } window.close();</script>"
    call dbClose()
    Response.End
End If
If action = "delete" And djmanual_idx > 0 Then
    Dbcon.Execute "UPDATE dbo.tk_wms_dj_dashboard_manual SET is_active=0, upd_dt=GETDATE() WHERE djmanual_idx=" & djmanual_idx
    Response.Write "<script>alert('삭제되었습니다.'); if (window.opener) { window.opener.location.reload(); } window.close();</script>"
    call dbClose()
    Response.End
End If
If djmanual_idx > 0 Then

    Set Rs = Server.CreateObject("ADODB.Recordset")
    SQL = ""
    SQL = SQL & "SELECT ymd, cname, item_name, meas_name, qtyname, pname, coat, djnum, totalquan, spec_text, djmemo "
    SQL = SQL & "FROM dbo.tk_wms_dj_dashboard_manual WITH (NOLOCK) "
    SQL = SQL & "WHERE djmanual_idx=" & djmanual_idx
    Rs.Open SQL, Dbcon, 1, 1
    If Not (Rs.BOF Or Rs.EOF) Then
        ymd = "" & Rs("ymd")
        cname = "" & Rs("cname")
        item_name = "" & Rs("item_name")
        meas_name = "" & Rs("meas_name")
        qtyname = "" & Rs("qtyname")
        pname = "" & Rs("pname")
        coat = SafeLong(Rs("coat"))
        djnum = "" & Rs("djnum")
        totalquan = SafeLong(Rs("totalquan"))
        spec_text = "" & Rs("spec_text")
        djmemo = "" & Rs("djmemo")
    End If
    Rs.Close : Set Rs = Nothing
End If
Dim ymd_html
If Len(ymd) = 8 Then
    ymd_html = Left(ymd,4) & "-" & Mid(ymd,5,2) & "-" & Mid(ymd,7,2)
Else
    ymd_html = ""
End If
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>도장 수동등록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { font-family:'맑은 고딕','Noto Sans KR',sans-serif; font-size:14px; background:#f8f9fa; margin:20px; }
.form-label { font-weight:600; }
.form-card { background:#fff; border:1px solid #e5e5e5; border-radius:8px; padding:18px; }
.row-gap { row-gap:12px; }
</style>
</head>
<body>
<h4>도장 수동등록</h4>
<form method="post" class="form-card">
    <input type="hidden" name="action" value="save">
    <input type="hidden" name="djmanual_idx" value="<%=djmanual_idx%>">
    <input type="hidden" name="ymd" value="<%=ymd%>">
    <div class="row row-gap">
        <div class="col-4">
            <label class="form-label">출고일</label>
            <input type="date" class="form-control" value="<%=ymd_html%>" disabled>
        </div>
        <div class="col-8">
            <label class="form-label">거래처명</label>
            <input type="text" name="cname" class="form-control" value="<%=Server.HTMLEncode(cname)%>" required>
        </div>
        <div class="col-6">
            <label class="form-label">품목명</label>
            <input type="text" name="item_name" class="form-control" value="<%=Server.HTMLEncode(item_name)%>" required>
        </div>

        <div class="col-6">
            <label class="form-label">도장명</label>
            <input type="text" name="qtyname" class="form-control" value="<%=Server.HTMLEncode(qtyname)%>" required>
        </div>
        <div class="col-6">
            <label class="form-label">재질</label>
            <input type="text" name="pname" class="form-control" value="<%=Server.HTMLEncode(pname)%>" required>
        </div>
        <div class="col-4">
            <label class="form-label">코트</label>
            <select name="coat" class="form-select">
                <option value="0" <% If CLng(0 & coat) = 0 Then %>selected<% End If %>>0 (없음)</option>
                <option value="1" <% If CLng(0 & coat) = 1 Then %>selected<% End If %>>1 (기본/2코트)</option>
                <option value="2" <% If CLng(0 & coat) = 2 Then %>selected<% End If %>>2 (필수/3코트)</option>
            </select>
        </div>
        <div class="col-4">
            <label class="form-label">도장번호</label>
            <input type="text" name="djnum" class="form-control" value="<%=Server.HTMLEncode(djnum)%>" required>
        </div>
        <div class="col-4">
            <label class="form-label">총수량</label>
            <input type="number" name="totalquan" class="form-control" value="<%=totalquan%>">
        </div>
        <div class="col-12">
            <label class="form-label">규격 텍스트</label>
            <textarea name="spec_text" class="form-control" rows="4"><%=Server.HTMLEncode(spec_text)%></textarea>
        </div>
        <div class="col-12">
            <label class="form-label">비고</label>
            <textarea name="djmemo" class="form-control" rows="4"><%=Server.HTMLEncode(djmemo)%></textarea>
        </div>
    </div>
    <div class="mt-3 d-flex gap-2">
        <button type="submit" class="btn btn-primary">저장</button>
        <% If djmanual_idx > 0 Then %>
        <button type="button" class="btn btn-outline-danger" onclick="deleteRow()">삭제</button>
        <% End If %>
        <button type="button" class="btn btn-outline-secondary" onclick="window.close()">닫기</button>
    </div>
</form>
<script>
function deleteRow(){
    if(!confirm('삭제하시겠습니까?')) return;
    const url = location.pathname + '?action=delete&djmanual_idx=<%=djmanual_idx%>&ymd=<%=Server.URLEncode(ymd)%>';
    location.href = url;
}
</script>
</body>
</html>
<%
call dbClose()
%>