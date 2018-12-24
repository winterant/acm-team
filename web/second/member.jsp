<%@ page import="Mysql.SQL" %>
<%@ page import="java.util.Map" %><%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/12/20
  Time: 13:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-团队成员主页</title>
</head>
<body>
    <%@include file="/template/header.jsp"%>

    <%
        String midStr=request.getParameter("mid");
        SQL mysql=new SQL();
        Object member=mysql.queryFirst("select * from members where id="+midStr);
        if(member==null||((Map)member).isEmpty()){
            response.sendRedirect("/");
            return;
        }
        request.setAttribute("member",member);
    %>

    <div class="bigContainer">
        <div class="userProfile">
            <%--个人信息表--%>
            <div id="userInfo">
                <div>
                    <font size="15em">${member.name}</font>
                    <font>(${["退役队员","现役","教师"][member.identity]})</font>
                </div>
                <c:if test="${member.identity<2}">
                    <div style="padding:5px;">
                        <font size="3em">${member.grade}级&nbsp;${member.major}</font>
                    </div>
                </c:if>
                <hr>
                <div class="someInfo">
                    <font>现今: <font style="font-size:1.2em;">${member.work}</font></font>
                </div>

                <div class="someInfo">
                    <font>blog: <a href="${member.blog}" target="_blank">${member.blog}</a></font>
                </div>
                <div class="someInfo">
                    <font>email: ${member.email}</font>
                </div>
                <hr>
                <div class="someInfo">
                    ${member.introduce}
                </div>
            </div>
            <%--end of userInfo--%>

            <%--begin of user photo--%>
            <div id="photo-div">
                <div id="photo">
                    <img width="100%" src="/ServletLoad?type=memberPhoto&mid=${member.id}" alt="">
                </div>
            </div>
            <%--end of user photo--%>

        </div>
        <%--end of member--%>

    </div>

    <%@include file="/template/footer.jsp"%>

<script type="text/javascript">
    document.getElementById('members').style.color="<%=homeSelectColor%>";

</script>
</body>
</html>
