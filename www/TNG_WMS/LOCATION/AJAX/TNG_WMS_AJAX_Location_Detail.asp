<%@ Language="VBScript" CodePage="65001" %>
<!--#include virtual="/inc/dbcon.asp"-->
<%
Response.Charset = "utf-8"
Response.ContentType = "application/json"
Call dbOpen()

' =========================
' 1. 파라미터 검증
' =========================
Dim stock_loc_idx
stock_loc_idx = Request("stock_loc_idx")

If Not IsNumeric(stock_loc_idx) Then
    Response.Write "{}"
    Response.End
End If

' =========================
' 2. 유틸 (JSON 안전)
' =========================
Function J(v)
    If IsNull(v) Then
        J = ""
    Else
        J = Replace(CStr(v), """", "\""")
    End If
End Function

' =========================
' 3. 조회
' =========================
Dim Rs, SQL
Set Rs = Server.CreateObject("ADODB.Recordset")

SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & "  a.stock_loc_idx, "
SQL = SQL & "  a.stock_sub_idx, "
SQL = SQL & "  a.wh_idx, "
SQL = SQL & "  a.stock_idx, "
SQL = SQL & "  a.loc_code, "
SQL = SQL & "  a.zone, a.rack, a.shelf, a.bin, "
SQL = SQL & "  a.amount, "
SQL = SQL & "  ISNULL(b.material_id,'') AS material_id "
SQL = SQL & "FROM tk_wms_stock_loc a "
SQL = SQL & "LEFT JOIN tk_wms_stock b "
SQL = SQL & "  ON a.stock_idx = b.stock_idx "
SQL = SQL & " AND b.is_active = 1 "
SQL = SQL & "WHERE a.stock_loc_idx = " & CLng(stock_loc_idx)
SQL = SQL & " AND a.is_active = 1"

Rs.Open SQL, DbCon

' =========================
' 4. JSON 출력
' =========================
If Rs.EOF Then
    Response.Write "{}"
Else
    Response.Write "{"
    Response.Write """stock_loc_idx"":""" & J(Rs("stock_loc_idx")) & ""","
    Response.Write """stock_sub_idx"":""" & J(Rs("stock_sub_idx")) & ""","
    Response.Write """wh_idx"":""" & J(Rs("wh_idx")) & ""","
    Response.Write """stock_idx"":""" & J(Rs("stock_idx")) & ""","
    Response.Write """material_id"":""" & J(Rs("material_id")) & ""","
    Response.Write """loc_code"":""" & J(Rs("loc_code")) & ""","
    Response.Write """zone"":""" & J(Rs("zone")) & ""","
    Response.Write """rack"":""" & J(Rs("rack")) & ""","
    Response.Write """shelf"":""" & J(Rs("shelf")) & ""","
    Response.Write """bin"":""" & J(Rs("bin")) & ""","
    Response.Write """amount"":""" & J(Rs("amount")) & """"
    Response.Write "}"
End If

Rs.Close : Set Rs = Nothing
%>
