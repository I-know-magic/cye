/**
 * Created by Administrator on 2015/6/10.
 */

function statusFormatter(val) {
    if (val == 0) {
        return '正常';
    }
    if (val == 1) {
        return '停售';
    }
    if (val == 2) {
        return '停购';
    }
    if (val == 3) {
        return '淘汰';
    }
    return val;
}
function down(e, url) {
    ban_bubbling(e);
    window.location.href = url;
}
function exportExcel(e, url) {
    ban_bubbling(e);
    window.location.href = url + '?goodsCodeOrName=' + $("#queryStr").val() + '&categoryIds=' + $('#categoryIds').val();
}
//function exportpdf(e,url){
//    ban_bubbling(e);
//    var url =  url + '?goodsCodeOrName='+$("#queryStr").textbox("getText") + '&categoryIds=' + $('#categoryIds').val();
//    window.open(url)
//}
//function getNextGoodsCode(url){
//    $.get(url,function(data){
//        if(true){
//            $('#goodsCode').textbox('setText',""+data+"");
//        }
//        else{
//        }
//    });
//}
function loadBoxData(id, url, textField, update) {
    $('#' + id).combobox({
        editable: false,
        valueField: 'id',
        textField: textField,
        panelHeight: 230,
        url: url,
        onLoadSuccess: function (rec) {
            if (!update) {
                $('#' + id).combobox("select", rec[1].id);
            }
        }
    });
}
function loadComboTree(id, url, op, initUrl, add,data) {
    is = false;
    $('#' + id).combotree({
        editable: false,
        required: true,
        url: url,
        //panelWidth: 'auto',
        onLoadSuccess: function (rec) {
            if (add) {
                var a = $('#categoryIds').val()
                var is_cat = $("#is_cat").val();
                if (a && !(/,/g.test(a))) {// && is_cat === '1'
                    var t = $('#' + id).combotree('tree');
                    t.tree('select', t.tree('find', a).target)
                    $('#' + id).combotree('setValue', a);
                }
                if (a == "")
                    $('#' + id).combotree('setValue', -1);
            } else {
                var node = $(this).tree('find', data.categoryId);
                $(this).tree('select', node.target);
                $('#category_id').combotree('setValue', data.categoryId);
                $('#category_id').combotree('setText', node.text);

            }
        },
        onBeforeSelect: function (node) {
            // 判断父节点是否是根节点
            var parent = $(this).tree('getParent', node.target);
            var isLeaf = $(this).tree('isLeaf', node.target);
            // $('#' + op).textbox('setText', "");
            //if (node != null && node.attributes.code.length == 2) {
            //    is = true;
            //    return false;
            //}
            is = false;
        },
        onHidePanel: function () {
            if (is) {
                $('#' + id).combotree('showPanel');
            }
        },
        onSelect: function (node) {
            var isLeaf = $(this).tree('isLeaf', node.target);
            if (!isLeaf) {
                $('#' + id).combotree('setValue', -1);
                $.messager.alert("系统提示", "此分类下有二级分类，不能添加商品，请重新选择！", "info");
                return false;
            }
            //如果类型是原料，则禁用库存管理
            if (node.attributes.categoryType == 1) {
                $(".c_g_type").attr("disabled", "disabled");
                document.getElementById("isStore").checked = true;
            } else {
                $(".c_g_type").removeAttr("disabled");
                //document.getElementById("isStore").checked = false;
            }

            // if (node.id != -1 && isAdd){
            //     $.post(initUrl + '?catId=' + node.id, function (data) {
            //         // if($('#' + op).val()==""){
            //             $('#' + op).textbox('setText', data);
            //         // }
            //
            //     });
            // }
        }
    });
}

