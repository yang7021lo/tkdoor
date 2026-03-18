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
Set Rs = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")
Set Rs3 =  Server.CreateObject("ADODB.Recordset")

part = Request("part")

' 🔹 파일 및 폼 데이터 읽기
kgotopage = Request("kgotopage")
rSearchWord = Request("SearchWord")

' 🔹 tng_unitprice_t 테이블 기준 변수


rsjbtidx = Request("sjbtidx")
rpcent = Request("pcent")
rSJB_IDX = Request("SJB_IDX")
rSJB_TYPE_NAME = Request("SJB_TYPE_NAME%")
rSJB_barlist = Request("SJB_barlist")
bar = right(rSJB_barlist,3)  
rSJB_TYPE_No = Request("SJB_TYPE_No")
SJB_IDX_P = 0

' Response.Write "rpcent : " & rpcent & "<br>"
' Response.Write "rSJB_IDX  : " & rSJB_IDX  & "<br>"
' Response.Write "rSJB_barlist  : " & rSJB_barlist  & "<br>"
' Response.Write "bar  : " & bar  & "<br>"
' Response.Write "rSJB_TYPE_No  : " & rSJB_TYPE_No  & "<br>"
' Response.end
' 🔹 요청 받은 변수 출력 (디버그용)

'Response.Write "rsjbtidx : " & rsjbtidx & "<br>"
'Response.Write "rpcent : " & rpcent & "<br>"
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "rSJB_TYPE_NAME : " & rSJB_TYPE_NAME & "<br>"
'Response.Write "rSearchWord : " & rSearchWord & "<br>"
'Response.Write "kgotopage : " & kgotopage & "<br>"
'Response.End

' 삭제 처리
If part = "delete" Then
    sql = "DELETE FROM TNG_SJB WHERE SJB_IDX = " & rSJB_IDX
    'Response.Write sql & "<br>"
    'Response.End
    Dbcon.Execute(sql)

Response.Write "<script>location.replace('unittype_pa.asp?SJB_IDX=" & rSJB_IDX & "');</script>"

