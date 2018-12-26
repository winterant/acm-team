<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/9/25
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="footContainer">
    <p style="font-size: .8em;margin-bottom: 4px">
        <a href="${pageContext.request.contextPath}/" target="_parent"><%=homeName%></a>
        <font style="color: #ffffff">&nbsp;|&nbsp;</font>
        <a href="http://icpc.ldu.edu.cn" target="_blank">LDU Online Judge</a>
        <font style="color: #ffffff">&nbsp;|&nbsp;</font>
        <a href="https://blog.csdn.net/winter2121" target="_blank">雪的期许</a>
        <font style="color: #ffffff">&nbsp;|&nbsp;</font>
        <a href="http://www.miitbeian.gov.cn/" target="_blank">鲁ICP备18051516号</a>
    </p>

    <div id="time1">
        <%-- js显示动态时间 --%>.
    </div>

    <div>
        <p style="margin: 5px;color: white">
            Copyright © 2018 winter All rights reserved.
        </p>
    </div>
</div>

<script src="${pageContext.request.contextPath}/template/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/template/js/ajax.js"></script>
<script src="${pageContext.request.contextPath}/template/js/menu.js"></script>
<script src="${pageContext.request.contextPath}/template/js/action.js"></script>
<script type="text/javascript">
    var h=document.getElementById("footContainer").offsetHeight;
    var hideDiv=document.createElement("div");
    hideDiv.style.height=h+"px";
    document.body.appendChild(hideDiv);

    var nowTime=function () {
        document.getElementById('time1').innerHTML='Server time: '+formatDate(new Date());
        return nowTime; //若不返回，此函数就无法多次执行
    }
    setInterval(nowTime(),1000);
</script>