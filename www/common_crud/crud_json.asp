<%
' ============================================================
' crud_json.asp - VBScript JSON Parser for CRUD Engine
' 지원 형식: {"insert":[{...},...], "update":[{...},...], "delete":[{...},...]}
' flat 객체만 지원 (중첩 객체/배열 불필요)
' ============================================================

Class CrudJsonParser
  Private src
  Private pos
  Private srcLen

  Public Sub Init(jsonStr)
    src = jsonStr
    pos = 1
    srcLen = Len(src)
  End Sub

  ' 공백 건너뛰기
  Private Sub SkipWS()
    Dim c
    Do While pos <= srcLen
      c = Mid(src, pos, 1)
      If c <> " " And c <> vbTab And c <> vbCr And c <> vbLf Then Exit Do
      pos = pos + 1
    Loop
  End Sub

  ' 현재 문자 확인
  Private Function Peek()
    If pos > srcLen Then Peek = "" Else Peek = Mid(src, pos, 1)
  End Function

  ' 현재 문자 소비
  Private Function Consume()
    If pos > srcLen Then Consume = "" : Exit Function
    Consume = Mid(src, pos, 1)
    pos = pos + 1
  End Function

  ' 문자열 파싱 "..."
  Private Function ParseString()
    Dim result, c
    result = ""
    pos = pos + 1 ' skip opening "
    Do While pos <= srcLen
      c = Mid(src, pos, 1)
      If c = "\" And pos + 1 <= srcLen Then
        Dim nc
        nc = Mid(src, pos + 1, 1)
        If nc = """" Then
          result = result & """"
          pos = pos + 2
        ElseIf nc = "\" Then
          result = result & "\"
          pos = pos + 2
        ElseIf nc = "n" Then
          result = result & vbCrLf
          pos = pos + 2
        ElseIf nc = "t" Then
          result = result & vbTab
          pos = pos + 2
        Else
          result = result & c
          pos = pos + 1
        End If
      ElseIf c = """" Then
        pos = pos + 1 ' skip closing "
        ParseString = result
        Exit Function
      Else
        result = result & c
        pos = pos + 1
      End If
    Loop
    ParseString = result
  End Function

  ' 값 파싱 (문자열, 숫자, null, true, false)
  Private Function ParseValue()
    SkipWS
    Dim c
    c = Peek()
    If c = """" Then
      ParseValue = ParseString()
    ElseIf c = "n" Then
      pos = pos + 4 ' null
      ParseValue = ""
    ElseIf c = "t" Then
      pos = pos + 4 ' true
      ParseValue = "true"
    ElseIf c = "f" Then
      pos = pos + 5 ' false
      ParseValue = "false"
    Else
      ' 숫자
      Dim num
      num = ""
      Do While pos <= srcLen
        c = Mid(src, pos, 1)
        If c = "," Or c = "}" Or c = "]" Or c = " " Or c = vbCr Or c = vbLf Then Exit Do
        num = num & c
        pos = pos + 1
      Loop
      ParseValue = Trim(num)
    End If
  End Function

  ' 객체 파싱 {...} → Dictionary
  Public Function ParseObject()
    Dim dict
    Set dict = Server.CreateObject("Scripting.Dictionary")
    SkipWS
    If Peek() <> "{" Then Set ParseObject = dict : Exit Function
    pos = pos + 1 ' skip {

    SkipWS
    If Peek() = "}" Then pos = pos + 1 : Set ParseObject = dict : Exit Function

    Do
      SkipWS
      ' key
      Dim key
      If Peek() = """" Then
        key = ParseString()
      Else
        Set ParseObject = dict : Exit Function
      End If
      SkipWS
      If Peek() = ":" Then pos = pos + 1 ' skip :
      SkipWS
      ' value
      Dim val
      val = ParseValue()
      If Not dict.Exists(key) Then dict.Add key, val
      SkipWS
      If Peek() = "," Then
        pos = pos + 1
      ElseIf Peek() = "}" Then
        pos = pos + 1
        Exit Do
      Else
        Exit Do
      End If
    Loop

    Set ParseObject = dict
  End Function

  ' 배열 파싱 [{...},{...},...] → Array of Dictionary
  Public Function ParseArray()
    Dim result()
    Dim count
    count = 0
    SkipWS
    If Peek() <> "[" Then ParseArray = Array() : Exit Function
    pos = pos + 1 ' skip [

    SkipWS
    If Peek() = "]" Then pos = pos + 1 : ParseArray = Array() : Exit Function

    Do
      SkipWS
      If Peek() = "{" Then
        ReDim Preserve result(count)
        Set result(count) = ParseObject()
        count = count + 1
      ElseIf Peek() = """" Or IsNumericChar(Peek()) Then
        ' 단순 값 배열 (delete용)
        ReDim Preserve result(count)
        Dim sv
        Set sv = Server.CreateObject("Scripting.Dictionary")
        sv.Add "_val", ParseValue()
        Set result(count) = sv
        count = count + 1
      Else
        ParseValue ' skip unknown
      End If
      SkipWS
      If Peek() = "," Then
        pos = pos + 1
      ElseIf Peek() = "]" Then
        pos = pos + 1
        Exit Do
      Else
        Exit Do
      End If
    Loop

    If count = 0 Then
      ParseArray = Array()
    Else
      ParseArray = result
    End If
  End Function

  Private Function IsNumericChar(c)
    IsNumericChar = (c >= "0" And c <= "9") Or c = "-" Or c = "."
  End Function

  ' 최상위 파싱: {"insert":[...],"update":[...],"delete":[...]}
  ' → Dictionary: key → Array of Dictionary
  Public Function ParseBatch()
    Dim batch
    Set batch = Server.CreateObject("Scripting.Dictionary")
    batch.Add "insert", Array()
    batch.Add "update", Array()
    batch.Add "delete", Array()

    SkipWS
    If Peek() <> "{" Then Set ParseBatch = batch : Exit Function
    pos = pos + 1 ' skip {

    Do
      SkipWS
      If Peek() = "}" Then pos = pos + 1 : Exit Do
      If Peek() = "" Then Exit Do

      Dim bkey
      If Peek() = """" Then
        bkey = ParseString()
      Else
        Exit Do
      End If
      SkipWS
      If Peek() = ":" Then pos = pos + 1
      SkipWS

      If Peek() = "[" Then
        Dim arr
        arr = ParseArray()
        If batch.Exists(bkey) Then batch.Remove bkey
        batch.Add bkey, arr
      Else
        ParseValue ' skip
      End If

      SkipWS
      If Peek() = "," Then pos = pos + 1
    Loop

    Set ParseBatch = batch
  End Function
End Class

' JSON 문자열 이스케이프 (출력용)
Function CrudJsonEscape(s)
  If IsNull(s) Or IsEmpty(s) Then CrudJsonEscape = "" : Exit Function
  s = CStr(s)
  s = Replace(s, "\", "\\")
  s = Replace(s, """", "\""")
  s = Replace(s, vbCrLf, "\n")
  s = Replace(s, vbCr, "\n")
  s = Replace(s, vbLf, "\n")
  s = Replace(s, vbTab, "\t")
  CrudJsonEscape = s
End Function
%>
