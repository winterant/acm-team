
<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/10/22
  Time: 20:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-管理员</title>
</head>
<body>
    <%
        User user= (User) session.getAttribute("user");
        if(user==null||!user.isExist()||user.getInt("power")==0){
            response.sendRedirect("/");
        }
    %>
    <%@include file="/template/header.jsp"%>

    <div class="bigContainer">
        <%@include file="managerLeft.jsp"%>
        <div class="adminRightArea">
            <div>
                <img src="${rootPath}/images/background/icpclogo.jpg" alt="icpc" width="80%">
            </div>
        </div>
    </div>
    <%--end of bigContainer--%>

    <%@include file="/template/footer.jsp"%>
</body>
</html>
