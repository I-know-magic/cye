/**
 * Created by qiuyu on 2015/6/25.
 */
;(function($) {
    $.fn.extend({
        _template:{
            _menu_group://菜单组
                ""
                +"<div class='menu_min'>"
                +"</div>",
            _menu_one://一级菜单
                "<div class='bt-name'><a class='_menu_one_name' href='javascript:;'></a></div>",
            _menu_sec_group://二级菜单组
                ""
                +"<div class='sanjiao'></div>"
                +"<div class='new-sub'>"
                +   "<ul class='_menu_sec_here'>"
                +   "</ul>"
                +"<div class='tiggle'></div>"
                +"<div class='innertiggle'></div>"
                +"</div>"
                +"",
            _menu_sec:
                "<li><a href='javascript:;' class='_menu_sec_name'></a></li>"
        },
        _setting:{
            url : "",           //请求菜单的url
            queryParams:null,   //请求参数
            data : null,        //本地数据
            loadType :"local",  //加载方式:local加载本地数据,ajax请求数据
            pk:"id",            //数据主键
            name:"name",        //菜单名
            pId:"pId",          //父Id
            rootId:"",          //根id
            link:"url"          //菜单链接<暂时不需要>
        },
        createMenu:function(options){
            var dom = this;//要创建菜单的div对象
            //添加必要的class样式
            if(!dom.hasClass("btn3")){dom.addClass("btn3")};
            if(!dom.hasClass("clearfix")){dom.addClass("clearfix")};
            var opts = $.extend(this._setting,options);
            var loadType = opts.loadType;
            if(loadType=="ajax"){
                $.post(opts.url,opts.queryParams,function(data){
                    opts.data = data;
                    this._init(dom,opts);
                },"json");
            }else{
                this._init(dom,opts);
            }
        },
        _createOne:function(dom,data,opts){//创建一级菜单
            var $menu_group = $(this._template._menu_group);//菜单组
            $menu_group.attr("_menu_id",data[opts.pk])//记录此组是哪个一级菜单
            var $menu_one = $(this._template._menu_one);//一级菜单
            $menu_one.find("._menu_one_name").text(data[opts.name]);
            if(data.link){
                $menu_one.attr("_open_url",data.link);
                $menu_one.click(function(){
                    window.open($(this).attr("_open_url"));
                })
            }
            $menu_group.append($menu_one);
            dom.append($menu_group);
        },
        _createSecond:function(dom,data,opts){//创建二级菜单
            // 找到一级菜单组
            var $one_group = dom.find("[_menu_id='"+data[opts.pId]+"']");
            //在一级菜单组下查找是否存在二级菜单组
            var $sec_append = $one_group.find("._menu_sec_here");
            if($sec_append.length == 0){//还不存在
                var $sec_group = $(this._template._menu_sec_group);//二级菜单组
                $sec_append = $sec_group.find("._menu_sec_here");
                $one_group.append($sec_group);
            }
            var $menu_sec = $(this._template._menu_sec);//创建二级菜单
            $menu_sec.find("._menu_sec_name").text(data[opts.name]);
            if(data.link){
                $menu_sec.attr("_open_url",data.link);
                $menu_sec.click(function(){
                    window.open($(this).attr("_open_url"));
                })
            }
            $sec_append.append($menu_sec);
        },
        _init:function(dom,opts){//初始化菜单
            this._destory(dom);//初始化菜单时先清除对象
            var data = opts.data;
            //先创建一级菜单,再创建二级菜单
            for(var key in data){
                var menu_data = data[key];
                //如果父ID等于根ID说明是一级菜单
                if(menu_data[opts.pId] == opts.rootId){
                    this._createOne(dom,menu_data,opts);
                }
            }
            //完成一级菜单创建后再创建二级,否则二级菜单找不到菜单分组
            for(var key in data){
                var menu_data = data[key];
                //如果父ID不等于根ID说明是二级菜单
                if(menu_data[opts.pId] != opts.rootId){
                    this._createSecond(dom,menu_data,opts);
                }
            }
            this._bind_event(dom);
        },
        _destory:function(dom){//销毁菜单
            dom.empty();
        },
        _bind_event:function(dom){//给菜单绑定相应事件
            dom.find(".menu_min").click(function() {
                if ($(this).hasClass("cura")) {
                    $(this).children(".new-sub").hide(); //当前菜单下的二级菜单隐藏
                    $(".menu_min").removeClass("cura"); //同一级的菜单项
                } else {
                    $(".menu_min").removeClass("cura"); //移除所有的样式
                    $(this).addClass("cura"); //给当前菜单添加特定样式
                    $(".menu_min").children(".new-sub").slideUp("fast"); //隐藏所有的二级菜单
                    $(this).children(".new-sub").slideDown("fast"); //展示当前的二级菜单
                }
            });
        }
    });
})(jQuery);
