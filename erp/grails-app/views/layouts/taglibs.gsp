<!doctype html>
<html lang="en" class="no-js">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
        <title><g:layoutTitle default=""/></title>
        <script type="text/javascript">
            window.onerror=function(sMessage,sUrl,sLine){
                //alert(sMessage+"--line:"+sLine)
                return true;
            }
        </script>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!--  通用js css文件 -->
        <link type="text/css" rel="stylesheet" href="${resource(base:"..",dir: "resources",file:"bootstrap-3.3.4/dist/css/bootstrap.css?version=0.2.7" )}"/>
        <link type="text/css" rel="stylesheet" href="${resource(base:"..",dir: "resources",file:"css/common/css/base.css?version=0.3.8" )}"/>
        <script src="${resource(base:"..",dir:"resources",file:"js/common/jquery-2.1.3.js")}" type="text/javascript"></script>
        <script src="${resource(base:"..",dir:"resources",file:"bootstrap-3.3.4/dist/js/bootstrap.js")}" type="text/javascript"></script>
        <script src="${resource(base:"..",dir: "resources", file: "js/common/jquery.form.js")}" type="text/javascript"></script>
        <script src="${resource(base:"..",dir: "resources", file: "js/common/jquery.json.js")}" type="text/javascript"></script>
        <!-- 自定义时间工具类 -->
        <script src="${resource(base:"..",dir:"resources",file:"js/common/datetime.until.js")}"></script>
        <!-- 自定义通用工具类 -->
        <script src="${resource(base:"..",dir:"resources",file:"js/common/common_until.js?version=1.4.2")}"></script>
        <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js "></script>
        <!-- 时间选择控件专用,包含各种功能皮肤 -->
        <link href="${resource(base:"..",dir:"resources",file:"mobiscroll-master/css/mobiscroll.animation.css")}" rel="stylesheet" type="text/css" />
        <link href="${resource(base:"..",dir:"resources",file:"mobiscroll-master/css/mobiscroll.icons.css")}" rel="stylesheet" type="text/css" />
        <link href="${resource(base:"..",dir:"resources",file:"mobiscroll-master/css/mobiscroll.frame.css")}" rel="stylesheet" type="text/css" />
        <link href="${resource(base:"..",dir:"resources",file:"mobiscroll-master/css/mobiscroll.frame.ios.css")}" rel="stylesheet" type="text/css" />
        <link href="${resource(base:"..",dir:"resources",file:"mobiscroll-master/css/mobiscroll.scroller.css")}" rel="stylesheet" type="text/css" />
        <link href="${resource(base:"..",dir:"resources",file:"mobiscroll-master/css/mobiscroll.scroller.ios.css")}" rel="stylesheet" type="text/css" />
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.core.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.frame.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.scroller.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.util.datetime.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.datetimebase.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.datetime.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.select.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.listbase.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.image.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.treelist.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/mobiscroll.frame.ios.js")}"></script>
        <script src="${resource(base:"..",dir:"resources",file:"mobiscroll-master/js/i18n/mobiscroll.i18n.zh.js")}"></script>
        <script type="text/javascript">
            ;var replaceDate = false;//是否替换日期选择,营业日报只能选择当天的
            var isShowHeader = true;//是否显示头部
            var fixHeader = "";//设置固定的表头,当有固定表头时其他表头都失效
            var isShowDateSelector = true; //设定头部日期
            var only_month = false;//时间范围只能选择月份,当replaceDate时,此参数有效
            var searchDepartment = false;//是否显示部门检索条件
        </script>
        <g:layoutHead/>
        <script type="text/javascript">
            $(function(){
                var fixed_url = {
                    // 通用
                    type_sh : "<g:createLink base=".." controller="frontManageTenantInfo" action="index"/>",//账户信息
                    // 餐饮
                    type_rb : "<g:createLink base=".." controller="frontManageTableDay" action="index"/>",//营业日报
                    type_sy : "<g:createLink base=".." controller="frontManageTableQuick" action="details"/>",//收银汇总
                    type_pl : "<g:createLink base=".." controller="frontManageTableCategory" action="index"/>",//品类分析
                    type_dp : "<g:createLink base=".." controller="frontManageTableItemsGather" action="index"/>",//单品分析
                    type_sd : "<g:createLink base=".." controller="frontManageTableTimeInterval" action="index"/>",//时段汇总
                    // 零售
                    ls_type_rb : "<g:createLink base=".." controller="retailReport" action="yyrbIndex" />",//营业日报
                    ls_type_qs : "<g:createLink base=".." controller="retailReport" action="xsqsIndex" />",//销售趋势
                    ls_type_depqs: "<g:createLink base=".." controller="retailReport" action="bmqsIndex" />",//部门趋势
                    ls_type_dpqs : "<g:createLink base=".." controller="retailReport" action="dpqsIndex" />",//单品趋势
                    ls_type_skhz : "<g:createLink base=".." controller="retailReport" action="syhzIndex" />",//收银汇总
                    ls_type_sp   : "<g:createLink base=".." controller="retailReport" action="spcxIndex" />",//商品查询
                    ls_type_sdph : "<g:createLink base=".." controller="retailReport" action="sdphIndex" />"//时段排行
                };
                if(isShowHeader){
                    $("#_header").show();
                }
                $(".menu li").click(function(){
                    $(".menu li").removeClass("current");
                    $(this).addClass("current");
                    var url = fixed_url[$(this).attr("_type")];
                    Until.redirect(url)
                });
                if(!isShowDateSelector){
                    $("#_search_btn").hide();
                }
                var m_name = Until.getParameter("m_name");
                m_name = m_name?m_name:"${params.m_name}"
                if(m_name){
                    $("#_header_title").text(decodeURI(decodeURI(m_name)))
                }
                $("#_head_menu").click(function(){
                    $("#_menu").fadeToggle()
                })
                var startDate = Until.getParameter("beginDate");
                startDate = startDate?startDate:"${params.beginDate}"
                var endDate = Until.getParameter("endDate");
                endDate = endDate?endDate:"${params.endDate}"
                if(startDate){
                    if(replaceDate){
                        $("#_header_time").text(startDate);
                    }else{
                        if(only_month){
                            $("#_header_time").text(startDate.substring(0,7) + "至" + endDate.substring(0,7))
                        }else{
                            $("#_header_time").text(startDate + "至" + endDate)
                        }
                    }
                }else{
                    $("#_header_time").text("未选择任何日期");
                }
                if(fixHeader){
                    $("#_header_title").text(fixHeader);
                    $("#_header_time").text("");
                }
                $("#_search_btn").click(function(){
                    var params = {
                        _origin_url: window.location.href,
                        _replace_date: replaceDate,
                        _only_month:only_month,
                        _search_department:searchDepartment
                    };
                    Until.redirect("<g:createLink base=".." controller='frontManageCommon' action='select' />", params)
                });
                $(".changeShow").click(function(){
                    var _img_style = Until.getParameter("_img_style");
                    if(_img_style){
                        var params = Until.getParameter();
                        delete params["_img_style"]
                        Until.redirect(window.location.href.split("?")[0],params)
                    }else{
                        Until.redirect(window.location.href,{_img_style:true})
                    }
                })
            })
        </script>
    </head>
    <body style="overflow-x: hidden;">
        <div class="container-fluid navbar">
            %{--<div class="row navbar-fixed-top center-block" id="_header" style="display: none;">--}%
                %{--<div class="col-xs-12 col-sm-12">--}%
                    %{--<header class="head-wrap rel">--}%
                        %{--<span class="abs icon head-menu" id="_head_menu"></span>--}%
                        %{--<h2 class="head-title">--}%
                            %{--<p id="_header_title">全部数据</p>--}%
                            %{--<p class="head-time" id="_header_time"></p>--}%
                        %{--</h2>--}%
                        %{--<span class="abs icon head-day" id="_search_btn"></span>--}%
                    %{--</header>--}%
                %{--</div>--}%
            %{--</div>--}%
            %{--<div class="row navbar-fixed-top center-block" style="top: 60px;z-index: 9999;display: none;" id="_menu">--}%
            %{--<div class="col-xs-4 col-sm-4">--}%
                %{--<section class="menu">--}%
                    %{--<ul>--}%
                        %{--<!-- 餐饮报表 -->--}%
                        %{--<li class="rel" _type="type_rb" _cy>--}%
                            %{--<i class="menu-yyrb abs icon"></i>营业日报--}%
                        %{--</li>--}%
                        %{--<li class="rel" _type="type_sy" _cy>--}%
                            %{--<i class="menu-skhz abs icon"></i>收银汇总--}%
                        %{--</li>--}%
                        %{--<li class="rel" _type="type_pl" _cy>--}%
                            %{--<i class="menu-lbph abs icon"></i>品类分析--}%
                        %{--</li>--}%
                        %{--<li class="rel" _type="type_dp" _cy>--}%
                            %{--<i class="menu-dpph abs icon"></i>单品分析--}%
                        %{--</li>--}%
                        %{--<li class="rel" _type="type_sd" _cy>--}%
                            %{--<i class="menu-sdhz abs icon"></i>时段汇总--}%
                        %{--</li>--}%

                        %{--<!-- 通用数据 -->--}%
                        %{--<li class="rel" _type="type_aqsy" _common>--}%
                            %{--<i class="menu-aqsy abs icon"></i>安全收银--}%
                        %{--</li>--}%
                        %{--<li class="rel" _type="type_sh" _common>--}%
                            %{--<i class="menu-zhxx abs icon"></i>账户信息--}%
                        %{--</li>--}%
                    %{--</ul>--}%
                %{--</section>--}%
            %{--</div>--}%
        %{--</div>--}%
            <g:layoutBody/>
            <div class="_modal_here"></div>
        </div>
    </body>
</html>
