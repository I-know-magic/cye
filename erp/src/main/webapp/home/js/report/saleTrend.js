function initPager() {
    var height = $(window).height();
    $(".nav").css({"height": (height - 0) + "px"});
    $(".wrap").css({"height": (height - 0) + "px"});
    $(".left-pop-up-box").css({"height": (height - 48) + "px"});
    var width = $(window).width();
    $(".wrap").css({"width": (width - 100 - 40) + "px"});
    $(".wrap-s").css({"width": (width - 50 - 40) + "px"});
    $(window).resize(function () {
        var height = $(window).height();
        $(".nav").css({"height": (height - 0) + "px"});
        $(".wrap").css({"height": (height - 0) + "px"});
        $(".left-pop-up-box").css({"height": (height - 48) + "px"});
        var width = $(window).width();
        $(".wrap").css({"width": (width - 100 - 40) + "px"});
        $(".wrap-s").css({"width": (width - 50 - 40) + "px"});
    });
    $(".search-data").click(function () {
        $(".left-pop-up-box").slideToggle('slow');
    });
    $("span.close").click(function () {
        $(".left-pop-up-box").slideUp("slow");
        $("#categoryUl").slideUp();
        $("#brandUl").slideUp();
    });
    $(".select-span").click(function () {
        $(".left-pop-up-box ul").not($(this).parent().parent().next()).hide();
        $(this).parent().parent().next().toggle();
    })
    $(".left-pop-up-box li").click(function () {
        $(this).parent().prev().find("input").val($.trim($(this).text()));
        $(this).parent().hide();
    })
    //按条件检索
    $("span.save").click(function () {
        searchData();
        $(".left-pop-up-box").slideUp("slow");
    });
    //重置查询条件
    $("p.reset").click(function () {
        resetParams();
    });
    $(".checkbox").children().click(function () {
        $(".choose").removeClass("choose");
        $(this).addClass("choose");
    });
    initTable();
}
function initTable() {

    $("#saleTab").smartTab({
        onSelect: function (param) {
            if (param.tabId == 'tab1') {
                onSelectTableNum = 1;
                $('#onSelectTableNum_1').show();
                $('#onSelectTableNum_2').hide();
                $('#onSelectTableNum_3').hide();
            }
            if (param.tabId == 'tab2') {
                onSelectTableNum = 2;
                $('#onSelectTableNum_1').hide();
                $('#onSelectTableNum_2').show();
                $('#onSelectTableNum_3').hide();
            }
            if (param.tabId == 'tab3') {
                onSelectTableNum = 3;
                $('#onSelectTableNum_1').hide();
                $('#onSelectTableNum_2').hide();
                $('#onSelectTableNum_3').show();
            }
            searchData();
        }
    });

    $("#saleTrendDay_table").dataTable({
        rownumber: true,
        checkrow: false,
        footer: {
            showFooter: true, foots: [
                {name: 'saleUnitPrice', formatter: moneyFormatter2},
                {
                    name: 'saleNum', formatter: function (val) {
                    return val;
                }
                },
                {name: 'realAmount', formatter: moneyFormatter2}
            ]
        },
        columns: [
            {filed: "createAt", title: '日期'},
            {filed: "realAmount", title: '营业额', formatter: moneyFormatter},
            {filed: "saleNum", title: '客单数'},
            {filed: "saleUnitPrice", title: '客单价', formatter: moneyFormatter}
        ]
    });
    $("#saleTrendMonth_table").dataTable({
        rownumber: true,
        checkrow: false,
        footer: {
            showFooter: true, foots: [
                {name: 'saleUnitPrice', formatter: moneyFormatter2},
                {
                    name: 'saleNum', formatter: function (val) {
                    return val;
                }
                },
                {name: 'realAmount', formatter: moneyFormatter2}
            ]
        },
        columns: [
            {filed: "createAt", title: '日期'},
            {filed: "realAmount", title: '营业额', formatter: moneyFormatter},
            {filed: "saleNum", title: '客单数'},
            {filed: "saleUnitPrice", title: '客单价', formatter: moneyFormatter}
        ]
    });
    $("#saleTrendTimeInterval_table").dataTable({
        rownumber: true,
        checkrow: false,
        footer: {
            showFooter: true,
            foots: [
                {name: 'saleUnitPrice', formatter: moneyFormatter2},
                {
                    name: 'saleNum', formatter: function (val) {
                    return val;
                }
                },
                {name: 'realAmount', formatter: moneyFormatter2}
            ]
        },
        columns: [
            {filed: "createAt", title: '时段', formatter: createAt_Interval},
            {filed: "realAmount", title: '营业额', formatter: moneyFormatter},
            {filed: "saleNum", title: '客单数'},
            {filed: "saleUnitPrice", title: '客单价', formatter: moneyFormatter}
        ]
    });
    searchData();
}
function createAt_Interval(row, val, index) {
    return row.createAt + ":00" + "~" + row.dateInterval + ":00";
}
function moneyFormatter(row, val, index) {
    if (val != null) {
        return "￥" + parseFloat(val).toFixed(2);
    } else {
        return "N/A";
    }
}
function moneyFormatter2(val) {
    if (val != null) {
        return "￥" + parseFloat(val).toFixed(2);
    } else {
        return "N/A";
    }
}
function searchData() {
    var startTime = '';
    var endTime = '';
    switch (onSelectTableNum) {
        case 1:
            startTime = $('#beginTime1').val();
            endTime = $('#endTime1').val();
            $("#saleTrendDay_table").dataTable(
                'search', {
                    url: url_list_day,
                    startDate: startTime,
                    endDate: endTime
                }
            );
            break;
        case 2:
            startTime = $('#beginTime2').val();
            endTime = $('#endTime2').val();
            $("#saleTrendMonth_table").dataTable(
                'search', {
                    url: url_list_month,
                    startDate: startTime,
                    endDate: endTime
                }
            );
            break;
        case 3:
            startTime = $('#beginTime3').val();
            endTime = $('#endTime3').val();
            $("#saleTrendTimeInterval_table").dataTable(
                'search', {
                    url: url_list_intervalPager,
                    startDate: startTime,
                    endDate: endTime
                }
            );
            break;
    }
}
//重置查询条件实现函数
function resetParams() {
    switch (onSelectTableNum) {
        case 1:
            $('#beginTime1').val(beginTime);
            $('#endTime1').val(today);
            break;
        case 2:
            $('#beginTime2').val(beginMonth);
            $('#endTime2').val(today.substring(0, 7));
            break;
            break;
        case 3:
            $('#beginTime3').val(today);
            $('#endTime3').val(today);
            break;
            break;
    }
}