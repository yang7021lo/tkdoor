<%
' ============================================================
' crud_api.asp - Generic CRUD API Engine
' 사용법: 각 테이블 api.asp에서 CFG_ 변수 설정 후 include
'
' 필요 변수 (호출 전 설정):
'   CFG_TABLE      : 테이블명
'   CFG_PK         : PK 컬럼명
'   CFG_PK_AUTO    : True = MAX+1 자동생성
'   CFG_COLS       : Dictionary (컬럼명 → 타입: str/int/float)
'   CFG_SELECT     : SELECT 절 (컬럼목록)
'   CFG_FROM       : FROM 절
'   CFG_ORDERBY    : 기본 ORDER BY
'   CFG_WHERE      : 추가 WHERE 조건 (선택)
'   CFG_OUTPUT_COLS: Array (JSON 출력 컬럼명 순서)
'   CFG_AUDIT_CREATE: "midx컬럼,date컬럼" (선택)
'   CFG_AUDIT_UPDATE: "midx컬럼,date컬럼" (선택)
'   CFG_AUTO_INCREMENT: "컬럼명" (선택, INSERT시 비어있으면 MAX+1)
' ============================================================

' 기본값 (설정 안 된 경우 에러 방지)
If IsEmpty(CFG_AUTO_INCREMENT) Then CFG_AUTO_INCREMENT = ""

Dim CRUD_ACTION
CRUD_ACTION = LCase(Trim(Request("action")))

' === 값 이스케이프 ===
Function SafeValue(val, dataType)
  If IsNull(val) Or IsEmpty(val) Then val = ""
  val = CStr(val)
  Select Case LCase(dataType)
    Case "str"
      SafeValue = "N'" & Replace(Replace(val, "'", "''"), Chr(0), "") & "'"
    Case "int"
      If val = "" Or Not IsNumeric(val) Then
        SafeValue = "NULL"
      Else
        SafeValue = CStr(CLng(val))
      End If
    Case "float"
      If val = "" Or Not IsNumeric(val) Then
        SafeValue = "NULL"
      Else
        SafeValue = CStr(CDbl(val))
      End If
    Case Else
      SafeValue = "NULL"
  End Select
End Function

' === 정렬 컬럼 검증 ===
Function ValidateSortCol(col)
  If col = "" Then ValidateSortCol = CFG_PK : Exit Function
  If CFG_COLS.Exists(col) Or LCase(col) = LCase(CFG_PK) Then
    ValidateSortCol = "[" & col & "]"
  Else
    ValidateSortCol = "[" & CFG_PK & "]"
  End If
End Function

