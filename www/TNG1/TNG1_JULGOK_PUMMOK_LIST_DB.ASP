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

part=Request("part")
gotopage=Request("gotopage")




' Request 값을 받아 변수에 저장
rSJB_IDX       = Request("SJB_IDX")
rbfidx         = Request("bfidx")
rset_name_FIX  = Request("set_name_FIX")
rset_name_AUTO = Request("set_name_AUTO")
rWHICHI_FIX    = Request("WHICHI_FIX")
rWHICHI_AUTO   = Request("WHICHI_AUTO")
rxsize         = Request("xsize")
rysize         = Request("ysize")
rbfimg1        = Request("bfimg1")
rbfimg2        = Request("bfimg2")
rbfimg3        = Request("bfimg3")
rbfimg4        = Request("bfimg4")

rbfmidx        = Request("bfmidx")
rbfwdate       = Request("bfwdate")
rbfemidx       = Request("bfemidx")
rbfewdate      = Request("bfewdate")
rTNG_Busok_idx      = Request("TNG_Busok_idx")
rTNG_Busok_idx2      = Request("TNG_Busok_idx2")
rTNG_Busok_idx3      = Request("TNG_Busok_idx3")
rpcent  = Request("pcent")
rboyang  = Request("boyang")
rboyangname = Request("boyangname")
rboyangtype = Request("boyangtype")



' 값 출력 (디버깅용)
'Response.Write "rpcent : " & rpcent & "<br>"
 'Response.Write "rTNG_Busok_idx : " & rTNG_Busok_idx & "<br>"
 'Response.Write "rTNG_Busok_idx2 : " & rTNG_Busok_idx2 & "<br>"
 'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
 'Response.Write "rbfidx : " & rbfidx & "<br>"
 'Response.Write "part : " & part & "<br>"
'Response.Write "set_name_FIX : " & rset_name_FIX & "<br>"
'Response.Write "set_name_AUTO : " & rset_name_AUTO & "<br>"
 'Response.Write "WHICHI_FIX : " & rWHICHI_FIX & "<br>"
 'Response.Write "WHICHI_AUTO : " & rWHICHI_AUTO & "<br>"
 'Response.Write "xsize : " & rxsize & "<br>"
 'Response.Write "ysize : " & rysize & "<br>"
' Response.Write "bfimg1 : " & bfimg1 & "<br>"
' Response.Write "bfimg2 : " & bfimg2 & "<br>"
' Response.Write "bfidx : " & bfidx & "<br>"
' Response.Write "bfmidx : " & bfmidx & "<br>"
' Response.Write "bfwdate : " & bfwdate & "<br>"
' Response.Write "bfemidx : " & bfemidx & "<br>"
' Response.Write "bfewdate : " & bfewdate & "<br>"
'response.end
if part="delete" then 
    SQL="Delete From tk_barasiF Where bfidx='"&rbfidx&"' "
    'Response.write (SQL)&"<br>"
    'Response.end
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage="&gotopage&"&SJB_IDX="&rSJB_IDX&"');</script>"
else 
    if rbfidx="0" then 
        SQL = "INSERT INTO tk_barasiF (set_name_FIX, set_name_AUTO, WHICHI_FIX, WHICHI_AUTO, xsize, ysize, bfimg1, bfimg2, sjb_idx, bfmidx, bfwdate, bfemidx, bfewdate ) "
        SQL = SQL & "VALUES ('" & rset_name_FIX & "', '" & rset_name_AUTO & "', '" & rWHICHI_FIX & "', '" & rWHICHI_AUTO & "', "
        SQL = SQL & " '" & rxsize & "', '" & rysize & "', '" & rbfimg1 & "', '" & rbfimg2 & "', "
        SQL = SQL & " '" & rsjb_idx & "', '" & C_midx & "', GETDATE(), '" & C_midx & "', GETDATE() ) "
        'Response.write (SQL)&"<br>"
        'Response.END
        Dbcon.Execute(SQL)

        SQL=" Select max(bfidx) From tk_barasiF "
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            bfidx = Rs(0)
        End If
        Rs.Close

        response.write "<script>location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage="&gotopage&"&bfidx="&bfidx&"&sjb_idx="&rsjb_idx&"');</script>"
    else


mode = Request("mode")


'  UPDATE 후 리턴 시
'response.write "<script>location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage="&gotopage&"&bfidx=" & rbfidx & "&sjb_idx=" & rsjb_idx & "&mode=" & mode & "');</script>"

