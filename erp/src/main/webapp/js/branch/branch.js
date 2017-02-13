/**
 * 左侧区域树定义
 */
var branch_zTree_setting = {
    view: {
        addHoverDom: addHoverDom,
        removeHoverDom: removeHoverDom,
        selectedMulti: false,
        expandSpeed: "fast"
    },
    data: {
        simpleData: {
            enable: true,
            idKey: "id",
            pIdKey: "pId",
            rootId: ""
        }
    },
    edit: {
        enable: true,
        drag: {
            isCopy: false,
            isMove: false,
            prev: false,
            next: false,
            inner: false
        },
        showRemoveBtn: validRemove,
        showRenameBtn: validEdit,
        removeTitle: "删除区域",
        renameTitle: "修改区域"
    },
    callback: {
        onRename: endEditName,
        beforeRemove: remove,
        beforeEditName: beforeEditName,
        beforeRename: beforeRename,
        onClick: onClickBranchZTree
    }
}

function remove(treeId, treeNode) {
    $.messager.confirm('系统提示', '确定要删除？', function (r) {
        if (r) {
            $.post(url_area_delete + treeNode.id, function (data) {
                if (data.success == "true") {
                    obj_branch_zTree.removeNode(treeNode);
                } else {
                    $.messager.alert('系统提示', data.msg, 'error');
                }
            }, "json")
        }
    });
    return false
}

function addHoverDom(treeId, treeNode) {
    //节点深度大于4的不能增加
    if (treeNode.level > 3) {
        return true
    }
    var sObj = $("#" + treeNode.tId + "_span");
    if (treeNode.editNameFlag || $("#addBtn_" + treeNode.tId).length > 0) {
        return;
    }
    var addStr = "<span class='button add' id='addBtn_" + treeNode.tId + "' title='增加区域' onfocus='this.blur();'></span>";
    sObj.after(addStr);
    var btn = $("#addBtn_" + treeNode.tId);
    if (btn) btn.bind("click", function () {
        $("#areaPId").val(treeNode.id);
        //var str = treeNode.memo == -999 ? treeNode.name.replace(/\(.*\)/gi, "") : "[" + treeNode.memo + "]" + treeNode.name.replace(/\(.*\)/gi, "");
        var str = treeNode.memo == -999 ? tenantName : "[" + treeNode.memo + "]" + treeNode.name.replace(/\(.*\)/gi, "");
        $("#parentCode").textbox("setText", str);
        $("#area_Name").textbox("setText", '');
        $.post(url_area_nextCode + treeNode.id, function (result) {
            $("#areaCode").textbox("setValue", result);
            $("#areaDialog").dialog("open");
        })
        return false;
    });
}

function removeHoverDom(treeId, treeNode) {
    $("#addBtn_" + treeNode.tId).unbind().remove();
}
/**
 * 编辑结束前
 * @param treeId
 * @param treeNode
 * @param newName
 * @param isCancel
 */
function beforeRename(treeId, treeNode, newName, isCancel) {
    var is = newName == '' || newName.length > 15 ? false : true;
    if (is) {
        var url = url_area_edit + treeNode.id + '&name=' + newName;
        $.post(encodeURI(url),
            function (data) {
                if (data.success == "true") {
                } else {
                    $.messager.alert('系统提示', data.msg, 'error');
                }
            }, "json");
    } else {
        $.messager.alert('系统提示', '长度不超过15个汉字或字符！', 'info')
    }
    return is
}
/**
 * 节点编辑名称结束 加上门店数显示
 * @param treeId
 * @param treeNode
 * @param newName
 * @param isCancel
 */
function endEditName(event, treeId, treeNode) {
    treeNode.name += '(' + treeNode.childNumber + ')';
    obj_branch_zTree.updateNode(treeNode);
    return true;
}
//正在编辑的节点id
var onEditNodeId = '';
/**
 * 点编辑按钮的 click 事件 去掉门店数
 * @param treeId
 * @param treeNode
 * @return {boolean}
 */
function beforeEditName(treeId, treeNode) {
    treeNode.name = treeNode.name.replace(/\(.*\)/gi, "");
    return true;
}
/**
 * 校验节点是否可以编辑 初始化（总部直属）门店、全部门店节点不可编辑
 * @param treeId
 * @param treeNode
 * @return {boolean}
 */
function validEdit(treeId, treeNode) {
    //return treeNode.memo != '00' && treeNode.memo != '-999';
    return treeNode.memo != '-999';
}
/**
 * 校验节点是否可以删除 有门店、初始化（总部直属）、全部门店节点不可删除
 * @param treeId
 * @param treeNode
 * @return {boolean}
 */
