<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
    call dbOpen()
    Set RsC = Server.CreateObject ("ADODB.Recordset")
    Set Rs = Server.CreateObject ("ADODB.Recordset")
    Set Rs1 = Server.CreateObject ("ADODB.Recordset")
    Set Rs2 = Server.CreateObject ("ADODB.Recordset")
    Set Rs3 = Server.CreateObject ("ADODB.Recordset")

    projectname="알루미늄 발주서"

' ===== 함수 정의 영역 =====
Function SafeStr(val)
    On Error Resume Next
    If IsNull(val) Or IsEmpty(val) Then
        SafeStr = ""
    Else
        SafeStr = Trim(CStr(val))
    End If
    On Error GoTo 0
End Function
' ==========================


    page_name="TNG1_B_baljuST.asp?"

    rsjcidx=request("cidx") '발주처idx
    rsjcidx=request("sjcidx") '발주처idx 
    rsjmidx=request("sjmidx") '거래처담당자idx
    rsjidx=request("sjidx") '수주idx
    rsjsidx=request("sjsidx") '품목idx


SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & " balju_st_idx, sjidx, fkidx, bfidx, baidx, baname, blength"
SQL = SQL & ", quan, xsize, ysize, sx1, sx2, sy1, sy2"
SQL = SQL & ", bachannel, bfimg, midx, mdate, cname, sjdate, sjnum"
SQL = SQL & ", cgaddr, cgdate, djcgdate, cgtype_text, qtyname, p_image, tw"
SQL = SQL & ", th, ow, oh, p_name, SJB_TYPE_NAME, f_name, st_quan"
SQL = SQL & ", ds_daesinaddr, yaddr, sjsidx, cidx, sjmidx, g_bogang, g_busok"
SQL = SQL & ", basidx, bassize, basdirection, accsize, idv, final, GREEM_F_A"
SQL = SQL & ", WHICHI_FIX, WHICHI_AUTO, T_Busok_name, TNG_Busok_images, TNG_Busok_idx, memo_text, bigo,yaddr1 "
SQL = SQL & ", fksidx, insert_flag,SJB_barlist ,dooryn_text "
SQL = SQL & ", T_Busok_name2, TNG_Busok_images2, TNG_Busok_idx2, T_Busok_name3, TNG_Busok_images3, TNG_Busok_idx3 "
SQL = SQL & ", set_name_FIX , set_name_AUTO "
SQL = SQL & " FROM tk_balju_st "
SQL = SQL & "WHERE sjidx='" & rsjidx & "' AND insert_flag = 1 "
'Response.write (SQL)&" tk_balju_st <br> "
Rs.open Sql,Dbcon
if not (Rs.EOF or Rs.BOF ) then

    balju_st_idx   = Rs(0)   ' 발주 고유번호 (PK)
    sjidx          = Rs(1)   ' 수주 IDX
    fkidx          = Rs(2)   ' 프레임 IDX
    bfidx          = Rs(3)   ' 자재 IDX
    baidx          = Rs(4)   ' 바 IDX
    baname         = Rs(5)   ' 자재명
    blength        = Rs(6)   ' 길이
    quan           = Rs(7)   ' 수량
    xsize          = Rs(8)   ' X사이즈
    ysize          = Rs(9)   ' Y사이즈
    sx1            = Rs(10)  ' 시작X1
    sx2            = Rs(11)  ' 시작X2
    sy1            = Rs(12)  ' 시작Y1
    sy2            = Rs(13)  ' 시작Y2
    bachannel      = Rs(14)  ' 채널명
    bfimg          = Rs(15)  ' 자재 이미지
    midx           = Rs(16)  ' 등록자 IDX
    mdate          = Rs(17)  ' 등록일자
    cname          = Rs(18)  ' 발주처
    sjdate         = Rs(19)  ' 수주일자
    sjnum          = Rs(20)  ' 수주번호
    cgaddr         = Rs(21)  ' 현장명
    cgdate         = Rs(22)  ' 출고일자
    djcgdate       = Rs(23)  ' 도장출고일자
    cgtype_text    = Rs(24)  ' 출고구분 텍스트
    qtyname        = Rs(25)  ' 수량단위명
    p_image        = Rs(26)  ' 제품 이미지
    tw             = Rs(27)  ' 전체가로
    th             = Rs(28)  ' 전체세로
    ow             = Rs(29)  ' 오픈가로
    oh             = Rs(30)  ' 오픈세로
    p_name         = Rs(31)  ' 제품명
    SJB_TYPE_NAME  = Rs(32)  ' 수주타입명
    f_name         = Rs(33)  ' 프레임명
    st_quan        = Rs(34)  ' ST 수량
    ds_daesinaddr  = Rs(35)  ' 대신주소
    yaddr          = Rs(36)  ' 용차주소
    sjsidx         = Rs(37)  ' 수주서IDX
    cidx           = Rs(38)  ' 고객 IDX
    sjmidx         = Rs(39)  ' 수주자 IDX
    g_bogang       = Rs(40)  ' 보강여부
    g_busok        = Rs(41)  ' 부속여부
    basidx         = Rs(42)  ' BAS IDX
    bassize        = Rs(43)  ' BAS 크기
    basdirection   = Rs(44)  ' BAS 방향
    accsize        = Rs(45)  ' 부속 사이즈
    idv            = Rs(46)  ' 구분값
    final          = Rs(47)  ' 최종 여부
    GREEM_F_A      = Rs(48)  ' 자동/수동 구분
    WHICHI_FIX     = Rs(49)  ' FIX 구분
    WHICHI_AUTO    = Rs(50)  ' AUTO 구분
    T_Busok_name   = Rs(51)  ' 부속명
    TNG_Busok_images = Rs(52)' 부속 이미지
    TNG_Busok_idx  = Rs(53)  ' 부속 IDX
    memo_text           = Rs(54)  ' 메모
    bigo           = Rs(55)  ' 비고
    fksidx         = Rs(56)  ' FrameKSub IDX
    insert_flag    = Rs(57)  ' 인서트 여부 플래그
    yaddr1          = Rs(58)  ' 용차주소1
    SJB_barlist     = Rs(59)  ' 수주타입바리스트
    dooryn_text     = Rs(60)  ' 도와인여부 텍스트
    T_Busok_name2   = Rs(61)  ' 부속명2
    TNG_Busok_images2 = Rs(62)' 부속 이미지2
    TNG_Busok_idx2  = Rs(63)  ' 부속 IDX2
    T_Busok_name3   = Rs(64)  ' 부속명3
    TNG_Busok_images3 = Rs(65)' 부속 이미지3
    TNG_Busok_idx3  = Rs(66)  ' 부속 IDX3
    set_name_FIX    = Rs(67)  ' FIXSetName
    set_name_AUTO   = Rs(68)  ' AUTOSetName
