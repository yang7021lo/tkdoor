Select A.fkidx, B.fksidx, B.xi, B.yi, B.wi, B.hi ,C.set_name_Fix, C.set_name_AUTO, A.sjb_idx, fstype
from tk_framek A 
Join tk_framekSub B On A.fkidx=B.fkidx 
Left OUter Join tk_barasiF C On B.bfidx=C.bfidx 
Where A.sjidx='21' and A.sjsidx='67'
order by xi ASC
fksidx, xi, yi, wi, hi


Select revidx, revsjidx, revsjsidx, revfksidx, revxi, revyi, revwi, revhi, revstatus, revwdate, ody
From tk_reverse
Where revsjidx='21' and revsjsidx='67'
order by ody DESC

Insert into tk_reverse (revsjidx, revsjsidx, revfksidx, revxi, revyi, revwi, revhi, revstatus ) 
values ('"&revsjidx&"', '"&revsjsidx&"', '"&revfksidx&"', '"&revxi&"', '"&revyi&"', '"&revwi&"', '"&revhi&"', '0' )

Select B.fksidx, B.xi, B.yi, B.wi, B.hi 
from tk_framek A 
Join tk_framekSub B On A.fkidx=B.fkidx 
Left OUter Join tk_barasiF C On B.bfidx=C.bfidx
Where A.sjidx='21' and A.sjsidx='66'

Select top 1 revxi, revyi From tk_reverse Where revsjidx='21' and revsjsidx='67' Order by revxi asc,  revyi asc
