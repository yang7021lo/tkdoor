<nav aria-label="Page navigation example">
    <ul class="pagination justify-content-center">
        <%
        blockpage=int((gotopage-1)/10)*10+1
        if blockpage=1 then 
            Response.Write ""
        else 
        %>
            <li class="page-item"><a class="page-link" href="<%=page_name%>gotopage=1" ><span aria-hidden="true">&lt;&lt;&lt;</span></a></li>
            <li class="page-item"><a class="page-link" href="<%=page_name%>gotopage=<%=blockpage-10%>"><span aria-hidden="true">&lt;&lt;</span></a></li>
        <% 
        end if
        %> 

        <% if gotopage <>1 then%>
            <li class="page-item"><a class="page-link" href="<%=page_name%>gotopage=<%=gotopage-1%>"><span aria-hidden="true">&lt;</span></a></li>
        <% else %>
        <% end if %>

        <%		
        i=1
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
            <li class="page-item"><a class="page-link" href="<%=page_name%>gotopage=<%=gotopage+1%>">&gt;</a></li>
        <% else %>
        <% end if%>

        <%
        if blockpage>rs.PageCount  then 
        Response.Write ""
        %>
        <% else %>
            <li class="page-item"><a class="page-link" href="<%=page_name%>gotopage=<%=blockpage%>" ><span aria-hidden="true">&gt;&gt;</span></a></li>
            <a class="page-link" href="<%=page_name%>gotopage=<%=CInt(rs.recordcount/rs.PageSize)%>" ><span aria-hidden="true">&gt;&gt;&gt;</span></a>
        <% end if%>   
    </ul>
</nav>