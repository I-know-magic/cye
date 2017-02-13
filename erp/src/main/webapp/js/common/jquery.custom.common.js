/**
 * Created by qiuyu on 2015/6/17.
 */
/**
 * 基于jquery拓展的工具方法
 */
;String.prototype.replaceAll = function(reallyDo, replaceWith) {
        return this.replace(new RegExp(reallyDo, ("gi")), replaceWith);
};
;(function($) {
    $.fn.extend({
        // 对jquery函数进行拓展,调用方式$().functionName([pararms])
        // 调用dom元素需要将其dom对象传递到函数内的算法写在这里,函数内部this指向调用的dom对象
        /**
         * 验证指定的处于编辑状态的表格，调用方式:
         * if(!$("#dataGridId").validateDataGrid()){
         *      return false;
         * }
         * @returns {boolean}
         */
        validateDataGrid:function(){
            var selector = this.selector;
            var rows = $(selector).datagrid("getRows");
            var isContinue = true;
            for(var i=0;i<rows.length;i++){
                var index =$(selector).datagrid("getRowIndex",rows[i]);
                $(selector).datagrid("beginEdit",index);
                if(!$(selector).datagrid("validateRow",index)){
                    isContinue =  false;
                    break;
                }else{
                    $(selector).datagrid("endEdit",index);
                }
            }
            return isContinue;
        },
        /**
         * 用于清除datagrid编辑对象的值
         * @param index
         */
        clearGridEditorValue:function(index){
            var gridSeletor=this.selector;
            var $edit= $(gridSeletor).datagrid('getEditors',index);
            for(var key in $edit){
                if($edit[key].type=="textbox"){
                    $($edit[key].target).textbox("setValue","");
                }
                if($edit[key].type=="numberbox"){
                    $($edit[key].target).numberbox("setValue","");
                }
                if($edit[key].type=="datebox"){
                    $($edit[key].target).datebox("setValue","");
                }
                if($edit[key].type=="combobox"){
                    $($edit[key].target).combobox("setValue","");
                }
                if($edit[key].type=="numberspinner"){
                    $($edit[key].target).numberspinner("setValue","");
                }
            }
        }
    });
    $.extend({
        // 对jquery本身进行拓展,调用方式$.functionName([params])
        // 没有必要传递调用对象本身的方法,纯工具算法写在这里this指向函数本身
        browser:function (type){
            var userAgent = navigator.userAgent.toLowerCase();
            switch (type) {
                case "isSafari":
                    return /webkit/.test(userAgent);
                case "isOpera":
                    return /opera/.test(userAgent);
                case "isMsie":
                    if (!!window.ActiveXObject || "ActiveXObject" in window)
                        return true;
                    else
                        return false;
                case "isMozilla":
                    return /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);
                default:
                    alert("无法识别检测的浏览器类型");
                    break;
            }
        },
        /**
         * 页面取url参数
         * @param key
         * @returns 传递的参数
         */
        getParameter:function(key,uri){
            var param_value="", url = uri?uri:window.location.href;
            if(url.indexOf("?") != -1){
                var param_ary = url.split("?")[1].split("&");
                for(var k in param_ary){
                    var param = param_ary[k];
                    if(param.split("=")[0] == key){
                        param_value = param.split("=")[1];
                        break;
                    }
                }
            }
            return param_value;
        },
        /**
         * 带面包线页面跳转
         * @param url 跳转链接
         * @param params 参数信息
         */
        redirect:function(url,params){
            var first_param = false;
            if(url.indexOf("?")==-1){
                url += "?";
                first_param = true;
            }else{
                if(url.indexOf("?") == url.length-1){
                    first_param = true;
                }
            }
            var _inner_param = {};
            if(typeof params == "string"){
                var params_ary = params.replaceAll("?","").split("&");
                for(var key in params_ary){
                    var k_v = params_ary[key].split("=");
                    _inner_param[k_v[0]] = _inner_param[k_v[1]];
                }
            }else if(typeof params == "object"){
                _inner_param = params;
            }
            var pos_info= $.getParameter("_position",window.location.href);
            if(_inner_param){
                if(_inner_param["_position"]){
                    _inner_param["_position"] = pos_info+","+encodeURI(encodeURI(_inner_param["_position"]));
                }else{
                    _inner_param["_position"] = pos_info;
                }
                if(_inner_param["_remove_position"]){
                    _inner_param["_position"] = _inner_param["_position"].replaceAll(encodeURI(encodeURI(","+_inner_param["_remove_position"])),"");
                }
                for(var key in _inner_param){
                    if(first_param){
                        first_param = false;
                        url += key+"="+_inner_param[key];
                    }else{
                        url += "&"+key+"="+_inner_param[key];
                    }
                }
                window.location.href = url;
            }
        }
    });
})(jQuery);