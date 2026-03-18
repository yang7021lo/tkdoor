// ============================================
// Door Engine v1 - CLEAN FULL VERSION
// (아치/간살/존 선택 버그 수정본)
// ============================================

// ========================================================
// [BLOCK 0] CORE SAFE GUARD & DEBUG
// ========================================================

function call(fn) {
    if (typeof fn === "function") {
        try {
            var args = Array.prototype.slice.call(arguments, 1);
            return fn.apply(null, args);
        } catch (err) {
            console.error("[DoorEngine] call() 오류:", err);
        }
    }
}

function hasCanvas() {
    return (typeof canvas !== "undefined" && canvas && ctx);
}

function hasDoors() {
    return Array.isArray(doors) && doors.length > 0;
}

// 디버깅 토글
var DE_DEBUG = true;
function debugLog() {
    if (!DE_DEBUG) return;
    try {
        console.log.apply(console, arguments);
    } catch (e) {}
}



// ========================================================
// [BLOCK 1] CONST / STRUCTURE
// ========================================================

const FRAME = 30;
const SHEET_W = 1219;
const SHEET_H = 2438;

const doorStructure = {
    hinge: [
        { code:"1-1", name:"편개",    doors:1, fix:"none" },
        { code:"1-2", name:"좌픽스",  doors:1, fix:"left" },
        { code:"1-3", name:"우픽스",  doors:1, fix:"right" },
        { code:"1-4", name:"양픽스",  doors:1, fix:"both" },
        { code:"2-1", name:"양개",    doors:2, fix:"none" },
        { code:"2-2", name:"양개+좌", doors:2, fix:"left" },
        { code:"2-3", name:"양개+우", doors:2, fix:"right" },
        { code:"2-4", name:"양개+양", doors:2, fix:"both" }
    ],
    sliding: [
        { code:"S1", name:"1짝",    doors:1 },
        { code:"S2", name:"2짝",    doors:2 },
        { code:"S3", name:"3연동",  doors:3 }
    ],
    folding: [
        { code:"F2", name:"2짝", doors:2 },
        { code:"F4", name:"4짝", doors:4 }
    ],
    auto:   [ { code:"A-S", name:"자동슬라이딩", doors:1 } ],
    pocket: [ { code:"P1", name:"포켓1", doors:1 }, { code:"P2", name:"포켓2", doors:2 } ],
    swing:  [ { code:"SW1",name:"스윙1",doors:1 }, { code:"SW2",name:"스윙2",doors:2 } ],
    fixmix: [ { code:"FM", name:"픽스+도어", doors:1, fix:"right" } ]
};



// ========================================================
// [BLOCK 2] DOM CACHE
// ========================================================

const $ = function(id){ return document.getElementById(id); };

const canvas        = $("canvas");
const ctx           = canvas ? canvas.getContext("2d") : null;
const structureInfo = $("structureInfo");

const doorCount = $("doorCount");
const doorW     = $("doorW");
const doorH     = $("doorH");

const selW      = $("selW");
const selH      = $("selH");

const bottomH   = $("bottomH");

const btnApplyDoor   = $("btnApplyDoor");
const btnApplyFrame  = $("btnApplyFrame");
const btnApplyBottom = $("btnApplyBottom");
const btnResetBottom = $("btnResetBottom");

const btnAddVG       = $("btnAddVG");
const btnAddVGN      = $("btnAddVGN");
const btnResetVG     = $("btnResetVG");

const btnAddHG       = $("btnAddHG");
const btnAddHGN      = $("btnAddHGN");
const btnResetHGZone = $("btnResetHGZone");
const btnResetHGFrame= $("btnResetHGFrame");

const topArcH     = $("topArcH");
const botArcH     = $("botArcH");
const leftArcD    = $("leftArcD");
const rightArcD   = $("rightArcD");
const btnApplyArc = $("btnApplyArc");
const btnResetArc = $("btnResetArc");

