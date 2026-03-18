/* =========================
   네스팅 계산 전용
   - mm 기준
   - canvas / scale / A4 모름
========================= */

function expandItems(items){
  const out = [];
  items.forEach(it=>{
    const qty = Number(it.qty||0);
    for(let i=0;i<qty;i++){
      out.push({
        w: Number(it.width),
        len: Number(it.length),
        name: it.baname
      });
    }
  });
  out.sort((a,b)=>(b.w-a.w)||(b.len-a.len));
  return out;
}

function buildSheets(items, sheetW, sheetH){
  const sheets = [];
  let sheet = { strips:[], usedW:0 };
  sheets.push(sheet);

  const map = new Map();
  items.forEach(it=>{
    if(!map.has(it.w)) map.set(it.w, []);
    map.get(it.w).push(it);
  });

  [...map.keys()].sort((a,b)=>b-a).forEach(w=>{
    const arr = map.get(w);

    while(arr.length){
      if(sheet.usedW + w > sheetH){
        sheet = { strips:[], usedW:0 };
        sheets.push(sheet);
      }

      const strip = { stripW:w, pieces:[], usedLen:0 };

      while(arr.length && strip.usedLen + arr[0].len <= sheetW){
        strip.pieces.push(arr.shift());
        strip.usedLen += strip.pieces.at(-1).len;
      }

      sheet.strips.push(strip);
      sheet.usedW += w;

      if(strip.pieces.length === 0) arr.shift(); // 안전장치
    }
  });

  return sheets;
}