%>
<%
End if
Rs.close
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title><%=projectname%></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

    <style>
    @page {
    size: A4 portrait;
    margin-top: 10mm;
    margin-left: 8mm;
    margin-right: 8mm;
    margin-bottom: 10mm;
    }

    @media print {
        body {
        -webkit-print-color-adjust: exact !important;
        print-color-adjust: exact !important;
        margin: 0;
        padding: 0;
        background: white;
        }
        .no-print {
        display: none !important;
        }
    }

    body, #pdfArea {
        font-family: "맑은 고딕", "Malgun Gothic", Arial, sans-serif;
        font-size: 10.5pt;
        color: #000;
        box-sizing: border-box;
    }

    /* === 출력 전체 영역 === */
    #pdfArea {
    width: 210mm;
    min-height: 297mm;
    margin: 0 auto;
    padding-top: 10mm;
    background: #fff;
    box-sizing: border-box;
    }

    /* === Bootstrap row 기본 보정 === */
    .row {
        display: flex;
        flex-wrap: wrap; /* ✅ 줄바꿈 허용 */
        margin-left: 0 !important;
        margin-right: 0 !important;
        width: 100%;
    }

    /* === column 정렬 === */
    .col, [class^="col-"] {
        flex: 1;
        padding: 0.5mm !important;
        margin: 0;
        box-sizing: border-box;
        overflow: hidden;
    }

    /* === 테두리 === */
    .row > .col {
        border: 0.2mm solid #ddd;
    }

    /* === 헤더 === */
    .header-box {
        background: #c0c0c0;
        padding: 2mm;
        margin-bottom: 2mm;
        border-radius: 0;
    }

    /* === 이미지 제한 === */
    img {
        max-width: 100%;
        height: auto;
        display: block;
    }

    /* === 작은 행 간격 통일 === */
    .mb-1, .mb-2 {
        margin-bottom: 1mm !important;
    }

    /* === 발주서 헤더 전용 정렬 === */
    .header-wrap {
    width: 100%;
    display: block;
    background: #f8f8f8;
    border: 0.2mm solid #ccc;
    border-radius: 0;
    box-sizing: border-box;
    margin-bottom: 2mm;
    }

    .header-row {
    display: flex;
    width: 100%;
    flex-wrap: nowrap;
    border-bottom: 0.2mm solid #ddd;
    box-sizing: border-box;
    }

    .header-row:last-child {
    border-bottom: none;
    }

    .header-col {
    flex: 1 1 25%;             /* ✅ 4등분 정확히 */
    padding: 1.5mm 2mm;
    box-sizing: border-box;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    border-right: 0.2mm solid #ddd;
    }

    .header-col:last-child {
    border-right: none;
    }

    /* ✅ 각 자재 블록 페이지 분리 */
    .barasi-card {
    width: 100%;
    border: 0.3mm solid #bbb;
    margin-bottom: 2mm;
    box-sizing: border-box;
    page-break-inside: avoid !important;
    page-break-after: auto !important;
    break-after: auto !important;
    }

    .barasi-card:last-child {
    page-break-after: auto;
    break-after: auto;
    }

    .barasi-header {
    display: flex;
    background: #fff9c4;
    border-bottom: 0.3mm solid #bbb;
    text-align: center;
    }

    .barasi-header .cell {
    flex: 1 1 25%;
    padding: 1mm;
    box-sizing: border-box;
    }

    .barasi-body {
    display: flex;
    width: 100%;
    background: #f4f4f4;
    box-sizing: border-box;
    }

    .barasi-body .cell {
    padding: 2mm;
    box-sizing: border-box;
    border-right: 0.2mm solid #ccc;
    text-align: center;
    vertical-align: middle;
    }

    .barasi-body .cell:last-child {
    border-right: none;
    }

    .barasi-body .img {
    flex: 0 0 20%;
    }

    .barasi-body .info {
    flex: 1 1 60%;
    }

    .barasi-body .length {
    flex: 0 0 20%;
    background: #fff9c4;
    }

    .busok-names {
    display: flex;
    justify-content: space-between;
    margin-bottom: 2mm;
    gap: 2mm;
    }

    .busok-names > div {
    flex: 1;
    text-align: center;
    word-break: break-all;      /* ✅ 긴 영어도 줄바꿈 */
    white-space: normal;        /* ✅ 줄바꿈 허용 */
    overflow: hidden;           /* ✅ 영역 밖 글자 자르기 */
    line-height: 1.1;
    font-size: 9pt;             /* ✅ 기본 폰트 */
    max-height: 2.5em;          /* ✅ 두 줄까지만 표시 */
    }

    .busok-images {
    display: flex;
    justify-content: space-between;
    align-items: center;   /* ✅ 세로 중앙 정렬 */
    gap: 2mm;
    width: 100%;
    }

    .busok-images > * {
    flex: 1 1 0;           /* ✅ 균등 3등분 */
    text-align: center;
    max-width: 33%;
    box-sizing: border-box;
    }

    .busok-images img {
    max-width: 25mm;
    max-height: 20mm;
    object-fit: contain;
    border: 1px solid #ccc;
    border-radius: 2mm;
    display: block;
    margin: 0 auto;
    }

    .busok-images div {
    height: 20mm;
    line-height: 20mm;
    color: #bbb;
    font-size: 9pt;
    border: 1px dashed #ddd;
    border-radius: 2mm;
    }


    </style>
    <style>
    .section{ margin-top: var(--gap-y); }
    .no-break{ break-inside: avoid; page-break-inside: avoid; }
    /* 도면 박스 (얇게) */
    .drawing.wrap,
    .drawing .wrap {
    border: var(--bdw) solid var(--bdc);
    padding: 3mm;
    border-radius: 2px;
    background: #fff;
    }
    .page-break {
    page-break-after: always;
    break-after: always;
    }
    </style>
    <style>
    /* ===============================
   ✅ 인쇄 전용 푸터 (정리된 최신 버전)
=================================*/
:root {
  --print-footer-h: 14mm; /* 푸터 높이(mm) */
}

