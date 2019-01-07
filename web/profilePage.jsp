<%@ page import="Tools.UserColor" %>
<%@ page import="Mysql.SQL" %>
<%@ page import="java.util.Map" %>
<%@ page import="Tools.FilePath" %>
<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/11/7
  Time: 17:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="template/headTag.jsp"%>
    <title><%=homeName%>-个人主页</title>
</head>
<body>
    <%@ include file="template/header.jsp"%>
    <div class="bigContainer">
        <%
            String userName=request.getParameter("userName");

            User userInfo=(userName==null||userName.length()<1)?userTemp:new User(userName);
            if(userInfo==null||!userInfo.isExist()){
                response.sendRedirect(request.getContextPath());
                return;
            }
            request.setAttribute("userInfo",userInfo);
        %>

        <div class="userProfile">
            <%--个人信息表--%>
            <div id="userInfo">
                <div class="<%=UserColor.getUserColor(userInfo)%>">
                    <font size="15em">${userInfo.userMap.userName}</font>
                </div>
                <div style="padding:5px;">
                    <font size="2em"><%=userInfo.getString("school")%> <%=userInfo.getString("className")%> <%=userInfo.getString("nickName")%></font>
                </div>
                <div class="someInfo">
                    Ta说：<font face="楷体"><%=userInfo.getString("motto")%></font>
                </div>
                <hr>
                <div class="someInfo <%=UserColor.getUserColor(userInfo)%>">
                    <font>Personal rating: <font style="font-size:1.3em"><%=userInfo.getInt("rating")%></font></font>
                </div>
                <div class="someInfo">
                    <img src="${rootPath}/images/smallPic/codeforces.jpg" height="15" alt="codeforces">
                    <font>codeforces: <a href="<%=codeforcesAdrr%>/profile/<%=userInfo.getString("codeforcesid")%>" target="_blank"><%=userInfo.getString("codeforcesid")%></a></font>
                    <font>&nbsp;(rating: <%=userInfo.getInt("codeforcesRating")%>)</font>
                </div>
                <div class="someInfo">
                    <img src="${rootPath}/images/smallPic/newcoder.jpg" height="15" alt="牛客">
                    <font>newcoder: <a href="<%=newcoderAddr%>/acm/contest/rating-index?searchUserName=<%=userInfo.getString("newcoderid")%>" target="_blank"><%=userInfo.getString("newcoderid")%></a></font>
                    <font>&nbsp;(rating: <%=userInfo.getInt("newcoderRating")%>)</font>
                </div>
                <div class="someInfo">
                    <img src="${rootPath}/images/smallPic/atcoder.jpg" height="15" alt="AtCoder">
                    <font>atcoder: <a href="<%=atcoderAddr%>/user/<%=userInfo.getString("atcoderid")%>" target="_blank"><%=userInfo.getString("atcoderid")%></a></font>
                    <font>&nbsp;(rating: <%=userInfo.getInt("atcoderRating")%>)</font>
                </div>
                <div class="someInfo">
                    <font>vjudge: <a href="<%=vjudgeAddr%>/user/<%=userInfo.getString("vjudgeid")%>" target="_blank"><%=userInfo.getString("vjudgeid")%></a></font>
                </div>
                <div class="someInfo">
                    <font>upc exam: <a href="<%=upcAddr%>/userinfo.php?user=<%=userInfo.getString("upcojid")%>" target="_blank"><%=userInfo.getString("upcojid")%></a></font>
                </div>
                <div class="someInfo">
                    <font>LDUOJ: <a href="<%=lduojAddr%>/userinfo.php?user=<%=userInfo.getString("lduojid")%>" target="_blank"><%=userInfo.getString("lduojid")%></a></font>
                </div>
                <div class="someInfo <%=userInfo.getString("blog").length()<"http://".length()?"hide":""%>">
                    <font>blog: <a href="<%=userInfo.getString("blog")%>" target="_blank"><%=userInfo.getString("blog")%></a></font>
                </div>
                <div class="someInfo <%=userInfo.getString("email").indexOf("@")==-1?"hide":""%>">
                    <font>email: <%=userInfo.getString("email")%></font>
                </div>
            </div>
            <%--end of userInfo--%>

            <%--begin of user photo--%>
            <div id="photo-div">
                <div id="photo">
                    <img id="userPhoto" width="100%" src="<%=FilePath.getPhotoPath(userInfo.getString("userName"))%>" alt="<%=userInfo.getString("userName")%>">
                </div>
                <c:if test="${userInfo.userMap.id==user.userMap.id}">
                    <div style="width: 60%;text-align: center;margin: 2% auto;">
                        <input id="myphoto" type="file" name="pic" onchange="uploadFiles('myphoto','photo')" hidden>
                        <button type="button" onclick="$('#myphoto').click();">更换</button>
                    </div>
                </c:if>
            </div>
            <%--end of user photo--%>

        </div>
        <%--end of userProfile--%>

    </div>
    <%@ include file="/template/footer.jsp"%>
<script type="text/javascript">
    document.getElementById('profile').style.color="<%=homeSelectColor%>";
</script>
</body>
</html>
