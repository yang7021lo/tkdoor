<%@ Language="VBScript" CodePage="65001" %>
<%
Option Explicit
Response.Charset = "utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
Call dbOpen()

' -------------------------
' Helpers
' -------------------------
Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = Trim(CStr(v))
End Function

Function SafeLong(v)
  On Error Resume Next
  SafeLong = CLng(0 & v)
  On Error GoTo 0
End Function

Function SqlEsc(s)
  s = Nz(s)
  SqlEsc = Replace(s, "'", "''")
End Function

' ymd: "20251210" 또는 "2025-12-10" 모두 지원
Function CleanYmdDigits(ByVal s)
  Dim i, ch, out
  s = Nz(s)
  out = ""
  For i = 1 To Len(s)
    ch = Mid(s, i, 1)
    If ch >= "0" And ch <= "9" Then out = out & ch
  Next
  CleanYmdDigits = out
End Function

Function MakeCreatedDtSql(ByVal ymdRaw)
  Dim d, ymdDigits, yy, mm, dd
  ymdDigits = CleanYmdDigits(ymdRaw)

  If Len(ymdDigits) <> 8 Then
    ' fallback: 오늘
    d = Date()
  Else
    yy = CInt(Left(ymdDigits, 4))
    mm = CInt(Mid(ymdDigits, 5, 2))
    dd = CInt(Right(ymdDigits, 2))
    d = DateSerial(yy, mm, dd)
  End If

  MakeCreatedDtSql = "'" & Year(d) & "-" & Right("0"&Month(d),2) & "-" & Right("0"&Day(d),2) & "'"
End Function

' -------------------------
' Params
' -------------------------
Dim kind
kind = LCase(Nz(Request("kind")))
If kind = "" Then kind = "meta" ' 기존 호출은 kind 없음 -> meta로 유지

Dim wms_idx, manual_idx, wms_type, recv_name, cargo_status, box_cnt
wms_idx      = SafeLong(Request("wms_idx"))
manual_idx   = SafeLong(Request("manual_idx"))
wms_type     = SafeLong(Request("wms_type"))
recv_name    = Nz(Request("recv_name"))
cargo_status = SafeLong(Request("cargo_status"))

box_cnt = SafeLong(Request("box_cnt"))
If box_cnt < 0 Then box_cnt = 0

Dim ymd, created_dt_sql
ymd = Nz(Request("ymd"))
created_dt_sql = MakeCreatedDtSql(ymd)

' -------------------------
' Validation
' -------------------------
If kind = "manual" Then
  If manual_idx <= 0 Then
    Response.Status = "400 Bad Request"
    Response.Write "manual_idx required"
    Call dbClose()
    Response.End
  End If
Else
  ' meta
  If wms_idx <= 0 Then
    Response.Status = "400 Bad Request"
    Response.Write "wms_idx required"
    Call dbClose()
    Response.End
  End If
End If

If wms_type <= 0 Then wms_type = 1

' -------------------------
' Delete existing rows
' -------------------------
If kind = "manual" Then
  ' 수동: manual_idx 기준 삭제
  DbCon.Execute "DELETE FROM tk_wms_cargo WHERE manual_idx = " & manual_idx
Else
  ' 기존: wms_idx 기준 삭제(기존 동작 유지)
  DbCon.Execute "DELETE FROM tk_wms_cargo WHERE wms_idx = " & wms_idx
End If

' -------------------------
' Insert loop
' -------------------------
Dim i, rect, framename, sjsidx, price, SQLI

For i = 0 To box_cnt - 1

  rect      = Nz(Request("cargo_rect_" & i))
  framename = Nz(Request("frame_name_" & i))
  sjsidx    = SafeLong(Request("sjsidx_" & i)) ' manual-123 같은 값이면 0으로 떨어짐

  price = 0

  Select Case CLng(wms_type)

    ' 1. 일반화물
    Case 1
      Select Case Trim(rect)
        Case "정사각형_1000이하": price = 6000
        Case "정사각형_2500":     price = 8000
        Case "정사각형_3000이상": price = 10000
        Case Else:                price = 0
      End Select

    ' 19. 택배 (고정가)
    Case 19
      price = 12000

    ' 17. 제주 화물
    Case 17
      ' 화면 옵션 문자열과 맞춤
      Select Case Trim(rect)
        Case "정사각형_1000이하":   price = 20000
        Case "정사각형_2500":       price = 20000
        Case "정사각형_3000이상":   price = 20000
        Case "정사각형_4000이상":   price = 40000

        Case "사다리꼴_2":          price = 30000
        Case "사다리꼴_2.5~3.4":    price = 35000
        Case "사다리꼴_3.5~4.5":    price = 40000
        Case "사다리꼴_4.5~5":      price = 60000
        Case Else:                  price = 0
      End Select

    ' 18. 제주 택배
    Case 18
      Select Case Trim(rect)
        Case "사다리꼴_2", "사다리꼴_2.5~3.4", "사다리꼴_3.5~4.5", "사다리꼴_4.5~5"
          price = 15000
        Case "정사각형_1000이하", "정사각형_2500", "정사각형_3000이상", "정사각형_4000이상"
          price = 20000
        Case Else
          price = 0
      End Select

    Case Else
      price = 0
  End Select

  ' -------------------------
  ' INSERT
  '  - meta: wms_idx 저장, manual_idx NULL
  '  - manual: manual_idx 저장, wms_idx NULL (권장)
  '    * 만약 wms_idx NOT NULL이라면 아래 wmsValue를 "0"으로 바꾸세요.
  ' -------------------------
  Dim wmsValue, manualValue
  If kind = "manual" Then
    wmsValue = "NULL"          ' <-- wms_idx NOT NULL이면 "0" 으로 변경
    manualValue = CStr(manual_idx)
  Else
    wmsValue = CStr(wms_idx)
    manualValue = "NULL"
  End If

  SQLI = ""
  SQLI = SQLI & "INSERT INTO tk_wms_cargo ("
  SQLI = SQLI & " wms_idx, manual_idx, recv_name, status, cargo_status, cargo_rect, cargo_price, created_dt, sjsidx, frame_name"
  SQLI = SQLI & ") VALUES ("
  SQLI = SQLI & " " & wmsValue & ", "
  SQLI = SQLI & " " & manualValue & ", "
  SQLI = SQLI & " N'" & SqlEsc(recv_name) & "', "
  SQLI = SQLI & " 1, "
  SQLI = SQLI & " " & CLng(cargo_status) & ", "
  SQLI = SQLI & " N'" & SqlEsc(rect) & "', "
  SQLI = SQLI & " " & CLng(price) & ", "
  SQLI = SQLI & " " & created_dt_sql & ", "
  SQLI = SQLI & " " & CLng(sjsidx) & ", "
  SQLI = SQLI & " N'" & SqlEsc(framename) & "'"
  SQLI = SQLI & ")"

  DbCon.Execute SQLI
Next

Response.Write "OK"
Call dbClose()
%>
