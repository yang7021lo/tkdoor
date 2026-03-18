function drawSheetPrint(canvas, sheet, sheetW, sheetH){
  const A4_W = 794;        // A4 width px
  const PRINT_H = 650;     // 🔥 여기서 키운다 (600~680 사이 추천)
  const margin = 30;

  canvas.width  = A4_W;
  canvas.height = PRINT_H;

  const usableW = A4_W - margin * 2;
  const usableH = PRINT_H - margin * 2;

  // 👉 시트 전체가 캔버스를 최대한 채우도록
  const scale = Math.min(
    usableW / sheetW,
    usableH / sheetH
  );

  const ctx = canvas.getContext("2d");
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  // 외곽
  ctx.strokeStyle = "#111";
  ctx.lineWidth = 2;
  ctx.strokeRect(
    margin,
    margin,
    sheetW * scale,
    sheetH * scale
  );

  let y = 0;

  sheet.strips.forEach(st=>{
    const rh = st.stripW * scale;
    const ry = margin + y * scale;

    ctx.fillStyle = "#cfe3f2";
    ctx.fillRect(margin, ry, sheetW * scale, rh);
    ctx.strokeRect(margin, ry, sheetW * scale, rh);

    let x = 0;
    st.pieces.forEach(p=>{
      const rw = p.len * scale;
      const rx = margin + x * scale;
      ctx.strokeRect(rx, ry, rw, rh);
      x += p.len;
    });

    y += st.stripW;
  });
}
