
<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/12/17
  Time: 13:31
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="Tools.Changing" %>
<%@ page import="Tools.Paging" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-成员</title>
</head>
<body>
    <%@ include file="/template/header.jsp"%>

    <div class="bigContainer">

        <div class="members-div">

            <%--页码--%>
            <%
                request.setCharacterEncoding("UTF-8");
                String keyWords=request.getParameter("keyWords");
                String strPage=request.getParameter("nowPage");
                int nowPage= Changing.strToNumber(strPage,1); //检查是否指定页数
                Paging paging=new Paging("members");
                paging.setOrder("identity",1);
                paging.setOrder("grade",1);
                paging.addVague("name",keyWords);  //模糊查询
                paging.addVague("grade",keyWords);
                paging.addVague("major",keyWords);
                paging.addVague("work",keyWords);
                paging.setSqlWhere("where status>0");

                paging.setPageSize(50);  //自定义每页条数

                List<Map<String,Object>> list=paging.getDataList(nowPage); //获取当前页的内容
                if(keyWords!=null&&keyWords.length()>0)
                    paging.addNextArgs("keyWords",keyWords);  //页面传参,继续模糊查询
                request.setAttribute("members",list);

                int[] count={0,0,0};
                for(Map<String,Object> i:list){
                    count[(int)i.get("identity")]++;
                }
                request.setAttribute("count",count);
            %>
            <%@include file="/template/vagueSearch.jsp"%>
            <%@include file="/template/pagingDiv.jsp"%>

            <div class="members-list">

                <c:if test="${count[2]>0}">
                    <h4 style="margin-bottom: 0">教师</h4>
                    <hr style="margin: 0">
                    <table class="table-members">
                        <c:forEach var="item" items="${members}" varStatus="j">
                            <c:if test="${item.identity==2}">
                                <tr id="member${item.id}">
                                    <td><a href="/second/member.jsp?mid=${item.id}">${item.name}</a></td>
                                    <td>
                                        <c:if test="${fn:indexOf(item.blog, 'http')!=-1}">
                                            <a href="${item.blog}" target="_blank">Ta的博客</a>
                                        </c:if>
                                    </td>
                                    <td>${item.work}</td>
                                    <td>${item.email}</td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </table>
                </c:if>

                <c:if test="${count[1]>0}">
                    <h4 style="margin-bottom: 0">现役队员</h4>
                    <hr style="margin: 0">
                    <table class="table-members">
                        <c:forEach var="item" items="${members}" varStatus="j">
                            <c:if test="${item.identity==1}">
                                <tr id="member${item.id}">
                                    <td><a href="/second/member.jsp?mid=${item.id}">${item.name}</a></td>
                                    <td>${item.grade}级</td>
                                    <td>${item.major}</td>
                                    <td>
                                        <c:if test="${fn:indexOf(item.blog, 'http')!=-1}">
                                            <a href="${item.blog}" target="_blank">Ta的博客</a>
                                        </c:if>
                                    </td>
                                    <td>${item.work}</td>
                                    <td>${item.email}</td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </table>
                </c:if>

                <c:if test="${count[0]>0}">
                    <h4 style="margin-bottom: 0">退役队员</h4>
                    <hr style="margin: 0">
                    <table class="table-members">
                        <c:forEach var="item" items="${members}" varStatus="j">
                            <c:if test="${item.identity==0}">
                                <tr id="member${item.id}">
                                    <td><a href="/second/member.jsp?mid=${item.id}">${item.name}</a></td>
                                    <td>${item.grade}级</td>
                                    <td>${item.major}</td>
                                    <td>
                                        <c:if test="${fn:indexOf(item.blog, 'http')!=-1}">
                                            <a href="${item.blog}" target="_blank">Ta的博客</a>
                                        </c:if>
                                    </td>
                                    <td>${item.work}</td>
                                    <td>${item.email}</td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </table>
                </c:if>

            </div>

            <div style="margin:0 auto;width: 80%;">
                <p>队员填报信息请点击<a href="/second/newMember.jsp" style="font-size: 1.5em">这里</a> ！</p>
            </div>

        </div>



    </div>
    <%@ include file="/template/footer.jsp"%>
<script type="text/javascript">
    document.getElementById('members').style.color="<%=homeSelectColor%>";

</script>
</body>
</html>
