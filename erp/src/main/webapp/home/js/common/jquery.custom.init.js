;$(function(){
    // 全局式生成导航面包线
    createPosLine();
    // 控制权限
    operationController();
    //更多操作实现
    more_operate();
    //f5刷新事件绑定
    f5Refrash();
    /**解决ie8、9浏览器 placeholder不兼容问题**/
    resolve_placeholder();
    /**实现点击回车键 进行查询以及表单换行**/
    enterSearch();
    /**初始化表单时第一个input应获取焦点**/
    initFormFocus();
    /** href=# 会导致页面刷新至top */
    replaceHref();
});
/**
 * <a href='#' onclick='fn()' /> 这种写法会导致在执行onclick事件的同时,是页面跳转至页面最顶端
 * 如果body正好存在overflow=auto,并且出现滚动条,操作体验会因此出现很大程度上的影响
 * 现在,通过此方法默认将href=#替换为,href=javascript:void(0),如有部分超链a确实需要使用href=#
 * 来实现页面交互效果,则通过属性 not_replace_href 禁用自动替换
 * not_replace_href 存在即为生效
 */
function replaceHref(){
    $("[href='#']:not([not_replace_href])").attr("href","javascript:void(0)");
}
function f5Refrash(){
    $("body").bind("keydown", function(event) {
        if (event.keyCode == 116) {
            window.location.reload();
            return false;
        }
        //全局性禁用退格按键
        //if(event.keyCode == 8){
        //    return false;
        //}
    });
}
/**
 * 页面左上角自动创建可点击的导航面包线,例如 商品档案-批量添加
 * 最后一级导航不能点击或者点击没有任何结果
 * 面包线需要与jquery.custom.common.js中的redirect方法配合使用
 */
function createPosLine(){
    var position = $.getParameter("_position");
    if(position){
        var pos = position.split(",");
        $(".js_header").empty();
        for(var key in pos){
            if(key==0){
                $(".js_header").append("<span>"+decodeURI(decodeURI(pos[key]))+"</span>");
            }else{
                $(".js_header").append("-<span>"+decodeURI(decodeURI(pos[key]))+"</span>");
            }
        }
    }

    var $line_p = $(".line").parent(), $line = $(".line").clone(true);
    $line_p.empty().append($line);
    var url_splits = window.location.href.split("?")[0].split("/");
    var key = "/"+ url_splits[url_splits.length-2] + "/" + url_splits[url_splits.length-1];
    var positions = $.cookie(key)? $.parseJSON($.cookie(key)):[]; // 当前页面cookies
    for(var i=0;i<positions.length;i++){
        var position_line = "<a href='"+positions[i]["url"]+"' >"+positions[i]["title"]+"</a>";
        $line_p.append(i==0?position_line:"-"+position_line);
    }
    $line_p.append((positions.length>0?"-":"") + "<a href='javascript:void(0)' style='cursor: default;'>"+$("title").text()+"</a>")
}
function operationController(){
    $(".js_other_op,[opId]").hide();
    var _op_object = $.cookie("_op_json")? $.parseJSON($.cookie("_op_json")):null;
    if(_op_object){
        for(var key in _op_object){
            $("[opId='"+_op_object[key]+"']").show();
            $("[opId='"+_op_object[key]+"']").attr("active","true");
        }
    }
    //$("[opId]:not([active])").hide();
    $(".js_other_op").each(function(i,e){
        //判断数量,如果有不受权限控制的直接显示
        if($(e).find("span:not([opId])").length>0){
            $(e).show()
        }else{
            //如果都有权限控制,判断可显示的数量
            if($(e).find("span[active]").length>0){
                $(e).show();
            }
        }
    })
    //此行被用来防止弹窗中的按钮样式被改变
    $("[iconCls]").removeAttr("style")
}
function more_operate(){
    $(".js_other_op").bind("click", function () {
        $(".js_op_div").is(":visible")?$(".js_op_div").slideUp(800):$(".js_op_div").slideDown(800);
    })
}
//阻止冒泡方法
function ban_bubbling(e){
    if(e && e.stopPropagation){
        e.stopPropagation();
    }
}
/**解决ie8、9浏览器 placeholder不兼容问题**/
function resolve_placeholder(){
    if($.browser("isMsie")){
        if(!("placeholder" in document.createElement("input"))){
            $("input").each(function(i,e){
                if($(e).attr("placeholder")){
                    var _placeholder=$(e).attr("placeholder");
                    if($(e).attr("type")==="password"){
                        $(e).attr("type","text");
                        $(e).val(_placeholder);
                        $(e).attr("is_password","true");
                    }else{
                        $(e).val(_placeholder);
                    }
                    $(e).css({"color":"#9b9fa1"});
                }
            })
            $("input").bind("focus",function(){
                if($(this).attr("placeholder")){
                    if($(this).val()==$(this).attr("placeholder")){
                        $(this).val("");
                        if($(this).attr("is_password")&&$(this).attr("is_password")=="true"){
                            $(this).attr("type","password");
                        }
                        $(this).css({"color":"black"});
                    }else{
                        $(this).css({"color":"black"})
                    }
                }
            })
            $("input").bind("blur",function(){
                if($(this).attr("placeholder")){
                    if($(this).val()==""){
                        if($(this).attr("type")==="password"){
                            $(this).attr("type","text");
                            $(this).val($(this).attr("placeholder"));
                            $(this).attr("is_password","true");
                        }else{
                            $(this).val($(this).attr("placeholder"))
                        }
                        $(this).css({"color":"#9b9fa1"});
                    }else{
                        $(this).css({"color":"black"});
                    }
                }
            })
        }
    }
}
/**
 * 实现点击回车键 进行列表查询以及表单切换input焦点
 *在input元素中加入名为 js_isFocus的class
 * 在查询按钮上加入名为 js_enterSearch的class
 */
function enterSearch(){
    $("body").bind("keypress",function(e){
        if(e.keyCode==13){
            $(".js_isFocus").is(":focus")?$(".js_enterSearch").click():addInputFocusByEnter()
        }
    })
}
/**
 * 实现表单 敲击回车切换input焦点
 * @returns {boolean}
 */
function addInputFocusByEnter(){
    var inputArray=[];
    var $input=$("form").find("input[type='text'],textarea");
    if($input&&$input.length>0){
        $($input).each(function(i,e){
            if($(e).css("display")!=="none" &&!$(e).attr("readonly")&&!$(e).attr("disabled")&&!$(e).parents("tr").is(":hidden")){
                inputArray.push(e);
            }
        });
    }
    var $focus_input=$("input[type='text']:focus,textarea:focus");
    if(inputArray.length>0){
        for(var key in inputArray){
            if($focus_input.length>0){
                var focusIndex= $.inArray($focus_input[0],inputArray)
                focusIndex++;
                if(!$(inputArray[focusIndex]).is(":focus")){
                    $(inputArray[focusIndex]).focus();
                    return false
                }
            }else{
                inputArray[0].focus();
                return false
            }
        }
    }
}
/**
 *初始化表单时第一个input应获取焦点
 */
function initFormFocus(){
    $("form").find(":input:visible:not([readonly],:disabled):first").focus()
}


