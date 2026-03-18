<%@ codepage="65001" language="vbscript"%>
<%
Response.ContentType = "application/json"
Response.CharSet = "utf-8"
Session.CodePage = "65001"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
' ============================================================
' unittype_api.asp - 단가 매트릭스 JSON API
' 용도: unittype_new.asp, unittypeA_new.asp 에서 AJAX 호출
' ============================================================

call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

action = Request("action")
sjb_idx = Request("SJB_IDX")
frame_type = Request("frame_type") ' "manual" or "auto"

' 숫자 검증
If sjb_idx = "" Or Not IsNumeric(sjb_idx) Then sjb_idx = "0"
sjb_idx = CLng(sjb_idx)

Select Case action

    ' ============================================================
    ' 1. 단가 데이터 조회 (매트릭스 전체)
    ' ============================================================
    Case "get_prices"
        
        ' 단일 쿼리로 해당 SJB_IDX의 모든 단가 조회
        sql = "SELECT uptidx, unittype_bfwidx, unittype_qtyco_idx, price " & _
              "FROM tng_unitprice_t " & _
              "WHERE SJB_IDX = " & sjb_idx & " " & _
              "AND upstatus = 1 " & _
              "ORDER BY unittype_bfwidx, unittype_qtyco_idx"
        
        Rs.Open sql, Dbcon, 1, 1
        
        json = "["
        isFirst = True
        
        If Not (Rs.EOF Or Rs.BOF) Then
            Do While Not Rs.EOF
                If Not isFirst Then json = json & ","
                isFirst = False
                
                json = json & "{"
                json = json & """uptidx"":" & Rs("uptidx") & ","
                json = json & """bfwidx"":" & Rs("unittype_bfwidx") & ","
                json = json & """qtyco_idx"":" & Rs("unittype_qtyco_idx") & ","
                json = json & """price"":" & IIf(IsNull(Rs("price")), "0", Rs("price"))
                json = json & "}"
                
                Rs.MoveNext
            Loop
        End If
        Rs.Close
        
        json = json & "]"
        Response.Write json

    ' ============================================================
    ' 2. 바 종류 목록 조회
    ' ============================================================
    Case "get_bfwidx_list"
        
        If frame_type = "manual" Then
            ' 수동: 1,2,3만
            sql = "SELECT DISTINCT unittype_bfwidx FROM tng_whichitype " & _
                  "WHERE bfwstatus = 1 " & _
                  "AND unittype_bfwidx IN (1, 2, 3) " & _
                  "ORDER BY unittype_bfwidx ASC"
        Else
            ' 자동: WHICHI_AUTO 있는 것
            sql = "SELECT DISTINCT unittype_bfwidx FROM tng_whichitype " & _
                  "WHERE bfwstatus = 1 " & _
                  "AND WHICHI_auto IS NOT NULL " & _
                  "AND WHICHI_auto <> 0 " & _
                  "AND WHICHI_auto <> '' " & _
                  "ORDER BY unittype_bfwidx ASC"
        End If
        
        Rs.Open sql, Dbcon, 1, 1
        
        json = "["
        isFirst = True
        
        If Not (Rs.EOF Or Rs.BOF) Then
            Do While Not Rs.EOF
                If Not isFirst Then json = json & ","
                isFirst = False
                
                bfwidx = Rs(0)
                bfwidx_text = GetBfwidxText(bfwidx, frame_type)
                
                json = json & "{"
                json = json & """id"":" & bfwidx & ","
                json = json & """name"":""" & bfwidx_text & """"
                json = json & "}"
                
                Rs.MoveNext
            Loop
        End If
        Rs.Close
        
        json = json & "]"
        Response.Write json

    ' ============================================================
    ' 3. 재질 종류 목록 조회
    ' ============================================================
    Case "get_qtyco_list"
        
        sql = "SELECT DISTINCT unittype_qtyco_idx FROM tk_qtyco " & _
              "WHERE unittype_qtyco_idx <> '' " & _
              "ORDER BY unittype_qtyco_idx ASC"
        
        Rs.Open sql, Dbcon, 1, 1
        
        json = "["
        isFirst = True
        
        If Not (Rs.EOF Or Rs.BOF) Then
            Do While Not Rs.EOF
                If Not isFirst Then json = json & ","
                isFirst = False
                
                qtyco_idx = Rs(0)
                qtyco_text = GetQtycoText(qtyco_idx)
                
                json = json & "{"
                json = json & """id"":" & qtyco_idx & ","
                json = json & """name"":""" & qtyco_text & """"
                json = json & "}"
                
                Rs.MoveNext
            Loop
        End If
        Rs.Close
        
        json = json & "]"
        Response.Write json

    ' ============================================================
    ' 4. 단가 저장 (INSERT or UPDATE)
    ' ============================================================
    Case "save_price"
        
        uptidx = Request("uptidx")
        bfwidx = Request("bfwidx")
        qtyco_idx = Request("qtyco_idx")
        price = Request("price")
        
        ' 숫자 검증
        If uptidx = "" Or Not IsNumeric(uptidx) Then uptidx = "0"
        If bfwidx = "" Or Not IsNumeric(bfwidx) Then bfwidx = "0"
        If qtyco_idx = "" Or Not IsNumeric(qtyco_idx) Then qtyco_idx = "0"
        If price = "" Or Not IsNumeric(price) Then price = "0"
        
        uptidx = CLng(uptidx)
        bfwidx = CLng(bfwidx)
        qtyco_idx = CLng(qtyco_idx)
        price = CDbl(price)
        
        On Error Resume Next
        
        If uptidx > 0 Then
            ' UPDATE
            sql = "UPDATE tng_unitprice_t SET " & _
                  "price = " & price & " " & _
                  "WHERE uptidx = " & uptidx
            Dbcon.Execute sql
            
            If Err.Number = 0 Then
                Response.Write "{""success"":true,""action"":""update"",""uptidx"":" & uptidx & "}"
            Else
                Response.Write "{""success"":false,""error"":""" & Replace(Err.Description, """", "'") & """}"
            End If
        Else
            ' INSERT
            sql = "INSERT INTO tng_unitprice_t " & _
                  "(SJB_IDX, unittype_bfwidx, unittype_qtyco_idx, price, upstatus) " & _
                  "VALUES (" & sjb_idx & ", " & bfwidx & ", " & qtyco_idx & ", " & price & ", 1)"
            Dbcon.Execute sql
            
            If Err.Number = 0 Then
                ' 새로 생성된 uptidx 조회
                sql = "SELECT MAX(uptidx) FROM tng_unitprice_t WHERE SJB_IDX = " & sjb_idx
                Rs.Open sql, Dbcon, 1, 1
                newUptidx = Rs(0)
                Rs.Close
                Response.Write "{""success"":true,""action"":""insert"",""uptidx"":" & newUptidx & "}"
            Else
                Response.Write "{""success"":false,""error"":""" & Replace(Err.Description, """", "'") & """}"
            End If
        End If
        
        On Error GoTo 0

    ' ============================================================
    ' 5. 자동 연동 저장 (unittypedbA 로직)
    ' ============================================================
    Case "save_price_auto"
        
        uptidx = Request("uptidx")
        bfwidx = Request("bfwidx")
        qtyco_idx = Request("qtyco_idx")
        price = Request("price")
        
        ' 숫자 검증
        If uptidx = "" Or Not IsNumeric(uptidx) Then uptidx = "0"
        If bfwidx = "" Or Not IsNumeric(bfwidx) Then bfwidx = "0"
        If qtyco_idx = "" Or Not IsNumeric(qtyco_idx) Then qtyco_idx = "0"
        If price = "" Or Not IsNumeric(price) Then price = "0"
        
        uptidx = CLng(uptidx)
        bfwidx = CLng(bfwidx)
        qtyco_idx = CLng(qtyco_idx)
        price = CDbl(price)
        
        On Error Resume Next
        
        ' 기본 저장
        If uptidx > 0 Then
            sql = "UPDATE tng_unitprice_t SET price = " & price & " WHERE uptidx = " & uptidx
        Else
            sql = "INSERT INTO tng_unitprice_t (SJB_IDX, unittype_bfwidx, unittype_qtyco_idx, price, upstatus) " & _
                  "VALUES (" & sjb_idx & ", " & bfwidx & ", " & qtyco_idx & ", " & price & ", 1)"
        End If
        Dbcon.Execute sql
        
        ' === 자동 연동 로직 ===
        
        ' 갈바(3) → 지급판(8) = 80%
        If qtyco_idx = 3 Then
            Call SaveOrUpdatePrice(sjb_idx, bfwidx, 8, price * 0.8)
        End If
        
        ' 블랙H/L(4) → 바이브(6), 헤어1.5(11) 동일가
        If qtyco_idx = 4 Then
            Call SaveOrUpdatePrice(sjb_idx, bfwidx, 6, price)
            Call SaveOrUpdatePrice(sjb_idx, bfwidx, 11, price)
        End If
        
        ' 중간소대(4) → 픽스하바(6) 연동
        If bfwidx = 4 Then
            Call SaveOrUpdatePrice(sjb_idx, 6, qtyco_idx, price)
        End If
        
        ' 가로남마(3) → 자동&픽스바(5) 연동
        If bfwidx = 3 Then
            Call SaveOrUpdatePrice(sjb_idx, 5, qtyco_idx, price)
        End If
        
        If Err.Number = 0 Then
            Response.Write "{""success"":true}"
        Else
            Response.Write "{""success"":false,""error"":""" & Replace(Err.Description, """", "'") & """}"
        End If

        On Error GoTo 0

    ' ============================================================
    ' 6. 행 삭제 (바 종류별 모든 단가 삭제)
    ' ============================================================
    Case "delete_row"

        bfwidx = Request("bfwidx")

        ' 숫자 검증
        If bfwidx = "" Or Not IsNumeric(bfwidx) Then bfwidx = "0"
        bfwidx = CLng(bfwidx)

        On Error Resume Next

        ' 해당 바 종류의 모든 단가 삭제 (soft delete: upstatus = 0)
        sql = "UPDATE tng_unitprice_t SET upstatus = 0 " & _
              "WHERE SJB_IDX = " & sjb_idx & " " & _
              "AND unittype_bfwidx = " & bfwidx
        Dbcon.Execute sql

        If Err.Number = 0 Then
            Response.Write "{""success"":true,""action"":""delete""}"
        Else
            Response.Write "{""success"":false,""error"":""" & Replace(Err.Description, """", "'") & """}"
        End If

        On Error GoTo 0

    Case Else
        Response.Write "{""success"":false,""error"":""Unknown action""}"
        
