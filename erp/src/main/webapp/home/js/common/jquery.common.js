/**
 * Created by LiuJie on 2016/3/16.
 * 零售页面公共js方法
 */
/**
 * 跳转页面公共方法
 * @param url//参数跳转页面的url
 */
;String.prototype.replaceAll = function(reallyDo, replaceWith) {
    return this.replace(new RegExp(reallyDo, ("gm")), replaceWith);
};
;$(function(){
    //***ajax检测登录超时****//
    $.ajaxSetup({
        global: false,
        type: "POST",
        cache:false,
        complete: function (XMLHttpRequest, textStatus) {
            var data = XMLHttpRequest.getResponseHeader("SYS_TIME_OUT");
            var error = XMLHttpRequest.getResponseHeader("SYS_500_ERROR");
            if (data) {
                window.location.href = data;
            }
            if(error){
                window.open(error);
            }
        }
    });
    editableForInput();
});
function changeContent(url,fn,isOp){
    if(url==null){
        $("#content").empty();
    }else{
        $.ajax({
            type:"POST",
            url: url,
            dataType: "html",
            success:function(data){
                if(fn && $.isFunction(fn)){
                    fn();
                }
                $('#content').html(data);
                if(!isOp){
                    operationChildController();
                }

            }
        });
    }
}
/**
 * 选择商品
 */
function selectGoodsByDialog(){
    $(".selectGoodsByDialog")
}

function editableForInput(){
    $("input[editable='false']").attr("readonly","readonly");
}
;(function($){
    $.extend({
        /**
         * 封装通用加载 商品列表数据（用于库存、采购选择商品）
         * @param id
         * @param url
         */
        loadSelectedGoods:function(id,url){
            $("#"+id).dataTable({
                url:url,
                pagination:false,
                queryParams:{isStore:1},
                columns:[
                    {filed:"barCode",title:'商品条码'},
                    {filed:"goodsName",title:'商品名称'},
                    {filed:"unitName",title:'单位'}
                ]
            });
        },
        loadRoot:function(data){
            if(data && typeof (data) == "string"){
                var root = data.replaceAll("&quot;","\"");
                root = JSON.parse(root);
                var root_obj = root["root"] ? root["root"]:"";
                var root_child = root["child"] ? root["child"]:"";
                $.cookie("RETAIL_SYS_PRIVILEGE_ROOT", $.toJSON(root_obj),{path: "/"});
                $.cookie("RETAIL_SYS_PRIVILEGE_CHILD",$.toJSON(root_child),{path: "/"});
            }
        }
    });
})(jQuery);