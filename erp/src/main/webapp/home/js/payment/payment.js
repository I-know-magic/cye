/**
 * 格式化支付方式名称
 * @param row
 * @param val
 * @param index
 * @returns {string}
 */
function paymentNameF(row,val,index){
    return "<a href='#'  onClick='view(" + row.id + ","+row.isOpen+")' style='color: #0ae'>" + val + "</a>";
}
/**
 * 点击支付方式名称查看该支付方式
 * @param id
 */
function view(id,isOpen){
    var url = url_getPaymentById+"?id="+id;
    $.post(url,function(data){
        if(data.isSuccess){
            $("#paymentId").val(data.data.id);
            $("#payNameTxt").text(data.data.paymentName);
            if(data.data.paymentStatus == 0){
                $("#payStatusTxt").text('正常');
            }else if(data.data.paymentStatus == 1){
                $("#payStatusTxt").text('停用');
            }
            if(data.data.isScore == 0){
                $("#payScoreTxt").text('否');
            }else if(data.data.isScore == 1){
                $("#payScoreTxt").text('是');
            }
            if(data.data.isVoucher == 0){
                $("#payVoucherTxt").text('否');
            }else if(data.data.isVoucher == 1){
                $("#payVoucherTxt").text('是');
            }
            if(data.data.fixValue != null){
                $("#fixValueTxt").text(parseFloat(data.data.fixValue).toFixed(2));
            }
            if(data.data.fixNum != null){
                $("#fixNumTxt").text(data.data.fixNum);
            }
            //是否代金券如果为否，则不显示固定面值和单笔限次
            var isVoucher = data.data.isVoucher;
            if(isVoucher == null){
                isVoucher = 0;
            }
            isShowFix(isVoucher);
            if((data.data.paymentCode).indexOf('ZDY') > -1){//自定义的支付方式
                $("#updatePay").css("cursor","pointer").bind('click',function(){
                    updatePayFn();
                });
                $("#delPay").css("cursor","pointer").bind('click',function(){
                    delPayFn();
                });
                $("#paymentName").removeAttr("disabled").css("cursor","pointer");
                $("#payVoucherTxt").parent().show();//显示是否代金券
            }else if(isOpen == 0){//系统默认的支付方式未开通
                $("#updatePay").css("cursor","not-allowed").unbind('click');
                $("#delPay").css("cursor","not-allowed").unbind('click');
                $("#payVoucherTxt").parent().hide();//不显示是否代金券
            }else{//系统默认的支付方式已开通
                $("#updatePay").css("cursor","pointer").bind('click',function(){
                    updatePayFn();
                });
                $("#delPay").css("cursor","not-allowed").unbind('click');
                $("#paymentName").attr("disabled","disabled").css("cursor","not-allowed");
                //系统默认的非代金券的支付方式不显示是否代金券
                if(data.data.paymentCode != 'DJQ'){
                    $("#payVoucherTxt").parent().hide();
                }else{
                    $("#payVoucherTxt").parent().show();
                }
            }
            $("#showPaymentDialog").show();
        }
    },'json')
}
/**
 * 是否显示固定面值和单笔限次
 * @param val
 */
function isShowFix(val){
    if(val == 1){
        $("._isVoucher_item").show();
    }else{
        $("._isVoucher_item").hide();
    }
}
/**
 * 格式化支付方式状态
 * @param row
 * @param val
 * @param index
 * @returns {*}
 */
function statusF(row,val,index){
    var statusVal = [0,1];
    var statusName = ['正常','停用'];
    var formatterVal;
    if(val!=undefined){
        for(var k in statusVal){
            if(val == statusVal[k]){
                formatterVal = statusName[k];
            }
        }
        return formatterVal;
    }
}
/**
 * 格式化支付方式名称的是否积分是否代金券
 * @param row
 * @param val
 * @param index
 * @returns {string}
 */
