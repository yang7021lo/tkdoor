<%
' ==========================================
' Role Detail Template Cache
' ==========================================
Function GetRoleDetailTemplate(role_core_idx)

    Dim dict, Rs, sql
    Set dict = Server.CreateObject("Scripting.Dictionary")
    Set Rs   = Server.CreateObject("ADODB.Recordset")

    sql = ""
    sql = sql & " SELECT role_detail_idx, step, is_finish, spot_idx "
    sql = sql & " FROM tk_wms_role_detail "
    sql = sql & " WHERE role_core_idx = " & role_core_idx
    sql = sql & "   AND is_active = 1 "
    sql = sql & " ORDER BY step ASC "

    Rs.Open sql, DbCon, 1, 1

    Do Until Rs.EOF
        ' key : step
        ' value : Array(is_finish, spot_idx)
        dict.Add CStr(Rs("step")), Array( _
            Rs("is_finish"), _
            Rs("spot_idx") _
        )
        Rs.MoveNext
    Loop

    Rs.Close
    Set Rs = Nothing

    Set GetRoleDetailTemplate = dict
End Function
%>
