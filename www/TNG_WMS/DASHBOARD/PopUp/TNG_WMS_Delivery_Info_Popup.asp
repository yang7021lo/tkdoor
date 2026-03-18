<%@ Language="VBScript" CodePage="65001" %>
<%

Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

Dim wms_idx, manual_idx, mode, wms_type, ymd
Dim SQL, Rs

Dim recv_name, recv_tel, recv_addr, recv_addr_detail, pay_type
Dim load_time, unload_time
Dim sql_pay_type, sql_load_time, sql_unload_time

wms_idx     = Trim(Request("wms_idx"))
manual_idx  = Trim(Request("manual_idx"))
mode        = LCase(Trim(Request("mode")))
wms_type    = Trim(Request("wms_type"))
ymd         = Trim(Request("ymd"))

recv_name        = ""
recv_tel         = ""
recv_addr        = ""
recv_addr_detail = ""
pay_type         = ""

load_time   = ""
unload_time = ""

Set Rs = Server.CreateObject("ADODB.Recordset")

' -------------------------
' 숫자 안전 변환
' -------------------------
Function SafeLng(v)
  On Error Resume Next
  SafeLng = CLng(0 & v)
  On Error GoTo 0
End Function

Function SqlEsc(s)
  s = "" & s
  SqlEsc = Replace(s, "'", "''")
End Function

Function DateToInput(v)
  If IsNull(v) Or v = "" Then
      DateToInput = ""
      Exit Function
  End If

  Dim d
  d = CDate(v)

  DateToInput = _
      Year(d) & "-" & _
      Right("0" & Month(d), 2) & "-" & _
      Right("0" & Day(d), 2) & "T" & _
      Right("0" & Hour(d), 2) & ":" & _
      Right("0" & Minute(d), 2)
End Function

' -------------------------
' 수동 여부 판단: manual_idx 우선
' -------------------------
Dim isManual
isManual = False
If SafeLng(manual_idx) > 0 Then isManual = True

' -------------------------
' WHERE 키 구성
'  - 수동: manual_idx
'  - 일반: wms_idx
' -------------------------
Dim keyField, keyValue
If isManual Then
  keyField = "manual_idx"
  keyValue = SafeLng(manual_idx)
Else
  keyField = "wms_idx"
  keyValue = SafeLng(wms_idx)
End If

If keyValue <= 0 Then
  Response.Write "<script>alert('wms_idx 또는 manual_idx가 없습니다.');window.close();</script>"
  Response.End
End If

' =================================
' 저장 (INSERT / UPDATE)
' =================================
If mode = "save" Then

    recv_name        = Trim(Request.Form("recv_name"))
    recv_tel         = Trim(Request.Form("recv_tel"))
    recv_addr        = Trim(Request.Form("recv_addr"))
    recv_addr_detail = Trim(Request.Form("recv_addr_detail"))
    pay_type         = Trim(Request.Form("pay_type"))

    If pay_type = "" Then
        sql_pay_type = "NULL"
    Else
        sql_pay_type = CLng(pay_type)
    End If

    ' ==============================
    ' delivery_info 존재 여부 체크
    ' ==============================
    SQL = "SELECT COUNT(*) AS cnt FROM tk_wms_delivery_info WHERE " & keyField & "=" & keyValue
    Set Rs = DbCon.Execute(SQL)

    Dim existsCnt
    existsCnt = 0
    If Not (Rs.BOF Or Rs.EOF) Then existsCnt = SafeLng(Rs("cnt"))

    ' ==============================
    ' INSERT / UPDATE
    ' ==============================
    If existsCnt = 0 Then
        SQL = ""
        SQL = SQL & "INSERT INTO tk_wms_delivery_info ("

        ' 수동이면 manual_idx 저장, 일반이면 wms_idx 저장
        If isManual Then
          SQL = SQL & " manual_idx, "
        Else
          SQL = SQL & " wms_idx, "
        End If

        SQL = SQL & " recv_name, recv_tel, recv_addr, recv_addr_detail, pay_type, midx "
        SQL = SQL & ") VALUES ("
        SQL = SQL & keyValue & ", "
        SQL = SQL & "N'" & SqlEsc(recv_name) & "', "
        SQL = SQL & "N'" & SqlEsc(recv_tel) & "', "
        SQL = SQL & "N'" & SqlEsc(recv_addr) & "', "
        SQL = SQL & "N'" & SqlEsc(recv_addr_detail) & "', "
        SQL = SQL & sql_pay_type & ", "
        SQL = SQL & "N'" & SqlEsc(midx) & "'"
        SQL = SQL & ")"
    Else
        SQL = ""
        SQL = SQL & "UPDATE tk_wms_delivery_info SET "
        SQL = SQL & " recv_name=N'" & SqlEsc(recv_name) & "', "
        SQL = SQL & " recv_tel=N'" & SqlEsc(recv_tel) & "', "
        SQL = SQL & " recv_addr=N'" & SqlEsc(recv_addr) & "', "
        SQL = SQL & " recv_addr_detail=N'" & SqlEsc(recv_addr_detail) & "', "
        SQL = SQL & " pay_type=" & sql_pay_type & ", "
        SQL = SQL & " meidx=N'" & SqlEsc(midx) & "', "
        SQL = SQL & " udate=GETDATE() "
        SQL = SQL & "WHERE " & keyField & "=" & keyValue
    End If

    DbCon.Execute SQL

    ' ==============================
    ' 용차일 때만 상/하차 시간 저장
    ' ==============================
    If CLng(0 & wms_type) = 13 Then

        load_time   = Trim(Request.Form("load_time"))
        unload_time = Trim(Request.Form("unload_time"))

        If load_time = "" Then
            sql_load_time = "NULL"
        Else
            sql_load_time = "'" & Replace(load_time, "T", " ") & ":00'"
        End If

        If unload_time = "" Then
            sql_unload_time = "NULL"
        Else
            sql_unload_time = "'" & Replace(unload_time, "T", " ") & ":00'"
        End If

        ' 동일 키로 다시 존재 체크
        SQL = "SELECT COUNT(*) AS cnt FROM tk_wms_delivery_info WHERE " & keyField & "=" & keyValue
        Set Rs = DbCon.Execute(SQL)

        existsCnt = 0
        If Not (Rs.BOF Or Rs.EOF) Then existsCnt = SafeLng(Rs("cnt"))

        If existsCnt = 0 Then
            SQL = "INSERT INTO tk_wms_delivery_info (" & _
                  keyField & ", load_time, unload_time, midx) VALUES (" & _
                  keyValue & ", " & sql_load_time & ", " & sql_unload_time & ", N'" & SqlEsc(midx) & "')"
        Else
            SQL = "UPDATE tk_wms_delivery_info SET " & _
                  " load_time=" & sql_load_time & ", " & _
                  " unload_time=" & sql_unload_time & ", " & _
                  " meidx=N'" & SqlEsc(midx) & "', udate=GETDATE() " & _
                  "WHERE " & keyField & "=" & keyValue
        End If

        DbCon.Execute SQL
    End If
