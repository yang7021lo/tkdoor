<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
Response.ContentType = "application/json"

Function JsonSafe(val)
    Dim s
    s = val & ""
    s = Replace(s, "\", "\\")
    s = Replace(s, """", "\""")
    s = Replace(s, vbCrLf, "\n")
    s = Replace(s, vbCr, "\n")
    s = Replace(s, vbLf, "\n")
    s = Replace(s, vbTab, "\t")
    s = Replace(s, Chr(8), "")
    s = Replace(s, Chr(12), "")
    JsonSafe = s
End Function

Function SafeNum(val)
    If IsNull(val) Or val = "" Then
        SafeNum = 0
    Else
        SafeNum = val
    End If
End Function
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

' baidx 목록 받기 (콤마 구분)
Dim baidxList
baidxList = Request("baidx_list")

If baidxList = "" Then
    Response.Write "{}"
    Response.End
End If

' SQL Injection 방지: 숫자와 콤마만 허용
Dim cleanList, ch, i
cleanList = ""
For i = 1 To Len(baidxList)
    ch = Mid(baidxList, i, 1)
    If InStr("0123456789,", ch) > 0 Then
        cleanList = cleanList & ch
    End If
Next

If cleanList = "" Then
    Response.Write "{}"
    Response.End
End If

' 모든 baidx의 서브 데이터를 한 번에 조회
SQL = "SELECT baidx, basidx, bassize, basdirection, x1, y1, x2, y2, accsize, idv, final "
SQL = SQL & "FROM tk_barasisub "
SQL = SQL & "WHERE baidx IN (" & cleanList & ") "
SQL = SQL & "ORDER BY baidx, basidx ASC"

Rs.Open SQL, Dbcon, 1, 1

' baidx별로 그룹핑하여 JSON 생성
Dim currentBaidx, isFirstBaidx, isFirstRow, isFirstSvg
Dim rowCount
currentBaidx = ""
isFirstBaidx = True

Response.Write "{"

If Not (Rs.EOF Or Rs.BOF) Then
    Do While Not Rs.EOF
        Dim thisBaidx
        thisBaidx = Rs("baidx") & ""

        If thisBaidx <> currentBaidx Then
            ' 이전 baidx 닫기
            If currentBaidx <> "" Then
                Response.Write "]}, "
            End If

            ' 새 baidx 시작
            If Not isFirstBaidx Then
                ' comma already written above
            End If
            isFirstBaidx = False
            currentBaidx = thisBaidx
            rowCount = 0

            Response.Write """" & currentBaidx & """: {""row1"": ["
            isFirstRow = True
        End If

        rowCount = rowCount + 1

        Dim bassize_val, basdirection_val, x1_val, y1_val, x2_val, y2_val, accsize_val, idv_val, final_val
        bassize_val = SafeNum(Rs("bassize"))
        basdirection_val = Rs("basdirection") & ""
        x1_val = SafeNum(Rs("x1"))
        y1_val = SafeNum(Rs("y1"))
        x2_val = SafeNum(Rs("x2"))
        y2_val = SafeNum(Rs("y2"))
        accsize_val = Rs("accsize") & ""
        idv_val = Rs("idv") & ""
        final_val = Rs("final") & ""

        ' 버튼 스타일 결정
        Dim btn_class_val
        btn_class_val = "primary"

        If idv_val = "0" Then
            If rowCount > 1 Then
                btn_class_val = "primary"
            End If
        Else
            btn_class_val = "light"
        End If

        If final_val = "0" Then
            btn_class_val = "danger"
        End If

        ' 텍스트 위치 계산
        Dim tx1_val, ty1_val, bojngv_val
        bojngv_val = 0
        If CDbl(bassize_val) > 30 Then
            bojngv_val = -10
        End If

        If basdirection_val = "1" Then
            tx1_val = CDbl(x1_val) + (CDbl(bassize_val) / 2)
            ty1_val = CDbl(y1_val) - 1
        ElseIf basdirection_val = "2" Then
            tx1_val = CDbl(x1_val) - 5
            ty1_val = CDbl(y1_val) + (CDbl(bassize_val) / 2) + bojngv_val + 10
        ElseIf basdirection_val = "3" Then
            tx1_val = CDbl(x1_val) - (CDbl(bassize_val) / 2)
            ty1_val = CDbl(y1_val) + 5
        ElseIf basdirection_val = "4" Then
            tx1_val = CDbl(x1_val) + 5
            ty1_val = CDbl(y1_val) - (CDbl(bassize_val) / 2) + bojngv_val + 10
        Else
            tx1_val = x1_val
            ty1_val = y1_val
        End If

        ' bassize 정수/소수 처리
        Dim bassize_display_val
        If CDbl(bassize_val) = Int(CDbl(bassize_val)) Then
            bassize_display_val = FormatNumber(bassize_val, 0)
        Else
            bassize_display_val = FormatNumber(bassize_val, 1)
        End If

        ' row1 item + svg path를 하나의 객체로
        If Not isFirstRow Then Response.Write ", "
        isFirstRow = False

        Response.Write "{"
        Response.Write """accsize"": """ & JsonSafe(accsize_val) & """, "
        Response.Write """btn_class"": """ & btn_class_val & """, "
        Response.Write """x1"": " & x1_val & ", ""y1"": " & y1_val & ", "
        Response.Write """x2"": " & x2_val & ", ""y2"": " & y2_val & ", "
        Response.Write """tx1"": " & tx1_val & ", ""ty1"": " & ty1_val & ", "
        Response.Write """text"": """ & JsonSafe(bassize_display_val) & """"
        Response.Write "}"

        Rs.MoveNext
    Loop

    ' 마지막 baidx 닫기
    If currentBaidx <> "" Then
        Response.Write "]}"
    End If
End If

Response.Write "}"

Rs.Close
Set Rs = Nothing
call dbClose()
%>
