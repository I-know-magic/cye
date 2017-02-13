/**
 * Created by Administrator on 2015/7/30.
 */
function init_textbox() {
    $('#goods_info').textbox({
        //prompt: '菜品选择',
        editable: false,
        icons: [{
            iconCls: 'icon-clear',
            handler: function (e) {
                $('#goods_info').textbox("clear");
                $('#select_good').val('');
            }
        }],
        buttonText: '选择',
        width: 200,
        onClickButton: function () {
            var url = addGood();
            if ($("#goods").textbox("getValue") !== "") {
                $.messager.alert("系统提示", "已选择菜品分类【不能选择菜品】！", "info");
                return;
            }
            $("#select_dialog").dialog({
                href: url,
                width: "600px",
                height: "480px"
            }).dialog("open").dialog('setTitle', "选择菜品");
        }
    });
    $("#branch").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            var url = getBranchView();
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择门店");
        }
    });
    $("#goods").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        icons: [{
            iconCls: 'icon-clear',
            handler: function (e) {
                $('#goods').textbox("clear");
                $('#select_cateId').val('');
            }
        }],
        onClickButton: function () {
            if ($("#goods_info").textbox("getValue") !== "") {
                $.messager.alert("系统提示", "已选择菜品【不能选择菜品分类】！", "info");
                return;
            }
            var url = getGoodCateView();
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择菜品分类");
        }
    });
}
function closeReport() {
    $("#select_dialog").dialog("close");
}
/**
 * 写入查询条件
 * @param id
 * @param name
 * @param isWhere
 */
function setSelectObj(id, name, isWhere,categoryId) {
    if (isWhere === "3") {
        $("#select_cateId").val(id);
        $("#goods").textbox("setValue", name);
    }
    if (isWhere === "2") {
        $("#branchMenu_r").val(id);
        $("#branch").textbox("setValue", name);
    }
    if (isWhere === "1") {
        $("#select_good").val(id);
        $("#goods_info").textbox("setValue", name);
        $("#h_categoryId").val(categoryId);
    }
    closeReport();
}
function clearSearch() {
    $("#searchForm").form("reset");
    $("#branchMenu_r").val($("#h_branchMenu_r").val());
    $("#branch").textbox('setText', $("#h_branchMenu_name").val());
    $("#goods").textbox('setText','' );
    $("#select_cateId").val('')
    $("#h_categoryId").val('')
    $("input[id*='begin']").val(new Date().format("yyyy-MM-dd 00:00"));
    $("input[id*='end']").val($.dateFormat(new Date, "yyyy-MM-dd hh:mm"));
}
function clear_query() {
    $('#goods_info').textbox("clear");
    $('#select_good').val('');
}


function fitDateGrid(cen_h) {
    $("#center").find(".datagrid-wrap").css({"height": cen_h - 2});
    $("#center").find(".datagrid-view").css({"height": cen_h - 33});
    $("#center").find(".datagrid-view").children(".datagrid-view1").find(".datagrid-body").css({"height": cen_h - 69});
    $("#center").find(".datagrid-view").children(".datagrid-view2").find(".datagrid-body").css({"height": cen_h - 69});
}
function single_print(url) {
    var par = '&goodsId=' + $('#select_good').val() + '&branchId=' + $("#branchMenu_r").val()
        + '&startDate=' + $("input[id*='begin']").val() + '&endDate=' + $("input[id*='end']").val()
        + '&categoryId=' + $("#select_cateId").val();
    window.open(url + par);
}