End Select

Set Rs = Nothing
call dbClose()

' ============================================================
' Helper Functions
' ============================================================

Function IIf(condition, trueValue, falseValue)
    If condition Then
        IIf = trueValue
    Else
        IIf = falseValue
    End If
End Function

Function GetBfwidxText(idx, frameType)
    If frameType = "manual" Then
        Select Case CInt(idx)
            Case 1: GetBfwidxText = "45바"
            Case 2: GetBfwidxText = "60~100바"
            Case 3: GetBfwidxText = "코너바"
            Case Else: GetBfwidxText = "(없음)"
        End Select
    Else
        Select Case CInt(idx)
            Case 1: GetBfwidxText = "기계박스"
            Case 2: GetBfwidxText = "박스커버"
            Case 3: GetBfwidxText = "가로남마"
            Case 4: GetBfwidxText = "중간소대"
            Case 5: GetBfwidxText = "자동&픽스바"
            Case 6: GetBfwidxText = "픽스하바"
            Case 7: GetBfwidxText = "픽스상바"
            Case 8: GetBfwidxText = "코너바"
            Case 9: GetBfwidxText = "하부레일"
            Case 10: GetBfwidxText = "T형_자동홈바"
            Case 11: GetBfwidxText = "오사이"
            Case 12: GetBfwidxText = "자동홈마개"
            Case 13: GetBfwidxText = "민자홈마개"
            Case 14: GetBfwidxText = "이중_뚜껑마감"
            Case 15: GetBfwidxText = "마구리"
            Case Else: GetBfwidxText = "(없음)"
        End Select
    End If
