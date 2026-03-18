<html>
  <head></head>
  <body>
<!-- ...existing code... -->
<form id="myForm" method="get" action="aaa.asp" class="d-flex align-items-center gap-2">
  <select name="selectValue" id="selectValue" class="form-select" style="width:auto;">
    <option value="A">A</option>
    <option value="B">B</option>
    <option value="C">C</option>
  </select>
  <input type="hidden" name="buttonValue" id="buttonValue">
  <button type="button" class="btn btn-primary" onclick="submitWithValue(1)">1</button>
  <button type="button" class="btn btn-primary" onclick="submitWithValue(2)">2</button>
  <button type="button" class="btn btn-primary" onclick="submitWithValue(3)">3</button>
  <button type="button" class="btn btn-primary" onclick="submitWithValue(4)">4</button>
</form>

<script>
  function submitWithValue(val) {
    document.getElementById('buttonValue').value = val;
    document.getElementById('myForm').submit();
  }
</script>
<!-- ...existing code... -->    
    </body>
</html>