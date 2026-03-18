<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"

' 엑셀 다운로드 여부 확인 (URL에서 ?excel=1 이면 엑셀 다운로드)
Dim exportExcel
exportExcel = Request.QueryString("excel")
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 

<%

' DB 연결
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

' 데이터 조회 쿼리
SQL = "SELECT A.sidx, A.baridx, A.barNAME, A.rgoidx, A.goname, A.FULL_NAME, " _
    & "A.smtype, A.smproc, A.smal, A.smalqu, A.smst, A.smstqu, A.smglass, A.smgrid, A.tagongfok, A.tagonghigh, A.smnote, A.smcomb, " _
    & "B.Buidx, B.BUNAME, B.BUSELECT, B.BUPAINT, " _
    & "B.BUST_GLASS, B.BUST_GLASStype1, B.BUST_GLASStype2, B.BUST_GLASStype3, B.BUST_GLASStype4, B.BUST_GLASStype5, " _
    & "B.BUST_N_CUT_STATUS, B.BUST_HL_COIL, B.BUST_NUCUT_ShRing, B.BUST_NUCUT_1, B.BUST_NUCUT_2, " _
    & "B.BUST_VCUT_ShRing, B.BUST_VCUT_1, B.BUST_VCUT_2, B.BUST_VCUT_CH " _
    & "FROM TKM1 A JOIN BUSOK1 B ON A.buidx = B.Kuidx " _
    & "WHERE A.smcomb = 1"

Rs.Open SQL, Dbcon, 3, 1

' ✅ 데이터 가공 (SELECT CASE 적용)
Dim jsidx, ksidx, kk, jj, rdade
jsidx = ""
ksidx = ""
kk = 0
jj = 0

' ✅ 엑셀 다운로드 처리 (CSV 방식)
If exportExcel = "1" Then
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-Disposition", "attachment; filename=insert_preview.csv"
    Response.Charset = "utf-8"
    Response.Write Chr(239) & Chr(187) & Chr(191) ' UTF-8 BOM 추가 (한글 깨짐 방지)

    ' CSV 헤더 출력
    Response.Write "sidx,baridx,barNAME,rgoidx,goname,FULL_NAME,smtype,smproc,smal,smalqu,smst,smstqu,smglass,smgrid,tagongfok,tagonghigh,smnote,smcomb,Buidx,BUNAME,BUSELECT,BUPAINT,BUST_GLASS,BUST_GLASStype1,BUST_GLASStype2,BUST_GLASStype3,BUST_GLASStype4,BUST_GLASStype5,BUST_N_CUT_STATUS,BUST_HL_COIL,BUST_NUCUT_ShRing,BUST_NUCUT_1,BUST_NUCUT_2,BUST_VCUT_ShRing,BUST_VCUT_1,BUST_VCUT_2,BUST_VCUT_CH" & vbCrLf

    ' 데이터 출력
    If Not Rs.EOF Then
        Do While Not Rs.EOF
            ' 데이터 매핑
            sidx = Rs("sidx")
            baridx = Rs("baridx")
            barNAME = Rs("barNAME")
            rgoidx = Rs("rgoidx")
            goname = Rs("goname")
            FULL_NAME = Rs("FULL_NAME")
            smtype = Rs("smtype")
            smproc = Rs("smproc")
            smal = Rs("smal")
            smalqu = Rs("smalqu")
            smst = Rs("smst")
            smstqu = Rs("smstqu")
            smglass = Rs("smglass")
            smgrid = Rs("smgrid")
            tagongfok = Rs("tagongfok")
            tagonghigh = Rs("tagonghigh")
            smnote = Rs("smnote")
            smcomb = Rs("smcomb")
            Buidx = Rs("Buidx")
            BUNAME = Rs("BUNAME")
            BUSELECT = Rs("BUSELECT")
            BUPAINT = Rs("BUPAINT")

            ' ✅ CASE 조건 로직 적용
            rdade = Right(BUSELECT, 3)

            Select Case rdade
                Case "다대바"
                    smtype = "H"
                    If smtype = "H" And sidx = ksidx Then
                        kk = kk + 1
                        smproc = "SM_DADE" & kk
                    Else
                        kk = 0
                        ksidx = ""
                    End If
                Case "에치바"
                    smtype = "W"
                    If smtype = "W" And sidx = jsidx Then
                        jj = jj + 1
                        smproc = "SM_H" & jj
                    Else
                        jj = 0
                        jsidx = ""
                    End If
            End Select

            ' ✅ 데이터 엑셀로 출력
            Response.Write sidx & "," & baridx & "," & barNAME & "," & rgoidx & "," & goname & "," & FULL_NAME & "," & smtype & "," & smproc & "," & smal & "," & smalqu & "," & smst & "," & smstqu & "," & smglass & "," & smgrid & "," & tagongfok & "," & tagonghigh & "," & smnote & "," & smcomb & "," & Buidx & "," & BUNAME & "," & BUSELECT & "," & BUPAINT & vbCrLf
            
            Rs.MoveNext
        Loop
    End If

    Rs.Close
    Set Rs = Nothing
    call dbClose()
    Response.End
End If

Rs.Close
Set Rs = Nothing
call dbClose()
%>

