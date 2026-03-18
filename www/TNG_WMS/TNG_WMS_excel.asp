<%@ CodePage="65001" Language="VBScript" %>
<%
Session.CodePage = 65001
Response.Charset  = "utf-8"
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "attachment; filename=WMS_출하_" & Replace(Date(),"-","") & ".xls"
Response.Write "<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
On Error Resume Next

Call GenerateExcel()

If Err.Number = 0 Then
    Err.Clear
    Response.Write "<table><tr><td>"&Err.Number&"엑셀 변환 중 오류가 있었지만 파일은 정상 출력되었습니다.</td></tr></table>"
End If
%>

<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

ymd = Trim(Request("ymd"))
If ymd = "" Then ymd = Replace(Date(), "-", "")
ymd = Replace(ymd, "-", "")

' ============================================================
' 공통 함수
' ============================================================
Function Clean(v)
    If IsNull(v) Then Clean = "" : Exit Function
    v = Trim(v)
    v = Replace(v, "-", "")
    v = Replace(v, "_", "")
    v = Replace(v, ".", "")
    Clean = v
End Function

Function CleanNameOnly(bn)
    Dim regEx
    Set regEx = New RegExp
    regEx.Pattern = "^\s*\d+\s*[xX]\s*\d+\s*_?\s*"
    regEx.IgnoreCase = True
    regEx.Global = True
    CleanNameOnly = Trim(regEx.Replace(bn, ""))
End Function

Function NormalizeName(name)
    If InStr(name, "박스세트") > 0 Then
        NormalizeName = "박스세트"
    ElseIf InStr(name, "박스커버") > 0 Then
        NormalizeName = "박스커버"
    Else
        NormalizeName = name
    End If
End Function

Function MyMin(a,b)
    If a < b Then MyMin = a Else MyMin = b
End Function

Function SortByLength(x, y)
    If x(0) < y(0) Then
        SortByLength = -1
    ElseIf x(0) > y(0) Then
        SortByLength = 1
    Else
        SortByLength = 0
    End If
End Function

Function SortFks(x, y)
    If x(0) < y(0) Then
        SortFks = -1
    ElseIf x(0) > y(0) Then
        SortFks = 1
    Else
        If x(3) < y(3) Then
            SortFks = -1
        ElseIf x(3) > y(3) Then
            SortFks = 1
        Else
            SortFks = 0
        End If
    End If
End Function


' ############################################################
' [1] dictSjs (품목/재질/비고)
' ############################################################
Dim dictSjs : Set dictSjs = Server.CreateObject("Scripting.Dictionary")

SQL = ""
SQL = SQL & "SELECT A.sjsidx, A.framename, G.qtyname, P.pname, "
SQL = SQL & "       A.asub_wichi1, A.asub_wichi2, A.asub_bigo1, A.asub_bigo2, A.asub_bigo3, "
SQL = SQL & "       A.asub_meno1, A.asub_meno2, A.mwidth, A.mheight, A.qtyidx "
SQL = SQL & "FROM tng_sjaSub A "
SQL = SQL & "JOIN tk_wms_meta M ON A.sjidx = M.sjidx "
SQL = SQL & "LEFT JOIN tk_qty C ON A.qtyidx = C.qtyidx "
SQL = SQL & "LEFT JOIN tk_qtyco G ON C.qtyno = G.qtyno "
SQL = SQL & "LEFT JOIN tk_paint P ON A.pidx = P.pidx "
SQL = SQL & "WHERE M.actual_ship_dt='" & ymd & "' AND A.astatus='1'"

Set Rs = Dbcon.Execute(SQL)
Do Until Rs.EOF
    sidx = "" & Rs("sjsidx")

    tmpB = Trim("" & Rs("asub_wichi1") & " " & Rs("asub_wichi2") & " " & _
                     Rs("asub_bigo1")  & " " & Rs("asub_bigo2") & " " & _
                     Rs("asub_bigo3")  & " " & Rs("asub_meno1") & " " & Rs("asub_meno2"))
    tmpB = Replace(tmpB, "  ", " ")

    mw = Trim("" & Rs("mwidth"))
    If mw = "" Or Not IsNumeric(mw) Then mw = 0

    mh = Trim("" & Rs("mheight"))
    If mh = "" Or Not IsNumeric(mh) Then mh = 0

    dictSjs.Add sidx, Array( _
        "" & Rs("framename"), _
        "" & Rs("qtyname"), _
        "" & Rs("pname"), _
        tmpB, _
        mw, _
        mh, _
        Rs("qtyidx") _
    )

    Rs.MoveNext
