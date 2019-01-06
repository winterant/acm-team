
<%--
  Created by IntelliJ IDEA.
  User.java: winter
  Date: 2018/10/8
  Time: 20:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Tools.Changing" %>
<%@ page import="Mysql.SQL" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%>-编辑新闻</title>

</head>
<body>

    <%
        User user= (User) session.getAttribute("user");
        if(user==null||!user.isExist()||user.getInt("power")==0){
            response.sendRedirect("/"); //不是管理员将被送回主页
            return;
        }
        int nid= Changing.strToNumber(request.getParameter("nid"),0);
        boolean isNew=nid==0;    //添加数据
        request.setAttribute("isNew",isNew);
        Map<String,Object> newsMap=null;
        String titleStr="",mainTextStr="";
        SQL mysql=new SQL();
        if(!isNew){
            //修改新闻
            newsMap=mysql.queryFirst("select * from news where id="+nid);
            titleStr=(String)newsMap.get("title");
            mainTextStr=(String)newsMap.get("mainText");
        }
    %>
    <script type="text/javascript">
        var jsnid=<%=nid%>;
    </script>

    <%@include file="/template/header.jsp"%>
    <div class="bigContainer">
        <%@include file="managerLeft.jsp"%>
        <%-- 添加新闻 --%>
        <div class="adminRightArea">
            <div style="width: 96%;margin: 0 auto">
                <form>
                    <h3>编辑<%=nid==1?"首页":"新闻"%></h3>
                    <div style="margin-bottom:20px">
                        <input id="txtTitle" name="newsTitle" type="text" maxlength="100" placeholder="输入标题" value="<%=titleStr%>">
                    </div>

                    <div id="editor" style="text-align: left;background-color: white;margin-bottom: 20px;">
                    </div>
                    <c:if test="${!isNew}">
                        <p style="margin: 0;float: left">
                            <input id="cbox" type="checkbox" name="updateDate">
                            <font onclick="$('#cbox').click()" style="cursor:pointer;vertical-align: top">将发表时间修改为现在</font>
                        </p>
                        <br>
                    </c:if>
                </form>

                <button class="form-control" onclick="WEsave(jsnid,'<%=user.getString("userName")%>')" type="button">保存草稿</button>
                <button class="form-control" onclick="WEpublish(jsnid,'<%=user.getString("userName")%>')" type="button">提交</button>

            </div>

        </div>
    </div>
    <%@include file="/template/footer.jsp"%>

<script type="text/javascript" src="${rootPath}/wangEditor/release/wangEditor.min.js"></script>
<script type="text/javascript">

    var E = window.wangEditor;
    var editor = new E('#editor');
    editor.customConfig.uploadImgServer = '/ServletUpload?type=newsImg';
    editor.customConfig.uploadImgMaxSize=10*1024*1024;
    editor.customConfig.uploadImgMaxLength = 50;
    editor.customConfig.uploadImgHooks = {
        before: function (xhr, editor, files) {
            // 图片上传之前触发
            // xhr 是 XMLHttpRequst 对象，editor 是编辑器对象，files 是选择的图片文件

            // 如果返回的结果是 {prevent: true, msg: 'xxxx'} 则表示用户放弃上传
            // return {
            //     prevent: true,
            //     msg: '放弃上传'
            // }
            console.log("准备上传")
        },
        success: function (xhr, editor, result) {
            console.log("上传成功"+result);
            // 图片上传并返回结果，图片插入成功之后触发
            // xhr 是 XMLHttpRequst 对象，editor 是编辑器对象，result 是服务器端返回的结果
        },
        fail: function (xhr, editor, result) {
            alert("上传失败"+result);
            // 图片上传并返回结果，但图片插入错误时触发
            // xhr 是 XMLHttpRequst 对象，editor 是编辑器对象，result 是服务器端返回的结果
        },
        error: function (xhr, editor) {
            alert("上传出错"+result);
            // 图片上传出错时触发
            // xhr 是 XMLHttpRequst 对象，editor 是编辑器对象
        },
        timeout: function (xhr, editor) {
            alert("上传超时"+result);
            // 图片上传超时时触发
            // xhr 是 XMLHttpRequst 对象，editor 是编辑器对象
        },

        // 如果服务器端返回的不是 {errno:0, data: [...]} 这种格式，可使用该配置
        // （但是，服务器端返回的必须是一个 JSON 格式字符串！！！否则会报错）
        customInsert: function (insertImg, result, editor) {
            // 图片上传并返回结果，自定义插入图片的事件（而不是编辑器自动插入图片！！！）
            // insertImg 是插入图片的函数，editor 是编辑器对象，result 是服务器端返回的结果

            // 举例：假如上传图片成功后，服务器端返回的是 {url:'....'} 这种格式，即可这样插入图片：
            console.log("回传图片地址"+result);
            console.log(result)
            insertImg(result.data);

            // result 必须是一个 JSON 格式字符串！！！否则报错
        }
    }

    editor.create();

    //把数据读出来放到输入框
    editor.txt.html("<%=Changing.strTransfer(mainTextStr).replace("\n","")%>");

    var nowId=(jsnid==1)?"gongEditor":"newsEditor";
    document.getElementById(nowId).style.backgroundColor="#b3b3b3";
    document.getElementById(nowId).style.color="#000000";

</script>
</body>
</html>