const cutFrame  = $("cutFrame");
const cutFix    = $("cutFix");
const cutBottom = $("cutBottom");
const cutBar    = $("cutBar");
const cutArc    = $("cutArc");



// ========================================================
// [BLOCK 3] STATE
// ========================================================

let doors = [];
let vBars = [];
let hBars = [];

let selectedStructure = null;
let selectedDoorIndex = 0;
let selectedZone = null;

let scale = 1;
let dragTarget = null;



// ========================================================
// [BLOCK 4] TOP STRUCTURE UI
// ========================================================

(function initTopUI(){

    if (!document.querySelectorAll) return;

    const typeItems = document.querySelectorAll("#doorTypeList .topItem");
    typeItems.forEach(function(el){
        el.onclick = function(){
            typeItems.forEach(function(x){ x.classList.remove("active"); });
            el.classList.add("active");

            const type = el.getAttribute("data-type");
            debugLog("[TopUI] 중문 종류 선택:", type);
            call(renderDetail, type);
        };
    });

    function renderDetail(type){
        const box = $("doorDetailList");
        if (!box) return;

        box.innerHTML = "";
        const list = doorStructure[type] || [];

        if (!list.length){
            const div = document.createElement("div");
            div.style.color = "#888";
            div.innerText = "구조 정의 없음";
            box.appendChild(div);
            return;
        }

        list.forEach(function(data){
            const div = document.createElement("div");
            div.className = "topItem";
            div.innerText = (data.code||"") + " " + (data.name||"");
            div.onclick = function(){
                call(selectDetail, div, data, type);
            };
            box.appendChild(div);
        });
    }

    function selectDetail(el, data, type){
        document
          .querySelectorAll("#doorDetailList .topItem")
          .forEach(function(x){ x.classList.remove("active"); });

        el.classList.add("active");

        selectedStructure = {
            code:  data.code  || "",
            name:  data.name  || "",
            doors: data.doors || 1,
            fix:   data.fix   || "none",
            type:  type       || "hinge"
        };

        debugLog("[TopUI] 세부 구조 선택:", selectedStructure);

        if (doorCount) doorCount.value = selectedStructure.doors;

        call(updateStructureInfo);
        call(layout);
    }

    function updateStructureInfo(){
        if (!structureInfo) return;

        if (!selectedStructure){
            structureInfo.innerText = "구조 선택 안됨";
            return;
        }

        const t = selectedStructure;
        let fixTxt = "픽스 없음";
        if (t.fix === "left")  fixTxt = "좌측 픽스";
        if (t.fix === "right") fixTxt = "우측 픽스";
        if (t.fix === "both")  fixTxt = "양측 픽스";

        structureInfo.innerText =
            "[" + t.type + "] " + (t.code||"") + " " + (t.name||"") +
            " / 도어 " + (t.doors||1) +
            " / " + fixTxt;
    }

    window.updateStructureInfo = updateStructureInfo;

})();



 // ========================================================
 // [BLOCK 5] LAYOUT ENGINE
 // ========================================================