function isFormatter(row,val,index){
    if(val == 0){
        return '否'
    }else if(val == 1){
        return '是'
    }else{
        return''
    }
}
/**
 * 为开通支付方式提示开通
 * @param row
 * @param val
 * @param index
 * @returns {string}
 */
function isOpenF(row,val,index){
    if(row.isOpen == 0){
        return "<a href='#'  onClick='openPay()' style='color: #0ae'>" + "申请开通" + "</a>";
    }else if(row.isOpen == 1){
        return '已开通';
    }else{
        return '';
    }
}
function openPay(){
    $.message.alert("申请开通联系我们：400-033-9199");
}
//判断字符方式是否可以删除，系统默认的不可删除，自定义的支付方式可以删除
function isDel(row,val,index){
    if((row.paymentCode).indexOf('ZDY') > -1){
        return "<span class='icon del' onClick='delPayment("+row.id+")'>"
    }
}
/**
 * 删除支付方式
 * @param id
 */
function delPayment(id){
    var delPayId = id;
    var url = url_delPayment+"?id="+delPayId;
    $.message.confirm("确定要删除该支付方式吗？","系统提示",function(r){
        if(r){
            $.post(url,function(data){
                if(data.isSuccess){
                    $.message.alert('删除成功！',function(){
                        $("#showPaymentDialog").hide();
                        $("#paymentTable").dataTable('reload');
                    });
                }else{
                    $.message.alert('删除失败！')
                }
            },'json')
        }
    });
}
/**
 * 加载支付方式编辑数据
 * @param id
 */
function loadUpdateData(id){
    var url = url_getPaymentById+"?id="+id;
    $.post(url,function(data){
        if(data.isSuccess){
            $("#id").val(data.data.id);
            $("#paymentStatus").val(data.data.paymentStatus);
            $("#isScore").val(data.data.isScore);
            //系统默认的非代金券的支付方式不显示是否代金券
            if((data.data.paymentCode).indexOf('ZDY') == -1 && data.data.paymentCode != 'DJQ'){
                $(".isVoucher").parent().hide();
            }else{
                $(".isVoucher").parent().show();
            }

            if(data.data.fixValue != null){
                $("#fixValue").val(parseFloat(data.data.fixValue).toFixed(2));
            }else{
                $("#fixValue").val('0.00');
            }
            if(data.data.fixNum != null){
                $("#fixNum").val(data.data.fixNum);
            }else{
                $("#fixNum").val('0');
            }
            $("#isVoucher").val(data.data.isVoucher);
            //是否代金券如果为否，则不显示固定面值和单笔限次
            data.data.isVoucher == null ? 0 : data.data.isVoucher;
            isShowFix(data.data.isVoucher);
            $("#paymentName").val(data.data.paymentName);
            if(data.data.paymentStatus == 1){
                $(".paymentStatus").removeClass("switch-on").addClass("switch-off");
            }else{
                $(".paymentStatus").addClass("switch-on").removeClass("switch-off");
            }
            if(data.data.isScore == 0){
                $(".isScore").removeClass("switch-on").addClass("switch-off");
            }else{
                $(".isScore").addClass("switch-on").removeClass("switch-off");
            }
            if(data.data.isVoucher == 0){
                $(".isVoucher").removeClass("switch-on").addClass("switch-off");
            }else{
                $(".isVoucher").addClass("switch-on").removeClass("switch-off");
            }
        }
    },'json')
}
/**
 * 格式化固定面值
 * @param inputId
 */
function valFormatter(inputId){
    var data = $("#"+inputId).val();
    var result;
    if(data &&!isNaN(data)){
        result = parseFloat(data).toFixed(2);
    }else{
        result = parseFloat(0).toFixed(2);
    }
    if(result > 9999.99){
        result = 9999.99;
    }
    $("#"+inputId).val(result);
}
/**
 * 格式化单笔限次
 * @param inputId
 */
function numFormatter(inputId){
    var data = $("#"+inputId).val();
    var result = data.replace(/\b(0+)/gi,"");
    if(result > 9999){
        result = 9999;
    }
    $("#"+inputId).val(result);
}
/**
 * 绑定click函数
 */
