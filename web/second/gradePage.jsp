<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="Tools.Checking" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-战绩</title>
</head>
<body>
    <%@include file="../template/header.jsp"%>

    <%
        SimpleDateFormat sdf=new SimpleDateFormat("YYYY-MM-dd");
        request.setAttribute("matchName",matchName);
    %>
    <div class="bigContainer">
        <%--左侧概览区域--%>
        <%@include file="/template/homeLeftPage.jsp"%>

            <%--  竞赛区域  --%>
            <div class="homeContainer">

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
                                    <td valign="top">摘要：</td>
                                    <td><textarea name="mainText" id="" cols="30" rows="10" placeholder="简述一下队伍和奖项吧"></textarea></td>
                                </tr>
                                <tr>
                                    <td>竞赛时间：</td>
                                    <td><input type="text" name="date" value="<%=sdf.format(new Date())%>"></td>
                                </tr>
                                <tr>
                                    <td>金牌数量：</td>
                                    <td><input type="text" name="gold"></td>
                                </tr>
                                <tr>
                                    <td>银牌数量：</td>
                                    <td><input type="text" name="silver"></td>
                                </tr>
                                <tr>
                                    <td>铜牌数量：</td>
                                    <td><input type="text" name="bronze"></td>
                                </tr>
                                <tr>
                                    <td>新闻链接：</td>
                                    <td><input type="text" name="newsUrl" placeholder="填写新闻的网址"></td>
                                </tr>
                            </table>
                        </form>
                        <button id="matchbtn" class="form-control" type="button" onclick="addMatch()">提交</button>
                    </div>
                </div>

                <%--模态框按钮--%>
                <c:if test="${user.userMap.power>0}">
                    <button onmousedown="toAddMatch('matchbtn')" onclick="overlay('match-back','match-main')" class="form-control" type="button" style="float: right;margin-top:0.6%;margin-right: 6%;">添加比赛成绩</button>
                </c:if>

                <%--页码--%>
                <%
                    request.setCharacterEncoding("utf-8");
                    String type=request.getParameter("type");
                    String keyWords=request.getParameter("keyWords");
                    String strPage=request.getParameter("nowPage");
                    int nowPage= Changing.strToNumber(strPage); //检查是否指定页数
                    Paging paging=new Paging("matches");
                    paging.setOrder("date",1);

                    paging.addVague("title",keyWords);  //模糊查询
                    paging.addVague("mainText",keyWords);
                    if(Checking.strIsNumber(type))
                        paging.setSqlWhere("where type="+type);
                    paging.setPageSize(10);
                    List<Map<String,Object>> list=paging.getDataList(nowPage); //获取当前页的内容
                    if(keyWords!=null&&keyWords.length()>0)
                        paging.addNextArgs("keyWords",keyWords);  //页面传参,继续模糊查询
                    request.setAttribute("list",list);
    //                out.print(keyWords);
    //                out.print(paging.getSql());
                %>
                <%@include file="/template/vagueSearch.jsp"%>
                <%@include file="/template/pagingDiv.jsp"%>

                <div class="match-list">
                    <c:forEach var="item" items="${list}" varStatus="j">
                        <hr style="margin: 0">
                        <div id="match${j.index}">
                            <h3 style="margin:8px auto;">
                                <a href="${item.newsUrl}" target="_blank">${item.title}</a>
                                <font style="font-size: 0.8em">
                                    <c:if test="${item.gold>0}">
                                        <font class="bg-gold">金×${item.gold}</font>
                                    </c:if>
                                    <c:if test="${item.silver>0}">
                                        <font class="bg-silver">银×${item.silver}</font>
                                    </c:if>
                                    <c:if test="${item.bronze>0}">
                                        <font class="bg-bronze">铜×${item.bronze}</font>
                                    </c:if>
                                </font>
                            </h3>
                            <p style="margin: 0;width:70%;font-size: 0.9em;color:#505050">
                                <font style="font-weight: bold">摘要：</font>
                                <font>${item.mainText}</font>
                            </p>
                            <p style="margin: 0;font-size: 0.9em;text-align: right">

                                <c:if test="${user!=null&&user.userMap.power>0}">
                                    <a href="javascript:overlay('match-back','match-main');
                                        toUpdateMatch('matchbtn','${item.id}','${item.type}','${item.title}',
                                        '${item.mainText}','${item.date}','${item.gold}','${item.silver}','${item.bronze}')">编辑</a>
                                    <a href="javascript:if(confirm('删除这项比赛记录吗？'))deleteMatch('${item.id}')">删除</a>
                                </c:if>
                                <font color="#ff4a00">${matchName[item.type]}</font>
                                <font>${item.date}</font>
                            </p>
                        </div>
                    </c:forEach>
                    <hr style="margin-top: 0;">
                </div>
                <%--end of mainText--%>

            </div>
            <%--end of homeContainer--%>
    </div>
    <%@include file="../template/footer.jsp"%>
</body>
</html>
