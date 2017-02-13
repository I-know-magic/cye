var setting = {
    view: {
        selectedMulti: false,
        expandSpeed: "fast"
    },
    data: {
        simpleData: {
            enable: true,
            idKey: "code",
            pIdKey: "parentcode",
            rootId: ""
        },
        key: {
            name: 'name'
        }
    },
    check: {
        enable: true,
        chkStyle: "checkbox"
    }
}
var setting2 = {
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
        chkStyle: "checkbox"
    }
}

function setPos(url) {
    var rows = $("#mainGrid").datagrid("getSelections");
    if (rows.length != 1) {
        $.messager.alert('系统提示', '请选择一条用户记录！', 'info');
        return;
    }
    $('#posPowerDialog').dialog('open');
    $.post(url + '?employeeId=' + rows[0].id, function (result) {
        var bTreeObj = $.fn.zTree.getZTreeObj("cateTree");
        $.each(result.aut, function (i, item) {
            var select_node = bTreeObj.getNodeByParam("code", item.posAuthorityKey, null);
            bTreeObj.checkNode(select_node, true, true);
        });
        var ns = bTreeObj.getCheckedNodes(true)
        if (ns.length == 0) {
            //bTreeObj.expandAll(true);
            bTreeObj.expandNode(bTreeObj.getNodeByParam("code", '0', null).children[0],true)
        }else{
            for(var t in ns){
                bTreeObj.expandNode(ns[t],true)
            }
        }

    }, 'json');
}
function saveAut(url){
    var rows = $("#mainGrid").datagrid("getSelections");
    var bTreeObj = $.fn.zTree.getZTreeObj("cateTree");
    var ns = bTreeObj.getCheckedNodes(true)
    var data = []
    //data.push(rows[0].id)
    for(var t in ns){
        if(!ns[t].isParent){
            data.push(ns[t].code)
        }
    }
    //if(data.length == 0){
    //    $.messager.alert('系统提示', '请选择权限', 'info');return;
    //}
    var employeeAuthorityKey = rows[0].id + ';'+data;
    if (data.length == 0){
        employeeAuthorityKey = rows[0].id;
    }
    $.messager.confirm('系统提示','确定操作？',function(r){
        if (r){
            $.post(url+'?employeeAuthorityKey='+employeeAuthorityKey,function(result){
                if (result.success=="true"){
                    $("#mainGrid").datagrid('reload');
                    $.messager.alert('系统提示', result.msg, 'info');
                    $('#posPowerDialog').dialog('close');
                    doSearch();
                } else {
                    $.messager.alert('系统提示', result.msg, 'error');
                }
            },'json');
    }
    });
}
/**
 *加载树方法
 * @param url
 * @param trId
 */
var treeNodes,zTree;
function loadTree1(url, trId, setting) {
    $.ajax({
        url: url,
        type: "post",
        dataType: 'json',
        success: function (data) {
            treeNodes = data;
            //for (var key in treeNodes) {
            //    treeNodes[key].open = false;
            //}
            zTree = $.fn.zTree.init(trId, setting, treeNodes);
        }
    })
}
function setRole(url) {
    var rows = $("#orderTable").datagrid("getSelections");
    if (rows.length != 1) {
        $.messager.alert('系统提示', '请选择一条角色记录！', 'info');
        return;
    }
    //if(rows.length == 1 && rows[0].roleCode <= '02'){
    //    $.messager.alert('系统提示', '【'+rows[0].roleName+'】角色不能设置权限', 'info' );
    //    return
    //}
    $('#rolePowerDialog').dialog('open');
    $.post(url + '?roleId=' + rows[0].id, function (result) {
        var bTreeObj = $.fn.zTree.getZTreeObj("cateTree");
        $.each(result, function (i, item) {
            var select_node = bTreeObj.getNodeByParam("id", item.id, null);
            if(select_node&&!select_node.isParent)
            bTreeObj.checkNode(select_node, true, true);
        });
        var ns = bTreeObj.getCheckedNodes(true)
        if (ns.length == 0) {
            //bTreeObj.expandAll(true);
            bTreeObj.expandNode(bTreeObj.getNodeByParam("id", '-99999', null).children[0],true)
        }else{
            for(var t in ns){
                bTreeObj.expandNode(ns[t],true)
            }
        }

    }, 'json');
}
function saveRolePrivilege(url){
    var rows = $("#orderTable").datagrid("getSelections");
    var bTreeObj = $.fn.zTree.getZTreeObj("cateTree");
    var ns = bTreeObj.getCheckedNodes(true)
    var pIds = []
    $.each(ns,function(index,item){
        if(item.id != '-99999'){
            pIds.push(item.memo)
        }
    });
    if(pIds.length == 0){
        $.messager.alert('系统提示', '请选择权限', 'info');return;
    }
    var params = '?roleId='+rows[0].id + '&privilegeIds='+pIds;
    $.messager.confirm('系统提示','确定操作？',function(r){
        if (r){
            $.post(url+params,function(result){
                if (result.success=="true"){
                    $("#orderTable").datagrid('reload');
                    $.messager.alert('系统提示', result.msg, 'info');
                    $('#rolePowerDialog').dialog('close');
                    query();
                } else {
                    $.messager.alert('系统提示', result.msg, 'error');
                }
            },'json');
        }
    });
}