function layout(){

    if (!hasCanvas()) {
        debugLog("[Layout] 캔버스 없음");
        return;
    }

    if (!selectedStructure){
        selectedStructure = {
            code:"1-1", name:"편개", doors:1, fix:"none", type:"hinge"
        };
    }

    const w  = doorW ? (+doorW.value || 900)   : 900;
    const h  = doorH ? (+doorH.value || 2200)  : 2200;
    const bh = bottomH ? (+bottomH.value || 0) : 0;

    debugLog("[Layout] 기본 입력값 w/h/bh:", w, h, bh);

    let frames = [];

    if (selectedStructure.fix === "left" || selectedStructure.fix === "both"){
        frames.push({type:"fix"});
    }

    const doorCnt = selectedStructure.doors || 1;
    for (let i=0;i<doorCnt;i++){
        frames.push({type:"door"});
    }

    if (selectedStructure.fix === "right" || selectedStructure.fix === "both"){
        frames.push({type:"fix"});
    }

    frames.forEach(function(f){
        if (f.type === "door") f.mmW = w;
        else                   f.mmW = Math.round(w * 0.4);
    });

    const totalMm = frames.reduce(function(sum,f){ return sum + (f.mmW||0); }, 0);

    const sx = (canvas.width  / totalMm) * 0.9;
    const sy = (canvas.height / h)       * 0.85;
    scale = Math.min(sx, sy);

    debugLog("[Layout] totalMm:", totalMm, "scaleX:", sx, "scaleY:", sy, "→ scale:", scale);

    doors = [];
    vBars = [];
    hBars = [];
    selectedDoorIndex = 0;
    selectedZone = null;

    const doorPxH = h * scale;
    let x = (canvas.width  - totalMm * scale) / 2;
    let y = (canvas.height - doorPxH)        / 2;

    frames.forEach(function(f, i){
        const wp = (f.mmW || 0) * scale;

        doors.push({
            index:    i,
            type:     f.type,
            mmW:      f.mmW,
            mmH:      h,
            x:        x,
            y:        y,
            w:        wp,
            h:        doorPxH,
            framePx:  FRAME * scale,
            bottomMm: bh,
            bottomPx: bh * scale,
            topArc:   0,
            botArc:   0,
            leftArc:  0,
            rightArc: 0
        });

        x += wp;
    });

    debugLog("[Layout] doors 배열 생성:", doors);

    call(updateFrameUI);
    call(draw);
}



// ========================================================
// [BLOCK 6] DRAW CORE (DOOR + ARC)
// ========================================================

function draw(){
    if (!hasCanvas() || !hasDoors()) {
        return;
    }

    ctx.clearRect(0,0,canvas.width,canvas.height);

    doors.forEach(function(d){ call(drawDoor,d); });
    vBars.forEach(function(v){ call(drawVBar,v); });
    hBars.forEach(function(h){ call(drawHBar,h); });
    call(drawSelectedZone);
    call(drawCut);
}

function drawDoor(d){
    if (!hasCanvas()) return;

    const fp = d.framePx;

    // 프레임
    ctx.fillStyle="#222";
    ctx.fillRect(d.x, d.y, d.w, fp);
    ctx.fillRect(d.x, d.y+d.h-fp, d.w, fp);
    ctx.fillRect(d.x, d.y, fp, d.h);
    ctx.fillRect(d.x+d.w-fp, d.y, fp, d.h);

    // 유리영역
    const glassHpx = d.h - fp*2 - d.bottomPx;

    ctx.fillStyle = (d.type==="fix")
        ? "rgba(100,150,200,0.15)"
        : "rgba(255,200,0,0.15)";

    ctx.fillRect(d.x+fp, d.y+fp, d.w-fp*2, glassHpx);

    // 하부고시
    if (d.bottomPx>0){
        ctx.fillStyle="rgba(255,0,150,0.45)";
        ctx.fillRect(
            d.x+fp,
            d.y+d.h-fp-d.bottomPx,
            d.w-fp*2,
            d.bottomPx
        );
    }

    call(drawArc,d);

    if (d.index===selectedDoorIndex){
        ctx.strokeStyle="red";
        ctx.lineWidth=2;
        ctx.strokeRect(d.x,d.y,d.w,d.h);
    }
}