'tng_busok TB에서 이미지 정보 불러와 tk_barasiF에 업데이트하기 시작 

        SQL=" select TNG_Busok_images from tng_busok where TNG_busok_idx='"&rTNG_busok_idx&"' "
        'Response.write(SQL) & "<br>"
        'Response.END
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            rbfimg1 = Rs(0)

        End If
        Rs.Close

        SQL=" select TNG_Busok_images from tng_busok where TNG_busok_idx='"&rTNG_busok_idx2&"' "
        'Response.write(SQL) & "<br>"
        'Response.END
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            rbfimg2 = Rs(0)

        End If
        Rs.Close

        SQL=" select TNG_Busok_images from tng_busok where TNG_busok_idx='"&rTNG_busok_idx3&"' "
        'Response.write(SQL) & "<br>"
        'Response.END
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            rbfimg4 = Rs(0)

        End If
        Rs.Close

'tng_busok TB에서 이미지 정보 불러와 tk_barasiF에 업데이트하기 끝

'---------------------------------------------------------------------------------------------------------

if rWHICHI_FIX <>"" then

    sql = "SELECT set_name_FIX FROM tk_barasiF "
    sql = sql & "WHERE WHICHI_FIX = '" & rWHICHI_FIX & "' "
    sql = sql & " AND xsize = '" & rxsize & "'" 
    sql = sql & " AND ysize = '" & rysize & "'" 
    sql = sql & " AND SJB_IDX = '" & rSJB_IDX & "'" 
    sql = sql & " AND bfidx <> '" & rbfidx & "'"  ' 현재 본인 제외 (update 시)
    'Response.write(SQL) & "<br>"
    'Response.END
    Rs.open sql, Dbcon, 1, 1, 1
    If Not (Rs.EOF Or Rs.BOF) Then
        yset_name_FIX = Rs(0)
    End If
    Rs.Close

    if rset_name_FIX  = yset_name_FIX  and rset_name_FIX <>""  Then
        'Response.Write "rset_name_FIX : " & rset_name_FIX & "<br>"
        'Response.Write "yset_name_FIX : " & yset_name_FIX & "<br>"
        'Response.END
        ' 중복 체크 - FIX
        sql = "SELECT COUNT(*) FROM tk_barasiF "
        sql = sql & "WHERE WHICHI_FIX = '" & rWHICHI_FIX & "' "
        sql = sql & " AND xsize = '" & rxsize & "'" 
        sql = sql & " AND ysize = '" & rysize & "'" 
        sql = sql & " AND SJB_IDX = '" & rSJB_IDX & "'" 
        sql = sql & " AND bfidx <> '" & rbfidx & "'"  ' 현재 본인 제외 (update 시)

        'Response.write(SQL) & "<br>"
        'Response.END
        Rs.open sql, Dbcon, 1, 1, 1
        If Not (Rs.EOF Or Rs.BOF) Then
            COUNT_set_name_FIX = Rs(0)
                
                If COUNT_set_name_FIX > 0 Then
                    
                    Response.Write "<script>alert('수동 자재명이 " & COUNT_set_name_FIX & "개 이미 존재합니다! 추가 생성됩니다.');</script>"
                    'Response.End
                End If
        End If
        Rs.Close

        sql = "SELECT WHICHI_FIXname "
        sql = sql & " FROM tng_whichitype "
        sql = sql & " WHERE WHICHI_FIX = '" & rWHICHI_FIX & "' "
        'Response.write(SQL) & "<br>"
        'Response.END
        Rs.open sql, Dbcon, 1, 1, 1
        If Not (Rs.EOF Or Rs.BOF) Then

            rWHICHI_FIXname = Rs(0)

        End If
        Rs.Close

        ' 수동 생성된 수동자재명
        kset_name_FIX = rxsize & " X " & rysize & "_" & rWHICHI_FIXname
        'Response.Write "kset_name_FIX : " & kset_name_FIX & "<br>"

        If COUNT_set_name_FIX > 0 Then

            ' 자동완성 A,B,C 추가 --- 기본 이름을 먼저 저장
            base_name_FIX = kset_name_FIX
            suffix = ""
            sql = "SELECT set_name_FIX FROM tk_barasiF WHERE set_name_FIX LIKE '" & base_name_FIX & "%'"
            Rs.Open sql, Dbcon, 1, 1

            ' --- 이미 사용된 이름들을 배열로 저장
            Dim usedNames()
            ReDim usedNames(0)
            countUsed = 0
            Do Until Rs.EOF
                ReDim Preserve usedNames(countUsed)
                usedNames(countUsed) = Rs(0)
                countUsed = countUsed + 1
                Rs.MoveNext
            Loop
            Rs.Close

            ' --- A~Z 중 사용되지 않은 접미사 찾기
            For i = 65 To 90   ' ASCII 65 = "A", 66 = "B", ..., 90 = "Z"
                candidate = base_name_FIX & Chr(i)
                isDuplicate = False
                For j = 0 To UBound(usedNames)
                    If LCase(usedNames(j)) = LCase(candidate) Then
                        isDuplicate = True
                        Exit For
                    End If
                Next
                If Not isDuplicate Then
                    suffix = Chr(i)
                    Exit For
                End If
            Next

                If suffix <> "" Then
                    kset_name_FIX = base_name_FIX & suffix
                End If

            End If

        elseif rset_name_FIX="" Then

            sql = "SELECT WHICHI_FIXname "
            sql = sql & " FROM tng_whichitype "
            sql = sql & " WHERE WHICHI_FIX = '" & rWHICHI_FIX & "' "
            'Response.write(SQL) & "<br>"
            'Response.END
            Rs.open sql, Dbcon, 1, 1, 1
            If Not (Rs.EOF Or Rs.BOF) Then

                rWHICHI_FIXname = Rs(0)

            End If
            Rs.Close
            
            ' 수동 생성된 수동자재명
            kset_name_FIX = rxsize & " X " & rysize & "_" & rWHICHI_FIXname
            'Response.Write "rWHICHI_FIXname : " & rWHICHI_FIXname & "<br>"
            'Response.Write "kset_name_FIX : " & kset_name_FIX & "<br>"
            'Response.END

        elseif rset_name_FIX <> yset_name_FIX Then  

            kset_name_FIX=rset_name_FIX

        End If    
