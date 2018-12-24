
/*功能：单击按钮弹出下拉菜单dropdown*/
/* 点击id按钮，下拉菜单dropdown在 显示/隐藏 之间切换 */
function dropShow(id) {
    if($('#'+id).is(':visible')){
        classSlideUp('dropdown');
    }else{
        classSlideUp('dropdown'); //先关掉其他元素
        $('#'+id).slideDown(200);
    }
}

// 点击下拉菜单按钮dropbtn以外区域隐藏dropdown区域，在header.jsp用到，rankPage.jsp
window.onclick = function(event) {
    if (!event.target.matches('.dropbtn')) {
        classSlideUp('dropdown');
    }
}

/**** className类隐藏，display:none*****/
function classSlideUp(className) {
    $('.'+className).each(function (i) {
        $(this).slideUp(200);
    });
}

/***** 小屏幕 ******/
function showMenu(id) {
    if($('#'+id).is(':hidden')){
        $('#'+id).slideDown(300);
    }else{
        $('#'+id).slideUp(300);
    }
}