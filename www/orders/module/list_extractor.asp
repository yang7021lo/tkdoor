<%@ CodePage=65001 Language="VBScript" %>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
'— 기존 응답(HTML 등) 모두 제거 —
Response.Clear
Response.Buffer = True

'— JSON 전용 헤더 설정 —
Response.ContentType = "application/json; charset=utf-8"

'— DB 열기 —
Call dbOpen()

'— 발주 리스트 조회 —
Dim SQL, Rs
SQL = ""
SQL = SQL & "SELECT TOP 50 A.kidx, B.cname, C.mname AS fmname, D.mname AS smname,"
SQL = SQL & "       CONVERT(varchar(10),A.kwdate,121) AS kwdate,"
SQL = SQL & "       CONVERT(varchar(10),A.kidate,121) AS kidate,"
SQL = SQL & "       CONVERT(varchar(10),A.krdate,121) AS krdate,"
SQL = SQL & "       A.kstatus"
SQL = SQL & "  FROM tk_korder A"
SQL = SQL & "  JOIN tk_customer B ON A.kcidx = B.cidx"
SQL = SQL & "  JOIN tk_member C   ON A.kmidx = C.midx"
SQL = SQL & "  JOIN tk_member D   ON A.midx  = D.midx"
SQL = SQL & " ORDER BY A.kwdate DESC"

Set Rs = Dbcon.Execute(SQL)

'— JSON 배열 시작 —
Response.Write "["

Dim first
first = True

Do While Not Rs.EOF
    If Not first Then Response.Write ","
    first = False

    ' 상태 로직
    Dim statText,pct,badgeClass
    Select Case Rs("kstatus")
      Case "0": statText="발주중":    pct=25:  badgeClass="primary"
      Case "1": statText="납품처확인": pct=60:  badgeClass="warning"
      Case "2": statText="입고완료":  pct=100: badgeClass="success"
      Case Else: statText="알수없음": pct=0:   badgeClass="secondary"
    End Select

    ' JSON 오브젝트
    Response.Write "{"
    Response.Write """kidx"":"""       & JsEscape(Rs("kidx"))   & ""","
    Response.Write """cname"":"""      & JsEscape(Rs("cname"))  & ""","
    Response.Write """fmname"":"""     & JsEscape(Rs("fmname")) & ""","
    Response.Write """smname"":"""     & JsEscape(Rs("smname")) & ""","
    Response.Write """kwdate"":"""     & Rs("kwdate")           & ""","
    Response.Write """kidate"":"""     & Rs("kidate")           & ""","
    Response.Write """krdate"":"""     & Rs("krdate")           & ""","
    Response.Write """statusText"":""" & statText               & ""","
    Response.Write """pct"":"""        & pct                    & ""","
    Response.Write """badgeClass"":""" & badgeClass             & """"
    Response.Write "}"

    Rs.MoveNext
Loop

Response.Write "]"

'— 마무리 —
Rs.Close
Call dbClose()
Response.End


'— JSON 문자열 이스케이프 함수 —
Function JsEscape(s)
    If IsNull(s) Then
        JsEscape = ""
    Else
        s = Replace(s, "\", "\\")
        s = Replace(s, """", "\""")
        s = Replace(s, vbCrLf, "\n")
        s = Replace(s, vbLf,  "\n")
        JsEscape = s
    End If
End Function
%>