function goodsNameM(newV, oldV) {
    //var gn = $('#goodsName').textbox('getValue');
    if (newV == '' || newV == null) {
        $('#mnemonic').textbox('setValue', '');
        return;
    }
    var url = url_goods_m + '?goodsCode=' + newV;
    $.post(encodeURI(url), function (data) {
        if (true) {
            if (mnemonicFlage > 0) {
                $('#mnemonic').textbox('setValue', data.replace(/[^a-z^A-Z^0-9]+/g, ''));
            }
            mnemonicFlage = 2;
        }
        else {
        }
    });
}
function saveGoods() {
    var val = $('#category_id').combobox('getValue');
    // var val1 = $('#goodsUnitId').combobox('getValue');
    if (val == '-1' || val == null) {
        $.messager.alert("系统提示", "  请设置分类！", "info");
        return;
    }
    // if (val1 == '' || val1 == null) {
    //     $.messager.alert("系统提示", "请设置单位！", "info");
    //     return;
    // }
    orderTable.mainSave();
}
function init(url) {
    $('#importExcelDialog').dialog({
        title: '导入菜品',
        modal: true,
        closed: true,
        collapsible: true,
        resizable: true,
        striped: false,
        width: 500,
        height: 200,
        buttons: [{
            text: '上传',
            iconCls: 'icon-ok',
            handler: okUpload
        }, {
            text: '关闭',
            iconCls: 'icon-cancel',
            handler: cUpload
        }]
    });
}
function cUpload() {

    $('#importExcelDialog').dialog('close');
}
function okUpload() {
    var url = uploadUrl
    var uploadFile = $('#uploadFile1').filebox('getValue');
    if (uploadFile) {
        $.messager.confirm('确认框', '您确定要上传该文件吗？', function (r) {
            if (r) {
                $('#submitUploadFileForm').form('submit', {
                    url: url,
                    success: function (data) {
                        if (data == null) return;
                        $.messager.alert('信息框', eval('(' + data + ')').msg);
                        $('#uploadFile1').filebox('setValue', '')
                        $('#importExcelDialog').dialog('close');
                        doSearch();
                    }
                }, 'json');
            }
        });
    } else {
        $.messager.alert('系统提示', "请选择上传文件！", 'warning');
    }
}
function importExcel(e) {
    if (e && e.stopPropagation) {
        e.stopPropagation();
    }
    $('#importExcelDialog').dialog('open');
}

function formatterSpec(row) {
    var s = '<span style="font-weight:bold" >' + row.property + '</span><br/>' +
        '<span style="color:#888;margin-left: 0px">' + row.describing + '</span>';
    return s;
}

function back(url) {
    $.redirect(url, {_remove_position: "查看菜品"})
}


var setting = {
    view: {
        selectedMulti: false
    },
    data: {
        simpleData: {
            enable: true,
            idKey: "id",
            pIdKey: "parentId",
            rootId: ""
        },
        key: {
            name: 'catName'
        }

    },
    callback: {
        onClick: zTreeOnClick
    }

}
var goodsTree
function loadZTree(url) {
    $.ajax({
        async: true,
        url: url,
        type: "post",
        dataType: 'json',
        success: function (data) {
            treeNodes = data;
            for (var key in treeNodes) {
                treeNodes[key].open = false;
            }
            goodsTree = $.fn.zTree.init($('#goodsTree'), setting, treeNodes);
            var root = goodsTree.getNodeByParam("id", '-1', null)
            goodsTree.expandNode(root, true)
            var hidden_categoryId = $('#hidden_categoryId').val();
            var targetNode = goodsTree.getNodeByParam("id", hidden_categoryId, null)
            var categoryIds = [];
            if (targetNode) {
                goodsTree.selectNode(targetNode, true);
                goodsTree.expandNode(targetNode, true)
                if (targetNode.children) {
                    $.each(targetNode.children, function (i, item) {
                        categoryIds.push(item.id);
                    });
                } else {
                    categoryIds.push(targetNode.id);
                }

            } else {
                goodsTree.selectNode(root, true)
            }
            $("#categoryIds").val(categoryIds.toString())
            doSearch();
        }
    })
}

function zTreeOnClick(event, treeId, treeNode) {
    var categoryIds = [];
    goodsTree.expandNode(treeNode, true)
    if (treeNode.id == -1) {
        $("#categoryIds").val('');
    } else {
        if (treeNode.children) {
            $.each(treeNode.children, function (i, item) {
                categoryIds.push(item.id);
            });
            $("#is_cat").val('1');
        } else {
            categoryIds.push(treeNode.id);
            if (treeNode.catCode.length == 4) {
                $("#is_cat").val('1');
            } else {
                $("#is_cat").val('0');
            }
        }
        $("#categoryIds").val(categoryIds.toString())
    }
    doSearch();
}
function setVipPrice(newVal, oldVal) {
    $('#vipPrice2').numberbox('setValue', newVal);
    $('#vipPrice1').numberbox('setValue', newVal);
    $('#purchasingPrice').numberbox('setValue', newVal);
}
function goodsTypeClick(obj) {
    if (obj.checked) {
        document.getElementById("isStore").checked = true;
    }
}
function isStoreClick(obj) {
    if (!obj.checked) {
        document.getElementById("goodsType").checked = false;
    }
}
