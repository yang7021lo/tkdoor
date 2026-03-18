<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
call dbOpen()

Set Rs  = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")
Set Rs3 = Server.CreateObject("ADODB.Recordset")
Set RsC = Server.CreateObject("ADODB.Recordset")

part           = Request("part")
gotopage = Request("gotopage")
aluminum_id    = Request("aluminum_id")

master_id      = Request("master_id")
mold_no        = Request("mold_no")
width_mm       = Request("width_mm")
height_mm      = Request("height_mm")
density        = Request("density")
unit_type      = Request("unit_type")
status         = Request("status")
memo           = Request("memo")
mold_id        = Request("mold_id")

'===================================================
response.write "[DEBUG] part=" & part & "<br>"
response.write "[DEBUG] mold_no=" & mold_no & "<br>"
response.write "[DEBUG] width_mm=" & width_mm & "<br>"
response.write "[DEBUG] height_mm=" & height_mm & "<br>"
response.write "[DEBUG] density=" & density & "<br>"
response.write "[DEBUG] unit_type=" & unit_type & "<br>"
response.write "[DEBUG] memo=" & memo & "<br>"
response.write "[DEBUG] mold_id=" & mold_id & "<br>"

'===================================================
'mold_id 없으면 자동인서트 
If mold_id = "" Then

    SQL = ""
    SQL = SQL & "INSERT INTO bom_mold (mold_no, midx, cdate) VALUES ("
    SQL = SQL & "'" & mold_no & "', "
    SQL = SQL & "'" & c_midx & "', "
    SQL = SQL & "getdate() "
    SQL = SQL & ")"
    response.write "<br>[bom_mold INSERT] " & SQL & "<br>"
    Dbcon.Execute SQL

        SQL = "SELECT SCOPE_IDENTITY() AS mold_id"
        Response.Write "<br>"& (SQL) & "<br>"
        Rs1.Open SQL, Dbcon
        If Not (Rs1.BOF Or Rs1.EOF) Then
        
            mold_id = Rs1(0)
       
        End if
        Rs1.close

    'response.write "<script>location.replace('bom_aluminum_popup.asp?gotopage=" & gotopage & "&mold_id="&mold_id&"&SearchWord="&rSearchWord&"#"&mold_id&"');</script>"


End If
'===================================================

'Response.End
' If mold_no = "" Then
'     Response.Write "<script>alert('금형번호를 입력해주세요.'); history.back();</script>"
'     Response.End
' End If
'===================================================
' DELETE
'===================================================
If part="delete" Then

    SQL="DELETE FROM bom_aluminum WHERE aluminum_id='"&aluminum_id&"'"
    Response.Write SQL & "<br>"
    Dbcon.Execute SQL

    response.write "<script>location.replace('bom_aluminum_popup.asp');</script>"
    response.end

    response.write "<script>location.replace('bom_aluminum_popup.asp?gotopage=" & gotopage & "&mold_id="&mold_id&"&SearchWord="&rSearchWord&"#"&mold_id&"');</script>"

else 


'===================================================
' INSERT
'===================================================
If aluminum_id="0" Or aluminum_id="" Then

    SQL = ""
    SQL = SQL & " INSERT INTO bom_aluminum (master_id, mold_no, width_mm, height_mm, density, unit_type, status, midx, memo, cdate, mold_id) "
    SQL = SQL & " VALUES ( "
    SQL = SQL & " '" & master_id & "', "
    SQL = SQL & " '" & mold_no & "', "
    SQL = SQL & " '" & width_mm & "', "
    SQL = SQL & " '" & height_mm & "', "
    SQL = SQL & " '" & density & "', "
    SQL = SQL & " '" & unit_type & "', "
    SQL = SQL & " '" & status & "', "
    SQL = SQL & " '" & c_midx & "', "
    SQL = SQL & " '" & memo & "', "
    SQL = SQL & " getdate(), "
    SQL = SQL & " '" & mold_id & "' "
    SQL = SQL & " ) "

    response.write "[INSERT] " & SQL & "<br>"
    Dbcon.Execute SQL

    SQL = "SELECT SCOPE_IDENTITY() AS aluminum_id"
    response.write "[aluminum_id SCOPE_IDENTITY] " & SQL & "<br>"
    Rs1.Open SQL, Dbcon
    If Not(Rs1.BOF Or Rs1.EOF) Then
        new_id = Rs1("aluminum_id")
    End If
    Rs1.Close

    response.write "<script>location.replace('bom_aluminum_popup.asp?gotopage=" & gotopage & "&aluminum_id="&new_id&"&SearchWord="&rSearchWord&"#"&new_id&"');</script>"

    response.end

else


    '===================================================
    ' UPDATE
    '===================================================

    SQL = ""
    SQL = SQL & " UPDATE bom_aluminum SET "
    SQL = SQL & " master_id = '" & master_id & "', "
    SQL = SQL & " mold_no = '" & mold_no & "', "
    SQL = SQL & " width_mm = '" & width_mm & "', "
    SQL = SQL & " height_mm = '" & height_mm & "', "
    SQL = SQL & " density = '" & density & "', "
    SQL = SQL & " unit_type = '" & unit_type & "', "
    SQL = SQL & " status = '" & status & "', "
    SQL = SQL & " memo = '" & memo & "', "
    SQL = SQL & " mold_id = '" & mold_id & "', "
    SQL = SQL & " meidx = '" & c_midx & "', "
    SQL = SQL & " udate = getdate() "
    SQL = SQL & " WHERE aluminum_id='" & aluminum_id & "' "

    response.write "[UPDATE] " & SQL & "<br>"
    Dbcon.Execute SQL

    response.write "<script>location.replace('bom_aluminum_popup.asp?gotopage=" & gotopage & "&aluminum_id="&aluminum_id&"&SearchWord="&rSearchWord&"#"&aluminum_id&"');</script>"

    end if     

end if  
%>

<%
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
set RsC=Nothing
call dbClose()
%>
