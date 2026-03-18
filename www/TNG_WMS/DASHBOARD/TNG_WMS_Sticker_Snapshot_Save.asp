<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
Response.Buffer = True
Response.Expires = -1
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

Function Nz(v)
    If IsNull(v) Then
        Nz = ""
    Else
        Nz = Trim(CStr(v))
    End If
End Function

Function SafeInt(v)
    On Error Resume Next
    SafeInt = CLng(0 & v)
    On Error GoTo 0
End Function

Function SqlEsc(s)
    s = Nz(s)
    s = Replace(s, "'", "''")
    SqlEsc = s
End Function

Sub Die(msg)
    Response.Status = "500 Internal Server Error"
    Response.Write msg
    Call dbClose()
    Response.End
End Sub

Dim wms_idx, ymd, data
wms_idx = SafeInt(Request.Form("wms_idx"))
ymd     = Nz(Request.Form("ymd"))
data    = Nz(Request.Form("data"))

ymd = Replace(ymd, "-", "")
If Len(ymd) <> 8 Then ymd = ""

If wms_idx <= 0 Then Die("wms_idx가 없습니다.")
If data = "" Then Die("data가 없습니다. (폼 전송 확인)")

' ★ 테이블 존재/권한 체크
On Error Resume Next
Dbcon.Execute "SELECT TOP 1 wms_idx FROM tk_wms_sticker_snapshot"
If Err.Number <> 0 Then
    Die("테이블/권한 오류: " & Err.Number & " / " & Err.Description)
End If
On Error GoTo 0

Dim lines, i, line, parts, sjsidx, sum_qty, payload, sql

lines = Split(data, vbLf)

' =========================
' 트랜잭션 시작
' =========================
On Error Resume Next
Dbcon.Execute "BEGIN TRAN"
If Err.Number <> 0 Then
    Die("TRAN 시작 실패: " & Err.Number & " / " & Err.Description)
End If
On Error GoTo 0

' =========================
' 1) 기존 데이터 전부 삭제 (wms_idx 기준)
' =========================
On Error Resume Next
Dbcon.Execute "DELETE FROM tk_wms_sticker_snapshot WHERE wms_idx=" & wms_idx
If Err.Number <> 0 Then
    Dbcon.Execute "ROLLBACK TRAN"
    Die("기존 데이터 삭제 실패: " & Err.Number & " / " & Err.Description)
End If
On Error GoTo 0

' =========================
' 2) 이번 전송분을 전부 INSERT
' =========================
For i = 0 To UBound(lines)
    line = Trim(Replace(lines(i), vbCr, ""))
    If line <> "" Then
        parts = Split(line, vbTab)
        If UBound(parts) >= 2 Then
            sjsidx  = SafeInt(parts(0))
            sum_qty = SafeInt(parts(1))
            payload = Nz(parts(2))

            If sjsidx > 0 Then
                sql = ""
                sql = sql & "INSERT INTO tk_wms_sticker_snapshot(wms_idx, sjsidx, ymd, sum_qty, payload,  updated_at) "
                sql = sql & "VALUES(" & wms_idx & "," & sjsidx & ",'" & SqlEsc(ymd) & "'," & sum_qty & ",N'" & SqlEsc(payload) & "', GETDATE())"

                On Error Resume Next
                Dbcon.Execute sql
                If Err.Number <> 0 Then
                    Dbcon.Execute "ROLLBACK TRAN"
                    Die("저장 실패: " & Err.Number & " / " & Err.Description & vbCrLf & "SQL=" & sql)
                End If
                On Error GoTo 0
            End If
        End If
    End If
Next

Dbcon.Execute "COMMIT TRAN"
Response.Write "저장 완료"

Call dbClose()
%>
