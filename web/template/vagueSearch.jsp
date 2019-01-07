<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/11/11
  Time: 11:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="search">
    <form method="get" action="<%=request.getRequestURI()%>">
        <input class="form-control-input" type="text" name="keyWords" placeholder="输入关键字查找">
        <button class="form-control" type="submit">查找</button>
    </form>
</div>