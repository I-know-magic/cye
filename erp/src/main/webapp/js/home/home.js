function chartInit() {
    $('#turnoverChart').highcharts({
        title: {
            text: ''
        },
        chart: {
            type: 'scatter'
        },
        credits: {
            enabled: false
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        exporting: {
            enabled: false
        },
        lang: {
            noData: ""
        },
        plotOptions: {
            line: {
                dataLabels: {
                    enabled: true,
                    formatter: function () {
                        return parseFloat(this.y).toFixed(2);
                    }
                },
                enableMouseTracking: true
            }
        },
        noData: {
            style: {
                'font-family': "微软雅黑",
                'color': '#52585b',
                'fontSize': '15px'
            }
        },
        xAxis: {
            categories: timePeriod,
            labels: {
                align: 'center'
            }
        },
        yAxis: {
            title: {
                text: '营业额（￥）'
            },
            gridLineDashStyle: 'longdash'
        },
        tooltip: {
            valueSuffix: "（￥）",
            valueDecimals: 2 //数据值保留小数位数
        }

    });
    $('#goodsTop7Chart').highcharts({
        title: {
            text: ''
        },
        chart: {
            type: 'column'
        },
        credits: {
            enabled: false
        },
        legend: {
            enabled: false
        },
        exporting: {
            enabled: false
        },
        lang: {
            noData: "还未添加菜品"
        },
        noData: {
            style: {
                'font-family': "微软雅黑",
                'color': '#52585b',
                'fontSize': '15px'
            }
        },
        xAxis: {
            categories: [],
            labels: {
                align: 'center'
            }
        },
        yAxis: {
            title: {
                text: '销售额（￥）'
            },
            gridLineDashStyle: 'longdash'
        },
        tooltip: {
            //valueSuffix : "（￥）",
            //valueDecimals: 2,//数据值保留小数位数
            formatter: function () {
                var s = this.x + ':<b>' + parseFloat(this.y).toFixed(2) + '（￥）</b>';
                return s;
            }
        }

    });
}

function opTimePeriod() {
    $.each(timePeriodStr.split(','), function (index, item) {
        timePeriod.push(item);
    })
}

/**
 * 获得门店营业额数据
 */
function searchTurnoverData() {
    $.ajax({
        type: "GET",
        url: turnover_url,
        cache: true,
        async: true,
        dataType: "json",
        success: function (data) {
            var chart = $('#turnoverChart').highcharts();
            $.each(data, function (index, item) {
                item.id = index;
                item.type = 'line';
                chart.addSeries(item, 100);
            })
        }
    });
}
var dataLabels = {
    enabled: true,
    rotation: 15,
    color: '#FFFFFF',
    align: 'center',
    //x: 4,
    //y: 30,
    formatter: function () {
        return parseFloat(this.y).toFixed(2);
    }
}
function searchGoodsTop10() {
    var isChecked = undefined;
    if ($("#checkedBranch").length != 0) {
        isChecked = $("#checkedBranch")[0].checked;
        $("#checkedBranch").attr("disabled", 'disabled');
    }
    $.ajax({
        type: "GET",
        url: goodsTop7_url + '?checkedBranch=' + (isChecked ? 'checkedBranch' : ''),
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            var chart = $('#goodsTop7Chart').highcharts();
            var colors = Highcharts.getOptions().colors;
            chart.xAxis[0].setCategories(data.categories, false);
            $.each(data.data, function (index, item) {
                item.color = colors[index];
                item.name = '销售额';
                item.dataLabels = dataLabels;
            })
            if (chart.series.length > 0) {
                chart.series[0].remove(false);
            }
            chart.addSeries({
                data: data.data
            }, false);
            chart.redraw();
            if (isChecked != undefined) {
                $("#checkedBranch").removeAttr("disabled");
            }
        }
    });
}
/**
 * 获取推广
 */
function searchExtensions() {
    $.ajax({
        type: "GET",
        url: ext_url,
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            for (var x = 0; x < data.length; x++) {
                var title  = data[x].title.length > 30 ? data[x].title.substring(0,31) + "..." : data[x].title;
                var msg = '<p><a target= "_blank" href="' + data[x].content + '">' +
                    '<span class="">【推广】</span>' + title + '</a></p>';
                $('#ext_msg').append(msg);
            }
        }
    });
}
/**
 * 获取公告
 */
function searchNotices() {
    $.ajax({
        type: "GET",
        url: not_url,
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            for (var x = 0; x < data.length; x++) {
                var title  = data[x].title.length > 30 ? data[x].title.substring(0,31) + "..." : data[x].title;
                var msg = '<p><a href="#" onclick="showNotice(this)" id="' + data[x].id + '">' +
                        //'<span class="">【推广】</span>' +
                    title + '</a></p>';
                $('#notice_msg').append(msg);
                data[x].id = data[x].id;
                notices.push(data[x]);
            }
        }
    });
}
function showNotice(obj) {
    var id = $(obj).attr('id');
    var title = '';
    var content = '';
    $.each(notices, function (index, item) {
        if (item.id == id) {
            title = '主题： &nbsp; &nbsp;' + item.title + "<br/>";
            content = '内容： &nbsp; &nbsp;' + item.content;
            return;
        }
    });
    $(".notice_content").html(title+content);
    $('#noticeInfoWindow').dialog('open').dialog('setTitle', '【公告】');
}
function colseNotice() {
    $('#noticeInfoWindow').dialog('close');
}
