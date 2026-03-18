<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim mode
mode = Request("mode")

If mode = "select" Then

    Dim title_sub_id, list_title_id
    If Not IsNumeric(Request("title_sub_id")) _
       Or Not IsNumeric(Request("list_title_id")) Then
        Response.Write "INVALID"
        Response.End
    End If

    title_sub_id  = CLng(Request("title_sub_id"))
    list_title_id = CLng(Request("list_title_id"))

    Dbcon.Execute _
      "UPDATE bom3_list_title_sub SET is_select=0 WHERE list_title_id=" & list_title_id

    Dbcon.Execute _
      "UPDATE bom3_list_title_sub SET is_select=1 WHERE title_sub_id=" & title_sub_id

    Response.Write "OK"

ElseIf mode = "show" Then

    Dim is_show
    If Not IsNumeric(Request("title_sub_id")) _
       Or Not IsNumeric(Request("is_show")) Then
        Response.Write "INVALID"
        Response.End
    End If

    Dbcon.Execute _
      "UPDATE bom3_list_title_sub SET is_show=" & CLng(Request("is_show")) & _
      " WHERE title_sub_id=" & CLng(Request("title_sub_id"))

    Response.Write "OK"

Else
    Response.Write "INVALID MODE"
End If

call DbClose()
%>