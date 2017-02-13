/**
 * Created by LiuJie on 2016/3/14.
 */
;$(function(){
    operationRootController();
    operationChildController();
});

/**
 * 控制首页菜单权限权限方法
 */
function operationRootController(){
    //***加载首页菜单权限***//
    var roots = $.cookie("RETAIL_SYS_PRIVILEGE_ROOT")? $.parseJSON($.cookie("RETAIL_SYS_PRIVILEGE_ROOT")):null;
    if(roots && roots.length>0){
        for(var i = 0;i<roots.length;i++){
            var root = roots[i];
            if(root){
               var menu = $("#sys_menu").find("[menuName='"+root["controllerName"]+"_"+root["actionName"]+"']");
               if($(menu).is(":hidden")){
                   $(menu).show();
               }
            }
        }
    }

}
/**
 * 加载子页面的权限
 */
function operationChildController(fn,param){
    var childs = $.cookie("RETAIL_SYS_PRIVILEGE_CHILD")? $.parseJSON($.cookie("RETAIL_SYS_PRIVILEGE_CHILD")):null;
    //****加载子页面相关权限****//
    if(childs && childs.length>0){
        for(var c = 0;c<childs.length;c++){
            var child = childs[c];
            var op = $("[opId='"+child['opId']+"']");
            var tag_name;
            if(op && op.length>0){
                tag_name = $(op)[0].tagName;
            }
            if($(op).is(":hidden")){
                if(child['opId']=="4" || child['opId']=="5" ||child['opId']=="6" ||child['opId']=="7"){
                    if(param){
                        $(op).show();
                    }else{
                        $(op).css({"display":"block"});
                    }
                }else{
                    if(tag_name == "SPAN"){
                        $(op).css({"display":"block"});
                    }else{
                        $(op).show();
                    }

                }
            }
        }
    }
    if(fn && $.isFunction(fn)){
        fn();
    }
}