End Function

Function GetQtycoText(idx)
    Select Case CInt(idx)
        Case 0: GetQtycoText = "❌"
        Case 1: GetQtycoText = "H/L"
        Case 2: GetQtycoText = "P/L"
        Case 3: GetQtycoText = "갈바"
        Case 4: GetQtycoText = "블랙H/L"
        Case 5: GetQtycoText = "블랙,골드"
        Case 6: GetQtycoText = "바이브_등"
        Case 7: GetQtycoText = "브론즈_등"
        Case 8: GetQtycoText = "지급판"
        Case 9: GetQtycoText = "AL/도장"
        Case 10: GetQtycoText = "AL/블랙"
        Case 11: GetQtycoText = "헤어1.5"
        Case Else: GetQtycoText = "(없음)"
    End Select
End Function

Sub SaveOrUpdatePrice(sjbIdx, bfwIdx, qtycoIdx, priceVal)
    Dim chkRs, chkSql
    Set chkRs = Server.CreateObject("ADODB.Recordset")
    
    chkSql = "SELECT uptidx FROM tng_unitprice_t " & _
             "WHERE SJB_IDX = " & sjbIdx & " " & _
             "AND unittype_bfwidx = " & bfwIdx & " " & _
             "AND unittype_qtyco_idx = " & qtycoIdx
    
    chkRs.Open chkSql, Dbcon, 1, 1
    
    If chkRs.EOF Then
        ' INSERT
        Dbcon.Execute "INSERT INTO tng_unitprice_t (SJB_IDX, unittype_bfwidx, unittype_qtyco_idx, price, upstatus) " & _
                      "VALUES (" & sjbIdx & ", " & bfwIdx & ", " & qtycoIdx & ", " & priceVal & ", 1)"
    Else
        ' UPDATE
        Dbcon.Execute "UPDATE tng_unitprice_t SET price = " & priceVal & " WHERE uptidx = " & chkRs("uptidx")
    End If
    
    chkRs.Close
    Set chkRs = Nothing
End Sub
%>
