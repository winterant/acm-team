<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/11/22
  Time: 21:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Tools.Paging" %>
<%@ page import="Tools.Changing" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-留言板</title>
</head>
<body>
    <%@include file="/template/header.jsp"%>
    <div class="bigContainer">
        <%--左侧概览区域--%>
        <%@include file="/template/homeLeftPage.jsp"%>

        <%--  留言区域  --%>
        <div class="homeContainer">

            <h1 align="center">留言板</h1>
            <hr>

            <%@include file="/template/vagueSearch.jsp"%>
            <%--页码--%>
            <%
                request.setCharacterEncoding("UTF-8");
                String keyWords=request.getParameter("keyWords");
                String strPage=request.getParameter("nowPage");
                int nowPage= Changing.strToNumber(strPage,1); //检查是否指定页数
                Paging paging=new Paging("speaks");
                paging.setOrder("publishTime",1); //按积分降序
                paging.addVague("author",keyWords);  //模糊查询
                paging.addVague("mainText",keyWords);
                paging.setPageSize(20);
                List<Map<String,Object>> list=paging.getDataList(nowPage); //获取当前页的内容
                paging.addNextArgs("keyWords",keyWords);  //页面传参,继续模糊查询
            %>
            <%@include file="/template/pagingDiv.jsp"%>

            <div class="mainText" style="width: 90%;margin:10px auto;">
                <%
                    int sj=0;
                    for(Map<String,Object> i:list){
                %>
                <hr style="margin: 0">
                <div id="speaks<%=++sj%>" style="overflow: hidden;">
                    <p style="margin:8px auto;">
                        <%
                            if(1==(int)i.get("isUser")){
                        %>
                            <a href="/profilePage.jsp?userName=<%=i.get("author")%>"><%=i.get("author")%></a>
                        <%}else{%>
                        <%=i.get("author")%>
                        <%}%>

                        说：<%=i.get("mainText")%>
                    </p>
                    <p style="margin: 0;float:right;font-size: 0.8em">
                        <%
                            if(userTemp!=null&&userTemp.getInt("power")>0){
                        %>
                            <a href="javascript:deleteSpeaks('<%=i.get("id")%>')">删除</a>
                        <%
                            }
                        %>
                        <%=i.get("publishTime").toString().substring(0,19)%>
                    </p>
                </div>
                <%
                    }
                %>
                <hr style="margin-top: 0;">
            </div>
            <%--end of mainText--%>

        </div>
        <%--end of homeContainer--%>

    </div>
    <%@include file="/template/footer.jsp"%>
</body>
</html>