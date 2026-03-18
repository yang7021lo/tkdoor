function drawSheetScreen(canvas, sheet, sheetW, sheetH){
  const margin = 20;
  const baseW  = 900;
  const scale  = (baseW - margin*2) / sheetW;

  canvas.width  = baseW;
  canvas.height = sheetH * scale + margin*2;

  const ctx = canvas.getContext("2d");
  ctx.clearRect(0,0,canvas.width,canvas.height);

  ctx.strokeStyle="#111";
  ctx.lineWidth=2;
  ctx.strokeRect(margin,margin,sheetW*scale,sheetH*scale);

  let y = 0;
  let cutNo = 1;

  sheet.strips.forEach(st=>{
    const rh = st.stripW * scale;
    const ry = margin + y * scale;

    ctx.fillStyle="#bcd4ea";
    ctx.fillRect(margin,ry,sheetW*scale,rh);
    ctx.strokeRect(margin,ry,sheetW*scale,rh);

    let x = 0;
    st.pieces.forEach(p=>{
      const rw = p.len * scale;
      const rx = margin + x * scale;

      const isSelected =
        window.SELECTED_ITEM &&
        Number(p.w) === Number(window.SELECTED_ITEM.width);

      if(isSelected){
        ctx.fillStyle = "rgba(255,80,80,0.6)";
        ctx.fillRect(rx, ry, rw, rh);
      }

      ctx.strokeStyle = "#111";
      ctx.strokeRect(rx,ry,rw,rh);

      ctx.fillStyle = isSelected ? "#fff" : "#111";
      ctx.font = "bold 12px Arial";
      ctx.fillText(`${p.w}×${p.len}`, rx+6, ry+18);
      ctx.fillText(`#${cutNo++}`, rx+6, ry+rh-6);

      if(isSelected){
        console.log("[HIT]", p.w, p.len);
      }

      x += p.len;
    });

    y += st.stripW;
  });
}
