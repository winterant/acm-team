<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/10/22
  Time: 20:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <div id="manager-left-menu">
        <div style="overflow: hidden;margin-top: 1%">
            <div class="leftSmallTitle" style="float: none">管理员</div>
            <img src="${rootPath}/images/background/icpclogo.jpg" alt="ICPC" style="width:96%;">
        </div>
        <hr>
        <ul id="dropManage">
            <li><a id="userList" href="userListPage.jsp">用户列表</a> </li>
            <li><a id="newsList" href="newsListPage.jsp">新闻列表</a> </li>
            <li><a id="memberList" href="membersListPage.jsp">成员列表</a></li>
            <li><a id="newsEditor" href="newsEditorPage.jsp">添加新闻</a> </li>
            <li><a id="gongEditor" href="newsEditorPage.jsp?nid=1">编辑首页</a></li>
            <li><a id="addMatch" href="addMatchPage.jsp">历史战绩</a></li>
            <li><a id="dataUpdate" href="dataUpdatePage.jsp">数据更新</a></li>
        </ul>
    </div>
