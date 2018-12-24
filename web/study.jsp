<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/12/9
  Time: 10:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="template/headTag.jsp"%>
    <title><%=homeName%>-资料</title>
</head>
<body>
    <%@include file="template/header.jsp"%>
    <%
        if(userTemp==null||!userTemp.isExist()){
            %>
            <script>
                alert('请先登录！');
                window.location="/";
            </script>
            <%
            return;
        }else if(userTemp.getInt("status")<1){
            %>
            <script>
                alert('您的权限不足');
                window.location="/";
            </script>
            <%
            return;
        }
    %>
    <div class="bigContainer">
        <div class="item-study">
            1.比赛文件
            <div>
                <div>
                    <input id="myfile" type="file" name="filePic">
                    <button type="button" onclick="uploadFiles('contest','myfile')">OK</button>
                </div>
            </div>
        </div>
        <div class="item-study">2.学习资料</div>
        <div class="item-study">3.软件分享(请将分享的软件打包后上传)</div>
        <div class="item-study">4.算法教学视频</div>
        <div class="item-study">5.算法模板分享</div>
        <div class="item-study">6.友好社区</div>
    </div>
    <%@include file="template/footer.jsp"%>
<script type="text/javascript">
    document.getElementById('study').style.color="<%=homeSelectColor%>";
    $('.item-study').each(function () {
        $(this).fadeIn(1000);
    })

</script>
</body>
</html>