%>
<script>
    if (window.opener && !window.opener.closed) {
        window.opener.location.reload();
    }
    window.close();
</script>
<%
    Response.End
End If

' =================================
' 조회 (최초 오픈)
' =================================
SQL = "SELECT TOP 1 * FROM tk_wms_delivery_info WHERE " & keyField & "=" & keyValue
Rs.Open SQL, DbCon, 1, 1
If Not Rs.EOF Then
    recv_name        = Rs("recv_name")
    recv_tel         = Rs("recv_tel")
    recv_addr        = Rs("recv_addr")
    recv_addr_detail = Rs("recv_addr_detail")
    pay_type         = Rs("pay_type")
    load_time        = Rs("load_time")
    unload_time      = Rs("unload_time")
    If IsNull(pay_type) Then pay_type = ""
End If
Rs.Close

' 기본 시간값(용차)
Dim default_load_time, default_unload_time
If ymd = "" Then ymd = Date()

default_load_time   = ymd & " 17:00:00"
default_unload_time = DateAdd("d", 1, ymd) & " 07:30:00"

If CLng(0 & wms_type) = 13 Then
    If IsNull(load_time) Or load_time = "" Then load_time = default_load_time
    If IsNull(unload_time) Or unload_time = "" Then unload_time = default_unload_time
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>배송 정보 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background:#f4f6f9; font-size:14px; }
</style>
</head>

<body>
<div class="container p-3">

<h5 class="mb-3">
  배송 정보 수정
  <% If isManual Then %>
    <span style="font-size:12px;color:#666;">(수동: manual_idx=<%=keyValue%>)</span>
  <% Else %>
    <span style="font-size:12px;color:#666;">(wms_idx=<%=keyValue%>)</span>
  <% End If %>
</h5>

<form method="post">
<input type="hidden" name="mode" value="save">
<input type="hidden" name="wms_type" value="<%=Server.HTMLEncode(wms_type)%>">
<input type="hidden" name="ymd" value="<%=Server.HTMLEncode(ymd)%>">

<% If isManual Then %>
  <input type="hidden" name="manual_idx" value="<%=keyValue%>">
<% Else %>
  <input type="hidden" name="wms_idx" value="<%=keyValue%>">
<% End If %>

<div class="mb-2">
<label class="form-label">받는사람 이름</label>
<input type="text" name="recv_name" class="form-control" value="<%=Server.HTMLEncode(recv_name)%>">
</div>

<div class="mb-2">
<label class="form-label">받는사람 전화번호</label>
<input type="text" name="recv_tel" class="form-control" value="<%=Server.HTMLEncode(recv_tel)%>">
</div>

<div class="mb-2">
<label class="form-label">주소</label>
<input type="text" name="recv_addr" class="form-control" value="<%=Server.HTMLEncode(recv_addr)%>">
</div>

<div class="mb-2">
<label class="form-label">상세주소</label>
<input type="text" name="recv_addr_detail" class="form-control" value="<%=Server.HTMLEncode(recv_addr_detail)%>">
</div>

<div class="mb-3">
<label class="form-label">선불 / 착불</label>
<select name="pay_type" class="form-select">
    <option value="">선택</option>
    <option value="0" <%If CStr(pay_type)="0" Then Response.Write "selected"%>>선불</option>
    <option value="1" <%If CStr(pay_type)="1" Then Response.Write "selected"%>>착불</option>
</select>
</div>

<% If CLng(0 & wms_type) = 13 Then %>

<hr>
<h6 class="mt-3">용차 운송 시간</h6>

<div class="mb-2">
<label class="form-label">상차 시간</label>
<input type="datetime-local" name="load_time" class="form-control" value="<%=DateToInput(load_time)%>">
</div>

<div class="mb-3">
<label class="form-label">하차 시간</label>
<input type="datetime-local" name="unload_time" class="form-control" value="<%=DateToInput(unload_time)%>">
</div>

<% End If %>

<div class="text-end">
<button type="submit" class="btn btn-primary">저장</button>
<button type="button" class="btn btn-secondary" onclick="window.close()">취소</button>
</div>

</form>
</div>
</body>
</html>