Loop
Rs.Close


' ############################################################
' [2] dictDj (도장번호)
' ############################################################
Dim dictDj : Set dictDj = Server.CreateObject("Scripting.Dictionary")

SQL = ""
SQL = SQL & "SELECT D.sjsidx, D.djnum FROM tk_wms_djnum D "
SQL = SQL & "JOIN tk_wms_meta M ON D.sjidx = M.sjidx "
SQL = SQL & "WHERE M.actual_ship_dt='" & ymd & "' ORDER BY D.sjsidx, D.djnum"

Set Rs = Dbcon.Execute(SQL)
Do Until Rs.EOF
    sidx = "" & Rs("sjsidx")
    If Not dictDj.Exists(sidx) Then
        dictDj.Add sidx, "" & Rs("djnum")
    End If
    Rs.MoveNext
Loop
Rs.Close


' ############################################################
' [3] dictDetail (규격 리스트)
' ############################################################
Dim dictDetail : Set dictDetail = Server.CreateObject("Scripting.Dictionary")

SQL = ""
SQL = SQL & "SELECT D.wms_idx, D.sjsidx, D.blength, D.quan, D.bfgroup, D.baname "
SQL = SQL & "FROM tk_wms_detail D "
SQL = SQL & "JOIN tk_wms_meta M ON D.wms_idx = M.wms_idx "
SQL = SQL & "WHERE M.actual_ship_dt='" & ymd & "'"

Set Rs = Dbcon.Execute(SQL)

Do Until Rs.EOF
    keyD = CStr(Rs("wms_idx")) & "_" & CStr(Rs("sjsidx"))

    If Not dictDetail.Exists(keyD) Then
        Set dictDetail(keyD) = CreateObject("System.Collections.ArrayList")
    End If

    dictDetail(keyD).Add Array( _
        CLng(0 & Rs("blength")), _
        CLng(0 & Rs("quan")), _
        CStr("" & Rs("bfgroup")), _
        CStr("" & Rs("baname")) _
    )

    Rs.MoveNext
Loop
Rs.Close

' 정렬
For Each keyD In dictDetail.Keys
    Set tmpList = dictDetail(keyD)
    tmpList.Sort GetRef("SortByLength")
    Set dictDetail(keyD) = tmpList
Next


' ############################################################
' [4] dictFks (framek 정보)
' ############################################################
Dim dictFks : Set dictFks = Server.CreateObject("Scripting.Dictionary")

SQL = ""
SQL = SQL & "SELECT S.sjsidx, FS.fkidx, FS.whichi_auto, FS.whichi_fix, FS.blength "
SQL = SQL & "FROM tk_framekSub FS "
SQL = SQL & "JOIN tk_framek S ON FS.fkidx = S.fkidx "
SQL = SQL & "JOIN tk_wms_meta M ON S.sjidx = M.sjidx "
SQL = SQL & "WHERE M.actual_ship_dt='" & ymd & "' AND FS.gls=0"

Set Rs = Dbcon.Execute(SQL)

Do Until Rs.EOF
    sidx = "" & Rs("sjsidx")
    If Not dictFks.Exists(sidx) Then
        Set dictFks(sidx) = CreateObject("System.Collections.ArrayList")
    End If

    dictFks(sidx).Add Array( _
        CLng(0 & Rs("fkidx")), _
        CLng(0 & Rs("whichi_auto")), _
        CLng(0 & Rs("whichi_fix")), _
        CLng(0 & Rs("blength")) _
    )

    Rs.MoveNext
Loop
Rs.Close

' 정렬
For Each sidx In dictFks.Keys
    Set tmpList = dictFks(sidx)
    tmpList.Sort GetRef("SortFks")
    Set dictFks(sidx) = tmpList
