<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/11/5
  Time: 15:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


    <div class="homeLeft">
        <%
            SQL mysqlLeft=new SQL();
            String sqlLeft="select id,title from news where status>0 and id>1 order by publishTime DESC limit 10";
            request.setAttribute("nearNews",mysqlLeft.queryList(sqlLeft));
            sqlLeft="select * from speaks order by publishTime DESC limit 6";
            request.setAttribute("nearSpeaks",mysqlLeft.queryList(sqlLeft));
            mysqlLeft.close();
        %>
        <%--动态显示时间--%>
        <div id="time1" style="font-size: 0.84em;height: 18px;text-align: center;">
            <%-- js显示动态时间 --%>
            <script type="text/javascript">
                var nowTime=function () {
                    document.getElementById('time1').innerHTML= new Date().toLocaleString()
                        +' 周'+'日一二三四五六'.charAt(new Date().getDay());
                    return nowTime; //若不返回，此函数就无法多次执行
                }
                setInterval(nowTime(),1000);
            </script>
        </div>

        <%--战绩--%>
        <div class="item-left-block">
            <div style="overflow:hidden;">
                <div class="leftSmallTitle" onmousemove="prizeDisplay(<%=matchName.length%>,0)" onmouseleave="prizeDisplay(<%=matchName.length%>,1)">
                    <a href="/second/gradePage.jsp" style="color: #ff4a00">鲁东大学ACM战绩</a>
                </div>
                <%--<div style="float: right;"><a href="/second/#" style="font-size: 0.7em;">更多..</a></div>--%>
            </div>
            <hr style="margin: 0">
            <div class="dropShowSTH">
                <ul class="ulstyleNone" style="font-size: 0.9em;">
                    <%
                        SQL mysqlMatch=new SQL();
                        String sqlMatch;
                        for(int i=0;i<matchName.length;i++){
                            sqlMatch=String.format("select ifnull(sum(gold),0) num from matches where type=%d",i);
                            String gold=mysqlMatch.queryFirst(sqlMatch).get("num").toString();
                            sqlMatch=String.format("select ifnull(sum(silver),0) num from matches where type=%d",i);
                            String silver=mysqlMatch.queryFirst(sqlMatch).get("num").toString();
                            sqlMatch=String.format("select ifnull(sum(bronze),0) num from matches where type=%d",i);
                            String bronze=mysqlMatch.queryFirst(sqlMatch).get("num").toString();
                    %>
                        <li style="padding:1%;">
                            <a href="/second/gradePage.jsp?type=<%=i%>" onmousemove="$('#prizeInfo<%=i%>').fadeIn(200)" onmouseleave="$('#prizeInfo<%=i%>').fadeOut(200)"><%=matchName[i]%></a>
                            <%--<br>--%>
                            <font id="prizeInfo<%=i%>" class="prizeInfo" style="font-size: 0.86em">
                                <%--<font style="padding-left: 5%;">汇总:</font>--%>
                                <font class="bg-gold">金×<%=gold%></font>
                                <font class="bg-silver">银×<%=silver%></font>
                                <font class="bg-bronze">铜×<%=bronze%></font>
                            </font>
                        </li>
                    <%
                        }
                        mysqlMatch.close();
                    %>
                </ul>
            </div>
        </div>

        <%--团队介绍--%>
        <%--<div class="item-left-block">--%>
            <%--<div style="overflow: hidden">--%>
                <%--<div class="leftSmallTitle"><%=homeName%></div>--%>
                <%--<div class="btnShowMenu" type="button" onclick="showMenu('dropShowImg')">展开</div>--%>
            <%--</div>--%>
            <%--<div id="dropShowImg" class="dropShowSTH">--%>
                <%--<hr style="margin:0;">--%>
                <%--<img src="/images/background/teamPhoto.jpg" width="100%">--%>
            <%--</div>--%>
        <%--</div>--%>

        <%--近期新闻--%>
        <div class="item-left-block">
            <div style="overflow:hidden;">
                <div class="leftSmallTitle">近期新闻</div>
                <div style="float: right;"><a href="/newsListPage.jsp" style="font-size: 0.7em;">更多..</a></div>
            </div>
            <div id="dropShowNews" class="dropShowSTH">
                <hr style="margin:0;">
                <c:forEach var="item" items="${nearNews}">
                    <p class="line-limit-length" style="margin:6px 0;font-size: 0.8em">
                        <a href="/second/newsPage.jsp?nid=${item.id}" title="${item.title}">
                            ${item.title}
                        </a>
                    </p>
                </c:forEach>
            </div>
        </div>

        <%--留言板--%>
        <div class="item-left-block">
            <div style="overflow: hidden">
                <div class="leftSmallTitle">留言板</div>
                <div style="float:right;">
                    <a href="/second/speaksPage.jsp" style="font-size: 0.7em;">查看所有..</a>
                </div>
            </div>
            <div id="dropShowSpeaks" class="dropShowSTH">
                <hr style="margin:0;">
                <div style="overflow: hidden;margin-bottom: 3px;">
                    <textarea id="saySth" style="width:97%;height: 70px;" maxlength="50" placeholder="说点什么吧...50字以内"></textarea>
                    <c:if test="${user==null}">
                        <input id="authorName" style="float:left;width: 70%;margin-top: 4px" placeholder="留下你的名字吧">
                    </c:if>
                    <button id="btnSaySth" type="button" onclick="speak()" style="float: right;background-color: #f3f7f8;color: #557bff;margin: 4px;">发表</button>
                </div>

                <%--显示6条最近留言--%>
                <c:forEach var="item" items="${nearSpeaks}" varStatus="j">
                    <hr style="margin: 0">
                    <div style="overflow: hidden;">
                        <p style="margin:5px auto;font-size: 0.8em;">
                            <c:choose>
                                <c:when test="${item.isUser==1}">
                                    <a href="/profilePage.jsp?userName=${item.author}">${item.author}</a>
                                </c:when>
                                <c:otherwise>${item.author}</c:otherwise>
                            </c:choose>
                            说：${item.mainText}
                        </p>
                        <p style="margin: 0;float:right;font-size: 0.8em">${item.publishTime}</p>
                    </div>
                </c:forEach>

            </div>
        </div>
        <%--end of speaks--%>
    </div>
    <%--end of left--%>