<%@ codepage="65001" language="vbscript"%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%
call dbOpen()

Dim idx, material_id, amount, cidx, pre_in_date, total_price, status
Dim midx, meidx
Dim sql, sql_cidx, sql_pre_in_date, sql_total_price

stock_idx    = Trim(Request("stock_idx"))
material_id  = Trim(Request("material_id"))
amount       = Trim(Request("amount"))
cidx         = Trim(Request("cidx"))
pre_in_date  = Trim(Request("pre_in_date"))
total_price  = Trim(Request("total_price"))
status       = Trim(Request("status"))
mode         = Trim(Request("mode"))
is_popup = Request("is_popup")

midx  = c_midx   ' 로그인 사용자
meidx = c_midx

' response.Write "('stock_idx: " & stock_idx & "')"
' response.Write "('material_id: " & material_id & "')"
' response.Write "('amount: " & amount & "')"
' response.Write "('cidx: " & cidx & "')"
' response.Write "('pre_in_date: " & pre_in_date & "')"
' response.Write "('total_price: " & total_price & "')"
' response.Write "('midx: " & midx & "')"
' response.Write "('meidx: " & meidx & "')"
' response.Write "('mode: " & mode & "')"


' ----------------------------
' NULL / VALUE 처리
' ----------------------------

' cidx
If cidx = "" Then
    sql_cidx = "NULL"
Else
    sql_cidx = cidx
End If

' pre_in_date (date)
If pre_in_date = "" Then
    sql_pre_in_date = "NULL"
Else
    sql_pre_in_date = "'" & pre_in_date & "'"
End If

' total_price
If total_price = "" Then
    sql_total_price = "NULL"
Else
    sql_total_price = total_price
End If
' ----------------------------
' DELETE
' ----------------------------
If mode = "delete" And stock_idx <> "" Then
    
    sql = ""
    sql = sql & "UPDATE tk_wms_stock SET "
    sql = sql & " is_active = 0 "
    sql = sql & "WHERE stock_idx = " & stock_idx
    'response.Write "('sql: " & sql & "')"
ElseIf stock_idx = "" Then
    ' ----------------------------
    ' INSERT
    ' ----------------------------
    sql = ""
    sql = sql & "INSERT INTO tk_wms_stock ("
    sql = sql & " material_id, amount, cidx, pre_in_date, total_price, "
    sql = sql & " status, midx, meidx "
    sql = sql & ") VALUES ("
    sql = sql & "'" & material_id & "', "
    sql = sql & amount & ", "
    sql = sql & sql_cidx & ", "
    sql = sql & sql_pre_in_date & ", "
    sql = sql & sql_total_price & ", "
    sql = sql & status & ", "
    sql = sql & "'" & midx & "', "
    sql = sql & "'" & meidx & "'"
    sql = sql & ")"

Else
    ' ----------------------------
    ' UPDATE
    ' ----------------------------
    sql = ""
    sql = sql & "UPDATE tk_wms_stock SET "
    sql = sql & " material_id = '" & material_id & "', "
    sql = sql & " amount = " & amount & ", "
    sql = sql & " cidx = " & sql_cidx & ", "
    sql = sql & " pre_in_date = " & sql_pre_in_date & ", "
    sql = sql & " total_price = " & sql_total_price & ", "
    sql = sql & " status = " & status & ", "
    sql = sql & " meidx = '" & meidx & "', "
    sql = sql & " udate = GETDATE() "
    sql = sql & "WHERE stock_idx = " & stock_idx
End If


'Response.End
'Response.Write sql : Response.End ' ← 디버그용

DbCon.Execute sql
call dbClose()


If is_popup = "1" Then
%>
    <script>
        // 팝업에서 저장된 경우
        if (window.opener && !window.opener.closed) {
            window.opener.location.reload();
        }
        window.close();
    </script>
<%
Else
    ' 일반 페이지 접근
    Response.Redirect "TNG_WMS_stock_list.asp"
End If
%>