// ✅ 아치: 유리 내부 기준으로만 그리기 (FIXED VERSION)
function drawArc(d){
    if (!ctx) return;

    // 유리 내부 좌표
    const gl = d.x + d.framePx;
    const gr = d.x + d.w - d.framePx;
    const gt = d.y + d.framePx;
    const gb = d.y + d.h - d.framePx - d.bottomPx;

    const cx = (gl + gr) / 2;
    const cy = (gt + gb) / 2;

    const halfW = (gr - gl) / 2;
    const halfH = (gb - gt) / 2;

    ctx.strokeStyle = "#aaa";
    ctx.lineWidth   = 1;

    const TAU = Math.PI * 2;

// ✅ 상부 아치 (유리 안으로 들어오게)
if (d.topArc > 0){
    const r = d.topArc * scale;
    ctx.beginPath();
    ctx.ellipse(
        cx,
        gt + r,          // 🔥 중심을 아래로 이동
        halfW,
        r,
        0,
        Math.PI,
        2*Math.PI,
        false
    );
    ctx.stroke();
}

// ✅ 하부 아치 (유리 안으로 들어오게)
if (d.botArc > 0){
    const r = d.botArc * scale;
    ctx.beginPath();
    ctx.ellipse(
        cx,
        gb - r,          // 🔥 중심을 위로 이동
        halfW,
        r,
        0,
        0,
        Math.PI,
        false
    );
    ctx.stroke();
}

    // ======================
    // ✅ 좌 (왼쪽에서 안쪽 = 오른쪽으로 볼록)
    // ======================
    if (d.leftArc > 0){
        ctx.beginPath();
        ctx.ellipse(
            gl, cy,
            d.leftArc * scale, halfH,
            0,
            Math.PI * 1.5, Math.PI * 0.5, false  // ← 내부방향
        );
        ctx.stroke();
    }

    // ======================
    // ✅ 우 (오른쪽에서 안쪽 = 왼쪽으로 볼록)
    // ======================
    if (d.rightArc > 0){
        ctx.beginPath();
        ctx.ellipse(
            gr, cy,
            d.rightArc * scale, halfH,
            0,
            Math.PI * 0.5, Math.PI * 1.5, false
        );
        ctx.stroke();
    }
}

// ========================================================
// [BLOCK 7] VERTICAL BAR
// ========================================================

if (btnAddVG){
    btnAddVG.onclick = function(){
        if (selectedZone){
            vBars.push({
                door:selectedZone.door,
                from:selectedZone.from,
                to:selectedZone.to,
                ratio:0.5
            });
        }else{
            vBars.push({
                door:selectedDoorIndex,
                from:0,
                to:1,
                ratio:0.5
            });
        }
        debugLog("[VBar] 1개 추가:", vBars);
        call(draw);
    };
}

if (btnAddVGN){
    btnAddVGN.onclick = function(){
        const n = +prompt("세로 몇 등분?");
        if (!n || n<2) return;

        const zone = selectedZone || {door:selectedDoorIndex, from:0, to:1};

        vBars = vBars.filter(function(v){
            return !(v.door===zone.door && v.from===zone.from && v.to===zone.to);
        });

        for (let i=1;i<n;i++){
            vBars.push({
                door: zone.door,
                from: zone.from,
                to:   zone.to,
                ratio: i/n
            });
        }
        debugLog("[VBar] N등분 생성:", vBars);
        call(draw);
    };
}

if (btnResetVG){
    btnResetVG.onclick = function(){
        if (selectedZone){
            const z = selectedZone;
            vBars = vBars.filter(function(v){
                return !(v.door===z.door && v.from===z.from && v.to===z.to);
            });
        }else{
            vBars = vBars.filter(function(v){
                return v.door !== selectedDoorIndex;
            });
        }
        selectedZone = null;
        debugLog("[VBar] 리셋 후:", vBars);
        call(draw);
    };
}

function drawVBar(v){
    const d = doors[v.door];
    if (!d) return;

    const fp = d.framePx;
    const gh = (d.mmH - FRAME*2 - d.bottomMm)*scale;
    const gw = d.w - fp*2;

    const zoneW = gw * (v.to - v.from);
    const x = d.x + fp + gw*v.from + zoneW*v.ratio;
    const y = d.y + fp;

    ctx.fillStyle="#444";
    ctx.fillRect(x-2, y, 4, gh);
}



