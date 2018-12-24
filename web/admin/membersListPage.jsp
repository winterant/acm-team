<%@ page import="Tools.Changing" %>
<%@ page import="Tools.Paging" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>

<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/12/17
  Time: 16:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-管理员-成员列表</title>
</head>
<body>
<%
    User user= (User) session.getAttribute("user");
    if(user==null||!user.isExist()||user.getInt("power")==0){
        response.sendRedirect("/"); //不是管理员将被送回主页
        return;
    }
%>
<%@include file="/template/header.jsp"%>
<div class="bigContainer">
    <%@include file="managerLeft.jsp"%>

    <%-- 用户列表 --%>
    <div class="adminRightArea">


        <%--页码--%>
        <%
            request.setCharacterEncoding("UTF-8");
            String status=request.getParameter("status");
            String identity=request.getParameter("identity");
            String keyWords=request.getParameter("keyWords");
            String strPage=request.getParameter("nowPage");
            int nowPage= Changing.strToNumber(strPage,1); //检查是否指定页数
            Paging paging=new Paging("members");
            paging.setOrder("id",1); //id升序
            paging.addVague("name",keyWords);  //模糊查询
            paging.addVague("grade",keyWords);
            paging.addVague("major",keyWords);
            paging.addVague("work",keyWords);
            if(Changing.strToNumber(status,-1)>=0){
                paging.addExact("status",status);
            }
            if(Changing.strToNumber(identity,-1)>=0){
                paging.addExact("identity",identity);
            }

            paging.setPageSize(30);
            List<Map<String,Object>> list=paging.getDataList(nowPage); //获取当前页的内容
            paging.addNextArgs("keyWords",keyWords);  //页面传参,继续模糊查询
            paging.addNextArgs("status",status);
            paging.addNextArgs("identity",identity);
            request.setAttribute("members",list);
//            out.print(paging.getSql());
        %>

        <div class="search">
            <form method="get" action="<%=request.getServletPath()%>">
                <select id="statusSelect" name="status" class="selectStyle">
                    <option value="0">待审核</option>
                    <option value="1">已通过</option>
                </select>

                <select id="identitySelect" name="identity" class="selectStyle">
                    <option value="-1">所有</option>
                    <option value="0">退役队员</option>
                    <option value="1">现役队员</option>
                    <option value="2">教师</option>
                </select>
                <input class="form-control-input" type="text" name="keyWords" placeholder="输入关键字查找">
                <button class="form-control" type="submit">查找</button>
            </form>
        </div>
        <%@include file="/template/pagingDiv.jsp"%>

        <table class="table-list">
            <tr>
                <th>编号</th>
                <th>姓名</th>
                <th>年级</th>
                <th>专业</th>
                <th>身份</th>
                <th>审核</th>
                <th>操作</th>
            </tr>
            <c:forEach var="item" items="${members}" varStatus="j">
                <tr id="memberTr${j.index}">
                    <td>${item.id}</td>
                    <td>${item.name}</td>
                    <td>${item.grade}</td>
                    <td>${item.major}</td>
                    <td>${['*退役','@现役','教师'].get(item.identity)}</td>
                    <td>

                        [<a href="javascript:memberStatus('${item.id}')" title="点击更改">${['待审核','已通过'].get(item.status)}</a>]
                    </td>
                    <td align="center">
                        [<a class="oneline" href="/second/member.jsp?mid=${item.id}">详情</a>]
                        [<a class="oneline" href="/second/newMember.jsp?mid=${item.id}">编辑</a>]
                        [<a class="oneline" href="javascript:if(confirm('确定删除该条记录吗?'))memberDelete(${item.id})">删除</a>]
                    </td>
                </tr>
            </c:forEach>

        </table>
    </div>
</div>
<%@include file="/template/footer.jsp"%>
<script type="text/javascript">

    document.getElementById('memberList').style.backgroundColor="#b3b3b3";
    document.getElementById('memberList').style.color="#000000";

    selectOption('statusSelect',<%=status%>);
    selectOption('identitySelect',<%=identity%>);

    function memberStatus(mid) {
        $.ajax({
            type:"POST",
            url:"/ServletMember",
            dataType:"json",
            data:{
                mid:mid,
                type:"changeStatus"
            },
            success:function (ret) {
                if(ret["result"]){
                    window.location.reload();
                }else{
                    alert(ret["msg"]);
                }
            },
            error:function (err) {
                alert('系统错误-changeStatus');
            }
        })
    }
    
    function memberDelete(mid) {
        $.ajax({
            type:"POST",
            url:"/ServletMember",
            dataType:"json",
            data:{
                mid:mid,
                type:"delete"
            },
            success:function (ret) {
                if(ret["result"]){
                    window.location.reload();
                }else{
                    alert(ret["msg"]);
                }
            },
            error:function (err) {
                alert('系统错误-delete-member');
            }
        })
    }
    
</script>
</body>
</html>