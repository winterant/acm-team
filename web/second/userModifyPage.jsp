
<%--
  Created by IntelliJ IDEA.
  User.java: winter
  Date: 2018/10/30
  Time: 11:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Tools.UserColor" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-修改个人信息</title>
</head>
<body>
<%@ include file="/template/header.jsp"%>
    <div class="bigContainer">
        <center class="userProfile">
            <h2>修改个人信息</h2>
            <%
                User user= (User) session.getAttribute("user");
                if (user == null||!user.isExist()) {
                    if(user!=null&&!user.isExist())session.removeAttribute("user"); //无效用户
                    response.sendRedirect("/");
                }else{
                    int alow= user.getInt("alowModify");

                    String userName=request.getParameter("userName");
                    User aimUser=user;
                    if(new User(userName).isExist())
                    {
                        aimUser=new User(userName);
                        if(user.getInt("power")>aimUser.getInt("power"))
                            alow=2; //强制允许修改
                    }
            %>

            <form id="user-modify-form">
                <table class="table-input-info">
                    <tr>
                        <td class="td1">
                            用户名：
                            <input type="hidden" name="userName" value="<%=aimUser.getString("userName")%>">
                        </td>
                        <td class="td2"><font class="<%=UserColor.getUserColor(aimUser)%>"> <%=aimUser.getString("userName")%> </font>
                        </td>
                    </tr>
                    <tr class="<%=alow==2?"hide":""%>">
                        <td class="td1">*密码：</td>
                        <td><input type="password" name="password" size="16" placeholder="你必须输入密码验证身份"/></td>
                    </tr>
                    <tr>
                        <td class="td1">新密码：</td>
                        <td><input type="password" name="password1" maxlength="16" size="16" placeholder="如果你不修改密码，此项不要填,密码不少于4个字符"/></td>
                    </tr>
                    <tr>
                        <td class="td1">确认新密码：</td>
                        <td><input type="password" name="password2" maxlength="16" size="16" placeholder="同上"/></td>
                    </tr>
                    <tr>
                        <td class="td1">个性签名：</td>
                        <td>
                            <textarea style="font-size: 16px" maxlength="30" name="motto"><%=aimUser.getString("motto")%></textarea>
                        </td>
                    </tr>
                    <%
                        if(alow>0) //允许修改
                        {
                    %>
                        <tr>
                            <td class="td1">姓名：</td>
                            <td><input type="text" name="nickName" value="<%=aimUser.getString("nickName")%>" size="16"/></td>
                        </tr>
                        <tr>
                            <td class="td1">班级：</td>
                            <td><input type="text" name="className" size="16" value="<%=aimUser.getString("className")%>"/></td>
                        </tr>
                        <tr>
                            <td class="td1">学校：</td>
                            <td><input type="text" name="school" size="16" value="<%=aimUser.getString("school")%>"/></td>
                        </tr>
                        <tr>
                            <td class="td1">邮箱：</td>
                            <td><input type="text" name="email" size="16" placeholder="如：123@163.com"></td>
                        </tr>
                        <tr>
                            <td class="td1">博客地址：</td>
                            <td><input type="text" name="blog" size="16" value="<%=aimUser.getString("blog")%>" placeholder="例如:https://blog.csdn.net/hello"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=codeforcesAdrr%>" target="_blank">codeforces</a>用户名：</td>
                            <td><input type="text" name="codeforcesid" size="16" value="<%=aimUser.getString("codeforcesid")%>"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=newcoderAddr%>" target="_blank">newcoder</a>用户名：</td>
                            <td><input type="text" name="newcoderid" size="16" value="<%=aimUser.getString("newcoderid")%>" placeholder="请去牛客竞赛排行榜查看 用户名"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=atcoderAddr%>" target="_blank">atcoder</a>用户名：</td>
                            <td><input type="text" name="atcoderid" size="16" value="<%=aimUser.getString("atcoderid")%>"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=vjudgeAddr%>" target="_blank">vjudge</a>用户名：</td>
                            <td><input type="text" name="vjudgeid" size="16" value="<%=aimUser.getString("vjudgeid")%>"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=upcAddr%>" target="_blank">upc exam</a>用户名：</td>
                            <td><input type="text" name="upcojid" size="16" value="<%=aimUser.getString("upcojid")%>"/></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=lduojAddr%>" target="_blank">LDUOJ</a>用户名：</td>
                            <td><input type="text" name="lduojid" size="16" value="<%=aimUser.getString("lduojid")%>"/></td>
                        </tr>
                    <%
                        }else{
                    %>
                        <tr>
                            <td></td>
                            <td>
                                <p style="color: #7f7f7f">您的信息已被锁定，如需修改以下信息请联系管理员或指导教师。</p>
                            </td>
                        </tr>

                        <tr>
                            <td class="td1">姓名：</td>
                            <td><%=aimUser.getString("nickName")%></td>
                        </tr>
                        <tr>
                            <td class="td1">班级：</td>
                            <td><%=aimUser.getString("className")%></td>
                        </tr>
                        <tr>
                            <td class="td1">学校：</td>
                            <td><%=aimUser.getString("school")%></td>
                        </tr>
                        <tr>
                            <td class="td1">邮箱：</td>
                            <td><%=aimUser.getString("email")%></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=codeforcesAdrr%>" target="_blank">codeforces</a>用户名：</td>
                            <td><%=aimUser.getString("codeforcesid")%></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=newcoderAddr%>" target="_blank">newcoder</a>用户名：</td>
                            <td><%=aimUser.getString("newcoderid")%></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=atcoderAddr%>" target="_blank">atcoder</a>用户名：</td>
                            <td><%=aimUser.getString("atcoderid")%></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=vjudgeAddr%>" target="_blank">vjudge</a>用户名：</td>
                            <td><%=aimUser.getString("vjudgeid")%></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=upcAddr%>" target="_blank">upc exam</a>用户名：</td>
                            <td><%=aimUser.getString("upcojid")%></td>
                        </tr>
                        <tr>
                            <td class="td1"><a href="<%=lduojAddr%>" target="_blank">LDUOJ</a>用户名：</td>
                            <td><%=aimUser.getString("lduojid")%></td>
                        </tr>
                        <tr>
                            <td class="td1">博客地址：</td>
                            <td><%=aimUser.getString("blog")%></td>
                        </tr>
                    <%
                        }
                    %>
                </table>
            </form>

            <p style="color: #686d7b">注意！此修改不可撤销，请谨慎操作</p>
            <button type="button" class="btnSubmit" onclick="modify('user-modify-form')">确认修改</button>
            <%
                }
            %>
        </center>
    </div>
    <%@ include file="/template/footer.jsp"%>
<script type="text/javascript">
    $('input[name=password]').focus();
</script>
</body>
</html>