' ============================================================
' ACTION: list
' ============================================================
If CRUD_ACTION = "list" Then

  Dim pg, pgSize, sortCol, sortDir, searchText
  pg = Request("page")
  pgSize = Request("size")
  sortCol = Request("sort")
  sortDir = UCase(Trim(Request("dir") & ""))
  searchText = Trim(Request("search") & "")

  If pg = "" Or Not IsNumeric(pg) Then pg = 1 Else pg = CLng(pg)
  If pgSize = "" Or Not IsNumeric(pgSize) Then pgSize = 50 Else pgSize = CLng(pgSize)
  If pgSize > 500 Then pgSize = 500
  If pg < 1 Then pg = 1
  If sortDir <> "ASC" And sortDir <> "DESC" Then sortDir = "DESC"

  sortCol = ValidateSortCol(sortCol)

  ' WHERE 조건 빌드
  Dim whereClause
  whereClause = " WHERE 1=1 "
  If CFG_WHERE <> "" Then whereClause = whereClause & " AND " & CFG_WHERE

  ' 검색 (CFG_COLS의 str 컬럼 대상 OR 검색)
  If searchText <> "" Then
    Dim searchSafe, searchParts, sk
    searchSafe = Replace(Replace(searchText, "'", "''"), "%", "[%]")
    searchParts = ""
    For Each sk In CFG_COLS.Keys
      If LCase(CFG_COLS(sk)) = "str" Then
        If searchParts <> "" Then searchParts = searchParts & " OR "
        searchParts = searchParts & "[" & sk & "] LIKE N'%" & searchSafe & "%'"
      End If
    Next
    If searchParts <> "" Then
      whereClause = whereClause & " AND (" & searchParts & ")"
    End If
  End If

  ' 총 건수
  Dim sqlCount, rsCount, totalRows
  sqlCount = "SELECT COUNT(*) FROM " & CFG_FROM & whereClause
  On Error Resume Next
  Set rsCount = Dbcon.Execute(sqlCount)
  If Err.Number <> 0 Then
    Response.Write "{""error"":true,""msg"":""" & CrudJsonEscape(Err.Description) & """}"
    Err.Clear
    Response.End
  End If
  totalRows = CLng(rsCount(0))
  rsCount.Close
  Set rsCount = Nothing

  ' 데이터 조회 (ROW_NUMBER 방식)
  Dim sqlData, rsData, startRow, endRow
  startRow = (pg - 1) * pgSize + 1
  endRow = pg * pgSize

  sqlData = "SELECT * FROM (" & _
    "SELECT ROW_NUMBER() OVER (ORDER BY " & sortCol & " " & sortDir & ") AS _rn, " & _
    CFG_SELECT & " FROM " & CFG_FROM & whereClause & _
    ") AS T WHERE T._rn BETWEEN " & startRow & " AND " & endRow & " ORDER BY T._rn"

  Set rsData = Dbcon.Execute(sqlData)
  If Err.Number <> 0 Then
    Response.Write "{""error"":true,""msg"":""" & CrudJsonEscape(Err.Description) & """}"
    Err.Clear
    Response.End
  End If
  On Error GoTo 0

  ' JSON 응답
  Response.Write "{""data"":["
  Dim firstRow, ci
  firstRow = True
  Do While Not rsData.EOF
    If Not firstRow Then Response.Write ","
    firstRow = False
    Response.Write "{"
    For ci = 0 To UBound(CFG_OUTPUT_COLS)
      If ci > 0 Then Response.Write ","
      Dim colName, colVal
      colName = CFG_OUTPUT_COLS(ci)
      colVal = rsData(colName)
      If IsNull(colVal) Then colVal = ""
      Response.Write """" & colName & """:""" & CrudJsonEscape(CStr(colVal)) & """"
    Next
    Response.Write "}"
    rsData.MoveNext
  Loop
  Response.Write "],"
  Response.Write """totalRows"":" & totalRows & ","
  Response.Write """page"":" & pg & ","
  Response.Write """pageSize"":" & pgSize
  Response.Write "}"

  rsData.Close
  Set rsData = Nothing
  Response.End
End If

' ============================================================
' ACTION: batch
' ============================================================
If CRUD_ACTION = "batch" Then

  Dim bodyStr
  If Request.TotalBytes > 0 Then
    Dim stm
    Set stm = Server.CreateObject("ADODB.Stream")
    stm.Type = 1
    stm.Open
    stm.Write Request.BinaryRead(Request.TotalBytes)
    stm.Position = 0
    stm.Type = 2
    stm.Charset = "utf-8"
    bodyStr = stm.ReadText
    stm.Close
    Set stm = Nothing
  Else
    bodyStr = ""
  End If

  ' JSON 파싱
  Dim parser, batch
  Set parser = New CrudJsonParser
  parser.Init bodyStr
  Set batch = parser.ParseBatch()

  Dim arrInsert, arrUpdate, arrDelete
  arrInsert = batch("insert")
  arrUpdate = batch("update")
  arrDelete = batch("delete")

  Dim insertCount, updateCount, deleteCount, errOccurred, errMsg
  insertCount = 0
  updateCount = 0
  deleteCount = 0
  errOccurred = False
  errMsg = ""

  On Error Resume Next
  Dbcon.Execute "BEGIN TRANSACTION"
  If Err.Number <> 0 Then
    Response.Write "{""result"":""fail"",""msg"":""" & CrudJsonEscape(Err.Description) & """}"
    Err.Clear
    Response.End
  End If

  ' --- DELETE ---
  Dim di
  If IsArray(arrDelete) Then
    For di = 0 To UBound(arrDelete)
      If Not errOccurred Then
        Dim delDict, delPK
        Set delDict = arrDelete(di)
        If delDict.Exists(CFG_PK) Then
          delPK = delDict(CFG_PK)
        ElseIf delDict.Exists("_val") Then
          delPK = delDict("_val")
        Else
          delPK = ""
        End If
        If delPK <> "" And IsNumeric(delPK) Then
          Dbcon.Execute "DELETE FROM " & CFG_TABLE & " WHERE [" & CFG_PK & "]=" & CLng(delPK)
          If Err.Number <> 0 Then errOccurred = True : errMsg = "DELETE 오류: " & Err.Description : Err.Clear
          deleteCount = deleteCount + 1
        End If
      End If
    Next
  End If

  ' --- UPDATE ---
  Dim ui
  If IsArray(arrUpdate) And Not errOccurred Then
    For ui = 0 To UBound(arrUpdate)
      If Not errOccurred Then
        Dim updDict, updSQL, updFirst, updKey, updPKVal
        Set updDict = arrUpdate(ui)
        If updDict.Exists(CFG_PK) Then
          updPKVal = updDict(CFG_PK)
          If updPKVal <> "" And IsNumeric(updPKVal) Then
            updSQL = "UPDATE " & CFG_TABLE & " SET "
            updFirst = True
            For Each updKey In CFG_COLS.Keys
              If updDict.Exists(updKey) Then
                If Not updFirst Then updSQL = updSQL & ", "
                updSQL = updSQL & "[" & updKey & "]=" & SafeValue(updDict(updKey), CFG_COLS(updKey))
                updFirst = False
              End If
            Next
            ' 감사 컬럼
            If CFG_AUDIT_UPDATE <> "" Then
              Dim auParts
              auParts = Split(CFG_AUDIT_UPDATE, ",")
              If UBound(auParts) >= 1 Then
                If Not updFirst Then updSQL = updSQL & ", "
                updSQL = updSQL & "[" & Trim(auParts(0)) & "]='" & C_midx & "'"
                updSQL = updSQL & ", [" & Trim(auParts(1)) & "]=GETDATE()"
              End If
            End If
            updSQL = updSQL & " WHERE [" & CFG_PK & "]=" & CLng(updPKVal)

            If Not updFirst Then
              Dbcon.Execute updSQL
              If Err.Number <> 0 Then errOccurred = True : errMsg = "UPDATE 오류(PK=" & updPKVal & "): " & Err.Description : Err.Clear
              updateCount = updateCount + 1
            End If
          End If
        End If
      End If
    Next
  End If

  ' --- INSERT ---
  Dim ii
  If IsArray(arrInsert) And Not errOccurred Then
    For ii = 0 To UBound(arrInsert)
      If Not errOccurred Then
        Dim insDict, insCols, insVals, insKey, newPK
        Set insDict = arrInsert(ii)

        ' PK 자동생성
        If CFG_PK_AUTO Then
          Dim rsPK
          Set rsPK = Dbcon.Execute("SELECT ISNULL(MAX([" & CFG_PK & "]),0)+1 FROM " & CFG_TABLE)
          If Err.Number <> 0 Then errOccurred = True : errMsg = "PK생성 오류: " & Err.Description : Err.Clear
          If Not errOccurred Then
            newPK = rsPK(0)
            rsPK.Close
            Set rsPK = Nothing
          End If
        Else
          If insDict.Exists(CFG_PK) Then newPK = insDict(CFG_PK)
        End If

        If Not errOccurred Then
          insCols = "[" & CFG_PK & "]"
          insVals = CStr(CLng(newPK))

          ' 자동 채번 컬럼 (CFG_AUTO_INCREMENT)
          If CFG_AUTO_INCREMENT <> "" Then
            Dim autoVal, hasAutoVal
            hasAutoVal = False
            If insDict.Exists(CFG_AUTO_INCREMENT) Then
              If Trim(insDict(CFG_AUTO_INCREMENT) & "") <> "" Then hasAutoVal = True
            End If
            If Not hasAutoVal Then
              Dim rsAuto
              Set rsAuto = Dbcon.Execute("SELECT ISNULL(MAX(CAST([" & CFG_AUTO_INCREMENT & "] AS INT)),0)+1 FROM " & CFG_TABLE)
              If Err.Number <> 0 Then errOccurred = True : errMsg = "자동채번 오류: " & Err.Description : Err.Clear
              If Not errOccurred Then
                autoVal = rsAuto(0)
                rsAuto.Close
                Set rsAuto = Nothing
                insDict.Item(CFG_AUTO_INCREMENT) = CStr(CLng(autoVal))
              End If
            End If
          End If

          For Each insKey In CFG_COLS.Keys
            If insDict.Exists(insKey) Then
              insCols = insCols & ", [" & insKey & "]"
              insVals = insVals & ", " & SafeValue(insDict(insKey), CFG_COLS(insKey))
            End If
          Next

          ' 감사 컬럼 (생성)
          If CFG_AUDIT_CREATE <> "" Then
            Dim acParts
            acParts = Split(CFG_AUDIT_CREATE, ",")
            If UBound(acParts) >= 1 Then
              insCols = insCols & ", [" & Trim(acParts(0)) & "], [" & Trim(acParts(1)) & "]"
              insVals = insVals & ", '" & C_midx & "', GETDATE()"
            End If
          End If
          ' 감사 컬럼 (수정)
          If CFG_AUDIT_UPDATE <> "" Then
            Dim auiParts
            auiParts = Split(CFG_AUDIT_UPDATE, ",")
            If UBound(auiParts) >= 1 Then
              insCols = insCols & ", [" & Trim(auiParts(0)) & "], [" & Trim(auiParts(1)) & "]"
              insVals = insVals & ", '" & C_midx & "', GETDATE()"
            End If
          End If

          Dim insSQL
          insSQL = "INSERT INTO " & CFG_TABLE & " (" & insCols & ") VALUES (" & insVals & ")"
          Dbcon.Execute insSQL
          If Err.Number <> 0 Then errOccurred = True : errMsg = "INSERT 오류: " & Err.Description : Err.Clear
          insertCount = insertCount + 1
        End If
      End If
    Next
  End If

  ' --- COMMIT / ROLLBACK ---
  If errOccurred Then
    Dbcon.Execute "ROLLBACK"
    If Err.Number <> 0 Then Err.Clear
    Response.Write "{""result"":""fail"",""msg"":""" & CrudJsonEscape(errMsg) & """}"
  Else
    Dbcon.Execute "COMMIT"
    If Err.Number <> 0 Then
      Response.Write "{""result"":""fail"",""msg"":""COMMIT 오류: " & CrudJsonEscape(Err.Description) & """}"
      Err.Clear
    Else
      Response.Write "{""result"":""ok"",""inserted"":" & insertCount & ",""updated"":" & updateCount & ",""deleted"":" & deleteCount & "}"
    End If
  End If
  On Error GoTo 0
  Response.End
End If

' === action 없으면 에러 ===
Response.Write "{""error"":true,""msg"":""action parameter required (list|batch)""}"
Response.End
%>