function validRemove(treeId, treeNode) {
    return treeNode.memo != '00' && treeNode.memo != '-999' && treeNode.childNumber == 0;
}
/**
 * 加载左侧区域树
 */
function loadAreaTree() {
    $.ajax({
        async: true,
        url: url_branch_zTree,
        type: "post",
        dataType: 'json',
        success: function (data) {
            obj_branch_zTree_nodes = data;
            obj_branch_zTree = $.fn.zTree.init($("#areaTree"), branch_zTree_setting, obj_branch_zTree_nodes);
            var select_node = obj_branch_zTree.getNodeByParam("id", userBranchAreaId, null);
            select_node ? obj_branch_zTree.selectNode(select_node, false, true) : '';
            select_node ? obj_branch_zTree.expandNode(select_node, true, true, false) : '';
            $('#h_checked_area_id').val(select_node.id);
            doSearch();
        }
    });
}
/**
 * 加左侧区域树节点及父节点门店数量
 * @param n 门店数
 * @param nodeId 节点id
 */
function opBranchZTreeNodes(n, nodeId) {
    var node = obj_branch_zTree.getNodeByParam("id", nodeId, null);

}
/**
 * 递归遍历node节点及父节点，门店数加n
 * @param node
 * @param n
 */
function addBranchZTreeNodes(node, n) {
    var num = node.name.substring(node.name.indexOf('\(') + 1, node.name.indexOf('\)'))
    num = parseInt(num) + parseInt(n);
    node.name = node.name.replace(/\(.*\)/gi, "") + "(" + num + ")";
    node.childNumber = num;
    obj_branch_zTree.updateNode(node);
    $.each(obj_branch_zTree_nodes, function (index, item) {
        if (item.id == node.pId) {
            addBranchZTreeNodes(obj_branch_zTree.getNodeByParam("id", item.id, null), n);
        }
    });
}
/**
 * 左侧区域树onClick事件
 * @param event
 * @param treeId
 * @param treeNode
 */
function onClickBranchZTree(event, treeId, treeNode) {
    $('#h_checked_area_id').val(treeNode.id == -1 ? '' : treeNode.id);
    doSearch();
}

/**
 *保存树操作
 *
 */
function treeSave() {
    $("#areaForm").form("submit", {
        url: url_area_add,
        onSubmit: function () {
            if ($(this).form('validate')) {
                $('#sub').linkbutton('disable');
                return true;
            } else {
                return false;
            }
        },
        success: function (result) {
            var result = eval('(' + result + ')');
            if (result.success == "false") {
                $('#sub').linkbutton('enable');
                $.messager.alert('系统提示', result.msg, 'error');
            } else {
                $('#sub').linkbutton('enable');
                $("#areaDialog").dialog('close');
                var pNode = obj_branch_zTree.getNodeByParam("id", result.area.parentId, null);
                obj_branch_zTree.addNodes(pNode,
                    {
                        id: result.area.id,
                        pId: result.area.parentId,
                        name: result.area.name + '(0)',
                        memo: result.area.code,
                        isParent: true,
                        childNumber: 0
                    });
            }
        },
        onLoadError: function () {
            $.messager.alert('系统提示', "加载数据失败，请稍后再试！", 'error');
        }
    })
}
/**
 * 加载添加修改门店区域树
 */
function loadingBranchAreaTree() {
    $.ajax({
        async: true,
        url: url_branch_area_tree,
        type: "get",
        dataType: 'json',
        cache: false,
        success: function (data) {
            treeNodes = data;
            for (var key in treeNodes) {
                treeNodes[key].open = true;
            }
            $.fn.zTree.init($("#addAreaTree"), areaSetting, treeNodes);
            $("#addAreaDialog").dialog("open");
            treeOnCheckB();
        }
    });
}
/**
 * 添加门店回调函数
 */
function addBranchInit() {
    clearFrom();
    $('.class_outerInfo').hide();
    $('.class_tinyhall_type').hide();
    $('#isBuffet_id').hide();
    $('#isInvite_id').hide();
    $.ajax({
        type: "GET",
        url: url_branch_code,
        cache: false,
        async: false,
        dataType: "json",
        success: function (data) {
            if ($('#h_checked_area_id').val() != '') {
                var node = obj_branch_zTree.getNodeByParam("id", $('#h_checked_area_id').val(), null);
                $('#areaName').textbox('setValue', node.name.replace(/\(.*\)/gi, ""));
                $('#areaId').val(node.id);
            }
            $('#areaName').textbox('enable');
            $('#branch_code').textbox('setValue', data.code);
            $('#h_branch_id').val('');
            $('#point').val('');
            $("#geolocat").text("从地图获取位置");
            $('#branchInfoWindow').dialog('open').dialog('setTitle', '门店管理-增加');
        }
    });

}
/**
 * 格式化门店编码列
 */
