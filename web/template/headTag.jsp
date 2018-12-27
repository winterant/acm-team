
<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/11/9
  Time: 9:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--此文件必须加在head标签的开头！--%>
<!--网页页面字符集-->
<meta charset="utf-8">
<!--将下面的 <meta> 标签加入到页面中，可以让部分国产浏览器默认采用高速模式渲染页面：-->
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit"/>
<!--让IE使用最新的渲染模式-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<!--针对移动设备,网站显示宽度等于设备屏幕显示宽度,内容缩放比例为1:1-->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- 上述meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="rootPath" value="${pageContext.request.contextPath}"></c:set>
<link rel="shortcut icon" href="${rootPath}/images/background/favicon.ico" type="image/x-icon" />
<link type="text/css" rel="stylesheet" href="${rootPath}/template/css/main.css">


<%!
    String homeName="ICPC创新实验室";
    String teamName="鲁东大学";
    //请不要更改数组元素的顺序！数据库中存的是下标
    String[] OJplatform=new String[]{"常规","codeforces","牛客","atcoder","vjudge","upcOJ","lduOJ","HDU"};
    String[] matchName={"icpc亚洲区域赛&邀请赛","山东省ACM程序设计大赛","ccpc中国大学生程序设计竞赛",
            "蓝桥杯系列","中国计算机团体程序设计天梯赛","其它竞赛"};
    String homeSelectColor="#b1e8f8";

    //地址
    String csdnAddr="https://blog.csdn.net";
    String codeforcesAdrr="http://codeforces.com";
    String newcoderAddr="https://ac.nowcoder.com";
    String atcoderAddr="https://atcoder.jp";
    String vjudgeAddr="https://vjudge.net";
    String upcAddr="http://icpc.upc.edu.cn";
    String lduojAddr="http://icpc.ldu.edu.cn";
%>
