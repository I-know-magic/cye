<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    %{--<meta name="layout" content="taglibs"/>--}%
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>图表</title>
    <style type="text/css">
    .title {
        width: 120px;
    }
    .search-width{
        width: 50px;width: 106px \9;
    }
    .search-txt-width{
        width: 170px;
    }
    .search-date {
        right: 60px;
        font-size: 11px;
        color: #979a9b;
        top: 4px;
    }
    </style>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'ztree-cus.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'combox-cus.js',base: '..')}"></script>
    <script src="${resource(base:"..",dir:"resources",file:"js/common/common_until.js?version=1.4.2")}"></script>
    <script src="${resource(base:"..",dir:"resources",file:"highcharts-4.1.8/js/highcharts.js")}" type="text/javascript"></script>
    <script src="${resource(base:"..",dir:"resources",file:"highcharts-4.1.8/js/themes/grid-light.js?version=0.1.2")}" type="text/javascript"></script>

    <link rel="stylesheet" href="${resource(dir: 'js', file: 'datePicker/jquery-ui-timepicker.css', base: '..')}"
          type="text/css">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'datePicker/jquery-ui.js', base: '..')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'datePicker/jquery-ui-timepicker-addon.js', base: '..')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'datePicker/ftrend.datepicker.js', base: '..')}"></script>
    <script type="text/javascript">
        var orderTable;
        var url;
        var nodes_delId = [];
        var oneCode;//一级分类编码
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height":(height-40-24-20-8-($.browser("isMsie")?0:70))+"px"});
            url='<g:createLink base=".." controller='baseArea' action='loadZTreeTerminal'/>';
            init_tree('id','baseAreaPid','baseAreaName',false,url,fn_clickTree);
            loadMyTree(url);
            var date_7=new DateTimeUntil();
            dateTimePicker = new dateTimePicker({
                container: $('#dateTimeRangeBox'),
                defaultDateTime: [$.dateFormat(date_7.getBeforeDate(6), "yyyy-MM-dd") + ' 00:00', $.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59']
            });


            var params = Until.getParameter();
            $("#container").css({height:($(window).height()-168-8-105)+"px"});
            $(".data_light").hide();
            drawChart([],[],[],[],[]);
//            createChart("用电量分析");
        });
        var fn_clickTree=function clickTree(event, treeId, treeNode) {
            createChart('用电量分析',event, treeId, treeNode)

        }
        function createChart(prodType,event, treeId, treeNode){
            var params = Until.getParameter();
            params["u_name"] = prodType;
            if(treeNode.isArea==1){
                var baseAreaName=treeNode.baseAreaName;
                var baseAreaId=treeNode.tid;
                var startTime = $("input[id*='begin']").val();
                var endTime = $("input[id*='end']").val();
                var url = "<g:createLink base=".." action="findLoss" controller="chart" />?qryLogicaddr="+baseAreaName+"&startTime="+startTime+"&endTime="+endTime;
                $.get(url,params,function(data){
                    var categories = [];
                    //zones 不同区间颜色不同 默认针对Y轴 zoneAxis: 'x' 可更改为x轴
//                var seriesData =
//                {name:"线损-1",data:[], zoneAxis: 'x',zones: [{
//                    value: 3,
//                    color: '#f7a35c',
//                    dashStyle: 'dot'
//                }, {
//                    value: 5,
//                    color: '#7cb5ec'
//                }, {
//                    color: '#90ed7d'
//                }]};
                    //线的样式不同
                    var total_e  = {name:"总用电量",data:[],dashStyle: 'longdash'};//条形样式
                    var light_part_e = {name:"智能路灯用电量",data:[],dashStyle: 'longdash'};//条形样式
                    var pile_part_e = {name:"智能充电桩用电量",data:[],dashStyle: 'longdash'};//条形样式
                    var bill_part_e = {name:"智能广告牌用电量",data:[],dashStyle: 'longdash'};//条形样式
                    $(".data_light").show();
                    $(".data_light_hide").hide();
                    if(data){

                        for(var key in data){
                            if(key==0){

                                $("#prt_date").text(data[key]["prt_date"]);
                                $(".u_percent").textdata([key]["u_percent"]);
//                                $("._top10_percent").text((top10/(sum==0?1:sum) *100).toFixed(2)+"%");
                            }
                            categories.push(data[key]["btime"]);
                            total_e["data"].push(data[key]["total_e"])
                            light_part_e["data"].push(data[key]["light_part_e"])
                            pile_part_e["data"].push(data[key]["pile_part_e"])
                            bill_part_e["data"].push(data[key]["bill_part_e"])
                        }
                        drawChart(categories,total_e,light_part_e,pile_part_e,bill_part_e);
                    }
                },"json")
            }else {
                $.messager.alert("系统提示", "请选择集中器查询！", "warning");
            }

        }
        %{--function createChart(prodType){--}%
            %{--var params = Until.getParameter();--}%
            %{--params["u_name"] = prodType;--}%
            %{--var url = "<g:createLink base=".." action="findLoss" controller="chart" />";--}%
            %{--$.get(url,params,function(data){--}%
                %{--var categories = [];--}%
                %{--//zones 不同区间颜色不同 默认针对Y轴 zoneAxis: 'x' 可更改为x轴--}%
%{--//                var seriesData =--}%
%{--//                {name:"线损-1",data:[], zoneAxis: 'x',zones: [{--}%
%{--//                    value: 3,--}%
%{--//                    color: '#f7a35c',--}%
%{--//                    dashStyle: 'dot'--}%
%{--//                }, {--}%
%{--//                    value: 5,--}%
%{--//                    color: '#7cb5ec'--}%
%{--//                }, {--}%
%{--//                    color: '#90ed7d'--}%
%{--//                }]};--}%
                %{--//线的样式不同--}%
                %{--var total_e  = {name:"总用电量",data:[],dashStyle: 'longdash'};//条形样式--}%
                %{--var light_part_e = {name:"智能路灯用电量",data:[],dashStyle: 'longdash'};//条形样式--}%
                %{--var pile_part_e = {name:"智能充电桩用电量",data:[],dashStyle: 'longdash'};//条形样式--}%
                %{--var bill_part_e = {name:"智能广告牌用电量",data:[],dashStyle: 'longdash'};//条形样式--}%
                %{--if(data){--}%
                    %{--for(var key in data){--}%
                        %{--categories.push(data[key]["btime"]);--}%
                        %{--total_e["data"].push(data[key]["total_e"])--}%
                        %{--light_part_e["data"].push(data[key]["light_part_e"])--}%
                        %{--pile_part_e["data"].push(data[key]["pile_part_e"])--}%
                        %{--bill_part_e["data"].push(data[key]["bill_part_e"])--}%
                    %{--}--}%
                    %{--drawChart(categories,total_e,light_part_e,pile_part_e,bill_part_e)--}%
                %{--}--}%
            %{--},"json")--}%
        %{--}--}%
        function drawChart(categories,total_e,light_part_e,pile_part_e,bill_part_e){
            if(total_e==''){
                total_e  = {name:"总用电量",data:[],dashStyle: 'longdash'};//条形样式
                light_part_e = {name:"智能路灯用电量",data:[],dashStyle: 'longdash'};//条形样式
                pile_part_e = {name:"智能充电桩用电量",data:[],dashStyle: 'longdash'};//条形样式
                bill_part_e = {name:"智能广告牌用电量",data:[],dashStyle: 'longdash'};//条形样式

            };
            $('#container').highcharts({
                chart: {
                        type: 'column'
                },
                title: {
                    text: '用电量分析',
                    align: "right",
                    style:{ "color": "#adb3b3", "fontSize": "13px" }
                },
                xAxis: {
                    categories: categories
                },
                yAxis: {
                    title: {
                        text: 'KW'
                    },
                    min:0,
                    plotLines: [{
                        value: 0,
                        width: 1,
                        color: '#808080'
                    }]
                },
//                //可显示具体值
                plotOptions: {
                    column: {
                        dataLabels: {
                            enabled: true
                        }
                    }
                },
                tooltip: {
                    headerFormat: "<span style='font-size: 22px'>{point.key}</span><br/>",
                    pointFormat : "{series.name}:<b>{point.y} w"
                },
                legend: {
                    enabled:true
                },
                credits: {
                    enabled: false
                },
                series: [total_e,light_part_e,pile_part_e,bill_part_e]
            });
        }

        function doSearch() {
            $("#mainGrid").datagrid({
                queryParams: {
                    codeName: $("#queryStr").val()
                }
            });
        }
        function clearSearch(){
            $("#queryStr").val("");
        }
        function cleardata() {
            formclear("myForm")
        }
    </script>
</head>

<body>
<h3 class="rel ovf  js_header">
    <span></span>
    -
    <span></span>
</h3>

<div class="rel clearfix function-btn">
    <p class="search-date search-date-position abs"><a id="dateTimeRangeBox"></a></p>
    <p  class="search search-width abs">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
    </p>
</div>

<div class="table-list">
    <div class="table-list-l fl" style="background:#dfe3e5;">
        <ul id="kindTree" class="ztree">
        </ul>
    </div>
    <div class="table-list-r fr" >
        <div class="rel clearfix function-btn-chart-top">
            <ul class="boxtab-btn-chart abs">
                <li  class=""><p class="">用电量数据分析:<span class=""></span></p></li>
                <li  class="data_light_hide"><p class="" ><span class="" id="">当前无数据</span></p></li>
                <li  class="data_light"><p class="" >日期:<span class="" id="prt_date">无;</span>总用电量:<span class="u_percent">0</span>KW</p></li>
                %{--<li  class=""><p class="">总用电量:<span class="">0.00</span>元,占总金额比例:<span class="_top10_percent">0.00%</span></p></li>--}%
                %{--<li  class=""><p class="">前十项金额总计:<span class="">0.00</span>元,占总金额比例:<span class="_top10_percent">0.00%</span></p></li>--}%
                %{--<li  class=""><p class="">前十项金额总计:<span class="">0.00</span>元,占总金额比例:<span class="_top10_percent">0.00%</span></p></li>--}%
            </ul>
        </div>
        <div class="rel clearfix function-btn-chart-footer">
            <div id="container">
            </div>
        </div>


    </div>
</div>
</body>
</html>

