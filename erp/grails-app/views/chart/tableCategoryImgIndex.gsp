<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="taglibs"/>
    <title>销售分析</title>
    <!-- hightChart required -->
    <script src="${resource(base:"..",dir:"resources",file:"highcharts-4.1.8/js/highcharts.js")}" type="text/javascript"></script>
    <script src="${resource(base:"..",dir:"resources",file:"highcharts-4.1.8/js/themes/custom.js?version=0.1.2")}" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            var params = Until.getParameter();
            $("#container").css({height:($(window).height()-168-8)+"px"})
            $.get("<g:createLink base=".." action="findcls" controller="chart" />", params, function (data) {
                if(data){
                    var sum = 0, top10 = 0, others = 0;
                    var categories = [], seriesData = [];
                    for (var i=0;i<data.length;i++) {
                        sum += data[i]["c_total"];// 统计总额
                        if(i<10){
                            // 统计前十总额
                            categories.push(data[i]["u_name"]);
                            seriesData.push(data[i]["c_total"])
                            top10 += data[i]["c_total"];
                        }else{
                            //统计其他总额
                            others += data[i]["c_total"]
                        }
                    }
                    if(categories.length>0 && seriesData.length>0){
                        categories.push("其他");
                        seriesData.push(others)
                    }
                    $("._total").text(sum.toFixed(2));
                    $("._top10_total").text(top10.toFixed(2));
                    $("._top10_percent").text((top10/(sum==0?1:sum) *100).toFixed(2)+"%");
                    createChart(categories,seriesData)
                }
            }, "json")
        });
        function createChart(categories,seriesData){
            //highcharts Theme

            // Load the fonts
            Highcharts.createElement('link', {
                href: '//fonts.googleapis.com/css?family=Unica+One',
                rel: 'stylesheet',
                type: 'text/css'
            }, null, document.getElementsByTagName('head')[0]);

            Highcharts.theme = {
                colors: ["#2b908f", "#90ee7e", "#f45b5b", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
                    "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"],
                chart: {
                    backgroundColor: {
                        linearGradient: { x1: 0, y1: 0, x2: 1, y2: 1 },
                        stops: [
                            [0, '#2a2a2b'],
                            [1, '#3e3e40']
                        ]
                    },
                    style: {
                        fontFamily: "'Unica One', sans-serif"
                    },
                    plotBorderColor: '#606063'
                },
                title: {
                    style: {
                        color: '#E0E0E3',
                        textTransform: 'uppercase',
                        fontSize: '20px'
                    }
                },
                subtitle: {
                    style: {
                        color: '#E0E0E3',
                        textTransform: 'uppercase'
                    }
                },
                xAxis: {
                    gridLineColor: '#707073',
                    labels: {
                        style: {
                            color: '#E0E0E3'
                        }
                    },
                    lineColor: '#707073',
                    minorGridLineColor: '#505053',
                    tickColor: '#707073',
                    title: {
                        style: {
                            color: '#A0A0A3'

                        }
                    }
                },
                yAxis: {
                    gridLineColor: '#707073',
                    labels: {
                        style: {
                            color: '#E0E0E3'
                        }
                    },
                    lineColor: '#707073',
                    minorGridLineColor: '#505053',
                    tickColor: '#707073',
                    tickWidth: 1,
                    title: {
                        style: {
                            color: '#A0A0A3'
                        }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.85)',
                    style: {
                        color: '#F0F0F0'
                    }
                },
                plotOptions: {
                    series: {
                        dataLabels: {
                            color: '#B0B0B3'
                        },
                        marker: {
                            lineColor: '#333'
                        }
                    },
                    boxplot: {
                        fillColor: '#505053'
                    },
                    candlestick: {
                        lineColor: 'white'
                    },
                    errorbar: {
                        color: 'white'
                    }
                },
                legend: {
                    itemStyle: {
                        color: '#E0E0E3'
                    },
                    itemHoverStyle: {
                        color: '#FFF'
                    },
                    itemHiddenStyle: {
                        color: '#606063'
                    }
                },
                credits: {
                    style: {
                        color: '#666'
                    }
                },
                labels: {
                    style: {
                        color: '#707073'
                    }
                },

                drilldown: {
                    activeAxisLabelStyle: {
                        color: '#F0F0F3'
                    },
                    activeDataLabelStyle: {
                        color: '#F0F0F3'
                    }
                },

                navigation: {
                    buttonOptions: {
                        symbolStroke: '#DDDDDD',
                        theme: {
                            fill: '#505053'
                        }
                    }
                },

                // scroll charts
                rangeSelector: {
                    buttonTheme: {
                        fill: '#505053',
                        stroke: '#000000',
                        style: {
                            color: '#CCC'
                        },
                        states: {
                            hover: {
                                fill: '#707073',
                                stroke: '#000000',
                                style: {
                                    color: 'white'
                                }
                            },
                            select: {
                                fill: '#000003',
                                stroke: '#000000',
                                style: {
                                    color: 'white'
                                }
                            }
                        }
                    },
                    inputBoxBorderColor: '#505053',
                    inputStyle: {
                        backgroundColor: '#333',
                        color: 'silver'
                    },
                    labelStyle: {
                        color: 'silver'
                    }
                },

                navigator: {
                    handles: {
                        backgroundColor: '#666',
                        borderColor: '#AAA'
                    },
                    outlineColor: '#CCC',
                    maskFill: 'rgba(255,255,255,0.1)',
                    series: {
                        color: '#7798BF',
                        lineColor: '#A6C7ED'
                    },
                    xAxis: {
                        gridLineColor: '#505053'
                    }
                },

                scrollbar: {
                    barBackgroundColor: '#808083',
                    barBorderColor: '#808083',
                    buttonArrowColor: '#CCC',
                    buttonBackgroundColor: '#606063',
                    buttonBorderColor: '#606063',
                    rifleColor: '#FFF',
                    trackBackgroundColor: '#404043',
                    trackBorderColor: '#404043'
                },

                // special colors for some of the
                legendBackgroundColor: 'rgba(0, 0, 0, 0.5)',
                background2: '#505053',
                dataLabelsColor: '#B0B0B3',
                textColor: '#C0C0C0',
                contrastTextColor: '#F0F0F3',
                maskColor: 'rgba(255,255,255,0.3)'
            };

            // Apply the theme
            Highcharts.setOptions(Highcharts.theme);



            //-------------------
            $('#container').highcharts({
                chart: {
                    type: 'bar'
                },
                title: {
                    text: '销售分析'
                },
                xAxis: {
                    categories: categories,
                    title: {
                        text: null
                    }
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: '销售额(元)',
                        align: 'high'
                    },
                    labels: {
                        overflow: 'justify'
                    }
                },
                tooltip: {
                    headerFormat: "<span style='font-size: 22px'>{point.key}</span><br/>",
                    pointFormat : "{series.name}:<b>{point.y} 元"
                },
                plotOptions: {
                    bar: {
                        dataLabels: {
                            enabled: true
                        }
                    }
                },
                legend: {
                    enabled:false
                },
                credits: {
                    enabled: false
                },
                series: [{
                    name: '销售额',
                    data: seriesData
                }]
            });
        }
    </script>
