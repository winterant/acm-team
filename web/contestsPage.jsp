<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/10/29
  Time: 9:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Tools.Paging" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="Tools.Checking" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-竞赛</title>
</head>
<body>
    <%@ include file="/template/header.jsp"%>
    <div class="bigContainer">
        <%--左侧概览区域--%>
        <%@include file="/template/homeLeftPage.jsp"%>

        <%--  竞赛区域  --%>
        <div class="homeContainer">

            <div style="width: 94%;margin: 0px auto">
                <%--模态框添加竞赛--%>
                <div id="contest-back" class="modal-overlay">
                    <div id="contest-main" class="modal-main">
                        <div>
                            <font style="font-size: 1.3em">添加竞赛</font>
                            <div class="close">
                                <a href="javascript:overlay('contest-back','contest-main')">×</a>
                            </div>
                        </div>
                        <hr>
                        <form id="add-contest">
                            <%
                                SimpleDateFormat sdf=new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
                                int h=1000*60*60;  //一个小时的毫秒数
                                Date later=new Date( (new Date().getTime()/h+1)*h );
                            %>
                            <p style="font-size: 0.9em">UPC可以在管理员界面自动更新（爬虫）</p>
                            <table class="table-input-info" align="center">
                                <tr>
                                    <td>竞赛平台：</td>
                                    <td>
                                        <select name="platform" id="addModSelect" style="width: 100%;height:30px;">
                                            <%
                                                for(int i=0;i<OJplatform.length;i++){
                                            %>
                                            <option value="<%=i%>"><%=OJplatform[i]%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>竞赛标题：</td>
                                    <td><input type="text" name="title"></td>
                                </tr>
                                <tr>
                                    <td valign="top">竞赛描述：</td>
                                    <td><textarea name="mainText" id="" cols="30" rows="10"></textarea></td>
                                </tr>
                                <tr>
                                    <td>开始时间：</td>
                                    <td><input type="text" name="startTime" value="<%=sdf.format(later)%>"></td>
                                </tr>
                                <tr>
                                    <td>时长：</td>
                                    <td><input type="text" name="length" value="5:00"></td>
                                </tr>
                                <tr>
                                    <td>比赛地址：</td>
                                    <td><input type="text" name="url" placeholder="网址,请以http(s)开头"></td>
                                </tr>
                            </table>
                        </form>
                        <button id="contestbtn" class="form-control" type="button" onclick="addContest()">提交</button>
                    </div>
                </div>

                <%--模态框按钮--%>
                <c:if test="${user.userMap.power>0}">
                    <div>
                        <button onmousedown="toAdd('contestbtn')" onclick="overlay('contest-back','contest-main')" class="form-control" type="button" style="float: right;margin-right: 6%;">添加竞赛</button>
                    </div>
                </c:if>

                <%--页码--%>
                <%
                    request.setCharacterEncoding("utf-8");
                    boolean isEnd="end".equals(request.getParameter("type"));
                    String platform=request.getParameter("platform");
                    String keyWords=request.getParameter("keyWords");
                    String strPage=request.getParameter("nowPage");

                    int nowPage=Changing.strToNumber(strPage,1);
                    Paging paging=new Paging("contests");
                    if(isEnd){
                        paging.setSqlWhere("where endTime<'"+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())+"'");
                        paging.setOrder("startTime",1);
                        paging.addNextArgs("type","end"); //已结束
                    }else{
                        paging.setSqlWhere("where endTime>'"+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())+"'");
                        paging.setOrder("startTime",0);
                    }

                    if(keyWords!=null&&keyWords.length()>0){
                        paging.addVague("title",keyWords);  //模糊查询
                        paging.addVague("mainText",keyWords);
                    }
                    paging.setPageSize(8);

                    if(keyWords!=null&&keyWords.length()>0)
                        paging.addNextArgs("keyWords",keyWords);  //页面传参,继续模糊查询
                    if(Checking.strIsNumber(platform)&&Changing.strToNumber(platform)>=0){
                        paging.addNextArgs("platform",platform);
                        paging.addExact("platform",platform);
                    }

