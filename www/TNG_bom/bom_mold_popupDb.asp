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

part      = Request("part")
gotopage = Request("gotopage")
mold_id   = Request("mold_id")

mold_no    = Request("mold_no")
mold_name  = Request("mold_name")
vendor_id  = Request("vendor_id")
location_mold   = Request("location_mold")
cad_path   = Request("cad_path")
img_path   = Request("img_path")
status     = Request("status")
memo       = Request("memo")

response.write "mold_no=" & mold_no & "<br>"
response.write "mold_name=" & mold_name & "<br>"
response.write "vendor_id=" & vendor_id & "<br>"
response.write "location_mold=" & location_mold & "<br>"
response.write "cad_path=" & cad_path & "<br>"
response.write "img_path=" & img_path & "<br>"
response.write "status=" & status & "<br>"
response.write "memo=" & memo & "<br>"

' ============================================================
' DELETE
' ============================================================
if part="delete" then 

    ' 1) 참조 여부 체크
    SQL = ""
    SQL = SQL & "SELECT COUNT(*) AS ref_cnt "
    SQL = SQL & "FROM bom_aluminum "
    SQL = SQL & "WHERE mold_id = '" & mold_id & "'"

    response.write "[CHECK REF] " & SQL & "<br>"
    Rs1.Open SQL, Dbcon
    ref_cnt = 0
    If Not (Rs1.BOF Or Rs1.EOF) Then
        ref_cnt = Rs1("ref_cnt")
    End If
    Rs1.Close

    ' 2) 참조 있으면 삭제 막기
    If CLng(ref_cnt) > 0 Then
        response.write "[BLOCK DELETE] mold_id=" & mold_id & ", ref_cnt=" & ref_cnt & "<br>"
        response.write "<script>"
        response.write "alert('이 금형은 bom_aluminum(알루미늄)에서 사용 중이라 삭제할 수 없습니다.\n먼저 bom_aluminum에서 연결을 해제하거나 금형 status를 0(미사용)으로 변경하세요.');"
        response.write "history.back();"
        response.write "</script>"
    Else
        ' 3) 참조 없으면 실제 삭제
        SQL = "DELETE FROM bom_mold WHERE mold_id = '" & mold_id & "'"
        response.write "[BOM_MOLD DELETE] " & SQL & "<br>"
        Dbcon.Execute SQL

        response.write "<script>location.replace('bom_mold_popup.asp');</script>"
    End If

    SQL="DELETE FROM bom_mold WHERE mold_id='"& mold_id &"' "
    response.write SQL & "<br>"
    'Response.end
    Dbcon.Execute SQL

    response.write "<script>location.replace('bom_mold_popup.asp');</script>"

else 

    ' ============================================================
    ' INSERT (mold_id=0 일 때)
    ' ============================================================
    if mold_id="0" then 

        SQL = ""
        SQL = SQL & " INSERT INTO bom_mold (mold_no, mold_name, vendor_id, location_mold, cad_path, img_path, status, midx, memo, cdate) "
        SQL = SQL & " VALUES ( "
        SQL = SQL & " '" & mold_no & "', "
        SQL = SQL & " '" & mold_name & "', "
        SQL = SQL & " '" & vendor_id & "', "
        SQL = SQL & " '" & location_mold & "', "
        SQL = SQL & " '" & cad_path & "', "
        SQL = SQL & " '" & img_path & "', "
        SQL = SQL & " '" & status & "', "
        SQL = SQL & " '" & c_midx & "', "
        SQL = SQL & " '" & memo & "', "
        SQL = SQL & " getdate() "
        SQL = SQL & " ) "

        response.write "[BOM_MOLD INSERT] " & SQL & "<br>"
        Dbcon.Execute SQL

        SQL = "SELECT SCOPE_IDENTITY() AS mold_id"
        Rs1.Open SQL, Dbcon
        If Not(Rs1.BOF Or Rs1.EOF) Then
            new_mold_id = Rs1("mold_id")
        End If
        Rs1.Close

        response.write "<script>location.replace('bom_mold_popup.asp?gotopage=" & gotopage & "&mold_id="&new_mold_id&"&SearchWord="&rSearchWord&"#"&new_mold_id&"');</script>"

    else

        ' ============================================================
        ' UPDATE
        ' ============================================================
        SQL = ""
        SQL = SQL & " UPDATE bom_mold SET "
        SQL = SQL & " mold_no   = '" & mold_no & "', "
        SQL = SQL & " mold_name = '" & mold_name & "', "
        SQL = SQL & " vendor_id = '" & vendor_id & "', "
        SQL = SQL & " location_mold  = '" & location_mold & "', "
        SQL = SQL & " cad_path  = '" & cad_path & "', "
        SQL = SQL & " img_path  = '" & img_path & "', "
        SQL = SQL & " status    = '" & status & "', "
        SQL = SQL & " memo      = '" & memo & "', "
        SQL = SQL & " meidx     = '" & c_midx & "', "
        SQL = SQL & " udate     = getdate() "
        SQL = SQL & " WHERE mold_id = '" & mold_id & "' "

        response.write "[BOM_MOLD UPDATE] <br>" & SQL & "<br>"
        Dbcon.Execute SQL

        response.write "<script>location.replace('bom_mold_popup.asp?gotopage=" & gotopage & "&mold_id="&mold_id&"&SearchWord="&rSearchWord&"#"&mold_id&"');</script>"

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
