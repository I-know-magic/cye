/**
 * 门店树的setting
 */
var branchSetting={
    view:{
        selectedMulti:false,
        expandSpeed:"fast"
    },
    data:{
        simpleData:{
            enable:true,
            idKey:"id",
            pIdKey:"pId",
            rootId:""
        },
        key:{
            name:'name'
        }
    },
    check:{
        enable:true,
        chkStyle: "radio",
        radioType: "all"
    }

}
var treeNodes,zTree;
function loadTree2(url,trId,setting){
    $.ajax({
        url:url,
        type:"post",
        dataType:'json',
        success:function(data){
            treeNodes=data;
            for(var key in treeNodes){
                treeNodes[key].open = true;
                if(treeNodes[key].nodeType == '-9999'){
                    treeNodes[key].nocheck = true;
                }
            }
            zTree= $.fn.zTree.init(trId,setting,treeNodes);
        }
    })
}
/**
 * 修改时选中ztree复选框时
 */
function treeOnCheck(){
    //var branchIdStr=$("input[name='branchId']").val();
    var branchIdStr=$("#branchIdSearch").val();
    if(branchIdStr!=""&&branchIdStr!=undefined){
            var bTreeObj=$.fn.zTree.getZTreeObj("branchTree");
                var select_node = bTreeObj.getNodeByParam("id",branchIdStr,null);
                bTreeObj.checkNode(select_node,true,true);
                $("#branchCode").textbox("setText",select_node.name);
    }
}

function treeOnUncheck(){
    var bTreeObj=$.fn.zTree.getZTreeObj("branchTree");
   var nodes= bTreeObj.getCheckedNodes(true);
    if(nodes.length>0){
        bTreeObj.checkNode(nodes[0],false,true);
    }

}

/**
 * 选中tree复选框,点击确定时
 *
 */
function okCheck() {
    var checkIndex = 0;
    var ids = [];
    var name;
    var tree = $.fn.zTree.getZTreeObj("branchTree");
    var nodes = tree.getCheckedNodes(true);
    if (nodes != null && nodes.length != 0) {
        for (var n = 0; n < nodes.length; n++) {
            ids.push(nodes[n].id)
            name = nodes[n].name;
            checkIndex++
        }
        if (checkIndex == 1) {
            $("#branchCode").textbox("setText", name);
        }
        $("#branchId").val(ids);
        $("#branchDialog").dialog('close');
    } else {
        $.messager.alert("系统提示", "您还没有选择任何门店！", "info");
    }
}

function okCheckSave() {
    var checkIndex = 0;
    var ids = [];
    var name;
    var tree = $.fn.zTree.getZTreeObj("branchTreeSearch");
    var nodes = tree.getCheckedNodes(true);
    if (nodes != null && nodes.length != 0) {
        for (var n = 0; n < nodes.length; n++) {
            ids.push(nodes[n].id)
            name = nodes[n].name;
            checkIndex++
        }
        if (checkIndex == 1) {
            $("#branchCodeSearch").textbox("setText", name);
        }

        $("#branchIdSearch").val(ids);
        $("#branchDialogSearch").dialog('close');
    } else {
        $.messager.alert("系统提示", "您还没有选择任何门店！", "info");
    }
}