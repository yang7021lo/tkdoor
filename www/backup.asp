<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
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
</head>
<body>

<!--화면시작-->
<%

'파일읽기 시작
Response.CodePage = 65001
Response.Charset = "UTF-8"
Dim fso, txtFile, filePath, line

' 파일 경로 지정
filePath = Server.MapPath("shr3.txt")  ' 현재 폴더에 있는 *.txt 파일을 읽어옵니다.

' FileSystemObject 객체 생성
Set fso = Server.CreateObject("Scripting.FileSystemObject")

' 파일이 존재하는지 확인
If fso.FileExists(filePath) Then
    ' 파일 열기
    Set txtFile = fso.OpenTextFile(filePath, 1, false, -1)  ' 1은 읽기 모드

    ' 파일 내용 출력
    Do Until txtFile.AtEndOfStream
        line = txtFile.ReadLine
        sline=split(line,",")
        Response.Write sline(0)&"/"&sline(1)&"/"&sline(2)&"<br>"
        'Response.Write(line & "<br>")  ' 각 줄을 HTML에서 줄바꿈하여 출력
    Loop

    ' 파일 닫기
    txtFile.Close
    Set txtFile = Nothing
Else
    Response.Write("파일을 찾을 수 없습니다.")
End If

' FileSystemObject 객체 해제
Set fso = Nothing
'파일읽기 끝
%>

<!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>
