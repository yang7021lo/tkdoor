<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>jQuery Split Example</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <form>
        <label for="inputNumber">Input Number:</label>
        <input type="number" id="inputNumber" value="0"><br><br>

        <label for="selectNumber">Select Number:</label>
        <select id="selectNumber">
            <option value="0_0">0</option>
            <option value="1_10">10</option>
            <option value="2_20">20</option>
            <option value="3_30">30</option>
        </select><br><br>

        <label for="result">Result:</label>
        <input type="number" id="result" readonly><br><br>
            <input type="number" id="aaa" value="<%=aaa%>">
    </form>

    <script>
        $(document).ready(function() {
            function updateResult() {
                // Get the input value
                const inputVal = parseFloat($('#inputNumber').val()) || 0;

                // Get the select value and split it
                const selectVal = $('#selectNumber').val();
                const splitVal = parseFloat(selectVal.split('_')[1]) || 0;

                const aaa = parseFloat(selectVal.split('_')[0]) || 0;
      
                // Calculate the sum
                const sum = inputVal + splitVal;

                // Set the result
                $('#result').val(sum);
                $('#aaa').val(aaa);
 
            }

            // Bind event listeners
            $('#inputNumber, #selectNumber').on('input change', updateResult);
        });
    </script>

</body>
</html>
