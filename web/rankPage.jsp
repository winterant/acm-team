<%@ page import="Tools.Paging" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="Tools.UserColor" %>
<%@ page import="Tools.Changing" %>
<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/11/5
  Time: 22:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="template/headTag.jsp"%>
    <title><%=homeName%>-排名</title>
</head>
<body>
    <%@include file="template/header.jsp"%>
    <div class="bigContainer">
        <div class="rank-list">


            <%--页码--%>
            <%
                request.setCharacterEncoding("UTF-8");
                String keyWords=request.getParameter("keyWords");
                String strPage=request.getParameter("nowPage");
                int nowPage= Changing.strToNumber(strPage,1); //检查是否指定页数
                Paging paging=new Paging("users");
                paging.setOrder("rating",1); //按积分降序
                paging.addVague("userName",keyWords);  //模糊查询
                paging.addVague("nickName",keyWords);
                paging.addVague("school",keyWords);
                paging.setSqlWhere("where status>0");

                paging.setPageSize(25);  //自定义每页条数

                List<Map<String,Object>> list=paging.getDataList(nowPage); //获取当前页的内容
                if(keyWords!=null&&keyWords.length()>0)
                    paging.addNextArgs("keyWords",keyWords);  //页面传参,继续模糊查询
                int j=0;
                for(Map i:list){
                    i.put("color",UserColor.getUserColor((Integer) i.get("rating")));
                    i.put("rank",(paging.getNowPage()-1)*paging.getPageSize()+(++j));
                }
                request.setAttribute("users",list);
            %>
            <%@include file="template/vagueSearch.jsp"%>
            <%@include file="template/pagingDiv.jsp"%>

            <div class="userTable">
                <table class="table-list">
                    <tr>
                        <th>名次</th>
                        <th>用户名</th>
                        <th>姓名</th>
                        <th>积分</th>

                        <th><a href="<%=codeforcesAdrr%>">codeforces</a></th>
                        <th><a href="<%=newcoderAddr%>">newcoder</a></th>
                        <th><a href="<%=atcoderAddr%>">atcoder</a></th>
                        <th>博客</th>

                        <th>班级</th>
                        <th>学校</th>
                    </tr>
                    <c:forEach var="item" items="${users}" varStatus="j">
                        <tr>
                            <td>${item.rank}</td>
                            <td>
                                <a class="${item.color}" href="${rootPath}/profilePage.jsp?userName=${item.userName}">
                                    ${item.userName}
                                </a>
                            </td>
                            <td class="${item.color}">${item.nickName}</td>
                            <td class="${item.color}">${item.rating}</td>

                            <td><a class="${item.color}" href="<%=codeforcesAdrr%>/profile/${item.codeforcesid}" target="_blank" title="${item.codeforcesid}">${item.codeforcesRating}</a></td>
                            <td><a class="${item.color}" href="<%=newcoderAddr%>/acm/contest/rating-index?searchUserName=${item.newcoderid}" target="_blank" title="${item.newcoderid}">${item.newcoderRating}</a></td>
                            <td><a class="${item.color}" href="<%=atcoderAddr%>/user/${item.atcoderid}" target="_blank" title="${item.atcoderid}">${item.atcoderRating}</a></td>
                            <td><a class="${item.color}" ${fn:indexOf(item.blog,"http")!=0?"hidden":""} href="${item.blog}" target="_blank" title="${item.blog}">Ta的博客</a></td>

                            <td class="${item.color}">${item.className}</td>
                            <td class="${item.color}">${item.school}</td>
                        </tr>
                    </c:forEach>

                </table>

            </div>

            <%--颜色说明--%>
            <div class="rankBottomInfo">
                <h3>用户颜色与积分说明：</h3>
                <table>
                    <tr>
                        <td>0~<%=UserColor.scoreLine[0]%></td>
                        <td><%=UserColor.scoreColorWords[0]%></td>
                    </tr>
                    <%
                        for(int i=1;i<UserColor.scoreLine.length;i++){
                    %>
                    <tr>
                        <td><%=UserColor.scoreLine[i-1]+1%>~<%=UserColor.scoreLine[i]%></td>
                        <td><%=UserColor.scoreColorWords[i]%></td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td><%=UserColor.scoreLine[UserColor.scoreLine.length-1]+1%>~+∞</td>
                        <td><%=UserColor.scoreColorWords[7]%></td>
                    </tr>
                </table>
            </div>

            <%--积分规则--%>
            <div class="rankBottomInfo">
                <h3>积分规则</h3>
                <table>
                    <tr>
                        <th>来源</th>
                        <th>比率</th>
                    </tr>
                    <tr>
                        <td>codeforces</td>
                        <td>1.0</td>
                    </tr>
                    <tr>
                        <td>newcoder</td>
                        <td>1.0</td>
                    </tr>
                    <tr>
                        <td>atcoder</td>
                        <td>1.0</td>
                    </tr>
                </table>
            </div>

        </div>
    </div>
    <%@include file="template/footer.jsp"%>
<script type="text/javascript">
    document.getElementById('rank').style.color="<%=homeSelectColor%>";
</script>
</body>
</html>
