<%
' =========================
' whichi_type 캐시
' =========================
Dim dictWhichi
Set dictWhichi = Server.CreateObject("Scripting.Dictionary")

Dim RsC, sqlC
Set RsC = Server.CreateObject("ADODB.Recordset")

sqlC = ""
sqlC = sqlC & " SELECT "
sqlC = sqlC & "     WHICHI_FIX, WHICHI_FIXName, "
sqlC = sqlC & "     WHICHI_AUTO, WHICHI_AUTOName "
sqlC = sqlC & " FROM tng_whichitype "


RsC.Open sqlC, DbCon, 1, 1

Do Until RsC.EOF

    Dim keyIdx, typeFlag, nameVal

    If Not IsNull(RsC("WHICHI_FIX")) Then
        keyIdx   = CStr(RsC("WHICHI_FIX"))
        typeFlag = "FIX"
        nameVal  = RsC("WHICHI_FIXName")
    ElseIf Not IsNull(RsC("WHICHI_AUTO")) Then
        keyIdx   = CStr(RsC("WHICHI_AUTO"))
        typeFlag = "AUTO"
        nameVal  = RsC("WHICHI_AUTOName")
    End If

    If keyIdx <> "" Then
        If Not dictWhichi.Exists(keyIdx) Then
            dictWhichi.Add keyIdx, Array(typeFlag, nameVal)
        End If
    End If

    RsC.MoveNext
Loop

RsC.Close
Set RsC = Nothing
%>
