<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

' 개별 파라미터로 업데이트
' URL 형식: ?baidx=123&bachannel=54&baname=절곡1&sharing_size=100
Dim baidx, bachannel, baname, sharing_size
baidx = Request("baidx")
bachannel = Request("bachannel")
baname = Request("baname")
sharing_size = Request("sharing_size")

Dim updateCount
updateCount = 0
Dim errorMsg
errorMsg = ""

If baidx <> "" Then
    On Error Resume Next
    
    SQL = "UPDATE tk_barasi SET "
    
    Dim needComma
    needComma = False
    
    If bachannel <> "" Then
        SQL = SQL & "bachannel = '" & Replace(bachannel, "'", "''") & "'"
        needComma = True
    End If
    
    If baname <> "" Then
        If needComma Then SQL = SQL & ", "
        SQL = SQL & "baname = '" & Replace(baname, "'", "''") & "'"
        needComma = True
    End If

    If sharing_size <> "" And IsNumeric(sharing_size) Then
        If needComma Then SQL = SQL & ", "
        SQL = SQL & "sharing_size = " & CDbl(sharing_size)
    End If

    SQL = SQL & " WHERE baidx = '" & baidx & "'"
    
    Dbcon.Execute SQL
    
    If Err.Number = 0 Then
        updateCount = 1
        Response.Write "{""success"": true, ""updated"": 1, ""baidx"": " & baidx & "}"
    Else
        errorMsg = "업데이트 실패: " & Err.Description
        Response.Write "{""success"": false, ""error"": """ & Replace(errorMsg, """", "\""") & """}"
    End If
    
    On Error Goto 0
Else
    Response.Write "{""success"": false, ""error"": ""baidx is required""}"
End If

call dbClose()
%>