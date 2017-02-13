var category_zTree_setting = {
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
            pIdKey: "parentId",
            rootId: ""
        },
        key: {
            name:"catName"
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
        removeTitle: "删除分类",
        renameTitle: "修改分类"
    },
    callback: {
        onRename: endEditName,
        beforeRemove: remove,
        beforeEditName: beforeEditName,
        beforeRename: beforeRename
        //,
        //onClick: onClickCategoryZTree
    }
};
/**
 * 加载分类树
 */
function loadCategoryTree() {
    $.ajax({
        async: true,
        url: url_category_zTree,
        type: "post",
        dataType: 'json',
        success: function (data) {
            obj_category_zTree_nodes = data.data;
            for (var key in obj_category_zTree_nodes) {
                obj_category_zTree_nodes[key].open = true;
            }
            obj_category_zTree = $.fn.zTree.init($("#categoryTree"), category_zTree_setting, obj_category_zTree_nodes);
            var select_node = obj_category_zTree.getNodeByParam("id", -1, null);
            //$('#h_checked_categoryId').val('');
        }
    });
}
function getChildren(ids,treeNode){
    if (treeNode.isParent){
        for(var obj in treeNode.children){
            ids.push(treeNode.children[obj].id);
            getChildren(ids,treeNode.children[obj]);
        }
    }
    return ids;
}
var delCategoryNode;//要删除的分类节点
function remove(treeId, treeNode) {
    delCategoryNode = treeNode;
    $.message.confirm('您确定要删除此分类吗？','系统提示',function(r){
        if(r){
            $.post(url_category_delete + treeNode.id, function (data) {
                if (data.isSuccess) {
                    obj_category_zTree.removeNode(treeNode);
                    $.message.alert(data.message);
                } else {
                    $.message.alert($.message.alert(data.data.errors[0].mes));
                }
            }, "json")
        }
    });
    return false
}
function addHoverDom(treeId, treeNode) {
    //节点深度大于3的不能增加
    if (treeNode.level > 2) {
        return true
    }
    //每一级最多20个分类
    if(treeNode.children!=undefined && treeNode.children.length > 19){
        return true
    }
    if(treeNode.goodsNum > 0){
        return true
    }
    var sObj = $("#" + treeNode.tId + "_span");
    if (treeNode.editNameFlag || $("#addBtn_" + treeNode.tId).length > 0){
        return;
    }
    var addStr = "<span class='button add' id='addBtn_" + treeNode.tId + "' title='增加分类' onfocus='this.blur();'></span>";
    sObj.after(addStr);
    var btn = $("#addBtn_" + treeNode.tId);
    if (btn) btn.bind("click", function () {
                    $("#categoryPId").val(treeNode.id);
                    var str = treeNode.catName;
                    $("#parentCode").val(str);
                    $("#categoryName").val('');
                    $("#categoryDialog").retailDialog("open");
                    return false;

    });
}
function removeHoverDom(treeId, treeNode) {
    $("#addBtn_" + treeNode.tId).unbind().remove();
}
/**
 * 点击编辑按钮的click事件
 * @param treeId
 * @param treeNode
 * @returns {boolean}
 */
function beforeEditName(treeId, treeNode) {
    treeNode.catName = treeNode.catName.replace(/\(.*\)/gi, "");
    return true;
}
/**
 * 编辑结束前
 * @param treeId
 * @param treeNode
 * @param newName
 * @param isCancel
 */
function beforeRename(treeId, treeNode, newName, isCancel) {
    var is = newName == '' || newName.length > 20 ? false : true;
    if (is) {
        var url = url_category_edit + treeNode.id + '&catName=' + newName;
        $.post(encodeURI(url),
            function (data) {
                if (data.isSuccess) {
                }else{
                    $.message.alert(data.message);
                }
            }, "json");
    } else {
        if(newName == ''){
            $.message.alert('分类名称不能为空！');
        }else if(newName.length > 20){
            $.message.alert('长度不超过20个汉字或字符！');
        }
    }
    return is
}

function endEditName(event, treeId, treeNode) {
    obj_category_zTree.updateNode(treeNode);
    return true;
}
/**
 * 校验节点是否可以编辑 根节点不可编辑
 * @param treeId
 * @param treeNode
 * @return {boolean}
 */
function validEdit(treeId, treeNode) {
    return treeNode.id != '-1';
}
/**
 * 校验节点是否可以删除 有子节点、全部门店节点不可删除
 * @param treeId
 * @param treeNode
 * @return {boolean}
 */
function validRemove(treeId, treeNode) {
    return  treeNode.id != '-1' && treeNode.childNum == 0 && treeNode.goodsNum == 0;
}
/**
 * 分类树保存的方法
 */
function categoryTreeSave1(){
    var catName = $("#categoryName").val();
    if(catName == ""){
        $.message.alert("分类名称为必填项！");
        return;
    }
    if(catName.length > 20){
        $.message.alert("长度不超过20个字母或字符！");
        return;
    }
    //$("#sub").attr("disabled",true);
    var options ={
        url:url_category_add,
        type:'post',
        data:null,
        success:function(data){
            var result = eval('(' + data + ')');
            if (!result.isSuccess){
                //$("#sub").attr("disabled",false);
                $.message.alert("添加失败！");
            }else if(result.isSuccess){
                //$("#sub").attr("disabled",false);
                $("#categoryDialog").retailDialog("close");
                var pNode = obj_category_zTree.getNodeByParam("id", result.data.parentId, null);
                obj_category_zTree.addNodes(pNode,
                    {
                        id: result.data.id,
                        pId: result.data.parentId,
                        name: result.data.catName,
                        memo: result.data.memo,
                        isParent: true,
                        childNumber: 0
                    });
                //obj_category_zTree.refresh();
                loadCategoryTree();
            }
        }
    };
    $('#categoryForm').ajaxSubmit(options);
}





