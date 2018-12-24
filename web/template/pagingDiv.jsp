<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/11/2
  Time: 22:00
  To change this template use File | Settings | File Templates.
--%>

<%--
    // java示例
    /*
    Paging paging=new Paging("users");
    paging.setOrder("rating",1); //按积分降序
    paging.addVague("userName",keyWords);  //模糊查询
    paging.addExact("nickName",key); //精确查找

    paging.setPageSize(6);  //规定每页显示条数!!

    List<Map<String,Object>> list=paging.getDataList(nowPage); //获取nowPage页的内容
    paging.addNextArgs("keyWords",keyWords);  //页面传参,继续模糊查询
     */
--%>
<%--这是一个页码条的模板模块,上面是java代码示例--%>
<%--需要上面的页面定义页码对象paging--%>

<div class="pagingContainer <%=paging.getEndPage()==1?" hide":""%>">
    <div class="paging">
        <li>
            <a href="<%=paging.getGotoPath(request,paging.getIndexPage())%>" style="border-top-left-radius: 4px;border-bottom-left-radius: 4px"> << </a>
        </li>
        <%
            for(int i=paging.getLeft();i<paging.getNowPage();i++){
        %>
            <li><a href="<%=paging.getGotoPath(request,i)%>"> <%=i%> </a></li>
        <%}%>
        <li><a style="background-color: #748190;color: #fcfcff" href="<%=paging.getGotoPath(request,paging.getNowPage())%>"> <%=paging.getNowPage()%> </a></li>
        <%
            for(int i=paging.getNowPage()+1;i<=paging.getRight();i++){
        %>
            <li><a href="<%=paging.getGotoPath(request,i)%>"> <%=i%> </a></li>
        <%}%>
        <li><a href="<%=paging.getGotoPath(request,paging.getEndPage())%>" style="border-top-right-radius: 4px;border-bottom-right-radius: 4px" > >> </a></li>
    </div>
</div>
