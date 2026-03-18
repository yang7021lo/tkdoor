<%
' ==================================================
' Warehouse Cache (Pure)
' ==================================================
Function GetWarehouseCache()

    Dim dict, Rs, sql
    Set dict = Server.CreateObject("Scripting.Dictionary")
    Set Rs   = Server.CreateObject("ADODB.Recordset")

    sql = ""
    sql = sql & " SELECT "
    sql = sql & "   wh_idx, "
    sql = sql & "   wh_name, "
    sql = sql & "   wh_addr, "
    sql = sql & "   wh_addr_detail "
    sql = sql & " FROM tk_wms_warehouse "
    sql = sql & " WHERE is_active = 1 "
    sql = sql & " ORDER BY wh_name ASC "

    Rs.Open sql, DbCon, 1, 1

    Do Until Rs.EOF

        ' key   : wh_idx
        ' value : Array(wh_name, wh_addr, wh_addr_detail)
        dict.Add CStr(Rs("wh_idx")), Array( _
            Rs("wh_name"), _
            Rs("wh_addr"), _
            Rs("wh_addr_detail") _
        )

        Rs.MoveNext
    Loop

    Rs.Close
    Set Rs = Nothing

    Set GetWarehouseCache = dict
End Function
%>
