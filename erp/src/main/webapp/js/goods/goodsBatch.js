function insertRow(obj, isEmpty) {
    if (isEmpty) {//添加空行
        $('#tt').datagrid('insertRow', {
            row: {
                op: (cop + addGood + del),
                salePrice: '0',
                categoryId: categoryId[0].id,
                goodsUnitId: goodsUnitId && goodsUnitId.length > 2 ? goodsUnitId[1].id : goodsUnitId[0].id
            }
        });
    } else { //cop
        var copIndex = getRowIndex(obj);
        if ($('#tt').datagrid('validateRow', copIndex)) {
            $('#tt').datagrid('endEdit', copIndex);
            var copRow = getRowByIndex(copIndex);
            $('#tt').datagrid('insertRow', {
                row: {
                    op: (cop + addGood + del),
                    goodsName: copRow.goodsName,
                    categoryId: copRow.categoryId,
                    goodsUnitId: copRow.goodsUnitId,
                    vipPrice: copRow.vipPrice,
                    vipPrice2: copRow.vipPrice2,
                    salePrice: copRow.salePrice
                }
            });
        }
    }
    beginEdit($('#tt').datagrid('getRows').length - 1);
}
/**
 * 根据行号获得行数据
 * @param index
 */
function getRowByIndex(index) {
    var rows = $('#tt').datagrid('getRows');
    var resultRow = undefined;
    $.each(rows, function (x, row) {
        if ($('#tt').datagrid('getRowIndex', row) == index) {
            resultRow = row;
            return false;
        }
    });
    return resultRow;
}
/**
 * 删除行
 * @param target
 */
function deleterow(target) {
    var row = $('#tt').datagrid('getRows');
    if (row.length > 1) {
        $.messager.confirm('系统提示', '你确定删除?', function (r) {
            if (r) {
                $('#tt').datagrid('deleteRow', getRowIndex(target));
            }
        });
    }
}
/**
 * 获得行号
 * @param target
 * @return {Number}
 */
function getRowIndex(target) {
    var tr = $(target).closest('tr.datagrid-row');
    return parseInt(tr.attr('datagrid-row-index'));
}
function onClickRow(index) {
    beginEdit(index);
}
function endEditing(editIndex) {
    if ($('#tt').datagrid('validateRow', editIndex)) {
        $('#tt').datagrid('endEdit', editIndex);
        return true;
    } else {
        return false;
    }
}
function saveGoodsList(url) {
    var row = $('#tt').datagrid('getRows');
    var par = [];
    var str = '';
    var errIndex = undefined;
    $.each(row, function (i, item) {
        var index = $('#tt').datagrid('getRowIndex', item);
        if (!endEditing(index)) {
            errIndex = '请填写第' + (index + 1) + '行';
            return false;
        }
        par.push(item.goodsName);
        par.push(item.categoryId);
        par.push(item.goodsUnitId);
        par.push(item.salePrice);
        par.push(item.vipPrice ? item.vipPrice : ' ');
        par.push(item.vipPrice2 ? item.vipPrice2 : ' ');
        str += par.toString() + ";";
        par.length = 0;
    });
    if (errIndex) {
        $.messager.alert('系统提示', errIndex, 'info');
        return;
    }
    var list = str.substr(0, str.length - 1);
    $.messager.confirm('系统提示', '确定保存,点取消继续添加', function (r) {
        if (r) {
            $.post(save_url, {goodsList: list}, function (result) {
                if (result.success == "true") {
                    $.redirect(back_url, {_remove_position: "批量添加"})
                } else {
                    $.messager.alert('系统提示', result.msg, 'error');
                }
            }, 'json');
        }
    });
}
function beginEdit(index) {
    $('#tt').datagrid('beginEdit', index);
    keydown(index);
}
function keydown(index) {
    $.edits = $(".datagrid-view2 .datagrid-body [datagrid-row-index=" + index + "]").find('[autocomplete="off"]');
    $.each($.edits, function (i, item) {
        $(item).keydown(function (event) {
            if (event.keyCode && event.keyCode == 13) {
                var index = getRowIndex(this) + 1;
                var col = getColNo(this);
                var row = $(".datagrid-view2 .datagrid-body [datagrid-row-index=" + index + "]").find('[autocomplete="off"]');
                beginEdit(index);
                $(row[col - 1]).focus();
                //while(true){
                //    if(row[col-1] != undefined){
                //
                //        return;
                //    }
                //}
            }
        })
    })
}
function getColNo(obj) {
    if ($(obj).parents('[field="goodsName"]').length == 1) {
        return 1;
    }
    if ($(obj).parents('[field="categoryId"]').length == 1) {
        return 2;
    }
    if ($(obj).parents('[field="goodsUnitId"]').length == 1) {
        return 3;
    }
    if ($(obj).parents('[field="salePrice"]').length == 1) {
        return 4;
    }
    if ($(obj).parents('[field="vipPrice"]').length == 1) {
        return 5;
    }
    if ($(obj).parents('[field="vipPrice2"]').length == 1) {
        return 6;
    }
    return -1;
}