Next

' ###################################################################
' STEP 2 — 대시보드와 100% 동일한 규격 병합 로직 (엑셀용)
' ###################################################################
Function BuildSizeHTML(wms_idx, sjsidx)

    Dim keyD, arrD
    keyD = CStr(wms_idx) & "_" & CStr(sjsidx)

    BuildSizeHTML = ""   ' 기본값

    If Not dictDetail.Exists(keyD) Then Exit Function

    Set arrD = dictDetail(keyD)

    ' -----------------------------------------------------------
    ' STEP 1: blength > 0 인 원본 데이터 수집
    ' -----------------------------------------------------------
    Dim baseList(), baseCnt
    ReDim baseList(0) : baseCnt = 0

    Dim row, bl2, q2, gp2, bn2
    For Each row In arrD
        bl2 = CLng(row(0))
        q2  = CLng(row(1))
        gp2 = CStr(row(2))
        bn2 = CStr(row(3))

        If IsNumeric(row(0)) Then bl2 = CLng(row(0)) Else bl2 = 0
        If IsNumeric(row(1)) Then q2  = CLng(row(1)) Else q2 = 0

        If bl2 > 0 Then
            ReDim Preserve baseList(baseCnt)
            baseList(baseCnt) = Array(bl2, q2, gp2, bn2)
            baseCnt = baseCnt + 1
        End If
    Next

    If baseCnt = 0 Then Exit Function  ' 규격 없음


    ' -----------------------------------------------------------
    ' STEP 2: 카테고리 분리 (FIX / BOX / NORMAL)
    ' -----------------------------------------------------------
    Dim fixList(), fixCnt
    Dim boxList(), boxCnt
    Dim normalList(), normalCnt

    ReDim fixList(0) : fixCnt = 0
    ReDim boxList(0) : boxCnt = 0
    ReDim normalList(0) : normalCnt = 0

    Dim i, bnCheck
    For i = 0 To baseCnt - 1
        bl2 = baseList(i)(0)
        q2  = baseList(i)(1)
        gp2 = baseList(i)(2)
        bn2 = baseList(i)(3)

        If InStr(bn2, "픽스하바") > 0 Or InStr(bn2, "픽스상바") > 0 Or InStr(bn2, "오사이") > 0 Then
            ReDim Preserve fixList(fixCnt)
            fixList(fixCnt) = baseList(i)
            fixCnt = fixCnt + 1

        ElseIf InStr(bn2, "박스") > 0 Then
            ReDim Preserve boxList(boxCnt)
            boxList(boxCnt) = baseList(i)
            boxCnt = boxCnt + 1

        Else
            ReDim Preserve normalList(normalCnt)
            normalList(normalCnt) = baseList(i)
            normalCnt = normalCnt + 1
        End If
    Next


    ' -----------------------------------------------------------
    ' STEP 3: FIX 병합 (픽스세트 / 하바세트 / 상바세트 / 오사이)
    ' -----------------------------------------------------------
    Dim fixOut(), fixOutCnt
    ReDim fixOut(0) : fixOutCnt = 0

    If fixCnt > 0 Then

        Dim fixMap
        Set fixMap = CreateObject("Scripting.Dictionary")

        Dim keyLen, info, baseLen
        baseLen = 0  ' sjidx별 최대 FIX 길이

        ' FIX 수량 집계
        For i = 0 To fixCnt - 1
            bl2 = fixList(i)(0)
            q2  = fixList(i)(1)
            bn2 = fixList(i)(3)

            keyLen = CStr(bl2)

            If bl2 > baseLen Then baseLen = bl2

            If Not fixMap.Exists(keyLen) Then
                fixMap.Add keyLen, Array(0,0,0,bl2)   ' 하바, 상바, 오사이
            End If

            info = fixMap(keyLen)

            If InStr(bn2, "픽스하바") > 0 Then info(0) = info(0) + q2
            If InStr(bn2, "픽스상바") > 0 Then info(1) = info(1) + q2
            If InStr(bn2, "오사이")    > 0 Then info(2) = info(2) + q2

            fixMap(keyLen) = info
        Next

        Dim totalBA, totalSANG, totalOSAI
        totalBA = 0 : totalSANG = 0 : totalOSAI = 0

        For Each keyLen In fixMap.Keys
            info = fixMap(keyLen)
            totalBA   = totalBA   + info(0)
            totalSANG = totalSANG + info(1)
            totalOSAI = totalOSAI + info(2)
        Next

        ' -----------------------------------------------------------
        ' (1) 픽스세트 = 하바 + 상바 + 오사이 2개
        ' -----------------------------------------------------------
        Dim setCnt, habaSet, sangSet, mergedO
        setCnt = MyMin( MyMin(totalBA, totalSANG), Int(totalOSAI / 2) )

        If setCnt > 0 Then
            fixOutCnt = fixOutCnt + 1
            ReDim Preserve fixOut(fixOutCnt-1)
            fixOut(fixOutCnt-1) = Array(baseLen, setCnt, "", "픽스세트")

            totalBA   = totalBA   - setCnt
            totalSANG = totalSANG - setCnt
            totalOSAI = totalOSAI - (setCnt * 2)
        End If

        ' -----------------------------------------------------------
        ' (2) 하바세트
        ' -----------------------------------------------------------
        If totalBA > 0 And totalOSAI > 0 Then
            habaSet = MyMin(totalBA, totalOSAI)

            fixOutCnt = fixOutCnt + 1
            ReDim Preserve fixOut(fixOutCnt-1)
            fixOut(fixOutCnt-1) = Array(baseLen, habaSet, "", "하바세트")

            totalBA   = totalBA   - habaSet
            totalOSAI = totalOSAI - habaSet
        End If

        ' -----------------------------------------------------------
        ' (3) 상바세트
        ' -----------------------------------------------------------
        If totalSANG > 0 And totalOSAI > 0 Then
            sangSet = MyMin(totalSANG, totalOSAI)

            fixOutCnt = fixOutCnt + 1
            ReDim Preserve fixOut(fixOutCnt-1)
            fixOut(fixOutCnt-1) = Array(baseLen, sangSet, "", "상바세트")

            totalSANG = totalSANG - sangSet
            totalOSAI = totalOSAI - sangSet
        End If

        ' -----------------------------------------------------------
        ' (4) 나머지 오사이 (단품)
        ' -----------------------------------------------------------
        If totalOSAI > 0 Then
            fixOutCnt = fixOutCnt + 1
            ReDim Preserve fixOut(fixOutCnt-1)
            fixOut(fixOutCnt-1) = Array(baseLen, totalOSAI, "", "오사이")
        End If

    End If ' END FIX 병합



    ' -----------------------------------------------------------
    ' STEP 4: 박스세트 병합
    ' -----------------------------------------------------------
    Dim boxOut(), boxOutCnt
    ReDim boxOut(0) : boxOutCnt = 0

    If boxCnt > 0 Then
        Dim j, bn0, bl0, merged

        For i = 0 To boxCnt - 1
            bl2 = boxList(i)(0)
            bn2 = NormalizeName(boxList(i)(3))

            merged = False

            For j = 0 To boxOutCnt - 1
                bl0 = boxOut(j)(0)
                bn0 = NormalizeName(boxOut(j)(3))

                If InStr(bn0, "박스") > 0 And Abs(bl0 - bl2) <= 2 Then

                    If bn2 = "박스세트" Or bn0 = "박스세트" Then
                        boxOut(j)(3) = "박스세트"
                    Else
                        boxOut(j)(3) = "박스커버"
                    End If

                    boxOut(j)(1) = boxCnt / 2

                    If bl2 > bl0 Then boxOut(j)(0) = bl2

                    merged = True
                    Exit For
                End If
            Next

            If Not merged Then
                boxOutCnt = boxOutCnt + 1
                ReDim Preserve boxOut(boxOutCnt-1)
                boxOut(boxOutCnt-1) = Array(bl2, 1, "", bn2)
            End If
        Next
    End If



    ' -----------------------------------------------------------
    ' STEP 5: 일반 바 병합
    ' -----------------------------------------------------------
    Dim normOut(), normOutCnt
    ReDim normOut(0) : normOutCnt = 0

    If normalCnt > 0 Then
        For i = 0 To normalCnt - 1
            bl2 = normalList(i)(0)
            q2  = normalList(i)(1)
            gp2 = normalList(i)(2)
            bn2 = normalList(i)(3)

            merged = False

            For j = 0 To normOutCnt - 1
                bl0 = normOut(j)(0)
                bn0 = normOut(j)(3)
                gp0 = normOut(j)(2)

                If Abs(bl0 - bl2) <= 2 And Clean(bn0) = Clean(bn2) And Clean(gp0) = Clean(gp2) Then
                    normOut(j)(1) = normOut(j)(1) + q2
                    If bl2 > bl0 Then normOut(j)(0) = bl2
                    merged = True
                    Exit For
                End If
            Next

            If Not merged Then
                normOutCnt = normOutCnt + 1
                ReDim Preserve normOut(normOutCnt-1)
                normOut(normOutCnt-1) = Array(bl2, q2, gp2, bn2)
            End If
        Next
    End If



    ' -----------------------------------------------------------
    ' STEP 6: 최종 리스트 합치기
    ' -----------------------------------------------------------
    Dim finalList(), finalCnt, idx
    finalCnt = fixOutCnt + boxOutCnt + normOutCnt

    If finalCnt = 0 Then Exit Function

    ReDim finalList(finalCnt - 1)

    idx = 0
    For i = 0 To fixOutCnt - 1
        finalList(idx) = fixOut(i)
        idx = idx + 1
    Next
    For i = 0 To boxOutCnt - 1
        finalList(idx) = boxOut(i)
        idx = idx + 1
    Next
    For i = 0 To normOutCnt - 1
        finalList(idx) = normOut(i)
        idx = idx + 1
    Next


    ' -----------------------------------------------------------
    ' STEP 7: 정렬
    ' -----------------------------------------------------------
    Dim x, y, a, b, tmp
    For x = 0 To finalCnt - 2
        For y = x + 1 To finalCnt - 1

            a = finalList(x)
            b = finalList(y)

            If (Clean(a(3)) = "" And Clean(b(3)) <> "") _
            Or (Clean(a(3)) = Clean(b(3)) And a(0) > b(0)) Then

                tmp = finalList(x)
                finalList(x) = finalList(y)
                finalList(y) = tmp

            End If

        Next
    Next


    ' -----------------------------------------------------------
    ' STEP 8: 출력 HTML 생성
    ' -----------------------------------------------------------
    Dim html, totalQ
    html = ""
    totalQ = 0

    For i = 0 To finalCnt - 1
        html = html & "<span>"

        If finalList(i)(3) <> "" Then
            html = html & "<b>" & CleanNameOnly(finalList(i)(3)) & "</b>&nbsp;"
        End If

        html = html & "<b>" & finalList(i)(0) & "</b> × " & finalList(i)(1)

        html = html & "</span>&nbsp;&nbsp;"

        totalQ = totalQ + finalList(i)(1)
    Next

    BuildSizeHTML = html & "<b>(총 " & totalQ & "개)</b>"

