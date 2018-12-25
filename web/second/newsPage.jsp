
<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/11/4
  Time: 21:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Mysql.SQL" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
<%@include file="/template/headTag.jsp"%>
<%
    //浏览量+1
    request.setCharacterEncoding("UTF-8");
    String nid=request.getParameter("nid");
    SQL mysql=new SQL();
    String sql;
    if(true) {
        sql = "update news set lookCount=lookCount+1 where id='" + nid + "'";
        mysql.update(sql);
    }
    sql="select * from news where id='"+nid+"'";
    Map<String,Object> news=mysql.queryFirst(sql);
    mysql.close();
%>
    <title><%=news.get("title")%></title>
</head>
<body>
    <%@include file="../template/header.jsp"%>
    <div class="bigContainer">
        <%--左侧概览区域--%>
        <%@include file="/template/homeLeftPage.jsp"%>

        <%--  新闻区域  --%>
        <div class="homeContainer">
            <div class="newsContainer">
                <h1 align="center" style="width: 92%"><%=news.get("title")%></h1>
                <div class="newsReadInfo" style="text-align: center;">
                    <td>作者：[ <a href="/profilePage.jsp?userName=<%=news.get("author")%>"><%=news.get("author")%></a> ]</td>
                    <td>时间：[ <%=news.get("publishTime").toString().substring(0,19)%> ]</td>
                    <td>浏览：[ <%=news.get("lookCount")%> ]</td>
                    <c:if test="${user.userMap.power>0}">
                        [<a class="oneline" href="/admin/newsEditorPage.jsp?nid=<%=nid%>" >编辑</a>]
                    </c:if>
                </div>
                <hr>
                <div class="mainText" style="width: 90%;margin:10px auto;">
                    <p><%=news.get("mainText")%></p>
                </div>
            </div>
        </div>

    </div>
    <%@include file="../template/footer.jsp"%>
</body>
</html>
