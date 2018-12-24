<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/11/28
  Time: 22:34
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Tools.Paging" %>

<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-新闻</title>
</head>
<body>
    <%@include file="/template/header.jsp"%>
    <div class="bigContainer">
        <%--左侧概览区域--%>
        <%@include file="/template/homeLeftPage.jsp"%>

        <%--  新闻区域  --%>
        <div class="homeContainer homeRightMod" >
            <%--页码--%>
            <%
                request.setCharacterEncoding("UTF-8");
                String keyWords=request.getParameter("keyWords");
                String strPage=request.getParameter("nowPage");
                int nowPage=Changing.strToNumber(strPage,1); //检查是否指定页数
                Paging paging=new Paging("news");
                paging.setOrder("publishTime",1); //按时间
                paging.addVague("title",keyWords);
                paging.addVague("author",keyWords);  //模糊查询
                paging.addVague("mainText",keyWords);
                paging.setPageSize(20);
                paging.setSqlWhere("where id>1 and status>0");
                paging.addNextArgs("keyWords",keyWords);  //页面传参,继续模糊查询
                request.setAttribute("list",paging.getDataList(nowPage)); //获取当前页的内容

            %>
            <%@include file="/template/vagueSearch.jsp"%>
            <%@include file="/template/pagingDiv.jsp"%>

            <div class="mainText">
                <hr style="margin: 0">
                <c:forEach var="item" items="${list}" varStatus="j">
                    <li style="overflow: auto;list-style: none;position:relative;">
                        <p class="newsTitle">
                            <a href="${rootPath}/second/newsPage.jsp?nid=${item["id"]}" >${item["title"]}</a>
                            <c:set var="nowPage" value="<%=paging.getNowPage()%>"></c:set>
                            <c:if test="${j.index<5 and nowPage==1}">
                                <img src="${rootPath}/images/smallPic/newsnew.gif" alt="news">
                            </c:if>
                        </p>
                        <p class="newsInfo">
                            作者:
                            <a href="${rootPath}/profilePage.jsp?userName=${item["author"]}" >${item["author"]}</a>&nbsp;
                            <c:set var="power" value="power"></c:set>
                            <c:if test="${user.userMap[power]>0}">
                                <a href="${rootPath}/admin/newsEditorPage.jsp?nid=${item["id"]}" >编辑</a>&nbsp;
                                <a href="javascript:if(confirm('确定删除该新闻吗?'))newsDelete('${item["id"]}')">删除</a>
                            </c:if>
                            ${fn:substring(item["publishTime"],0,10)}
                        </p>
                    </li>

                    <hr style="margin: 0;border:0.5px dotted #6b6b6b">
                </c:forEach>
                <h2 style="text-align: center"><%=homeName%></h2>
                <hr>
            </div>
            <%--end of mainText--%>

        </div>
        <%--end of homeContainer--%>

    </div>
    <%@include file="/template/footer.jsp"%>
<script type="text/javascript">
    document.getElementById('news').style.color="<%=homeSelectColor%>";
</script>
</body>
</html>