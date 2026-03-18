<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
' ============================================================
' /paint_color/picker_api.asp
' 페인트 피커 전용 읽기전용 JSON API v1.0
' modes: search, color_group, similar, brands
' ============================================================
call dbOpen()

Dim mode
mode = LCase(Trim(Request("mode") & ""))

If mode = "" Then
    Response.Write "{""ok"":false,""msg"":""mode required""}"
    call dbClose()
    Response.End
End If

' === 초성 매핑 함수 ===
' 한글 초성(ㄱ~ㅎ) → SQL Server LIKE 범위 [가-깋] 등
Function ChoToRange(ch)
    Dim code
    code = AscW(ch)
    Select Case code
        Case &H3131 : ChoToRange = ChrW(&HAC00) & "-" & ChrW(&HAE4B)  ' ㄱ → 가-깋
        Case &H3132 : ChoToRange = ChrW(&HAE4C) & "-" & ChrW(&HB097)  ' ㄲ → 까-낗
        Case &H3134 : ChoToRange = ChrW(&HB098) & "-" & ChrW(&HB2E3)  ' ㄴ → 나-닣
        Case &H3137 : ChoToRange = ChrW(&HB2E4) & "-" & ChrW(&HB52F)  ' ㄷ → 다-딯
        Case &H3138 : ChoToRange = ChrW(&HB530) & "-" & ChrW(&HB77B)  ' ㄸ → 따-럻
        Case &H3139 : ChoToRange = ChrW(&HB77C) & "-" & ChrW(&HB9C7)  ' ㄹ → 라-맇
        Case &H3141 : ChoToRange = ChrW(&HB9C8) & "-" & ChrW(&HBC13)  ' ㅁ → 마-밓
        Case &H3142 : ChoToRange = ChrW(&HBC14) & "-" & ChrW(&HBE5F)  ' ㅂ → 바-뷟
        Case &H3143 : ChoToRange = ChrW(&HBE60) & "-" & ChrW(&HC0AB)  ' ㅃ → 뷠-삫
        Case &H3145 : ChoToRange = ChrW(&HC0AC) & "-" & ChrW(&HC2F7)  ' ㅅ → 사-싷
        Case &H3146 : ChoToRange = ChrW(&HC2F8) & "-" & ChrW(&HC543)  ' ㅆ → 싸-앃
        Case &H3147 : ChoToRange = ChrW(&HC544) & "-" & ChrW(&HC78F)  ' ㅇ → 아-잏
        Case &H3148 : ChoToRange = ChrW(&HC790) & "-" & ChrW(&HC9DB)  ' ㅈ → 자-짛
        Case &H3149 : ChoToRange = ChrW(&HC9DC) & "-" & ChrW(&HCC27)  ' ㅉ → 짜-찧
        Case &H314A : ChoToRange = ChrW(&HCC28) & "-" & ChrW(&HCE73)  ' ㅊ → 차-칳
        Case &H314B : ChoToRange = ChrW(&HCE74) & "-" & ChrW(&HD0BF)  ' ㅋ → 카-탿
        Case &H314C : ChoToRange = ChrW(&HD0C0) & "-" & ChrW(&HD30B)  ' ㅌ → 타-팋
        Case &H314D : ChoToRange = ChrW(&HD30C) & "-" & ChrW(&HD557)  ' ㅍ → 파-핗
        Case &H314E : ChoToRange = ChrW(&HD558) & "-" & ChrW(&HD7A3)  ' ㅎ → 하-힣
        Case Else   : ChoToRange = ""
    End Select
End Function

' 초성 문자열인지 판별
Function IsChosung(s)
    Dim i, c
    IsChosung = True
    If Len(s) = 0 Then IsChosung = False : Exit Function
    For i = 1 To Len(s)
        c = AscW(Mid(s, i, 1))
        If c < &H3131 Or c > &H314E Then
            IsChosung = False
            Exit Function
        End If
    Next
End Function

' 초성 문자열 → SQL LIKE 패턴
Function ChosungToLike(s)
    Dim i, ch, rng, pat
    pat = ""
    For i = 1 To Len(s)
        ch = Mid(s, i, 1)
        rng = ChoToRange(ch)
        If rng <> "" Then
            pat = pat & "[" & rng & "]"
        End If
    Next
    ChosungToLike = pat & "%"
End Function

' SQL 인젝션 방지
Function SafeStr(s)
    SafeStr = Replace(s, "'", "''")
End Function


