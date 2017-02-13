/**
 * Created by LiuJie on 2016/5/9.
 */
;(function($){
    $.fn.smartTab = function(options,param){
            //tab设置参数
            var setting={};
            //传入初始tab参数
            var option ={
                width:'',//面板宽度
                height:'',//面板高度
                headerWidth:'',
                headerHeight:'',
                onSelect:null//点击tab选中事件
            };
            var tab_selector =this.selector;//this
            if(typeof (option) == "object"){
                var params = $.extend(option,options);
                smartTab.init(tab_selector,params);//初始化tab
            }
            if(typeof (option) == "string"){

            }
    }
})(jQuery);
//********tab對象*********//
var smartTab =function($){

        var tabHead_html = '<div class="tabHead">'
                            +'<ul>'
                            +'</ul>'
                            +'</div>';
        var tabBody_html = '<div class="tabBody"></div>';
        var tabObj = function(){
            this.selectedTab = [],//被选中的tab对象
            this.tabId = '',
            this.filedId = '',
            this.title = ''
        };

        /**
         * 点击切换tab事件
         * @param tab
         * @param option
         */
        function click_tab(tab,option){
            var $tab= $(tab).find(".tabHead").find("li");
            $tab.bind("click",function(){
                var tab_index = $(this).index();//获取索引
                var $tab_content_div = $(tab).find(".tabBody").children("div");
                var $selected_tab_div = $tab_content_div.filter("[filedId='tab"+tab_index+"']");
                $tab.removeClass("current");
                $(this).addClass("current");
                $tab_content_div.hide();
                $selected_tab_div.show();
                if(option){
                    if(option.onSelect && $.isFunction(option.onSelect)){
                        var tabOnSelect = option.onSelect;
                        var selectTab = new tabObj();
                        selectTab.selectedTab = $selected_tab_div;
                        selectTab.tabId = $selected_tab_div.attr("id");
                        selectTab.filedId = $selected_tab_div.attr("filedId");
                        selectTab.title = $selected_tab_div.attr("title");
                        tabOnSelect(selectTab);
                    }
                }
            })
        }
       return {
           /**
            * 初始化tab方法
            * @param tab: tab selector
            */
           init:function(tab,option){
                var tabs = $(tab).children("div").filter(":visible");
                if(tabs && tabs.length>0){
                    $(tabs).hide();
                    var $tabHead = $(tab).find(".tabHead");//获取tab的头部
                    var $tabBody = $(tab).find(".tabBody");//获取tab内容
                    if($tabHead && $tabHead.length>0){
                        $tabHead.remove();
                    }
                    if($tabBody && $tabBody.length>0){
                        $tabBody.remove();
                    }
                    $(tab).append(tabHead_html);
                    $(tab).append(tabBody_html);
                    $tabHead = $(tab).find(".tabHead");
                    $tabBody = $(tab).find(".tabBody");
                    var _li = "";
                    for(var i =0;i<tabs.length;i++){
                        var _tab_div = tabs[i];
                        var tab_title = $(_tab_div).attr("title");
                        $(_tab_div).attr("filedId","tab"+i);
                        if(i ==0){
                           _li +="<li class='current'>"+tab_title+"</li>";
                        }else{
                            _li +="<li>"+tab_title+"</li>";
                        }
                    }
                    $tabHead.find("ul").append(_li);
                    $tabBody.append(tabs);
                    $(tabs[0]).show();
                    click_tab(tab,option)
                }
           },
           getVisibleTab:function(){

           }
       }
}(jQuery);