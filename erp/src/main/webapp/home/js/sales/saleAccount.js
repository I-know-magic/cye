function clickFns(){
    //点击检索展开收起搜索框
    $(".search-data").click(function(){
        $(".left-pop-up-box").slideToggle('slow');
    });
    //点击关闭图标收起搜索框
    $("span.close").click(function(){
        $(".left-pop-up-box").slideUp("slow");
    });
    //展开收款员的下拉列表
    $("#cashierSpan").click(function(){
        if($("#cashRegisterUl").css('display') == 'block'){
            $("#cashRegisterUl").hide();
        }
        $("#cashierUl").slideToggle();
    });
    $("#cashRegisterSpan").click(function(){
        if($("#cashierUl").css('display') == 'block'){
            $("#cashierUl").hide();
        }
        $("#cashRegisterUl").slideToggle();
    });
    //按条件检索
    $("span.save").click(function(){
        searchData();
        $(".left-pop-up-box").slideUp("slow");
    });
    //重置查询条件
    $("p.reset").click(function(){
        resetParams();
    });
    //点击时间防止时间控件隐藏
    $(".timeInput ").click(function(){
        $("#ui-datepicker-div").show();
    });
    $(".saleAccountBack").click(function(){
        changeContent(url_saleIndex);
    })

}
//按条件检索函数
function searchData(){
    var startTime = $("input[id*='begin']").val();
    var endTime = $("input[id*='end']").val();
    $("#accountTable").dataTable(
        'search',{
            startDate:startTime,
            endDate:endTime,
            empId:$("#cashier").val(),//li的隐藏域放Id值
            startReceivedAmount:$("#actualAmount1").val(),
            endReceivedAmount:$("#actualAmount2").val()
        }
    );
}
//重置查询条件实现函数
function resetParams(){
    $("#beginTime").val($.dateFormat(new Date, "yyyy-MM-dd ") + ' 00:00');
    $("#endTime").val($.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59');
    $("#cashier").val('');
    $("#cashierTxt").val("");
    $("#actualAmount1").val('');
    $("#actualAmount2").val('');
}
function moneyFormatter(row,val,index) {
    if (val) {
        return "￥" + parseFloat(val).toFixed(2);
    } else if (val === 0) {
        return "￥" + parseFloat(val).toFixed(2);
    } else if (val === undefined || val === "" || val == null) {
        return "￥" + parseFloat(0).toFixed(2);
    } else {
        return "￥" + parseFloat(0).toFixed(2);
    }
}
/**
 * 初始化收款员下拉列表
 */
function initEmployeeList(){
    $.post(url_getEmployeeList,function(data){
        var $cloneLi;
        if(data.data.rows.length == 0){
            $("#cashierUl").css('height','50px');
        }else{
            $.each(data.data.rows,function(index,item){
                $cloneLi = $("#cashierTemplate").find('li').clone(true);
                $cloneLi.attr('empId',item.id);
                $cloneLi.find('p').text(item.name);
                $cloneLi.find('p').click(function(){
                    $("#cashier").val(item.id);
                    $("#cashierTxt").val(item.name);
                    $("#cashierUl").slideUp();
                });
                $("#cashierUl").append($cloneLi);
            });
        }
    },'json')
}
/**
 * 初始化收款机下拉列表
 */
function initPosList(){
    $.post(url_getPosList,function(result){
        var $cloneLi;
        if(result.data.length == 0){
            $("#cashRegisterUl").css('height','50px');
        }else{
            $.each(result.data,function(index,item){
                $cloneLi = $("#posTemplate").find('li').clone(true);
                $cloneLi.attr('posId',item.id);
                $cloneLi.find('p').text(item.posCode);
                $cloneLi.find('p').click(function(){
                    $("#cashRegister").val(item.id);
                    $("#cashRegisterTxt").val(item.posCode);
                    $("#cashRegisterUl").slideUp();
                });
                $("#cashRegisterUl").append($cloneLi);
            })
        }
    },'json')
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
        return $.dateFormat(val.substr(0, 20),"yyyy-MM-dd hh:mm");
    }
}