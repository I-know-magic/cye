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
            url='<g:createLink base=".." controller='baseArea' action='loadZTree'/>';
            init_tree('id','baseAreaPid','baseAreaName',true);
            loadMyTree(url);
            dateTimePicker = new dateTimePicker({
                container: $('#dateTimeRangeBox'),
                defaultDateTime: [$.dateFormat(new Date, "yyyy-MM-dd") + ' 00:00', $.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59']
            });

            var params = Until.getParameter();
            $("#container").css({height:($(window).height()-168-8-105)+"px"});
            createChart("总金额");
        });
        function createChart(prodType){
            var params = Until.getParameter();
            params["u_name"] = prodType;
            var url = "<g:createLink base=".." action="linedata" controller="chart" />";
            $.get(url,params,function(data){
                var categories = [];
                //zones 不同区间颜色不同 默认针对Y轴 zoneAxis: 'x' 可更改为x轴
                var seriesData =
                {name:"线损-1",data:[]};
                if(data){
                    for(var key in data){
//                        categories.push(data[key]["prt_date"]);
                        seriesData["data"].push([data[key]["prt_date"],data[key]["c_total"]]);
//                        seriesData1["data"].push(data[key]["c_total"]+2)
                    }
                    drawChart(categories,seriesData)
                }
            },"json")
        }
        function drawChart(categories,seriesData){

            $('#container').highcharts({
                chart: {
                    type: 'pie',
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false
                },
                title: {
                    text: '饼图',
//                    align: "right",
                    style:{ "color": "#adb3b3", "fontSize": "13px" }
                },
//                //可显示具体值
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            color: '#000000',
                            connectorColor: '#000000',
                            formatter: function() {
                                return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
                            }
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
                series: [seriesData]
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
                <li  class=""><p class="">总金额：<span class="">0.00</span>元</p></li>
                <li  class=""><p class="">前十项金额总计:<span class="">0.00</span>元,占总金额比例:<span class="_top10_percent">0.00%</span></p></li>
                <li  class=""><p class="">前十项金额总计:<span class="">0.00</span>元,占总金额比例:<span class="_top10_percent">0.00%</span></p></li>
                <li  class=""><p class="">前十项金额总计:<span class="">0.00</span>元,占总金额比例:<span class="_top10_percent">0.00%</span></p></li>
                <li  class=""><p class="">前十项金额总计:<span class="">0.00</span>元,占总金额比例:<span class="_top10_percent">0.00%</span></p></li>
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

