window.SELECTED_ITEM = null;
window.SELECTED_MATERIAL = null;

Split(['#left','#right'],{
  sizes:[40,60],
  minSize:[320,420],
  gutterSize:14
});

function selectNestingItem(item){
  window.SELECTED_ITEM = item;


  // 기존 폭 기준 렌더 재사용
  renderNestingByWidth(item.width);
}


function parseSheet(v){
  const [w,h] = v.split('x').map(Number);
  return { sheetW:h, sheetH:w, label:`${w}×${h}` };
}

function getMaterialList(items){
  const set = new Set();
  items.forEach(it => {
    if(it.material) set.add(it.material);
  });
  return Array.from(set);
}

function renderMaterialTabs(){
  const wrap = document.getElementById("materialTabs");
  if(!wrap) return;
  wrap.innerHTML = "";

  const materials = getMaterialList(RAW_ITEMS);
  if(materials.length === 0) return;

  if(!window.SELECTED_MATERIAL) window.SELECTED_MATERIAL = materials[0];

  materials.forEach(m => {
    const btn = document.createElement("button");
    btn.className = "mat-btn";
    btn.textContent = m;
    btn.onclick = () => {
      window.SELECTED_MATERIAL = m;
      renderMaterialTabs();
      render();
    };
    if(m === window.SELECTED_MATERIAL) btn.classList.add("active");
    wrap.appendChild(btn);
  });
}

function getFilteredItems(){
  if(!window.SELECTED_MATERIAL) return RAW_ITEMS;
  return RAW_ITEMS.filter(it => it.material === window.SELECTED_MATERIAL);
}

function render(){
  const {sheetW,sheetH,label} = parseSheet(window.SHEET_VALUE || "1219x4000");
  const list = document.getElementById("sheetList");
  list.innerHTML = "";

  const expanded = expandItems(getFilteredItems());
  const sheets   = buildSheets(expanded, sheetW, sheetH);

  stat.textContent = `총 ${expanded.length}개 / 시트 ${sheets.length}장`;

  sheets.forEach((s,i)=>{
    const card = document.createElement("div");
    card.className="sheetCard";
    card.innerHTML = `
      <div class="sheetHead">
        <div>${i+1}번 시트</div>
        <div>${label}</div>
      </div>
    `;

    const c = document.createElement("canvas");
    drawSheetScreen(c, s, sheetW, sheetH);

    card.appendChild(c);
    list.appendChild(card);
  });
}
function renderNestingByWidth(targetWidth){

  const {sheetW, sheetH} = parseSheet(window.SHEET_VALUE || "1219x4000");
  const list = document.getElementById("sheetList");
  list.innerHTML = "";

  // 🔥 선택한 샤링값만 필터
  const filtered = getFilteredItems().filter(it => Number(it.width) === Number(targetWidth));

  if(filtered.length === 0){
    list.innerHTML = "<div style='padding:20px'>선택한 샤링값 없음</div>";
    return;
  }

  const expanded = expandItems(filtered);
  const sheets   = buildSheets(expanded, sheetW, sheetH);

  sheets.forEach((s, i)=>{
    const card = document.createElement("div");
    card.className = "sheetCard";
    card.innerHTML = `
      <div class="sheetHead">
        <div>${i+1}번 시트</div>
        <div>샤링 ${targetWidth}mm</div>
      </div>
    `;

    const c = document.createElement("canvas");
    drawSheetScreen(c, s, sheetW, sheetH);

    card.appendChild(c);
    list.appendChild(card);
  });
}

btnGenerate.onclick = render;
btnPrint.onclick = ()=>window.print();
renderMaterialTabs();
render();
