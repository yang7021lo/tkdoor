<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
%>
<% 
part=Request("part")
kgotopage=request("kgotopage")
rSearchWord=Request("SearchWord")

rpidx           = Request("pidx")            ' [pidx] 페인트 고유번호
rpcode          = Request("pcode")           ' [pcode] 코드
rpshorten       = Request("pshorten")        ' [pshorten] 축약명
rpname          = Request("pname")           ' [pname] 페인트 이름
rpprice         = Request("pprice")          ' [pprice] 단가
rpstatus        = Request("pstatus")         ' [pstatus] 상태
rpmidx          = Request("pmidx")           ' [pmidx] 등록자
rpwdate         = Request("pwdate")          ' [pwdate] 등록일
rpemidx         = Request("pemidx")          ' [pemidx] 수정자
rpewdate        = Request("pewdate")         ' [pewdate] 수정일
rpname_brand    = Request("pname_brand")     ' [pname_brand] 제조사 번호 (1.조광 2.애경(플랙스폰) 3.KCC(코푸럭스) 4.PPG 5.신양금속)
rp_percent      = Request("p_percent")       ' [p_percent] 할증비율
rp_image        = Request("p_image")         ' [p_image] 페인트 이미지
rp_sample_image = Request("p_sample_image")  ' [p_sample_image] 샘플 이미지
rp_sample_name  = Request("p_sample_name")   ' [p_sample_name] 샘플명
rcidx           = Request("cidx")            ' [cidx] 수주처
rsjidx          = Request("sjidx")           ' [sjidx] 수주키
rin_gallon      = Request("in_gallon")       ' [in_gallon] 입고량
rout_gallon     = Request("out_gallon")      ' [out_gallon] 사용량
rremain_gallon  = Request("remain_gallon")   ' [remain_gallon] 남은량
rcname          = Request("cname")           ' [cname] 수주처 이름
rmname          = Request("mname")           ' [mname] 작성자 이름
rpaint_type     = Request("paint_type")      ' [paint_type] 색상 타입 (1.기본 2.원색 3.브라운 4.메탈릭)
rcoat           = Request("coat")            ' [coat] 도장 횟수

Response.Write "rpidx : " & rpidx & "<br>"
'Response.end

if part="delete" then 

    SQL="Delete From tk_paint Where pidx='"&rpidx&"' "
    'Response.write (SQL)&"<br>"
    'Response.end
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('paint_itemin.asp?kgotopage="&kgotopage&"&SearchWord="&rSearchWord&"&pidx="&rpidx&"');</script>"

else 

    if rpidx="0" then 

        SQL = "INSERT INTO tk_paint (pcode, pshorten, pname, pprice, pstatus, pmidx, pwdate, pemidx, pewdate, pname_brand, paint_type, p_percent"
        SQL = SQL & ", p_image, p_sample_image, p_sample_name, cidx, sjidx, in_gallon, out_gallon, remain_gallon, coat ) "
        SQL = SQL & "VALUES ('" & rpcode & "', N'" & rpshorten & "', N'" & rpname & "', N'" & rpprice & "', 1 "
        SQL = SQL & ", '" & C_midx & "', getdate(), '" & C_midx & "', getdate(), '" & rpname_brand & "', '" & rpaint_type & "', '" & rp_percent & "'"
        SQL = SQL & ", N'" & rp_image & "', N'" & rp_sample_image & "', N'" & rp_sample_name & "', '" & rcidx & "', '" & rsjidx & "'"
        SQL = SQL & ", '" & rin_gallon & "', '" & rout_gallon & "', '" & rremain_gallon & "', '" & rcoat & "')"
        'Response.write (SQL)&"<br>"
        'Response.END
        Dbcon.Execute(SQL)

        response.write "<script>location.replace('paint_itemin.asp?kgotopage="&kgotopage&"&SearchWord="&rSearchWord&"&pidx="&rpidx&"');</script>"
    
    else

        SQL = "UPDATE tk_paint SET "
        SQL = SQL & "pcode = '" & rpcode & "', "
        SQL = SQL & "pshorten = N'" & rpshorten & "', "
        SQL = SQL & "pname = N'" & rpname & "', "
        SQL = SQL & "pprice = N'" & rpprice & "', "
        SQL = SQL & "pstatus = 1 , "
        SQL = SQL & "pemidx = '" & C_midx & "', "
        SQL = SQL & "pewdate = getdate(), "
        SQL = SQL & "pname_brand = '" & rpname_brand & "', "
        SQL = SQL & "paint_type = '" & rpaint_type & "', "
        SQL = SQL & "p_percent = '" & rp_percent & "', "
        SQL = SQL & "p_image = N'" & rp_image & "', "
        SQL = SQL & "p_sample_image = N'" & rp_sample_image & "', "
        SQL = SQL & "p_sample_name = N'" & rp_sample_name & "', "
        SQL = SQL & "cidx = '" & rcidx & "', "
        SQL = SQL & "sjidx = '" & rsjidx & "', "
        SQL = SQL & "in_gallon = '" & rin_gallon & "', "
        SQL = SQL & "out_gallon = '" & rout_gallon & "', "
        SQL = SQL & "remain_gallon = '" & rremain_gallon & "', "
        SQL = SQL & "coat = '" & rcoat & "' "
        SQL = SQL & "WHERE pidx = '" & rpidx & "'"
        Response.write(SQL) & "<br>"
        'Response.END
        Dbcon.Execute(SQL)

        response.write "<script>location.replace('paint_itemin.asp?kgotopage="&kgotopage&"&SearchWord="&rSearchWord&"&pidx="&rpidx&"');</script>"
    
    end if 

end if 
%>


<%
set Rs=Nothing
call dbClose()
%>