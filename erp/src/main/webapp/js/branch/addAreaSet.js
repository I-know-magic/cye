/**
 * 区域树的setting
 */
var areaSetting = {
    view: {
        selectedMulti: false,
        expandSpeed: "fast"
    },
    data: {
        simpleData: {
            enable: true,
            idKey: "id",
            pIdKey: "pId",
            rootId: ""
        },
        key: {
            name: 'name'
        }
    },
    check: {
        enable: true,
        chkStyle: "radio",
        radioType: "all"
    }

}
/**
 * 修改时选中ztree复选框时
 */
function treeOnCheckB() {
    var branchIdStr = $("input[name='areaId']").val();
    if (branchIdStr != "" && branchIdStr != undefined) {
        var bTreeObj = $.fn.zTree.getZTreeObj("addAreaTree");
        var select_node = bTreeObj.getNodeByParam("id", branchIdStr, null);
        bTreeObj.checkNode(select_node, true, true);
        $("#areaName").textbox("setText", select_node.name.replace(/\(.*\)/gi, ""));
    }
}

/**
 * 选中tree复选框,点击确定时
 *
 */
function okCheckB() {
    var tree = $.fn.zTree.getZTreeObj("addAreaTree");
    var nodes = tree.getCheckedNodes(true);
    if (nodes != null && nodes.length != 0) {
        $("#areaName").textbox("setText", nodes[0].name.replace(/\(.*\)/gi, ""));
        $("#areaId").val(nodes[0].id);
        $("#addAreaDialog").dialog('close');
    } else {
        $.messager.alert("系统提示", "请选择区域！", "info");
    }
}