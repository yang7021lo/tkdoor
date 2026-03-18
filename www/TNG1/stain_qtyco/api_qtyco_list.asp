<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

sql = ""
sql = sql & "SELECT "
sql = sql & " qtyco_idx, QTYNo, QTYNAME, QTYcoNAME, "
sql = sql & " unittype_qtyco_idx, QTYcostatus, kg, "
sql = sql & " sheet_w, sheet_h, sheet_t, coil_cut, "
sql = sql & " QTYcoewdate, "
sql = sql & " (SELECT mname FROM tk_member WHERE midx = A.QTYcoemidx) AS mename "
sql = sql & "FROM tk_qtyco A "
sql = sql & "ORDER BY qtyco_idx DESC "

On Error Resume Next
Set Rs = Dbcon.Execute(sql)
If Err.Number <> 0 Then
  Response.Write "{""error"":true,""msg"":""" & Replace(Err.Description, """", "'") & """,""sql"":""" & Replace(sql, """", "'") & """}"
  Response.End
End If

Response.Write "["

first = true
Do Until Rs.EOF
  If Not first Then Response.Write ","
  first = false

  Response.Write "{"
  Response.Write """qtyco_idx"":""" & Rs("qtyco_idx") & ""","
  Response.Write """QTYNo"":""" & Rs("QTYNo") & ""","
  Response.Write """QTYNAME"":""" & Rs("QTYNAME") & ""","
  Response.Write """QTYcoNAME"":""" & Rs("QTYcoNAME") & ""","
  Response.Write """unittype_qtyco_idx"":""" & Rs("unittype_qtyco_idx") & ""","
  Response.Write """QTYcostatus"":""" & Rs("QTYcostatus") & ""","
  Response.Write """kg"":""" & Rs("kg") & ""","
  Response.Write """sheet_w"":""" & Rs("sheet_w") & ""","
  Response.Write """sheet_h"":""" & Rs("sheet_h") & ""","
  Response.Write """sheet_t"":""" & Rs("sheet_t") & ""","
  Response.Write """coil_cut"":""" & Rs("coil_cut") & ""","
  Response.Write """mename"":""" & Rs("mename") & ""","
  Response.Write """QTYcoewdate"":""" & Rs("QTYcoewdate") & """"
  Response.Write "}"

  Rs.MoveNext
Loop

Response.Write "]"

Rs.Close
Set Rs = Nothing
call dbClose()
%>
