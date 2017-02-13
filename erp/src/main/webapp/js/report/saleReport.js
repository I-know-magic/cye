/**
 * Created by Administrator on 2015/7/23.
 */
function sale_highDosearch() {
    $('#queryStr').textbox({
        buttonText: '',
        buttonIcon: ''
    });
    $("#searchBtn").hide();
    $(".layout-panel-north").css({"height": "180px"});
    $("#report_north").css({"height": "165px"});
    var cen_h = $("#center").height() - 101;
    var tab_h = $("#reportTab").height() - 101;
    $("#center").css({"height": cen_h});
    $("#center").css({"margin-top": "100px"});
    fitTab(tab_h);
    $("#search").show();
}
function sale_closeSearch() {
    $('#queryStr').textbox({
        buttonText: '查询',
        buttonIcon: 'icon-search'
    });
    $("#searchBtn").show();
    $(".layout-panel-north").css({"height": "75px"});
    $("#report_north").css({"height": "60px"});
    var cen_h = $("#center").height() + 101;
    var tab_h = $("#reportTab").height() + 101;
    $("#center").css({"height": cen_h});
    $("#center").css({"margin-top": "0px"});
    fitTab(tab_h);
    $("#search").hide();
}
function init_search() {
    $("#branch").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            if ($("#queryStr").val() !== "") {
                $.messager.alert("系统提示", "您已使用流水号进行查询，不能同时使用高级查询！", "info");
                return;
            }
            var url = getBranchView();
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择门店");
        }
    });
    $("#pos").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            if ($("#queryStr").val() !== "") {
                $.messager.alert("系统提示", "您已使用流水号进行查询，不能同时使用高级查询！", "info");
                return;
            }
            var branchId = $("#branchMenu_r").val();
            var url = getPosView();
            url += "?branchId=" + branchId;
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择POS机");
        }
    });
    $("#sent").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            if ($("#queryStr").val() !== "") {
                $.messager.alert("系统提示", "您已使用流水号进行查询，不能同时使用高级查询！", "info");
                return;
            }
            var branchId = $("#branchMenu_r").val();
            var url = getCashierView();
            url += "?branchId=" + branchId;
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择收款员");
        }
    });
    $("#goods").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            if ($("#queryStr").val() !== "") {
                $.messager.alert("系统提示", "您已使用流水号进行查询，不能同时使用高级查询！", "info");
                return;
            }
            var url = addCateGory();
            $("#select_dialog").dialog({
                href: url,
                width: "600px",
                height: "480px"
            }).dialog("open").dialog('setTitle', "选择菜品");
        }
    });
    $("#payMethod").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            if ($("#queryStr").val() !== "") {
                $.messager.alert("系统提示", "您已使用流水号进行查询，不能同时使用高级查询！", "info");
                return;
            }
            var url = getPayView();
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择支付方式");
        }
    });
}

function fitTab(tab_h) {
    $("#reportTab").css({"height": tab_h});
    $(".tabs-panels").css({"height": tab_h - 31});
    $(".tabs-panels").find(".panel-noscroll").css({"height": tab_h - 31});
    $(".tabs-panels").find(".datagrid-wrap").css({"height": tab_h - 33});
    $(".tabs-panels").find(".datagrid-view").css({"height": tab_h - 64});
    $(".tabs-panels").find(".datagrid-view").children(".datagrid-view1").find(".datagrid-body").css({"height": tab_h - 75});
    $(".tabs-panels").find(".datagrid-view").children(".datagrid-view2").find(".datagrid-body").css({"height": tab_h - 75});
}