function codeF(val, row) {
    if (row != null) {
        return "<a href='#' class='code_open' onClick='editBranch(" + row.id + ")'>" + val + "</a>";
    }
    return val;
}

/**
 * 编辑门店
 * @param id
 */
function editBranch(id) {
    clearFrom();
    var url = url_branch_edit + '?id=' + id;
    $('#branchInfoWindow').dialog('open').dialog('setTitle', '门店管理-修改');
    $.ajax({
        type: "GET",
        url: url,
        cache: false,
        async: false,
        dataType: "json",
        success: function (data) {
            var node = obj_branch_zTree.getNodeByParam("id", data.areaId, null);
            data.areaName = node.name.replace(/\(.*\)/gi, "");
            $('#branchOrder').form('load', data);
            if (data.branchType == 0) {
                $('#areaName').textbox('disable');
            }
            var point = data.geolocation;
            if (point != "") {
                $("#geolocat").text("已选中门店位置");
            }
            if (data.isTakeout) {
                $("#isTakeout").prop("checked", true);
                $("#isTakeout").val(true);
                $("#isTinyhall").val(true);
                $("#isTinyhall").prop("checked", true);
                $('.class_outerInfo').show();
                $('.class_tinyhall_type').show();
                if (data.isBuffet) {
                    $("#isBuffet").prop("checked", true);
                    $("#isBuffet").val(true);
                    $('#isBuffet_id').show();
                }
                if (data.isInvite) {
                    $("#isInvite").prop("checked", true);
                    $("#isInvite").val(true);
                    $('#isInvite_id').show();
                }
            } else {
                $("#isTakeout").prop("checked", false);
                $("#isTinyhall").prop("checked", false);
                $("#isTakeout").val(false);
                $("#isTinyhall").val(false);
                $("#isInvite").prop("checked", false);
                $("#isInvite").val(false);
                $("#isBuffet").prop("checked", false);
                $("#isBuffet").val(false);
                $('#isBuffet_id').hide();
                $('#isInvite_id').hide();
                $('.class_tinyhall_type').hide();
                $('.class_outerInfo').hide();
            }
        }
    });
}
/**
 * 保存门店
 */
function saveBranch() {
    $('#branchOrder').form('submit', {
        url: url_branch_add,
        onSubmit: function () {
            if ($(this).form('validate')) {
                if ($('#point').val() == '') {
                    $.messager.alert('系统提示', '请设置门店位置！', 'info');
                    return false;
                }
                if ($('#isTinyhall').val() == 'true' && $('#isTakeout').val() == 'false') {
                    $.messager.alert('系统提示', '请设置接受网络外卖下单!', 'info');
                    return false;
                }
                $('#sub_b').hide();
                //$('#sub_b').linkbutton('disable');
                return true;
            } else {
                return false;
            }
        },
        success: function (result) {
            var result = eval('(' + result + ')');
            if (result.success == "false") {
                $.messager.alert('系统提示', result.msg, 'error');
            } else {
                $.messager.alert('系统提示', result.msg, 'info');
                $('#branchInfoWindow').dialog('close');
                var select_node = obj_branch_zTree.getNodeByParam("id", $('#areaId').val(), null);
                select_node ? obj_branch_zTree.selectNode(select_node, false, true) : '';
                select_node ? obj_branch_zTree.expandNode(select_node, true, true, false) : '';
                $('#h_checked_area_id').val(select_node.id);
                doSearch();
                if ($('#h_branch_id').val() == '') {
                    addBranchZTreeNodes(select_node, 1);
                    obj_branch_zTree.selectNode(select_node, false, true)
                }
            }
            $('#sub_b').show();
            //$('#sub_b').linkbutton('enable');
        },
        onLoadError: function () {
            $.messager.alert('系统提示', "加载数据失败，请稍后再试！", 'error');
        }
    });
}
/**
 * 删除门店
 */
