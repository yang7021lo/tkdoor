<%
    Dim file_svrip,admin_svrip,svrip, svripDB, get_String

    Function SQL_Injection(get_String)
        get_String = Replace(get_String,"'", "''")
        get_String = Replace(get_String,";","")
        get_String = Replace(get_String,"--","")
        get_String = Replace(get_String,"1=1","",1,-1,1)
        get_String = Replace(get_String,"sp_","",1,-1,1)
        get_String = Replace(get_String,"xp_","",1,-1,1)
        get_String = Replace(get_String,"@variable","",1,-1,1)
        get_String = Replace(get_String,"@variable","",1,-1,1)
        get_String = Replace(get_String,"@@variable","",1,-1,1)
        SQL_Injection = get_String

    end Function

    Dim DbCon, DbConShape, MailCon, OLE_DB
    Dim CON_STR, OLE_Provider, SHAPE_Provider
    Dim Column,Table,value


'	CON_STR = "Data Source=sql16ssd-013.localnet.kr;Initial Catalog=kevinsaemdb_lab93;user ID=kevinsaemdb_lab93;password=Kevin95733@;"
'	Set DbCon = Server.CreateObject("ADODB.Connection")
'	Set MailCon = Server.CreateObject("ADODB.Connection")
'	dbcon.ConnectionTimeout = 1000000
'	dbcon.CommandTimeout = 1000000
'	OLE_Provider = "SQLOLEDB"
'	SHAPE_Provider = "MSDataShape"
'	OLE_DB="Provider = SQLOLEDB; Data Source=sql16ssd-013.localnet.kr;initial Catalog=kevinsaemdb_lab93;User ID=kevinsaemdb_lab93;password=Kevin95733@;"	



    CON_STR = "Data Source=sql19-004.cafe24.com;Initial Catalog=tkd001;user ID=tkd001;password=tkd2713!;"
    Set DbCon = Server.CreateObject("ADODB.Connection")
    Set MailCon = Server.CreateObject("ADODB.Connection")
    dbcon.ConnectionTimeout = 1000000
    dbcon.CommandTimeout = 1000000
    OLE_Provider = "SQLOLEDB"
    SHAPE_Provider = "MSDataShape"
    OLE_DB = "Provider = SQLOLEDB; Data Source=sql19-004.cafe24.com;Initial Catalog=tkd001;user ID=tkd001;password=tkd2713!;"

    Sub dbOpen()
        Dbcon.Provider = OLE_Provider
        DbCon.Open CON_STR
    End Sub

    Sub dbClose()
        DbCon.close
        set DbCon = nothing
    End Sub

    Sub MailClose()
        MailCon.close
        Set MailClose = nothing
    End Sub

    Sub dbShapeOpen()
        Set DbConShape = Server.CreateObject("ADODB.Connection")
        DbConShape.Provider = SHAPE_Provider
        DbConShape.Open "Data Provider=" & OLE_Provider & ";" & CON_STR
    End Sub

    Sub dbShapeClose()
        DbConShape.close
        Set DbConShape = nothing
    End Sub

%>