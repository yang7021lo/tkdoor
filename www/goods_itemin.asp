<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<% projectname="품명이름 등록" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title><%=projectname%></title>
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <style>
      a:link {
        color: #070707;
        text-decoration: none;
      }
      a:visited {
        color: #070707;
        text-decoration: none;
      }
      a:hover {
        color: #070707;
        text-decoration: none;
      }
    </style>
<script>
    function validateForm(){
            document.frmMain.submit();
        }
</script>
<script>
        function validateForm(){
            document.frmMain.submit();
        }

        function updateGonameAndPrice() {
            const gonameInput = document.getElementById('goname'); // 전체품명 필드
            const goprice3Input = document.getElementById('goprice3'); // 합계 단가 필드
            const gopriceSelect = document.getElementById('goprice'); // 가격 select 필드
            const goprice1Input = parseFloat(document.getElementById('goprice1').value) || 0; // 중간키 단가
            const goprice2Input = parseFloat(document.getElementById('goprice2').value) || 0; // 다대무홈 단가

            let selectedGoname = 'TK_'; // 항상 "TK_"로 시작
            let totalPrice = 0; // 합계 단가 초기화

            // 1) goname11을 TK_ 바로 뒤에 붙이기
        const goname11 = document.getElementById('goname11');
        if (goname11 && goname11.value !== "0") {
            selectedGoname += `${goname11.options[goname11.selectedIndex].text} `;
            // goname11 가격을 포함시키려면 여기에 추가로 처리하세요.
        }

        // 2) goname1 ~ goname10 처리
        for (let i = 1; i <= 10; i++) {
            const gonameElement = document.getElementById(`goname${i}`);
            if (gonameElement && gonameElement.value !== "0") {
                selectedGoname += `${gonameElement.options[gonameElement.selectedIndex].text} `;
                totalPrice += parseFloat(gonameElement.value) || 0;
            }
        }

        // 3) goname12와 goname13 처리 (추가 단가 포함)
        const goname12 = document.getElementById('goname12');
        if (goname12 && goname12.value !== "0") {
            selectedGoname += `${goname12.options[goname12.selectedIndex].text} `;
            totalPrice += goprice2Input; // 다대무홈 단가
        }

        const goname13 = document.getElementById('goname13');
        if (goname13 && goname13.value !== "0") {
            selectedGoname += `${goname13.options[goname13.selectedIndex].text} `;
            totalPrice += goprice1Input; // 중간키 단가
        }

        // 전체품명과 합계 단가 업데이트
        gonameInput.value = selectedGoname.trim();
        goprice3Input.value = totalPrice.toFixed(2);

        // goprice select 값 동기화
        let matched = false;
        for (let option of gopriceSelect.options) {
            if (parseFloat(option.value) === totalPrice) {
                option.selected = true;
                matched = true;
                break;
            }
        }
        if (!matched) {
            gopriceSelect.value = 0; // 해당 단가가 없으면 기본값(0)으로
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        function attachEventListeners() {
            // goname1 ~ goname13 이벤트 바인딩
            for (let i = 1; i <= 13; i++) {
                const gonameElement = document.getElementById(`goname${i}`);
                if (gonameElement) {
                    gonameElement.addEventListener('change', updateGonameAndPrice);
                }
            }

            // 직접 입력 단가 필드 이벤트 바인딩
            document.getElementById('goprice1').addEventListener('input', updateGonameAndPrice);
            document.getElementById('goprice2').addEventListener('input', updateGonameAndPrice);
            document.getElementById('goprice3').addEventListener('input', updateGonameAndPrice);

            // 단가 select 요소 이벤트 바인딩
            document.getElementById('goprice').addEventListener('change', updateGonameAndPrice);
        }

        attachEventListeners();
    });
