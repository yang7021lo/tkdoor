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

    projectname="절곡 발주서"

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

'==== 도장 정보 불러오기 시작 
SQL = "SELECT djnum FROM tk_wms_djnum "
SQL = SQL & "WHERE sjidx='"&rsjidx&"'"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
    djnum=Rs(0)

End if
RS.Close

SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & " balju_st_idx, sjidx, fkidx, bfidx, baidx, baname, blength"
SQL = SQL & ", quan, xsize, ysize, sx1, sx2, sy1, sy2"
SQL = SQL & ", bachannel, bfimg, midx, mdate, cname, sjdate, sjnum"
SQL = SQL & ", cgaddr, cgdate, djcgdate, cgtype_text, qtyname, p_image, tw"
SQL = SQL & ", th, ow, oh, p_name, SJB_TYPE_NAME, f_name, st_quan"
SQL = SQL & ", ds_daesinaddr, yaddr, sjsidx, cidx, sjmidx, g_bogang, g_busok, g_autorf"
SQL = SQL & ", basidx, bassize, basdirection, accsize, idv, final, GREEM_F_A"
SQL = SQL & ", WHICHI_FIX, WHICHI_AUTO, T_Busok_name, TNG_Busok_images, TNG_Busok_idx, memo_text, bigo,yaddr1 "
SQL = SQL & ", fksidx, insert_flag,SJB_barlist ,dooryn_text "
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
    g_autorf       = Rs(42)  ' 반자동여부
    basidx         = Rs(43)  ' BAS IDX
    bassize        = Rs(44)  ' BAS 크기
    basdirection   = Rs(45)  ' BAS 방향
    accsize        = Rs(46)  ' 부속 사이즈
    idv            = Rs(47)  ' 구분값
    final          = Rs(48)  ' 최종 여부
    GREEM_F_A      = Rs(49)  ' 자동/수동 구분
    WHICHI_FIX     = Rs(50)  ' FIX 구분
    WHICHI_AUTO    = Rs(51)  ' AUTO 구분
    T_Busok_name   = Rs(52)  ' 부속명
    TNG_Busok_images = Rs(53)' 부속 이미지
    TNG_Busok_idx  = Rs(54)  ' 부속 IDX
    memo_text           = Rs(55)  ' 메모
    bigo           = Rs(56)  ' 비고
    fksidx         = Rs(57)  ' FrameKSub IDX
    insert_flag    = Rs(58)  ' 인서트 여부 플래그
    yaddr1          = Rs(59)  ' 용차주소1
    SJB_barlist     = Rs(60)  ' 수주타입바리스트
    dooryn_text     = Rs(61)  ' 도와인여부 텍스트

%>

<%
End if
Rs.close

SQL = "SELECT sjb_type_no"
SQL = SQL & " FROM tng_sjb  "
If rSJB_IDX <> "" Then
SQL = SQL & " WHERE sjb_idx = '" & rSJB_IDX & "' "
end if
'Response.write (SQL)&"<br>"
'response.end
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then

  sjb_type_no  = Rs(0)


end if
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
/* ===============================
   글로벌 설정
=================================*/
:root {
  /* 인쇄 푸터 높이(mm) — 내용 늘면 이 값만 키워 */
  --print-footer-h: 14mm;
}

@page {
  size: A4 portrait;
  /* 푸터가 들어갈 공간을 margin-bottom으로 확보해야 겹치지 않음 */
  margin-top: 10mm;
  margin-left: 8mm;
  margin-right: 8mm;
  margin-bottom: calc(10mm + var(--print-footer-h));
}

/* 화면 기본 */
body, #pdfArea {
  font-family: "맑은 고딕","Malgun Gothic",Arial,sans-serif;
  font-size: 10.5pt;
  color: #000;
  box-sizing: border-box;
}

/* 출력 전체 영역 */
#pdfArea {
  width: 210mm;
  min-height: 297mm;
  margin: 0 auto;
  padding: 0 !important;
  background: #fff;
  box-sizing: border-box;
}

/* Bootstrap flex 영향 최소화 */
#pdfArea.container-fluid,
#pdfArea .row,
#pdfArea .container,
#pdfArea .container-fluid {
  display: block !important;
  position: relative !important;
  height: auto !important;
  min-height: auto !important;
  flex: none !important;
  flex-grow: 0 !important;
  flex-shrink: 0 !important;
  overflow: visible !important;
}