function initClickFns(){
    $("#addPayment").click(function(){
        if($("#paymentName").attr('disabled') == 'disabled'){
            $("#paymentName").removeAttr('disabled').css('cursor','pointer');
        }
        $("#payForm").form('reset');
        $("#id").val('');
        $("#paymentStatus").val(0);
        $(".paymentStatus").removeClass("switch-off").addClass("switch-on");
        $("#isScore").val(1);
        $(".isScore").removeClass("switch-off").addClass("switch-on");
        $("#isVoucher").val(1);
        $(".isVoucher").removeClass("switch-off").addClass("switch-on");
        $(".isVoucher").parent().show();//显示是否代金券
        $("._isVoucher_item").show();//显示固定面值和单笔限次
        $("#addPaymentDialog").find(".payTitle").text("增加支付方式");
        $("#addPaymentDialog").show();
    });
    $("span.closeAdd").click(function(){
        $("#addPaymentDialog").hide(function(){
            if($(this).find("#error-box").length>0 ){
                $(this).find("#error-box").remove();
            }
        });
    });
    $("span.closeView").click(function(){
        $("#showPaymentDialog").hide();
    });
    $("span.saveAdd").click(function(){
        var url = url_addPayment;
        //系统默认的支付方式，不能修改名称，所以名称是禁用的，后台得不到值，需要手动拼接名称参数
        if($("#id").val()!='' && $("#paymentName").attr('disabled') == 'disabled'){
            var paymentName = $("#paymentName").val();
            url = url_addPayment+"?paymentName="+paymentName;
        }
        $("#payForm").validation(function(){
            $("#payForm").form("submit",{
                url:url,
                onSuccess:function(data){
                    if(data.isSuccess){
                        var tips;
                        if($("#id").val()!=''){
                            tips = '修改成功';
                        }else{
                            tips = '支付方式添加成功！'
                        }
                        $.message.alert(tips,function(){
                            $("#addPaymentDialog").hide(function(){
                                if($(this).find("#error-box").length>0 ){
                                    $(this).find("#error-box").remove();
                                }
                            });
                            $("#paymentTable").dataTable('reload');
                        });
                    }else{
                        $.message.alert(data.error);
                    }
                }
            })
        })
    });
    $(".paymentStatus").click(function(){
        if($(this).hasClass("switch-on")){
            $(this).removeClass("switch-on");
            $(this).addClass("switch-off");
            $("#paymentStatus").val(1);
        }else{
            $(this).removeClass("switch-off");
            $(this).addClass("switch-on");
            $("#paymentStatus").val(0);
        }
    });
    $(".isScore").click(function(){
        if($(this).hasClass("switch-on")){
            $(this).removeClass("switch-on");
            $(this).addClass("switch-off");
            $("#isScore").val(0);
        }else{
            $(this).removeClass("switch-off");
            $(this).addClass("switch-on");
            $("#isScore").val(1);
        }
    });
    $(".isVoucher").click(function(){
        if($(this).hasClass("switch-on")){
            $(this).removeClass("switch-on");
            $(this).addClass("switch-off");
            $("#isVoucher").val(0);
            $("._isVoucher_item").hide();
        }else{
            $(this).removeClass("switch-off");
            $(this).addClass("switch-on");
            $("#isVoucher").val(1);
            $("._isVoucher_item").show();
        }
    });
    $("#updatePay").click(function(){
        updatePayFn();
    });
    $("#delPay").click(function(){
        delPayFn();
    });
    $(".paymentBack").click(function(){
        changeContent(url_setting);
    });
}
function updatePayFn(){
    var editPayId = $("#paymentId").val();
    loadUpdateData(editPayId);
    $("#showPaymentDialog").hide();
    $("#addPaymentDialog").find(".payTitle").text("编辑支付方式");
    $("#addPaymentDialog").show();
}
function delPayFn(){
    var delPayId = $("#paymentId").val();
    delPayment(delPayId);
}