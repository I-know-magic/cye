function initClickFns(){
    //点击展开检索框
    $("#searchList").click(function(){
        $(".searchPurchaseDiv").slideToggle('slow');
    });
    //关闭检索框
    $(".closeSearchPurchaseDiv").click(function(){
        $(".searchPurchaseDiv").slideUp('slow');
    });
    //展开收款员的下拉列表
    $("#employeeSpan").click(function(){
        $("#employeeUl").slideToggle();
    });
    //按条件检索采购进货单
    $(".saveParams").click(function(){
        searchList();
        $(".searchPurchaseDiv").slideUp('slow');
    });
    //重置查询条件
    $("p.resetParams").click(function(){
        resetParams();
    });
    //点击时间防止时间控件隐藏
    $(".timeInput ").click(function(){
        $("#ui-datepicker-div").show();
    });
    //根据订单号查询采购进货单
    $(".orderNoSearch").click(function(){
        $("#purchasingListTable").dataTable(
            'search',{
                code:$("#orderNo").val(),
                orderType:1
            }
        );
    });
    $(".reBackPIndex").click(function(){
        changeContent(url_purchaseIndex);
    });
}
/**
 * 按条件检索采购进货单
 */
function searchList(){
    var startTime = $("input[id*='begin']").val();
    var endTime = $("input[id*='end']").val();
    $("#purchasingListTable").dataTable(
        'search',{
            startDate:startTime,
            endDate:endTime,
            makeBy:$("#employeeId").val(),
            branchId:branchId,
            quantityMin:$("#purchaseQuantity1").val(),
            quantityMax:$("#purchaseQuantity2").val(),
            amountMin:$("#purchaseAmount1").val(),
            amountMax:$("#purchaseAmount2").val(),
            orderType:1
        }
    );
}
//重置查询条件实现函数
function resetParams(){
    $("input[id*='begin']").val(beforeDate + ' 00:00');
    $("input[id*='end']").val($.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59');
    $("#employeeId").val('');
    $("#employeeName").val("");
    $("#purchaseQuantity1").val('');
    $("#purchaseQuantity2").val('');
    $("#purchaseAmount1").val('');
    $("#purchaseAmount2").val('');
}
/**
 * 初始化收款员下拉列表
 */
function initEmployeeList(){
    $.post(url_getEmployeeList,function(data){
        var $cloneLi;
        $.each(data.data.rows,function(index,item){
            $cloneLi = $("#employeeTemplate").find('li').clone(true);
            $cloneLi.attr('empId',item.userId);
            $cloneLi.find('p').text(item.name);
            $cloneLi.find('p').click(function(){
                $("#employeeId").val(item.userId);
                $("#employeeName").val(item.name);
                $("#employeeUl").slideUp();
            });
            $("#employeeUl").append($cloneLi);
        });
    },'json')
}
/**
 * 单据号格式化
 * @param row
 * @param val
 * @param index
 * @returns {string}
 */
function orderNumF(row,val,index){
    return "<a href='#'  onClick='view(" + row.id + ")' style='color: #0ae'>" + val + "</a>";
}
function view(orderId){
    var url = url_purchaseDetail+"?orderId="+orderId+"&backParams="+getBackInitParams();
    changeContent(url);
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
function getBackInitParams(){
    var backStr1 = '';
    backStr1 += $('#orderNo').val() + ';';
    backStr1 += $("input[id*='begin']").val() + ';';
    backStr1 += $("input[id*='end']").val() + ';';
    backStr1 += $('#employeeId').val() + ';';
    backStr1 += $('#employeeName').val() + ';';
    backStr1 += $('#purchaseQuantity1').val() + ';';
    backStr1 += $('#purchaseQuantity2').val() + ';';
    backStr1 += $('#purchaseAmount1').val() + ';';
    backStr1 += $('#purchaseAmount2').val();
    return backStr1;
}
function setBackInitParams(){
    if (backParams != '') {
        var backs = backParams.split(';');
        backParams = '';
        $('#orderNo').val(backs[0]);
        $("input[id*='begin']").val(backs[1]);
        $("input[id*='end']").val(backs[2]);
        $("#employeeId").val(backs[3]);
        $('#employeeName').val(backs[4]);
        $('#purchaseQuantity1').val(backs[5]);
        $('#purchaseQuantity2').val(backs[6]);
        $('#purchaseAmount1').val(backs[7]);
        $('#purchaseAmount2').val(backs[8]);
    }
}
