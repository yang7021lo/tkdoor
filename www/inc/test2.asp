<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
<script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
<script>
function GetSum() {
    var total = '';
    var firstNum = 0;
    var secondNum = 0;

    firstNum = Number($('#NUM1').val());
    secondNum = Number($('#NUM2').val());
    total = firstNum + secondNum
    $('#RESULT').val(total);

}
</script>
</head>
<body>


<input type="text" onKeyup"this.value=this.value.replace(/[^0-9]/g,'');">
<table>
    <tr>
        <th scope="col">첫번째 값</th>
        <th scope="col">두번째 값</th>
        <th scope="col">결과</th>

    </tr>
    <tr>
        <td><input type="text" id="NUM1" name="NUM1" value="" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');GetSum();" /></td>
        <td><input type="text" id="NUM2" name="NUM2" value="" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');GetSum();" /></td>
        <td><input type="text" id="RESULT" name="RESULT" value="" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');GetSum();" /></td>

    </tr>    
</table>
</body>
</html>



