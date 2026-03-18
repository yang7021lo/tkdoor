<!-- 글자입력시 텍스 복사 시작 -->
    <script>
    function printName()  {
        const name = document.getElementById('name').value;
        document.getElementById('result').innerText = name;

    }
    
    </script>
<input id='name' onkeyup='printName()'/>
<div id='result'></div>
<!-- 글자입력시 텍스 복사 끝-->



<!-- 마우스 클릭시 복사 시작 -->
<script type="text/javascript">

function transfer(){

var pix = document.getElementById('pix').value;

document.abc.test.value =pix;

}

</script>

<form action="" name="abc">

<input type="text" id="pix">

<input type="button" value="click" onclick="transfer();">

<input type="text" name="test" id="test">

</form>
<!-- 마우스 클릭시 복사 끝 -->
