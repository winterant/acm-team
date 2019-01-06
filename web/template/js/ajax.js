
//执行登录检查
function login() {
    var data = $.param({"type":"login"}) + "&" + $("#login").serialize();
    $.ajax({
        type:"POST",
        url:"/ServletUser",
        dataType:'json',
        data:data,  //直接传表单里的数据
        success:function (ret) {
            if(ret.result){
                window.location.reload();
            }else{
                alert(ret.msg);
                $("#password").val("");  //将密码input清空
                $("#password").focus();  //将光标定位到密码input
            }
        },
        error:function (err) {
            console.log("系统错误-login");
        }
    });
};

/****** 注销   ******/
function logout() {
    $.ajax({
        type:"POST",
        url:"/ServletUser",
        data:{type:"logout"},
        dataType:'json',
        success:function (res) {
            if(res.result){
                window.location.reload();
            }
        },
        error:function (err) {
            console.log('系统错误-logout')
        }
    })
}

/***注册*****/
function register(id) {
    $.ajax({
        type:"POST",
        url:"/ServletUser",
        dataType:'json',
        data:$('#'+id).serialize()+"&"+$.param({"type":"register"}),
        success:function (res) {
            if(res.result){
                window.location.reload();
                console.log(res.msg);
            }else{
                alert(res.msg);
                if(res.flag==3)
                    $('input[name=userName]').focus();
            }
        },
        error:function (err) {
            alert("系统错误-register");
        }
    })
}

/******* 修改用户信息 *******/
function modify(id) {
    $.ajax({
        type:"POST",
        url:"/ServletUser",
        dataType:'json',
        data:$('#'+id).serialize()+"&"+$.param({"type":"modify"}),
        success:function (ret) {
            console.log(ret);
            if(ret["result"]){
                self.location=document.referrer;
            }else{
                alert(ret["msg"]);
                if(ret["flag"]==3){
                    $('input[name=password]').focus();
                }else if(ret["flag"]==4){
                    $('input[name=password2]').focus();
                }
            }
        },
        error:function (err) {
            alert("系统错误-modify");
        }
    });
}

/****** 信息锁定的切换   ******/
function changeAlow(aimUser,which) {
    $.ajax({
        type:"POST",
        url:"/ServletUser",
        dataType:'json',
        data:{
            userName:aimUser,
            type:"changeAlow"
        },
        success:function (ret) {
            if(ret["result"]){
                window.location.reload();
            }else{
                console.log('权限不足');
                alert('您的权限不足以修改该用户');
            }
        },
        error:function (err) {
            console.log('系统错误-changeAlow')
        }
    })
}

/****** 删除用户   ******/
function deleteUser(aimUser) {
    $.ajax({
        type:"POST",
        url:"/ServletUser",
        dataType:"json",
        data:{
            userName:aimUser,
            type:"deleteUser"
        },
        success:function (ret) {
            if(ret.result){
                window.location.reload();
            }else{
                console.log('权限不足');
                alert(ret["msg"]);
            }
        },
        error:function (err) {
            console.log('系统错误-changeAlow')
        }
    })
}

/****** 权限修改   ******/
function changePower(aimUser,way) {
    $.ajax({
        type:"POST",
        url:"/ServletUser",
        dataType:"json",
        data:{
            userName:aimUser,
            changePower:way,
            type:"changePower"
        },
        success:function (ret) {
            if(ret["result"]){
                window.location.reload();
            }else{
                console.log('权限不足');
                alert(ret["msg"]);
            }
        },
        error:function (err) {
            console.log('系统错误-changePower');
        }
    })
}

/****** 身份修改   ******/
function changeStatus(aimUser,way) {
    $.ajax({
        type:"POST",
        url:"/ServletUser",
        dataType:"json",
        data:{
            userName:aimUser,
            change:way,
            type:"changeStatus"
        },
        success:function (ret) {
            if(ret["result"]){
                window.location.reload();
            }else{
                console.log('权限不足');
                alert(ret["msg"]);
            }
        },
        error:function (err) {
            console.log('系统错误-changeStatus');
        }
    })
}


/*****  wangeditor 保存新闻  *****/
function WEsave(nid,author) {
    sendToServletNews('save','0',nid,author);
}

/**** wangeditor 发表新闻*******/
function WEpublish(nid,author) {
    var ret=sendToServletNews('save','1',nid,author);
    if(ret==0) return;///标题为空
    window.location = "/second/newsPage.jsp?nid=" +nid;
}

/******wangeditor向servlet发送指令*****/
function sendToServletNews(type,status,nid,author) {
    var title=$("input[name='newsTitle']").val();
    var mainText=editor.txt.html();
    var updateDate=$("input[name='updateDate']").is(":checked");

    if(title.length<1){
        alert('请保证标题不为空！');
        return 0;
    }
    $.ajax({
        type:"POST",
        url:"/ServletNews",
        async:false,
        dataType:"json",
        data:{
            id:nid,
            title:title,
            mainText:mainText,
            updateDate:updateDate,
            author:author,
            status:status,
            type:type
        },
        success:function (ret) {
            jsnid=ret.nid;
            if(ret["result"]){
                console.log('执行'+type+'成功 news id='+nid);
                if(status==0){
                    alert('已保存草稿');
                }
            }else{
                alert(ret["msg"]);
            }
        },
        error:function (XMLHttpRequest) {
            alert("系统错误-newsEditor.jsp"+XMLHttpRequest.status)
        }
    });
}


