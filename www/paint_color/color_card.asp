<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

Dim pidx, rs, pname, pcode, hexColor, brandName, paintImg
pidx = Request.QueryString("pidx")

If pidx = "" Or Not IsNumeric(pidx) Then
  Response.Write "pidx 파라미터 필요"
  Response.End
End If

Set rs = Dbcon.Execute("SELECT p.pidx, p.pname, p.pcode, p.p_hex_color, p.p_image, " & _
  "ISNULL(b.pname_brand,'') AS brand_name " & _
  "FROM tk_paint p LEFT JOIN tk_paint_brand b ON p.pname_brand = b.pbidx " & _
  "WHERE p.pidx=" & CLng(pidx))

If rs.EOF Then
  Response.Write "해당 페인트 없음 (pidx=" & pidx & ")"
  Response.End
End If

pname = rs("pname") & ""
pcode = rs("pcode") & ""
hexColor = rs("p_hex_color") & ""
brandName = rs("brand_name") & ""
paintImg = rs("p_image") & ""
rs.Close
Set rs = Nothing

' hex 없으면 기본 회색
If hexColor = "" Then hexColor = "#CCCCCC"

call dbClose()
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title><%=pname%> - 색상 카드</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  font-family: "Malgun Gothic", "맑은 고딕", sans-serif;
  background: #f5f5f5;
  display: flex; flex-direction: column;
  justify-content: center; align-items: center;
  min-height: 100vh; gap: 12px;
}
#cardImg {
  border: 1px solid #ddd;
  cursor: pointer;
}
.btn-row {
  display: flex; gap: 8px; align-items: center;
}
.btn-copy {
  padding: 8px 20px; font-size: 13px; font-weight: 700;
  background: #3b82f6; color: #fff; border: none; border-radius: 6px;
  cursor: pointer; transition: background 0.15s;
}
.btn-copy:hover { background: #2563eb; }
.btn-copy:active { background: #1d4ed8; }
.status {
  font-size: 12px; color: #059669; font-weight: 600;
  min-height: 18px;
}
.hint {
  font-size: 11px; color: #999;
}
</style>
</head>
<body>

<canvas id="cardCanvas" width="480" height="160" style="display:none"></canvas>
<img id="cardImg" title="클릭하면 이미지 복사">
<div class="btn-row">
  <button class="btn-copy" id="btnCopy">이미지 복사 (Ctrl+C)</button>
  <span class="status" id="status"></span>
</div>
<div class="hint">복사 후 카톡/메일에 Ctrl+V로 붙여넣기</div>

<script>
(function(){
  var DATA = {
    hex: "<%=hexColor%>",
    brand: "<%=Replace(brandName, """", "\""")%>",
    code: "<%=Replace(pcode, """", "\""")%>",
    name: "<%=Replace(pname, """", "\""")%>"
  };

  var canvas = document.getElementById("cardCanvas");
  var ctx = canvas.getContext("2d");
  var W = 480, H = 160;
  var SWATCH_W = 300;

  // --- Canvas에 색상카드 그리기 ---
  function drawCard() {
    // 배경 (흰색)
    ctx.fillStyle = "#fff";
    ctx.fillRect(0, 0, W, H);

    // 왼쪽: 대표색 영역
    ctx.fillStyle = DATA.hex;
    ctx.fillRect(0, 0, SWATCH_W, H);

    // 구분선
    ctx.strokeStyle = "#ddd";
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(SWATCH_W, 0);
    ctx.lineTo(SWATCH_W, H);
    ctx.stroke();

    // 오른쪽: 텍스트 정보
    var tx = SWATCH_W + 16;
    var ty = 45;

    // 제조사
    if (DATA.brand) {
      ctx.fillStyle = "#1a237e";
      ctx.font = "bold 14px 'Malgun Gothic', sans-serif";
      ctx.fillText(DATA.brand, tx, ty);
      ty += 22;
    }

    // 코드
    if (DATA.code) {
      ctx.fillStyle = "#333";
      ctx.font = "bold 13px 'Malgun Gothic', sans-serif";
      ctx.fillText(DATA.code, tx, ty);
      ty += 20;
    }

    // 페인트명
    if (DATA.name) {
      ctx.fillStyle = "#555";
      ctx.font = "13px 'Malgun Gothic', sans-serif";
      ctx.fillText(DATA.name, tx, ty);
      ty += 22;
    }

    // HEX 코드
    ctx.fillStyle = "#999";
    ctx.font = "11px 'Consolas', monospace";
    ctx.fillText(DATA.hex, tx, ty);

    // 테두리
    ctx.strokeStyle = "#ccc";
    ctx.lineWidth = 1;
    ctx.strokeRect(0.5, 0.5, W - 1, H - 1);
  }

  drawCard();

  // Canvas → img 태그에 표시 (우클릭 복사 가능)
  var imgEl = document.getElementById("cardImg");
  imgEl.src = canvas.toDataURL("image/png");

  // --- 클립보드 복사 함수 ---
  function copyToClipboard() {
    var statusEl = document.getElementById("status");
    canvas.toBlob(function(blob) {
      if (!blob) {
        statusEl.textContent = "이미지 생성 실패";
        statusEl.style.color = "#ef4444";
        return;
      }
      var item = new ClipboardItem({"image/png": blob});
      navigator.clipboard.write([item]).then(function() {
        console.log("[COLOR_CARD] 클립보드 복사 성공");
        statusEl.textContent = "복사 완료!";
        statusEl.style.color = "#059669";
        setTimeout(function(){ statusEl.textContent = ""; }, 2000);
      }).catch(function(err) {
        console.error("[COLOR_CARD] 클립보드 복사 실패:", err);
        statusEl.textContent = "복사 실패 - 우클릭→이미지 복사 사용";
        statusEl.style.color = "#ef4444";
      });
    }, "image/png");
  }

  // 버튼 클릭
  document.getElementById("btnCopy").onclick = copyToClipboard;

  // 이미지 클릭
  imgEl.onclick = copyToClipboard;

  // Ctrl+C 단축키
  document.addEventListener("keydown", function(e) {
    if ((e.ctrlKey || e.metaKey) && e.key === "c") {
      e.preventDefault();
      copyToClipboard();
    }
  });

})();
</script>

</body>
</html>
