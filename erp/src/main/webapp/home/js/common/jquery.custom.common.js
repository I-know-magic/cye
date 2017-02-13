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
    $.fn.modelDialog = function(method,params) {
        return $.fn.modelDialog.methods[method](this,params)
    };
    $.fn.modelDialog.methods = {
        _shadow_template : {
            _dom : "<div class='popup-box-shadow'></div>",
            _css : {
                "background-color":"#52585b",
                "position":"absolute",
                "z-index":9000,
                "display":"none",
                "width":"100%",
                "height":"100%",
                "opacity":"0.5",
                "filter": "alpha(opacity=50)",
                "-moz-opacity": "0.5",
                "margin": "0px",
                "left": "0px",
                "top": "0px",
                "right": "0px",
                "bottom": "0px"
            }
        },
        /**
         * 在父页面上初始化遮罩
         * @returns {div}
         */
        _init : function(){
            var $shadow_div = $(document).find(".popup-box-shadow");
            if($shadow_div.length == 0){
                $shadow_div = $(this._shadow_template._dom).css(this._shadow_template._css);
                $(document).find("body").append($shadow_div);
            }
            return $shadow_div;
        },
        open : function(jq){
            var selector = jq.selector;
            var $shadow_div = $.fn.modelDialog.methods._init();
            $(selector).show();
            $("body").css({
                "overflow":"hidden"
            });
            $shadow_div.css({
                "top":$("body").scrollTop()+"px"
            });
            $shadow_div.show();
        },
        close : function(jq){
            var selector = jq.selector;
            var $shadow_div = $.fn.modelDialog.methods._init();
            $(selector).hide();
            $shadow_div.hide();
            $("body").css("overflow","auto");
        }
    };
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
         * 页面之间的跳转,跳转过程中通过cookie缓存记录跳转路径信息
         * @param url 跳转链接
         * @param params 参数信息
         */
        redirect:function(url,params){
            if(url.indexOf("?")==-1 || url.indexOf("?") == url.length-1){
                // 如果给定的url中不存在 ? <追加一位> 或者 ?为当前url的最后一位
                // 为方便参数拼接,在当前url不存在参数时,拼接一个无意义的参数
                url = url.replaceAll("\\?","") + "?p=v";
            }
            if(params){ // 如果params存在
                if(typeof params == "string"){
                    // 当params为string类型时,替换参数中的?防止传递的参数为?key=value
                    // 并将参数直接拼接到要跳转的url中
                    url += "&" + params.replaceAll("?","")
                }else if(typeof params == "object"){
                    // 当params为object对象时,则循环拼接参数
                    for(var key in params){
                        // 每一个参数都用&key=value拼接到url的最后
                        url += "&" + key + "=" + params[key];
                    }
                }
            }

            var params_ary = url.split("?").length>1?url.split("?")[1].split("&"):[];
            var _inner_param = {};
            for(var key in params_ary){
                var k_v = params_ary[key].split("=");
                _inner_param[k_v[0]] = _inner_param[k_v[1]];
            }
            var pos_info= $.getParameter("_position",window.location.href);
            if(_inner_param["_position"]){
                _inner_param["_position"] = pos_info+","+encodeURI(encodeURI(_inner_param["_position"]));
            }else{
                _inner_param["_position"] = pos_info;
            }
            if(_inner_param["_remove_position"]){
                _inner_param["_position"] = _inner_param["_position"].replaceAll(encodeURI(encodeURI(","+_inner_param["_remove_position"])),"");
            }

            url += "&" + "_position" + "=" + _inner_param["_position"];

            // 在跳转之前,记录上一个页面的流转信息,依赖于jquery.cookie.js

            // 获取当前页面的cookies,key为当前页面的url,cookies存放的进入当前页面时的导航信息
            var current_url = window.location.href; // 当前页面url
            var positions = $.cookie(current_url)? $.parseJSON($.cookie(current_url)):[]; // 当前页面cookies
            var is_cookie_append = true; // 是否追加新的cookies信息
            for(var key in positions){
                var position = positions[key];
                // 判断即将要跳转的url是否已经为导航中存在的
                if(position["url"] == url){
                    is_cookie_append = false;
                }
            }
            if(is_cookie_append){
                positions[positions.length] = {title : $("title").text(), url : current_url};
                var url_splits = url.split("?")[0].split("/");
                var key = "/"+ url_splits[url_splits.length-2] + "/" + url_splits[url_splits.length-1];
                $.cookie(key, $.toJSON(positions),{path : "/"})
            }

            // 页面跳转,如果想防止浏览器回退,则这里可以使用window.location.replace(url);
            // window.location.replace(url);
            window.location.href = url;
        }
    });
})(jQuery);