</head>
<body>
<div class="row navbar-fixed-top center-block" id="_header" style="display: none;">
    <div class="col-xs-12 col-sm-12">
        <header class="head-wrap rel">
            <span class="abs icon head-menu" id="_head_menu"></span>
            <h2 class="head-title">
                <p id="_header_title">统计分析</p>
                <p class="head-time" id="_header_time"></p>
            </h2>
            <span class="abs icon head-day" id="_search_btn"></span>
        </header>
    </div>
</div>
<div class="container-fluid day-main navbar">
    <div class="row center-block navbar-fixed-top"  style="top: 60px;">
        %{--background-color: #353639--}%
        <div class="col-xs-12 col-sm-12">
            <section class="table-wrap">
                <div class="money-percent">
                    <p class="money-all">总金额：<span class="_total">0.00</span>元</p>
                    <p class="">前十项金额总计:<span class="_top10_total">0.00</span>元,占总金额比例:<span class="_top10_percent">0.00%</span></p>
                </div>
            </section>
        </div>
    </div>
    <div class="row center-block" style="margin-top: 128px;">
        <!-- 图表生成区域 -->
        <div class="col-xs-12 col-sm-12">
            <div id="container"></div>
        </div>
    </div>
    <div class="row navbar-fixed-bottom center-block" style="bottom: 0px;">
        <div class="col-xs-12 col-sm-12" style="height: 40px;line-height: 40px;">
            %{--<table class="table">--}%
                %{--<tbody>--}%
                %{--<tr class="table-c">--}%
                    %{--<td style="width: 18%;padding:0px;text-align: left;line-height: 32px;" id="">--}%
                        %{--<img src="${resource(base:"..",dir: "resources",file:"css/common/img/change.png")}" class="changeShow" style="padding: 4px 0 0 4px;"/>--}%
                    %{--</td>--}%
                    %{--<td colspan="3"></td>--}%
                %{--</tr>--}%
                %{--</tbody>--}%
            %{--</table>--}%
        </div>
    </div>
</div>
</body>
</html>