// ========================================================
// [BLOCK 8] HORIZONTAL BAR
// ========================================================

if (btnAddHG){
    btnAddHG.onclick = function(){
        const zone = selectedZone || {door:selectedDoorIndex, from:0, to:1};

        hBars.push({
            door: zone.door,
            from: zone.from,
            to:   zone.to,
            ratio:0.5
        });

        debugLog("[HBar] 1개 추가:", hBars);
        call(draw);
    };
}

if (btnAddHGN){
    btnAddHGN.onclick = function(){
        const zone = selectedZone || {door:selectedDoorIndex, from:0, to:1};

        const n = +prompt("가로 몇 등분?");
        if (!n || n<2) return;

        for (let i=1;i<n;i++){
            hBars.push({
                door: zone.door,
                from: zone.from,
                to:   zone.to,
                ratio: i/n
            });
        }
        debugLog("[HBar] N등분 추가:", hBars);
        call(draw);
    };
}

if (btnResetHGZone){
    btnResetHGZone.onclick = function(){
        if (!selectedZone){
            alert("선택된 세로 영역이 없습니다.");
            return;
        }
        hBars = hBars.filter(function(h){
            return !(h.door===selectedZone.door &&
                     h.from===selectedZone.from &&
                     h.to===selectedZone.to);
        });
        debugLog("[HBar] 선택 존 삭제 후:", hBars);
        call(draw);
    };
}

if (btnResetHGFrame){
    btnResetHGFrame.onclick = function(){
        hBars = hBars.filter(function(h){
            return h.door !== selectedDoorIndex;
        });
        selectedZone = null;
        debugLog("[HBar] 도어 전체 삭제 후:", hBars);
        call(draw);
    };
}

function drawHBar(h){
    const d = doors[h.door];
    if (!d) return;

    const fp = d.framePx;
    const gw = d.w - fp*2;
    const gh = (d.mmH - FRAME*2 - d.bottomMm)*scale;

    const lx = d.x + fp + gw*h.from;
    const rx = d.x + fp + gw*h.to;
    const y  = d.y + fp + gh*h.ratio;

    ctx.fillStyle="#0a0";
    ctx.fillRect(lx, y-2, rx-lx, 4);
}



// ========================================================
// [BLOCK 9] ZONE SYSTEM (세로 1D 존)
// ========================================================

function getZones(idx){
    const d = doors[idx];
    if (!d) return [];

    const ratios = vBars
        .filter(function(v){ return v.door===idx; })
        .map(function(v){ return v.ratio; })
        .sort(function(a,b){ return a-b; });

    const zones = [];
    let last = 0;

    ratios.forEach(function(r){
        zones.push({door:idx, from:last, to:r});
        last = r;
    });
    zones.push({door:idx, from:last, to:1});

    return zones;
}

// ✅ 선택 영역 표시 (유리 범위로 clip)
function drawSelectedZone(){
    if (!selectedZone) return;

    const d = doors[selectedZone.door];
    if (!d) return;

    const gl = d.x + d.framePx;
    const gr = d.x + d.w - d.framePx;
    const gt = d.y + d.framePx;
    const gb = d.y + d.h - d.framePx - d.bottomPx;

    const gw = gr - gl;
    const gh = gb - gt;

    const lx = gl + gw * selectedZone.from;
    const rx = gl + gw * selectedZone.to;

    ctx.save();
    ctx.beginPath();
    ctx.rect(gl, gt, gw, gh); // 유리로 제한
    ctx.clip();

    ctx.fillStyle="rgba(0,150,255,0.15)";
    ctx.fillRect(lx, gt, rx-lx, gh);

    ctx.restore();
}



// ========================================================
// [BLOCK 10] CANVAS EVENT
// ========================================================

