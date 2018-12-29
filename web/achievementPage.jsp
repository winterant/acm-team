<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/12/27
  Time: 9:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-战绩</title>

</head>
<body>
    <%@include file="template/header.jsp"%>
    <%
        String sql;
        SQL mysql=new SQL();
        sql= "select type,year(date) year,sum(gold) gold,sum(silver) silver,sum(bronze) bronze" +
                ",sum(fine) fine from matches group by type,year(date) order by year(date) DESC";
        List prizes=mysql.queryList(sql);
        request.setAttribute("prizes",prizes);
        request.setAttribute("list",mysql.queryList("select *,year(date) year from matches"));
        mysql.close();
        request.setAttribute("matchName",matchName);
        String []pname1={"金牌","银牌","铜牌","优胜奖"};
        String []pname2={"一等奖","二等奖","三等奖","优胜奖"};
        request.setAttribute("pname1",pname1);
        request.setAttribute("pname2",pname2);
    %>
    <div class="bigContainer">
        <c:forEach var="item" items="${matchName}" varStatus="j">
            <div class="item-block">
                    <div class="leftSmallTitle">${item}</div>
                    <hr style="margin:0;">
                    <div class="prize-show">
                        <c:forEach var="pri" items="${prizes}">
                            <c:set var="pname" value="${j.index<=2?pname1:pname2}"></c:set>
                            <c:if test="${pri.type == j.index}">
                                <div class="everyYear">
                                    <a class="user-color1" href="javascript:void(0)"
                                       onclick="slideDisplay('yearPrize${j.index}_${pri.year}')">
                                        <font>${pri.year}年</font>&nbsp;
                                        <font>${pname[0]}×${pri.gold}</font>&nbsp;
                                        <font>${pname[1]}×${pri.silver}</font>&nbsp;
                                        <font>${pname[2]}×${pri.bronze}</font>&nbsp;
                                        <font>${pname[3]}×${pri.fine}</font>
                                    </a>
                                    <%--输出pri.year年的所有塞站--%>
                                    <div id="yearPrize${j.index}_${pri.year}" class="hide">
                                        <c:forEach var="prize" items="${list}">
                                            <c:if test="${prize.year==pri.year&&prize.type==pri.type}">
                                                <li style="padding-left: 2%">
                                                    <a href="javascript:void(0)" onclick="showNews(${prize.newsid})">${prize.title}</a>
                                                    <font class="pc-gold ${prize.gold>0?'':'hide'}">${pname[0]}×${prize.gold}</font>
                                                    <font class="pc-silver ${prize.silver>0?'':'hide'}">${pname[1]}×${prize.silver}</font>
                                                    <font class="pc-bronze ${prize.bronze>0?'':'hide'}">${pname[2]}×${prize.bronze}</font>
                                                    <font class="${prize.fine>0?'':'hide'}">${pname[3]}×${prize.fine}</font>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                    </div>

                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
            </div>
        </c:forEach>
    </div>
    <div class="bigContainer">
        <div style="width: 98%">
            <div id="showNews" class="prizeShowNews">
                <a href="javascript:goToTop()" class="backA">返回顶部</a>
                <h1 id="ptitle" style="margin: 0;text-align: center"></h1>
                <hr style="margin: 0">
                <div id="ptext"></div>
            </div>
        </div>

    </div>

    <%@include file="template/footer.jsp"%>
<script type="text/javascript">
    document.getElementById('achievement').style.color="<%=homeSelectColor%>";
    function slideDisplay(divid) {
        if($('#'+divid).is(":hidden")){
            $('#'+divid).slideDown();
        }else{
            $('#'+divid).slideUp();
        }
    }
    function showNews(newsid) {
        $.ajax({
            type:"POST",
            url:"/ServletNews",
            dataType:"json",
            data:{
                type:"query",
                id:newsid
            },
            success:function (ret) {
                console.log(ret)
                if(ret.result){
                    $("#showNews").fadeIn();
                    $("#ptitle").text(ret.news.title);
                    $("#ptext").html(ret.news.mainText);
                    $('html,body').animate({scrollTop:$('#showNews').offset().top-10}, 200);
                }else{
                    console.log(ret.msg);
                }
            },
            error:function (err) {
                console.log(err)
            }
        })

    }
</script>

</body>
</html>
