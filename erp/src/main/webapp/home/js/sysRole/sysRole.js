
var cancelCheck = function(){
    this.isCancelCheck = false;
};//判断是否取消选中对象
/**
 * 设置权限
 */
function roleF(row,val,index){
    return "<a href='#'  onClick='setPrivilege(\"" +row.roleCode + "\","+ row.id + ")' style='color: #0ae'>" + '设置权限' + "</a>";
}
/**
 * 打开权限选择对话框
 * @param roleId 角色Id
 */
function setPrivilege(roleCode,roleId){
    if(roleCode == "01"){
        cancelCheck.isCancelCheck = true;
    }else{
        cancelCheck.isCancelCheck = false;
    }
    if($("#roleDialog").css('display') == 'block'){
        selectedRoleId = null;
        $("#roleDialog").hide();
    }
    selectedRoleId = roleId;
    var url = url_getPrivilegesById+"?roleId="+roleId;
    $.post(url, function (result) {
        var bTreeObj = $.fn.zTree.getZTreeObj("privilegeTree");
        bTreeObj.checkAllNodes(false);//将zTree之前勾选的节点全部清空.
        $.each(result.data, function (i, item) {
            var select_node = bTreeObj.getNodeByParam("id", item.id, null);
            if(select_node&&!select_node.isParent)
                bTreeObj.checkNode(select_node, true, true);
        });
        var ns = bTreeObj.getCheckedNodes(true);
        if (ns.length == 0) {
            bTreeObj.expandNode(bTreeObj.getNodeByParam("id", '-99999', null).children[0],true)
        }else{
            for(var t in ns){
                bTreeObj.expandNode(ns[t],true)
            }
        }
        $("#roleDialog").show();
    }, 'json');

}
/**
 * 保存勾选的权限
 */
function saveRolePrivileges(){
    var bTreeObj = $.fn.zTree.getZTreeObj("privilegeTree");
    var ns = bTreeObj.getCheckedNodes(true);
    var pIds = [];
    $.each(ns,function(index,item){
        if(item.id != '-99999'){
            pIds.push(item.memo)
        }
    });
    if(pIds.length == 0){
        $.message.alert('请选择权限');
        return;
    }
    var params = '?roleId='+selectedRoleId + '&privilegeIds='+pIds;
    $.message.confirm('确定操作？','系统提示',function(r){
        if (r){
            $.post(url_savePrivileges+params,function(result){
                if (result.isSuccess){
                    //$("#orderTable").datagrid('reload');
                    $.message.alert(result.message);
                    selectedRoleId = null;
                    $('#roleDialog').hide();
                    //query();
                } else {
                    $.message.alert(result.error);
                }
            },'json');
        }
    });
}
//权限树设置
var privilege_zTree_setting = {
    view: {
        selectedMulti: false,
        expandSpeed: "fast"
    },
    check: {
        chkStyle:"checkbox",
        enable:true
    },
    data: {
        simpleData: {
            enable: true,
            idKey: "id",
            pIdKey: "pId",
            rootId: ""
        },
        key: {
            roleName:"name"
        }
    },
    callback: {
        beforeCheck: zTreeBeforeCheck
    }
};
var privilegeTreeNodes,privilegeTreeObj;
/**
 * 初始化权限树
 */
function loadPrivilegeTree(){
    $.ajax({
        async: true,
        url: url_getPrivileges,
        type: "post",
        dataType: 'json',
        success: function (result) {
            privilegeTreeNodes = result.data;
            privilegeTreeObj = $.fn.zTree.init($("#privilegeTree"), privilege_zTree_setting, privilegeTreeNodes);
        }
    });
}
/**
 * 选中或取消之前方法
 * @param treeId
 * @param treeNode
 * @returns {boolean}
 * author:LiuJie
 */
function zTreeBeforeCheck(treeId, treeNode){
    if( cancelCheck.isCancelCheck && treeNode["checked"]){
        return false;
    }
}