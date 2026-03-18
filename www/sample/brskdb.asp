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


part=Request("part")    'DB처리 구분값

baname=Request("baname")    '절곡이름
bastatus=Request("bastatus")    '절곡상태

rbaidx=Request("rbaidx")    '절곡키값
bassize=Request("bassize")  '치수입력값
basdirection=Request("basdirection")    '방향

final=Request("final")  '샤링값 적용여부
  
cx2=Request("x2")   '시작점 x좌표
cy2=Request("y2")   '시작점 y좌표

kak=Request("kak")  '앞각 뒷각
response.write "part : "&part&"<br>"
response.write "baname : "&baname&"<br>"
response.write "rbaidx : "&rbaidx&"<br>"
response.write "bassize : "&bassize&"<br>"
response.write "basdirection : "&basdirection&"<br>"
response.write "final : "&final&"<br>"
 
response.write "cx2 : "&cx2&"<br>"
response.write "cy2 : "&cy2&"<br>"

'절곡(tk_barasi) 생성 시작
if part="binsert" then 
    if baname="" then 
        response.write "<script>alert('이름입력');history.back();</script>" 
        response.end
    else
    SQL="Insert into tk_barasi (baname,bamidx, bawdate,bastatus) values ('"&baname&"','"&c_midx&"',getdate(),'"&bastatus&"' ) "
    Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('brsk.asp');</script>"
    end if 
end if
'절곡(tk_barasi) 생성 끝

'절곡(tk_barasi) 정보 수정시작
if part="bupdate" then 
    sql="update tk_barasi set baname='"&baname&"' , bastatus='"&bastatus&"' where baidx='"&rbaidx&"' "
    Response.write (SQL)&"<br>"
    'Dbcon.Execute (SQL)
    response.write "<script>location.replace('brsk.asp?rbaidx="&rbaidx&"&part=update');</script>"
end if 
'절곡(tk_barasi) 정보 수정 끝

'치수입력 시작
if part="bisnsert" then 
    if bassize="" then 
        response.write "<script>alert('치수를 입력해 주세요.');history.back();</script>" 
        response.end
    else

'첫 입력 여부 확인 및 초기 변수 설정 시작
    SQL="Select top 1 basidx, x1, y1, x2, y2, accsize, basdirection, idv, basp2, ysr2, ysr1, ody, bassize From tk_barasisub Where baidx='"&rbaidx&"' order by basidx desc"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then '입력값이 하나라도 있다면
        basidx=Rs(0)    '최근 절곡 서브키값
        x1=Rs(1)    '최근 시작점 x좌표
        y1=Rs(2)    '최근 시작저 y좌표
        x2=Rs(3)    '최근 종점 x좌표
        y2=Rs(4)    '최근 종점 y좌표
        accsize=Rs(5)   '최근 결과값2
        pba=Rs(6)   '최근 방향
        pidv=Rs(7)  '최근 보정값
        basp2=Rs(8)   '전전방향 / 사용안함
        pysr2=Rs(9) '전전 연신율
        pysr1=Rs(10)    '최근 연신율
        pody=Rs(11) '최근 순번
        pbassize=Rs(12)  '최근 수치 입력값
        

    else  '입력값이 없다면 초기 변수 설정
        x1=Cint(cx2)    '시작점 x좌표를 입력값으로 설정
        y1=Cint(cy2)    '시작점 y좌표를 입력값으로 설정
        x2=Cint(cx2)    '종점 x좌표를 입력값으로 설정
        y2=Cint(cy2)    '종점 y좌표를 입력값으로 설정
        pba=0   '최근 방향 0으로 초기화
        basp2=0   '전전방향 0으로 초기화/ 사용안함
        accsize=0   '결과값2 0으로 초기화
        ody="0" ' 순번 0으로 초기화
    End if
    Rs.Close
