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

    response.write "<script>location.replace('barasik0228.asp');</script>"
    end if 
end if

'업데이트 방식
if part="bupdate" then 
    sql="update tk_barasi set baname='"&baname&"' , bastatus='"&bastatus&"' where baidx='"&rbaidx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    response.write "<script>location.replace('barasik0228.asp?rbaidx="&rbaidx&"&part=update');</script>"
end if 





if part="bisnsert" then 
    if bassize="" then 
        response.write "<script>alert('치수입력');history.back();</script>" 
        response.end
    else




'첫행일 경우 좌표 초기화
    SQL="Select top 1 basidx, x1, y1, x2, y2, accsize, basdirection, idv, basp2 From tk_barasisub Where baidx='"&rbaidx&"' order by basidx desc"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        basidx=Rs(0)
        x1=Rs(1)
        y1=Rs(2)
        x2=Rs(3)
        y2=Rs(4)
        accsize=Rs(5)
        pba=Rs(6)   '이전방향
        pidv=Rs(7)
        basp2=Rs(8)   '전전방향

    else
        x1=Cint(cx2)
        y1=Cint(cy2)
        x2=Cint(cx2)
        y2=Cint(cy2)
        pba=0   '이전방향
        basp2=0   '전전방향
    End if
    Rs.Close

    if basdirection="1" then 
        x1=x2
        y1=y2
        x2=x1+bassize
        y2=y1

    elseif basdirection="2" then 
        x1=x2
        y1=y2
        x2=x1
        y2=y1+bassize

    elseif basdirection="3" then 
        x1=x2
        y1=y2
        x2=x1-bassize
        y2=y1

    elseif basdirection="4" then 
        x1=x2
        y1=y2
        x2=x1
        y2=y1-bassize

    end if
'가로 세로 사이즈 구하기 시작

'가로 세로 사이즈 구하기 끝
response.write "xsize : "&xsize&"<br>"
response.write "ysize : "&ysize&"<br>"

    if pba="0" then '첫 등록이라면
        idv=0
    else '두번째 등록부터
        p2=basp2    '전전 방향
        p1=pba  '이전방향
        p0=basdirection    '현재방향

        if p2="0" then 
            '두번째 줄도 전전값이 0이므로 idv 무조건 -1로 처리
            idv="-1"
        else
            if p2="1" and p1="2" and p0="1" then idv="1" end if
            if p2="1" and p1="4" and p0="1" then idv="1" end if
            if p2="3" and p1="2" and p0="1" then idv="-1" end if
            if p2="3" and p1="4" and p0="1" then idv="-1" end if

            if p2="2" and p1="1" and p0="2" then idv="1" end if
            if p2="2" and p1="3" and p0="2" then idv="1" end if
            if p2="4" and p1="1" and p0="2" then idv="-1" end if
            if p2="4" and p1="3" and p0="2" then idv="-1" end if

            if p2="1" and p1="2" and p0="3" then idv="-1" end if
            if p2="1" and p1="4" and p0="3" then idv="-1" end if
            if p2="3" and p1="2" and p0="3" then idv="1" end if
            if p2="3" and p1="4" and p0="3" then idv="1" end if

            if p2="2" and p1="1" and p0="4" then idv="-1" end if
            if p2="2" and p1="3" and p0="4" then idv="-1" end if
            if p2="4" and p1="1" and p0="4" then idv="1" end if
            if p2="4" and p1="3" and p0="4" then idv="1" end if
        end if
    end if



response.write "p2 : "&p2&"<br>"




'역발향 발생시 이전 idv값 0으로 변경 
if idv="1" and pidv="-1" then 
    accsize=accsize+1
    SQL="Update tk_barasisub set idv=0, accsize="&accsize&" Where basidx='"&basidx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if

'이전에 idv가 1이거나. 현재 선이 최종일 경우 idv=0dmfh
if pidv="1" or final="1" then 
    idv=0
end if
response.write "accsize : "&accsize&"<br>"
response.write "bassize : "&bassize&"<br>"
response.write "idv : "&idv&"<br>"

    accsize=accsize+bassize+idv 

    SQL="Insert into tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection, basmidx, baswdate, accsize, idv, final, basp2) "
    SQL=SQL&" values ('"&rbaidx&"', '"&x1&"', '"&y1&"', '"&x2&"', '"&y2&"', '"&bassize&"', '"&basdirection&"', '"&c_midx&"', getdate(), '"&accsize&"', '"&idv&"', '"&final&"', '"&pba&"')"
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    'response.end





'가로세로 최소좌표 최대좌표 구해서 업데이트

    SQL="select min(x1), max(x1), min(x2), max(x2), min(y1), max(y1), min(y2), max(y2) "
    SQL=SQL&" From tk_barasisub "
    SQL=SQL&" Where baidx='"&rbaidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        min_x1=Rs(0)
        max_x1=Rs(1)
        min_x2=Rs(2)
        max_x2=Rs(3)
        min_y1=Rs(4)
        max_y1=Rs(5)
        min_y2=Rs(6)
        max_y2=Rs(7)

        if Cint(min_x1) <= Cint(min_x2) then  
            sx1=min_x1
        else
            sx1=min_x2
        end if
        if Cint(max_x1) >= Cint(max_x2) then  
            sx2=max_x1
        else
            sx2=max_x2
        end if

        if Cint(min_y1) <= Cint(min_y2) then  
            sy1=min_y1
        else
            sy1=min_y2
        end if
        if Cint(max_y1) >= Cint(max_y2) then  
            sy2=max_y1
        else
            sy2=max_y2
        end if

        xsize=sx2-sx1
        ysize=sy2-sy1
    SQL="Update tk_barasi set xsize='"&xsize&"', ysize='"&ysize&"', sx1='"&sx1&"', sx2='"&sx2&"', sy1='"&sy1&"', sy2='"&sy2&"' Where baidx='"&rbaidx&"' "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    End If
    Rs.Close
    response.write "<script>location.replace('barasik0228.asp?rbaidx="&rbaidx&"');</script>"
    end if 

end if

set Rs=Nothing
call dbClose()
%>