if (canvas){

    canvas.onmousedown = function(e){
        const mx = e.offsetX;
        const my = e.offsetY;

        dragTarget = null;

        // 세로바 hit test
        for (let i=0;i<vBars.length;i++){
            const v = vBars[i];
            const d = doors[v.door];
            if (!d) continue;

            const fp = d.framePx;
            const gw = d.w - fp*2;
            const gh = (d.mmH - FRAME*2 - d.bottomMm)*scale;

            const zoneW = gw * (v.to - v.from);
            const x = d.x + fp + gw*v.from + zoneW*v.ratio;
            const y1 = d.y + fp;
            const y2 = y1 + gh;

            if (mx>x-6 && mx<x+6 && my>y1 && my<y2){
                dragTarget = {type:"v", bar:v};
                debugLog("[Drag] 세로 간살 선택:", v);
                return;
            }
        }

        // 가로바 hit test
        for (let i=0;i<hBars.length;i++){
            const h = hBars[i];
            const d = doors[h.door];
            if (!d) continue;

            const fp = d.framePx;
            const gw = d.w - fp*2;
            const gh = (d.mmH - FRAME*2 - d.bottomMm)*scale;

            const lx = d.x + fp + gw*h.from;
            const rx = d.x + fp + gw*h.to;
            const y  = d.y + fp + gh*h.ratio;

            if (mx>lx && mx<rx && my>y-6 && my<y+6){
                dragTarget = {type:"h", bar:h};
                debugLog("[Drag] 가로 간살 선택:", h);
                return;
            }
        }
    };

    canvas.onmousemove = function(e){
        if (!dragTarget) return;

        const mx = e.offsetX;
        const my = e.offsetY;
        const SNAP = 50;

        if (dragTarget.type==="v"){
            const v = dragTarget.bar;
            const d = doors[v.door];
            if (!d) return;

            const fp = d.framePx;
            const gw = d.w - fp*2;

            const zonePx = gw * (v.to - v.from);
            const basePx = d.x + fp + gw*v.from;

            let px = mx - basePx;
            let r  = px / zonePx;

            // mm 스냅 필요하면 여기서 r을 보정할 수 있음
            if (r<0.05) r=0.05;
            if (r>0.95) r=0.95;

            v.ratio = r;
            selectedZone = null;
        }

        if (dragTarget.type==="h"){
            const h = dragTarget.bar;
            const d = doors[h.door];
            if (!d) return;

            const fp = d.framePx;
            const gh = (d.mmH - FRAME*2 - d.bottomMm)*scale;

            const baseY = d.y + fp;
            let py = my - baseY;
            let r  = py / gh;

            if (r<0.05) r=0.05;
            if (r>0.95) r=0.95;

            h.ratio = r;
        }

        call(draw);
    };

    canvas.onmouseup = function(){
        dragTarget = null;
    };

    canvas.onclick = function(e){
        const x = e.offsetX;
        const y = e.offsetY;

        let idx = null;

        doors.forEach(function(d){
            if (x>d.x && x<d.x+d.w && y>d.y && y<d.y+d.h){
                idx = d.index;
            }
        });

        if (idx===null) return;

        selectedDoorIndex = idx;
        call(updateFrameUI);

        const d = doors[idx];
        const fp = d.framePx;
        const gw = d.w - fp*2;
        const gh = (d.mmH - FRAME*2 - d.bottomMm)*scale;

        const gl = d.x + fp;
        const gt = d.y + fp;

        if (x<gl || x>gl+gw || y<gt || y>gt+gh){
            selectedZone = null;
            call(draw);
            return;
        }

        const r = (x-gl)/gw;
        const zones = getZones(idx);
        selectedZone = null;
        zones.forEach(function(z){
            if (r>z.from && r<z.to){
                selectedZone = z;
            }
        });

        debugLog("[Click] 도어/존 선택:", selectedDoorIndex, selectedZone);
        call(draw);
    };
}



// ========================================================
// [BLOCK 11] BOTTOM BAR / ARC UI
// ========================================================