Else
        
        ' UPDATE 실행
        sql = "UPDATE TNG_SJB SET "
        sql = sql & "pcent = '" & rpcent & "' "
        sql = sql & " WHERE SJB_IDX = '" & rSJB_IDX & "' "
        'Response.Write sql & "<br>"
        'Response.End
        Dbcon.Execute(sql)
            

        '기본 가격이 저장된 SJB_IDX 값을 가져오기'
        sql = "SELECT SJB_IDX "
        sql = sql & " FROM TNG_SJB " 
        sql = sql & " WHERE pcent = 1 "
        sql = sql & " AND SJB_barlist LIKE '%" & bar & "%' "
        sql = sql & " AND SJB_TYPE_No = '" & rSJB_TYPE_No & "' " 
        Rs1.open sql, Dbcon, 1, 1, 1

        SJB_IDX_P = Rs1(0)
        
        ' Response.write("SJB_IDX_P = '" &SJB_IDX_P & "'")
        ' Response.end
        Rs1.Close()


        '초기 데이터 값이 있는지 조회 없을시 생성'
         sql_check = "SELECT * "
         sql_check = sql_check & "FROM tng_unitprice_t "
         sql_check = sql_check & "WHERE SJB_IDX = " & rSJB_IDX   
         Rs3.Open sql_check, Dbcon, 1, 1, 1
        
        '데이터가 없을시 실행'
        If Rs3.EOF Then
            '기본 가격을 가져와서 넣어주기'
            sql = "SELECT * "
            sql = sql & " FROM tng_unitprice_t "
            sql = sql & " WHERE SJB_IDX = '" & SJB_IDX_P & "' "
            Rs2.open sql, Dbcon, 1, 1, 1



            '반복문을 활용하여 해당 칸 맞게 가격을 넣어주기
            if Not (Rs2.EOF Or Rs2.BOF) Then
                Do while Not Rs2.EOF 
                    
                rbfwidx        = Rs2("bfwidx")
                rbfidx         = Rs2("bfidx")
                rsjbtidx       = Rs2("sjbtidx")
                rqtyco_idx     = Rs2("qtyco_idx")
                rprice         = Rs2("price")
                rupstatus      = Rs2("upstatus")
                rQTYIDX        = Rs2("QTYIDX")
                runittype_qtyco_idx = Rs2("unittype_qtyco_idx")
                runittype_bfwidx = Rs2("unittype_bfwidx")
                    
                

               
                    '초기값 생성'
                    If IsNull(rbfwidx) Or rbfwidx = "" Then rbfwidx = 0
                    If IsNull(rbfidx) Or rbfidx = "" Then rbfidx = 0
                    If IsNull(rsjbtidx) Or rsjbtidx = "" Then rsjbtidx = 0
                    If IsNull(rqtyco_idx) Or rqtyco_idx = "" Then rqtyco_idx = 0
                    If IsNull(rupstatus) Or rupstatus = "" Then rupstatus = 1   ' 사용 기본값
                    If IsNull(rSJB_IDX) Or rSJB_IDX = "" Then rSJB_IDX = 0
                    If IsNull(rQTYIDX) Or rQTYIDX = "" Then rQTYIDX = 0
            
                    
                sql_ins = "INSERT INTO tng_unitprice_t "
                sql_ins = sql_ins & "(bfwidx, bfidx, sjbtidx, qtyco_idx, price, upstatus, SJB_IDX, QTYIDX, unittype_bfwidx, unittype_qtyco_idx) "
                sql_ins = sql_ins & "VALUES ("
                sql_ins = sql_ins & rbfwidx & ", "
                sql_ins = sql_ins & rbfidx & ", "
                sql_ins = sql_ins & rsjbtidx & ", "
                sql_ins = sql_ins & rqtyco_idx & ", "
                sql_ins = sql_ins & rprice & ", "
                sql_ins = sql_ins & "1, "
                sql_ins = sql_ins & rSJB_IDX & ", "
                sql_ins = sql_ins & rQTYIDX & ", "
                sql_ins = sql_ins & runittype_bfwidx & ", "
                sql_ins = sql_ins & runittype_qtyco_idx & ")"
                
                ' 디버그용
                ' Response.Write sql_ins & "<br>"
                ' Response.End
                
                Dbcon.Execute sql_ins

                Rs2.MoveNext
            Loop
            
        End IF
        Rs2.Close()
        
    END if
    Rs3.Close()
    
    '퍼센트가 업데이트 되면 기본 가격을 다시 불러와서 퍼센트 만큼 증가 시킨뒤 가격 업데이트 해주기'
     sql = "SELECT * "
    sql = sql & " FROM tng_unitprice_t "
    sql = sql & " WHERE SJB_IDX = '" & SJB_IDX_P & "' "
    Rs2.open sql, Dbcon, 1, 1, 1
    
    If Not (Rs2.EOF Or Rs2.BOF) Then
        Do While Not Rs2.EOF
            
            uptidx = Rs2("uptidx")
            price = Rs2("price")
            unittype_qtyco_idx = Rs2("unittype_qtyco_idx")
            unittype_bfwidx = Rs2("unittype_bfwidx")

            '반복문을 활용하여 칸마다 가격 확인' 
       
             
            '기본 가격에 * 퍼센트 만큼 한 값을 새로 저장'
            new_price = int(price * rpcent)
            'new_price = Round(CDbl(price) * CDbl(rpcent), 5)
            
            sql_u = "UPDATE tng_unitprice_t SET "
            sql_u = sql_u & " price = '" & new_price & "' "
            sql_u = sql_u & " Where SJB_IDX = '" & rSJB_IDX & "' "
            sql_u = sql_u & " AND unittype_qtyco_idx = '" & unittype_qtyco_idx & "' "
            sql_u = sql_u & " AND unittype_bfwidx = '" & unittype_bfwidx & "' "
            ' Response.Write sql_u & "<br>"
            ' Response.End

            Dbcon.Execute sql_u

            Rs2.MoveNext
        Loop
    End If

Rs2.Close()


Response.Write "<script>location.replace('unittype_pa.asp?SJB_IDX=" & rSJB_IDX & "');</script>"
End If

Set Rs = Nothing
Set Rs1 = Nothing
Set Rs2 = Nothing
call dbClose()
%>
