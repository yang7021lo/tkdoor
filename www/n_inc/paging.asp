

                        <nav aria-label="Page navigation example">
                          <ul class="pagination justify-content-center">
<% if gotopage <>1 then%>
                            <li class="page-item">
                              <a class="page-link" href="<%=page_name%>gotopage=<%=gotopage-1%>#his" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                              </a>
                            </li>
<% end if %>
<%
	i=1
    blockpage=1
	Do until i>10 or blockpage > rs.PageCount  
	if blockpage=int(gotopage) then 
%>
	<li class="page-item"><a class="page-link" href="#">[<%=blockpage%>]</a></li>
<% else %>
	<li class="page-item"><a class="page-link" href="<%=page_name%>gotopage=<%=blockpage%>#his"><%=blockpage%></a></li>
<% end if %>
<% 
	blockpage=blockpage+1
	i=i+1
	loop
%>
<% if cint(gotopage) <>cint(totalpage) and totalpage<>0 then%>
                            <li class="page-item">
                              <a class="page-link" href="<%=page_name%>gotopage=<%=gotopage+1%>#his" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                              </a>
                            </li>
<% end if%>
                          </ul>
                        </nav>