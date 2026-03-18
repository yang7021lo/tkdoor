<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 

<%
call dbOpen()

Set Rs  = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")
Set Rs3 = Server.CreateObject("ADODB.Recordset")
Set RsC = Server.CreateObject("ADODB.Recordset")

part        = Request("part")
master_id   = Request("master_id")

item_name   = Request("item_name")
item_type   = Request("item_type")
origin_type = Request("origin_type")
origin_name = Request("origin_name")
status      = Request("status")
memo        = Request("memo")


response.write "item_name=" & item_name & "<br>"
response.write "item_type=" & item_type & "<br>"
response.write "origin_type=" & origin_type & "<br>"
response.write "origin_name=" & origin_name & "<br>"
response.write "status=" & status & "<br>"
response.write "memo=" & memo & "<br>"

' ============================================================
' INSERT
' ============================================================
if part="delete" then 

    SQL="Delete From bom_master Where master_id='"&master_id&"' "
    Response.write (SQL)&"<br>"
    'Response.end
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('bom_master_popup.asp');</script>"

else 
    if master_id="0" then 

        SQL = ""
        SQL = SQL & " INSERT INTO bom_master (item_name, item_type, origin_type,origin_name, status, midx, memo, cdate) "
        SQL = SQL & " VALUES ( "
        SQL = SQL & " '" & item_name & "', "
        SQL = SQL & " '" & item_type & "', "
        SQL = SQL & " '" & origin_type & "', "
        SQL = SQL & " '" & origin_name & "', "
        SQL = SQL & " '" & status & "', "
        SQL = SQL & " '" & c_midx & "', "
        SQL = SQL & " '" & memo & "', "
        SQL = SQL & " getdate() "
        SQL = SQL & " ) "

        response.write "[BOM_MASTER INSERT] " & SQL & "<br>"
        Dbcon.Execute SQL

        SQL=" Select max(master_id) From bom_master "
        Rs1.open Sql,Dbcon
        if not (Rs1.EOF or Rs1.BOF ) then
            new_master_id=Rs1(0)
        end if
        Rs1.Close
        response.write "<script>location.replace('bom_master_popup.asp?master_id="&new_master_id&"');</script>"

    else

        ' ============================================================
        ' UPDATE
        ' ============================================================

        SQL = ""
        SQL = SQL & " UPDATE bom_master SET "
        SQL = SQL & " item_name = '" & item_name & "', "
        SQL = SQL & " item_type = '" & item_type & "', "
        SQL = SQL & " origin_type = '" & origin_type & "', "
        SQL = SQL & " origin_name = '" & origin_name & "', "
        SQL = SQL & " status = '" & status & "', "
        SQL = SQL & " memo = '" & memo & "', "
        SQL = SQL & " meidx = '" & c_midx & "', "
        SQL = SQL & " udate = getdate() "
        SQL = SQL & " WHERE master_id = '" & master_id & "' "

        response.write "[BOM_MASTER UPDATE] <br>" & SQL & "<br>"
        Dbcon.Execute SQL

        response.write "<script>location.replace('bom_master_popup.asp?master_id="&master_id&"');</script>"
    
    end if     

end if      
%>

<%
set RsC = Nothing
set Rs = Nothing
set Rs1 = Nothing
set Rs2 = Nothing
set Rs3 = Nothing
call dbClose()
%>