function del() {
    var rows = $("#branchTable").datagrid("getSelections");
    if (rows.length == 1 && rows[0].code == '000') {
        $.messager.alert('系统提示', '【' + rows[0].name + '】门店不能删除！', 'info');
        return
    }
    if (rows.length != 1) {
        $.messager.alert('系统提示', '请选择门店！', 'info');
        return
    }
    $.messager.confirm('删除确认', '确定删除？', function (r) {
        if (r) {
            var url = url_branch_del + rows[0].id;
            var del_area_id = rows[0].areaId;
            $.ajax({
                type: "GET",
                url: url,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success == "true") {
                        var node = obj_branch_zTree.getNodeByParam("id", del_area_id, null);
                        addBranchZTreeNodes(node, -1);
                        obj_branch_zTree.selectNode(node, false, true)
                    }
                    $.messager.alert('系统提示', data.msg, 'info');
                    doSearch();
                }
            });
        }
    });
}

function tinyhallStateOnClick(obj) {
    if (obj.checked) {
        obj.value = true;
        $('.class_tinyhall_type').show();
        $('#isBuffet_id').show();
        $('#isInvite_id').show();
    } else {
        obj.value = false;
        $("#isTakeout").prop("checked", false);
        $("#isTakeout").val(false);
        $("#isBuffet").prop("checked", false);
        $("#isBuffet").val(false);
        $("#isInvite").prop("checked", false);
        $("#isInvite").val(false);
        $('.class_tinyhall_type').hide();
        $('.class_outerInfo').hide();
        $('#isBuffet_id').hide();
        $('#isInvite_id').hide();
    }
}
function showTypeInfo(obj) {
    if (obj.checked) {
        obj.value = true;
        $('.class_outerInfo').show();
    } else {
        obj.value = false;
        $("#isTinyhall").prop("checked", false);
        $("#isTinyhall").val(false);
        tinyhallStateOnClick($('#isTinyhall')); // 网络外卖和微餐厅是同步的
    }
}
function clearFrom() {
    $('#branchOrder').form('reset');
}
function validNot(newValue, oldValue) {
    if (newValue == null || newValue == '') {
        $(this).textbox('setValue', '0.00');
    }
}
function validNot2(newValue, oldValue) {
    if (newValue == null || newValue == '') {
        $(this).textbox('setValue', '00:00');
    }
}
/*
 *门店操作列
 */
function formatOper(val, row, index) {
    return '<a href="#" onclick="createBranchTwoDimension(' + index + ')">生成二维码</a>';
}
/*
 *生成门店二维码
 */
function createBranchTwoDimension(index) {
    if (index != null) {
        $('#branchTable').datagrid('selectRow', index);
    }
    var rows = $("#branchTable").datagrid("getSelections");
    var fileName = rows[0].name;
    var title = '\"' + fileName + '\"' + '二维码链接';
    if (rows.length != 1) {
        $.messager.alert('系统提示', '请先选择一个门店！', 'info');
        return
    }
    var url = url_branch_TwoDimension + '?tenantId=' + rows[0].tenantId + '&branchId=' + rows[0].id + '&isBuffet=' + rows[0].isBuffet + '&isInvite=' + rows[0].isInvite;
    $.ajax({
        type: "GET",
        url: url,
        cache: false,
        //async: false,
        dataType: "json",
        success: function (data) {
            if (data.success == "true") {
                if(data.msg != null && data.msg != '' && data.msg != undefined){
                    var urlEncodeFileName = data.msg + "&fileName=" + encodeURI(encodeURI(fileName));
                    //window.location= urlEncodeFileName;
                    $('#createBranchTwoDimension').dialog({
                        title: title,
                        modal: true,
                        draggable: true,
                        width: 545,
                        height: 635
                    }).dialog('open');
                    $("#text_BranchTwoDimension").text(urlEncodeFileName+"&downLoad=1")
                    $("#down_createBranchTwoDimension-buttons").attr('display',"block");
                    $('#createBranchTwoDimension').find("textarea").css("display","none")
                    $("#img_BranchTwoDimension").attr('src',urlEncodeFileName);

                }else{
                    $("#down_createBranchTwoDimension-buttons").attr('display',"none");
                    $('#createBranchTwoDimension').dialog({
                        title: title,
                        modal: true,
                        draggable: true,
                        width: 500,
                        height: 150
                    }).dialog('open');
                    $('#createBranchTwoDimension').find("textarea").text("data.msg为空值，无法生成二维码图片");
                }
            } else {
                $("#down_createBranchTwoDimension-buttons").attr('display',"none");
                $('#createBranchTwoDimension').dialog({
                    title: title,
                    modal: true,
                    draggable: true,
                    width: 500,
                    height: 150
                }).dialog('open');
                $('#createBranchTwoDimension').find("textarea").text(data.msg);
            }
        }
    });
}