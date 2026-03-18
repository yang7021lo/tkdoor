<%@codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/TNG_WMS_CommonMsg.asp"-->

<%
call dbOpen()

wms_idx = Trim(Request("wms_idx"))
del_idx = Trim(Request("del"))
sjidx   = Trim(Request("sjidx"))
exec    = Trim(Request("exec"))

' -----------------------------------------
' 삭제
' -----------------------------------------
If del_idx <> "" Then
  SQL = "DELETE FROM tk_wms_meta WHERE wms_idx='" & del_idx & "'"
  Dbcon.Execute SQL

  SQL = "DELETE FROM tk_wms_detail WHERE wms_idx='" & del_idx & "'"
  Dbcon.Execute SQL

  Call MsgSuccess("삭제 완료")
End If

' -----------------------------------------
' 저장 처리
' -----------------------------------------
If exec="yes" Then
  cidx = Trim(Request("cidx"))
  wms_type = Trim(Request("wms_type"))
  shipdt = Trim(Request("shipdt"))

  If wms_idx="" Then
    ' 신규 INSERT
    SQL=""
    SQL = SQL & "INSERT INTO tk_wms_meta("
    SQL = SQL & "company_id,sjidx,cidx,wms_type,planned_ship_dt,actual_ship_dt,reg_user,reg_date"
    SQL = SQL & ") VALUES("
    SQL = SQL & "'1','" & sjidx & "','" & cidx & "','" & wms_type & "','" & shipdt & "','" & shipdt & "','" & C_midx & "',GETDATE()"
    SQL = SQL & ")"

    Dbcon.Execute SQL

    ' 신규 wms_idx 조회
    SQL = "SELECT TOP 1 wms_idx FROM tk_wms_meta ORDER BY wms_idx DESC"
    Set Rs = Server.CreateObject("ADODB.Recordset")
    Rs.Open SQL, Dbcon
    new_idx = Rs("wms_idx")
    Rs.Close

    Call MsgSuccess("META 생성 성공! wms_idx=" & new_idx)

  Else
    ' UPDATE
    SQL=""
    SQL = SQL & "UPDATE tk_wms_meta SET "
    SQL = SQL & "wms_type='" & wms_type & "', "
    SQL = SQL & "planned_ship_dt='" & shipdt & "', "
    SQL = SQL & "actual_ship_dt='" & shipdt & "', "
    SQL = SQL & "upd_user='" & C_midx & "', upd_date=GETDATE() "
    SQL = SQL & "WHERE wms_idx='" & wms_idx & "'"

    Dbcon.Execute SQL

    Call MsgSuccess("META 수정 완료")
  End If
End If

' -----------------------------------------
' 조회 (수정용)
' -----------------------------------------
If wms_idx <> "" Then
  SQL = "SELECT * FROM tk_wms_meta WHERE wms_idx='" & wms_idx & "'"
  Set Rs = Server.CreateObject("ADODB.Recordset")
  Rs.Open SQL, Dbcon

  If Not (Rs.BOF Or Rs.EOF) Then
    sjidx = Rs("sjidx")
    cidx = Rs("cidx")
    wms_type = Rs("wms_type")
    shipdt = Left(Rs("actual_ship_dt"),10)
  End If
  Rs.Close
End If
%>

<!DOCTYPE html>
<html>
<head>
<title>WMS 출하 생성/수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="p-3">

<h4>🚚 WMS 출하 생성/수정</h4>

<form method="post">
<input type="hidden" name="exec" value="yes">
<input type="hidden" name="wms_idx" value="<%=wms_idx%>">

<div class="row mb-2">
  <div class="col-2">
    <label>sjidx</label>
    <input type="text" name="sjidx" value="<%=sjidx%>" class="form-control">
  </div>
  <div class="col-2">
    <label>cidx</label>
    <input type="text" name="cidx" value="<%=cidx%>" class="form-control">
  </div>
  <div class="col-2">
    <label>wms_type</label>
    <select class="form-control" name="wms_type">
      <option value="1" <% If wms_type="1" Then Response.Write("selected") %>>택배</option>
      <option value="2" <% If wms_type="2" Then Response.Write("selected") %>>대신화물</option>
      <option value="3" <% If wms_type="3" Then Response.Write("selected") %>>용차</option>
      <option value="4" <% If wms_type="4" Then Response.Write("selected") %>>창고이동</option>
    </select>
  </div>
  <div class="col-2">
    <label>출하일</label>
    <input type="date" name="shipdt" value="<%=shipdt%>" class="form-control">
  </div>
</div>

<button class="btn btn-success" type="submit">저장</button>
<a href="TNG_WMS_Meta_List.asp" class="btn btn-secondary">목록</a>

</form>

</body>
</html>

<%
call dbClose()
%>