if (btnApplyBottom){
    btnApplyBottom.onclick = function(){
        const v = bottomH ? (+bottomH.value || 0) : 0;
        doors.forEach(function(d){
            d.bottomMm = v;
            d.bottomPx = v*scale;
        });
        debugLog("[Bottom] 적용:", v);
        call(draw);
    };
}

if (btnResetBottom){
    btnResetBottom.onclick = function(){
        if (bottomH) bottomH.value = 0;
        doors.forEach(function(d){
            d.bottomMm = 0;
            d.bottomPx = 0;
        });
        debugLog("[Bottom] 제거");
        call(draw);
    };
}

if (btnApplyArc){
    btnApplyArc.onclick = function(){
        const d = doors[selectedDoorIndex];
        if (!d) return;

        d.topArc   = topArcH   ? (+topArcH.value   || 0) : 0;
        d.botArc   = botArcH   ? (+botArcH.value   || 0) : 0;
        d.leftArc  = leftArcD  ? (+leftArcD.value  || 0) : 0;
        d.rightArc = rightArcD ? (+rightArcD.value || 0) : 0;

        debugLog("[Arc] 적용:", d);
        call(draw);
    };
}

if (btnResetArc){
    btnResetArc.onclick = function(){
        const d = doors[selectedDoorIndex];
        if (!d) return;

        d.topArc = d.botArc = d.leftArc = d.rightArc = 0;

        if (topArcH)   topArcH.value   = "";
        if (botArcH)   botArcH.value   = "";
        if (leftArcD)  leftArcD.value  = "";
        if (rightArcD) rightArcD.value = "";

        debugLog("[Arc] 리셋:", d);
        call(draw);
    };
}



// ========================================================
// [BLOCK 12] FRAME UI
// ========================================================

if (btnApplyDoor){
    btnApplyDoor.onclick = function(){
        if (!selectedStructure){
            alert("상단에서 구조를 먼저 선택하세요.");
            return;
        }
        call(layout);
    };
}

if (btnApplyFrame){
    btnApplyFrame.onclick = function(){
        const d = doors[selectedDoorIndex];
        if (!d) return;

        d.mmW = selW ? (+selW.value || d.mmW) : d.mmW;
        d.mmH = selH ? (+selH.value || d.mmH) : d.mmH;

        debugLog("[FrameUI] 선택 프레임 mm 변경:", d);
        call(layout);
    };
}

function updateFrameUI(){
    const d = doors[selectedDoorIndex];
    if (!d) return;
    if (selW) selW.value = d.mmW;
    if (selH) selH.value = d.mmH;
}



// ========================================================
// [BLOCK 13] CUT ENGINE
// ========================================================

function ellipsePerimeter(a,b){
    const h = Math.pow((a-b)/(a+b),2);
    return Math.PI*(a+b)*(1+(3*h)/(10+Math.sqrt(4-3*h)));
}

