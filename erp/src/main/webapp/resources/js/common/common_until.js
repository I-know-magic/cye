/**
 * Created by qiuyu on 2015/6/17.
 */
/**
 * 基于jquery拓展的工具方法
 */
;String.prototype.replaceAll = function(reallyDo, replaceWith) {
        return this.replace(new RegExp(reallyDo, ("gi")), replaceWith);
};
var Until ={
    redirect:function(url, params){
        if(!url){ // 没有给定跳转链接时直接中断函数
            return false;
        }
        if(params){
            // 如果原来的url带有?将其原有参数拆分放入要携带的参数中
            if(url.indexOf("?") != -1){
                var paramStr = url.substr(url.indexOf("?")+1);// 截取参数
                //截取最原始url
                url = url.substr(0,url.indexOf("?"));
                if(paramStr){
                    var origin_params_obj = new Object();
                    var param_ary = paramStr.split("&");
                    for(var key in param_ary){
                        var e_p_a = param_ary[key].split("=");
                        origin_params_obj[e_p_a[0]] = e_p_a[1];
                    }
                    params = $.extend(origin_params_obj, params);
                }
            }
            url += "?";
            // 将参数拼装到url上
            var paramStr = "";
            for(var key in params){
                if(!params[key]){
                    continue;
                }
                if(key == "_origin_url"){
                    params[key] = params[key].replaceAll("\\?","{@@}");
                    params[key] = params[key].replaceAll("\\&","{@}");
                    params[key] = params[key].replaceAll("=","{{@}}");
                }
                if(paramStr){//其他参数
                    paramStr += "&"+key+"="+params[key];
                }else{//第一个参数
                    paramStr += key+"="+params[key];
                }
            }
            url += paramStr;
        }
        // 重定向浏览器链接
        window.location.replace(url);
    },
    /**
     * 获取url上拼接的参数
     * @param parameterName 要获取的参数的key(参数名)
     * parameterName 为空返回所有参数
     */
    getParameter:function(parameterName){
        var url = window.location.href;
        if(url.indexOf("?") != -1){
            // 请求上携带了参数
            var paramStr = url.substr(url.indexOf("?")+1);// 截取参数
            if(paramStr){
                var param_ary = paramStr.split("&");
                var param_obj = new Object();
                for(var key in param_ary){
                    var e_p_a = param_ary[key].split("=");
                    if (e_p_a[0] == "_origin_url") {
                        param_obj[e_p_a[0]] = e_p_a[1].replaceAll("{@@}", "?").replaceAll("{{@}}", "=").replaceAll("{@}", "&");
                    } else {
                        param_obj[e_p_a[0]] = e_p_a[1];
                    }
                }
                if (!parameterName) {
                    return param_obj;
                }
                return param_obj[parameterName];
            }
            return null;
        }
        return null;
    },

    /**
     * 生成随机颜色
     * @returns 16进制颜色字符串
     */
    getRandomColor:function(){
        return  '#' +
            (function(color){
                return (color +=  '0123456789abcdef'[Math.floor(Math.random()*16)])
                && (color.length == 6) ?  color : arguments.callee(color);
            })('');
    },
    /**
     * 消息组件
     */
    message: {
        _template://拟态模板
        "<div class='modal fade _modal_plugin_div' id='_alert_modal' tabindex='-1' role='dialog' aria-labelledby='_alert_model' aria-hidden='true'>"
        + "<div class='modal-dialog'>"
        + "<div class='modal-content'>"
        + "<div class='modal-header'>"
        + "<button type='button' class='close' data-dismiss='modal' aria-label='Close'>"
        + "<span aria-hidden='true'>&times;</span>"
        + "</button>"
        + "<h4 class='modal-title' id='_alert_modal_title'></h4>"
        + "</div>"
        + "<div class='modal-body' id='_alert_modal_text'></div>"
        + "<div class='modal-footer' id='_alert_modal_btn'>"
        + "<button type='button' class='btn btn-primary' id='_alert_modal_ok' data-dismiss='modal'>确定</button>"
        + "</div>"
        + "</div>"
        + "</div>"
        + "</div>"
        + "<div class='_modal_plugin_a_div' style='display: none;'><a id='_modal_plugin_a' data-toggle='modal' data-target='#_alert_modal' href='javascript:void(0)'></a></div>",
        _default: {
            url: "",                    //请求拟态框内容
            title: "提示消息",          //标题
            content: "",                //消息体
            queryParams: null            //请求参数
        },
        /**
         *
         * @param content 拟态消息体[str,dom]
         * @param title 消息头[str,dom]
         * @param options
         */
        alert: function (content, title,fn) {
            this._destory();
            var $modal_div = this._init();
            var $modal_title = $modal_div.find("#_alert_modal_title");
            var $modal_text = $modal_div.find("#_alert_modal_text");
            this._write_info($modal_title, title ? title : "提示消息");
            this._write_info($modal_text, content);
            var $modal_btn_div = $modal_div.find("#_alert_modal_btn");
            var $ok_btn = $modal_btn_div.find("#_alert_modal_ok");
            $ok_btn.click(function(){
                if(fn){
                    fn()
                }
            });
            $("#_modal_plugin_a").click();
        },
        /**
         *
         * @param content 消息体
         * @param title 标题
         * @param fn 回调函数
         */
        confirm:function(content,title,fn){
            var $modal_div = this._init();
            var $modal_title = $modal_div.find("#_alert_modal_title");
            var $modal_text = $modal_div.find("#_alert_modal_text");
            this._write_info($modal_title, title ? title : "确认消息");
            this._write_info($modal_text, content);
            var $modal_btn_div = $modal_div.find("#_alert_modal_btn");
            $modal_btn_div.find("button:not(#_alert_modal_ok)").remove();
            var $ok_btn = $modal_btn_div.find("#_alert_modal_ok");
            var $cancel_btn = $("<button type='button' class='btn btn-default' data-dismiss='modal'>取消</button>");
            $cancel_btn.click(function(){
                if(fn){
                    fn(false);
                }
            });
            $ok_btn.click(function(){
                if(fn){
                    fn(true)
                }
            });
            $ok_btn.after($cancel_btn);
            $("#_modal_plugin_a").click();
        },
        /**
         *
         * @param options 设置
         */
        modal: function (options) {
            var $modal_div = this._init();
            var $modal_title = $modal_div.find("#_alert_modal_title");
            var $modal_text = $modal_div.find("#_alert_modal_text");

            var opt = $.extend(this._default, options);
            this._write_info($modal_title, opt.title);
            if (opt.url) {
                $.get(opt.url, opt.queryParams, function (data) {
                    this._write_info($modal_text, $(data));
                    this._show();
                });
            } else {
                this._write_info($modal_text, opt.content);
                this._show();
            }
        },
        _show: function () {
            $("#_modal_plugin_a").click();
        },
        _write_info: function (des, info) {// 生成消息
            if (info) {
                des.empty();
            }
            if (typeof info == "object") {
                des.append($(info));
            } else {
                des.html(info);
            }
        },
        _init: function () {// 初始化拟态消息
            var $template = $("._modal_plugin_div");
            if ($template.length == 0) {
                $template = $(this._template);//模板
                $("._modal_here").append($template);
            }
            return $template;
        },
        _destory: function () {// 销毁拟态窗口
            $("._modal_plugin_a_div,._modal_plugin_div").remove();
        }
    },
    /**
     * 想指定元素中写入数据,需要自定义属性以及数据类型
     * dataType数据类型必须存在,不存在则视其为文本
     * @param property 自定义在dom上的数据对象javabean的属性
     * @param data 要填充的数据
     */
    writeData:function(property,data){
        var $dom = $("["+property+"='"+property+"']");
        var dataType = $dom.attr("dataType");
        dataType = dataType?dataType:"text";
        switch (dataType){
            case "number":
                $dom.text((data?data:0).toFixed(2))
                break;
            case "rate":
                $dom.text((data?data:0).toFixed(2) + "%");
                break;
            case "text":
                $dom.text(data?data:"");
                break;
        }
    }
}