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
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

baidx = Request("baidx")

If baidx = "" Then
    Response.Write "{""error"": ""baidx is required""}"
    Response.End
End If

' 절곡 서브 데이터 조회
SQL = "SELECT basidx, bassize, basdirection, x1, y1, x2, y2, accsize, idv, final "
SQL = SQL & "FROM tk_barasisub "
SQL = SQL & "WHERE baidx = '" & baidx & "' "
SQL = SQL & "ORDER BY basidx ASC"

Rs.Open SQL, Dbcon, 1, 1

' Row 1 데이터 (치수와 결과값)
Dim row1Data()
ReDim row1Data(0)
Dim row1Count
row1Count = 0

' Row 2 데이터 (SVG 경로)
Dim svgPaths()
ReDim svgPaths(0)
Dim svgCount
svgCount = 0

Dim finalShearing
finalShearing = ""
Dim hasFinalZero
hasFinalZero = False

Dim g
g = 0

If Not (Rs.EOF Or Rs.BOF) Then
    Do While Not Rs.EOF
        Dim basidx, bassize, basdirection, x1, y1, x2, y2, accsize, idv, final_val
        basidx = Rs("basidx")
        bassize = Rs("bassize")
        basdirection = Rs("basdirection")
        x1 = Rs("x1")
        y1 = Rs("y1")
        x2 = Rs("x2")
        y2 = Rs("y2")
        accsize = Rs("accsize")
        idv = Rs("idv")
        final_val = Rs("final")
        
        g = g + 1
        
        ' 방향 텍스트
        Dim direction_text
        If basdirection = "1" Then
            direction_text = "→"
        ElseIf basdirection = "2" Then
            direction_text = "↓"
        ElseIf basdirection = "3" Then
            direction_text = "←"
        ElseIf basdirection = "4" Then
            direction_text = "↑"
        Else
            direction_text = "-"
        End If
        
        ' 버튼 스타일 결정
        Dim btn_class
        btn_class = "primary"
        
        If idv = "0" Then
            If g > 1 Then
                btn_class = "primary"
            End If
        Else
            btn_class = "light"
        End If
        
        ' final="0"일 때 샤링값 (빨간색)
        If final_val = "0" Then
            btn_class = "danger"
            hasFinalZero = True
        End If
        
        ' Row 1 데이터 추가
        If row1Count > 0 Then
            ReDim Preserve row1Data(row1Count)
        End If
        
        Dim row1Item
        row1Item = "{""bassize"": """ & JsonSafe(bassize) & """, ""accsize"": """ & JsonSafe(accsize) & """, ""btn_class"": """ & btn_class & """}"
        row1Data(row1Count) = row1Item
        row1Count = row1Count + 1
        
        ' SVG 경로 데이터 추가
        If svgCount > 0 Then
            ReDim Preserve svgPaths(svgCount)
        End If
        
        ' 텍스트 위치 계산
        Dim tx1, ty1, bojngv
        bojngv = 0
        If bassize > 30 Then
            bojngv = -10
        End If
        
        If basdirection = "1" Then
            tx1 = x1 + (bassize / 2)
            ty1 = y1 - 1
        ElseIf basdirection = "2" Then
            tx1 = x1 - 5
            ty1 = y1 + (bassize / 2) + bojngv + 10
        ElseIf basdirection = "3" Then
            tx1 = x1 - (bassize / 2)
            ty1 = y1 + 5
        ElseIf basdirection = "4" Then
            tx1 = x1 + 5
            ty1 = y1 - (bassize / 2) + bojngv + 10
        End If
        
        ' bassize 정수/소수 처리
        Dim bassize_display
        If bassize = Int(bassize) Then
            bassize_display = FormatNumber(bassize, 0)
        Else
            bassize_display = FormatNumber(bassize, 1)
        End If
        
        Dim svgPath
        svgPath = "{""x1"": " & x1 & ", ""y1"": " & y1 & ", ""x2"": " & x2 & ", ""y2"": " & y2 & ", "
        svgPath = svgPath & """tx1"": " & tx1 & ", ""ty1"": " & ty1 & ", ""text"": """ & JsonSafe(bassize_display) & """}"
        svgPaths(svgCount) = svgPath
        svgCount = svgCount + 1
        
        ' 최종 샤링값 = accsize의 최대값
        If IsNumeric(accsize) Then
            If finalShearing = "" Or CDbl(accsize) > CDbl(finalShearing) Then
                finalShearing = accsize
            End If
        End If
        
        Rs.MoveNext
    Loop
End If

Rs.Close

' JSON 응답
Response.Write "{"
Response.Write """baidx"": " & baidx & ", "

' Row 1 데이터
Response.Write """row1"": ["
For i = 0 To row1Count - 1
    If i > 0 Then Response.Write ", "
    Response.Write row1Data(i)
Next
Response.Write "], "

' SVG 경로
Response.Write """svg_paths"": ["
For i = 0 To svgCount - 1
    If i > 0 Then Response.Write ", "
    Response.Write svgPaths(i)
Next
Response.Write "], "

' 샤링값 = MAX(accsize)
Response.Write """final_shearing"": """ & JsonSafe(finalShearing) & """, "
Response.Write """has_shearing"": " & LCase(CStr(hasFinalZero))
Response.Write "}"

Set Rs = Nothing
call dbClose()
%>