'-----------------------------------------------------------------------------------------------------------------

elseif rWHICHI_AUTO <>"" then

    sql = "SELECT set_name_AUTO FROM tk_barasiF "
    sql = sql & "WHERE WHICHI_AUTO = '" & rWHICHI_AUTO & "' "
    sql = sql & " AND xsize = '" & rxsize & "'" 
    sql = sql & " AND ysize = '" & rysize & "'" 
    sql = sql & " AND SJB_IDX = '" & rSJB_IDX & "'" 
    sql = sql & " AND bfidx <> '" & rbfidx & "'"  ' 현재 본인 제외 (update 시)
    'Response.write(SQL) & "<br>"
    'Response.END
    Rs.open sql, Dbcon, 1, 1, 1
    If Not (Rs.EOF Or Rs.BOF) Then
        yset_name_AUTO = Rs(0)
    End If
    Rs.Close

    if rset_name_AUTO = yset_name_AUTO  and rset_name_AUTO <>"" Then
    'Response.Write "rset_name_AUTO : " & rset_name_AUTO & "<br>"
    'Response.Write "yset_name_AUTO : " & yset_name_AUTO & "<br>"
    'Response.END

        ' 중복 체크 - AUTO
        sql = "SELECT COUNT(*) FROM tk_barasiF "
        sql = sql & "WHERE set_name_AUTO = '" & rset_name_AUTO & "' "
        sql = sql & "AND bfidx <> '" & rbfidx & "'"  ' 현재 본인 제외 (update 시)
        Rs.open sql, Dbcon, 1, 1, 1
        If Not (Rs.EOF Or Rs.BOF) Then
            COUNT_set_name_AUTO = Rs(0)
                If COUNT_set_name_AUTO > 0 Then

                    Response.Write "<script>alert('자동 자재명이 " & COUNT_set_name_AUTO & "개 이미 존재합니다! 추가 생성됩니다.'); </script>"
                    'Response.End
                End If
        End If
        Rs.Close

        sql = " SELECT WHICHI_AUTOname "
        sql = sql & " FROM tng_whichitype "
        sql = sql & " WHERE WHICHI_AUTO = '"  & rWHICHI_AUTO & "' "
        'Response.write(SQL) & "<br>"
        'Response.END
        Rs.open sql, Dbcon, 1, 1, 1
        If Not (Rs.EOF Or Rs.BOF) Then

            rWHICHI_AUTOname = Rs(0)

        End If
        Rs.Close

        ' 자동 생성된 자동자재명
        kset_name_AUTO = rxsize & " X " & rysize & "_" & rWHICHI_AUTOname
        'Response.Write "kset_name_AUTO : " & kset_name_AUTO & "<br>"

            If COUNT_set_name_AUTO > 0 Then
                ' 자동완성 A,B,C 추가 --- 기본 이름을 먼저 저장
                base_name_AUTO = kset_name_AUTO
                suffix_AUTO = ""

                sql = "SELECT set_name_AUTO FROM tk_barasiF WHERE set_name_AUTO LIKE '" & base_name_AUTO & "%'"
                Rs.Open sql, Dbcon, 1, 1

                ' --- 이미 사용된 이름들을 배열로 저장
                ReDim usedNamesAUTO(0)
                countUsedAUTO = 0
                Do Until Rs.EOF
                    ReDim Preserve usedNamesAUTO(countUsedAUTO)
                    usedNamesAUTO(countUsedAUTO) = Rs(0)
                    countUsedAUTO = countUsedAUTO + 1
                    Rs.MoveNext
                Loop
                Rs.Close

                ' --- A~Z 중 사용되지 않은 접미사 찾기
                For i = 65 To 90   ' ASCII 65 = "A", ..., 90 = "Z"
                    candidateAUTO = base_name_AUTO & Chr(i)
                    isDuplicate = False
                    For j = 0 To UBound(usedNamesAUTO)
                        If LCase(usedNamesAUTO(j)) = LCase(candidateAUTO) Then
                            isDuplicate = True
                            Exit For
                        End If
                    Next
                    If Not isDuplicate Then
                        suffix_AUTO = Chr(i)
                        Exit For
                    End If
                Next

                    If suffix_AUTO <> "" Then
                        kset_name_AUTO = base_name_AUTO & suffix_AUTO
                    End If

                End If    

        elseif rset_name_AUTO="" Then

            sql = "SELECT WHICHI_autoname "
            sql = sql & " FROM tng_whichitype "
            sql = sql & " WHERE WHICHI_AUTO = '" & rWHICHI_AUTO & "' "
            'Response.write(SQL) & "<br>"
            'Response.END
            Rs.open sql, Dbcon, 1, 1, 1
            If Not (Rs.EOF Or Rs.BOF) Then

                rWHICHI_autoname = Rs(0)

            End If
            Rs.Close

             ' 수동 생성된 자동자재명
            kset_name_AUTO = rxsize & " X " & rysize & "_" & rWHICHI_Autoname
            'Response.Write "rWHICHI_FIXname : " & rWHICHI_FIXname & "<br>"
            'Response.Write "kset_name_FIX : " & kset_name_FIX & "<br>"
            'Response.END

        elseif rset_name_AUTO <> yset_name_AUTO Then  

            kset_name_AUTO=rset_name_AUTO

        End If      

