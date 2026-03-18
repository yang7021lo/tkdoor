<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>jQuery Split with String</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <form>
        <label for="inputNumber">Input Number:</label>
        <input type="number" id="inputNumber" value="0"><br><br>

        <label for="selectNumber">Select Number:</label>
        <select id="selectNumber">
            <option value="0_0_None">None</option>
            <option value="1_10_Hello">Hello</option>
            <option value="2_20_World">World</option>
            <option value="3_30_Test">Test</option>
        </select><br><br>

        <label for="sumResult">Sum Result:</label>
        <input type="number" id="sumResult" readonly><br><br>

        <label for="textResult">Text Result:</label>
        <input type="text" id="textResult" readonly><br><br>
    </form>

    <script>
        $(document).ready(function() {
            function updateResults() {
                // Get the input value
                const inputVal = parseFloat($('#inputNumber').val()) || 0;

                // Get the select value and split it
                const selectVal = $('#selectNumber').val();
                const parts = selectVal.split('_'); // Split the value into parts

                const secondNumber = parseFloat(parts[1]) || 0; // Get the second number
                const thirdText = parts[2] || ''; // Get the third text

                // Calculate the sum
                const sum = inputVal + secondNumber;

                // Update the result fields
                $('#sumResult').val(sum);
                $('#textResult').val(thirdText);
            }

            // Bind event listeners
            $('#inputNumber, #selectNumber').on('input change', updateResults);
        });
    </script>
</body>
</html>