//                  out.print(paging.getSql());
                    List<Map<String,Object>> list=paging.getDataList(nowPage); //获取当前页的内容
                    request.setAttribute("list",list);
                %>

                <%--菜单--%>
                <div class="right-head-menu">
                    <div class="right-head-menu-click">
                        <li id="waitBtn"><a href="contestsPage.jsp">等你来战</a></li>
                        <li id="endBtn"><a href="contestsPage.jsp?type=end">温故知新</a></li>
                    </div>
                </div>

                <%--搜索条--%>
                <div class="search" style="margin-right: 15%;">
                    <form method="get" action="<%=request.getServletPath()%>">
                        <%--按平台条件显示--%>
                        <select name="platform" id="platformSelect">
                            <option value="-1">All contests</option>
                            <%
                                int platNum=Changing.strToNumber(platform,-1);
                                for(int i=0;i<OJplatform.length;i++){
                                    if(i==platNum){
                            %>
                            <option value="<%=i%>" selected><%=OJplatform[i]%></option>
                            <%
                            }else{
                            %>
                            <option value="<%=i%>"><%=OJplatform[i]%></option>
                            <%
                                    }
                                }
                            %>
                        </select>


                        <%
                            if("end".equals(request.getParameter("type"))){
                        %>
                        <input type="text" name="type" value="end" hidden>
                        <%
                            }
                        %>
                        <input class="form-control-input" type="text" name="keyWords" placeholder="标题、描述查找">
                        <button class="form-control" type="submit">查找</button>
                    </form>
                </div>
                <%@include file="/template/pagingDiv.jsp"%>

                <div style="overflow:auto">
                    <table class="table-contest">
                        <tr style="text-align: left;">
                            <th>开始时间</th>
                            <th>时长</th>
                            <th>平台</th>
                            <th>竞赛信息</th>
                            <th>状态</th>
                            <th></th>
                        </tr>
                        <script type="text/javascript">
                            var secMap=new Map();
                        </script>
                        <c:forEach var="item" varStatus="j" items="${list}">
                            <tr>
                                <td>
                                    <p class="oneline" style="margin: 2%">
                                        <fmt:formatDate value="${item.get('startTime')}" var="sDate" pattern="yyyy-MM-dd"></fmt:formatDate>
                                        <fmt:formatDate value="${item.get('startTime')}" var="sTime" pattern="HH:mm:ss"></fmt:formatDate>
                                        ${sDate}<br>
                                        <font>${sTime}</font>
                                    </p>
                                </td>

                                <td>
                                    <font id="length${j.index}"></font>
                                    <script type="text/javascript">
                                        var lenms="${(item.endTime.time-item.startTime.time)}";
                                        var days=Math.floor(lenms/(1000*60*60*24));
                                        var hours=Math.floor(lenms/(1000*60*60)%24);
                                        var mins=Math.floor(lenms/(1000*60)%60);
                                        var leninfo="";
                                        if(days>0)
                                            leninfo+=days+"天 ";
                                        leninfo+=hours+":"+(mins<10?"0":"")+mins;
                                        document.getElementById("length${j.index}").innerText=leninfo;
                                    </script>
                                </td>

                                <c:set var="OJname" value="<%=OJplatform%>"></c:set>
                                <td class="oneline">${OJname[item.platform]}</td>

                                <td>
                                    <p style="margin:0;font-size: 1.05em;"><a href="${item.get('url')}" target="_blank">${item.get('title')}</a></p>

                                    <%--<img src="images/smallPic/notice.jpg" style="height: 15px">--%>
                                    <font style="color: #5a5a5a;word-break:break-all;">
                                        ${item.mainText}
                                    </font>

                                </td>

                                <td>

                                    <c:set var="now" value="<%=new Date().getTime()%>"></c:set>
                                    <c:choose>
                                        <c:when test="${item.startTime.time > now}">
                                            <font class="oneline">等你来战！</font>
                                        </c:when>
                                        <c:when test="${item.startTime.time<now && now<item.endTime.time}">
                                            <font class="oneline" color="#00b708">正在比赛中...</font>
                                        </c:when>
                                        <c:otherwise>
                                            <font class="oneline">已结束</font>
                                        </c:otherwise>
                                    </c:choose>
                                    <br>
                                    <font id="timedown${j.index}" class="oneline" style="color: #505050;"></font>
                                    <script type="text/javascript">
                                        var tim=${item.startTime.time > now}?${item.startTime.time-now}:${item.endTime.time-now};
                                        secMap.set(${j.index},Math.floor(tim/1000));
                                        <%--倒计时--%>
                                        var timeDown=function () {
                                            if(secMap.has(${j.index})) {
                                                var sec = secMap.get(${j.index});
                                                if(sec<0)return;
                                                var d = Math.floor(sec / (60 * 60 * 24));
                                                var h = Math.floor(sec / (60 * 60)) % 24;
                                                var m = Math.floor(sec / 60) % 60;
                                                var s = sec % 60;
                                                var time = "";
                                                if (d > 0) time += d + '天';
                                                time += h + ":" + (m<10?"0":"") +m + ":" + (s<10?"0":"") + s;
                                                document.getElementById("timedown${j.index}").innerText=time;
                                                secMap.set(${j.index}, --sec);
                                                if (sec < 0){
                                                    secMap.delete(${j.index});
                                                    window.location.reload();
                                                }
                                            }
                                            return timeDown; //若不返回，此函数就无法多次执行
                                        }
                                        timeDown();
                                        setInterval(timeDown(),1000);
                                    </script>

                                </td>

                                <td>
                                    <%--<li class="oneline">[<a href="#">查看榜单</a>]</li>--%>
                                    <%--<li class="oneline">[<a href="#">提交记录</a>]</li>--%>
                                    <c:if test="${user!=null && user.userMap.power>0}">
                                        <li class="oneline">
                                                [<a href="javascript:overlay('contest-back','contest-main');
                                                toUpdate('contestbtn','${item.id}','${item.platform}','${item.title}',
                                                '${item.mainText}','${item.startTime}','${item.endTime.time-item.startTime.time}','${item.url}')">编辑</a>]
                                        </li>
                                        <li class="oneline">
                                                [<a href="javascript:if(confirm('确定删除该竞赛记录吗?'))deleteContest('${item.id}')">删除</a>]
                                        </li>
                                    </c:if>
                                </td>

                            </tr>
                        </c:forEach>

                    </table>
                </div>
            </div>

        </div>
        <%--end of homeContainer--%>

    </div>
    <%@ include file="/template/footer.jsp"%>
<script type="text/javascript">
    document.getElementById('recent').style.color="<%=homeSelectColor%>";
    document.getElementById(<%=isEnd%>?'endBtn':'waitBtn').style.backgroundColor="#a8e4d9";


</script>
</body>
</html>
