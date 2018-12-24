
<%--
  Created by IntelliJ IDEA.
  User.java: winter
  Date: 2018/9/18
  Time: 10:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-主页</title>
</head>
<body>
    <%@ include file="/template/header.jsp"%>

    <div class="bigContainer">
        <%--左侧概览区域--%>
        <%@include file="/template/homeLeftPage.jsp"%>

        <%-- 主页区域 --%>
        <div class="homeContainer">
            <div class="homeNotice homeRightMod">
                <%
                    SQL mysql=new SQL();
                    String sql="select * from news where id=1";
                    request.setAttribute("notice",mysql.queryFirst(sql));
                %>
                <div style="position: relative">
                    <h1 style="margin-left:15px;margin-bottom:0;color: #00b708">${notice.title}</h1>
                    <c:if test="${user!=null&&user.userMap.power>0}">
                        <font style="position: absolute;bottom: 0;right:3%;" >
                            [<a href="${rootPath}/admin/newsEditorPage.jsp?nid=${notice.id}">编辑</a>]
                        </font>
                    </c:if>
                </div>

                <div class="newsReadInfo hide" style="text-align: center;">
                    <td>作者：[ <a href="/profilePage.jsp?userName=${notice.author}">${notice["author"]}</a> ]</td>
                    <td>时间：[ ${notice["publishTime"].toString().substring(0,19)} ]</td>
                    <td>浏览：[ ${notice.lookCount} ]</td>
                </div>
                <hr>
                <div class="mainText" style="width: 90%;margin:10px auto;text-align: left">
                    <p>${notice.mainText}</p>
                </div>
            </div>
            <%--end of homeNotice--%>

        </div>
        <%--end of homeContainer--%>

    </div>
    <%--end of bigContainer--%>

    <%@ include file="/template/footer.jsp"%>
<script type="text/javascript">
    document.getElementById('home').style.color="<%=homeSelectColor%>";
</script>
</body>
</html>
