<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/12/27
  Time: 16:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
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
        response.sendRedirect(request.getContextPath()); //不是管理员将被送回主页
    }
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    request.setAttribute("matchName",matchName);
%>
<%@include file="/template/header.jsp"%>
<div class="bigContainer">
    <div class="main-container">
        <%@include file="managerLeft.jsp"%>
        <%-- 新闻列表 --%>
        <div class="adminRightArea">
            <h3>战绩列表</h3>
            <%--模态框添加竞赛--%>
            <div id="match-back" class="modal-overlay">
                <div id="match-main" class="modal-main">
                    <div>
                        <font style="font-size: 1.3em">添加赛事信息</font>
                        <div class="close">
                            <a href="javascript:overlay('match-back','match-main')">×</a>
                        </div>
                    </div>
                    <hr>
                    <form id="add-match">
                        <table class="table-input-info" align="center">
                            <tr>
                                <td>竞赛类别：</td>
                                <td>
                                    <select name="type" id="addModSelect" style="width: 100%;height:30px;">
                                        <c:forEach var="item" items="${matchName}" varStatus="j">
                                            <option value="${j.index}">${item}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>竞赛标题：</td>
                                <td><input type="text" name="title"></td>
                            </tr>
                            <tr>
                                <td>参赛时间：</td>
                                <td><input type="text" name="date" value="<%=sdf.format(new Date())%>"></td>
                            </tr>
                            <tr>
                                <td>一等奖数量：</td>
                                <td><input type="text" name="gold"></td>
                            </tr>
                            <tr>
                                <td>二等奖数量：</td>
                                <td><input type="text" name="silver"></td>
                            </tr>
                            <tr>
                                <td>三等奖数量：</td>
                                <td><input type="text" name="bronze"></td>
                            </tr>
                            <tr>
                                <td>优胜奖数量：</td>
                                <td><input type="text" name="fine"></td>
                            </tr>
                            <tr>
                                <td>新闻编号：</td>
                                <td><input type="text" name="newsid" placeholder="填写新闻的编号"></td>
                            </tr>
                        </table>
                    </form>
                    <button id="matchbtn" class="form-control" type="button" onclick="addMatch()">提交</button>
                </div>
            </div>

            <%--模态框按钮--%>
            <button onmousedown="toAddMatch('matchbtn')"
                    onclick="overlay('match-back','match-main')"
                    class="form-control" >添加比赛成绩</button>

            <%
                request.setCharacterEncoding("UTF-8");
                String keyWords=request.getParameter("keyWords");
                String nowPageStr=request.getParameter("nowPage");
                int nowPage= Changing.strToNumber(nowPageStr,1);
                Paging paging=new Paging("matches");
                paging.setOrder("date",1);
                paging.addVague("title",keyWords);
                paging.addVague("date",keyWords);
                paging.addVague("id",keyWords);
                paging.setPageSize(30);
                List<Map<String,Object>> list=paging.getDataList(nowPage); //获取当前页的内容
                paging.addNextArgs("keyWords",keyWords);
                request.setAttribute("matches",list);
            %>
            <%@include file="../template/vagueSearch.jsp"%>
            <%@include file="../template/pagingDiv.jsp"%>

            <table class="table-list">
                <tr>
                    <th>编号</th>
                    <th>标题</th>
                    <th>参赛时间</th>
                    <th>操作</th>
                </tr>
                <c:forEach var="item" items="${matches}" varStatus="j">
                    <tr id="match${j.index}">
                        <td>${item.id}</td>
                        <td><a href="${rootPath}/second/newsPage.jsp?nid=${item.newsid}" target="_blank">${item.title}</a></td>

                        <td>${item.date}</td>
                        <td>
                            [<a href="javascript:overlay('match-back','match-main');
                                    toUpdateMatch('matchbtn','${item.id}','${item.type}','${item.title}',
                                    '${item.date}','${item.gold}','${item.silver}','${item.bronze}','${item.fine}','${item.newsid}')">编辑</a>]
                            [<a href="javascript:if(confirm('删除这项比赛记录吗？'))deleteMatch('${item.id}')">删除</a>]
                        </td>
                    </tr>
                </c:forEach>
                <hr style="margin-top: 0;">
            </table>
        </div>
    </div>
</div>
<%@include file="/template/footer.jsp"%>
<script type="text/javascript">

    document.getElementById('addMatch').style.backgroundColor="#b3b3b3";
    document.getElementById('addMatch').style.color="#000000";

</script>
</body>

</html>