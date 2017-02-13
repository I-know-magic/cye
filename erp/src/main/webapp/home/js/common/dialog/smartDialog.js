/**
 * Created by LiuJie on 2016/2/25.
 * 关于零售的公共dialog组件
 */
;(function($){
    $.fn.extend({
        /**
         * dialog
         * @param options  参数
         * @param params
         */
        retailDialog:function(options){
            var $this=this.selector;
            var defaultParams={
                width:"",//dialog宽度
                height:"",//
                title:"New Dialog",//dialog标题
                content:"",//dialog内容
                href:"",//加载远程服务内容
                modal:false,//是否模态
                showButton:false,
                onShow:null,//dialog打开时事件
                onSure:null,//点击确定按钮事件
                onClose:null,//点击关闭、取消事件
                onBeforeSure:null,//点击确定前事件
                onBeforeClose:null//点击关闭前事件
            };
            $.dialogEvent.init(options,defaultParams,$this);
        }
    });
    $.extend({
        /**
         * 初始化dialog页面
         */
        template:{
            _black_template:'<div class="black_overlay"></div>',
            _template:'<div class="pop-up-box r_dialog" style="z-index: 10001">'
                        +'<h2 class="rel ">'
                        +    '<t class="r_title">'+'</t>'
                        +    '<span class="abs close icon r_close"></span>'
                        +'</h2>'
                        +'<div class="pop-up-box-txt r_content dialog_box_body" style="position: relative">'
                        +'</div>'
                        +'<div class="pop-up-box-btn r_btn">'
                        +'</div>'+
                      '</div>',
            button_template:'<button class="sure r_sure">确 定</button>'
                            +'<button class="r_close">取 消</button>'
        },
        /**
         * 用于dialog事件
         */
        dialogEvent:{
            /**
             * 初始化dialog
             * @param o
             * @param p
             * @param dom
             */
            init:function(o,p,dom){
               if(typeof (o)=="string"){
                   if(o=="open"){
                       $.dialogEvent.openDialog(dom);
                   }
                   if(o=="close"){
                       $.dialogEvent.closeDialog(dom);
                   }
               }
               if(typeof (o)=="object"){
                    var _dialog= $.template._template;//dialog模板
                    var this_dialog=$(dom).find(".r_dialog");
                    var param= $.extend(p,o);
                    if(this_dialog.length==0){
                        $(dom).append(_dialog);
                        this_dialog=$(dom).find(".r_dialog");
                        $(this_dialog).data("dialogParams",param);
                        $.dialogEvent.createDialog(dom,param);
                    }else{
                        var sessionParams=$(this_dialog).data("dialogParams");
                        param=sessionParams?function(){
                                            return  $.extend(sessionParams,o);
                                    }():function(){
                                        return $.extend(p,o);
                                    }();
                        $.dialogEvent.createDialog(dom,param);
                    }
               }

            },
            /**
             * 打开dialog
             */
            openDialog:function(dom_dialog){
                if($(".black_overlay").length == 0){
                    $("body").append($.template._black_template);
                }
                $(".black_overlay").show();
                $(dom_dialog).show();
            },
            /**
             * 关闭dialog
             */
            closeDialog:function(dom_dialog){
                $(".black_overlay").hide();
                $(dom_dialog).hide(function(){
                    if($(this).find("#error-box") && $(this).find("#error-box").length>0 ){
                        $(this).find("#error-box").remove();
                    }
                });
            },
            createDialog:function(dom,param){
                if(param){
                    if(param.showButton){
                        var button_html= $.template.button_template;
                        var _btn=$(dom).find(".r_btn");
                        if($(_btn).find("button").length==0){
                            $(_btn).append(button_html);
                        }
                    }
                    var _title=$(dom).find(".r_title");//标题
                    var _content=$(dom).find(".r_content");//内容
                    var _r_btn  =$(dom).find(".r_btn");//底部按钮区域
                    var _html=$(dom).find("#"+param.content+"");//写入dialog的内容
                    var _close=$(dom).find(".r_close");//关闭按钮
                    var _sure=$(dom).find(".r_sure");//确定按钮
                    var _height=param.height;
                    var _width=param.width;
                    var _onShow=param.onShow;//
                    var _onSure=param.onSure;//确定函数
                    var _onCancel=param.onClose;//关闭函数
                    $(_title).text(param.title);//写入dialog标题
                    if(_html){
                        $(_content).append(_html);//写入dialog内容
                    }
                    if(param.href){
                        var _url=param.href;
                        $.post(_url,null,function(data){
                            $(_content).html(data);
                        },"html")
                    }
                    if(_height){
                        $(_content).css({"max-height":_height,"overflow-y":"auto"});
                        $(_r_btn).css({"margin-top":"15px"});
                    }
                    if(_width){
                        $(_content).css({"width":_width});
                    }
                    //**********绑定点击确定函数******//
                    $(_sure).bind("click",function(){
                        //$.dialogEvent.closeDialog(dom);
                        if(_onSure&& $.isFunction(_onSure)){
                            _onSure();
                        }
                    });

                    //**********绑定点击取消函数******//
                    $(_close).bind("click",function(){
                        $.dialogEvent.closeDialog(dom);
                        if(_onCancel&& $.isFunction(_onCancel)){
                            _onCancel();
                        }
                    })

                }
            }
        },
        /**
         * alert消息框
         */
        message:{
            params:{
                title:'提示消息'
            },
            mould:'<div class="pop-up-box msg_alert" style="display: none;z-index: 10002">'
                    +'<h2 class="rel ">'
                    +    '<t class="msg_title">'+'</t>'
                    +    '<span class="abs close icon msg_close"></span>'
                    +'</h2>'
                    +'<div class="pop-up-box-txt msg_content">'
                    +'</div>'
                    +'<div class="pop-up-box-btn msg_btn">'
                    +'</div>'+
                    '</div>',
            btn_mould:'<button class="sure msg_sure">确 定</button>'
                        +'<button class="msg_close">取 消</button>',
            initMsg:function(){
                var msgTem= $.message.mould;
                var _alert=$("#content").find(".msg_alert");
                if(_alert.length==0){
                    $("#content").append(msgTem);
                }else{
                    $(_alert).remove();
                    $("#content").append(msgTem);
                }
            },
            alert:function(content,fn){
                $.message.initMsg();
                $(".msg_alert").find(".msg_title").text($.message.params.title);
                $(".msg_alert").find(".msg_content").html(content);
                $(".msg_close").bind("click",function(){
                    $(".msg_alert").hide();
                    if($.isFunction(fn)){
                        fn();
                    }
                });
                $(".msg_alert").show();
            },
            confirm:function(content,title,fn){
                $.message.initMsg();
                $(".msg_alert").find(".msg_title").text(title);
                $(".msg_alert").find(".msg_content").text(content);
                $(".msg_alert").find(".msg_btn").append($.message.btn_mould);
                $(".msg_close").bind("click",function(){
                    $(".msg_alert").hide();
                    if($.isFunction(fn)){
                        fn(false);
                    }
                });
                $(".msg_sure").bind("click",function(){
                    $(".msg_alert").hide();
                    if($.isFunction(fn)){
                        fn(true);
                    }
                });
                $(".msg_alert").show();

            }

        }
    })
})(jQuery);