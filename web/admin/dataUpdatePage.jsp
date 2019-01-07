
<%--
  Created by IntelliJ IDEA.
  User.java: winter
  Date: 2018/10/22
  Time: 20:31
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-管理员-用户列表</title>
</head>
<body>
<%
    User user= (User) session.getAttribute("user");
    if(user==null||!user.isExist()||user.getInt("power")==0){
        response.sendRedirect(request.getContextPath()); //不是管理员将被送回主页
        return;
    }
%>
<%@include file="/template/header.jsp"%>
<div class="bigContainer">
    <%@include file="managerLeft.jsp"%>


    <div class="adminRightArea">
        <p>请不要短时间内频繁使用此功能，以免爬虫被封锁</p>
        <table class="">
            <tr>
                <td><button class="form-control" type="button" onclick="updateCodeforcesRating()">积分更新·codeforces</button></td>
                <td>更新codeforces分数 </td>
            </tr>
            <tr>
                <td><button class="form-control" type="button" onclick="updateNewcoderRating()">积分更新·牛客</button></td>
                <td>更新牛客分数 </td>
            </tr>
            <tr>
                <td><button class="form-control" type="button" onclick="updateAtcoderRating()">积分更新·atcoder</button></td>
                <td>更新atcoder的积分</td>
            </tr>
            <tr>
                <td><button class="form-control" type="button" onclick="updateUpcContest()">竞赛更新·UPC</button> </td>
                <td>更新upc的竞赛</td>
            </tr>
        </table>
    </div>
</div>
<%@include file="/template/footer.jsp"%>
<script type="text/javascript">

    document.getElementById('dataUpdate').style.backgroundColor="#b3b3b3";
    document.getElementById('dataUpdate').style.color="#000000";

    function updateCodeforcesRating() {
        alert('已执行后台更新爬虫，请等待约5分钟再查看分数')
        $.ajax({
            type:"POST",
            url:rootPath+"/ServletReptile",
            dataType:"json",
            data:{type:"updateCodeforcesRating"},
            success:function (result) {
                console.log('更新成功');
            },
            error:function (err) {
                console.log("系统错误-updateCodeforcesRating");
            }
        })
    }
    function updateNewcoderRating() {
        alert('已执行后台更新爬虫，请等待约5分钟再查看分数')
        $.ajax({
            type:"POST",
            url:rootPath+"/ServletReptile",
            dataType:"json",
            data:{type:"updateNewcoderRating"},
            success:function (result) {
                console.log('更新成功');
            },
            error:function (err) {
                console.log("系统错误-updateNewcoderRating");
            }
        })
    }
    function updateAtcoderRating() {
        alert('已执行后台更新爬虫，请等待约5分钟再查看分数')
        $.ajax({
            type:"POST",
            url:rootPath+"/ServletReptile",
            dataType:'json',
            data:{type:"updateAtcoderRating"},
            success:function (ret) {
                console.log('更新成功');
            },
            error:function (err) {
                console.log("系统错误-updateAtcoderRating");
            }
        })
    }
    function updateUpcContest() {
        $.ajax({
            type:"POST",
            url:rootPath+"/ServletReptile",
            dataType:'json',
            data:{type:"updateUpcContest"},
            success:function (ret) {
                if(ret.result){
                    alert(ret.msg);
                }else{
                    alert(ret.msg);
                }
            },
            error:function (err) {
                console.log("系统错误-updateUpcContest");
            }
        })
    }

</script>
</body>
</html>