<%@ Language="VBScript" CodePage="65001" %>
<%
Response.Charset = "utf-8"
Response.ContentType = "application/json"

<!--#include virtual="/inc/dbcon.asp"-->

call dbOpen()

Dim bw_no, bw_idx, sql, Rs
bw_no  = Trim(Request("bw_no"))
bw_idx = Trim(Request("bw_idx"))  ' 수정 시 자기 자신 제외용

Set Rs = Server.CreateObject("ADODB.Recordset")

' 기본 방어
If bw_no = "" Then
    Response.Write "{""result"":""fail"",""msg"":""기계번호가 비어있습니다.""}"
    Response.End
End If

sql = ""
sql = sql & " SELECT bw_idx "
sql = sql & " FROM bom_wms "
sql = sql & " WHERE bw_no = '" & Replace(bw_no,"'","''") & "' "
sql = sql & " AND is_active = 1 "

' 수정 모드일 경우 자기 자신 제외
If bw_idx <> "" And IsNumeric(bw_idx) Then
    sql = sql & " AND bw_idx <> " & bw_idx
End If

Rs.Open sql, DbCon, 1, 1

If Rs.EOF Then
    ' 사용 가능
    Response.Write "{""result"":""ok""}"
Else
    ' 중복
    Response.Write "{""result"":""duplicate""}"
End If

Rs.Close
Set Rs = Nothing
call dbClose()
%>
