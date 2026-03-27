# 태광도어 ERP 레거시 파일 의존성 완전 맵

> 분석일: 2026-03-19
> 대상: `C:\Users\win11\Desktop\git_clone\www\` (ASP 951개, HTML 29개, JS 40개)

---

## 1. Include 의존성 트리

### 1.1 전체 통계
- **총 include 문**: ~1,400개 이상
- **include를 사용하는 파일**: ~400개
- **include 대상 파일(고유)**: ~40개

### 1.2 Include 대상별 참조 횟수 (TOP 20)

| 순위 | Include 대상 파일 | 참조 횟수 | 역할 |
|------|-------------------|-----------|------|
| 1 | `/inc/dbcon.asp` | **386회** (386개 파일) | DB 연결 (핵심 인프라) |
| 2 | `/inc/cookies.asp` | **384회** | 세션/쿠키 관리 |
| 3 | `/inc/md5.asp` | **216회** (216개 파일) | 암호화/해싱 |
| 4 | `/inc/top.asp` | **186회** (186개 파일) | 상단 네비게이션 |
| 5 | `/inc/left_TNG1.asp` | **49회** (49개 파일) | TNG1 좌측 메뉴 |
| 6 | `/inc/left.asp` | **30회** (30개 파일) | 기본 좌측 메뉴 |
| 7 | `/inc/left_TNG2.asp` | **26회** (26개 파일) | TNG2 좌측 메뉴 |
| 8 | `/inc/left_cyj.asp` | **17회** (17개 파일) | CYJ 모듈 좌측 메뉴 |
| 9 | `/inc/paging.asp` | **~8회** | 페이징 처리 |
| 10 | `/inc/left_pummok.asp` | **15회** (15개 파일) | 품목 좌측 메뉴 |
| 11 | `/inc/paging1.asp` | **~7회** | 페이징 처리 v2 |
| 12 | `/inc/left3.asp` | **13회** (13개 파일) | 관리 좌측 메뉴 |
| 13 | `/cyj/cinc.asp` | **~5회** | CYJ 공통 인클루드 |
| 14 | `/cyj/cinc2.asp` | **~4회** | CYJ 공통 인클루드 v2 |
| 15 | `/common_crud/crud_json.asp` | **7회** (7개 파일) | CRUD JSON 유틸 |
| 16 | `/common_crud/crud_api.asp` | **7회** (7개 파일) | CRUD API 엔진 |
| 17 | `/inc/left1.asp` | **8회** (8개 파일) | MES 좌측 메뉴 |
| 18 | `/inc/left_TNG3.asp` | **6회** (6개 파일) | TNG3 좌측 메뉴 |
| 19 | `/inc/left_BOM.asp` | **5회** (5개 파일) | BOM 좌측 메뉴 |
| 20 | `/doorframe/dframe_001.asp` | **3회** (1개 파일: order.asp) | 도어프레임 렌더링 |

### 1.3 Include 트리 구조 (주요 패턴)

```
[일반 페이지 패턴] (대부분의 ASP 파일)
 +-- /inc/dbcon.asp          (DB 연결)
 +-- /inc/cookies.asp        (세션 관리)
 +-- /inc/top.asp            (상단 메뉴)
 +-- /inc/left_XXX.asp       (좌측 메뉴 - 모듈별 다름)
 +-- /inc/paging.asp         (목록 페이지만)

[DB 처리 페이지 패턴] (*db.asp 파일들)
 +-- /inc/dbcon.asp
 +-- /inc/cookies.asp
 +-- /inc/md5.asp            (보안 검증)

[CRUD API 패턴] (paint_color, stain_qtyco 등 신규 모듈)
 +-- /inc/dbcon.asp
 +-- /inc/cookies.asp
 +-- /common_crud/crud_json.asp
 +-- /common_crud/crud_api.asp

[인증 처리 패턴]
 /inc/login_ok2.asp
   +-- /inc/dbcon1.asp       (별도 DB 연결)
   +-- /inc/cookies.asp
   +-- /inc/md5.asp
