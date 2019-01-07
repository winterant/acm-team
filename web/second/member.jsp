<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/12/20
  Time: 13:23
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="Mysql.SQL" %>
<%@ page import="java.util.Map" %>
<%@ page import="Tools.FilePath" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-团队成员主页</title>
</head>
<body>
    <%@include file="/template/header.jsp"%>

    <%
        String midStr=request.getParameter("mid");
        SQL mysql=new SQL();
        String sql="select * from members where id="+midStr;
        if(userTemp==null||userTemp.getInt("power")==0){
            sql+=" and status>0";
        }
        Map member=mysql.queryFirst(sql);
        if(member==null||(member).isEmpty()){
            out.print("<script>alert('成员不存在或未审核');</script>");
            response.sendRedirect(request.getContextPath());
            return;
        }
        member.put("photoPath", FilePath.getFilePath((Integer) member.get("photo"),request.getContextPath()+"/images/smallPic/defaultphoto.jpg"));
        request.setAttribute("member",member);
    %>

    <div class="bigContainer">
        <div class="userProfile">
            <%--个人信息表--%>
            <div id="userInfo">
                <div>
                    <font size="15em">${member.name}</font>
                    <font>(${["退役队员","现役","教师"][member.identity]})</font>
                </div>
                <c:if test="${member.identity<2}">
                    <div style="padding:5px;">
                        <font size="3em">${member.grade}级&nbsp;${member.major}</font>
                    </div>
                </c:if>
                <hr>
                <div class="someInfo">
                    <font>现今: <font style="font-size:1.2em;">${member.work}</font></font>
                </div>

                <div class="someInfo">
                    <font>blog: <a href="${fn:indexOf(member.blog,'http')!=-1?member.blog:'javascript:void(0)'}" target="_blank">${member.blog}</a></font>
                </div>
                <div class="someInfo">
                    <font>email: ${member.email}</font>
                </div>
                <hr>
                <div class="someInfo">
                    ${member.introduce}
                </div>
            </div>
            <%--end of userInfo--%>

            <%--begin of user photo--%>
            <div id="photo-div">
                <div id="photo">
                    <img width="100%" src="${member.photoPath}" alt="图片加载失败">
                </div>
            </div>
            <%--end of user photo--%>

        </div>
        <%--end of member--%>

    </div>

    <%@include file="/template/footer.jsp"%>

<script type="text/javascript">
    document.getElementById('members').style.color="<%=homeSelectColor%>";

</script>
</body>
</html>
