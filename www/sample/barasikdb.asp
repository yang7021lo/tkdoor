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


part=Request("part")
baname=Request("baname")

rbaidx=Request("rbaidx")
bassize=Request("bassize")
basdirection=Request("basdirection")
bastatus=Request("bastatus")
final=Request("final")
cx2=Request("x2")
cy2=Request("y2")
response.write "part : "&part&"<br>"
response.write "baname : "&baname&"<br>"
response.write "rbaidx : "&rbaidx&"<br>"
response.write "bassize : "&bassize&"<br>"
response.write "basdirection : "&basdirection&"<br>"
response.write "final : "&final&"<br>"
response.write "x2 : "&cx2&"<br>"
response.write "y2 : "&cy2&"<br>"

'x1,x2, y1,y2좌표를 넣어야 한다.
if part="binsert" then 
    if baname="" then 
        response.write "<script>alert('이름입력');history.back();</script>" 
        response.end
    else
    SQL="Insert into tk_barasi (baname,bamidx, bawdate,bastatus) values ('"&baname&"','"&c_midx&"',getdate(),'"&bastatus&"' ) "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('barasik.asp');</script>"
    end if 
end if

'업데이트 방식
if part="bupdate" then 
    sql="update tk_barasi set baname='"&baname&"' , bastatus='"&bastatus&"' where baidx='"&rbaidx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    response.write "<script>location.replace('barasik.asp?rbaidx="&rbaidx&"&part=update');</script>"
end if 





if part="bisnsert" then 
    if bassize="" then 
        response.write "<script>alert('치수입력');history.back();</script>" 
        response.end
    else

'전체 가로 세로 사이즈 불러오기
    SQL="Select xsize, ysize From tk_barasi Where  baidx='"&rbaidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        xsize=Rs(0)
        ysize=Rs(1)
    End If
    Rs.Close


'첫행일 경우 좌표 초기화
    SQL="Select top 1 basidx, x1, y1, x2, y2, accsize, basdirection,idv From tk_barasisub Where baidx='"&rbaidx&"' order by basidx desc"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        basidx=Rs(0)
        x1=Rs(1)
        y1=Rs(2)
        x2=Rs(3)
        y2=Rs(4)
        accsize=Rs(5)
        pba=Rs(6)
        pidv=Rs(7)

    else
        x1=Cint(cx2)
        y1=Cint(cy2)
        x2=Cint(cx2)
        y2=Cint(cy2)
        pba=0
    End if
    Rs.Close

    if basdirection="1" then 
        x1=x2
        y1=y2
        x2=x1+bassize
        y2=y1
        xsize=xsize+bassize '전체 가로 값 적용
    elseif basdirection="2" then 
        x1=x2
        y1=y2
        x2=x1
        y2=y1+bassize
        ysize=ysize+bassize '전체 세로 값 적용
    elseif basdirection="3" then 
        x1=x2
        y1=y2
        x2=x1-bassize
        y2=y1
        xsize=xsize-bassize '전체 가로 값 적용
    elseif basdirection="4" then 
        x1=x2
        y1=y2
        x2=x1
        y2=y1-bassize
        ysize=ysize-bassize '전체 세로 값 적용
    end if



    if pba="0" then '첫 등록이라면
            idv=0
    else '두번째 등록부터
        if (basdirection="3" and pba="4") or (basdirection="1" and pba="2") then '반시계가 있다면
            idv=1
        elseif (basdirection = 4 and pba = 3) or (basdirection = 2 and pba = 1) then
            idv=-1
        else
            idv=0
        end if
    end if



response.write "abc : "&abc&"<br>"

response.write "accsize : "&accsize&"<br>"
response.write "idv : "&idv&"<br>"

'반시계 발생이 이전 idv값 0으로 변경
if basdirection="3"  and pba="4" then '반시계가 있다면
    accsize=accsize+1
    SQL="Update tk_barasisub set idv=0, accsize="&accsize&" Where basidx='"&basidx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if
if basdirection="1"  and pba="2" then '반시계가 있다면
    accsize=accsize+1
    SQL="Update tk_barasisub set idv=0, accsize="&accsize&" Where basidx='"&basidx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if

if pidv="1" or final="1" then 
    idv=0
end if

    accsize=accsize+bassize+idv 

    SQL="Insert into tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection, basmidx, baswdate, accsize, idv, final) "
    SQL=SQL&" values ('"&rbaidx&"', '"&x1&"', '"&y1&"', '"&x2&"', '"&y2&"', '"&bassize&"', '"&basdirection&"', '"&c_midx&"', getdate(), '"&accsize&"', '"&idv&"', '"&final&"')"
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    SQL="Update tk_barasi set xsize='"&xsize&"', ysize='"&ysize&"' Where baidx='"&rbaidx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    response.write "<script>location.replace('barasik.asp?rbaidx="&rbaidx&"');</script>"
    end if 

end if

set Rs=Nothing
call dbClose()
%>