```

### 1.4 특이 include (비표준 경로)

| 원본 파일 | Include 대상 | 비고 |
|-----------|-------------|------|
| `order.asp` (L745, L888, L1111) | `/doorframe/dframe_001.asp` | 도어프레임 SVG 3회 반복 include |
| `order2.asp` (L7-8) | `/tkdoor/n_inc/dbcon1.asp`, `/tkdoor/n_inc/cookies.asp` | 외부 tkdoor 경로 참조 (존재 미확인) |
| `paint_color/index.asp` (L36, L401) | `/common_crud/css/crud.css`, `/common_crud/js/crud_core.js` | CSS/JS를 include로 삽입 |
| `inc/login_ok2.asp` (L8) | `/inc/dbcon1.asp` | 별도 DB 연결 파일 |

---

## 2. Form Action 맵

### 2.1 전체 통계
- **총 form action 수**: ~200개 이상
- **form을 포함하는 파일**: ~100개 이상

### 2.2 주요 Form Action 맵 (원본 -> 대상)

#### 자기 자신을 대상으로 하는 form (Self-POST)
| 원본 파일 | action | method |
|-----------|--------|--------|
| `barlist_item.asp` (L156) | `barlist_item.asp` | POST |
| `glass_item.asp` (L88) | `glass_item.asp` | POST |
| `goods_item.asp` (L88) | `goods_item.asp` | POST |
| `frmmgnt.asp` (L295, L326) | `frmmgnt.asp?gubun=insert/update` | POST, multipart/form-data |

#### DB 처리 파일을 대상으로 하는 form
| 원본 파일 | action 대상 | method | enctype |
|-----------|------------|--------|---------|
| `barlist_itemin.asp` (L94) | `barlist_itemdb.asp` | POST | multipart/form-data |
| `goods_itemin.asp` (L132) | `goods_itemdb.asp` | POST | - |
| `busok_itemin.asp` (L53) | `busok_itemdb.asp` | POST | multipart/form-data |
| `busok_st_item.asp` (L198) | `pummok_Busok_ST_db.asp` | POST | - |
| `hd_item.asp` (L89) | `tagong_item.asp` | POST | - |
| `mes/sujuin.asp` | `mes/sujuindbA.asp`, `mes/sujuindbb.asp` | POST | multipart/form-data |
| `mes/pummok_Busok_item.asp` | `mes/pummok_Busok_itemDB.asp` | POST | - |
| `mes/pummok_Busok_ST_item.asp` | `mes/pummok_Busok_ST_itemDB.asp` | POST | - |
| `khy/korder.asp` | `khy/korderdb.asp` | POST | - |
| `khy/khorder.asp` | `khy/khorderdb.asp` | POST | - |
| `cyj/corp.asp` | `cyj/corpdb.asp` | POST | - |
| `cyj/corpudt.asp` | `cyj/corpudtdb.asp` | POST | - |
| `cyj/mem.asp` | `cyj/memdb.asp` | POST | - |
| `ooo/advice/advice.asp` | `ooo/advice/advicedb.asp` | POST | multipart/form-data |
| `report/reg.asp` | `report/regdb.asp` | POST | - |
| `report/remain.asp` | `report/remaindb.asp` | POST | - |
| `TNG_bom/bom_mold_popup.asp` | `TNG_bom/bom_mold_popupDb.asp` | POST | multipart/form-data |
| `TNG_bom/bom_master_popup.asp` | `TNG_bom/bom_master_popupDb.asp` | POST | - |
| `TNG_WMS/TEAM/TNG_WMS_Team_PopUp.asp` | `TNG_WMS/TEAM/TNG_WMS_Team_DB.asp` | POST | - |
| `TNG_WMS/STOCK/TNG_WMS_Stock_PopUp.asp` | `TNG_WMS/STOCK/TNG_WMS_stock_DB.asp` | POST | - |

#### 검색 form (같은 페이지 또는 목록 페이지로)
| 원본 파일 | action 대상 | 비고 |
|-----------|------------|------|
| `frmmgnt.asp` (L135) | `order.asp?listgubun=two&subgubun=two1` | 주문 검색 |
| `order.asp` | `order.asp` (자기참조) | 주문 목록 검색 |
| `TNG1/TNG1_sujulist.asp` | 자기참조 | 수주목록 검색 |

### 2.3 일반 패턴

대부분의 form action은 **[모듈명]_itemin.asp -> [모듈명]_itemdb.asp** 패턴을 따름:
- 입력 화면(`*_itemin.asp`, `*_insert.asp`, `*udt.asp`) -> DB 처리(`*_itemdb.asp`, `*db.asp`, `*udtdb.asp`)

---

## 3. 팝업/window.open 체인 맵

### 3.1 전체 통계
- **window.open 호출**: 약 300회 이상
- **팝업을 사용하는 파일**: **133개**

### 3.2 주요 팝업 체인

#### inspector_v5.asp (최다 팝업 호출: 15회)
| 줄번호 | 팝업 URL | 크기 | 용도 |
|--------|----------|------|------|
| L250 | `inspector_cal.asp` | 400x300 | 검수 계산기 |
| L256 | `inspector_length.asp` | 400x300 | 길이 검사 |
| L495 | `lengthc.asp` | 600x1200 | 자동 길이 적용 |
| L1427 | `TNG1_B_suju2_pop_quick.asp` | 800x600 | 수주 퀵팝업 |

#### TNG1/TNG1_B_suju.asp 계열 (수주 관련 팝업 체인)
| 호출자 | 팝업 URL | 크기 |
|--------|----------|------|
| `TNG1_B.asp` / `tng1b.asp` | `TNG1_B_suju.asp` | 다양함 |
| `TNG1_B_suju.asp` | `TNG1_B_suju2.asp` | - |
| `TNG1_B_suju.asp` | `TNG1_B_suju2_pop.asp` | - |
| `TNG1_B_suju.asp` | `TNG1_B_suju2_pop_quick.asp` | 800x600 |
| `TNG1_B_suju2.asp` | `TNG1_B_door_glass_pop.asp` | - |
| `TNG1_B_suju_quick.asp` | `TNG1_B_suju2_pop_quick.asp` | 800x600 |

#### BOM 팝업 체인
| 호출자 | 팝업 URL | 용도 |
|--------|----------|------|
| `TNG_bom/bom_mold_popup.asp` | 이미지 업로드/프리뷰 | 금형 관리 |
| `TNG_bom/bom_aluminum_popup.asp` | 자재 선택 | AL 자재 |
| `TNG_bom/bom_master_popup.asp` | 마스터 선택 | BOM 마스터 |
| `TNG_bom/bom3/material/bom3_material_popup.asp` | 자재 팝업 | BOM3 자재 |

#### 기타 주요 팝업
| 호출자 | 팝업 URL | 용도 |
|--------|----------|------|
| `cyj/cinc.asp` (L172) | `cnumberview.asp` | 사업자번호 확인 (600x700) |
| `TNG1/TNG1_GREEMLIST.asp` | 그림 편집 팝업 | 도면 관리 |
| `TNG1/TNG1_JULGOK_PUMMOK_LIST1.asp` | 품목 이미지 팝업 | 절곡 품목 |
| `TNG_WMS/DASHBOARD/*.asp` | 각종 관리 팝업 | WMS 대시보드 |
| `report/sendmail.asp` | 메일 작성/발송 팝업 | 리포트 |
| `paint_color/index.asp` | `picker.asp` | 색상 선택기 |

---

## 4. 리다이렉트 맵

### 4.1 전체 통계
- **Response.Redirect**: 13회 (11개 파일)
- **location.href =**: 약 600회 이상 (169개 파일)
- **location.replace()**: 약 1,819회 (465개 파일) -- location.replace 포함한 전체 리다이렉트

### 4.2 Response.Redirect (서버 사이드)

| 원본 파일 | 줄번호 | 대상 | 비고 |
|-----------|--------|------|------|
| `index.asp` | L8 | `/ooo/advice/advicem.asp` | **사이트 진입점** -> 상담 메인 |
| `label_stk.asp` | L73 | `label_print.asp?stkidx=...` | 라벨 인쇄 |
| `label_stk.asp` | L80 | `label_stk.asp` | 자기참조 (리셋) |
| `TNG_WMS/TEAM/TNG_WMS_Team_DB.asp` | L158 | `TNG_WMS_Team_List.asp` | DB 저장후 목록 |
| `TNG_WMS/TEAM/TEAM_MEMBER/TNG_WMS_Team_Member_DB.asp` | L138 | `TNG_WMS_Team_Member_List.asp` | DB 저장후 목록 |
| `TNG_WMS/STOCK/TNG_WMS_stock_DB.asp` | L127 | `TNG_WMS_stock_list.asp` | DB 저장후 목록 |
| `TNG_WMS/ROLE/CORE/TNG_WMS_Role_Core_DB.asp` | L142 | `TNG_WMS_Role_Core_List.asp` | DB 저장후 목록 |
| `TNG_WMS/ROLE/DETALE/TNG_WMS_Role_Detail_DB.asp` | L115 | `TNG_WMS_Role_Detail_List.asp` | DB 저장후 목록 |
| `TNG1/TNG1_B.asp` | L169 | `TNG1_B.asp?sjcidx=...` | 자기참조 (상태 변경) |
| `TNG_bom/bom3/title/bom3_title_sub_save.asp` | L80 | `bom3_title_sub_manage.asp` | 저장후 관리 화면 |
| `test/x1y1_delete.asp` | L19 | `x1y1.asp?id=...` | 삭제후 목록 |
| `test/x1y1_complete.asp` | L43 | `x1y1.asp?id=...` | 완료후 목록 |

### 4.3 location.href 주요 패턴

대부분의 location.href는 **삭제 확인 후 이동** 또는 **상태 변경 후 리프레시** 패턴:

| 패턴 | 예시 파일 | 대상 |
|------|-----------|------|
| 삭제 후 | `appmgnt.asp` (L90) | `mgnt.asp?part=delete&uidx=...` |
| 삭제 후 | `busok_st_item.asp` (L133) | `busok_st_itemdb.asp?part=delete&buidx=...` |
| 삭제 후 | `frmmgnt.asp` (L92) | `frmmgnt.asp?gubun=del&tidx=...` |
| 코드 체크 | `customer.asp` (L78) | `/inc/codechecker.asp?cnumber=...` |
| 코드 체크 | `cyj/corp.asp` (L184) | `/inc/codechecker.asp?cnumber=...` |
| 상태 변경 | `inspector_v5.asp` (L262-L281) | 자기참조 (lengthreset/del/framedel) |
| 상태 변경 | `TNG1/TNG1_B_suju*.asp` | 자기참조 (다양한 파라미터) |

---

## 5. AJAX/Fetch 호출 맵

### 5.1 전체 통계
- **fetch()**: ~80회 이상
- **XMLHttpRequest**: 4회
- **$.ajax/$.get/$.post**: 0회 (jQuery AJAX 미사용)

### 5.2 주요 fetch 호출 맵

#### paint_color 모듈
| 호출자 | API 대상 | 용도 |
|--------|----------|------|
| `paint_color/index.asp` (L789) | `upload.asp` | 이미지 업로드 |
| `paint_color/index.asp` (L1184, L1304) | `brand_api.asp?action=list` | 브랜드 목록 |
| `paint_color/index.asp` (L1275) | `brand_api.asp?action=batch` | 브랜드 일괄처리 |
| `paint_color/import_noroo.asp` (L496) | `import_noroo.asp?action=import` | 노루 데이터 임포트 |
| `paint_color/picker.js` (L54) | XHR | 색상 선택기 |

#### paint_sample 모듈
| 호출자 | API 대상 | 용도 |
|--------|----------|------|
| `paint_sample/index.asp` (L180) | `paint_lookup.asp` | 도료 검색 |
| `paint_sample/index.asp` (L409) | `/inc/ajax_sj_info.asp` | 수주 정보 조회 |

#### TNG_bom (BOM 관리)
| 호출자 | API 대상 | 용도 |
|--------|----------|------|
| `TNG_bom/bom3/bom3_main.asp` | `origin/bom3_origin_save.asp` | 원산지 저장 |
| `TNG_bom/bom3/bom3_main.asp` | `master/bom3_master_save.asp` | 마스터 저장 |
| `TNG_bom/bom3/bom3_main.asp` | `title/bom3_title_save.asp` | 타이틀 저장 |
| `TNG_bom/bom3/bom3_main.asp` | `title/bom3_title_sub_value_save.asp` | 서브값 저장 |
| `TNG_bom/bom3/material/bom3_material_popup.asp` | `bom3_material_save.asp` | 자재 저장 |
| `TNG_bom/bom3/material/bom3_material_popup.asp` | `bom3_material_deactivate.asp` | 자재 비활성화 |
| `TNG_bom/bom3/material/bom3_material_popup.asp` | `bom3_material_list.asp` | 자재 목록 |
| `TNG_bom/bom3/title/bom3_title_sub_manage.asp` | `bom3_title_sub_toggle.asp` | 토글 처리 |
| `TNG_bom/bom2/bom2_main.asp` | `master/`, `origin/`, `title/`, `length/`, `mold/`, `surface/` | 각 탭 CRUD |

#### TNG1 (생산관리)
| 호출자 | API 대상 | 용도 |
|--------|----------|------|
| `TNG1/TNG1_B.asp` (L43, L86) | `TNG1_B_DB.asp` | 수주 DB 처리 |
| `TNG1/TNG1_B.asp` (L1500) | `TNG1_B_table.asp` | 테이블 로드 |
| `TNG1/tng1b.asp` (L734) | `TNG1_B_table.asp` | 테이블 로드 |
| `TNG1/TNG1_JULGOK_MASTER_GRID.asp` (L268) | `TNG1_JULGOK_GET_LIST.asp` | 절곡 목록 |
| `TNG1/TNG1_JULGOK_MASTER_GRID.asp` (L537) | `TNG1_JULGOK_UPDATE_SINGLE.asp` | 절곡 단건수정 |
| `TNG1/TNG1_JULGOK_MASTER_GRID.asp` (L555) | `TNG1_JULGOK_DELETE.asp` | 절곡 삭제 |
| `TNG1/julgok_movexy.asp` (L984) | `tng1_julgok_in_sub3.asp` | 절곡 좌표 |
| `TNG1/unittypeA_new.asp`, `unittype_new.asp` | `unittype_api.asp` | 유닛타입 API |

#### TNG_WMS (창고관리)
| 호출자 | API 대상 | 용도 |
|--------|----------|------|
| `TNG_WMS/DASHBOARD/TNG_WMS_DASHBOARD.asp` (L1758) | `TNG_WMS_Sticker_Snapshot_Save.asp` | 스티커 스냅샷 |
| `TNG_WMS/LOCATION/TNG_WMS_Location_Popup.asp` | `AJAX/TNG_WMS_AJAX_Location.asp` | 위치 조회 |
| `TNG_WMS/LOCATION/TNG_WMS_Location_Popup.asp` | `AJAX/TNG_WMS_AJAX_Location_Detail.asp` | 위치 상세 |
| `TNG_WMS/DASHBOARD/PopUp/TNG_WMS_Cargo_Receipt_Popup.asp` | `TNG_WMS_Cargo_Receipt_DB.asp` | 화물 입고 DB |
| `TNG_WMS/DASHBOARD/PopUp/TNG_WMS_Cargo_Receipt_Popup.asp` | `TNG_WMS_Cargo_Receipt_Load.asp` | 화물 데이터 로드 |

#### documents (문서)
| 호출자 | API 대상 | 용도 |
|--------|----------|------|
| `documents/outsideOrder/assets/js/products.js` | `/documents/outsideOrder/db/frames.json`, `doors.json` | 제품 데이터 |
| `documents/outsideOrder/assets/js/options.js` | `/documents/outsideOrder/db/options.json` | 옵션 데이터 |
| `documents/outsideOrder/assets/js/synthesize.js` | 아이템/옵션 URL | 종합 데이터 |

#### common_crud (공통 CRUD)
| 호출자 | API 대상 | 용도 |
|--------|----------|------|
| `common_crud/js/crud_core.js` (L690) | `CFG.apiUrl + "?action=batch"` | 일괄 CRUD |
| `TNG1/common_crud/js/crud_core.js` (L405) | 동일 | TNG1용 복사본 |
| `TNG1/stain_qtyco/crud_core.js` (L405) | 동일 | stain용 복사본 |

---

## 6. iframe 맵

### 6.1 전체 통계
- **iframe src 수**: ~70개 이상
- **iframe을 사용하는 파일**: ~30개

### 6.2 주요 iframe 맵

#### MES 모듈 (메인 iframe 허브)
| 호스트 파일 | iframe src | 용도 |
|------------|-----------|------|
| `mes/mes2.asp` (L88) | `/appmgnt.asp` | 장비 관리 |
| `mes/mes2.asp` (L94) | `/busok.asp` | 부속 |
| `mes/mes2.asp` (L183) | `/barlist.asp` | 바리스트 |
| `mes/mes3.asp` (L110) | `goods.asp` | 제품 |
| `mes/mes3.asp` (L116) | `busok.asp` | 부속 |
| `mes/mes3.asp` (L296) | `barlist.asp` | 바리스트 |
| `mes/pummok_door.asp` (L142) | `goods.asp` | 제품 |
| `mes/pummok_door.asp` (L148-L160) | `busok_chulmolbar.asp`, `busok_bujajae.asp`, `busok_bogang.asp`, `busok_AL.asp`, `busok_ST.asp` | 부속 상세 |
| `mes/pummok_door.asp` (L345) | `barlist.asp` | 바리스트 |
| `mes/pummok_barlist.asp` (L169, L173) | `/barlist_item.asp`, `/barlist_itemin.asp` | 바리스트 품목 |
| `mes/pummok_Busok.asp` (L168, L172) | `/busok_item.asp`, `/busok_itemin.asp` | 부속 품목 |
| `mes/pummok_Busok_ST.asp` (L164) | `/mes/pummok_Busok_ST_item.asp` | 부속(ST) 품목 |
| `mes/pummok_goods.asp` (L169, L173) | `/goods_item.asp`, `/goods_itemin.asp` | 제품 품목 |
| `mes/pummok_glass.asp` (L88, L94) | `/glass_item.asp`, `/glass_itemin.asp` | 유리 품목 |
| `mes/pummok_hd.asp` (L89, L95) | `/hd_item.asp`, `/hd_itemin.asp` | HD 품목 |
| `mes/pummok_hinge.asp` (L88, L94) | `/hinge_item.asp`, `/hinge_itemin.asp` | 경첩 품목 |
| `mes/pummok_tagong.asp` (L89, L95) | `/tagong_item.asp`, `/tagong_itemin.asp` | 타공 품목 |
| `mes/pummok_paint.asp` (L89, L95) | `/paint_item.asp`, `/paint_itemin.asp` | 도장 품목 |
| `mes/pummok_key.asp` (L88, L94) | `/key_item.asp`, `/key_itemin.asp` | 열쇠 품목 |
| `mes/pummok_kyukja.asp` (L88, L94) | `/kyukja_item.asp`, `/kyukja_itemin.asp` | 규격자 품목 |
| `mes/sujuin.asp` (L1611) | `sujuinb_material.asp` | 수주 자재 |
| `mes/sujuink.asp` (L1515) | `sujumaterial.asp` | 수주 자재 |
| `mes/goodch_s.asp` (L52-L66) | `goodch1~6.asp` | 품질검사 1~6 |

#### TNG1 모듈
| 호스트 파일 | iframe src | 용도 |
|------------|-----------|------|
| `TNG1/TNG1_JULGOK_IN.asp` (L257) | `TNG1_JULGOK_IN_SUB.asp` | 절곡 입력 서브 |
| `TNG1/TNG1_JULGOK_PUMMOK_LIST1.asp` (L1161) | `iframeimg.asp` | 이미지 프리뷰 |
| `TNG1/TNG1_N_12t_AD.asp` (L659) | `TNG1_GREEMLIST_edit.asp` | 그림 편집 |
| `TNG1/TNG1_N_12t_AD.asp` (L672) | `TNG1_FRAME_A_BAJU.asp` | 프레임 바주 |
| `TNG1/TNG1_GREEMLIST3.asp` (L1246) | `tng1_greemlist3_frame.asp` | 그림 프레임 |
| `TNG2/TNG2_nesting.asp` (L299) | `/tng2/TNG2_nesting_list.asp` | 네스팅 목록 |

#### LYH 모듈
| 호스트 파일 | iframe src | 용도 |
|------------|-----------|------|
| `LYH/mes3.asp` (L99) | `goods.asp` | 제품 |
| `LYH/mes3.asp` (L105) | `busok.asp` | 부속 |
| `LYH/mes3.asp` (L244) | `barlist.asp` | 바리스트 |

#### 기타
| 호스트 파일 | iframe src | 용도 |
|------------|-----------|------|
| `member.asp` (L466) | `reservation.asp` | 예약 |
| `frmmgnt.asp` (L564) | `./img/frame/*.svg` | 프레임 SVG 프리뷰 |
| `inc/logout.asp` (L30) | `https://www.google.com/accounts/Logout` | 구글 로그아웃 |
| `test/x1y1.asp` (L147) | `x1y1_draw.asp` | 도면 그리기 |

---

## 7. 허브 파일 식별 (TOP 20)

모든 연결 유형(include, form action, popup, redirect, AJAX, iframe)을 종합하여 **가장 많이 참조되는 파일**.

| 순위 | 파일 경로 | 총 참조 | 유형별 내역 |
|------|-----------|---------|-------------|
| **1** | **`/inc/dbcon.asp`** | **~386** | include 386 |
| **2** | **`/inc/cookies.asp`** | **~385** | include 384 + login_ok2의 1 |
| **3** | **`/inc/md5.asp`** | **~216** | include 216 |
| **4** | **`/inc/top.asp`** | **~186** | include 186 |
| **5** | **`/inc/left_TNG1.asp`** | **~49** | include 49 |
| **6** | **`/inc/left.asp`** | **~30** | include 30 |
| **7** | **`/inc/left_TNG2.asp`** | **~26** | include 26 |
| **8** | **`/inc/left_cyj.asp`** | **~17** | include 17 |
| **9** | **`/inc/left_pummok.asp`** | **~15** | include 15 |
| **10** | **`/inc/left3.asp`** | **~13** | include 13 |
| **11** | **`/inc/paging1.asp`** | **~10** | include ~10 |
| **12** | **`/cyj/cinc.asp`** / **`/cyj/cinc2.asp`** | **~9** | include ~5 + ~4 |
| **13** | **`/inc/left1.asp`** | **~8** | include 8 |
| **14** | **`/inc/paging.asp`** | **~8** | include ~8 |
| **15** | **`/common_crud/crud_api.asp`** | **~7** | include 7 |
| **16** | **`/common_crud/crud_json.asp`** | **~7** | include 7 |
| **17** | **`/inc/left_TNG3.asp`** | **~6** | include 6 |
| **18** | **`/inc/left_BOM.asp`** | **~5** | include 5 |
| **19** | **`/mes/goods.asp`** | **~8** | iframe 8 (mes3, pummok_door 등) |
| **20** | **`/mes/busok.asp`** / **`/mes/barlist.asp`** | **~7** | iframe ~7 |

### 허브 파일 유형 분류

**인프라 허브** (모든 ASP가 의존):
- `/inc/dbcon.asp` -- DB 연결. 이 파일 장애 시 전체 시스템 다운
- `/inc/cookies.asp` -- 세션 관리. 인증 전체 의존
- `/inc/md5.asp` -- 해싱. DB 처리 페이지 전부 의존

**UI 프레임 허브** (화면 레이아웃 결정):
- `/inc/top.asp` -- 상단 네비. 186개 페이지의 메뉴 구조 결정
- `/inc/left_TNG1.asp` -- TNG1 좌측 메뉴 (49개 페이지)
- `/inc/left.asp` -- 기본 좌측 메뉴 (30개 페이지)

**데이터 허브** (iframe으로 재사용되는 화면):
- `/mes/goods.asp` -- 제품 관리 iframe
- `/mes/busok.asp`, `/mes/barlist.asp` -- 부속/바리스트 iframe

---

## 8. 고아 파일 식별

어디서도 참조되지 않는 파일 (include, form action, popup, redirect, iframe, fetch 어디에도 대상으로 등장하지 않는 파일).

### 8.1 고아 판별 기준
- 다른 파일의 include 대상이 아님
- 다른 파일의 form action 대상이 아님
- 다른 파일의 window.open 대상이 아님
- 다른 파일의 location.href/Response.Redirect 대상이 아님
- 다른 파일의 iframe src 대상이 아님
- 다른 파일의 fetch/XHR 대상이 아님

### 8.2 고아 파일 목록 (확인된 것)

#### 완전한 고아 (진입점 외에는 참조 없음)
| 파일 경로 | 추정 상태 |
|-----------|----------|
| `hello.asp` | 테스트 파일 |
| `test.asp` | 테스트 파일 |
| `jedo.asp` | 사용 불명 |
| `mkakao.asp` | 카카오 관련 (미사용 추정) |
| `sample.asp` | 샘플 |
| `Qty_item.asp` | 수량 품목 (독립) |
| `Qty_itemdb.asp` | 수량 품목 DB (Qty_item에서만 호출 가능) |
| `doorframe/dframetest.asp` | 테스트 |
| `doorframe/dframetest2.asp` | 테스트 |
| `Door/Engine/door_editor.asp` | 도어 에디터 (독립 진입점) |

#### test/ 폴더 전체 (41개 파일) - 대부분 고아
| 파일 | 비고 |
|------|------|
| `test/test1.asp` ~ `test/test10.asp` | 테스트 파일 |
| `test/test0123.asp`, `test/test0124.asp` | 테스트 |
| `test/test0302_loop.asp`, `test/test0302_loop1.asp` | 루프 테스트 |
| `test/rotation.asp` | 회전 테스트 |
| `test/nboard.asp`, `test/nboarddb.asp` | 게시판 테스트 |
| `test/jean.asp`, `test/jeandb.asp`, `test/jeannamePopup.asp` | Jean 테스트 |
| `test/qboard_mgnt.asp` | 게시판 관리 테스트 |
| `test/r_x1y1.asp` 계열 | 도면 테스트 |
| `test/x1y1.asp` 계열 | 도면 테스트 |
| `test/test_TK_MATRIAL.asp` | 자재 테스트 |
| `test/test_svg1.asp` | SVG 테스트 |
| `test/tng1_b_suju_copy.asp` | TNG1 복사본 테스트 |

#### sample/ 폴더 (30개+ 파일) - 대부분 고아
| 파일 | 비고 |
|------|------|
| `sample/barasik0228.asp` ~ `sample/barasik0304.asp` | 날짜별 바라시크 샘플 |
| `sample/brsk.asp`, `sample/brsk0305.asp`, `sample/brskn.asp` | BRSK 샘플 |
| `sample/frame2.asp` ~ `sample/frame5.asp` | 프레임 샘플 |
| `sample/test0123.asp` ~ `sample/test04091.asp` | 테스트 샘플 |
| `sample/popwin.asp` | 팝업 윈도우 샘플 |
| `sample/geturl.asp` | URL 샘플 |
| `sample/imsi.asp` | 임시 |
| `sample/domyun.asp` | 도면 샘플 |

#### 백업/복사 파일 (중복)
| 파일 | 원본 |
|------|------|
| `mes/mes3_backup.asp` | `mes/mes3.asp`의 백업 |
| `mes/pummok_door_backup.asp` | `mes/pummok_door.asp`의 백업 |
| `cyj/corpsetting_backup.asp` | `cyj/corpsetting.asp`의 백업 |
| `TNG1/TNG1_B_suju_quick copy.asp` | `TNG1_B_suju_quick.asp` 복사 |
| `TNG1/TNG1_B_suju2 copy.asp` | `TNG1_B_suju2.asp` 복사 |
| `TNG1/TNG1_B_suju4 copy.asp` | `TNG1_B_suju4.asp` 복사 |
| `TNG1/TNG1_B_suju5 copy.asp` | `TNG1_B_suju5.asp` 복사 |
| `TNG1/tng1_julgok_in_sub2_copy.asp` | 절곡 서브 복사 |
| `TNG1/tng1_julgok_in_sub2_copy_wj.asp` | 절곡 서브 복사 (WJ) |
| `TNG1/tng1_julgok_in_sub3_copy.asp` | 절곡 서브 복사 |
| `TNG1/TNG1_JULGOK_PUMMOK_LIST1_copy.asp` | 품목목록 복사 |
| `TNG1/greemlist3_backup.asp` | 그림목록 백업 |

#### 사용 불명 독립 파일
| 파일 | 비고 |
|------|------|
| `sso/index.asp` | SSO 진입점 (독립) |
| `collapsehome/h_idpw.asp` | ID/PW 관리 (독립) |
| `datacenter/rtk_customer.asp` | 고객 데이터센터 |
| `datacenter/rtk_member.asp` | 회원 데이터센터 |
| `doc/doc1.asp`, `doc/doc2.asp` | 문서 |
| `erp/erp1.asp`, `erp/erp2.asp` | ERP 진입점 |
| `TNG1/architecture_map.asp` | 아키텍처 맵 (개발도구) |
| `TNG1/dev_architecture.asp` | 개발 아키텍처 (개발도구) |
| `TNG1/temp1.asp` | 임시 |
| `TNG1/test.asp` | 테스트 |
| `etc/test.asp`, `etc/update.asp` | 테스트/업데이트 |
| `wizard/qucik-order/index.html` | 퀵오더 위자드 (독립) |
| `wizard/desk.html` | 데스크 위자드 (독립) |
| `wizard/insurence/index.html` | 보험 위자드 (독립) |

### 8.3 고아 파일 통계 요약
- **test/ 폴더**: ~41개 (전부 고아 또는 내부 참조만)
- **sample/ 폴더**: ~30개 (대부분 고아)
- **백업/copy 파일**: ~12개
- **독립 진입점**: ~15개 (직접 URL 접근만 가능)
- **사용 불명**: ~10개
- **총 추정 고아 파일**: **~108개** (전체 951개 ASP 중 약 11%)

---

## 9. 시스템 구조 요약

### 연결 밀도 순위 (모듈별)

| 모듈 | 파일 수 | 내부 연결 | 외부 연결 | 밀도 |
|------|---------|-----------|-----------|------|
| `/inc/` | 30개 | 0 | ~1,200+ (포함됨) | 최고 (인프라) |
| `TNG1/` | ~180개 | 매우 높음 | 높음 | 높음 |
| `mes/` | ~50개 | 높음 (iframe 집약) | 중간 | 높음 |
| `TNG_WMS/` | ~70개 | 높음 | 낮음 | 중간 |
| `TNG_bom/` | ~60개 | 높음 (fetch 집약) | 낮음 | 중간 |
| `report/` | ~50개 | 중간 | 낮음 | 중간 |
| `cyj/` | ~30개 | 중간 | 중간 | 중간 |
| `khy/` | ~30개 | 중간 | 낮음 | 낮음 |
| `ooo/` | ~15개 | 중간 | 낮음 | 낮음 |
| `test/`, `sample/` | ~70개 | 낮음 | 없음 | 최저 |

### 핵심 의존 경로 (Critical Path)

```
[모든 페이지]
  |
  +-- /inc/dbcon.asp (386개 파일 의존) -- 단일 장애점
  +-- /inc/cookies.asp (384개 파일 의존) -- 단일 장애점
  |
  +-- /inc/top.asp (186개 페이지) -- UI 변경 영향 범위
  +-- /inc/left_TNG1.asp (49개 페이지) -- TNG1 메뉴 변경 영향
  |
  +-- /inc/md5.asp (216개 파일) -- 인증 로직 변경 시 전체 영향
```

### 연결 유형별 총량

| 유형 | 건수 | 관련 파일 수 |
|------|------|-------------|
| `#include` | ~1,400건 | ~400개 파일 |
| `location.replace/href` | ~1,819건 | 465개 파일 |
| `window.open` | ~300건 | 133개 파일 |
| `<form action>` | ~200건 | ~100개 파일 |
| `fetch/XHR` | ~90건 | ~40개 파일 |
| `<iframe src>` | ~70건 | ~30개 파일 |
| `Response.Redirect` | 13건 | 11개 파일 |
| **합계** | **~3,900건** | - |