@page {
  size: A4 portrait;
  margin-bottom: calc(10mm + var(--print-footer-h));
  margin-top: 10mm;
  margin-left: 8mm;
  margin-right: 8mm;

  /* ✅ 최신 Chrome/Safari용 페이지 번호 */
  @bottom-right {
    content: "Page " counter(page) " / " counter(pages);
    font-size: 10pt;
    color: #333;
  }
}

/* 기본적으로 화면에서는 숨김 */
.print-footer {
  display: none;
}

@media print {
  body {
    -webkit-print-color-adjust: exact !important;
    print-color-adjust: exact !important;
  }

  /* 푸터 고정 */
  .print-footer {
    display: block !important;
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    width: 100%;
    text-align: center;
    font-size: 10pt;
    color: #000;
    border-top: 0.2mm solid #aaa;
    padding-top: 2mm;
    background: #fff;
    z-index: 9999;
    height: var(--print-footer-h);
    box-sizing: border-box;
  }

  /* 본문 내용이 푸터와 겹치지 않게 하단 여백 확보 */
  #pdfArea {
    padding-bottom: var(--print-footer-h);
  }

  /* 수동 페이지 번호 (대체용, counter 동작 안 할 경우 대비) */
  .print-footer .pageNumber::after {
    content: counter(page) " / " counter(pages);
  }
}

    </style>