end if 


        SQL = "UPDATE tk_barasiF SET "
        SQL = SQL & "set_name_FIX = '" & kset_name_FIX & "', set_name_AUTO = '" & kset_name_AUTO & "', "
        SQL = SQL & "WHICHI_FIX = '" & rWHICHI_FIX & "', WHICHI_AUTO = '" & rWHICHI_AUTO & "', xsize = '" & rxsize & "', ysize = '" & rysize & "', "
        SQL = SQL & "bfimg1 = '" & rbfimg1 & "', bfimg2 = '" & rbfimg2 & "', bfimg4 = '" & rbfimg4 & "', sjb_idx = '" & rsjb_idx & "', "
        SQL = SQL & "bfemidx = '" & C_midx & "', bfewdate = GETDATE() , TNG_busok_idx='"&rTNG_busok_idx&"' , TNG_busok_idx2='"&rTNG_busok_idx2&"' "
        SQL = SQL & " , TNG_busok_idx3='"&rTNG_busok_idx3&"' , pcent='"&rpcent&"' ,  boyang='"&rboyang&"' ,  boyangname='"&rboyangname&"' ,  boyangtype='"&rboyangtype&"'"
        SQL = SQL & "WHERE bfidx = '" & rbfidx & "' "
        'Response.write(SQL) & "<br>"
        'Response.END
        Dbcon.Execute(SQL)
        response.write "<script>location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage="&gotopage&"&bfidx="&rbfidx&"&sjb_idx="&rsjb_idx&"');</script>"

    end if

end if

set Rs = Nothing
call dbClose()
%>

