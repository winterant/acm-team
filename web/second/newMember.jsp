<%--
  Created by IntelliJ IDEA.
  User: winter
  Date: 2018/12/17
  Time: 14:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="Mysql.SQL" %>
<%@ page import="java.util.Map" %>
<%@ page import="Tools.FilePath" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/template/headTag.jsp"%>
    <title><%=homeName%></title>
    <style type="text/css">
        .container{
            background-color: white;
            border-radius: 4px;
            overflow: hidden;
            text-align: center;
            min-height: 60%;
        }
    </style>
</head>
<body>
    <%@include file="/template/header.jsp"%>
    <%
        String midStr=request.getParameter("mid");
        SQL mysql=new SQL();
        String sql="select * from members where id="+midStr;
        Map member=mysql.queryFirst(sql);
        if(userTemp!=null&&userTemp.getInt("power")>0&&!member.isEmpty()){
            //编辑
            request.setAttribute("edi",true);
            member.put("photoPath", FilePath.getFilePath((Integer) member.get("photo"),"/images/smallPic/defaultphoto.jpg"));
            request.setAttribute("member",member);
        }else{
            request.setAttribute("edi",false);
        }
    %>
    <div class="bigContainer">
        <c:choose>
            <%-- test第一参数为false时，此页面将仅允许管理员访问 --%>
            <c:when test="${ false || user!=null && user.userMap.power>0}">
                <div class="container">
                    <h1>欢迎填写队员信息</h1>
                    <form id="form-member">
                        <table class="table-input-info" align="center">
                            <tr>
                                <td class="td1">*身份：</td>
                                <td>
                                    <select id="memberiden" name="identity">
                                        <option value="0">我是退役队员</option>
                                        <option value="1">我是现役队员</option>
                                        <option value="2">我是教师</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="td1">*姓名：</td>
                                <td>
                                    <input type="text" name="name" size="16" maxlength="10"/>
                                    <input type="text" name="mid" hidden>
                                </td>
                            </tr>
                            <tr>
                                <td class="td1">*年级：</td>
                                <td><input type="text" name="grade" size="16" placeholder="如：2018" onkeyup="value=value.replace(/[^\d]/g,'');"/></td>
                            </tr>
                            <tr>
                                <td class="td1">*专业：</td>
                                <td><input type="text" name="major" size="16" placeholder="如：软件工程"/></td>
                            </tr>
                            <tr>
                                <td class="td1">*邮箱：</td>
                                <td><input type="text" name="email" size="16" placeholder="如：123@163.com"/></td>
                            </tr>
                            <tr>
                                <td class="td1">个人博客主页：</td>
                                <td><input type="text" name="blog" size="16" placeholder="如:https://blog.csdn.net/hello"/></td>
                            </tr>
                            <tr>
                                <td class="td1">*工作/院校：</td>
                                <td><input type="text" name="work" size="16" placeholder="如:鲁东大学"/></td>
                            </tr>
                            <tr>
                                <td class="td1">个人简介：</td>
                                <td>
                                    <textarea name="introduce" placeholder="" hidden></textarea>
                                    <div id="weditor">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="td1">照片：</td>
                                <td>
                                    <div style="width: 30%;cursor: pointer;" id="showMemberPhoto" onclick="$('#memberPhoto').click()" title="更换照片">
                                        <img id="memberImg" width="100%" src="/images/smallPic/defaultphoto.jpg" alt="">
                                    </div>
                                    <input id="fileid" type="text" name="fileid" hidden>
                                    <input id="memberPhoto" type="file" name="photo" onchange="memberAddPhoto()" hidden>
                                </td>
                            </tr>
                        </table>
                        <button id="btnMember" type="button" onclick="newMember('form-member','update')" class="btnSubmit">提交</button>
                    </form>

                    <p style="color: #7f7f7f">提交后你的信息需要等待管理员验证后在前台显示</p>
                </div>
                <%--此页面开启时，才加载一下js--%>
                <script type="text/javascript" src="${rootPath}/wangEditor/release/wangEditor.min.js"></script>
                <script type="text/javascript">
                    var E = window.wangEditor;
                    var editor = new E('#weditor');
                    editor.customConfig.uploadImgServer = '/ServletUpload?type=newsImg';
                    editor.customConfig.uploadImgMaxSize=10*1024*1024;
                    editor.customConfig.uploadImgHooks = {
                        before: function (xhr, editor, files) {
                            console.log("准备上传")
                        },
                        success: function (xhr, editor, result) {
                            console.log("上传成功"+result);
                        },
                        fail: function (xhr, editor, result) {
                            alert("上传失败"+result);
                        },
                        error: function (xhr, editor) {
                            alert("上传出错"+result);
                        },
                        timeout: function (xhr, editor) {
                            alert("上传超时"+result);
                        },
                        customInsert: function (insertImg, result, editor) {
                            console.log("回传图片地址"+result);
                            console.log(result)
                            insertImg(result.data)
                        }
                    }
                    editor.create();

                    if(${edi}){
                        selectOption('memberiden','${member.identity}')
                        $('input[name=mid]').val('${member.id}')
                        $('input[name=name]').val('${member.name}')
                        $('input[name=grade]').val('${member.grade}')
                        $('input[name=major]').val('${member.major}')
                        $('input[name=email]').val('${member.email}')
                        $('input[name=blog]').val('${member.blog}')
                        $('input[name=work]').val('${member.work}')
                        //introduce
                        editor.txt.html("${member.introduce}")
                        $('input[name=fileid]').val('${member.photo}')
                        $('#memberImg').attr("src","${member.photoPath}");
                    }

                    function newMember(id) {
                        var must=['name','grade','major','email','work'];
                        for(var i=0;i<must.length;i++){
                            if($('input[name='+must[i]+']').val().length<1){
                                $('input[name='+must[i]+']').focus();
                                return;
                            }
                        }
                        var reg=/\S+@\S+\.\S+/i
                        if(!reg.test($('input[name=email]').val())){
                            alert('邮箱格式错误！');
                            $('input[name=email]').focus();
                            return;
                        }
                        // if($('input[name=fileid]').val().length<1){
                        //     alert('上传一张照片吧^_^')
                        //     return;
                        // }
                        $('textarea[name=introduce]').val(editor.txt.html())
                        $.ajax({
                            type:"POST",
                            url:"/ServletMember",
                            dataType:'json',
                            data:$('#'+id).serialize()+"&"+$.param({"type":${edi}?"update":"add"}),
                            success:function (res) {
                                if(res.result){
                                    console.log(res.msg);
                                    if(${edi})window.location="${rootPath}/admin/membersListPage.jsp"
                                    else{
                                        alert("您的信息提交成功，等待审核")
                                        window.location="${rootPath}/membersPage.jsp";
                                    }
                                }else{
                                    alert(res.msg);
                                }
                            },
                            error:function (err) {
                                alert("系统错误-newMember");
                            }
                        })
                    }
                    function memberAddPhoto() {
                        var formData=new FormData();
                        formData.append("file",$('#memberPhoto').prop('files')[0]);
                        formData.append('type','memberPhoto');
                        $.ajax({
                            type:'POST',
                            url:'/ServletUpload',
                            dataType:'json',
                            // contentType:"application/javascript; charset=utf-8",
                            data:formData,
                            contentType: false,// 注意：让jQuery不要处理数据
                            processData: false,// 注意：让jQuery不要设置contentType
                            success:function (ret) {
                                console.log(ret)
                                if(ret['result']){
                                    alert("照片上传成功");
                                    $('#fileid').val(ret.fileid);
                                    document.getElementById("memberImg").setAttribute("src",ret.path);
                                }else{
                                    alert(ret['msg']);
                                }
                            },
                            error:function (mag) {
                                console.log("上传失败，请重试");
                                alert("上传出错，请重试");
                            }
                        });
                    }
                </script>
            </c:when>
            <c:otherwise>
                <%--关闭了此页面的功能--%>
                <div class="container">
                    <h1>管理员关闭了此功能，如有需要请联系ICPC创新实验室</h1>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%@include file="/template/footer.jsp"%>


</body>
</html>
