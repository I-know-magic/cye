function highDosearchPay(){
    $("#easyBtn").hide();
    $("#searchBtn").hide();
    $(".layout-panel-north").css({"height":"180px"});
    $("#report_north").css({"height":"165px"});
    var cen_h=$("#center").height()-101;
    var tab_h=$("#payReportTab").height()-101;
    $("#center").css({"height":cen_h});
    $("#center").css({"margin-top":"100px"});
    fitTabPay(tab_h);
    $("#search").show();
}
function closeSearchPay(){
    $("#easyBtn").show();
    $("#searchBtn").show();
    $(".layout-panel-north").css({"height":"75px"});
    $("#report_north").css({"height":"60px"});
    var cen_h=$("#center").height()+101;
    var tab_h=$("#payReportTab").height()+101;
    $("#center").css({"height":cen_h});
    $("#center").css({"margin-top":"0px"});
    fitTabPay(tab_h);
    $("#search").hide();
}
function init_searchPay(){
    $("#branch").textbox({
        buttonText: '选择',
        editable:false,
        width: 200,
        onClickButton: function () {
            var url=getBranchView();
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择门店");
        }
    });
    $("#pos").textbox({
        buttonText: '选择',
        editable:false,
        width: 200,
        onClickButton: function () {
            var branchId=$("#branchMenu_r").val();
            var url=getPosView();
            url+="?branchId="+branchId;
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择POS");
        }
    });
    $("#sent").textbox({
        buttonText: '选择',
        editable:false,
        width: 200,
        onClickButton: function () {
            var branchId=$("#branchMenu_r").val();
            var url=getCashierView();
            url+="?branchId="+branchId;
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择收款员");
        }
    });
}
function fitTabPay(tab_h){
    $("#payReportTab").css({"height":tab_h});
    $(".tabs-panels").css({"height":tab_h-31});
    $(".tabs-panels").find(".panel-noscroll").css({"height":tab_h-31});
    $(".tabs-panels").find(".datagrid-wrap").css({"height":tab_h-33});
    $(".tabs-panels").find(".datagrid-view").css({"height":tab_h-64});
    $(".tabs-panels").find(".datagrid-view").children(".datagrid-view1").find(".datagrid-body").css({"height":tab_h-75});
    $(".tabs-panels").find(".datagrid-view").children(".datagrid-view2").find(".datagrid-body").css({"height":tab_h-75});
}