/**** 删除新闻  ****/
function newsDelete(nid) {
    $.ajax({
        type:"POST",
        url:"/ServletNews",
        dataType:"json",
        data:{
            id:nid,
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
            alert('系统错误-newsDelete');
        }
    });
}



/***** 留言板 发言 ******/
function speak() {
    $.ajax({
        type:"POST",
        url:"/ServletSpeaks",
        dataType:"json",
        data:{
            mainText:$('#saySth').val(),
            author:$('#authorName').val(),
            type:'speak'
        },
        success:function (ret) {
            console.log(ret);
            if(ret["result"]){
                window.location.reload();
            }else{
                alert(ret["msg"]);
            }
        },
        error:function (err) {
            alert("系统错误-ajax-speak");
        }
    })
}
/*删除留言*/
function deleteSpeaks(sid) {
    $.ajax({
        type:"POST",
        url:"/ServletSpeaks",
        dataType:"json",
        data:{
            sid:sid,
            type:'delete'
        },
        success:function (ret) {
            console.log(ret);
            if(ret["result"]){
                window.location.reload();
            }else{
                alert(ret["msg"])
            }
        },
        error:function (err) {
            alert("系统错误-ajax-speak");
        }
    })
}



/***** 添加竞赛 *****/
function addContest() {
    $.ajax({
        type:"POST",
        url:"/ServletContest",
        dataType:'json',
        data:$('#add-contest').serialize()+"&"+$.param({"type":"add"}),
        success:function (ret) {
            if (ret.result) {
                window.location.reload();
            } else {
                alert(ret.msg);
            }
        },
        error:function (err) {
            alert("系统错误-add contest");
        }
    })
}
/***** 修改竞赛 *****/
function updateContest(cid) {

    $.ajax({
        type:"POST",
        url:"/ServletContest",
        dataType:'json',
        async:false,
        data:$('#add-contest').serialize()+"&"+$.param({"type":"update"})+"&"+$.param({"cid":cid}),
        success:function (ret) {
            if(ret.result){
                window.location.reload();
            }else{
                alert(ret.msg)
            }
        },
        error:function (err,a,b) {
            alert("系统错误-update contest");
        }
    })
}
/**删除竞赛**/
function deleteContest(cid) {
    $.ajax({
        type:"POST",
        url:"/ServletContest",
        async:false,
        dataType:"json",
        data:{cid:cid,type:"delete"},
        success:function (ret) {
            if(ret.result){
                window.location.reload();
            }else{
                alert(ret.msg)
            }
        },
        error:function (err) {
            alert("系统错误-delete contest");
        }
    })
}



/***** 添加战绩 *****/
function addMatch() {
    $.ajax({
        type:"POST",
        url:"/ServletMatch",
        dataType:"json",
        data:$('#add-match').serialize()+"&"+$.param({"opertype":"add"}),
        success:function (ret) {
            if(ret.result){
                window.location.reload();
            }else{
                alert(ret.msg);
            }
        },
        error:function (err) {
            alert("系统错误-add match");
        }
    })
}
/***** 修改战绩 *****/
function updateMatch(mid) {

    $.ajax({
        type:"POST",
        url:"/ServletMatch",
        async:false,
        dataType:"json",
        data:$('#add-match').serialize()+"&"+$.param({"opertype":"update"})+"&"+$.param({"mid":mid}),
        success:function (ret) {
            if(ret.result){
                window.location.reload();
            }else{
                alert(ret.msg);
            }
        },
        error:function (err,a,b) {
            alert("系统错误-update match");
        }
    })
}
/**删除战绩**/
function deleteMatch(mid) {
    $.ajax({
        type:"POST",
        url:"/ServletMatch",
        async:false,
        dataType:"json",
        data:{mid:mid,opertype:"delete"},
        success:function (ret) {
            if(ret.result){
                window.location.reload();
            }else{
                alert(ret.msg);
            }
        },
        error:function (err) {
            alert("系统错误-delete match");
        }
    })
}


/*** 上传文件 *****/
function uploadFiles(inputid,type) {
    var formData=new FormData();
    formData.append("file",$('#'+inputid).prop('files')[0]);
    formData.append('type',type);
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
                if(type=="photo"){
                    $('#userPhoto').attr("src",ret.path);
                }else
                    window.location.reload();
            }else{
                alert(ret['msg']);
            }
        },
        error:function (err) {
            console.log("上传失败，请重试");
            alert("上传出错，请重试");
            // window.location.reload();
        }
    });

}

