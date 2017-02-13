function bindClickFns(){
    //点击检索展开收起检索框
    $("#searchByParams").click(function(){
        $(".saleMonthDiv").slideToggle('slow');
    });
    //关闭检索框
    $(".closeSaleMonthDiv").click(function(){
        $(".saleMonthDiv").slideUp('slow');
    });
    //按条件检索采购进货单
    $(".saleMonthParams").click(function(){
        searchSaleMonth();
        $(".saleMonthDiv").slideUp('slow');
    });
    //重置查询条件
    $("p.resetParams").click(function(){
        resetParams();
    });
    ////点击时间防止时间控件隐藏
    //$(".timeInput ").click(function(){
    //    $("#ui-datepicker-div").show();
    //});
    $(".monthReIndex").click(function(){
        changeContent(url_reportIndex);
    });
}
/**
 * 按条件检索销售月趋势报表
 */
function searchSaleMonth(){
    var startTime = $("input[id*='begin']").val();
    var endTime = $("input[id*='end']").val();
    $("#saleMonthTable").dataTable(
        'search',{
            startDate:startTime,
            endDate:endTime,
            businessNumMin:$("#businessNum1").val(),
            businessNumMax:$("#businessNum2").val(),
            unitPriceMin:$("#unitPrice1").val(),
            unitPriceMax:$("#unitPrice2").val(),
            receivedAmountMin:$("#receivedAmount1").val(),
            receivedAmountMax:$("#receivedAmount2").val(),
            grossProfitMin:$("#grossProfit1").val(),
            grossProfitMax:$("#grossProfit2").val()
        }
    );
}
/**
 * 重置查询条件
 */
function resetParams(){
    $("input[id*='begin']").val(beforeDate + ' 00:00');
    $("input[id*='end']").val($.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59');
    $("#businessNum1").val('');
    $("#businessNum2").val('');
    $("#unitPrice1").val('');
    $("#unitPrice2").val('');
    $("#receivedAmount1").val('');
    $("#receivedAmount2").val('');
    $("#grossProfit1").val('');
    $("#grossProfit2").val('');
}
/**
 * 时间格式化
 * @param row
 * @param val
 * @param index
 * @returns {*}
 */
function dateF(row,val,index) {
    if (val != null) {
        return $.dateFormat(val.substr(0, 20),"yyyy-MM-dd");
    }
}