function drawCut(){
    if (!cutFrame || !cutFix || !cutBottom || !cutBar || !cutArc) return;

    // 1) 프레임 / 픽스
    let frameHtml = "";
    let fixHtml   = "";

    doors.forEach(function(d,i){
        const kind = (d.type==="fix") ? "픽스" : "도어";
        const txt  = kind + (i+1) + " " + d.mmW + " × " + d.mmH + "<br>";
        if (d.type==="fix") fixHtml   += txt;
        else                frameHtml += txt;
    });

    cutFrame.innerHTML = frameHtml || "없음";
    cutFix.innerHTML   = fixHtml   || "없음";

    // 2) 하부고시
    let bottomMap = {};

    doors.forEach(function(d){
        if (d.bottomMm<=0 || d.type!=="door") return;
        const key = (d.mmW-FRAME*2) + "×" + d.bottomMm;
        bottomMap[key] = (bottomMap[key] || 0) + 1;
    });

    let bottomHtml = "";
    for (let k in bottomMap){
        bottomHtml += k + " / " + bottomMap[k] + "<br>";
    }
    cutBottom.innerHTML = bottomHtml || "없음";

    // 3) 간살 (세로/가로 개수 정확히)
    let barMap = {};

    vBars.forEach(function(v){
        const d = doors[v.door];
        if (!d) return;
        const len = Math.round(d.mmH - FRAME*2 - d.bottomMm);
        const key = "세로 " + len;
        barMap[key] = (barMap[key] || 0) + 1;
    });

    hBars.forEach(function(h){
        const d = doors[h.door];
        if (!d) return;
        const len = Math.round((d.mmW - FRAME*2) * (h.to - h.from));
        const key = "가로 " + len;
        barMap[key] = (barMap[key] || 0) + 1;
    });

    let barHtml = "";
    for (let bk in barMap){
        barHtml += bk + " / " + barMap[bk] + "<br>";
    }
    cutBar.innerHTML = barHtml || "없음";

// 4) 아치
let arcHtml = "";
let hasArc  = false;

doors.forEach(function(d,i){
    const iw = d.mmW - FRAME*2;                   // 내부 가로
    const ih = d.mmH - FRAME*2 - d.bottomMm;     // 내부 세로

    let peri, radius, diameter;

    // ========= 상 =========
    if (d.topArc){
        radius   = d.topArc;
        diameter = radius * 2;
        peri = ellipsePerimeter(iw/2, radius)/2;

        arcHtml += "도어" + (i+1) +
                   " 상 " + iw + "×" + radius +
                   " / 반지름:" + radius +
                   " / 지름:" + diameter +
                   " / 파이:" + peri.toFixed(1) + "<br>";
        hasArc = true;
    }

    // ========= 하 =========
    if (d.botArc){
        radius   = d.botArc;
        diameter = radius * 2;
        peri = ellipsePerimeter(iw/2, radius)/2;

        arcHtml += "도어" + (i+1) +
                   " 하 " + iw + "×" + radius +
                   " / 반지름:" + radius +
                   " / 지름:" + diameter +
                   " / 파이:" + peri.toFixed(1) + "<br>";
        hasArc = true;
    }

    // ========= 좌 =========
    if (d.leftArc){
        radius   = d.leftArc;
        diameter = radius * 2;
        peri = ellipsePerimeter(radius, ih/2)/2;

        arcHtml += "도어" + (i+1) +
                   " 좌 " + radius + "×" + ih +
                   " / 반지름:" + radius +
                   " / 지름:" + diameter +
                   " / 파이:" + peri.toFixed(1) + "<br>";
        hasArc = true;
    }

    // ========= 우 =========
    if (d.rightArc){
        radius   = d.rightArc;
        diameter = radius * 2;
        peri = ellipsePerimeter(radius, ih/2)/2;

        arcHtml += "도어" + (i+1) +
                   " 우 " + radius + "×" + ih +
                   " / 반지름:" + radius +
                   " / 지름:" + diameter +
                   " / 파이:" + peri.toFixed(1) + "<br>";
        hasArc = true;
    }
});

cutArc.innerHTML = hasArc ? arcHtml : "없음";


    debugLog("[Cut] 프레임/픽스/하부/간살/아치 계산 완료");
}



// ========================================================
// [BLOCK 14] INIT
// ========================================================

selectedStructure = { code:"1-1", name:"편개", doors:1, fix:"none", type:"hinge" };
if (doorCount) doorCount.value = 1;

call(updateStructureInfo);
call(layout);

window.DoorEngine = {
    getDoors : function(){ return doors; },
    getVbars : function(){ return vBars; },
    getHbars : function(){ return hBars; },
    relayout : function(){ call(layout); },
    redraw   : function(){ call(draw); },
    dump     : function(){
        console.log("doors:",doors);
        console.log("vBars:",vBars);
        console.log("hBars:",hBars);
    }
};

debugLog("[DoorEngine] 초기화 완료");
