<%@ Language="VBScript" CodePage="65001" %>
<%
Response.Charset = "utf-8"
Response.ContentType = "application/json"
Response.Clear
%>

<!--#include virtual="/inc/dbcon.asp"-->

<%
Call dbOpen()

Dim material_id
material_id = Request("material_id")

' material_id 검증
If material_id = "" Or Not IsNumeric(material_id) Then
    Response.Write "[]"
    Response.End
End If

Dim Rs, SQL
Set Rs = Server.CreateObject("ADODB.Recordset")

SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & "  S.stock_idx, "
SQL = SQL & "  SS.stock_sub_idx, "
SQL = SQL & "  (SS.amount - ISNULL(SUM(L.amount), 0)) AS remain_qty "
SQL = SQL & "FROM tk_wms_stock AS S "
SQL = SQL & "JOIN tk_wms_stock_sub AS SS "
SQL = SQL & "  ON S.stock_idx = SS.stock_idx "
SQL = SQL & "LEFT JOIN tk_wms_stock_loc AS L "
SQL = SQL & "  ON SS.stock_sub_idx = L.stock_sub_idx "
SQL = SQL & "WHERE S.material_id = " & CLng(material_id) & " "
SQL = SQL & "  AND S.status = 2 "
SQL = SQL & "  AND S.is_active = 1 "
SQL = SQL & "  AND SS.status = 0 "
SQL = SQL & "  AND SS.is_active = 1 "
SQL = SQL & "GROUP BY "
SQL = SQL & "  S.stock_idx, "
SQL = SQL & "  SS.stock_sub_idx, "
SQL = SQL & "  SS.amount "
SQL = SQL & "HAVING "
SQL = SQL & "  (SS.amount - ISNULL(SUM(L.amount), 0)) > 0 "


On Error Resume Next
Rs.Open SQL, DbCon
If Err.Number <> 0 Then
    Response.Write "[]"
    Response.End
End If
On Error GoTo 0

If Rs.EOF Then
    Response.Write "[]"
    Response.End
End If

Dim json, remain_qty
json = "["

Do Until Rs.EOF

    If IsNull(Rs("remain_qty")) Then
        remain_qty = 0
    Else
        remain_qty = Rs("remain_qty")
    End If

    json = json & "{"
    json = json & """stock_idx"":" & Rs("stock_idx") & ","
    json = json & """stock_sub_idx"":" & Rs("stock_sub_idx") & ","
    json = json & """remain_qty"":" & remain_qty
    json = json & "},"

    Rs.MoveNext   ' ✅ 딱 한 번만
Loop

If Right(json,1) = "," Then
    json = Left(json, Len(json)-1)
End If

json = json & "]"

Response.Write json
%>
