<!-- 

    [jeanidx]     키값       
    쿠키 
    c_midx = request.cookies("tk")("c_midx")	    '회원키값
    c_cidx = request.cookies("tk")("c_cidx")		'회원 소속사 키
    c_mname = request.cookies("tk")("c_mname")		'회원 이름
    c_cname = request.cookies("tk")("c_cname")		'회원 소속사 이름  
    쿠키    
    
    [jeandate]   등록일
    [jeandate]  수정일
-->

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

'listgubun="three"
projectname="제안제도"
    developername="양양"

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 

	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


SearchWord=Request("SearchWord")
gubun=Request("gubun")
 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="jean.asp?"


%>
 <nav class="sb-topnav navbar navbar-expand navbar-light bg-light">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href=""><%=projectname%></a>
            <!-- Sidebar Toggle-->
            <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
<%=c_cname%>&nbsp;<%=c_mname%>
            
            <!-- Navbar Search-->
            <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0" method="post" action="jeandb.asp" name="searchForm1">
                <div class="input-group">
                    <div class="input-group">
                        <input class="form-control" type="text" placeholder="제안내역 조회" aria-label="제안내역 조회" aria-describedby="btnNavbarSearch" name="SearchWord" />
                        <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="searchForm.submit();"><i class="fas fa-search"></i></button>
                    </div>
                </div>
            </form>
            <!-- Navbar-->
            <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="/inc/logOut.asp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
        </nav>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no"/>
    <meta name="description" content="제안 사항 작성 페이지"/>
    <meta name="작가" content="yang"/>
    <title>제안사항 작성하기</title>
    <link rel="icon" type="image/png" sizes="32x32" href="http://devkevin.cafe24.com/lyh/favicon-32x32.png">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script>
        // 이미지 미리보기 기능
        function previewImage(input) {
            const previewContainer = document.getElementById("previewContainer");
            previewContainer.innerHTML = ""; // 이전 미리보기 초기화
            for (const file of input.files) {
                if (file.type.startsWith("image/")) { // 이미지 파일만 처리
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const img = document.createElement("img");
                        img.src = e.target.result;
                        img.style.maxWidth = "100%";
                        img.style.maxHeight = "200px";
                        img.classList.add("my-2");
                        previewContainer.appendChild(img);
                    };
                    reader.readAsDataURL(file);
                }
            }
        }

        // 제안 유형 선택 처리
        function handleProposalType(type) {
            const c_mnameField = document.getElementById("c_mname");
            const searchPopup = document.getElementById("searchPopup");

            if (type === "single") { // 개인 제안
                c_mnameField.disabled = false;
                searchPopup.style.display = "none";
                c_mnameField.value = "<%=c_mname%>"; // 현재 로그인한 사용자 이름 입력
            } else if (type === "group") { // 공동 제안
                c_mnameField.value = ""; // 기존 이름 제거
                c_mnameField.disabled = true;
                searchPopup.style.display = "block";
            }
        }

        // 검색 팝업 열기
        function openSearchPopup() {
            // 여기에서 팝업 검색 기능 구현 필요
            alert("사용자 검색 후 다중 선택할 수 있습니다.");
        }

        // 폼 유효성 검사
        function validateForm() {
            const c_mnameField = document.getElementById("c_mname");
            const jemokField = document.frmMain.jemok.value;
            const jeansahangField = document.frmMain.jeansahang.value;

            if (!jemokField) {
                alert("제목을 입력해주세요.");
                return false;
            }
            if (!jeansahangField) {
                alert("제안사항을 입력해주세요.");
                return false;
            }
            if (!c_mnameField.value) {
                alert("제안자를 입력해주세요.");
                return false;
            }

            document.frmMain.submit();
        }
    </script>
</head>
<body class="bg-light">
    <div class="py-5 container text-center">
        <h3>제안사항 작성하기</h3>
        <form name="frmMain" action="nboarddb.asp" method="post" enctype="multipart/form-data">
            <!-- 제안 유형 선택 -->
            <div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="proposalType" id="singleProposal" value="single" onclick="handleProposalType('single')" checked>
    <label class="form-check-label" for="singleProposal">개인 제안</label>
</div>
<div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="proposalType" id="groupProposal" value="group" onclick="handleProposalType('group')">
    <label class="form-check-label" for="groupProposal">공동 제안</label>
</div>

