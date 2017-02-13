function bindClickFns(){
    //点击展开检索框
    $("#searchCheckOrder").click(function(){
        $(".checkOrderDiv").slideToggle('slow');
    });
    //关闭检索框
    $(".closeCheckOrderDiv").click(function(){
        $(".checkOrderDiv").slideUp('slow');
    });
    //展开收款员的下拉列表
    $("#employeeSpan").click(function(){
        $("#employeeUl").slideToggle();
    });
    //按条件检索采购进货单
    $(".checkOrderParams").click(function(){
        searchCheckOrder();
        $(".checkOrderDiv").slideUp('slow');
    });
    //重置查询条件
    $("p.resetParams").click(function(){
        resetParams();
    });
    //点击时间防止时间控件隐藏
    $(".timeInput ").click(function(){
        $("#ui-datepicker-div").show();
    });
    $(".checkOrderNoSearch").click(function(){
        $("#checkOrderTable").dataTable(
            'search',{
                code:$("#checkOrderNo").val()
            }
        );
    });
    //返回库存首页
    $(".rebackIndex").click(function(){
        changeContent(url_storeIndex);
    })
}
/**
 * 按条件检索商品盘点单
 */
function searchCheckOrder(){
    var startTime = $("input[id*='begin']").val();
    var endTime = $("input[id*='end']").val();
    $("#checkOrderTable").dataTable(
        'search',{
            startDate:startTime,
            endDate:endTime,
            makeBy:$("#employeeId").val(),
            branchId:branchId,
            minCheckQuantity:$("#checkQuantity1").val(),
            maxCheckQuantity:$("#checkQuantity2").val(),
            minCheckAmount:$("#checkAmount1").val(),
            maxCheckAmount:$("#checkAmount2").val()
        }
    );
}
/**
 * 重置查询条件
 */
function resetParams(){
    $("input[id*='begin']").val(beforeDate + ' 00:00');
    $("input[id*='end']").val($.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59');
    $("#employeeId").val('');
    $("#employeeName").val("");
    $("#checkQuantity1").val('');
    $("#checkQuantity2").val('');
    $("#checkAmount1").val('');
    $("#checkAmount2").val('');
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
function checkOrderF(row,val,index){
    return "<a href='#'  onClick='view(" + row.id + ")' style='color: #0ae'>" + val + "</a>";
}
function view(orderId){
    var url = url_checkOrderDetail+"?checkOrderId="+orderId+"&backParams="+getBackInitParams();
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
    backStr1 += $('#checkOrderNo').val() + ';';
    backStr1 += $("input[id*='begin']").val() + ';';
    backStr1 += $("input[id*='end']").val() + ';';
    backStr1 += $('#employeeId').val() + ';';
    backStr1 += $('#employeeName').val() + ';';
    backStr1 += $('#checkQuantity1').val() + ';';
    backStr1 += $('#checkQuantity2').val() + ';';
    backStr1 += $('#checkAmount1').val() + ';';
    backStr1 += $('#checkAmount2').val();
    return backStr1;
}
function setBackInitParams(){
    if (backParams != '') {
        var backs = backParams.split(';');
        backParams = '';
        $('#checkOrderNo').val(backs[0]);
        $("input[id*='begin']").val(backs[1]);
        $("input[id*='end']").val(backs[2]);
        $("#employeeId").val(backs[3]);
        $('#employeeName').val(backs[4]);
        $('#checkQuantity1').val(backs[5]);
        $('#checkQuantity2').val(backs[6]);
        $('#checkAmount1').val(backs[7]);
        $('#checkAmount2').val(backs[8]);
    }
}