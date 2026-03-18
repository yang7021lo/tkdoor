<%  

    c_midx = request.cookies("tk")("c_midx")	  '회원키값
    c_cidx = request.cookies("tk")("c_cidx")		'회원 소속사 키
    c_mname = request.cookies("tk")("c_mname")		'회원 이름
    c_cname = request.cookies("tk")("c_cname")		'회원 소속사 이름
    

    '파일 저장경로
    DefaultPath="F:\HOME\tkserver01\www\tfile"
    DefaultPath_bfimg="F:\HOME\tkserver01\www\img\frame\bfimg"
    DefaultPath_door="F:\HOME\tkserver01\www\img\door"
    DefaultPath_board="F:\HOME\tkserver01\www\cyj\cfile"
    DefaultPath_report="F:\HOME\tkserver01\www\report\rfile"
    DefaultPath_advice="F:\HOME\tkserver01\www\ooo\afile"
    DefaultPath_add="F:\HOME\tkserver01\www\report\arfile"
    DefaultPath_pu="F:\HOME\tkserver01\www\img\frame\pufile"
    DefaultPath_paint="F:\HOME\tkserver01\www\img\paint"

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
