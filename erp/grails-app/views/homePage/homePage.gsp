<!doctype html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>首页</title>
    <link rel="stylesheet" href="${resource(dir: 'home', file: 'css/common/common.css',base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'home', file: 'css/mainFrame/base.css', base: '..')}"
          type="text/css">

    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.1.11.3.min.js',base: '..')}"></script>
    <style>
    .op_root {
        display: none
    }

    @media screen and (max-device-height: 770px) {
        .wrap {
            max-height: 680px;
        }
    }

    @media screen and (max-device-width: 1024px) {
        .home-list {
            min-width: 0px;
            width: 42%;
        }
    }
    </style>
    <script type="text/javascript">
        $(function () {
            var height = $(window).height();
            $(".wrap").css({"height": (height - 0) + "px"});
            var width = $(window).width();
            $(".wrap").css({"width": (width - 0 - 5) + "px"});
//            $(".wrap-s").css({"width": (width - 50 - 40) + "px"});
//            $("h2.homePage-title").css({"width": (width - 100) + "px"});
            $(window).resize(function () {
                var height = $(window).height();
                $(".wrap").css({"height": (height - 0) + "px"});
                var width = $(window).width();
                $(".wrap").css({"width": (width - 0 - 5) + "px"});
//                $(".wrap-s").css({"width": (width - 50 - 40) + "px"});
//                $("h2.homePage-title").css({"width": (width - 100) + "px"});
            });
            //获取集中控制器信息
            %{--$.get("<g:createLink controller="home" action="queryTerminalData" base=".." />", null, function (data) {--}%
                %{--if (data) {--}%
                    %{--//debugger;--}%
                    %{--$("#todayTerminal").html(data["todayTerminal"]);--}%
                    %{--$("#todayOnlineTerminal").html(data["todayOnlineTerminal"]);--}%
                    %{--$("#todayOfflineTerminal").html(data["todayOfflineTerminal"]);--}%
                    %{--$("#onlineSale").html(data["onlineSale"]);--}%
                %{--}--}%
            %{--}, "json");--}%
            %{--//获取智能路灯信息--}%
            %{--$.post("<g:createLink base=".." controller="home" action="queryDeviceData"/>", null, function (data) {--}%
                %{--if (data) {--}%
                    %{--$("#todayDeviceTotal").html(data["todayDeviceTotal"]);--}%
                    %{--$("#normalDevice").html(data["normalDevice"]);--}%
                    %{--$("#warningDevice").html(data["warningDevice"]);--}%
                %{--}--}%
            %{--}, "json");--}%
            %{--//线损统计和总用电量统计--}%
            %{--$.post("<g:createLink base=".." controller="home" action="queryLossData"/>", null, function (data) {--}%
                %{--if (data) {--}%
                    %{--$("#todayLoss").html(data["todayLoss"]);--}%
                    %{--$("#yesterdayTotal").html(data["yesterdayTotal"]);--}%
                    %{--$("#yesterdaySale").html(data["yesterdaySale"]);--}%
                %{--}--}%
            %{--}, "json");--}%
            %{--//智能路灯用电量--}%
            %{--$.post("<g:createLink base=".." controller="home" action="queryDeviceTotalData"/>", null, function (data) {--}%
                %{--if (data) {--}%
                    %{--$("#yesterdayDevice").html(data["yesterdayDevice"]);--}%
                %{--}--}%
            %{--}, "json");--}%
            %{--//智能充电桩用电量--}%
            %{--$.post("<g:createLink base=".." controller="store" action="queryPillTotalData"/>", null, function (data) {--}%
                %{--data = data.data;--}%
                %{--if (data) {--}%
                    %{--$("#yesterdayPile").html(data["yesterdayPile"]);--}%
                %{--}--}%
            %{--}, "json");--}%
            %{--//广告牌用电量--}%
            %{--$.post("<g:createLink base=".." controller="home" action="queryBillTotalData"/>", null, function (data) {--}%
                %{--if (data) {--}%
                    %{--$("#yesterdayBound").html(data["yesterdayBound"]);--}%

                %{--}--}%
            %{--}, "json");--}%

        });
    </script>

</head>

<body>
<div class="wrap abs">
    <div class="fl home-list">
        <h2 class="home-title rel">
            <span class="home-tlt-icon abs"></span>
            <i class="abs icon arrows"></i>
            集中控制器概况
        </h2>

        <div class="home-box">
            <p class="home-box-con">
                <span class="tlt">总数量</span>
                <span class="nmb"><em id="todayTerminal">0</em>个</span>
            </p>
            <ul class="home-txt clearfix">
                <li>
                    <span class="tlt">在线</span>
                    <span class="nmb"><em id="todayOnlineTerminal">0</em>个</span>
                </li>
                <li>
                    <span class="tlt">离线</span>
                    <span class="nmb"><em id="todayOfflineTerminal">0</em>个</span>
                </li>
                <li class="no-border">
                    <span class="tlt">在线率</span>
                    <span class="nmb"><em id="onlineSale">90</em>%</span>
                </li>
            </ul>
        </div>
    </div>

    <div class="fl home-list home-list-sp">
        <h2 class="home-title rel">
            <span class="home-tlt-icon abs"></span>
            <i class="abs icon arrows"></i>
            智能路灯
        </h2>

        <div class="home-box">
            %{--<p class="home-box-con">--}%
                %{--<span class="tlt">当前安装智能路灯数量</span>--}%
            %{--</p>--}%
            <p class="home-box-con">
                <span class="tlt">当前安装智能路灯数量</span>
                <span class="nmb"><em id="todayDeviceTotal">0</em>个</span>
            </p>
            %{--<ul class="home-txt clearfix home-txt-con">--}%
                %{--<li>--}%
                    %{--<span class="nmb"><em id="sale0"></em>元</span>--}%
                    %{--<span class="tlt" id="goodsName0"></span>--}%
                %{--</li>--}%
                %{--<li>--}%
                    %{--<span class="nmb"><em id="sale1"></em>元</span>--}%
                    %{--<span class="tlt" id="goodsName1"></span>--}%
                %{--</li>--}%
                %{--<li class="no-border">--}%
                    %{--<span class="nmb"><em id="sale2"></em>元</span>--}%
                    %{--<span class="tlt" id="goodsName2"></span>--}%
                %{--</li>--}%
            %{--</ul>--}%
            <ul class="home-txt clearfix home-txt-bottom">
                <li>
                    <span class="tlt">正常</span>
                    <span class="nmb"><em id="normalDevice">0</em>个</span>
                </li>
                <li class="no-border">
                    <span class="tlt">异常</span>
                    <span class="nmb"><em id="warningDevice">0</em>个</span>
                </li>
            </ul>

            %{--<p class="function-btn">--}%
                %{--<a href="javascript:void(0)" class="add icon op_root" opId="2" onclick="addGoods()">增加新品</a>--}%
            %{--</p>--}%
        </div>
    </div>

    <div class="fl home-list home-list-cg">
        <h2 class="home-title rel">
            <span class="home-tlt-icon abs"></span>
            <i class="abs icon arrows"></i>
            线损统计
        </h2>

        <div class="home-box">
            <p class="home-box-con">
                <span class="tlt">线损统计</span>
                <span class="nmb"><em id="todayLoss">0</em>%</span>
            </p>
            <ul class="home-txt clearfix home-txt-bottom">
                <li>
                    <span class="tlt">总用电量</span>
                    <span class="nmb"><em id="yesterdayTotal">0</em>KW</span>
                </li>
                %{--<li>--}%
                    %{--<span class="no-border">抄读成功率</span>--}%
                    %{--<span class="nmb"><em id="yesterdaySale">321323</em></span>--}%
                %{--</li>--}%
                <li class="no-border">
                    <span class="tlt">抄读成功率</span>
                    <span class="nmb"><em id="yesterdaySale">0</em>%</span>
                </li>
            </ul>

        </div>
    </div>

    <div class="fl home-list home-list-kc">
        <h2 class="home-title rel">
            <span class="home-tlt-icon abs"></span>
            <i class="abs icon arrows"></i>
            智能路灯用电量
        </h2>

        <div class="home-box">
            <p class="home-box-con">
                <span class="tlt">智能路灯用电量</span>
                <span class="nmb"><em id="yesterdayDevice">0</em>KW</span>
            </p>
        </div>
    </div>

    <div class="fl home-list home-list-hy">
        <h2 class="home-title rel">
            <span class="home-tlt-icon abs"></span>
            <i class="abs icon arrows"></i>
            充电桩用电量
        </h2>

        <div class="home-box">
                <p class="home-box-con">
                    <span class="tlt">充电桩用电量</span>
                    <span class="nmb"><em id="yesterdayPile">0</em>KW</span>
                </p>
        </div>
    </div>

    <div class="fl home-list home-list-cx">
        <h2 class="home-title rel">
            <span class="home-tlt-icon home-tlt-icon-yygk abs"></span>
            <i class="abs icon arrows"></i>
            广告牌用电量
        </h2>

        <div class="home-box">
            <p class="home-box-con">
                <span class="tlt">广告牌用电量</span>
                <span class="nmb"><em id="yesterdayBound">0</em>KW</span>
            </p>
        </div>
    </div>

</div>
</body>
</html>