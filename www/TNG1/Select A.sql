Select A.sjidx, A.sjsidx, B.sjb_idx, F.sjb_type_name, A.mwidth, A.mheight, A.qtyidx, C.qtyname, A.sjsprice, A.quan, A.disrate, A.disprice, A.taxrate, A.sprice
, A.fprice , A.midx, D.mname, A.mwdate, A.meidx, E.mname, A.mewdate, A.astatus 
From tng_sjaSub A 
left outer Join tng_sjb B On A.sjb_idx=B.sjb_idx 
left outer Join tk_qty C On A.qtyidx=C.qtyidx 
Join tk_member D On A.midx=D.midx 
Join tk_member E On A.meidx=E.midx 
Left Outer JOin tng_sjbtype F On B.sjb_type_no=F.sjb_type_no 
Where A.sjidx='' and A.astatus='1'


Select tsprice, trate, tdisprice, tfprice, taxprice, tzprice from tng_sja where sjidx=21

select * from tng_sjaSub where sjidx=21

update tng_sjaSub set taxrate='105000'  where sjsidx=67
update tng_sjaSub set taxrate='46000'  where sjsidx=68

66
67
68
1050000
460000



