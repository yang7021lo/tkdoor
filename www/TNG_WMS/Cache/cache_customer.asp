<%

' ==========================================
' CUSTOMER SINGLE CACHE
' 특정 cidx만 Dictionary에 담음
'
' dictCustomerOne(cidx)("cname")
' dictCustomerOne(cidx)("cbran")
'
' 사용 전제:
'   - DbCon OPEN 상태
'   - company_idx 또는 cidx 존재
' ==========================================

Dim dictCustomerOne
Set dictCustomerOne = Server.CreateObject("Scripting.Dictionary")

Dim vCompanyIdx
vCompanyIdx = ""

If company_idx <> "" Then
    vCompanyIdx = company_idx
ElseIf cidx <> "" Then
    vCompanyIdx = cidx
End If

If vCompanyIdx <> "" Then

    Dim RsC, sqlC
    Set RsC = Server.CreateObject("ADODB.Recordset")

    sqlC = ""
    sqlC = sqlC & " SELECT cidx, cname, cbran "
    sqlC = sqlC & " FROM tk_customer "
    sqlC = sqlC & " WHERE cidx = " & CLng(vCompanyIdx)

    RsC.Open sqlC, DbCon, 1, 1

    If Not RsC.EOF Then
        
        Dim dictItem
        Set dictItem = Server.CreateObject("Scripting.Dictionary")

        dictItem("cname") = RsC("cname")
        dictItem("cbran") = RsC("cbran")

        dictCustomerOne(CStr(RsC("cidx"))) = dictItem

    End If

    RsC.Close
    Set RsC = Nothing

End If

%>
