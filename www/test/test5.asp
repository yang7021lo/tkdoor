<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>jQuery Split Example</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <form name="aa" action="testdb.asp" methon="post">
        <label for="inputNumber">Input Number:</label>
        <input type="number" id="inputNumber" name="inputNumber" value="0"><br><br>

        <label for="selectNumber">Select Number:</label>
        <select id="selectNumber"  name="selectNumber">
            <option value="0_0_None">None</option>
            <option value="1_10_Hello">Hello</option>
            <option value="2_20_World">World</option>
            <option value="3_30_Test">Test</option>
        </select><br><br>

        <label for="firstValue">First Value:</label>
        <input type="number" id="firstValue" name="firstValue" value="<%=firstValue%>" readonly><br><br>

        <label for="sumResult">Sum Result:</label>
        <input type="number" id="sumResult" name="sumResult" value="<%=sumResult%>"readonly><br><br>

        <label for="textResult">Text Result:</label>
        <input type="text" id="textResult" name="textResult" value="<%=textResult%>" readonly><br><br>

        <button class="btn btn-primary"  type="submit" onclik="submit();">저장</button>
    </form>

    <script>
        $(document).ready(function() {
            function updateResults() {
                // Get the input value
                const inputVal = parseFloat($('#inputNumber').val()) || 0;

                // Get the select value and split it
                const selectVal = $('#selectNumber').val();
                const parts = selectVal.split('_'); // Split the value into parts

                const firstNumber = parseFloat(parts[0]) || 0; // Get the first number
                const secondNumber = parseFloat(parts[1]) || 0; // Get the second number
                const thirdText = parts[2] || ''; // Get the third text

                // Calculate the sum
                const sum = inputVal + secondNumber;

                // Update the result fields
                $('#firstValue').val(firstNumber); // Display the first value
                $('#sumResult').val(sum); // Display the sum
                $('#textResult').val(thirdText); // Display the third text
            }

            // Bind event listeners
            $('#inputNumber, #selectNumber').on('input change', updateResults);
        });
    </script>
</body>
</html>
