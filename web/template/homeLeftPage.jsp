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

        <div class="item-left-block">
            <div style="overflow: hidden">
                <div class="leftSmallTitle">友情链接</div>
            </div>
            <hr style="margin:0;">
            <div id="dropShowImg" class="dropShowSTH">
                <li><a href="http://www.ldu.edu.cn/" target="_blank">鲁东大学</a></li>
                <li><a href="http://www.xinke.ldu.edu.cn" target="_blank">信电学院</a></li>
                <li><a href="<%=vjudgeAddr%>" target="_blank">Vjudge.net</a></li>
                <li><a href="<%=codeforcesAdrr%>" target="_blank">codeforces</a></li>
                <li><a href="<%=newcoderAddr%>" target="_blank">牛客网</a></li>
                <li><a href="<%=atcoderAddr%>" target="_blank">AtCoder</a></li>
                <li class="line-limit-length"><a href="<%=upcAddr%>" target="_blank">UPC Online Judge</a></li>
                <li><a href="http://acm.hdu.edu.cn/" target="_blank">HDU Online Judge</a></li>
                <li><a href="http://acm.sdut.edu.cn/" target="_blank">山东理工大学ACM</a></li>
                <li><a href="http://acm.zju.edu.cn/onlinejudge/" target="_blank">浙江大学ZOJ</a></li>
                <li><a href="http://poj.org/" target="_blank">北京大学POJ</a></li>
            </div>
        </div>

        <%--团队介绍--%>
        <%--<div class="item-left-block">--%>
            <%--<div style="overflow: hidden">--%>
                <%--<div class="leftSmallTitle"><%=homeName%></div>--%>
            <%--</div>--%>
            <%--<div id="dropShowImg" class="dropShowSTH">--%>
                <%--<hr style="margin:0;">--%>
                <%--<img src="/images/background/teamPhoto.jpg" width="100%">--%>
            <%--</div>--%>
        <%--</div>--%>

        <%--近期新闻--%>
        <div class="item-left-block">
            <div style="position: relative">
                <div class="leftSmallTitle">近期新闻</div>
                <div style="position: absolute;right: 0;bottom: 0"><a href="${rootPath}/newsListPage.jsp" style="font-size: 0.7em;">更多..</a></div>
            </div>
            <div id="dropShowNews" class="dropShowSTH">
                <hr style="margin:0;">
                <c:forEach var="item" items="${nearNews}">
                    <p class="line-limit-length" style="margin:6px 0;">
                        <a href="${rootPath}/second/newsPage.jsp?nid=${item.id}" title="${item.title}">
                            ${item.title}
                        </a>
                    </p>
                </c:forEach>
            </div>
        </div>

        <%--留言板--%>
        <c:if test="${false}">
            <div class="item-left-block">
                <div style="position: relative">
                    <div class="leftSmallTitle">留言板</div>
                    <div style="position: absolute;right: 0;bottom: 0">
                        <a href="${rootPath}/second/speaksPage.jsp" style="font-size: 0.7em;">查看所有..</a>
                    </div>
                </div>
                <div id="dropShowSpeaks" class="dropShowSTH">
                    <hr style="margin:0;">
                    <div style="overflow: hidden;margin-bottom: 3px;">
                        <textarea id="saySth" style="width:97%;height: 70px;" maxlength="50" placeholder="留下您的宝贵建议吧.."></textarea>
                        <c:if test="${user==null}">
                            <input id="authorName" style="float:left;width: 70%;margin-top: 4px" placeholder="留下你的名字吧">
                        </c:if>
                        <button id="btnSaySth" class="btnSpeakSubmit" type="button" onclick="speak()" style="float: right;">发表</button>
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
        </c:if>
        <%--end of speaks--%>


    </div>
    <%--end of left--%>