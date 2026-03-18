<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<% projectname="부속 등록" %>

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
        // Form submission happens here
        document.frmMain.submit();
    }

    // Function to update barNAME dynamically based on barNAME1 and barNAME2 selections
    function updateBarName() {
        var barNAME1 = document.frmMain.barNAME1.value; // Get selected value of barNAME1
        var barNAME2 = document.frmMain.barNAME2.value; // Get selected value of barNAME2
        var barNAME = ""; // Initialize the variable to hold the new barNAME value

        // Logic to update barNAME based on the selected values of barNAME1 and barNAME2
        if (barNAME1 != "0" && barNAME2 != "0") {
            // Generate the name dynamically
            barNAME = barNAME1 + " * " + barNAME2;
        }

        // Set the value of barNAME field
        document.frmMain.barNAME.value = barNAME; // Update barNAME field with the generated name
    }

    // Attach the updateBarName function to the onchange event of barNAME1 and barNAME2
    window.onload = function() {
        // Adding real-time event listener for barNAME1 and barNAME2
        document.frmMain.barNAME1.addEventListener('change', updateBarName);
        document.frmMain.barNAME2.addEventListener('change', updateBarName);
    };
</script>
<script>
    // Get the input element and datalist
    const inputElement = document.getElementById('barNAME1');
    const datalist = document.getElementById('barNAME1Options');

    // Function to add the user's input to the datalist dynamically
    inputElement.addEventListener('input', function() {
        const userInput = inputElement.value.trim();  // Get the input value

        // Check if there's any input, and if it's not already in the datalist
        if (userInput && !Array.from(datalist.options).some(option => option.value === userInput)) {
            let newOption = document.createElement('option');  // Create a new option element
            newOption.value = userInput;  // Set the input value as the option value
            datalist.appendChild(newOption);  // Add it to the datalist
        }
    });
</script>
</head>
<body class="bg-light">
<h3>부속 입력</h3>
    <div class="py-5 container text-center">
        <form name="frmMain" action="barlist_itemdb.asp" method="post" ENCTYPE="multipart/form-data">
            <div class="input-group mb-3">
            <div class="col-3">
                <span class="input-group-text">이름</span>
                    <input type="text" class="form-control" name="barNAME" value="">
                </div>
                <div class="col-3">
                    <span class="input-group-text">다대바</span>
                    <input type="number" class="form-control" name="barNAME1" id="barNAME1" value="">
                </div>
                <div class="col-3">
                <span class="input-group-text">에치바</span>
                <select class="form-select" name="barNAME2" id="barNAME2">
                    <option value="0">선택안함</option>
                    <option value="90">90</option>
                    <option value="100">100</option>
                    <option value="105">105</option>
                    <option value="120">120</option>
                    <option value="150">150</option>
                </select>
                <input type="text" id="customBarNAME2" class="form-control mt-2" placeholder="직접 입력" />
            </div>
                <div class="col-3">    
                <span class="input-group-text">코드</span>
                <input type="text" class="form-control" name="barCODE" value="">
                </div>
                <div class="col-3">    
                <span class="input-group-text">축약어</span>
                <input type="text" class="form-control" name="barshorten" value="">
                </div>
                <div class="col-3">  
                <span class="input-group-text">단위(EA,Kg,M)</span>
                <input type="text" class="form-control" name="barQTY" value="">
                </div>
                <div class="col-3">
                <span class="input-group-text">사용중/안함</span>
                    <select class="form-select" name="barSTATUS">
                        <option value="1">사용중</option>
                        <option value="2" >사용안함</option>
                    </select>
                </div>
            </div> 
            <div class="input-group mb-3">   
                <div class="col-3">  
                <span class="input-group-text">단가</span>
                <select class="form-select" name="barlistprice">
                        <option value="0">선택안함</option>
                        <option value="0" >0 50*90</option>
                        <option value="2" >20000 65*90</option>
                        <option value="3" >25000 70*90</option>
                        <option value="4" >30000 80*90</option>
                        <option value="5" >35000 90*90</option>
                        <option value="6" >40000 100*90</option>
                        <option value="7" >50000 120*90</option>
                        <option value="8" >65000 150*90</option>
                        <option value="9" >기타</option>
                    </select>
                </div>
                
            </div>
            <div class="input-group mb-3">
                <button type="button" class="btn btn-outline-primary" onclick="validateForm();">저장</button>
                <button type="button" class="btn btn-outline-secondary" onclick="location.replace('barlist_itemin.asp');">닫기</button>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384- YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
</body>
</html>