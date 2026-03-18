<%@ Language="VBScript" CodePage="65001" %>
<%
Response.Charset = "utf-8"
Response.ContentType = "application/json"
Response.Buffer = True
Response.Clear
Response.Expires = -1
Response.AddHeader "Pragma", "no-cache"
Response.AddHeader "Cache-Control", "no-cache"

On Error Resume Next
%>

<!--#include virtual="/inc/dbcon.asp"-->

<%
Call dbOpen()

Function Nz(v)
    If IsNull(v) Then Nz = "" Else Nz = Trim(CStr(v))
End Function

Function JsonEsc(s)
    s = Nz(s)
    s = Replace(s, "\", "\\")
    s = Replace(s, """", "\""")
    s = Replace(s, vbCrLf, "\n")
    s = Replace(s, vbCr, "\n")
    s = Replace(s, vbLf, "\n")
    JsonEsc = s
End Function

Sub JsonDie(code, msg, sqlText)
    Response.Status = code
    Response.Write "{""error"":""" & JsonEsc(code) & """,""message"":""" & JsonEsc(msg) & """,""sql"":""" & JsonEsc(sqlText) & """}"
    Response.End
End Sub

Dim sjidx
sjidx = CLng(0 & Request("sjidx"))

If sjidx <= 0 Then
    Response.Write "{""framename_list"":[],""debug"":{""sjidx"":" & sjidx & ",""count"":0}}"
    Response.End
End If

Dim Rs, SQL, RsCnt, SQLCnt
Set Rs = Server.CreateObject("ADODB.Recordset")
Set RsCnt = Server.CreateObject("ADODB.Recordset")

' 1) COUNT로 존재 확인
SQLCnt = "SELECT COUNT(*) AS cnt FROM tng_sjasub WHERE sjidx = " & sjidx


RsCnt.Open SQLCnt, DbCon, 1, 1

If Err.Number <> 0 Then
    JsonDie "500 Internal Server Error", "COUNT QUERY ERROR: " & Err.Description, SQLCnt
End If

Dim rowCnt
rowCnt = CLng(0 & RsCnt("cnt"))
RsCnt.Close

If rowCnt = 0 Then
    Response.Write "{""framename_list"":[],""debug"":{""sjidx"":" & sjidx & ",""count"":0}}"
    Response.End
End If

' =========================================================
' ✅ 핵심 수정:
'  - GROUP BY 제거
'  - 레코드 단위로 내려주기
'  - (중요) PK 컬럼명을 sjsidx로 가정. 다르면 여기만 바꾸면 됨.
' =========================================================
SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & "  sjsidx, "
SQL = SQL & "  ISNULL(NULLIF(LTRIM(RTRIM(framename)),''),'(미지정)') AS framename "
SQL = SQL & "FROM tng_sjasub "
SQL = SQL & "WHERE sjidx = " & sjidx & " "
SQL = SQL & "ORDER BY sjsidx "


Rs.Open SQL, DbCon, 1, 1

If Err.Number <> 0 Then
    JsonDie "500 Internal Server Error", "FRAME QUERY ERROR: " & Err.Description, SQL
End If

Dim first
first = True

Response.Write "{""framename_list"":["
Do Until Rs.EOF
    If Not first Then Response.Write ","
    first = False

    Response.Write "{""sjsidx"":" & CLng(0 & Rs("sjsidx")) & ",""framename"":""" & JsonEsc(Rs("framename")) & """}"
    Rs.MoveNext
Loop
Response.Write "],""debug"":{""sjidx"":" & sjidx & ",""count"":" & rowCnt & "}}"

Rs.Close
Set Rs = Nothing
Set RsCnt = Nothing
%>