<!-- ✅ 도면용 스크립트 -->
</head>
<body class="sb-nav-fixed">

    <div id="layoutSidenav_content">
        <main>
    <!-- 헤더 -->
            <div class="text-end mb-2 no-print">
                <button type="button" class="btn btn-outline-primary btn-sm" onclick="exportPDF()">
                    PDF 저장 (A4 세로)
                </button>
            </div>

            <div id="pdfArea" class="container-fluid"
                style="background-color:#ffffff; border-radius:8px;">
                <div class="d-flex justify-content-between align-items-center fw-bold fs-5 mb-2">
                    <div>알루미늄 발주서</div>
                    <div>
                        <%=Year(Now())%>-<%=Right("0" & Month(Now()),2)%>-<%=Right("0" & Day(Now()),2)%>
                        (<%=Left(WeekdayName(Weekday(Now()), False, 1),1)%>)
                        <%=Right("0" & Hour(Now()),2)%>:<%=Right("0" & Minute(Now()),2)%>
                    </div>
                </div>
                <!-- 🧾 발주서 헤더 -->
                <div class="header-wrap page-break">
                    <%
                        p=0
                        SQL = ""
                        SQL = SQL & "SELECT * FROM ("
                        SQL = SQL & " SELECT "
                        SQL = SQL & "  balju_st_idx, sjidx, fkidx, bfidx, baidx, baname, blength,"
                        SQL = SQL & "  quan, xsize, ysize, sx1, sx2, sy1, sy2,"
                        SQL = SQL & "  bachannel, bfimg, midx, mdate, cname, sjdate, sjnum,"
                        SQL = SQL & "  cgaddr, cgdate, djcgdate, cgtype_text, qtyname, p_image, tw,"
                        SQL = SQL & "  th, ow, oh, p_name, SJB_TYPE_NAME, f_name, st_quan,"
                        SQL = SQL & "  ds_daesinaddr, yaddr, sjsidx, cidx, sjmidx, g_bogang, g_busok,"
                        SQL = SQL & "  basidx, bassize, basdirection, accsize, idv, final, GREEM_F_A,"
                        SQL = SQL & "  WHICHI_FIX, WHICHI_AUTO, T_Busok_name, TNG_Busok_images, TNG_Busok_idx,"
                        SQL = SQL & "  memo_text, bigo, yaddr1, fksidx, insert_flag, SJB_barlist, dooryn_text,"
                        SQL = SQL & "  ROW_NUMBER() OVER (PARTITION BY sjidx, sjsidx ORDER BY balju_st_idx ASC) AS rn"
                        SQL = SQL & " FROM tk_balju_st"
                        SQL = SQL & " WHERE sjidx='" & rsjidx & "' AND insert_flag=1"
                        SQL = SQL & ") t WHERE rn=1"
                        SQL = SQL & " ORDER BY sjidx, sjsidx"
                        'Response.write (SQL)&" tk_balju_st <br> "
                        Rs.open Sql,Dbcon
                        if not (Rs.EOF or Rs.BOF ) then
                        Do while not Rs.EOF

                            balju_st_idx   = Rs(0)   ' 발주 고유번호 (PK)
                            sjidx          = Rs(1)   ' 수주 IDX
                            fkidx          = Rs(2)   ' 프레임 IDX
                            bfidx          = Rs(3)   ' 자재 IDX
                            baidx          = Rs(4)   ' 바 IDX
                            baname         = Rs(5)   ' 자재명
                            blength        = Rs(6)   ' 길이
                            quan           = Rs(7)   ' 수량
                            xsize          = Rs(8)   ' X사이즈
                            ysize          = Rs(9)   ' Y사이즈
                            sx1            = Rs(10)  ' 시작X1
                            sx2            = Rs(11)  ' 시작X2
                            sy1            = Rs(12)  ' 시작Y1
                            sy2            = Rs(13)  ' 시작Y2
                            bachannel      = Rs(14)  ' 채널명
                            bfimg          = Rs(15)  ' 자재 이미지
                            midx           = Rs(16)  ' 등록자 IDX
                            mdate          = Rs(17)  ' 등록일자
                            cname          = Rs(18)  ' 발주처
                            sjdate         = Rs(19)  ' 수주일자
                            sjnum          = Rs(20)  ' 수주번호
                            cgaddr         = Rs(21)  ' 현장명
                            cgdate         = Rs(22)  ' 출고일자
                            djcgdate       = Rs(23)  ' 도장출고일자
                            cgtype_text    = Rs(24)  ' 출고구분 텍스트
                            qtyname        = Rs(25)  ' 수량단위명
                            p_image        = Rs(26)  ' 제품 이미지
                            tw             = Rs(27)  ' 전체가로
                            th             = Rs(28)  ' 전체세로
                            ow             = Rs(29)  ' 오픈가로
                            oh             = Rs(30)  ' 오픈세로
                            p_name         = Rs(31)  ' 제품명
                            SJB_TYPE_NAME  = Rs(32)  ' 수주타입명
                            f_name         = Rs(33)  ' 프레임명
                            st_quan        = Rs(34)  ' ST 수량
                            ds_daesinaddr  = Rs(35)  ' 대신주소
                            yaddr          = Rs(36)  ' 용차주소
                            sjsidx_svg     = Rs(37)  ' 수주서IDX
                            cidx           = Rs(38)  ' 고객 IDX
                            sjmidx         = Rs(39)  ' 수주자 IDX
                            g_bogang       = Rs(40)  ' 보강여부
                            g_busok        = Rs(41)  ' 부속여부
                            basidx         = Rs(42)  ' BAS IDX
                            bassize        = Rs(43)  ' BAS 크기
                            basdirection   = Rs(44)  ' BAS 방향
                            accsize        = Rs(45)  ' 부속 사이즈
                            idv            = Rs(46)  ' 구분값
                            final          = Rs(47)  ' 최종 여부
                            GREEM_F_A      = Rs(48)  ' 자동/수동 구분
                            WHICHI_FIX     = Rs(49)  ' FIX 구분
                            WHICHI_AUTO    = Rs(50)  ' AUTO 구분
                            T_Busok_name   = Rs(51)  ' 부속명
                            TNG_Busok_images = Rs(52)' 부속 이미지
                            TNG_Busok_idx  = Rs(53)  ' 부속 IDX
                            memo_text           = Rs(54)  ' 메모
                            bigo           = Rs(55)  ' 비고
                            fksidx         = Rs(56)  ' FrameKSub IDX
                            insert_flag    = Rs(57)  ' 인서트 여부 플래그
                            yaddr1          = Rs(58)  ' 용차주소1
                            SJB_barlist     = Rs(59)  ' 수주타입바리스트
                            dooryn_text     = Rs(60)  ' 도와인여부 텍스트

                            p=p+1
                        %>   
                    <div class="header-row">
                        <div class="header-col">발주처: <%=cname%></div>
                        <div class="header-col">수주일자: <%=sjdate%></div>
                        <div class="header-col">수주번호: <%=sjnum%> : <%=p%>번</div>
                        
                    </div>
                    <div class="header-row">
                        <div class="header-col">현장명: <%=cgaddr%></div>
                        <div class="header-col">출고일자: <%=cgdate%></div>
                        <div class="header-col">도장출고일자: <%=djcgdate%></div>
                    </div>
                    <div class="header-row">
                        <div class="header-col">출고방식: <%=cgtype_text%></div>
                        <% if cgtype_text = "용차" then %>
                        <div class="header-col">출고지: <%=yaddr%><%=yaddr1%></div>
                        <% elseif cgtype_text = "화물" then %>
                        <div class="header-col">대신화물: <%=ds_daesinaddr%></div>
                        <% else %>
                        <div class="header-col"></div>
                        <% end if %>
                        <div class="header-col">재질명: <%=qtyname%></div>
                    </div>

                    <div class="header-row">
                        <div class="header-col">도장재질명: <%=p_name%></div>
                        <div class="header-col">
                            <% If p_image <> "" Then %>
                                <img src="/img/paint/<%=p_image%>" loading="lazy"
                                    style="width:100%; max-width:45mm; height:auto; border:1px solid #ccc; border-radius:2mm;"
                                    onerror="this.style.display='none'">
                            <% End If %>
                        </div>
                        <div class="header-col"><%=SJB_barlist%>_<%=SJB_TYPE_NAME%></div>
                    </div>
                    <!-- ✅ 도면 표시 -->
                    <section class="section drawing wrap no-break">
                        <%
                            Session("autoSchema.sjidx")  = rsjidx
                            Session("autoSchema.sjsidx") = sjsidx_svg
                            Server.Execute "../schema/export/index.asp"
                        %>
                    </section>
                    <div class="page-break"></div>
                    <%
                        rs.MoveNext
                        Loop
                        End if
                        rs.Close
                    %>
                </div>

                <%
                loop_count = 0

                ' ======================
                ' 🔹 fkidx 그룹 1회만 루프
                ' ======================

                SQL = ""
                SQL = SQL & "SELECT "
                SQL = SQL & "    MIN(sjsidx) AS sjsidx, "        ' ✅ sjsidx 대표값
                SQL = SQL & "    MIN(fkidx) AS fkidx, "          ' ✅ fkidx 대표값
                SQL = SQL & "    bfidx, "
                SQL = SQL & "    MIN(baname) AS baname, "
                SQL = SQL & "    MIN(baidx) AS baidx, "
                SQL = SQL & "    MIN(g_bogang) AS g_bogang, "
                SQL = SQL & "    MIN(g_busok) AS g_busok, "
                SQL = SQL & "    MIN(bfimg) AS bfimg, "
                SQL = SQL & "    MIN(set_name_FIX) AS set_name_FIX, "
                SQL = SQL & "    MIN(set_name_AUTO) AS set_name_AUTO, "
                SQL = SQL & "    qtyname, "
                SQL = SQL & "    MIN(T_Busok_name) AS T_Busok_name, "
                SQL = SQL & "    MIN(TNG_Busok_images) AS TNG_Busok_images, "
                SQL = SQL & "    MIN(TNG_Busok_idx) AS TNG_Busok_idx, "
                SQL = SQL & "    MIN(T_Busok_name2) AS T_Busok_name2, "
                SQL = SQL & "    MIN(TNG_Busok_images2) AS TNG_Busok_images2, "
                SQL = SQL & "    MIN(TNG_Busok_idx2) AS TNG_Busok_idx2, "
                SQL = SQL & "    MIN(T_Busok_name3) AS T_Busok_name3, "
                SQL = SQL & "    MIN(TNG_Busok_images3) AS TNG_Busok_images3, "
                SQL = SQL & "    MIN(TNG_Busok_idx3) AS TNG_Busok_idx3, "
                SQL = SQL & "    MIN(WHICHI_AUTO) AS WHICHI_AUTO "
                SQL = SQL & "FROM tk_balju_st "
                SQL = SQL & "WHERE sjidx='" & rsjidx & "' AND insert_flag=1 "
                SQL = SQL & "GROUP BY bfidx, qtyname "
                SQL = SQL & "ORDER BY "
               '------------------------------------------------- 수정시작'
                SQL = SQL & "    CASE MIN(WHICHI_AUTO) "
                SQL = SQL & "        WHEN 1 THEN 1 "
                SQL = SQL & "        WHEN 2 THEN 2 "
                SQL = SQL & "        WHEN 3 THEN 3 "
                SQL = SQL & "        WHEN 6 THEN 4 "
                SQL = SQL & "        WHEN 7 THEN 5 "
                SQL = SQL & "        WHEN 10 THEN 6 "
                SQL = SQL & "        WHEN 4 THEN 7 "
                SQL = SQL & "        WHEN 5 THEN 8 "
                SQL = SQL & "        WHEN 8 THEN 9 "
                SQL = SQL & "        ELSE 10 "
                SQL = SQL & "    END, "
                SQL = SQL & "    MIN(sjsidx), qtyname, bfidx"
              '------------------------------------------------- 수정끝'
                'Response.Write (SQL) & "<br>"

                Rs1.Open SQL, Dbcon

                If Not (Rs1.BOF Or Rs1.EOF) Then
                    Do While Not Rs1.EOF

                        bfidx              = Rs1("bfidx")
                        fkidx              = Rs1("fkidx")
                        baname             = Rs1("baname")
                        baidx              = Rs1("baidx")
                        g_bogang           = Rs1("g_bogang")
                        g_busok            = Rs1("g_busok")
                        bfimg              = Rs1("bfimg")
                        set_name_FIX       = Rs1("set_name_FIX")
                        set_name_AUTO      = Rs1("set_name_AUTO")
                        qtyname            = Rs1("qtyname")
                        T_Busok_name       = Rs1("T_Busok_name")
                        TNG_Busok_images   = Rs1("TNG_Busok_images")
                        TNG_Busok_idx      = Rs1("TNG_Busok_idx")
                        T_Busok_name2      = Rs1("T_Busok_name2")
                        TNG_Busok_images2  = Rs1("TNG_Busok_images2")
                        TNG_Busok_idx2     = Rs1("TNG_Busok_idx2")
                        T_Busok_name3      = Rs1("T_Busok_name3")
                        TNG_Busok_images3  = Rs1("TNG_Busok_images3")
                        TNG_Busok_idx3     = Rs1("TNG_Busok_idx3")
                        WHICHI_AUTO        = Rs1("WHICHI_AUTO")

                        loop_count = loop_count + 1

                        ' ==========================
                        ' 🔹 그룹별 대표 정보 출력
                        ' ==========================
                ' ==================================
                ' 🔹 이 fkidx에 속한 bfidx 세부 루프 (barasi, SVG 포함)
                ' ==================================
                %>
                <!-- 🔹 자재 블록 (개선 버전) -->
                <div class="barasi-card">
                    <!-- 상단 헤더 라인 -->
                    <div class="barasi-header">
                        <div class="cell num"><%=loop_count%></div>
                        <div class="cell name">
                        <% if set_name_FIX <> "" then %>
                            <%=set_name_FIX%>
                        <% else %>
                            <%=set_name_AUTO%>
                        <% end if %>
                        </div>
                        <div class="cell qty"><%=qtyname%></div>
                        <div class="cell title">길이</div>
                    </div>

                    <!-- 본문 라인 -->
                    <div class="barasi-body">
                        <!-- 🔹 좌측 이미지 -->
                        <div class="cell img">
                            <% If bfimg <> "" Then %>
                                <img src="/img/frame/bfimg/<%=bfimg%>" 
                                    style="width:100%; max-width:55mm; max-height:60mm; object-fit:contain; border:1px solid #ddd;"
                                    onerror="this.style.display='none'">
                            <% End If %>
                        </div>

                        <!-- 🔹 중앙 부속명 / 부속 이미지 -->
                        <div class="cell info">
                            <!-- 상단 이름 -->
                            <div class="busok-names">
                                <div><%=T_Busok_name%></div>
                                <div><%=T_Busok_name2%></div>
                                <div><%=T_Busok_name3%></div>
                            </div>

                            <!-- 하단 이미지 -->
                            <div class="busok-images">
                                <% If TNG_Busok_images <> "" Then %>
                                <img src="/img/frame/bfimg/<%=TNG_Busok_images%>">
                                <% Else %>
                                <div>-</div>
                                <% End If %>
                                <% If TNG_Busok_images2 <> "" Then %>
                                <img src="/img/frame/bfimg/<%=TNG_Busok_images2%>">
                                <% Else %>
                                <div>-</div>
                                <% End If %>
                                <% If TNG_Busok_images3 <> "" Then %>
                                <img src="/img/frame/bfimg/<%=TNG_Busok_images3%>">
                                <% Else %>
                                <div>-</div>
                                <% End If %>
                            </div>
                        </div>

                        <!-- 🔹 우측 길이 정보 -->
                        <div class="cell length">
                            <% 
                            SQL = ""
                            SQL = SQL & "WITH base AS ( "
                            SQL = SQL & "  SELECT DISTINCT sjidx, sjsidx, fkidx, fksidx, bfidx, qtyname, blength, quan, "
                            SQL = SQL & "  WHICHI_FIX, WHICHI_AUTO, rot_type "
                            SQL = SQL & "  FROM tk_balju_st WHERE sjidx='" & rsjidx & "' AND insert_flag=1 "
                            SQL = SQL & "), rank_s AS ( "
                            SQL = SQL & "  SELECT sjsidx, DENSE_RANK() OVER (ORDER BY sjsidx) AS sjsidx_order "
                            SQL = SQL & "  FROM (SELECT DISTINCT sjsidx FROM base) d "
                            SQL = SQL & "), grp AS ( "
                            SQL = SQL & "  SELECT t.sjsidx, t.bfidx, t.qtyname, CAST(t.blength AS FLOAT) AS blength, "
                            SQL = SQL & "  COUNT(DISTINCT t.fksidx) AS same_xy_count, MIN(t.quan) AS quan, "
                            SQL = SQL & "  MIN(t.WHICHI_FIX) AS WHICHI_FIX, MIN(t.WHICHI_AUTO) AS WHICHI_AUTO, MIN(t.rot_type) AS rot_type "
                            SQL = SQL & "  FROM base t WHERE t.bfidx='" & bfidx & "' AND t.qtyname='" & qtyname & "' "
                            SQL = SQL & "  GROUP BY t.sjsidx, t.bfidx, t.qtyname, t.blength "
                            SQL = SQL & ") "
                            SQL = SQL & "SELECT r.sjsidx_order, g.blength, g.same_xy_count, g.quan, g.WHICHI_FIX, g.WHICHI_AUTO, g.rot_type "
                            SQL = SQL & "FROM grp g JOIN rank_s r ON r.sjsidx=g.sjsidx "
                            SQL = SQL & "ORDER BY r.sjsidx_order, g.blength"
                           ' Response.write (SQL)&" 길이컬럼<br>"
                            Rs.open Sql,Dbcon
                            if not (Rs.EOF or Rs.BOF ) then
                                Do while not Rs.EOF
                                sjsidx_order = Rs("sjsidx_order")
                                blength = Rs("blength")
                                same_xy_count = Rs("same_xy_count")
                                quan = Rs("quan")
                                WHICHI_FIX = Rs("WHICHI_FIX")
                                WHICHI_AUTO = Rs("WHICHI_AUTO")
                                rot_type = Rs("rot_type")
                                total_quan = quan * same_xy_count

                                blength_1= blength-2
                                
                                Select Case WHICHI_AUTO
                                    Case 2,11,20,21,22,23,28,29
                                        blength_1 = blength
                                    Case Else
                                        blength_1= blength-2
                                End Select
                            %>
                            <% if WHICHI_FIX = 4 or WHICHI_FIX = 22 then %>
                                <div><%=sjsidx_order%>번 <%=blength_1%>mm = <%=total_quan%>개 롯트:<%=rot_type%></div>
                            <% else %>
                                <div><%=sjsidx_order%>번 <%=blength_1%>mm = <%=total_quan%>개</div>
                            <% end if %>
                            <% 
                                Rs.movenext
                                Loop
                            end if
                            Rs.close
                            %>
                        </div>
                    </div>
                </div>
                
                <%
                Rs1.movenext
                Loop
                End if
                Rs1.close
                %>

            </div>
            <div class="print-footer">
            발주처: <%=cname%> │ 재질명: <%=qtyname%> │ 도장재질명: <%=p_name%> │ 출고일자: <%=cgdate%> 
            </div>
        </main>
    </div>
    <script src="/js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/svg-pan-zoom@3.6.1/dist/svg-pan-zoom.min.js"></script>

