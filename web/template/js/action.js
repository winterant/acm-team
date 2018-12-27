

/***回车直接执行事件，点击id***/
function enterToClick(id) {
    id='#'+id;
    if(event.keyCode == "13"){  //回车
        $(id).click();
    }
}



/***模态框**/
function overlay(back,swing) {
    var time=300;
    back='#'+back;
    swing='#'+swing;
    if($(back).is(':hidden')) {
        $(back).fadeIn(time);
        $(swing).slideDown(time);
    }else {
        $(swing).slideUp(time);
        $(back).fadeOut(time);
    }
}

/*把添加竞赛功能，转化成修改竞赛功能*/
function toUpdate(id,cid,platform,title,mainText,startTime,lenms,url) {
    document.getElementById(id).setAttribute("onclick","updateContest("+cid+")");

    var amd=document.getElementById('addModSelect');
    for(i=0;i<amd.length;i++)amd[i].selected=false;
    amd[platform].selected=true;
    $("input[name=title]").val(title);
    $("textarea[name=mainText]").val(mainText.replace(/\<br>/g,"\r\n"));
    $("input[name=startTime]").val(startTime);
    var hours=Math.floor(lenms/(1000*60*60));
    var mins=Math.floor(lenms/(1000*60)%60);
    $("input[name=length]").val(hours+(mins<10?':0':':')+mins);
    $("input[name=url]").val(url);
}
function toAdd(id) {
    document.getElementById(id).setAttribute("onclick","addContest()");

    $("input[name=title]").val('');
    $("textarea[name=mainText]").val('');
    $("input[name=length]").val('5:00');
    $("input[name=url]").val('');
}


/******以下是在比赛战绩界面用的*******/
/*把添加竞赛功能，转化成修改竞赛功能*/
function toUpdateMatch(id,cid,type,title,date,gold,silver,bronze,fine,newsid) {
    document.getElementById(id).setAttribute("onclick","updateMatch("+cid+")");

    var amd=document.getElementById('addModSelect');
    for(i=0;i<amd.length;i++)amd[i].selected=false;
    amd[type].selected=true;
    $("input[name=title]").val(title);
    $("input[name=date]").val(date);
    $("input[name=gold]").val(gold);
    $("input[name=silver]").val(silver);
    $("input[name=bronze]").val(bronze);
    $("input[name=fine]").val(fine);
    $("input[name=newsid]").val(newsid);
}
function toAddMatch(id) {
    document.getElementById(id).setAttribute("onclick","addMatch()");

    $("input[name=title]").val('');
    $("input[name=gold]").val('');
    $("input[name=silver]").val('');
    $("input[name=bronze]").val('');
    $("input[name=fine]").val('');
    $("input[name=newsid]").val('');
}


/*****给select标签设置选中的option*******/
function selectOption(id,value) {
    var sta=document.getElementById(id);
    for(var i=0;i<sta.options.length;i++){
        if(sta.options[i].value==value){
            sta.options[i].selected = true;
        }
    }
}


//格式化时间 2000-01-01 12:00:00
function formatDate(date) {
    var year = date.getFullYear(),
        month = date.getMonth() + 1,//月份是从0开始的
        day = date.getDate(),
        hour = date.getHours(),
        min = date.getMinutes(),
        sec = date.getSeconds();
    var newTime = year + '-' +
        (month<10?'0':'')+month + '-' +
        (day<10?'0':'')+day + ' ' +
        (hour<10?'0':'')+hour + ':' +
        (min<10?'0':'')+min + ':' +
        (sec<10?'0':'')+sec;
    return newTime;
}

function goToTop() {
    $('html,body').animate({scrollTop:$('body').offset().top}, 200);
}