' =====================
' mode = brands
' =====================
If mode = "brands" Then
    Dim sqlB
    sqlB = "SELECT pbidx, pname_brand FROM tk_paint_brand WHERE pname_brand IS NOT NULL AND pname_brand<>'' ORDER BY pname_brand"
    Dim rsB
    Set rsB = DbCon.Execute(sqlB)
    Dim jsonB
    jsonB = "{""ok"":true,""data"":["
    Dim firstB : firstB = True
    Do While Not rsB.EOF
        If Not firstB Then jsonB = jsonB & ","
        ' 해당 브랜드의 coat 목록 조회
        Dim sqlBC, rsBC, coatArr
        coatArr = ""
        sqlBC = "SELECT DISTINCT ISNULL(coat,0) AS coat FROM tk_paint WHERE pstatus=1 AND pname_brand=" & rsB("pbidx") & " ORDER BY coat"
        Set rsBC = DbCon.Execute(sqlBC)
        Dim firstBC : firstBC = True
        Do While Not rsBC.EOF
            If Not firstBC Then coatArr = coatArr & ","
            coatArr = coatArr & CInt(rsBC("coat"))
            firstBC = False
            rsBC.MoveNext
        Loop
        rsBC.Close
        Set rsBC = Nothing
        jsonB = jsonB & "{""pbidx"":" & rsB("pbidx") & ",""name"":""" & SafeStr(rsB("pname_brand") & "") & """,""coats"":[" & coatArr & "]}"
        firstB = False
        rsB.MoveNext
    Loop
    rsB.Close
    Set rsB = Nothing
    jsonB = jsonB & "]}"
    Response.Write jsonB
    call dbClose()
    Response.End
End If


' =====================
' mode = search
' =====================
If mode = "search" Then
    Dim qS, pageS, sizeS, brandS, coatParam
    qS = Trim(Request("q") & "")
    pageS = CInt("0" & Request("page"))
    sizeS = CInt("0" & Request("size"))
    brandS = CInt("0" & Request("brand"))
    coatParam = Trim(Request("coat") & "")
    If coatParam = "" Then coatParam = "-1"

    If pageS < 1 Then pageS = 1
    If sizeS < 1 Then sizeS = 50
    If sizeS > 200 Then sizeS = 200

    Dim whereS, isChosungSearch
    whereS = "A.pstatus=1"
    isChosungSearch = False

    ' 브랜드 필터
    If brandS > 0 Then
        whereS = whereS & " AND A.pname_brand=" & brandS
    End If

    ' 코트 필터
    If coatParam <> "-1" And IsNumeric(coatParam) Then
        whereS = whereS & " AND A.coat=" & CInt(coatParam)
    End If

    ' 검색어
    If qS <> "" Then
        If IsChosung(qS) Then
            ' 초성 검색
            isChosungSearch = True
            Dim likePat
            likePat = ChosungToLike(qS)
            whereS = whereS & " AND A.pname LIKE N'" & SafeStr(likePat) & "'"
        Else
            ' Full-Text Search (CONTAINS 접두사) + LIKE 폴백 (한글 중간글자 매칭)
            Dim words, w, sq
            words = Split(qS, " ")
            For Each w In words
                w = Trim(w)
                If w <> "" Then
                    sq = SafeStr(w)
                    whereS = whereS & " AND (" & _
                             "CONTAINS((A.pcode, A.pname), N'""" & sq & "*""')" & _
                             " OR A.pcode LIKE N'%" & sq & "%'" & _
                             " OR A.pname LIKE N'%" & sq & "%'" & _
                             " OR EXISTS(SELECT 1 FROM tk_paint_brand WHERE pbidx=A.pname_brand" & _
                             " AND (CONTAINS(pname_brand, N'""" & sq & "*""') OR pname_brand LIKE N'%" & sq & "%')))"
                End If
            Next
        End If
    End If

    ' 카운트
    Dim sqlCnt, rsCnt, totalS
    sqlCnt = "SELECT COUNT(*) AS cnt FROM tk_paint A WHERE " & whereS
    Set rsCnt = DbCon.Execute(sqlCnt)
    totalS = CInt(rsCnt("cnt"))
    rsCnt.Close
    Set rsCnt = Nothing

    Dim pagesS
    pagesS = Int((totalS + sizeS - 1) / sizeS)
    If pagesS < 1 Then pagesS = 1

    ' 데이터 (ROW_NUMBER 페이지네이션)
    Dim offsetS
    offsetS = (pageS - 1) * sizeS

    Dim sqlS
    sqlS = "SELECT * FROM (" & _
           "SELECT ROW_NUMBER() OVER(ORDER BY A.pidx DESC) AS rn, " & _
           "A.pidx, A.pcode, A.pname, A.p_hex_color, A.coat, A.paint_type, A.pprice, A.p_image, A.pname_brand, " & _
           "ISNULL((SELECT pname_brand FROM tk_paint_brand WHERE pbidx=A.pname_brand),'') AS brand_name " & _
           "FROM tk_paint A WHERE " & whereS & _
           ") T WHERE T.rn>" & offsetS & " AND T.rn<=" & (offsetS + sizeS)

    Dim rsS
    Set rsS = DbCon.Execute(sqlS)
    Dim jsonS
    jsonS = "{""ok"":true,""chosung"":" & LCase(CStr(isChosungSearch)) & ",""total"":" & totalS & ",""page"":" & pageS & ",""pages"":" & pagesS & ",""data"":["
    Dim firstS : firstS = True
    Do While Not rsS.EOF
        If Not firstS Then jsonS = jsonS & ","
        Dim hexVal
        hexVal = rsS("p_hex_color") & ""
        jsonS = jsonS & "{""pidx"":" & rsS("pidx") & _
                ",""pcode"":""" & SafeStr(rsS("pcode") & "") & """" & _
                ",""pname"":""" & SafeStr(rsS("pname") & "") & """" & _
                ",""hex"":""" & SafeStr(hexVal) & """" & _
                ",""coat"":" & CInt("0" & rsS("coat")) & _
                ",""paint_type"":" & CInt("0" & rsS("paint_type")) & _
                ",""brand"":""" & SafeStr(rsS("brand_name") & "") & """" & _
                ",""brand_id"":" & CInt("0" & rsS("pname_brand")) & _
                "}"
        firstS = False
        rsS.MoveNext
    Loop
    rsS.Close
    Set rsS = Nothing
    jsonS = jsonS & "]}"
    Response.Write jsonS
    call dbClose()
    Response.End
End If


' =====================
' mode = color_group
' =====================
If mode = "color_group" Then
    Dim grpG, pageG, sizeG, brandG, coatG
    grpG = LCase(Trim(Request("group") & ""))
    pageG = CInt("0" & Request("page"))
    sizeG = CInt("0" & Request("size"))
    brandG = CInt("0" & Request("brand"))
    coatG = Trim(Request("coat") & "")
    If coatG = "" Then coatG = "-1"
    If pageG < 1 Then pageG = 1
    If sizeG < 1 Then sizeG = 50
    If sizeG > 200 Then sizeG = 200

    ' hex→RGB CROSS APPLY
    Dim rgbSQL
    rgbSQL = " CROSS APPLY (SELECT " & _
             "CASE WHEN ISNULL(LEN(A.p_hex_color),0)>=7 " & _
             "THEN CONVERT(INT,CONVERT(VARBINARY(1),SUBSTRING(A.p_hex_color,2,2),2)) ELSE -1 END AS cR," & _
             "CASE WHEN ISNULL(LEN(A.p_hex_color),0)>=7 " & _
             "THEN CONVERT(INT,CONVERT(VARBINARY(1),SUBSTRING(A.p_hex_color,4,2),2)) ELSE -1 END AS cG," & _
             "CASE WHEN ISNULL(LEN(A.p_hex_color),0)>=7 " & _
             "THEN CONVERT(INT,CONVERT(VARBINARY(1),SUBSTRING(A.p_hex_color,6,2),2)) ELSE -1 END AS cB" & _
             ") AS C"

    Dim whereG
    whereG = "A.pstatus=1 AND C.cR>=0"

    Select Case grpG
        Case "nocolor"
            whereG = "A.pstatus=1 AND (A.p_hex_color IS NULL OR A.p_hex_color='')"
        Case "black"
            whereG = whereG & " AND (C.cR+C.cG+C.cB)<135"
        Case "darkgray"
            whereG = whereG & " AND ABS(C.cR-C.cG)<45 AND ABS(C.cG-C.cB)<45 AND ABS(C.cR-C.cB)<50 AND (C.cR+C.cG+C.cB)>=135 AND (C.cR+C.cG+C.cB)<345"
        Case "silver"
            whereG = whereG & " AND ABS(C.cR-C.cG)<50 AND ABS(C.cG-C.cB)<50 AND ABS(C.cR-C.cB)<55 AND (C.cR+C.cG+C.cB)>=345 AND (C.cR+C.cG+C.cB)<525"
        Case "lightgray"
            whereG = whereG & " AND ABS(C.cR-C.cG)<45 AND ABS(C.cG-C.cB)<45 AND ABS(C.cR-C.cB)<50 AND (C.cR+C.cG+C.cB)>=525"
        Case "ivory"
            whereG = whereG & " AND C.cR>190 AND C.cG>170 AND C.cB>130 AND (C.cG-C.cB)>5 AND (C.cR-C.cB)>15 AND (C.cR+C.cG+C.cB)>510"
        Case "brown"
            whereG = whereG & " AND C.cR>=C.cG AND C.cG>=C.cB AND C.cG>(C.cR/4) AND C.cG<(C.cR*80/100) AND (C.cR-C.cB)>30 AND (C.cR+C.cG+C.cB)>=120 AND (C.cR+C.cG+C.cB)<480"
        Case "red"
            whereG = whereG & " AND C.cR>140 AND C.cR>=C.cG AND C.cR>=C.cB AND C.cG<(C.cR*45/100) AND C.cB<(C.cR*55/100)"
        Case "orange"
            whereG = whereG & " AND C.cR>160 AND C.cG>(C.cR*30/100) AND C.cG<(C.cR*70/100) AND C.cB<(C.cR*30/100)"
        Case "yellow"
            whereG = whereG & " AND C.cR>150 AND C.cG>140 AND C.cG>(C.cR*70/100) AND C.cB<(C.cG*55/100)"
        Case "green"
            whereG = whereG & " AND C.cG>=C.cR AND C.cG>=C.cB AND (C.cG-C.cR)>25"
        Case "blue"
            whereG = whereG & " AND C.cB>C.cR AND C.cB>C.cG AND (C.cR+C.cG+C.cB)>=200 AND (C.cB-C.cR)>30"
        Case "navy"
            whereG = whereG & " AND C.cB>=C.cR AND C.cB>=C.cG AND (C.cR+C.cG+C.cB)<200 AND C.cB>30"
        Case "purple"
            whereG = whereG & " AND C.cR>(C.cG+15) AND C.cB>(C.cG+15) AND ABS(C.cR-C.cB)<120"
        Case Else
            whereG = "A.pstatus=1 AND C.cR>=0"
    End Select

    ' 브랜드/코트 필터 추가
    If brandG > 0 Then
        whereG = whereG & " AND A.pname_brand=" & brandG
    End If
    If coatG <> "-1" And IsNumeric(coatG) Then
        whereG = whereG & " AND ISNULL(A.coat,0)=" & CInt(coatG)
    End If

    ' nocolor는 CROSS APPLY 불필요
    Dim fromG
    If grpG = "nocolor" Then
        fromG = "tk_paint A"
    Else
        fromG = "tk_paint A" & rgbSQL
    End If

    ' 카운트
    Dim sqlCntG, rsCntG, totalG
    sqlCntG = "SELECT COUNT(*) AS cnt FROM " & fromG & " WHERE " & whereG
    Set rsCntG = DbCon.Execute(sqlCntG)
    totalG = CInt(rsCntG("cnt"))
    rsCntG.Close
    Set rsCntG = Nothing

    Dim pagesG
    pagesG = Int((totalG + sizeG - 1) / sizeG)
    If pagesG < 1 Then pagesG = 1

    Dim offsetG
    offsetG = (pageG - 1) * sizeG

    Dim sqlG
    sqlG = "SELECT * FROM (" & _
           "SELECT ROW_NUMBER() OVER(ORDER BY A.pidx DESC) AS rn, " & _
           "A.pidx, A.pcode, A.pname, A.p_hex_color, A.coat, A.paint_type, A.pname_brand, " & _
           "ISNULL((SELECT pname_brand FROM tk_paint_brand WHERE pbidx=A.pname_brand),'') AS brand_name " & _
           "FROM " & fromG & " WHERE " & whereG & _
           ") T WHERE T.rn>" & offsetG & " AND T.rn<=" & (offsetG + sizeG)

    Dim rsG
    Set rsG = DbCon.Execute(sqlG)
    Dim jsonG
    jsonG = "{""ok"":true,""group"":""" & grpG & """,""total"":" & totalG & ",""page"":" & pageG & ",""pages"":" & pagesG & ",""data"":["
    Dim firstG : firstG = True
    Do While Not rsG.EOF
        If Not firstG Then jsonG = jsonG & ","
        jsonG = jsonG & "{""pidx"":" & rsG("pidx") & _
                ",""pcode"":""" & SafeStr(rsG("pcode") & "") & """" & _
                ",""pname"":""" & SafeStr(rsG("pname") & "") & """" & _
                ",""hex"":""" & SafeStr(rsG("p_hex_color") & "") & """" & _
                ",""coat"":" & CInt("0" & rsG("coat")) & _
                ",""paint_type"":" & CInt("0" & rsG("paint_type")) & _
                ",""brand"":""" & SafeStr(rsG("brand_name") & "") & """" & _
                ",""brand_id"":" & CInt("0" & rsG("pname_brand")) & _
                "}"
        firstG = False
        rsG.MoveNext
    Loop
    rsG.Close
    Set rsG = Nothing
    jsonG = jsonG & "]}"
    Response.Write jsonG
    call dbClose()
    Response.End
End If


' =====================
' mode = similar
' =====================
If mode = "similar" Then
    Dim hexS, limitS
    hexS = Trim(Request("hex") & "")
    limitS = CInt("0" & Request("limit"))
    If limitS < 1 Then limitS = 50
    If limitS > 200 Then limitS = 200

    ' hex → RGB 파싱 (#FF5500 → R=255, G=85, B=0)
    hexS = Replace(hexS, "#", "")
    hexS = Replace(hexS, "%23", "")
    If Len(hexS) < 6 Then
        Response.Write "{""ok"":false,""msg"":""invalid hex""}"
        call dbClose()
        Response.End
    End If

    Dim tR, tG, tB
    tR = CLng("&H" & Mid(hexS, 1, 2))
    tG = CLng("&H" & Mid(hexS, 3, 2))
    tB = CLng("&H" & Mid(hexS, 5, 2))

    Dim rgbSQLsim
    rgbSQLsim = " CROSS APPLY (SELECT " & _
                "CASE WHEN ISNULL(LEN(A.p_hex_color),0)>=7 " & _
                "THEN CONVERT(INT,CONVERT(VARBINARY(1),SUBSTRING(A.p_hex_color,2,2),2)) ELSE -1 END AS cR," & _
                "CASE WHEN ISNULL(LEN(A.p_hex_color),0)>=7 " & _
                "THEN CONVERT(INT,CONVERT(VARBINARY(1),SUBSTRING(A.p_hex_color,4,2),2)) ELSE -1 END AS cG," & _
                "CASE WHEN ISNULL(LEN(A.p_hex_color),0)>=7 " & _
                "THEN CONVERT(INT,CONVERT(VARBINARY(1),SUBSTRING(A.p_hex_color,6,2),2)) ELSE -1 END AS cB" & _
                ") AS C"

    Dim sqlSim
    sqlSim = "SELECT TOP " & limitS & " A.pidx, A.pcode, A.pname, A.p_hex_color, A.coat, A.paint_type, A.pname_brand, " & _
             "ISNULL((SELECT pname_brand FROM tk_paint_brand WHERE pbidx=A.pname_brand),'') AS brand_name, " & _
             "POWER(C.cR-" & tR & ",2)+POWER(C.cG-" & tG & ",2)+POWER(C.cB-" & tB & ",2) AS dist " & _
             "FROM tk_paint A" & rgbSQLsim & " " & _
             "WHERE A.pstatus=1 AND C.cR>=0 " & _
             "ORDER BY dist ASC"

    Dim rsSim
    Set rsSim = DbCon.Execute(sqlSim)
    Dim jsonSim
    jsonSim = "{""ok"":true,""target"":""#" & hexS & """,""data"":["
    Dim firstSim : firstSim = True
    Do While Not rsSim.EOF
        If Not firstSim Then jsonSim = jsonSim & ","
        jsonSim = jsonSim & "{""pidx"":" & rsSim("pidx") & _
                  ",""pcode"":""" & SafeStr(rsSim("pcode") & "") & """" & _
                  ",""pname"":""" & SafeStr(rsSim("pname") & "") & """" & _
                  ",""hex"":""" & SafeStr(rsSim("p_hex_color") & "") & """" & _
                  ",""coat"":" & CInt("0" & rsSim("coat")) & _
                  ",""paint_type"":" & CInt("0" & rsSim("paint_type")) & _
                  ",""brand"":""" & SafeStr(rsSim("brand_name") & "") & """" & _
                  ",""brand_id"":" & CInt("0" & rsSim("pname_brand")) & _
                  ",""dist"":" & CLng(rsSim("dist")) & _
                  "}"
        firstSim = False
        rsSim.MoveNext
    Loop
    rsSim.Close
    Set rsSim = Nothing
    jsonSim = jsonSim & "]}"
    Response.Write jsonSim
    call dbClose()
    Response.End
End If


' 알 수 없는 mode
Response.Write "{""ok"":false,""msg"":""unknown mode: " & SafeStr(mode) & """}"
call dbClose()
%>