End Function

' ###################################################################
' STEP 3 — 엑셀 전체 출력부 (대시보드 100% 동일 구조)
' ###################################################################

Dim normalHTML, specialHTML
normalHTML  = ""
specialHTML = ""

Dim prev_wms_type_normal, prev_wms_type_special
prev_wms_type_normal  = ""
prev_wms_type_special = ""


' ============================================================
' META 조회 (대시보드와 동일한 구조)
' ============================================================
SQL = ""
SQL = SQL & "SELECT M.wms_idx, M.sjidx, C.cname, "
SQL = SQL & "       M.recv_addr, M.recv_addr1, "
SQL = SQL & "       CONVERT(varchar(10), M.reg_date, 120) AS reg_date, "
SQL = SQL & "       M.wms_type, A.cgset, M.memo "
SQL = SQL & "FROM tk_wms_meta M "
SQL = SQL & "JOIN (SELECT sjidx, MIN(wms_idx) wms_idx "
SQL = SQL & "      FROM tk_wms_meta WHERE actual_ship_dt='" & ymd & "' "
SQL = SQL & "      GROUP BY sjidx) B ON M.wms_idx = B.wms_idx "
SQL = SQL & "JOIN TNG_SJA A ON M.sjidx = A.sjidx "
SQL = SQL & "JOIN tk_customer C ON A.sjcidx = C.cidx "
SQL = SQL & "LEFT JOIN tk_rule_core R ON M.wms_type = R.rule_id "
SQL = SQL & "ORDER BY M.wms_type, M.wms_idx"

