<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

Dim wh_idx, wh_name, wh_addr, lat, lng, floor, is_active
wh_idx = Trim(Request("wh_idx"))
wh_name = Trim(Request("wh_name"))
wh_addr = Trim(Request("wh_addr"))
wh_addr_detail = Trim(Request("wh_addr_detail"))
wh_zip = Trim(Request("wh_zip_code")) 
lat = Trim(Request("wh_addr_lat"))
lng = Trim(Request("wh_addr_long"))
floor = Trim(Request("wh_addr_floor"))
is_active = Trim(Request("is_active"))
mode = Trim(Request("mode"))

'response.Write wh_idx & "<br>"
'response.Write mode & "<br>"
' response.Write wh_name & "<br>"
' response.Write wh_addr & "<br>"
' response.Write wh_zip & "<br>"
' response.Write lat & "<br>"
' response.Write lng & "<br>"
' response.Write floor & "<br>"
' response.Write is_active & "<br>"
'response.end

If mode = "delete" Then
    SQL = "UPDATE tk_wms_warehouse SET is_active = 0 WHERE wh_idx = " & wh_idx
    DbCon.Execute SQL
    Response.Write "<script>alert('삭제되었습니다');window.opener.location.reload();window.close();</script>"
    Response.End
End If

If wh_name = "" Or wh_addr = "" AND mode <> "delete" Then
    Response.Write "<script>alert('창고명과 주소는 필수입니다');history.back();</script>"
    Response.End
End If

If lat = "" Then lat = "NULL"
If lng = "" Then lng = "NULL"
If floor = "" Then floor = "NULL"

Dim SQL

If wh_idx = "" Then
    SQL = ""
    SQL = SQL & "INSERT INTO tk_wms_warehouse ( "
    SQL = SQL & " wh_name, wh_addr, wh_addr_detail,wh_zip_code,wh_addr_lat, wh_addr_long, wh_addr_floor, is_active "
    SQL = SQL & ") VALUES ( "
    SQL = SQL & "'" & Replace(wh_name,"'","''") & "', "
    SQL = SQL & "'" & Replace(wh_addr,"'","''") & "', "
       SQL = SQL & "'" & Replace(wh_zip,"'","''") & "', "
    SQL = SQL & "'" & Replace(wh_addr_detail,"'","''") & "', "
    SQL = SQL & lat & ", "
    SQL = SQL & lng & ", "
    SQL = SQL & floor & ", "
    SQL = SQL & "1 ) "
Else
    SQL = ""
    SQL = SQL & "UPDATE tk_wms_warehouse SET "
    SQL = SQL & " wh_name='" & Replace(wh_name,"'","''") & "', "
    SQL = SQL & " wh_addr='" & Replace(wh_addr,"'","''") & "', "
    SQL = SQL & " wh_addr_detail='" & Replace(wh_addr_detail,"'","''") & "', "
    SQL = SQL & " wh_zip_code='" & Replace(wh_zip,"'","''") & "', "
    SQL = SQL & " wh_addr_lat=" & lat & ", "
    SQL = SQL & " wh_addr_long=" & lng & ", "
    SQL = SQL & " wh_addr_floor=" & floor
    SQL = SQL & " WHERE wh_idx=" & wh_idx
End If

DbCon.Execute SQL

Response.Write "<script>alert('저장되었습니다');window.opener.location.reload();window.close();</script>"
%>