function init() {
    $('#tt').datagrid({
        idField: 'id',
        rownumbers: true,
        onClickRow: onClickRow,
        columns: [[
            {
                field: 'op', title: '操作', width: 100
            },
            {
                field: 'goodsName', title: '菜品名称', width: 180, align: 'left',
                editor: {
                    type: 'textbox',
                    options: {
                        required: true,
                        missingMessage: '请输入菜品名称',
                        validType: ['goodsNameValid', 'length[1,20]'],
                        missingMessage: '菜品名称为必填项'
                    }
                }
            },
            {
                field: 'categoryId', title: '分类', width: 180, align: 'left',
                editor: {
                    type: 'combotree',
                    value: '--请选择--',
                    options: {
                        panelWidth: 240,
                        data: [{}],
                        required: true,
                        missingMessage: '分类为必填项',
                        editable: false,
                        validType: 'NotEqual["--请选择--"]',
                        onBeforeSelect: function (node) {

                            // 判断父节点是否是根节点
                            if (node.id === -1) {
                                return true
                            }
                            var parent = $(this).tree('getParent', node.target);
                            var isLeaf = $(this).tree('isLeaf', node.target);
                            if (isLeaf) {
                                return true
                            }
                            return false

                        },
                        onLoadSuccess: function (node, data) {

                            categoryId = data;
                            var rootNode = $(this).tree('getRoot');
                            $(this).tree("select", rootNode.target);
                        },
                        onChange: function (newValue, oldValue) {
                            if (newValue == "undefined") $(this).combotree("setValue", '');
                        }
                    }
                },
                formatter: function (value) {
                    if (categoryId) {
                        CatText = null;
                        VisitCategoryByValue(value, categoryId[0])
                        return CatText
                    }
                    return value;
                }
            },
            {
                field: 'goodsUnitId', title: '单位', width: 180,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'id',
                        textField: 'unitName',
                        data: [{}],
                        required: true,
                        missingMessage: '单位为必填项',
                        editable: false,
                        validType: 'NotEqual["-- 请选择 --"]',
                        onLoadSuccess: function (rec) {
                            goodsUnitId = rec;
                            if (goodsUnitId) {
                                $(this).combobox("setValue", goodsUnitId[1].id)
                            }
                        }
                    }
                },
                formatter: function (value) {
                    if (goodsUnitId) {
                        for (var i = 1; i < goodsUnitId.length; i++) {
                            if (goodsUnitId[i].id == value) return goodsUnitId[i].unitName;
                        }
                    }
                    return value;
                }
            },
            {
                field: 'salePrice', title: '售价', width: 180, align: 'right',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: true, min: 0, precision: 2, max: 9999.99, missingMessage: '售价为必填项',
                        onChange: function (nv, ov) {
                            var curIndex = getRowIndex(this);
                            var rowEdits = $('#tt').datagrid('getEditors', curIndex);
                            rowEdits[5].target.numberbox('setValue', nv);
                            rowEdits[4].target.numberbox('setValue', nv);
                        }
                    }
                },
                formatter: function (v) {
                    return moneyFormatter2(v);
                }
            },
            {
                field: 'vipPrice', title: '会员价-1', width: 180, align: 'right',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false, min: 0, precision: 2, max: 9999.99
                    }
                },
                formatter: function (v) {
                    if (v) {
                        return moneyFormatter2(v);
                    } else {
                        return v;
                    }
                }
            },
            {
                field: 'vipPrice2', title: '会员价-2', width: 180, align: 'right',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false, min: 0, precision: 2, max: 9999.99, value: 0.00
                    }
                },
                formatter: function (v) {
                    if (v) {
                        return moneyFormatter2(v);
                    } else {
                        return v;
                    }
                }
            }
        ]]
    });
}