<!-- 도면 수치 표현 모듈 (data-value/data-type 사용) -->
<script src="/schema/total.js"></script>
<script src="/schema/horizontal.js"></script>
<script src="/schema/vertical.js"></script>
<script src="/schema/intergrate.js"></script>
<script>
/** SVG를 내부 그룹(#viewport)의 바운딩박스에 딱 맞게 조정 + 다수 일괄 적용 + 텍스트 역스케일 보정 */
(function (root) {
  // (원본 그대로) CTM 적용 bbox
  function getTransformedBBox(el) {
    const bb = el.getBBox();
    const m  = el.getCTM();
    if (!m) return { x: bb.x, y: bb.y, width: bb.width, height: bb.height };

    const P = (x, y) =>
      (window.DOMPoint
        ? new DOMPoint(x, y).matrixTransform(m)
        : (function(){
            const pt = el.ownerSVGElement.createSVGPoint();
            pt.x = x; pt.y = y; return pt.matrixTransform(m);
          })());

    const p1 = P(bb.x, bb.y);
    const p2 = P(bb.x + bb.width, bb.y);
    const p3 = P(bb.x, bb.y + bb.height);
    const p4 = P(bb.x + bb.width, bb.y + bb.height);

    const xs = [p1.x, p2.x, p3.x, p4.x];
    const ys = [p1.y, p2.y, p3.y, p4.y];
    const minX = Math.min.apply(null, xs);
    const maxX = Math.max.apply(null, xs);
    const minY = Math.min.apply(null, ys);
    const maxY = Math.max.apply(null, ys);

    return { x: minX, y: minY, width: maxX - minX, height: maxY - minY };
  }

  // 화면 px / SVG 유닛 비율(대략치) — 회전 포함 평균 스케일
  function getPPU(svg) {
    const m = svg.getScreenCTM && svg.getScreenCTM();
    if (!m) return 1;
    const sx = Math.hypot(m.a, m.b);
    const sy = Math.hypot(m.c, m.d);
    return (sx + sy) / 2 || 1;
  }

  /**
   * 단일 SVG를 단일 그룹에 맞춤
   */
  function fitSvgToGroup(svgId='canvas', groupId='viewport', { padding=0, setSize=true, pxPerUnit=1, preserve='xMinYMin meet' } = {}) {
    const svg = document.getElementById(svgId);
    const g   = document.getElementById(groupId);
    if (!svg || !g) return;

    const bb = getTransformedBBox(g);
    const x = bb.x - padding;
    const y = bb.y - padding;
    const w = Math.max(0.0001, bb.width  + padding * 2);
    const h = Math.max(0.0001, bb.height + padding * 2);

    svg.setAttribute('viewBox', `${x} ${y} ${w} ${h}`);
    svg.setAttribute('preserveAspectRatio', preserve);

    if (setSize) {
      svg.style.width  = (w * pxPerUnit) + 'px';
      svg.style.height = (h * pxPerUnit) + 'px';
    } else {
      svg.style.removeProperty('width');
      svg.style.removeProperty('height');
    }

    return { x, y, width: w, height: h };
  }

  // 텍스트 역스케일 보정
  function compensateTexts(svg, groups, factor, {
    selector = 'text, .dim-text, .label',
    method   = 'transform',         // 'transform' | 'fontSize'
    minScale = 0.75,
    maxScale = 3.0
  } = {}) {
    if (!factor || factor === 1) return;

    // 클램프
    const f = Math.max(minScale, Math.min(maxScale, factor));

    // 대상 텍스트 수집(여러 그룹 합집합)
    const nodes = [];
    for (const g of groups) nodes.push(...g.querySelectorAll(selector));
    if (!nodes.length) return;

    if (method === 'transform') {
      // 좌표는 그대로 두고 글자만 확대/축소
      nodes.forEach(el => {
        el.style.transformBox = 'fill-box';
        el.style.transformOrigin = 'center';
        // 누적되지 않도록 이전 스케일 제거 후 적용
        const prev = el.__svgfitScale || 1;
        const next = f;
        // 기존 스케일을 덮어씌우기 위해 transform 문자열 재조합(간단 버전: scale만 관리)
        el.style.transform = `scale(${next})`;
        el.__svgfitScale = next;
      });
    } else if (method === 'fontSize') {
      // 폰트 크기를 직접 변경(상황에 따라 레이아웃이 달라질 수 있음)
      nodes.forEach(el => {
        const cs = window.getComputedStyle(el);
        const basePx = parseFloat(cs.fontSize) || 12;
        const target = basePx * f;
        el.style.fontSize = target + 'px';
      });
    }
  }

  /**
   * 문서 내 중복 id까지 고려, 모든 #canvas들에 대해 내부 #viewport 기준으로 일괄 맞춤
   * options:
   *  - padding, setSize, pxPerUnit, preserve, mode('first'|'union'), index
   *  - textCompensate: {
   *        enable: true,
   *        selector: 'text, .dim-text, .label',
   *        strength: 1.0,           // 1.0=축소만큼 정확히 키움(화면상 크기 유지), >1이면 더 키움
   *        method: 'transform',     // 'transform' 권장
   *        minScale: 0.75,
   *        maxScale: 3.0
   *    }
   */
  function fitAllById(svgId='canvas', groupId='viewport', {
    padding=0, setSize=true, pxPerUnit=1,
    preserve='xMinYMin meet', mode='first', index=0,
    textCompensate = { enable:false }
  } = {}) {
    const svgs = Array.from(document.querySelectorAll(`svg[id="${svgId}"]`));
    const results = [];

    for (const svg of svgs) {
      const groups = Array.from(svg.querySelectorAll(`[id="${groupId}"]`));
      if (!groups.length) continue;

      const ppuBefore = getPPU(svg);

      let targetBox;
      if (mode === 'union') {
        const boxes = groups.map(g => getTransformedBBox(g));
        const minX = Math.min(...boxes.map(b => b.x));
        const minY = Math.min(...boxes.map(b => b.y));
        const maxX = Math.max(...boxes.map(b => b.x + b.width));
        const maxY = Math.max(...boxes.map(b => b.y + b.height));
        targetBox = { x: minX, y: minY, width: Math.max(0.0001, maxX - minX), height: Math.max(0.0001, maxY - minY) };
      } else {
        const i = Math.max(0, Math.min(groups.length - 1, Number(index) || 0));
        targetBox = getTransformedBBox(groups[i]);
      }

      const x = targetBox.x - padding;
      const y = targetBox.y - padding;
      const w = Math.max(0.0001, targetBox.width  + padding * 2);
      const h = Math.max(0.0001, targetBox.height + padding * 2);

      svg.setAttribute('viewBox', `${x} ${y} ${w} ${h}`);
      svg.setAttribute('preserveAspectRatio', preserve);

      if (setSize) {
        svg.style.width  = (w * pxPerUnit) + 'px';
        svg.style.height = (h * pxPerUnit) + 'px';
      } else {
        svg.style.removeProperty('width');
        svg.style.removeProperty('height');
      }

      // 텍스트 역보정(레이아웃 반영 후 계산)
      if (textCompensate && textCompensate.enable) {
        requestAnimationFrame(() => {
          const ppuAfter = getPPU(svg);
          // f = (축소 비율)의 역수 -> 화면상 글자크기 유지/증가
          const raw = (ppuBefore && ppuAfter) ? (ppuBefore / ppuAfter) : 1;
          const strength = Math.max(0, Number(textCompensate.strength ?? 1));
          const factor = Math.pow(raw, strength);

          compensateTexts(svg, groups, factor, {
            selector: textCompensate.selector || 'text, .dim-text, .label',
            method: textCompensate.method || 'transform',
            minScale: textCompensate.minScale ?? 0.75,
            maxScale: textCompensate.maxScale ?? 3.0
          });
        });
      }

      results.push({ svg, groups: groups.length, width: w, height: h, mode });
    }

    return results;
  }

  root.SVGFit = { fitSvgToGroup, fitAllById };
})(window);

