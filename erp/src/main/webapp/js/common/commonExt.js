/**
 * Created by Administrator on 2015/7/18.
 */
/**
 * 初始化artDialog
 * @param title
 * @param text
 * @param w
 * @param h
 * @param modal  //boolean,true模态,false非模态
 * @param fn
 */
function _init_dialog(title,text,w,h,modal,fn){
    var _init_dialog=dialog({
        title:title,
        content:text,
        width:w,
        height:h,
        button:[
            {
                value:"已完成支付",
                callback:function(){
                    //TODO
                    if(fn){

                    }
                },
                autofocus: true
            },
            {
                value:"支付遇到问题",
                callback:function(){
                    //TODO
                }
            }
        ]
    })
    if(modal===true){
        _init_dialog.showModal();
    }

}
/**
 * 得到分页数据
 * @param total  总数
 * @param rows 每页显示的数据
 */
function getPageObj(total,rows){
    var pageIndex=0;
    if(total<=rows){
        $("#pageDiv").find(".first_li").after("<li pageId='page0'><a href='javascript:void(0)' pageValue='1' class='pageA' onclick='selectPage(this)'>1</a></li>");
    }else{
        if(total%rows==0){
            pageIndex=total/rows;
            for(var i=1;i<=pageIndex;i++){
                if(i==1){
                    $("#pageDiv").find(".first_li").after("<li pageId='page"+i+"'><a href='javascript:void(0)' pageValue='"+i+"'  class='pageA' onclick='selectPage(this)'>"+i+"</a></li>");
                }else{
                    var p=i-1;
                    $("#pageDiv").find("[pageId='page"+p+"']").after("<li pageId='page"+i+"'><a href='javascript:void(0)' pageValue='"+i+"'  class='pageA' onclick='selectPage(this)'>"+i+"</a></li>");
                }
            }
        }
        else{
            pageIndex=Math.ceil(total/rows);
            for(var i=1;i<=pageIndex;i++){
                if(i==1){
                    $("#pageDiv").find(".first_li").after("<li  pageId='page"+i+"'><a href='javascript:void(0)' pageValue='"+i+"' class='pageA' onclick='selectPage(this)'>"+i+"</a></li>");
                }else{
                    var p=i-1;
                    $("#pageDiv").find("[pageid='page"+p+"']").after("<li pageId='page"+i+"'><a href='javascript:void(0)' pageValue='"+i+"' class='pageA'  onclick='selectPage(this)'>"+i+"</a></li>");
                }
            }
        }
    }

}
/**
 * 公共消息提示框
 * @param text  提示文本
 * @param w  消息框宽，默认120px
 * @param h  消息框高，默认30px
 * @param fn 消息框关闭函数，用户自定义
 * @param isClose 定义鼠标点击任何位置是否关闭消息框，用户自定义,0 可以关闭  1不可以关闭
 */
function msgDialog(text,w,h,fn,isClose){
    var width=120;
    var height=50;
    var isQuickClose=true;
    if(w&&h){
        width=w;
        height=h;
    }
    if(isClose&&isClose==1){
        isQuickClose=false;
    }
    var msg_D = dialog({
        title: '提示信息',
        width:width,
        height:height,
        content:text,
        quickClose: isQuickClose,
        onclose: function () {
            if(fn){
                fn();
            }
        }
    });
    msg_D.show();
    setTimeout(function () {
        msg_D.close().remove();
    }, 5000);
}