/* 그리드(화면) */
.row { display:flex; flex-wrap:wrap; margin:0 !important; width:100%; }
.col, [class^="col-"] { flex:1; padding:0.5mm !important; box-sizing:border-box; overflow:hidden; }
.row > .col { border:0.2mm solid #ddd; }

/* 발주서 헤더 박스 */
.header-wrap {
  margin-top: 0 !important;
  padding-top: 0 !important;
  width: 100%;
  background: #f8f8f8;
  border: 0.2mm solid #ccc;
  margin-bottom: 2mm;
  page-break-inside: avoid;
  box-sizing: border-box;
}
.header-row { display:flex; width:100%; border-bottom:0.2mm solid #ddd; }
.header-row:last-child { border-bottom: none; }
.header-col {
  flex: 1 1 25%;
  padding: 1.5mm 2mm;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  border-right: 0.2mm solid #ddd;
  box-sizing: border-box;
}
.header-col:last-child { border-right: none; }

/* 자재 카드 */
.barasi-card {
  display: block !important;
  page-break-inside: avoid;
  page-break-after: auto;
  width: 100% !important;
  margin-bottom: 5mm;
}
.barasi-header { display:flex; background:#fff9c4; border-bottom:0.3mm solid #bbb; text-align:center; font-weight:700; }
.barasi-header .cell { flex:1 1 25%; padding:1mm; box-sizing:border-box; }
.barasi-header .cell.num { flex:1 1 21%; } /* num 셀을 더 작게 */
.barasi-header .cell.name { flex:1 1 32%; } /* name 셀을 더 크게 */

.barasi-body { display:flex; flex-wrap:nowrap; align-items:flex-start; width:100%; background:#f4f4f4; box-sizing:border-box; }
.barasi-body .cell { padding:2mm; text-align:center; vertical-align:middle; border-right:0.2mm solid #ccc; box-sizing:border-box; flex:1 0 0; min-width:0; }
.barasi-body .cell:last-child { border-right:none; }
.barasi-body .img { flex:0 0 20%; }
.barasi-body .info { flex:1 1 60%; }
.barasi-body .length { flex:0 0 20%; background:#fff9c4; }


/* SVG 도면 컨테이너 overflow 설정 */
.barasi-body .info .card,
.barasi-body .info .card-body {
  overflow: visible !important;
}

/* 도면 관련 스타일 */
.section { margin-top: 2mm; }
.no-break { break-inside: avoid; page-break-inside: avoid; }
.drawing.wrap,
.drawing .wrap {
  border: 0.2mm solid #ccc;
  padding: 30px;
  border-radius: 2px;
  background: #fff;
  overflow: visible !important;
}
@media print {
  .page-break {
    break-after: page;
  }
  .page-break:last-child {
    break-after: auto;
  }
}

/* canvas SVG 컨테이너 overflow 설정 */
.section.drawing.wrap,
.section.drawing.wrap *,
.drawing.wrap,
.drawing.wrap * {
  overflow: visible !important;
}

.section.drawing.wrap svg,
.section.drawing.wrap svg#canvas,
.drawing.wrap svg,
.drawing.wrap svg#canvas {
  overflow: visible !important;
}

/* canvas SVG 내부 viewport overflow 설정 */
.section.drawing.wrap svg g#viewport,
.drawing.wrap svg g#viewport {
  overflow: visible !important;
}

/* canvas SVG 내부 모든 text 요소 overflow 설정 */
.section.drawing.wrap svg text,
.drawing.wrap svg text {
  overflow: visible !important;
}


/* 부속 영역 */
.busok-names { display:flex; justify-content:space-between; margin-bottom:2mm; gap:2mm; }
.busok-names > div { flex:1; text-align:center; word-break:break-all; white-space:normal; overflow:hidden; line-height:1.1; font-size:9pt; max-height:2.5em; }
.busok-images { display:flex; justify-content:space-between; align-items:center; gap:2mm; width:100%; }
.busok-images > * { flex:1 1 0; text-align:center; max-width:33%; box-sizing:border-box; }
.busok-images img { max-width:25mm; max-height:20mm; object-fit:contain; border:1px solid #ccc; border-radius:2mm; display:block; margin:0 auto; }
.busok-images div { height:20mm; line-height:20mm; color:#bbb; font-size:9pt; border:1px dashed #ddd; border-radius:2mm; }


/* ===============================
   인쇄 전용
=================================*/
@media print {
  /* 컬러 유지 */
  body {
    -webkit-print-color-adjust: exact !important;
    print-color-adjust: exact !important;
    margin: 0;
    padding: 0;
    background: #fff;
  }
  .no-print { display: none !important; }

  /* 카드 높이 고정(필요 시 조절) */
  .barasi-card {
    width: 100%;
    height: 68mm; /* 297mm/4 근사 */
    page-break-inside: avoid !important;
    break-inside: avoid-page !important;
    margin: 0 0 5mm 0;
    padding: 0;
  }

  /* 본문 하단 여백(푸터와 겹침 방지 - 페이지 콘텐츠 쪽) */
  #pdfArea { padding-bottom: var(--print-footer-h); }

  /* 인쇄 푸터 고정 표시 */
  .print-footer {
    display: block !important;
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;               /* 페이지 하단에 고정 */
    width: 100%;
    text-align: center;
    font-size: 10pt;
    color: #000;
    border-top: 0.2mm solid #aaa;
    padding: 2mm 0 0 0;
    background: #fff;
    z-index: 9999;
    box-sizing: border-box;
    height: var(--print-footer-h);
  }

  /* 페이지 번호 */
  .print-footer .pageNumber::after {
    content: counter(page) " / " counter(pages);
  }

  /* 필요 시 페이지 강제 분리용 */
  .page-break { break-before: page; page-break-before: always; }
}
/* ✅ HTML로 표시되는 발주 정보 */
.print-footer {
  display: none;
}

@media print {
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
  }
}

/* ✅ CSS 기반 페이지 번호 (Chrome 121+ 이상, Safari, Firefox 지원) */
@page {
  size: A4 portrait;
  margin: 10mm 8mm 20mm 8mm;  /* 하단 여백 20mm로 확보 */
  @bottom-right {
    content: "Page " counter(page) " / " counter(pages);
    font-size: 10pt;
    color: #333;
  }
}

</style>

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

            <div id="pdfArea"
                style="background-color:#ffffff; border-radius:8px; display:block;">
                <div class="d-flex justify-content-between align-items-center fw-bold fs-5 mb-2">
                    <div>절곡 발주서</div>
                    <div>
                        <%=Year(Now())%>-<%=Right("0" & Month(Now()),2)%>-<%=Right("0" & Day(Now()),2)%>
                        (<%=Left(WeekdayName(Weekday(Now()), False, 1),1)%>)
                        <%=Right("0" & Hour(Now()),2)%>:<%=Right("0" & Minute(Now()),2)%>
                    </div>
                </div>
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
                        SQL = SQL & "  ds_daesinaddr, yaddr, sjsidx, cidx, sjmidx, g_bogang, g_busok,g_autorf,"
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
                            g_autorf       = Rs(42)  ' 부속여부
                            basidx         = Rs(43)  ' BAS IDX
                            bassize        = Rs(44)  ' BAS 크기
                            basdirection   = Rs(45)  ' BAS 방향
                            accsize        = Rs(46)  ' 부속 사이즈
                            idv            = Rs(47)  ' 구분값
                            final          = Rs(48)  ' 최종 여부
                            GREEM_F_A      = Rs(49)  ' 자동/수동 구분
                            WHICHI_FIX     = Rs(50)  ' FIX 구분
                            WHICHI_AUTO    = Rs(51)  ' AUTO 구분
                            T_Busok_name   = Rs(52)  ' 부속명
                            TNG_Busok_images = Rs(53)' 부속 이미지
                            TNG_Busok_idx  = Rs(54)  ' 부속 IDX
                            memo_text           = Rs(55)  ' 메모
                            bigo           = Rs(56)  ' 비고
                            fksidx         = Rs(57)  ' FrameKSub IDX
                            insert_flag    = Rs(58)  ' 인서트 여부 플래그
                            yaddr1          = Rs(59)  ' 용차주소1
                            SJB_barlist     = Rs(60)  ' 수주타입바리스트
                            dooryn_text     = Rs(61)  ' 도와인여부 텍스트

                            p=p+1
                        %>  
                <!-- 🧾 발주서 헤더 -->
                <div class="header-wrap"> 
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
                        <div class="header-col">도장번호: <%=djnum%></div>
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
                </div>
                    <%
                        rs.MoveNext
                        Loop
                        End if
                        rs.Close
                    %>

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
                        SQL = SQL & "    MIN(bachannel) AS bachannel, "  ' ✅ 좌표 따라감 (표시용)
                        SQL = SQL & "    MIN(baidx) AS baidx, "
                        SQL = SQL & "    MIN(g_bogang) AS g_bogang, "
                        SQL = SQL & "    MIN(g_busok) AS g_busok, "
                        SQL = SQL & "    MIN(g_autorf) AS g_autorf, "
                        SQL = SQL & "    MIN(bfimg) AS bfimg, "
                        SQL = SQL & "    qtyname, "                      ' ✅ qtyname 분리 기준
                        SQL = SQL & "    xsize, ysize, sx1, sx2, sy1, sy2 "
                        SQL = SQL & "FROM tk_balju_st "
                        SQL = SQL & "WHERE sjidx='" & rsjidx & "' AND insert_flag=1 "
                        SQL = SQL & "GROUP BY "
                        SQL = SQL & "    bfidx, "
                        SQL = SQL & "    qtyname, "
                        SQL = SQL & "    xsize, ysize, sx1, sx2, sy1, sy2 "
                        SQL = SQL & "ORDER BY "
                        SQL = SQL & "    MIN(sjsidx), "                  ' ✅ 1순위: sjsidx
                        SQL = SQL & "    qtyname, "                      ' ✅ 2순위: qtyname
                        SQL = SQL & "    bfidx, "                        ' ✅ 3순위: bfidx
                        SQL = SQL & "    xsize, ysize, sx1, sy1"         ' ✅ 이후 좌표 정렬
                        'Response.write (SQL)&" 1차 바라시 쿼리<br>"
                        Rs1.open Sql,Dbcon
                        If Not (Rs1.bof or Rs1.eof) Then 
                        Do while not Rs1.EOF

                        bfidx  = Rs1("bfidx")
                        fkidx  = Rs1("fkidx")
                        baname = Rs1("baname")
                        baidx  = Rs1("baidx")
                        xsize  = Rs1("xsize")
                        ysize  = Rs1("ysize")
                        sx1    = Rs1("sx1")
                        sx2    = Rs1("sx2")
                        sy1    = Rs1("sy1")
                        sy2    = Rs1("sy2")
                        g_bogang = Rs1("g_bogang") 
                        g_busok = Rs1("g_busok")
                        g_autorf = Rs1("g_autorf")
                        bfimg = Rs1("bfimg")
                        qtyname = Rs1("qtyname")
                        bachannel = Rs1("bachannel")

                        loop_count = loop_count + 1

                        ' ==========================
                        ' 🔹 그룹별 대표 정보 출력
                        ' ==========================
                        %>
                        <%
                        ' ==================================
                        ' 🔹 이 fkidx에 속한 bfidx 세부 루프 (barasi, SVG 포함)
                        ' ==================================
                    %>
                <div class="barasi-card">
                    <!-- 🔸 상단 제목 행 -->
                    <div class="barasi-header">
                        <div class="cell num"><%=loop_count%>번  채널명:<%=bachannel%></div>
                        <div class="cell name" style="display: flex; align-items: center; gap: 5px;">
                            <a href="tng1_julgok_in_sub3.asp?kkgotopage=1&SJB_IDX=<%=rsjidx%>&baidx=<%=baidx%>&bfidx=<%=bfidx%>" 
                               target="_blank"
                               style="color: #0066cc !important; text-decoration: underline !important; cursor: pointer !important; font-weight: bold !important; flex: 1;">
                               <%=baname%>
                            </a>
                            <button type="button" 
                                    onclick="window.open('julgok_movexy.asp?sjidx=<%=rsjidx%>&baidx=<%=baidx%>', '_blank', 'width=1200,height=800,scrollbars=yes,resizable=yes')"
                                    style="background: #28a745; color: white; border: none; padding: 3px 8px; border-radius: 4px; font-size: 11px; cursor: pointer; white-space: nowrap;">
                                변경
                            </button>
                        </div>
                        <div class="cell qty">
                            <%
                            If InStr(baname, "재료") > 0  And InStr(baname, "갈바") = 0 Then
                                Response.Write("헤어라인 1.2T")
                            ElseIf g_bogang = 1 Or g_busok = 1 Then
                                Response.Write("갈바1.2T")
                            ElseIf InStr(baname, "보양") > 0 Then
                                Response.Write("갈바1.2T")
                            Else
                                Response.Write(qtyname)
                            End If
                            %>
                        </div>
                        <div class="cell title">길이</div>
                    </div>
                        <!-- 🔸 본문 -->
                        <div class="barasi-body">

                            <!-- ① 자재 이미지 -->
                            <div class="cell img">
                                <% If bfimg <> "" Then %>
                                    <img src="/img/frame/bfimg/<%=bfimg%>"
                                        loading="lazy"
                                        style="width:100%; max-width:55mm; max-height:60mm; object-fit:contain; border:1px solid #ddd;">
                                <% Else %>
                                    <div style="color:#aaa;">(이미지 없음)</div>
                                <% End If %>
                            </div>

                            <!-- ② SVG (절곡도면) -->
                            <div class="cell info">
                                <div class="card card-body text-start" style="background:#fff; overflow:hidden;">
                                    <!-- * SVG 코드 시작 -->
                                    <svg id="mySVG"
                                        viewBox="0 0 100 100"
                                        width="100%"
                                        height="100%"
                                        fill="none"
                                        stroke="#000"
                                        stroke-width="1"
                                        preserveAspectRatio="xMidYMid meet"
                                        style="display:block; margin:0 auto;">

                                    <%
                                    SQL = "SELECT basidx, bassize, basdirection, x1, y1, x2, y2, accsize, idv, tx, ty FROM tk_barasisub WHERE baidx='" & baidx & "' ORDER BY basidx ASC"
                                    If Rs2.State = 1 Then Rs2.Close 
                                    Rs2.Open SQL, Dbcon
                                    If Not (Rs2.BOF Or Rs2.EOF) Then
                                        Do While Not Rs2.EOF
                                            basidx = Rs2(0)
                                            bassize = Rs2(1)
                                            basdirection = Rs2(2)
                                            x1 = CDbl(Rs2(3))
                                            y1 = CDbl(Rs2(4))
                                            x2 = CDbl(Rs2(5))
                                            y2 = CDbl(Rs2(6))
                                            accsize = Rs2(7)
                                            idv = Rs2(8)
                                            tx1 = Rs2(9)  ' 데이터베이스에서 tx 가져오기
                                            ty1 = Rs2(10) ' 데이터베이스에서 ty 가져오기

                                    %>
                                            <line x1="<%=x1%>" y1="<%=y1%>" x2="<%=x2%>" y2="<%=y2%>" />
                                    <%
                                            If bassize=Int(bassize) Then bassize_int=FormatNumber(bassize,0) Else bassize_int=FormatNumber(bassize,1)
                                    %>
                                            <text x="<%=tx1%>" y="<%=ty1%>" fill="#000" font-size="12" font-family="Arial" font-weight="600" text-anchor="middle" dominant-baseline="middle" style="paint-order:stroke;stroke:white;stroke-width:0.6px;"><%=bassize_int%></text>
                                    <%
                                            Rs2.MoveNext
                                        Loop
                                        Rs2.Close
                                    End If
                                    %>
                                    </svg>


                                    <!-- * SVG 코드 끝 -->
                                </div>
                            </div>
                            <!-- 👇 SVGFit 스크립트는 도면 아래로 이동 -->
                            <script>
                            (function (root) {
                            function getTransformedBBox(el) { ... }   // 동일
                            function getPPU(svg) { ... }              // 동일
                            function compensateTexts(svg, groups, factor) { ... }  // 동일
                            function fitAllById(svgId='canvas', groupId='viewport', {padding=20,setSize=false}={}) { ... } // 동일
                            root.SVGFit = { fitAllById };
                            })(window);

                            // ✅ 여기서 실행 (도면 완성 후)
                            window.addEventListener('load', () => {
                            const svg = document.querySelector('#mySVG');
                            if (svg) {
                                svg.setAttribute('preserveAspectRatio', 'xMinYMin meet');
                                const bb = svg.getBBox();
                                svg.setAttribute('viewBox', `${bb.x - 20} ${bb.y - 20} ${bb.width + 40} ${bb.height + 40}`);
                            }
                            });
                            </script>
                            <!-- ③ 절곡 값 (bend diagram) -->
                            <div class="cell info">
                                <div class="bend-diagram" style="width:100%; text-align:center; font-size:10px; line-height:1;">

                                    <div class="bend-row" 
                                        style="display:flex; flex-wrap:wrap; justify-content:flex-start; align-items:center; gap:0;">

                                        <%
                                        SQL="SELECT basidx, bassize, basdirection, accsize, idv, final FROM tk_barasisub WHERE baidx='" & baidx & "' ORDER BY basidx ASC"
                                        If Rs.State = 1 Then Rs.Close
                                        Rs.Open SQL, Dbcon
                                        If Not (Rs.BOF Or Rs.EOF) Then
                                            Do While Not Rs.EOF
                                            basidx       = Rs(0)
                                            bassize      = Rs(1)
                                            basdirection = Rs(2)
                                            accsize      = Rs(3)
                                            idv          = Rs(4)
                                            final        = Rs(5)

                                            bassize = bassize + idv

                                            ' === 버튼 색상 ===
                                            'btn_text = "btn-light"
                                            'If idv="0" Then btn_text="btn-primary btn-sm "
                                            'If final="0" Then btn_text="btn-dark btn-lg "
                                            ' === 텍스트 스타일 결정 ===
                                            text_style = "font-size:14px; line-height:14px; font-weight:400;"
                                            If final = "0" Then
                                                text_style = "font-size:18px; line-height:18px; font-weight:700; color:#000;"
                                            End If
                                        %>

                                        <!-- 🎯 하나의 세트(값2+값1) -->
                                        <div style="display:flex; flex-direction:column; align-items:center; width:56px; margin:0; padding:0;">
                                            <!-- 상단: 값2(accsize) -->
                                            <div style="display:flex; justify-content:center; align-items:center; gap:0;">
                                                <div style="width:28px; height:16px;">&nbsp;</div>
                                                <div style="width:28px; height:16px; margin:0; padding:0; <%=text_style%>"><%=accsize%></div>
                                            </div>

                                            <!-- 중앙 라인 -->
                                            <div style="width:100%; height:1px; background:#000; margin:1px 0;"></div>

                                            <!-- 하단: 값1(bassize) -->
                                            <div style="display:flex; justify-content:center; align-items:center; gap:0;">
                                                <div style="width:28px; height:16px; line-height:16px; <%=text_style%>"><%=bassize%></div>
                                                <div style="width:28px; height:16px;">&nbsp;</div>
                                            </div>
                                        </div>

                                        <%
                                            Rs.MoveNext
                                            Loop
                                        End If
                                        Rs.Close
                                        %>

                                    </div>
                                </div>
                            </div>
                            <!-- ④ 길이 출력 -->
                            <div class="cell length">
                                <%
                                SQL = ""
                                SQL = SQL & "WITH base AS ( "
                                SQL = SQL & "    SELECT * "
                                SQL = SQL & "    FROM tk_balju_st "
                                SQL = SQL & "    WHERE sjidx='" & rsjidx & "' AND insert_flag=1 "
                                SQL = SQL & "), "
                                SQL = SQL & "rank_s AS ( "
                                SQL = SQL & "    SELECT sjsidx, DENSE_RANK() OVER (ORDER BY sjsidx) AS sjsidx_order "
                                SQL = SQL & "    FROM (SELECT DISTINCT sjsidx FROM base) d "
                                SQL = SQL & "), "
                                SQL = SQL & "grp AS ( "
                                SQL = SQL & "    SELECT "
                                SQL = SQL & "        t.sjsidx, "
                                SQL = SQL & "        MIN(t.fkidx) AS fkidx, "
                                SQL = SQL & "        t.bfidx, "
                                SQL = SQL & "        t.qtyname, "                           ' ✅ qtyname 기준 추가
                                SQL = SQL & "        MIN(t.baidx) AS baidx, "
                                SQL = SQL & "        MIN(t.baname) AS baname, "
                                SQL = SQL & "        MIN(t.quan) AS quan, "
                                SQL = SQL & "        CAST(t.blength AS FLOAT) AS blength, "
                                SQL = SQL & "        t.xsize, t.ysize, t.sx1, t.sx2, t.sy1, t.sy2, "
                                SQL = SQL & "        COUNT(*) AS same_xy_count "
                                SQL = SQL & "    FROM base t "
                                SQL = SQL & "    GROUP BY "
                                SQL = SQL & "        t.sjsidx, t.bfidx, t.qtyname, t.blength, "  ' ✅ qtyname 포함
                                SQL = SQL & "        t.xsize, t.ysize, t.sx1, t.sx2, t.sy1, t.sy2 "
                                SQL = SQL & ") "
                                SQL = SQL & "SELECT "
                                SQL = SQL & "    g.sjsidx, "
                                SQL = SQL & "    r.sjsidx_order, "
                                SQL = SQL & "    g.fkidx, "
                                SQL = SQL & "    g.bfidx, "
                                SQL = SQL & "    g.qtyname, "
                                SQL = SQL & "    g.baidx, "
                                SQL = SQL & "    g.baname, "
                                SQL = SQL & "    g.quan, "
                                SQL = SQL & "    g.blength, "
                                SQL = SQL & "    g.same_xy_count, "
                                SQL = SQL & "    g.xsize, g.ysize, g.sx1, g.sx2, g.sy1, g.sy2 "
                                SQL = SQL & "FROM grp g "
                                SQL = SQL & "JOIN rank_s r ON r.sjsidx = g.sjsidx "
                                SQL = SQL & "WHERE g.xsize='" & xsize & "' "
                                SQL = SQL & "  AND g.ysize='" & ysize & "' "
                                SQL = SQL & "  AND g.sx1='" & sx1 & "' "
                                SQL = SQL & "  AND g.sx2='" & sx2 & "' "
                                SQL = SQL & "  AND g.sy1='" & sy1 & "' "
                                SQL = SQL & "  AND g.sy2='" & sy2 & "' "
                                SQL = SQL & "  AND g.bfidx='" & bfidx & "' "
                                SQL = SQL & "  AND g.qtyname='" & qtyname & "' "            ' ✅ qtyname 동기화 추가
                                SQL = SQL & "ORDER BY r.sjsidx_order, g.qtyname, g.fkidx, g.bfidx, g.blength"
                                i = 1     
                                s_sjsidx_order =  0 
                                ' Response.write (SQL)&" 사이즈 업데이트 <br> "
                                Rs.open Sql,Dbcon
                                if not (Rs.EOF or Rs.BOF ) then
                                Do while not Rs.EOF
                                    
                                    sjsidx_order    = Rs("sjsidx_order")
                                    blength        = Rs("blength")
                                    same_xy_count  = Rs("same_xy_count")
                                    quan           = Rs("quan")
                                    bfidx = Rs("bfidx")
                                    fkidx = Rs("fkidx")

                                    total_quan = quan * same_xy_count 
                                    '갈바보강일 경우
                                    if g_bogang = 1   then
                                        '박스 세트 박스커버 가로남마 일 경우
                                        if(whichi_auto = 1 OR whichi_auto = 2 OR whichi_auto = 3) Then
                                         
                                          '분할 했는지 확인하기
                                              SQL_check = ""
                                              SQL_check = SQL_check & "WITH base AS ( "
                                              SQL_check = SQL_check & "    SELECT * "
                                              SQL_check = SQL_check & "    FROM tk_balju_st "
                                              SQL_check = SQL_check & "    WHERE sjidx='" & rsjidx & "' "
                                              SQL_check = SQL_check & "      AND insert_flag=1 "
                                              SQL_check = SQL_check & "), "
                                              SQL_check = SQL_check & "rank_s AS ( "
                                              SQL_check = SQL_check & "    SELECT sjsidx, "
                                              SQL_check = SQL_check & "           DENSE_RANK() OVER (ORDER BY sjsidx) AS sjsidx_order "
                                              SQL_check = SQL_check & "    FROM (SELECT DISTINCT sjsidx FROM base) d "
                                              SQL_check = SQL_check & "), "
                                              SQL_check = SQL_check & "grp AS ( "
                                              SQL_check = SQL_check & "    SELECT "
                                              SQL_check = SQL_check & "        t.sjsidx, "
                                              SQL_check = SQL_check & "        t.fkidx, "
                                              SQL_check = SQL_check & "        t.bfidx, "
                                              SQL_check = SQL_check & "        t.qtyname, "
                                              SQL_check = SQL_check & "        CAST(t.blength AS FLOAT) AS blength, "
                                              SQL_check = SQL_check & "        t.xsize, t.ysize, t.sx1, t.sx2, t.sy1, t.sy2 "
                                              SQL_check = SQL_check & "    FROM base t "
                                              SQL_check = SQL_check & "    GROUP BY "
                                              SQL_check = SQL_check & "        t.sjsidx,t.fkidx, t.bfidx, t.qtyname, t.blength, "
                                              SQL_check = SQL_check & "        t.xsize, t.ysize, t.sx1, t.sx2, t.sy1, t.sy2 "
                                              SQL_check = SQL_check & ") "
                                              SQL_check = SQL_check & "SELECT COUNT(*) AS order_cnt "
                                              SQL_check = SQL_check & "FROM grp g "
                                              SQL_check = SQL_check & "JOIN rank_s r ON r.sjsidx = g.sjsidx "
                                              SQL_check = SQL_check & "WHERE r.sjsidx_order = '" & sjsidx_order & "' "
                                              SQL_check = SQL_check & "  AND g.xsize='" & xsize & "' "
                                              SQL_check = SQL_check & "  AND g.ysize='" & ysize & "' "
                                              SQL_check = SQL_check & "  AND g.sx1='" & sx1 & "' "
                                              SQL_check = SQL_check & "  AND g.sx2='" & sx2 & "' "
                                              SQL_check = SQL_check & "  AND g.sy1='" & sy1 & "' "
                                              SQL_check = SQL_check & "  AND g.sy2='" & sy2 & "' "
                                              SQL_check = SQL_check & "  AND g.bfidx='" & bfidx & "' "
                                              SQL_check = SQL_check & "  AND g.qtyname='" & qtyname & "' "
                                              SQL_check = SQL_check & "  AND g.fkidx='" & fkidx & "' "
                                              
                                              Rs2.open SQL_check, dbcon
                                              If Not Rs2.EOF Then
                                                  sjsidx_order_cnt = CLng(Rs2("order_cnt")) 'sjsidx_order_cnt 1개 이상일 경우 분할됨
                                              End If
                                              Rs2.close()

                                          '분할된 상태라면 True 아니라면 False'
                                          'sjsidx_order_cnt 가 1개 이상이면 분할된 상태
                                          if(sjsidx_order_cnt > 1 ) Then 
                                                hasData = True
                                          'same_xy_count  1개 이상이라면 분할된 상태
                                          Elseif(sjsidx_order_cnt = 1 and same_xy_count > 1) Then 
                                                hasData = True 
                                          Else 
                                              blength = blength - 2

                                          End if
                                      
                                    
                                        
                                          if(hasData) Then 
                                                  
                                              '갈바 보강은 분할되엇을 경우무조건 레코드 2개만 출력
                                              ' if(i = 3) Then 
                                              '     Exit Do
                                              ' End if
                                                      
                                              '갈바보강의 경우 분할 전 사이즈를 가져 온뒤 % 2의 길이
                                              '분할 전 사이즈 가져오기 
                                              SQL = ""
                                              SQL = SQL & "WITH base AS ( "
                                              SQL = SQL & "    SELECT * "
                                              SQL = SQL & "    FROM tk_balju_st "
                                              SQL = SQL & "    WHERE sjidx = '" & rsjidx & "' "
                                              SQL = SQL & "      AND insert_flag = 1 "
                                              SQL = SQL & "), "
                                              SQL = SQL & "rank_s AS ( "
                                              SQL = SQL & "    SELECT sjsidx, "
                                              SQL = SQL & "           DENSE_RANK() OVER (ORDER BY sjsidx) AS sjsidx_order "
                                              SQL = SQL & "    FROM (SELECT DISTINCT sjsidx FROM base) d "
                                              SQL = SQL & ") "
                                              SQL = SQL & "SELECT "
                                              SQL = SQL & "    SUM(CAST(b.blength AS FLOAT)) AS sum_blength, "
                                              SQL = SQL & "    COUNT(*) AS bar_cnt "
                                              SQL = SQL & "FROM base b "
                                              SQL = SQL & "JOIN rank_s r ON r.sjsidx = b.sjsidx "
                                              SQL = SQL & "WHERE r.sjsidx_order = '" & sjsidx_order & "' "
                                              SQL = SQL & "  AND b.xsize   = '" & xsize & "' "
                                              SQL = SQL & "  AND b.ysize   = '" & ysize & "' "
                                              SQL = SQL & "  AND b.sx1     = '" & sx1 & "' "
                                              SQL = SQL & "  AND b.sx2     = '" & sx2 & "' "
                                              SQL = SQL & "  AND b.sy1     = '" & sy1 & "' "
                                              SQL = SQL & "  AND b.sy2     = '" & sy2 & "' "
                                              SQL = SQL & "  AND b.bfidx   = '" & bfidx & "' "
                                              SQL = SQL & "  AND b.qtyname = '" & qtyname & "' "
                                              SQL = SQL & "  AND b.fkidx = '" & fkidx & "' "
                                              Rs2.open SQL, dbcon
                                              If Not Rs2.EOF Then
                                                  sum_blength = Rs2("sum_blength")
                                                  bar_cnt     = Rs2("bar_cnt")
                                              End If
                                              Rs2.close()

                                                                                        
                                                    '갈바보강 길이 = 분할전 사이즈 / 2
                                                    blength = int(sum_blength / 2)
                                                    
                                                '첫번째 길이만 -2 빠지기 i = 1 값만 -2 
                                                if(CLng(sjsidx_order) = CLng(s_sjsidx_order)) Then 
                                                     i = i + 1     
                                                Else 
                                                    s_sjsidx_order = sjsidx_order
                                                    i = 1
                                                End if

                                                       
                                                if(i = 1) Then 
                                                        blength = blength - 2
                                                        s_sjsidx_order = sjsidx_order
                                                End if
                                                    
                                                      

                                                  '갈바보강의 경우 원래 갯수에 반이 나오게 변경
                                                  total_quan = 1
                                                end if
                                                '2등분인 경우 1개의 레코드 값만 나오기 때문에 한개더 출력하기
                                                if(sjsidx_order_cnt = 1 and same_xy_count > 1) Then 
                                                  %>
                                                      <div class='text-start'><%=sjsidx_order%>번  <%=blength%>mm = <%=total_quan%>개&nbsp;&#9633;</div>
                                                  <%
                                                      blength = blength + 2 '2등분 인 경우 에만 +1
                                                End if
                                          Else 
                                              blength = blength - 2

                                        End if
                                     End if
                                                 
                                    if  g_busok = 1 then
                                        blength = 200
                                    end if

                                    if  g_autorf = 1 then
                                     'response.write "sjb_type_no : " &sjb_type_no& "<br>" 
                                        if (sjb_type_no = 1 or sjb_type_no = 2 or sjb_type_no = 3 or sjb_type_no = 4) then
                                            blength = blength - 135
                                        elseif (sjb_type_no = 8 or sjb_type_no = 9 or sjb_type_no = 10 or sjb_type_no = 15) then
                                            blength = blength - 2
                                        end if
                                    end if

                                %>
                                <div class='text-start'><%=sjsidx_order%>번  <%=blength%>mm = <%=total_quan%>개&nbsp;&#9633;</div>
                                <%
                                i = i+ 1
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

    // ===== 1) bbox 수집 =====
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

    // ===== 2) 스케일/이동 =====
    const width = maxX - minX;
    const height = maxY - minY;
    const maxDim = Math.max(width, height);
    const targetSize = 100;

    let paddingRatio = 1.2;
    if (maxDim > 200) paddingRatio = 1.3;
    if (maxDim > 400) paddingRatio = 1.4;
    if (maxDim > 800) paddingRatio = 1.5;

    const scale = targetSize / (maxDim * paddingRatio);
    const cx = (minX + maxX) / 2;
    const cy = (minY + maxY) / 2;
    const translateX = (targetSize / 2) - (cx * scale);
    const translateY = (targetSize / 2) - (cy * scale);
    group.setAttribute("transform", `translate(${translateX},${translateY}) scale(${scale})`);

    // ===== 3) 선 두께 보정 =====
    const strokeWidth = Math.max(0.4, Math.min(2.5, 1 / scale));
    lines.forEach(l => l.setAttribute("stroke-width", strokeWidth));

    // ===== 4) 숫자 파싱 =====
    const parseNumber = s => {
      const v = parseFloat(String(s||"").replace(/[^0-9.\-]/g,""));
      return isNaN(v) ? null : v;
    };

    // 최대 길이
    let maxLen = 0, vals = [];
    texts.forEach(t => {
      const v = parseNumber(t.textContent);
      if (v !== null) { vals.push(v); if (v > maxLen) maxLen = v; }
    });

    // ===== 5) 기본 폰트 =====
    let fontScale = 1 / (scale * 0.6);
    let fontSize = 10 * fontScale;

    // 강제 확대 (네 규칙 유지)
    if (maxLen > 150 && maxLen <= 190) fontSize = Math.max(fontSize, 12);
    else if (maxLen > 190 && maxLen <= 250) fontSize = Math.max(fontSize, 30);
    else if (maxLen > 250 && maxLen <= 400) fontSize = Math.max(fontSize, 50);
    else if (maxLen > 400 && maxLen <= 500) fontSize = Math.max(fontSize, 60);
    else if (maxLen > 500 && maxLen <= 800) fontSize = Math.max(fontSize, 70);
    else if (maxLen > 800) fontSize = Math.max(fontSize, 80);
    if (fontSize < 8) fontSize = 8;

    // ===== 6) 기본 offsetDistance =====
    let offsetDistance = 1;
    if (maxLen <= 150) offsetDistance = 1;
    else if (maxLen <= 190) offsetDistance = 15;
    else if (maxLen <= 250) offsetDistance = 35;
    else if (maxLen <= 400) offsetDistance = 40;
    else if (maxLen <= 500) offsetDistance = 50;
    else if (maxLen <= 800) offsetDistance = 60;
    else offsetDistance = 70;

    // 기본 폰트 속성
    const px = fontSize.toFixed(1) + 'px';
    texts.forEach(t => {
      t.setAttribute('font-size', fontSize.toFixed(1));
      t.style.setProperty('font-size', px, 'important');
      t.setAttribute('font-family', 'Arial, Helvetica, sans-serif');
      t.setAttribute('paint-order', 'stroke');
      t.setAttribute('stroke', 'white');
      t.setAttribute('stroke-width', '0.6px');
    });

    svg.style.overflow = 'visible';

    // ===== 7) 먼저 라인 법선 방향으로 1차 이동 (요소별 _offset 우선) =====
    texts.forEach((t, idx) => {
      const tx = parseFloat(t.getAttribute("x"));
      const ty = parseFloat(t.getAttribute("y"));
      if (isNaN(tx) || isNaN(ty)) return;

      // 가장 가까운 라인
      let nearest = null, best = Infinity;
      lines.forEach(l => {
        const x1 = parseFloat(l.getAttribute("x1"));
        const y1 = parseFloat(l.getAttribute("y1"));
        const x2 = parseFloat(l.getAttribute("x2"));
        const y2 = parseFloat(l.getAttribute("y2"));
        if ([x1,y1,x2,y2].some(isNaN)) return;
        const mx = (x1 + x2)/2, my = (y1 + y2)/2;
        const d = Math.hypot(tx - mx, ty - my);
        if (d < best) { best = d; nearest = {x1,y1,x2,y2}; }
      });

      if (!nearest) return;

      const vx = nearest.x2 - nearest.x1;
      const vy = nearest.y2 - nearest.y1;
      const len = Math.hypot(vx, vy);
      if (len === 0) return;

      const nx = -vy / len;
      const ny =  vx / len;

      // 👇 요소별 오버라이드(_offset) 우선 적용
      const thisOffset = t.dataset._offset ? parseFloat(t.dataset._offset) : offsetDistance;

      t.setAttribute("x", (tx + nx * thisOffset));
      t.setAttribute("y", (ty + ny * thisOffset));
      t.dataset._moved = "1";
      t.dataset._idx = String(idx);
    });

    // ===== 8) 겹침 탐지(원근사) =====
    const coords = Array.from(texts).map((t,i) => ({
      i,
      x: parseFloat(t.getAttribute("x")),
      y: parseFloat(t.getAttribute("y")),
      fs: parseFloat(t.getAttribute("font-size")) || fontSize
    }));

    const overlaps = [];
    for (let i = 0; i < coords.length; i++) {
      for (let j = i+1; j < coords.length; j++) {
        const dx = coords[i].x - coords[j].x;
        const dy = coords[i].y - coords[j].y;
        const dist = Math.hypot(dx, dy);

        const rTight = (coords[i].fs + coords[j].fs) * 0.2;
        const rLoose = (coords[i].fs + coords[j].fs) * 0.3;

        let type = null;
        if (dist < rTight) type = "tight";
        else if (dist < rLoose) type = "loose";

        if (type) overlaps.push({i, j, type, dist});
      }
    }

    // ===== 9) 텍스트별 "최대 severity"만 취합 =====
    // rank: none(0) < loose(1) < tight(2)
    const rank = { none:0, loose:1, tight:2 };
    const perText = Array.from({length: texts.length}, () => ({severity:"none"}));

    overlaps.forEach(o => {
      if (rank[o.type] > rank[perText[o.i].severity]) perText[o.i].severity = o.type;
      if (rank[o.type] > rank[perText[o.j].severity]) perText[o.j].severity = o.type;
    });

    // ===== 10) 겹침 반영 (텍스트당 1회만) =====
    const SHRINK_TIGHT = 0.4;
    const SHRINK_LOOSE = 0.6;
    const TIGHT_OFFSET = 200;   // tight 전용 수동 오프셋
    const LOOSE_OFFSET = null;  // null이면 유지

    perText.forEach((st, idx) => {
    if (st.severity === "none") return;
    const t = texts[idx];
    const origSize = parseFloat(t.getAttribute("font-size")) || fontSize;
    const shrink = (st.severity === "tight") ? SHRINK_TIGHT : SHRINK_LOOSE;
    const newSize = (origSize * shrink).toFixed(1);
    /*
    t.setAttribute("font-size", newSize);
    t.style.setProperty("font-size", newSize + "px", "important");
    t.setAttribute("fill", "#ff0000");
    */

    // ✅ 여기서 targetOffset도 저장
    if (st.severity === "tight") {
        t.dataset._tight = "1";
        t.dataset._offset = String(TIGHT_OFFSET);
        t.dataset._targetOffset = String(TIGHT_OFFSET);  // ✅ 추가
    } else {
        t.dataset._tight = "0";
        if (LOOSE_OFFSET != null) {
        t.dataset._offset = String(LOOSE_OFFSET);
        t.dataset._targetOffset = String(LOOSE_OFFSET); // ✅ 추가
        }
    }
    });

    // ===== 13) ✅ 2차 이동: targetOffset과 baseOffset의 차이만큼 추가 이동 =====
        texts.forEach((t) => {
        const target = t.dataset._targetOffset ? parseFloat(t.dataset._targetOffset) : null;
        const base   = t.dataset._baseOffset ? parseFloat(t.dataset._baseOffset) : null;
        const nx     = t.dataset._nx ? parseFloat(t.dataset._nx) : null;
        const ny     = t.dataset._ny ? parseFloat(t.dataset._ny) : null;
        if (target == null || base == null || nx == null || ny == null) return;

        const delta = target - base;        // 원하는 오프셋 - 기존 적용 오프셋
        if (Math.abs(delta) < 0.001) return;

        const x = parseFloat(t.getAttribute("x")) || 0;
        const y = parseFloat(t.getAttribute("y")) || 0;
        t.setAttribute("x", (x + nx * delta));
        t.setAttribute("y", (y + ny * delta));

        // 기록 갱신
        t.dataset._baseOffset = String(thisOffset);
        t.dataset._nx = String(nx);
        t.dataset._ny = String(ny);
        });

    // ===== 디버그 =====
    console.group(`SVG ${svg.id} 디버그`);
    console.log('texts=', texts.length, 'overlaps=', overlaps.length);
    console.log('severity=', perText.map(s=>s.severity));
    console.groupEnd();
  });
});
</script>


<script>
    document.addEventListener("DOMContentLoaded", () => {
    // 루프된 모든 barasi-card 추적
    const cards = document.querySelectorAll('.barasi-card');
    console.group('🧩 barasi-card layout debug');
    console.log(`총 ${cards.length}개 barasi-card 발견됨`);
    cards.forEach((card, i) => {
        const cs = getComputedStyle(card);
        console.log(
        `%c#${i+1} [barasi-card]`,
        'color:#0af;font-weight:bold;',
        {
            display: cs.display,
            flexGrow: cs.flexGrow,
            flexShrink: cs.flexShrink,
            height: cs.height,
            overflow: cs.overflow,
            marginBottom: cs.marginBottom
        }
        );
    });
    console.groupEnd();

    // flex가 살아있는 부모 컨테이너 찾기
    const pdfArea = document.querySelector('#pdfArea');
    const pdfCS = getComputedStyle(pdfArea);
    console.group('🧩 pdfArea 상태');
    console.log('display=', pdfCS.display, '| overflow=', pdfCS.overflow);
    console.groupEnd();

    // barasi-body 내부 cell 균등 확인
    document.querySelectorAll('.barasi-body').forEach((body, idx) => {
        const cells = body.querySelectorAll('.cell');
        if (!cells.length) return;
        const widths = Array.from(cells).map(c => c.offsetWidth.toFixed(1));
        console.log(`barasi-body[${idx}] cell width:`, widths.join(' / '));
    });

    // 전체 높이 변화 추적 (1초마다)
    let lastHeights = [];
    setInterval(() => {
        const heights = Array.from(cards).map(c => c.offsetHeight);
        if (JSON.stringify(heights) !== JSON.stringify(lastHeights)) {
        console.warn('⚠️ barasi-card 높이 변화 감지:', heights);
        lastHeights = heights;
        }
    }, 1000);
    });
</script>


<script>
document.addEventListener('DOMContentLoaded', () => {
  try {
    const svgs = document.querySelectorAll('svg#canvas');
    if (!svgs.length) {
      console.error('❌ SVGFit: canvas ID를 가진 <svg>를 찾을 수 없습니다.');
      return;
    }

    svgs.forEach((svg, i) => {
      const g = svg.querySelector('#viewport');
      if (!g) {
        console.error(`❌ SVG ${i+1}: #viewport 그룹이 없습니다.`);
      } else {
        const bb = g.getBBox();
        console.log(`✅ SVG ${i+1} bbox: x=${bb.x}, y=${bb.y}, w=${bb.width}, h=${bb.height}`);
      }
    });

    SVGFit.fitAllById('canvas', 'viewport', {
      padding: 20,
      setSize: false,
      preserve: 'xMidYMid meet',
    });
  } catch (err) {

    console.error('🔥 SVGFit 에러 발생:', err);

  }
});
</script>

<!-- ✅ 도면용 스크립트 -->
<script>
(function (root) {
  function getTransformedBBox(el) {
    const bb = el.getBBox();
    const m  = el.getCTM();
    if (!m) return bb;

    const P = (x, y) => {
      const pt = el.ownerSVGElement.createSVGPoint();
      pt.x = x; pt.y = y;
      return pt.matrixTransform(m);
    };
    const p1 = P(bb.x, bb.y);
    const p2 = P(bb.x + bb.width, bb.y);
    const p3 = P(bb.x, bb.y + bb.height);
    const p4 = P(bb.x + bb.width, bb.y + bb.height);
    const xs = [p1.x, p2.x, p3.x, p4.x];
    const ys = [p1.y, p2.y, p3.y, p4.y];
    return {
      x: Math.min(...xs),
      y: Math.min(...ys),
      width: Math.max(...xs) - Math.min(...xs),
      height: Math.max(...ys) - Math.min(...ys)
    };
  }

  function getPPU(svg) {
    const m = svg.getScreenCTM && svg.getScreenCTM();
    if (!m) return 1;
    const sx = Math.hypot(m.a, m.b);
    const sy = Math.hypot(m.c, m.d);
    return (sx + sy) / 2 || 1;
  }

  function compensateTexts(svg, groups, factor) {
    if (!factor || factor === 1) return;
    const nodes = [];
    for (const g of groups) nodes.push(...g.querySelectorAll('text, .dim-text, .label'));
    const f = Math.max(0.75, Math.min(2.5, factor));
    nodes.forEach(el => {
      el.style.transformBox = 'fill-box';
      el.style.transformOrigin = 'center';
      el.style.transform = `scale(${f})`;
    });
  }

  function fitAllById(svgId='canvas', groupId='viewport', {padding=20,setSize=false}={}) {
    const svgs = document.querySelectorAll(`svg[id="${svgId}"]`);
    for (const svg of svgs) {
      const groups = svg.querySelectorAll(`[id="${groupId}"]`);
      if (!groups.length) continue;

      const bb = getTransformedBBox(groups[0]);
      const x = bb.x - padding;
      const y = bb.y - padding;
      const w = bb.width + padding * 2;
      const h = bb.height + padding * 2;
      svg.setAttribute('viewBox', `${x} ${y} ${w} ${h}`);
      svg.setAttribute('preserveAspectRatio', 'xMinYMin meet');

      requestAnimationFrame(() => {
        const before = getPPU(svg);
        const after = getPPU(svg);
        compensateTexts(svg, groups, before / after);
      });
    }
  }
  root.SVGFit = { fitAllById };
})(window);

document.addEventListener('DOMContentLoaded', () => {
  SVGFit.fitAllById('canvas', 'viewport', {padding:20,setSize:false});
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