<!-- 개인 제안 입력 -->
<div id="singleProposalFields" style="display: block;">
    <div class="input-group mb-3">
        <span class="input-group-text">이름</span>
        <input type="text" class="form-control" id="c_mname" name="c_mname" value="<%=c_mname%>" readonly>
    </div>
</div>

<!-- 공동 제안 입력 -->
<div id="groupProposalFields" style="display: none;">
    <div class="input-group mb-3">
        <span class="input-group-text">공동 제안자</span>
        <input type="text" class="form-control" id="jean_c_mnames" name="jean_c_mnames" readonly onclick="openSearchPopup()">
        <button type="button" class="btn btn-outline-secondary" onclick="openSearchPopup()">검색</button>
    </div>
</div>

<script>
    // 제안 유형에 따른 입력 필드 표시
    function handleProposalType(type) {
        const singleFields = document.getElementById("singleProposalFields");
        const groupFields = document.getElementById("groupProposalFields");

        if (type === "single") {
            singleFields.style.display = "block";
            groupFields.style.display = "none";
        } else if (type === "group") {
            singleFields.style.display = "none";
            groupFields.style.display = "block";
        }
    }

    // 공동 제안자 검색 팝업
    function openSearchPopup() {
        const popup = window.open("jeannamePopup.asp", "memberSearch", "width=600,height=400,scrollbars=yes");
        popup.onbeforeunload = function() {
            if (popup.selectedMembers) {
                // 선택된 멤버 데이터를 입력 필드에 반영
                const jeanCNamesField = document.getElementById("jean_c_mnames");
                jeanCNamesField.value = popup.selectedMembers.map(member => member.mname).join(", ");
            }
        };
    }
</script>

            
            <!-- 이름 입력 -->
            <div class="input-group mb-3">
                <span class="input-group-text">이름</span>
                <input type="text" class="form-control" id="c_mname" name="c_mname" value="<%=c_mname%>" readonly>
                <button type="button" class="btn btn-outline-secondary" id="searchPopup" style="display: none;" onclick="openSearchPopup()">검색</button>
            </div>
            
            <!-- 제목 입력 -->
            <div class="input-group mb-3">
                <span class="input-group-text">제목</span>
                <input type="text" class="form-control" name="jemok" value="">
            </div>
            
            <!-- 제안사항 입력 -->
            <div class="input-group mb-3">
                <span class="input-group-text">제안사항</span>
                <textarea class="form-control" name="jeansahang" rows="10"></textarea>
            </div>
            
            <!-- 파일 업로드 -->
<div class="input-group mb-3">
    <span class="input-group-text">파일 업로드</span>
    <input type="file" class="form-control" name="uploadFile[]" multiple onchange="handleFileChange(this)">
</div>
<div id="fileInputsContainer" class="mb-3"></div>
<div id="previewContainer" class="text-center"></div>

<script>
    // 파일 변경 처리: 새로운 파일 입력 필드 자동 추가
    function handleFileChange(input) {
        const container = document.getElementById("fileInputsContainer");
        
        // 미리보기 생성
        previewImage(input);

        // 새 파일 입력 필드 생성
        const inputGroup = document.createElement("div");
        inputGroup.className = "input-group mb-3";

        const inputFile = document.createElement("input");
        inputFile.type = "file";
        inputFile.name = "uploadFile[]";
        inputFile.className = "form-control";
        inputFile.multiple = true;
        inputFile.onchange = function() {
            handleFileChange(inputFile);
        };

        inputGroup.appendChild(inputFile);
        container.appendChild(inputGroup);
    }

    // 이미지 미리보기
    function previewImage(input) {
        const previewContainer = document.getElementById("previewContainer");
        for (const file of input.files) {
            if (file.type.startsWith("image/")) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.createElement("img");
                    img.src = e.target.result;
                    img.style.maxWidth = "100%";
                    img.style.maxHeight = "200px";
                    img.classList.add("my-2");
                    previewContainer.appendChild(img);
                };
                reader.readAsDataURL(file);
            }
        }
    }
</script>


            
            <!-- 추가 코멘트 -->
            <div class="input-group mb-3">
                <span class="input-group-text">추가 코멘트</span>
                <textarea class="form-control" name="additionalComment" rows="3"></textarea>
            </div>
            
            <!-- 등록/취소 버튼 -->
            <div class="input-group mb-3">
                <button type="button" class="btn btn-outline-primary" onclick="validateForm()">등록</button>
                <button type="button" class="btn btn-outline-secondary" onclick="location.replace('jean.asp')">취소</button>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
