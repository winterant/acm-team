<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/10/8
  Time: 9:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-注册</title>
    <style type="text/css">
        input{
            width:300px;
            height:30px;
        }
        .bigContainer tr{
            height:35px;
        }
    </style>
</head>
<body>
    <%@include file="/template/header.jsp"%>
    <%
        User user= (User) session.getAttribute("user");
        if(user!=null&&user.isExist()){ //已登录，跳转到主页
            response.sendRedirect(request.getContextPath());
            return;
        }
    %>
    <div class="bigContainer">
        <div class="container">
            <center>
                <h1>欢迎注册<%=homeName%></h1>
                <form id="form-register">
                    <table class="table-input-info">
                        <tr>
                            <td class="td1">*用户名：</td>
                            <td><input type="text" name="userName" maxlength="16" onkeyup="value=value.replace(/[\W]/g,'') " size="16" placeholder="用户登录名，不少于4个英文字符或数字"/></td>
                        </tr>
                        <tr>
                            <td class="td1">*密码：</td>
                            <td><input type="password" name="password1" maxlength="16" size="16" placeholder="不少于4个字符"/></td>
                        </tr>
                        <tr>
                            <td class="td1">*重复密码：</td>
                            <td><input type="password" name="password2" size="16" placeholder="再一次输入你的密码"/></td>
                        </tr>
                        <tr>
                            <td class="td1">姓名：</td>
                            <td><input type="text" name="nickName" size="16"/></td>
                        </tr>
                        <tr>
                            <td class="td1">个性签名：</td>
                            <td><textarea type="text" name="motto" maxlength="30" size="16" placeholder="最多30个字"></textarea></td>
                        </tr>
                        <tr>
                            <td class="td1">班级：</td>
                            <td><input type="text" name="className" size="16" placeholder="请如实填写,如: 计算机1801"/></td>
                        </tr>
                        <tr>
                            <td class="td1">学校：</td>
                            <td><input type="text" name="school" size="16" placeholder="学校全称,如：鲁东大学"/></td>
                        </tr>
                        <tr>
                            <td class="td1">邮箱：</td>
                            <td><input type="text" name="email" size="16" placeholder="如：123@163.com"></td>
                        </tr>
                        <tr>
                            <td class="td1">个人博客主页：</td>
                            <td><input type="text" name="blog" size="16" placeholder="例如:https://blog.csdn.net/hello"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=codeforcesAdrr%>" target="_blank">codeforces</a>用户名：</td>
                            <td><input type="text" name="codeforcesid" size="16"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=newcoderAddr%>" target="_blank">newcoder</a>用户名：</td>
                            <td><input type="text" name="newcoderid" size="16" placeholder="请去牛客竞赛排行榜查看 用户名"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=atcoderAddr%>" target="_blank">atcoder</a>用户名：</td>
                            <td><input type="text" name="atcoderid" size="16"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=vjudgeAddr%>" target="_blank">vjudge</a>用户名：</td>
                            <td><input type="text" name="vjudgeid" size="16"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=upcAddr%>" target="_blank">upc exam</a>用户名：</td>
                            <td><input type="text" name="upcojid" size="16"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=lduojAddr%>" target="_blank">LDUOJ</a>用户名：</td>
                            <td><input type="text" name="lduojid" size="16"/></td>
                        </tr>
                    </table>
                    <button id="btnReg" type="button" onclick="register('form-register')" class="btnSubmit">注册</button>
                </form>
                <p style="color: #898989">*为必填项，建议您完善所有信息</p>
                <p style="color: #898989">注册默认身份为学生，如需教师身份，请联系管理员</p>
            </center>
        </div>

    </div>

    <%@ include file="/template/footer.jsp"%>
</body>
</html>
