<%@ Language="VBScript" %>
<%
' 프로토콜 구성
Dim sProtocol, sHost, sPort, sPath, sQuery, sFullUrl

If Request.ServerVariables("HTTPS") = "on" Then
    sProtocol = "https://"
Else
    sProtocol = "http://"
End If

' 호스트 및 포트
sHost = Request.ServerVariables("HTTP_HOST")
sPort = Request.ServerVariables("SERVER_PORT")

' 포트번호가 기본값이 아니라면 포트 포함
If (sProtocol = "http://" And sPort <> "80") Or (sProtocol = "https://" And sPort <> "443") Then
    sHost = sHost & ":" & sPort
End If

' 경로 및 쿼리스트링
sPath = Request.ServerVariables("SCRIPT_NAME")
sQuery = Request.ServerVariables("QUERY_STRING")

' 최종 URL 조합
If sQuery <> "" Then
    sFullUrl = sProtocol & sHost & sPath & "?" & sQuery
Else
    sFullUrl = sProtocol & sHost & sPath
End If

' 변수에 저장 (필요 시 Session 또는 DB 저장 가능)
Dim currentUrl
currentUrl = sFullUrl

' 출력 테스트
Response.Write "<p><strong>현재 접속된 부모 페이지 URL:</strong><br>" & currentUrl & "</p>"
%>
