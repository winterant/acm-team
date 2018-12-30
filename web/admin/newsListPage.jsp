<%@ page import="Mysql.SQL" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="Tools.Paging" %>
<%@ page import="Tools.Changing" %><%--
  Created by IntelliJ IDEA.
  User.java: winter
  Date: 2018/10/22
  Time: 20:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-管理员-新闻</title>
</head>
<body>
    <%
        User user= (User) session.getAttribute("user");
        if(user==null||!user.isExist()||user.getInt("power")==0){
            response.sendRedirect("/"); //不是管理员将被送回主页
        }
    %>
    <%@include file="/template/header.jsp"%>
    <div class="bigContainer">
        <div class="main-container">
            <%@include file="managerLeft.jsp"%>
            <%-- 新闻列表 --%>
            <div class="adminRightArea">
                <h3>新闻列表</h3>

                <%
                    request.setCharacterEncoding("UTF-8");
                    String keyWords=request.getParameter("keyWords");
                    String nowPageStr=request.getParameter("nowPage");
                    int nowPage= Changing.strToNumber(nowPageStr,1);
                    Paging paging=new Paging("news");
                    paging.setOrder("publishTime",1);
                    paging.addVague("title",keyWords);
                    paging.addVague("author",keyWords);
                    paging.addVague("id",keyWords);
                    paging.setPageSize(30);
                    List<Map<String,Object>> list=paging.getDataList(nowPage); //获取当前页的内容
                    paging.addNextArgs("keyWords",keyWords);
                    request.setAttribute("news",list);
                %>
                <%@include file="../template/vagueSearch.jsp"%>
                <%@include file="../template/pagingDiv.jsp"%>

                <table class="table-list">
                    <tr>
                        <th>编号</th>
                        <th>标题</th>
                        <th>作者</th>
                        <th>发表时间</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                    <c:forEach var="item" items="${news}" varStatus="j">
                        <tr id="news${j.index}">
                            <td>${item.id}</td>
                            <td><a href="/second/newsPage.jsp?nid=${item.id}" >${item.title}</a></td>
                            <td><a href="/profilePage.jsp?userName=${item.author}">${item.author}</a></td>
                            <td>${fn:substring(item.publishTime,0,19)}</td>
                            <td>${item.status==1?"公开":"草稿"}</td>
                            <td align="center">
                                    <%--用p 的white-space:nowrap 强制不换行--%>
                                [<a class="oneline" href="newsEditorPage.jsp?nid=${item.id}" >修改</a>]
                                <c:if test="${item.id>1}">
                                    [<a class="oneline" href="javascript:if(confirm('确定删除该新闻吗?'))newsDelete('${item.id}')" >删除</a>]
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>

                </table>
            </div>
        </div>
    </div>
    <%@include file="/template/footer.jsp"%>
<script type="text/javascript">

    document.getElementById('newsList').style.backgroundColor="#b3b3b3";
    document.getElementById('newsList').style.color="#000000";

</script>
</body>

</html>