// === 사용 예시 ===
// 모든 #canvas 들을 #viewport 기준으로 맞추되, 축소된 만큼 글자를 키워 화면 가독성을 유지/강화
document.addEventListener('DOMContentLoaded', () => {
  SVGFit.fitAllById('canvas', 'viewport', {
    padding: 20,
    setSize: false,          // true이면 pxPerUnit로 고정 px 크기 설정
    pxPerUnit: 1,
    mode: 'first',
    index: 0,
    textCompensate: {
      enable: true,
      selector: 'text, .dim-text, .label',
      strength: 1.0,         // 1.0 = 화면상 텍스트 크기 ‘유지’, 1.2처럼 올리면 축소 시 더 크게
      method: 'transform',   // 좌표 유지+글자만 확대, 가장 안전
      minScale: 0.8,
      maxScale: 2.5
    }
  });
});
</script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        document.querySelectorAll("svg[id^='mySVG']").forEach(svg => {
            const group = document.createElementNS("http://www.w3.org/2000/svg", "g");
            Array.from(svg.children).forEach(child => group.appendChild(child));
            svg.appendChild(group);

            const lines = group.querySelectorAll("line");
            const texts = group.querySelectorAll("text");
            if (!lines.length && !texts.length) return;

            // === 1️⃣ 전체 좌표 범위 계산 ===
            let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
            [...lines, ...texts].forEach(el => {
                const x1 = parseFloat(el.getAttribute("x1")) || parseFloat(el.getAttribute("x"));
                const y1 = parseFloat(el.getAttribute("y1")) || parseFloat(el.getAttribute("y"));
                const x2 = parseFloat(el.getAttribute("x2"));
                const y2 = parseFloat(el.getAttribute("y2"));
                if (!isNaN(x1)) minX = Math.min(minX, x1);
                if (!isNaN(y1)) minY = Math.min(minY, y1);
                if (!isNaN(x2)) maxX = Math.max(maxX, x2);
                if (!isNaN(y2)) maxY = Math.max(maxY, y2);
                if (isNaN(x2) && !isNaN(x1)) maxX = Math.max(maxX, x1);
                if (isNaN(y2) && !isNaN(y1)) maxY = Math.max(maxY, y1);
            });

            // === 2️⃣ 크기 및 비율 계산 ===
            const width = maxX - minX;
            const height = maxY - minY;
            const maxDim = Math.max(width, height);
            const targetSize = 100;

            let paddingRatio = 1.2;
            if (maxDim > 200) paddingRatio = 1.3;
            if (maxDim > 400) paddingRatio = 1.4;
            if (maxDim > 800) paddingRatio = 1.5;

            const scale = targetSize / (maxDim * paddingRatio);

            // === 3️⃣ 중심점 이동 ===
            const cx = (minX + maxX) / 2;
            const cy = (minY + maxY) / 2;
            const translateX = (targetSize / 2) - (cx * scale);
            const translateY = (targetSize / 2) - (cy * scale);
            group.setAttribute("transform", `translate(${translateX},${translateY}) scale(${scale})`);

            // === 4️⃣ stroke 보정 ===
            const strokeWidth = Math.max(0.4, Math.min(2.5, 1 / scale));
            lines.forEach(l => l.setAttribute("stroke-width", strokeWidth));

            // === 5️⃣ bassize(텍스트 숫자) 파싱 ===
            function parseBassizeText(txt){
                const cleaned = (txt || "").toString().replace(/[^0-9.\-]/g, "");
                const v = parseFloat(cleaned);
                return isNaN(v) ? null : v;
            }

            // === 6️⃣ bassize 최대값 계산 ===
            let maxLineLength = 0;
            const debugVals = [];
            texts.forEach(t => {
                const v = parseBassizeText(t.textContent);
                if (v !== null) {
                    debugVals.push(v);
                    if (v > maxLineLength) maxLineLength = v;
                }
            });

            // === 7️⃣ 기본 폰트 크기 계산 ===
            let fontScale = 1 / (scale * 0.6);
            let fontSize = 10 * fontScale;

            // === 8️⃣ 구간별 강제 폰트 확대 ===
            let appliedRule = 'none';
            const beforeRule = fontSize;
            if (maxLineLength > 150 && maxLineLength <= 190) {
                fontSize = Math.max(fontSize, 12);
                appliedRule = '150~190 → ≥12';
            } else if (maxLineLength > 190 && maxLineLength <= 250) {
                fontSize = Math.max(fontSize, 100);
                appliedRule = '190~250 → ≥30';
            } else if (maxLineLength > 250 && maxLineLength <= 400) {
                fontSize = Math.max(fontSize, 100);
                appliedRule = '250~400 → ≥30';
            } else if (maxLineLength > 400 && maxLineLength <= 500) {
                fontSize = Math.max(fontSize, 16);
                appliedRule = '400~500 → ≥16';
            } else if (maxLineLength > 500 && maxLineLength <= 800) {
                fontSize = Math.max(fontSize, 18);
                appliedRule = '500~800 → ≥18';
            } else if (maxLineLength > 800) {
                fontSize = Math.max(fontSize, 20);
                appliedRule = '>800 → ≥20';
            }

            // === 9️⃣ 제한 및 클램프 ===
            const beforeClamp = fontSize;
            if (fontSize < 8) fontSize = 8;

            if (maxLineLength <= 190) {
                if (fontSize > 20) fontSize = 20;
            } else if (maxLineLength > 190 && maxLineLength <= 250) {
                if (fontSize > 30) fontSize = 30;
            } else if (maxLineLength > 250 && maxLineLength <= 400) {
                if (fontSize > 50) fontSize = 50;
            } else if (maxLineLength > 400 && maxLineLength <= 500) {
                if (fontSize > 60) fontSize = 60;
            } else if (maxLineLength > 500 && maxLineLength <= 800) {
                if (fontSize > 70) fontSize = 70;
            } else if (maxLineLength > 800) {
                if (fontSize > 80) fontSize = 80;
            }

            // === 🎯 라인-문자 거리(offset) 수동 조정 ===
            let offsetDistance = 1; // 기본값
            if (maxLineLength <= 150) offsetDistance = 1;
            else if (maxLineLength > 150 && maxLineLength <= 190) offsetDistance = 15;
            else if (maxLineLength > 190 && maxLineLength <= 250) offsetDistance = 35;
            else if (maxLineLength > 250 && maxLineLength <= 400) offsetDistance = 40;
            else if (maxLineLength > 400 && maxLineLength <= 500) offsetDistance = 50;
            else if (maxLineLength > 500 && maxLineLength <= 800) offsetDistance = 60;
            else if (maxLineLength > 800) offsetDistance = 70;

            // === 디버그 로그 ===
            console.group(`[${svg.id}] 폰트 계산 디버그`);
            console.log('lines=', lines.length, 'texts=', texts.length);
            console.log('bassize values=', debugVals);
            console.log('maxLineLength=', maxLineLength, '| scale=', scale.toFixed(3));
            console.log('appliedRule=', appliedRule, '| before=', beforeRule.toFixed(1), '| after=', fontSize.toFixed(1));
            console.log('offsetDistance=', offsetDistance);
            if (beforeClamp !== fontSize)
                console.warn(`⚠️ 클램프됨: ${beforeClamp.toFixed(1)} → ${fontSize.toFixed(1)}`);
            console.groupEnd();

            // === 🔟 폰트 속성 적용 ===
            const px = fontSize.toFixed(1) + 'px';
            texts.forEach((t, i) => {
                t.setAttribute('font-size', fontSize.toFixed(1));
                t.style.setProperty('font-size', px, 'important');
                t.setAttribute('font-family', 'Arial, Helvetica, sans-serif');
                t.setAttribute('paint-order', 'stroke');
                t.setAttribute('stroke', 'white');
                t.setAttribute('stroke-width', '0.6px');
            });

            // === 11️⃣ tspan에도 폰트 적용 ===
            const tspans = group.querySelectorAll('text tspan');
            tspans.forEach(s => {
                s.setAttribute('font-size', fontSize.toFixed(1));
                s.style.setProperty('font-size', px, 'important');
            });

            // === 12️⃣ SVG 잘림 방지 ===
            svg.style.overflow = 'visible';

            // === 13️⃣ 라인 기준으로 텍스트 위치 수동 이동 ===
            texts.forEach(t => {
                const tx = parseFloat(t.getAttribute("x"));
                const ty = parseFloat(t.getAttribute("y"));
                if (isNaN(tx) || isNaN(ty)) return;

                let nearestLine = null;
                let minDist = Infinity;

                lines.forEach(l => {
                    const x1 = parseFloat(l.getAttribute("x1"));
                    const y1 = parseFloat(l.getAttribute("y1"));
                    const x2 = parseFloat(l.getAttribute("x2"));
                    const y2 = parseFloat(l.getAttribute("y2"));
                    if (isNaN(x1) || isNaN(y1) || isNaN(x2) || isNaN(y2)) return;

                    const midX = (x1 + x2) / 2;
                    const midY = (y1 + y2) / 2;
                    const dx = tx - midX;
                    const dy = ty - midY;
                    const dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist < minDist) {
                        minDist = dist;
                        nearestLine = { x1, y1, x2, y2, midX, midY };
                    }
                });

                if (nearestLine) {
                    const vx = nearestLine.x2 - nearestLine.x1;
                    const vy = nearestLine.y2 - nearestLine.y1;
                    const len = Math.sqrt(vx * vx + vy * vy);
                    if (len > 0) {
                        const nx = -vy / len;
                        const ny = vx / len;
                        const newX = tx + nx * offsetDistance;
                        const newY = ty + ny * offsetDistance;
                        t.setAttribute("x", newX);
                        t.setAttribute("y", newY);
                    }
                }
            });

            console.debug(`✅ [${svg.id}] texts moved by offset=${offsetDistance}px`);
        });
    });
</script>



</body>
</html>

<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()

%>