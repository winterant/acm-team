
<%--
  Created by IntelliJ IDEA.
  User.java: winter
  Date: 2018/10/22
  Time: 20:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="Tools.Paging" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="Tools.Changing" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-管理员-用户列表</title>
</head>
<body>
<%
    User user= (User) session.getAttribute("user");
    if(user==null||!user.isExist()||user.getInt("power")==0){
        response.sendRedirect("/"); //不是管理员将被送回主页
        return;
    }
%>
    <%@include file="/template/header.jsp"%>
    <div class="bigContainer">
        <%@include file="managerLeft.jsp"%>

        <%-- 用户列表 --%>
        <div class="adminRightArea">
            <h3>用户列表</h3>

            <%@include file="/template/vagueSearch.jsp"%>

            <%--页码--%>
            <%
                request.setCharacterEncoding("UTF-8");
                String keyWords=request.getParameter("keyWords");
                String strPage=request.getParameter("nowPage");
                int nowPage= Changing.strToNumber(strPage,1); //检查是否指定页数
                Paging paging=new Paging("users");
                paging.setOrder("id",1); //id升序
                paging.addVague("userName",keyWords);  //模糊查询
                paging.addVague("nickName",keyWords);
                paging.addVague("school",keyWords);
                paging.setPageSize(30);
                List<Map<String,Object>> list=paging.getDataList(nowPage); //获取当前页的内容
                paging.addNextArgs("keyWords",keyWords);  //页面传参,继续模糊查询

                request.setAttribute("list",list);
            %>
            <%@include file="/template/pagingDiv.jsp"%>

            <table class="table-list">
                <tr>
                    <th>编号</th>
                    <th>用户名</th>
                    <th>姓名</th>
                    <th>权限</th>
                    <th>身份</th>
                    <th>信息锁定</th>
                    <th>操作</th>
                </tr>
                <c:forEach var="item" items="${list}" varStatus="j">
                    <tr>
                        <td>${item.id}</td>
                        <td><a href="${rootPath}/profilePage.jsp?userName=${item.userName}">${item.userName}</a></td>
                        <td>${item.nickName}</td>
                        <td>
                            <font id="iden${j.index}">${["student","@teacher","@@administrator"][item.power]}</font>
                            <c:if test="${'admin'==user.userMap.userName}">
                                <a href="javascript:changePower('${item.userName}',1);" title="升级权限">↑</a>
                                <a href="javascript:changePower('${item.userName}',0);" title="降级权限">↓</a>
                            </c:if>
                        </td>
                        <td>
                            <font>${["hidden","@display","@@Love"][item.status]}</font>
                            <c:if test="${'admin'==user.userMap.userName}">
                                <a href="javascript:changeStatus('${item.userName}',1);" title="升级身份">↑</a>
                                <a href="javascript:changeStatus('${item.userName}',0);" title="降级身份">↓</a>
                            </c:if>
                        </td>
                        <td>
                            [<a id="alowStr${j.index}" href="javascript:changeAlow('${item.userName}','alowStr${j.index}')" title="点击切换">${item.alowModify>0?"自由":"已限制"}</a>]
                        </td>
                        <td align="center">
                            <c:if test="${user.userMap.power>item.power}">
                                [<a class="oneline" href="/second/userModifyPage.jsp?userName=${item.userName}" title="修改信息">修改</a>]
                                [<a class="oneline" href="javascript:if(confirm('确定删除该用户吗?'))deleteUser('${item.userName}')" title="永久删除该用户">删除</a>]
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>

            </table>
        </div>
    </div>
    <%@include file="/template/footer.jsp"%>
<script type="text/javascript">

    document.getElementById('userList').style.backgroundColor="#b3b3b3";
    document.getElementById('userList').style.color="#000000";

</script>
</body>
</html>