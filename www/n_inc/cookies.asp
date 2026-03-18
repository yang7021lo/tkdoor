<%  


    '쿠키 불러오기 종료
	'projectname="발주관리"
	'discription="시설이용 관리 "

    '파일 저장경로
    DefaultPath="F:\HOME\devkevin\www\tkdoor\img"
 
    yy=Year(now())
    mm=Month(now())
    If Len(mm)="1" Then 
        mm="0"&mm
    End If
    dd=Day(now())
    If Len(dd)="1" Then 
        dd="0"&dd
    End If
    hh=Hour(now())
    If Len(hh)="1" Then 
        hh="0"&hh
    End If
    nn=Minute(now())
    If Len(nn)="1" Then 
        nn="0"&nn
    End If
    ss=Second(now())
    If Len(ss)="1" Then 
        ss="0"&ss
    End If
    ymdhns=yy&mm&dd&hh&nn&ss


	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function 
%>
