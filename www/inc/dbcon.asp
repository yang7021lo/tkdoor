<%

Dim Dbcon,DbConshape,NailCon,ole_DB
Dim CON_STR, OLE_Provider, SHAPE_Provider
Dim Column,Table,value

CON_STR = "data Source=sql19-004.cafe24.com; Initial Catalog=tkd001;user ID=tkd001;password=tkd2713!;"
Set DbCon = Server.CreateObject("ADODB.Connection")
Set NailCon = Server.CreateObject("ADODB.Connection")
dbcon.ConnectionTimeout = 1000000
dbcon.CommandTimeout = 1000000
OLE_Provider = "SQLOLEDB"
shape_Provider = "MSdataShape"
OLE_DB="Provider = SQLOLEDB; Data Source=sql19-004.cafe24.com;initial Catalog=tkd001; User ID=tkd001;password=tkd2713!;"

Sub dbOpen()
    DbCon.Provider =  OLE_Provider
    DbCon.Open CON_STR
End Sub    

Sub dbClose()
    DbCon.close
    Set DbCon = Nothing
End Sub
%>
 