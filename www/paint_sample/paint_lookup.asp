<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

' 페인트 검색 API (자동완성용, 최대 30건)
Dim q, sql, rs, items, cnt
q = Trim(Request("q") & "")
q = Replace(q, "'", "''")

sql = "SELECT TOP 30 pidx, " & _
      "ISNULL(pcode,'') + ' ' + ISNULL(pname,'') AS display_name, " & _
      "ISNULL(p_hex_color,'') AS hex " & _
      "FROM tk_paint WHERE pstatus=1"

If q <> "" Then
  sql = sql & " AND (pcode LIKE N'%" & q & "%' OR pname LIKE N'%" & q & "%')"
End If

sql = sql & " ORDER BY pcode"

Set rs = Dbcon.Execute(sql)
items = ""
cnt = 0
Do While Not rs.EOF
  If items <> "" Then items = items & ","
  Dim pid, dname, hx
  pid = rs(0)
  dname = Replace(rs(1) & "", """", "\""")
  hx = rs(2) & ""
  items = items & "{""v"":""" & pid & """,""n"":""" & dname & """,""h"":""" & hx & """}"
  cnt = cnt + 1
  rs.MoveNext
Loop
rs.Close
Set rs = Nothing

Response.Write "[" & items & "]"

call dbClose()
%>
