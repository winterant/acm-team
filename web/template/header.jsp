<%@ page import="Tools.Paging" %>
<%@ page import="Tools.Changing" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="Beans.User" %>
<%@ page import="Mysql.SQL" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="headContainer">
    <div id="head-nav">
        <div id="head-title" class="oneline">
            <a href="/"><%=homeName%></a>
        </div>

        <div id="head-menu-login">
            <div id="head-menu">
                <ul style="font-size: 1.1em">
                    <li><a id="home" href="/">首页</a></li>
                    <li><a id="news" href="/newsListPage.jsp">新闻</a></li>
                    <%--<li><a id="study" href="/study.jsp">资料</a></li>--%>
                    <li><a id="recent" href="/contestsPage.jsp">竞赛</a></li>
                    <li><a id="rank" href="/rankPage.jsp">排名</a></li>
                    <li><a id="members" href="/membersPage.jsp">团队</a></li>
                    <li><a id="online" class="oneline" href="<%=lduojAddr%>" target="_blank">Online Judge</a></li>
                </ul>

            </div>

            <%
                //头部定义用户userTemp，可供所有页面使用。另外EL表达式可以直接取出session中的user
                User userTemp=(User)session.getAttribute("user");
            %>
            <%--登录模块--%>
            <div id="login-menu">
                <c:choose>
                    <c:when test="${user==null||!user.exist}">
                        <ul id="btnlogin">
                            <li><a href="javascript:overlay('login-back','login-page');$('input[name=userName]').focus();">登录</a></li>
                            <li><a href="/second/registerPage.jsp">注册</a></li>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <button onclick="dropShow('user-dropdown-menu')" class="dropbtn dropbtnUserInfo">
                            <%=userTemp.getString("userName")%>
                            <span class="caret"></span>
                        </button>
                        <ul id="user-dropdown-menu" class="dropdown dropdown-menu">
                            <li><a href="/profilePage.jsp">我的主页</a></li>
                            <li><a href="#">我的消息</a></li>
                            <li><a href="/second/userModifyPage.jsp">修改信息</a></li>
                            <c:set var="power" value="power"></c:set>
                            <c:if test="${user.userMap[power]>0}">
                                <li><a href="/admin/manager.jsp">管理</a></li>
                            </c:if>
                            <li><a href="javascript:void(0)" onclick="logout()">注销</a></li>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>
            <%--login menu end--%>
        </div>

    </div>
    <%--head nav end--%>


</div>
<%--head container end--%>


<%--模态框登录--%>
<div id="login-back" class="modal-overlay" style="display: none;">
    <div id="login-page" class="modal-main">
        <div>
            <font style="font-size: 1.3em">登录<%=homeName%></font>
            <div class="close">
                <a href="javascript:overlay('login-back','login-page')">×</a>
            </div>
        </div>
        <hr>
        <form id="login">

            <div class="login-block">
                <p style="padding-bottom:16px;border-bottom: 1px solid #d4d4d4">
                    <label class="tit">账号</label>
                    <input name="userName" type="text" id="userName" class="txt" placeholder="请输入登录名">
                </p>
                <p>
                    <label class="tit">密码</label>
                    <input name="password" type="password" id="password" class="txt" onkeydown="enterToClick('login-submit')" placeholder="密码">
                </p>
            </div>

            <button id="login-submit" class="btnSubmit" type="button" onclick="login();">登录</button>
            <p style="margin: 0">
                <a style="color: #1e88e5" href="#">忘记密码？</a>
                <a style="color: #1e88e5" href="/second/registerPage.jsp">没有账号？注册一个</a>
            </p>
        </form>
    </div>
</div>

