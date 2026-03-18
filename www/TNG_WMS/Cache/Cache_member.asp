<%
' =================================
' tk_member 캐시
' midx → mname
' =================================

If Not IsObject(dictMember) Then
    Set dictMember = Server.CreateObject("Scripting.Dictionary")

    Dim RsM, sqlM, k, v
    Set RsM = Server.CreateObject("ADODB.Recordset")

    sqlM = "SELECT midx, mname FROM tk_member"
    RsM.Open sqlM, DbCon, 1, 1

    Do Until RsM.EOF
        If Not IsNull(RsM("midx")) Then
            k = CStr(RsM("midx"))   ' ★ Field → 값 복사
            v = RsM("mname")        ' ★ Field → 값 복사

            If Not dictMember.Exists(k) Then
                dictMember.Add k, v
            End If
        End If
        RsM.MoveNext
    Loop

    RsM.Close
    Set RsM = Nothing
End If
%>
