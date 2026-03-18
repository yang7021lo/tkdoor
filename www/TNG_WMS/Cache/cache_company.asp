<%
Dim dictCompany
Set dictCompany = Server.CreateObject("Scripting.Dictionary")

Dim RsCompany
Set RsCompany = Server.CreateObject("ADODB.Recordset")

Dim sqlCompany
sqlCompany = ""
sqlCompany = sqlCompany & " SELECT company_idx, company_name "
sqlCompany = sqlCompany & " FROM tk_company "

RsCompany.Open sqlCompany, DbCon

Do Until RsCompany.EOF
    dictCompany.Add _
        CStr(RsCompany("company_idx").Value), _
        CStr(RsCompany("company_name").Value)
    RsCompany.MoveNext
Loop

RsCompany.Close
Set RsCompany = Nothing
%>
