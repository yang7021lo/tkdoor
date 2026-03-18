<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

Dim master_id
master_id = Trim(Request.Form("master_id"))

If master_id = "" Or Not IsNumeric(master_id) Then
    Response.Write "잘못된 요청입니다."
    Response.End
End If
 
On Error Resume Next
Dbcon.BeginTrans

' ============================================
' 공통 비활성화 함수
' ============================================
Sub DeactivateGroup(formKey, tableName, pkName)
    Dim cnt, i, v, sql

    cnt = Request.Form(formKey).Count
    If cnt <= 0 Then Exit Sub

    For i = 1 To cnt
        v = Trim(Request.Form(formKey)(i))
        If IsNumeric(v) Then
            sql = "UPDATE " & tableName & _
                  " SET is_active=0 WHERE " & pkName & "=" & CLng(v)
            Dbcon.Execute sql
        End If
    Next
End Sub

' ============================================
' 각 테이블 비활성화
' ============================================
Call DeactivateGroup("material_id[]", "bom2_material",   "material_id")
Call DeactivateGroup("mold_id[]",     "bom2_mold",       "mold_id")
Call DeactivateGroup("length_id[]",   "bom2_length",     "length_id")
Call DeactivateGroup("surface_id[]",  "bom2_surface",    "surface_id")
Call DeactivateGroup("title_id[]",    "bom2_list_title", "list_title_id")

' ============================================
' Master (항상 마지막)
' ============================================
Dbcon.Execute _
    "UPDATE bom2_master SET is_active=0 WHERE master_id=" & CLng(master_id)

' ============================================
' 트랜잭션 처리
' ============================================
If Err.Number <> 0 Then
    Dbcon.RollbackTrans
    Response.Write "<script>alert('비활성화 처리 중 오류 발생');history.back();</script>"
Else
    Dbcon.CommitTrans
    Response.Write "<script>alert('비활성화 완료');location.href='../bom2_main.asp';</script>"
End If

call DbClose()
%>