Set Rs = Dbcon.Execute(SQL)

If Not (Rs.EOF Or Rs.BOF) Then

    Do Until Rs.EOF

        wms_idx = Rs("wms_idx")
        sjidx   = Rs("sjidx")
        cname   = Rs("cname")
        recv_addr  = Rs("recv_addr")
        recv_addr1 = Rs("recv_addr1")
        reg_date = Rs("reg_date")
        memo     = Rs("memo")
        cgset    = "" & Rs("cgset")
        wms_type = "" & Rs("wms_type")

        ' ------------------------------------------------------------
        ' 출고구분 텍스트
        ' ------------------------------------------------------------
        wmsTypeName = "-"   ' 기본값

        If IsNumeric(wms_type) And wms_type <> "" Then
            Select Case CInt(wms_type)
                Case 1:  wmsTypeName = "화물"
                Case 2:  wmsTypeName = "낮1배달_신두영(인천,고양)"
                Case 3:  wmsTypeName = "낮2배달_최민성(경기)"
                Case 4:  wmsTypeName = "밤1배달_윤성호(수원,천안,능력)"
                Case 5:  wmsTypeName = "밤2배달_김정호(하남)"
                Case 6:  wmsTypeName = "대구창고"
                Case 7:  wmsTypeName = "대전창고"
                Case 8:  wmsTypeName = "부산창고"
                Case 9:  wmsTypeName = "양산창고"
                Case 10: wmsTypeName = "익산창고"
                Case 11: wmsTypeName = "원주창고"
                Case 12: wmsTypeName = "제주창고"
                Case 13: wmsTypeName = "용차"
                Case 14: wmsTypeName = "방문"
                Case 15: wmsTypeName = "1공장"
                Case 16: wmsTypeName = "인천항"
                Case Else
                    wmsTypeName = "-"
            End Select
        End If

        isSpecial = (Trim(cgset) = "1")

        ' ------------------------------------------------------------
        ' 그룹 헤더 출력
        ' ------------------------------------------------------------
        Dim groupHTML
        groupHTML = "<tr style='background:#d9e8ff;font-weight:bold;'><td colspan='9'>" & wmsTypeName & "</td></tr>"

        If isSpecial Then
            If prev_wms_type_special <> wms_type Then
                specialHTML = specialHTML & groupHTML
                prev_wms_type_special = wms_type
            End If
        Else
            If prev_wms_type_normal <> wms_type Then
                normalHTML = normalHTML & groupHTML
                prev_wms_type_normal = wms_type
            End If
        End If


        ' ------------------------------------------------------------
        ' sjsidx 목록
        ' ------------------------------------------------------------
        SQL1 = "SELECT DISTINCT sjsidx FROM tk_wms_detail WHERE wms_idx=" & wms_idx & " ORDER BY sjsidx ASC"
        Set Rs1 = Dbcon.Execute(SQL1)

        totalSJS = 0
        Do Until Rs1.EOF
            totalSJS = totalSJS + 1
            Rs1.MoveNext
        Loop
        If totalSJS = 0 Then totalSJS = 1
        Rs1.Close
        Rs1.Open SQL1


        rowCounter = 0

        Do Until Rs1.EOF

            cur_sjsidx = Rs1("sjsidx")

            ' ------------------------------------------------------------
            ' dictSjs 에서 품목/재질/비고 가져오기
            ' ------------------------------------------------------------
            framename = "" : qtyname = "" : pname = "" : bigoS = ""
            mwidth = 0 : mheight = 0 : qtyidx = ""

            If dictSjs.Exists(CStr(cur_sjsidx)) Then
                arrS = dictSjs(CStr(cur_sjsidx))
                framename = arrS(0)
                qtyname   = arrS(1)
                pname     = arrS(2)
                bigoS     = arrS(3)
                mw    = arrS(4)
                mh   = arrS(5)
                If UBound(arrS) >= 6 Then
                    qtyidx = arrS(6)
                Else
                    qtyidx = 0
                End If
            End If


            ' ------------------------------------------------------------
            ' 규격 병합 (BuildSizeHTML 함수 사용)
            ' ------------------------------------------------------------
            sizesHTML = BuildSizeHTML(wms_idx, cur_sjsidx)


            ' ------------------------------------------------------------
            ' 도장번호(dictDj)
            ' ------------------------------------------------------------
            djnum = ""
            If dictDj.Exists(CStr(cur_sjsidx)) Then
                djnum = "(" & dictDj(CStr(cur_sjsidx)) & ")"  ' 엑셀에서 텍스트로 강제 처리
            End If

            
            ' ------------------------------------------------------------
            ' 메모 분리
            ' ------------------------------------------------------------
            arrMemo = Split("" & memo, "||")
            memoText = ""
            If rowCounter <= UBound(arrMemo) Then
                memoText = Trim(arrMemo(rowCounter))
            End If


            ' ------------------------------------------------------------
            ' HTML 행 출력
            ' ------------------------------------------------------------
            trHTML = "<tr>"

            If rowCounter = 0 Then

                trHTML = trHTML & "<td rowspan='" & totalSJS & "'>" & cname & "</td>"
                trHTML = trHTML & "<td rowspan='" & totalSJS & "'>" & reg_date & "</td>"

                If djnum <> "" AND qtyidx <> 5 Then
                    trHTML = trHTML & "<td rowspan='" & totalSJS & "'>" & djnum & "</td>"

                Else
                    trHTML = trHTML & "<td rowspan='" & totalSJS & "'></td>"
                End If

                trHTML = trHTML & "<td rowspan='" & totalSJS & "'>" & wmsTypeName & "</td>"
                If wms_type = 1 Then
                    trHTML = trHTML & "<td rowspan='" & totalSJS & "'>" & recv_addr & "</td>"
                Else
                    trHTML = trHTML & "<td rowspan='" & totalSJS & "'>" & recv_addr1 & "</td>"
                End If

            End If

            trHTML = trHTML & "<td>" & framename & " (" & mw & " X " & mh & ")</td>"
            trHTML = trHTML & "<td>" & qtyname & " / " & pname & "</td>"
            trHTML = trHTML & "<td>" & sizesHTML & "</td>"
            trHTML = trHTML & "<td>" & memoText & "</td>"
            trHTML = trHTML & "</tr>"


            If isSpecial Then
                specialHTML = specialHTML & trHTML
            Else
                normalHTML = normalHTML & trHTML
            End If

            rowCounter = rowCounter + 1
            Rs1.MoveNext
        Loop

        Rs.MoveNext
    Loop

End If


' ###################################################################
' 최종 테이블 출력
' ###################################################################
Response.Write "<table border='1' cellspacing='0' cellpadding='6' style='border-collapse:collapse;font-size:12px;'>"
Response.Write "<thead style='background:#eef4ff;font-weight:bold;'>"
Response.Write "<tr>"
Response.Write "<th>거래처명</th>"
Response.Write "<th>수주일자</th>"
Response.Write "<th>도장번호</th>"
Response.Write "<th>출고구분</th>"
Response.Write "<th>도착지(현장)</th>"
Response.Write "<th>품명(검측)</th>"
Response.Write "<th>재질</th>"
Response.Write "<th>규격</th>"
Response.Write "<th>비고</th>"
Response.Write "</tr>"
Response.Write "</thead><tbody>"
Response.Write normalHTML
Response.Write "</tbody></table>"

If excelError Then
    ' 오류 메시지 넣기(엑셀은 HTML도 표시됨)
    Response.Write "<tr><td colspan='9' style='color:red;'>1111"&ErrorLog &"</td></tr>"
End If


call dbClose()
%>


