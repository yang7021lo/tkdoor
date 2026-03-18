<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"

call DbOpen()

Dim type
type = LCase(Trim(Request("type")))
%>

<%
Select Case type

    Case "master"
        %><!-- #include virtual="/TNG_bom/bom2/master/bom2_master_list.asp" --><%

    Case "origin"
        %><!-- #include virtual="/TNG_bom/bom2/origin/bom2_origin_list.asp" --><%

    Case "mold"
        %><!-- #include virtual="/TNG_bom/bom2/mold/bom2_mold_list.asp" --><%

    Case "surface"
        %><!-- #include virtual="/TNG_bom/bom2/surface/bom2_surface_list.asp" --><%

    Case "material"
        %><!-- #include virtual="/TNG_bom/bom2/material/bom2_material_list.asp" --><%

    Case "title"
        %><!-- #include virtual="/TNG_bom/bom2/title/bom2_title_list.asp" --><%

    Case Else
        Response.Write "<div class='text-muted'>잘못된 접근입니다.</div>"

End Select
%>

<%
call DbClose()
%>
