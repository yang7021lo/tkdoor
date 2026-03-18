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
SQL = SQL & ", ds_daesinaddr, yaddr, sjsidx, cidx, sjmidx, g_bogang, g_busok"
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

<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>절곡 발주서</title>
  <style>

    /* 드래그 시 텍스트 선택 효과 제거 */
     body { margin: 20px; font-family: 'Noto Sans KR', sans-serif; }
    
    :root{
      --bg:#f7f7f7;
      --card-bg:#fff;
      --label:#fff9d6; /* 연한 노란색 */
      --muted:#555;
      --accent:#222;
      --gap:18px;
      font-family: 'Noto Sans KR', Arial, sans-serif;
    }
    body{background:var(--bg); margin:20px; color:var(--muted)}

    header.page-header{
      display:flex; 
      gap:12px; 
      align-items:center; 
      padding:10px 12px; background:#fff; 
      border:1px solid #e3e3e3; 
      border-radius:6px; 
      margin-bottom:18px;
    }
    header .meta{font-size:19px; padding-right: 40px;}

    .grid{
      display:grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap:var(--gap);
      align-items:start;
    }

    .card{
      background:var(--card-bg);
      border:1px solid #e6e6e6;
      border-radius:6px;
      padding:10px;
      box-shadow:0 1px 0 rgba(0,0,0,0.03);
      
    }

    .label{
      display:inline-block;
      background:var(--label);
      padding:6px 10px;
      border-radius:4px;
      font-weight:700;
      margin-bottom:8px;
      font-size:25px;
    }

    .label1{
      display:inline-block;
      padding:6px 10px;
      border-radius:4px;
      font-weight:700;
      margin-bottom:8px;
      font-size:23px;
    }




    .label, .specs {
    display: inline-block;
    vertical-align: middle;
    }

    .specs{
      display:flex; gap:8px; margin:8px 0; align-items:center; flex-wrap:wrap;
    }
    .specs .hl{background:#fff; border:1px solid #eee; padding:6px 8px; border-radius:4px; font-weight:600}
    .specs .qty{font-size:20px; font-weight:800}

    .preview {
        width: 100%;
        height: auto;
        max-height: 200px; /* 카드 높이 제한 */
        display: flex;
        justify-content: center;
        align-items: center;
        border: 1px solid #eee;
        border-radius: 4px;
        background: #fff;
        overflow: hidden;
    }

    .preview svg {
        width: 100%;
        height: auto;
    }
    ::selection {
        background: transparent; /* 선택 배경 없앰 */
        color: inherit;          /* 글자 색 유지 */
    }
    #size-list {
        font-weight: bold;   /* 글씨 굵게 */
        font-size: 20px;     /* 글씨 크기 */
    }

      /* 드래그 영역 */
    /*
    #select-area {
        position: absolute;
        border: 2px dashed red;
        background: rgba(255,0,0,0.1);
        display: none;
        pointer-events: none; 
        z-index: 1000;
    }
    */
    
    .preview img{max-width:100%; max-height:100%; object-fit:contain}

    .preview svg line{
    stroke-width: 2; /* div 크기에 따라 상대적으로 설정 가능 */
    }

    .sizes{
      /*background:var(--label);*/
      padding:8px; border-radius:4px; 
      font-size:28px; 
      line-height:1.6; 
      display:block;
      
    }
    .sizes label{
        display:block;

    }

    .card-footer{margin-top:8px; display:flex; gap:8px; align-items:center;}
    .btn{background:#fff; border:1px solid #e1e1e1; padding:6px 8px; border-radius:4px; cursor:pointer}

    /* small responsive tweaks */
    @media (max-width:480px){
      .preview{height:120px}
      .specs .qty{font-size:18px}
    }
    .sizes.total {
        font-weight: bold;     /* 글자 굵게 */
        font-size: 25px;       /* 조금 더 크게 */
        color: #222222;        /* 진한 색상 */
        margin-top: 10px;      /* 카드와 간격 */
    }

    
      </style>
</head>
<body>
   <body>
    <div id="capture-area">
    <!-- 화면 최상단에 선택 박스 -->
    <div id="select-area"></div>
    <!-- 📌 상단 제목 + 날짜 (큰 글씨, 한 줄) -->
    <div id="pdf-header" style="display:flex; justify-content:space-between; 
            align-items:center; font-size:24px; font-weight:700; margin-bottom:15px;">
        <div>절곡 발주서</div>
        <div id="select-area"></div>

        <button id="exportPDFBtn">PDF 내보내기</button>
        <div>
            <%=Year(Now())%>-<%=Right("0" & Month(Now()),2)%>-<%=Right("0" & Day(Now()),2)%>
            (<%=Left(WeekdayName(Weekday(Now()), False, 1),1)%>)
            <%=Right("0" & Hour(Now()),2)%>:<%=Right("0" & Minute(Now()),2)%>
        </div>
    </div>
        <header class="page-header" style="margin-bottom:20px;">

            <!-- 📌 메타정보: 줄바꿈되도록 block 요소로 정리 -->
            <div class="meta">발주처: <strong><%=cname%></strong></div>
            <div class="meta">수주일자: <strong><%=sjdate%></strong></div>
            <div class="meta">수주번호: <strong><%=sjnum%> : <%=p%>번</strong></div>
            <div class="meta">현장명: <strong><%=cgaddr%></strong></div>
            <div class="meta">출고일자: <strong><%=cgdate%></strong></div>
            <div class="meta">도장출고일: <strong><%=djcgdate%></strong></div>
            <div class="meta">도장번호: <strong><%=djnum%></strong></div>
        </header>
    </div>
    <!-- 📌 본문 영역 -->

</body>

    <main>
    <section class="grid" id="grid">
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
        SQL = "SELECT max(accsize) FROM tk_barasisub WHERE baidx='" & baidx & "'"
        Set Rs2 = Dbcon.Execute(SQL)
        If Not (Rs2.BOF Or Rs2.EOF) Then
            maxaccsize = Rs2(0)
        End if
        'Response.write (SQL)&" 1차 바라시 쿼리<br>"
        Rs2.Close
        %>

        <article class="card">
            <div class="label" style=""><%=loop_count%>번 CH<%=bachannel%></div>
            <div class="label" style="">샤링값 : <%=maxaccsize%></div><br>
            <div class="label1" style="margin-top:6px;"><%=baname%></div><br>

            <div class="specs">
                <div class="hl ">
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
            </div>

            

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
                SQL = SQL & "    g.xsize, g.ysize, g.sx1, g.sx2, g.sy1, g.sy2, "
                SQL = SQL & "    COUNT(*) OVER() AS cnt "
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
                if(g_bogang = 1) Then 
                    SQL = SQL & "ORDER BY r.sjsidx_order, g.qtyname, g.fkidx, g.bfidx"
                Else 
                     SQL = SQL & "ORDER BY g.blength DESC, r.sjsidx_order, g.qtyname, g.fkidx, g.bfidx"
                End if
                
                ' Response.write (SQL)&" 사이즈 업데이트 <br> "
                Rs.open Sql,Dbcon
                if not (Rs.EOF or Rs.BOF ) then
                Do while not Rs.EOF
                    
                    sjsidx_order    = Rs("sjsidx_order")
                    blength        = Rs("blength")
                    same_xy_count  = Rs("same_xy_count")
                    quan           = Rs("quan")
                    total_cnt = Rs("cnt")
                    
                    total_quan = quan * same_xy_count 

                    if g_bogang = 1   then
                            blength = blength - 2
                             i = 1  
                            '갈바 보강 일경우
                            'sjsidx_order 갯수 가져오기
                            SQL_cnt = ""
                            SQL_cnt = SQL_cnt & "WITH base AS ( "
                            SQL_cnt = SQL_cnt & "  SELECT DISTINCT t.sjidx, t.sjsidx, t.fkidx, t.fksidx, t.bfidx, t.qtyname, t.blength, t.quan, "
                            SQL_cnt = SQL_cnt & "         t.WHICHI_FIX, t.WHICHI_AUTO, t.rot_type "
                            SQL_cnt = SQL_cnt & "  FROM tk_balju_st t "
                            SQL_cnt = SQL_cnt & "  JOIN tk_framekSub fs ON fs.fksidx = t.fksidx "
                            SQL_cnt = SQL_cnt & "  WHERE t.sjidx='" & rsjidx & "' AND t.insert_flag=1 "
                            SQL_cnt = SQL_cnt & "    AND fs.rstatus=2 AND fs.rstatus2=2 "
                            SQL_cnt = SQL_cnt & "), rank_s AS ( "
                            SQL_cnt = SQL_cnt & "  SELECT sjsidx, "
                            SQL_cnt = SQL_cnt & "         DENSE_RANK() OVER (ORDER BY sjsidx) AS sjsidx_order "
                            SQL_cnt = SQL_cnt & "  FROM (SELECT DISTINCT sjsidx FROM base) d "
                            SQL_cnt = SQL_cnt & "), grp AS ( "
                            SQL_cnt = SQL_cnt & "  SELECT t.sjsidx "
                            SQL_cnt = SQL_cnt & "  FROM base t "
                            SQL_cnt = SQL_cnt & "  WHERE t.bfidx='" & bfidx & "' "
                            SQL_cnt = SQL_cnt & "    AND t.qtyname='" & qtyname & "' "
                            SQL_cnt = SQL_cnt & "  GROUP BY t.sjsidx, t.blength "
                            SQL_cnt = SQL_cnt & ") "
                            SQL_cnt = SQL_cnt & "SELECT COUNT(*) AS sjsidx_order_count "
                            SQL_cnt = SQL_cnt & "FROM ( "
                            SQL_cnt = SQL_cnt & "  SELECT r.sjsidx_order "
                            SQL_cnt = SQL_cnt & "  FROM grp g "
                            SQL_cnt = SQL_cnt & "  JOIN rank_s r ON r.sjsidx = g.sjsidx "
                            SQL_cnt = SQL_cnt & ") X "
                            SQL_cnt = SQL_cnt & "WHERE X.sjsidx_order = '" & sjsidx_order & "'"
                            Rs2.Open SQL_cnt, dbcon
                            If Not Rs2.EOF Then
                                sjsidx_order_count = Rs2("sjsidx_order_count")
                            End If
                            Rs2.Close

                    

                            '분할 된 상태인지 확인하기 
                            '분할된 상태라면
                            if(same_xy_count > 1 AND sjsidx_order_count > 0) Then 

                        
                                sum_blength  = 0
                                '분할전 사이즈 가져오기
                                
                                SQL = ""
                                SQL = SQL & "WITH base AS ( "
                                SQL = SQL & "    SELECT "
                                SQL = SQL & "        sjsidx, "
                                SQL = SQL & "        whichi_auto, "
                                SQL = SQL & "        CAST(blength AS FLOAT) AS blength, "
                                SQL = SQL & "        fksidx "
                                SQL = SQL & "    FROM tk_balju_st "
                                SQL = SQL & "    WHERE sjidx = '" & rsjidx & "' "
                                SQL = SQL & "      AND insert_flag = 1 "
                                SQL = SQL & "), rank_s AS ( "
                                SQL = SQL & "    SELECT sjsidx, "
                                SQL = SQL & "           DENSE_RANK() OVER (ORDER BY sjsidx) AS sjsidx_order "
                                SQL = SQL & "    FROM (SELECT DISTINCT sjsidx FROM base) d "
                                SQL = SQL & "), grp AS ( "
                                SQL = SQL & "    SELECT "
                                SQL = SQL & "        b.sjsidx, "
                                SQL = SQL & "        b.whichi_auto, "
                                SQL = SQL & "        b.blength, "
                                SQL = SQL & "        COUNT(DISTINCT b.fksidx) AS same_xy_count "
                                SQL = SQL & "    FROM base b "
                                SQL = SQL & "    GROUP BY b.sjsidx, b.whichi_auto, b.blength "
                                SQL = SQL & ") "
                                SQL = SQL & "SELECT "
                                SQL = SQL & "    g.blength, "
                                SQL = SQL & "    g.same_xy_count "
                                SQL = SQL & "FROM grp g "
                                SQL = SQL & "JOIN rank_s r ON r.sjsidx = g.sjsidx "
                                SQL = SQL & "WHERE r.sjsidx_order = '" & sjsidx_order & "' "
                                SQL = SQL & "  AND g.whichi_auto = '" & whichi_auto & "' "
                                SQL = SQL & "ORDER BY g.blength"
                                
                                Rs2.open SQL,  dbcon,1,1 
                                If Not (Rs2.BOF OR Rs2.EOF) Then
                                    Do while not Rs2.EOF
                                        
                                            z_blength = CLng(Rs2("blength"))
                                            same_xy_count = CLng(Rs2("same_xy_count"))

                                            sum_blength = sum_blength + (z_blength * same_xy_count)

                                        Rs2.MoveNext
                            
                                    Loop
                                End If
                                Rs2.close()

                                    '절반으로 자르기
                                    sum_blength = int(sum_blength / 2)
                                    
                                       '첫번째 길이만 -2 빠지기 i = 1 값만 -2 
                                                if(CLng(sjsidx_order) = CLng(s_sjsidx_order)) Then 
                                                     i = i + 1     
                                                Else 
                                                    s_sjsidx_order = sjsidx_order
                                                    i = 1
                                                End if
                                               
                                                if(i = 1) Then 
                                                        sum_blength = sum_blength - 2
                                                        s_sjsidx_order = sjsidx_order
                                                End if

                                total_quan = 1
                                '2등분일 경우 레코드가 1개만 출력 되므로 레코드 1개다 추가 하기
                                    if(CLng(same_xy_count > 1) and CLng( sjsidx_order_count = 1) ) Then 
                                    
                                    %>
                                       
                                       <div id="size-list">
                                            &nbsp<%=sjsidx_order%>번  <%=blength%>mm = <%=total_quan%>개&nbsp;&#9633;
                                        </div>
                                    <%
                                        sum_blength = sum_blength + 2
                                    End if
                                    
                                blength = sum_blength
                            End if

                    end if

                    if  g_busok = 1 then
                        blength = 200
                    end if

                    if  g_autorf = 1 then
                        if (sjb_type_no = 1 or sjb_type_no = 2 or sjb_type_no = 3 or sjb_type_no = 4) then
                            blength = blength - 135
                        elseif (sjb_type_no = 8 or sjb_type_no = 9 or sjb_type_no = 10 or sjb_type_no = 15) then
                            blength = blength - 2
                        end if
                    end if

                   

                %>
        <div class="sizes">
            <div id="size-list">
                <%=sjsidx_order%>번  <%=blength%>mm = <%=total_quan%>개&nbsp;&#9633;
            </div>
        </div>
        <%
        Rs.movenext
        Loop
        end if
        Rs.close

        %>
        <div class="sizes total label" style="text-align: right;">
            총합 : <%=total_cnt%> 개
        </div>
        </article>

        <%
            Rs1.MoveNext
            Loop
        End If
        Rs1.Close
        %>
    </section>
    </main>
 
    <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script>
document.addEventListener("DOMContentLoaded", () => {

    const cards = Array.from(document.querySelectorAll("#grid .card"));
    const exportBtn = document.getElementById("exportPDFBtn");
    const header = document.getElementById("capture-area");

    const gap = 18;
    const cardsPerRow = 6;
    const pagePadding = 20;

    // ------------------------------------------------------------
    // 🔥 PDF에서 사용될 카드 HTML 변환기 (가장 중요함)
    // ------------------------------------------------------------
    function forceWhiteCard(card) {
        let html = card.outerHTML;

        // <article class="card"> 에만 흰색 배경 + 테두리 강제
        html = html.replace(
            /<article([^>]*)class="card"([^>]*)>/i,
            `<article$1class="card"$2 
             style="background:#ffffff !important;
                    border-radius:8px;
                    box-shadow:0 0 0 2px #e6e6e6;
                    padding:10px;">`
        );

        return html;
    }

    // ------------------------------------------------------------
    // 🔥 PDF 버튼 클릭 이벤트
    // ------------------------------------------------------------
    exportBtn.addEventListener("click", async () => {

        if (!header) return alert("캡처 영역(capture-area)을 찾을 수 없습니다!");

        const { jsPDF } = window.jspdf;
        const pdf = new jsPDF({
            orientation: "landscape",
            unit: "pt",
            format: "a4"
        });

        const pageWidth = pdf.internal.pageSize.getWidth() - pagePadding * 2;
        const pageHeight = pdf.internal.pageSize.getHeight() - pagePadding * 2;

        // 임시 렌더링 영역 생성
        const temp = document.createElement("div");
        temp.style.position = "absolute";
        temp.style.left = "-99999px";
        temp.style.top = "-99999px";
        document.body.appendChild(temp);

        exportBtn.style.display = "none";

        let i = 0;
        let currentPage = 1;

        // ------------------------------------------------------------
        // 🔄 페이지 반복
        // ------------------------------------------------------------
        while (i < cards.length) {

            temp.innerHTML = "";

            // 이번 페이지에 넣을 카드들 10개(5x2)
            let pageCards = cards.slice(i, i + cardsPerRow * 2);

            // --------------------------
            // 📌 PDF에 넣을 HTML 구성
            // --------------------------
            let html = `
                <div style="
                    padding:${pagePadding}px;
                    background:#f7f7f7;
                    width:max-content;
                ">
                    ${header.outerHTML}
            `;

            const cardWidth = 300;

            // ========== 1줄 (5개 이하) ==========
            if (pageCards.length <= cardsPerRow) {

                  html += `
                    <div style="display:grid;
                           grid-template-columns: repeat(${cardsPerRow}, ${cardWidth}px);
                            gap:${gap}px;
                                margin-top:20px;">
                    `;

                pageCards.forEach(card => {
                    html += `
                        <div style="height:auto; overflow:hidden;">
                            ${forceWhiteCard(card)}
                        </div>
                    `;
                });

                html += `</div>`;

            }

            // ========== 2줄 구성 ==========
            else {

                const firstRowCards = pageCards.slice(0, cardsPerRow);
                const secondRowCards = pageCards.slice(cardsPerRow);

                html += `
                    <div style="display:flex; flex-direction:column; gap:${gap}px; margin-top:20px;">
                        <div style="display:flex; flex-wrap:wrap; gap:${gap}px;">
                `;

                firstRowCards.forEach(card => {
                    html += `
                        <div style="flex:0 0 ${cardWidth}px; overflow:hidden;">
                            ${forceWhiteCard(card)}
                        </div>
                    `;
                });

                html += `
                        </div>
                        <div style="display:flex; flex-wrap:wrap; gap:${gap}px;">
                `;

                secondRowCards.forEach(card => {
                    html += `
                        <div style="flex:0 0 ${cardWidth}px; overflow:hidden;">
                            ${forceWhiteCard(card)}
                        </div>
                    `;
                });

                html += `
                        </div>
                    </div>
                `;
            }

            html += `</div>`;

            temp.innerHTML = html;

            // ------------------------------------------------------------
            // 📸 html2canvas 캡처
            // ------------------------------------------------------------
            const canvas = await html2canvas(temp, {
                scale: 2,
                useCORS: true,
                backgroundColor: null
            });

            const imgData = canvas.toDataURL("image/png");
            const imgProps = pdf.getImageProperties(imgData);

            let pdfWidth = pageWidth;
            let pdfHeightAdjust = (imgProps.height * pdfWidth) / imgProps.width;

            if (pdfHeightAdjust > pageHeight) {
                pdfHeightAdjust = pageHeight;
            }

            pdf.addImage(
                imgData,
                "PNG",
                pagePadding,
                pagePadding,
                pdfWidth,
                pdfHeightAdjust
            );

            // ------------------------------------------------------------
            // 📌 페이지 번호
            // ------------------------------------------------------------
            pdf.setFontSize(10);
            pdf.setTextColor(120);
            pdf.text(
                `${currentPage} Page`,
                pdf.internal.pageSize.getWidth() / 2,
                pdf.internal.pageSize.getHeight() - 10,
                { align: "center" }
            );

            i += pageCards.length;
            currentPage++;

            if (i < cards.length) pdf.addPage();
        }

        exportBtn.style.display = "inline-block";

        const blob = pdf.output("blob");
        window.open(URL.createObjectURL(blob), "_blank");
    });
});






    </script>
</body>
</html>