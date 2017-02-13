function init_searchStore(){
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
    $("#goods").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            var url = addCateGory();
            $("#select_dialog").dialog({
                href: url,
                width: "600px",
                height: "480px"
            }).dialog("open").dialog('setTitle', "选择商品");
        }
    });
    $("#category").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            var url = getGoodCateView();
            $("#select_dialog").dialog({
                href: url,
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择商品分类");
        }
    });
}
