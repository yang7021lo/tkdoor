<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Call DbOpen()

Dim master_id
master_id = Trim(Request.Form("master_id"))

If master_id = "" Or Not IsNumeric(master_id) Then
    Response.Write "잘못된 요청입니다."
    Response.End
End If

Dim mid
mid = CLng(master_id)

On Error Resume Next
Dbcon.BeginTrans

'============================================
' SQL 실행 + 오류나면 즉시 Rollback 후 종료
'============================================
Sub ExecSql(sqlText)
    Err.Clear
    Dbcon.Execute sqlText

    If Err.Number <> 0 Then
        Dbcon.RollbackTrans

        Dim msg
        msg = Replace(Err.Description, "'", "")

        Call DbClose()
        Response.Write "<script>alert('비활성화 처리 중 오류 발생: " & msg & "');history.back();</script>"
        Response.End
    End If
End Sub

'--------------------------------------------
' 1) bom3_table_value 비활성화 (tv.master_id 없음 → sv.master_id로 판단)
'--------------------------------------------
Call ExecSql( _
    "UPDATE tv SET tv.is_active=0 " & _
    "FROM bom3_table_value tv " & _
    "JOIN bom3_title_sub_value sv ON sv.title_sub_id = tv.title_sub_id " & _
    "WHERE sv.master_id = " & mid & " AND tv.is_active=1" _
)

'--------------------------------------------
' 2) bom3_title_sub_value 비활성화
'--------------------------------------------
Call ExecSql( _
    "UPDATE bom3_title_sub_value " & _
    "SET is_active=0 " & _
    "WHERE master_id = " & mid & " AND is_active=1" _
)

'--------------------------------------------
' 3) bom3_list_title_sub 비활성화 (ts.master_id 없음 → lt.master_id로 판단)
'--------------------------------------------
Call ExecSql( _
    "UPDATE ts SET ts.is_active=0 " & _
    "FROM bom3_list_title_sub ts " & _
    "JOIN bom3_list_title lt ON lt.list_title_id = ts.list_title_id " & _
    "WHERE lt.master_id = " & mid & " AND ts.is_active=1" _
)

'--------------------------------------------
' 4) bom3_list_title 비활성화
'--------------------------------------------
Call ExecSql( _
    "UPDATE bom3_list_title " & _
    "SET is_active=0 " & _
    "WHERE master_id = " & mid & " AND is_active=1" _
)

'--------------------------------------------
' 5) bom3_material 비활성화
'--------------------------------------------
Call ExecSql( _
    "UPDATE bom3_material " & _
    "SET is_active=0 " & _
    "WHERE master_id = " & mid & " AND is_active=1" _
)

'--------------------------------------------
' 6) bom3_master 비활성화 (항상 마지막)
'--------------------------------------------
Call ExecSql( _
    "UPDATE bom3_master " & _
    "SET is_active=0 " & _
    "WHERE master_id = " & mid _
)

Dbcon.CommitTrans
Call DbClose()

Response.Write "<script>alert('비활성화 완료');location.href='../bom3_main.asp';</script>"
%>