</script>
</head>
<body class="bg-light">
    품명이름 등록
    <div class="py-5 container text-center">
        <form name="frmMain" action="goods_itemdb.asp" method="post">
        <div class="input-group mb-3">
            <div class="col-3">
                <span class="input-group-text">코드&nbsp;&nbsp;&nbsp;</span>
                <input type="text" class="form-control" name="gocode" value="">
            </div>
            <div class="col-3">
                <span class="input-group-text">축약어&nbsp;&nbsp;&nbsp;</span>
                <input type="text" class="form-control" name="gocword" value="">
            </div>
            <div class="col-3">
                <span class="input-group-text">전체품명&nbsp;&nbsp;&nbsp;</span>
                <input type="text" class="form-control" id="goname" name="goname" value="" placeholder="예: TK_통도장 안전"> 
            </div>
            <div class="col-3">
                <span class="input-group-text">사용중/안함</span>
                    <select class="form-select" name="gostatus">
                        <option value="1">사용중</option>
                        <option value="2" >사용안함</option>
                    </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(안전/한쪽안전/일반)</span>
                    <select class="form-select" name="goname1" id="goname1" >
                    <option value="0" <% if goname1="0" or goname1="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname1="1"  then  %>selected<% end if %>>안전</option> 
                    <option value="2" <% if goname1="2" then  %>selected<% end if %>>한쪽안전</option>
                    <option value="3" <% if goname1="3" then  %>selected<% end if %>>일반</option>
                    <option value="4" <% if goname1="4" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(복층안전/복층한쪽안전/복층일반)</span>
                <select class="form-select" name="goname2" id="goname2" >
                    <option value="0" <% if goname2="0" or goname2="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname2="1"  then  %>selected<% end if %>>복층안전</option> 
                    <option value="2" <% if goname2="2" then  %>selected<% end if %>>복층한쪽안전</option>
                    <option value="3" <% if goname2="3" then  %>selected<% end if %>>복층일반</option>
                    <option value="4" <% if goname2="4" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(단열안전/단열한쪽안전/단열일반)</span>
                <select class="form-select" name="goname3" id="goname3" >
                    <option value="0" <% if goname3="0" or goname3="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname3="1"  then  %>selected<% end if %>>단열안전</option> 
                    <option value="2" <% if goname3="2" then  %>selected<% end if %>>단열한쪽안전</option>
                    <option value="3" <% if goname3="3" then  %>selected<% end if %>>단열일반</option>
                    <option value="4" <% if goname3="4" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(삼중_단열안전/삼중_단열한쪽안전/삼중_단열일반)</span>
                <select class="form-select" name="goname4" id="goname4" >
                    <option value="0" <% if goname4="0" or goname4="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname4="1"  then  %>selected<% end if %>>삼중_단열안전</option> 
                    <option value="2" <% if goname4="2" then  %>selected<% end if %>>삼중_단열한쪽안전</option>
                    <option value="3" <% if goname4="3" then  %>selected<% end if %>>삼중_단열일반</option>
                    <option value="4" <% if goname4="4" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(매립자동/한쪽안전_매립자동/양쪽안전_매립자동)</span>
                <select class="form-select" name="goname5" id="goname5" >
                    <option value="0" <% if goname5="0" or goname5="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname5="1"  then  %>selected<% end if %>>매립자동</option> 
                    <option value="2" <% if goname5="2" then  %>selected<% end if %>>한쪽안전_매립자동</option>
                    <option value="3" <% if goname5="3" then  %>selected<% end if %>>양쪽안전_매립자동</option>
                    <option value="4" <% if goname5="4" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(매립단열자동/한쪽안전_매립단열자동/양쪽안전_매립단열자동)</span>
                <select class="form-select" name="goname6" id="goname6" >
                    <option value="0" <% if goname6="0" or goname6="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname6="1"  then  %>selected<% end if %>>매립단열자동</option> 
                    <option value="2" <% if goname6="2" then  %>selected<% end if %>>한쪽안전_매립단열자동</option>
                    <option value="3" <% if goname6="3" then  %>selected<% end if %>>양쪽안전_매립단열자동</option>
                    <option value="4" <% if goname6="4" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(34자동)</span>
                <select class="form-select" name="goname7" id="goname7">
                    <option value="0" <% if goname7="0" or goname7="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname7="1"  then  %>selected<% end if %>>34자동</option> 
                    <option value="2" <% if goname7="2" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(비매립힌지 안전/비매립힌지 한쪽안전/비매립힌지 일반)</span>
                <select class="form-select" name="goname8" id="goname8" >
                    <option value="0" <% if goname8="0" or goname8="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname8="1"  then  %>selected<% end if %>>비매립힌지 안전</option> 
                    <option value="2" <% if goname8="2" then  %>selected<% end if %>>비매립힌지 한쪽안전</option>
                    <option value="3" <% if goname8="3" then  %>selected<% end if %>>비매립힌지 일반</option>
                    <option value="4" <% if goname8="4" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(비매립힌지 복층안전/비매립힌지 복층한쪽안전/비매립힌지 복층일반)</span>
                <select class="form-select" name="goname9" id="goname9">
                    <option value="0" <% if goname9="0" or goname9="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname9="1"  then  %>selected<% end if %>>비매립힌지 복층안전</option> 
                    <option value="2" <% if goname9="2" then  %>selected<% end if %>>비매립힌지 복층한쪽안전</option>
                    <option value="3" <% if goname9="3" then  %>selected<% end if %>>비매립힌지 복층일반</option>
                    <option value="4" <% if goname9="4" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(비매립힌지 단열안전/비매립힌지 단열한쪽안전/비매립힌지 단열일반)</span>
                <select class="form-select" name="goname10" id="goname10" >
                    <option value="0" <% if goname10="0" or goname10="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname10="1"  then  %>selected<% end if %>>비매립힌지 단열안전</option> 
                    <option value="2" <% if goname10="2" then  %>selected<% end if %>>비매립힌지 단열한쪽안전</option>
                    <option value="3" <% if goname10="3" then  %>selected<% end if %>>비매립힌지 일반</option>
                    <option value="4" <% if goname10="4" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(통도장/스텐/기타)</span>
                <select class="form-select" name="goname11" id="goname11" >
                    <option value="0" <% if goname11="0" or goname11="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname11="1"  then  %>selected<% end if %>>통도장</option> 
                    <option value="2" <% if goname11="2" then  %>selected<% end if %>>스텐/갈바</option>
                    <option value="3" <% if goname11="3" then  %>selected<% end if %>>기타</option>
                </select>
            </div>
            <div class="col-4">
            <span class="input-group-text">타입선택(다대무홈/현장시공용)</span>
                <select class="form-select" name="goname12" id="goname12" >
                    <option value="0" <% if goname12="0" or goname12="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname12="1"  then  %>selected<% end if %>>다대무홈</option> 
                    <option value="2" <% if goname12="2" then  %>selected<% end if %>>기타</option>
                </select>
            </div> 
            <div class="col-4">
            <span class="input-group-text">타입선택(중간키)</span>
                <select class="form-select" name="goname13" id="goname13" >
                    <option value="0" <% if goname13="0" or goname13="" then  %>selected<% end if %>>선택안함</option>
                    <option value="1" <% if goname13="1"  then  %>selected<% end if %>>중간키</option> 
                    <option value="2" <% if goname13="2" then  %>selected<% end if %>>기타</option>
                </select>
            </div>  
            <div class="col-4">
            <span class="input-group-text">가격&nbsp;&nbsp;&nbsp;</span>
                <select type="number" class="form-select" name="goprice" id="goprice" step="100" min="0" oninput="updateGonameAndPrice()">
                    <option value="0">0</option>
                    <option value="100000">100000</option> <!-- goname1 -->
                    <option value="110000">110000</option> <!-- goname2 -->
                    <option value="150000">150000</option> <!-- goname3 -->
                    <option value="200000">200000</option> <!-- goname4 -->
                    <option value="100000">110000</option> <!-- goname5 -->
                    <option value="110000">160000</option> <!-- goname6 -->
                    <option value="150000">100000</option> <!-- goname7 -->
                    <option value="200000">140000</option> <!-- goname8 -->
                    <option value="150000">150000</option> <!-- goname9 -->
                    <option value="200000">200000</option> <!-- goname10 -->
                </select>
            </div>
            <div class="col-4">
                <span class="input-group-text">중간키 단가</span>
                <input type="number" class="form-control" name="goprice1" id="goprice1" value="25000" step="100" min="0" oninput="updateGonameAndPrice()">
            </div>
            <div class="col-4">
                <span class="input-group-text">다대무홈 단가</span>
                <input type="number" class="form-control" name="goprice2" id="goprice2" value="5000" step="100" min="0" oninput="updateGonameAndPrice()">
            </div>
            <div class="col-4">
                <span class="input-group-text">합계 단가</span>
                <input type="number" class="form-control" name="goprice3" id="goprice3" value="0" step="100" min="0" oninput="updateGonameAndPrice()">
            </div>
            
        </div>
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-primary" onclick="validateForm();">저장</button>
            <button type="button" class="btn btn-outline-secondary" onclick="location.replace('goods_itemin.asp');">닫기</button>
        </div>

        


</form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384- YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></>
   
    
</body>
</html>