'첫 입력 여부 확인 및 초기 변수 설정 끝
' 방향에 대한 x2좌표 적용 시작
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
' 방향에 대한 x2좌표 적용 끝

    if pba="0" then '첫 등록이라면
        idv=0
        ysr2=0
        ysr1=0
    else '두번째 등록부터
        p2=basp2    '전전 방향
        p1=pba  '이전방향
        p0=basdirection    '현재방향
        ody=pody+1

        '이전 연신율 및 결과값수정 시작

        if kak="1" then 
          if (p1="2" and p0="1") or (p1="3" and p0="2")  or (p1="4" and p0="3")  or (p1="1" and p0="4") then 
              ysr1=0.5
    
          end if
          if (p1="4" and p0="1") or (p1="1" and p0="2") or (p1="2" and p0="3") or (p1="3" and p0="4") then 
              ysr1=-0.5
  
          end if
        elseif  kak="2" then 
          if (p1="2" and p0="1") or (p1="3" and p0="2")  or (p1="4" and p0="3")  or (p1="1" and p0="4") then 
              ysr1=-0.5
    
          end if
          if (p1="4" and p0="1") or (p1="1" and p0="2") or (p1="2" and p0="3") or (p1="3" and p0="4") then 
              ysr1=0.5
  
          end if
        end if


        '전전 결과값 2을 불러와 최근 결과값 2를 다시 설정 시작
        ppody=pody-1    '전전 레코드의 순번
        SQL="Select accsize From tk_barasisub Where  baidx='"&rbaidx&"' and ody='"&ppody&"' "
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            paccsize=Rs(0)
        End if
        Rs.Close

        '전전 결과값 2을 불러와 최근 결과값 2를 다시 설정 끝


        if ody="1" then '두번째 입력이어 첫번째 수정이라면 idv = 0으로 초기화
            idv = 0
        else 
            idv = pysr2+ysr1
        end if
        accsize=Cint(paccsize)+Cint(pbassize)+Cint(idv) 

        SQL="Update tk_barasisub set ysr1="&ysr1&", idv='"&idv&"', accsize='"&accsize&"' Where basidx='"&basidx&"' "
        Response.write (SQL)&"<br><br>"
        'response.end
        Dbcon.Execute (SQL)
        '이전 연신율 및 결과값수정 끝

    end if


'절곡값 입력 시작
'==========================================
response.write "accsize : "&accsize&"<br>"

ysr2=ysr1   '연신율을 신규입력의 전연신율로 적용
response.write "ysr2 : "&ysr2&"<br>"

if final="1" then 
    SQL="Insert into tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection, basmidx, baswdate,   final, basp2, ysr2,   ody) "
    SQL=SQL&" values ('"&rbaidx&"', '"&x1&"', '"&y1&"', '"&x2&"', '"&y2&"', '"&bassize&"', '"&basdirection&"', '"&c_midx&"', getdate(),   '"&final&"', '"&pba&"', "&ysr2&",  '"&ody&"')"
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute (SQL)
elseif final="0" then 
    accsize=accsize+bassize
    SQL="Insert into tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection, basmidx, baswdate, final, basp2, ysr2, ody, ysr1 , idv, accsize ) "
    SQL=SQL&" values ('"&rbaidx&"', '"&x1&"', '"&y1&"', '"&x2&"', '"&y2&"', '"&bassize&"', '"&basdirection&"', '"&c_midx&"', getdate(), '"&final&"', '"&pba&"', "&ysr2&", '"&ody&"', 0, 0, '"&accsize&"')"
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute (SQL)
end if
'==========================================
'절곡값 입력 끝


'가로세로 최소좌표 최대좌표 구해서 업데이트 시작
'==========================================
    SQL="select min(x1), max(x1), min(x2), max(x2), min(y1), max(y1), min(y2), max(y2) "
    SQL=SQL&" From tk_barasisub "
    SQL=SQL&" Where baidx='"&rbaidx&"' "
    response.write (SQL)&"<BR>"
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

'==========================================
'가로세로 최소좌표 최대좌표 구해서 업데이트 끝

    response.write "<script>location.replace('brsk.asp?rbaidx="&rbaidx&"');</script>"



    end if


end if
'치수입력 끝

set Rs=Nothing
call dbClose()
%>
