/**
 * 配货计划单据
 */


/**
 * 消耗图表初始化
 */
function chartInit() {
    $('#consumeChart').highcharts({
        title: {
            text: ''
        },
        chart: {
            type: 'scatter'
        },
        credits: {
            enabled: false
        },
        legend: {
            enabled: false
        },
        exporting: {
            enabled: false
        },
        lang: {
            noData: "请选择商品"
        },
        noData: {
            style: {
                'font-family': "微软雅黑",
                'color': '#52585b',
                'fontSize': '15px'
            }
        },
        xAxis: {
            categories: timePeriod,
            labels: {
                rotation: -40,
                align: 'center'
            }
        },
        yAxis: {
            title: {
                text: ''
            },
            gridLineDashStyle: 'longdash'
        },
        tooltip: {
            shared: true, //是否共享提示，也就是X一样的所有点都显示出来
            //useHTML: true, //是否使用HTML编辑提示信息
            //headerFormat: '<small>{point.key}</small><table>',
            //pointFormat: '<tr><td style="color: {series.color}">消耗: </td>' +
            //'<td style="text-align: right"><b>{point.y}</b></td></tr>',
            //footerFormat: '</table>',
            valueDecimals: 2 //数据值保留小数位数
        }

    });
    $('#turnoverChart').highcharts({
        title: {
            text: ''
        },
        chart: {
            type: 'scatter'
        },
        credits: {
            enabled: false
        },
        legend: {
            enabled: false
        },
        exporting: {
            enabled: false
        },
        lang: {
            noData: "请选择门店"
        },
        noData: {
            style: {
                'font-family': "微软雅黑",
                'color': '#52585b',
                'fontSize': '15px'
            }
        },
        xAxis: {
            categories: timePeriod,
            labels: {
                rotation: -40,
                align: 'center'
            }
        },
        yAxis: {
            title: {
                text: ''
            },
            gridLineDashStyle: 'longdash'
        },
        tooltip: {
            shared: true, //是否共享提示，也就是X一样的所有点都显示出来
            pointFormat: '<tr><td style="color: {series.color}">营业额: </td>' +
            '<td style="text-align: right"><b>{point.y}(￥)</b></td></tr>',
            valueDecimals: 2 //数据值保留小数位数
        }

    });
}
/**
 * 设置消耗图表数据
 */
function setConsumeChart() {
    if (!$('#sp_branch').combobox('isValid')) {
        $('#sp_branch').combobox('validate');
        return false;
    }
    pushRowsArrayType = 1;
    doSearchGoods(goods_url);
}
/**
 * 设置营业额图表数据
 */
function setTurnoverChart(branchId) {
    $.ajax({
        type: "GET",
        url: turnoverChart_url + '&branchId=' + branchId,
        cache: false,
        async: false,
        dataType: "json",
        success: function (data) {
            var chart = $('#turnoverChart').highcharts();
            if (chart.series.length > 0) {
                chart.series[0].remove(false);
            }
            $.each(branchList, function (index, branch) {
                if (branch.id == branchId) {
                    $('#class_p_t').html('营业额:' + branch.name);
                }
            });
            chart.addSeries({
                id: 1,
                type: 'line',
                name: '营业额',
                color: '#ffa800',
                data: data
            }, 100);
        }
    });
}
/**
 * 查询消耗图表数据
 * @param goods
 */
function queryConsumeChartData(goods) {
    var branchId = $('#sp_branch').combobox('getValue');
    $.ajax({
        type: "GET",
        url: consumeChart_url + '?goodsId=' + goods.id + '&branchId=' + branchId,
        cache: false,
        async: false,
        dataType: "json",
        success: function (data) {
            var chart = $('#consumeChart').highcharts();
            if (chart.series.length > 0) {
                chart.series[0].remove(false);
            }
            //chart.setTitle({ text: goods.goodsName});
            $('#class_p_c').html('消耗:' + goods.goodsName);
            chart.addSeries({
                id: 1,
                type: 'line',
                name: '消耗',
                color: '#00e138',
                data: data
            }, 100);
        }
    });
}

/****************************************函数***************************/
/**
 * 计算timePeriod
 */
function opTimePeriod() {
    $.each(timePeriodStr.split(','), function (index, item) {
        timePeriod.push(item);
    })
}
function branchOnSelect(row) {
    var branchId = $('#sp_branch').combobox('getValue');
    if (branchId == '') {
        return false;
    }
    if (branchId != getCookie('_shipping_branchId_')) {
        if ($('#shipping_detail').datagrid('getRows').length > 0 && update_p_o) {
            $.messager.confirm('系统提示', '计划还未保存,确定离开?', function (r) {
                if (r) {
                    setFrom(branchId);
                } else {
                    $('#sp_branch').combobox('setValue', getCookie('_shipping_branchId_'));
                }
            });
        } else {
            setFrom(branchId);
        }
    } else {
        setFrom(branchId);
    }
}
function branchValid(value) {
    var data = $('#sp_branch').combobox('getData');
    var valid = false;
    for (var x = 0; x < data.length; x++) {
        if (data[x].name == value) {
            valid = true;
            break;
        }
    }
    return valid;
}
function sPDateOnSelect(date) {
    var branchId = $('#sp_branch').combobox('getValue');
    var editLength = $('#shipping_detail').datagrid('getRows').length;
    if (!$('#sp_branch').combobox('isValid')) {
        return false;
    }
    if (editLength > 0 && update_p_o) {
        $.messager.confirm('系统提示', '计划还未保存,确定离开?', function (r) {
            if (r) {
                $('#spDate').datebox('hidePanel');
                $('#spDate').datebox('setValue', $.formatDate("yyyy-MM-dd", date));
                setDateGrid(branchId);
            }
        });
    } else {
        $('#spDate').datebox('hidePanel');
        $('#spDate').datebox('setValue', $.formatDate("yyyy-MM-dd", date));
        setDateGrid(branchId);
    }
    return true;
}
function setDateGrid(branchId) {
    var details = queryBranchExistPlan(branchId);
    $('#shipping_detail').datagrid('loadData', []);
    editIndex = undefined; //当前编辑状态的列号
    deleteIndex = undefined;
    planId = undefined;
    pushRowsArrayType = undefined;
    update_p_o = false;
    if (details.length > 0) {
        $('.class_param').hide();
        $('.class_add').show();
        appendRows(details, null);
        curInitSpType = 0;//修改时使用全部
        planId = details[0].planId;
    } else {
        curInitSpType = undefined;
        $('.class_add').hide();
        $('.class_param').show();
    }
}
/**
 * 重置表单
 * @param branchId
 */
function setFrom(branchId) {
    setTurnoverChart(branchId);
    addCookie("_shipping_branchId_", branchId); //30天
    var cur_goods = getCookie("_shipping_xh_goods") ? $.evalJSON(getCookie("_shipping_xh_goods")) : null;
    if (cur_goods) {
        queryConsumeChartData(cur_goods);
    }
    setDateGrid(branchId);
}
/**
 * 获得门店指定日期存在的配货计划
 */
function queryBranchExistPlan(branchId) {
    var details = [];
    var spDate = dateFormatter($('#spDate').datebox('getValue'));
    var url = exist_plan_url + 'branchId=' + branchId + '&spDate=' + spDate;
    $.ajax({
        type: "GET",
        url: url,
        cache: false,
        async: false,
        dataType: "json",
        success: function (data) {
            details = data;
        }
    });
    return details;
}
function getBranchList(data) {
    branchList = data;
    var oldBranchId = getCookie('_shipping_branchId_');
    $('#sp_branch').combobox('select', oldBranchId);
    //setTurnoverChart(oldBranchId);
    //$('.class_param').show();
}
function doSearchGoods(url) {
    $("#goodsDialog").dialog({
        href: url
    }).dialog("open");
}
function _get_push() {
    return [];
}
function closeGoodsDialog() {
    $('#goodsDialog').dialog('close');
}
function addCookie(name, value) {
    var path = window.location.pathname.substr(0,window.location.pathname.lastIndexOf('/')+1);
    $.cookie(name, value, {expires: 365, path: path});
}
function getCookie(name){
    return $.cookie(name);
}
/**
 * 商品选择回掉函数
 * @param f
 */
function pushRowsArray(goodsList) {
    if (pushRowsArrayType == 1) {
        addCookie("_shipping_xh_goods", $.toJSON(goodsList[0]));
        closeGoodsDialog();
        queryConsumeChartData(goodsList[0]);
    } else {
        var existGoods = $('#shipping_detail').datagrid('getRows');
        var isInsert = true;
        $.each(existGoods, function (x, goods) {
            if (goods.goodsId == goodsList[0].id) {
                isInsert = false;
                return false;
            }
        });
        if (isInsert) {
            shippingInit(goodsList[0]);
            isAdd = false;
        } else {
            $.messager.alert('系统提示', '商品【' + goodsList[0].goodsName + '】已存在', 'info');
        }
    }
}
/**
 * 选中菜品
 */
function checkSelectedItem() {
    $('#goodsTable').datagrid('clearSelections');
    var cur_goods = getCookie("_shipping_xh_goods") ? $.evalJSON(getCookie("_shipping_xh_goods")) : null;
    if (pushRowsArrayType == 1 && cur_goods) {
        $('#goodsTable').datagrid('selectRecord', cur_goods.id);
        return;
    }
    var row = $('#shipping_detail').datagrid('getRows');
    $.each(row, function (i, item) {
        $('#goodsTable').datagrid('selectRecord', item.goodsId);
    });
}
/****************************************明细***************************/
function newDataGrid() {
    $("#shipping_detail").datagrid({
        pagination: false,
        fit: true,
        height: "auto",
        fitColumns: false,
        idField: 'id',
        rownumbers: true,
        singleSelect: true,
        onClickRow: onClickRow,
        frozenColumns: [],
        columns: [[
            {field: 'op', title: '操作', width: 107, align: 'center', rowspan: 2},
            {field: 'goodsId', rowspan: 2, hidden: true},
            {
                field: 'goodsCode', title: '编码', width: 120, align: 'center', rowspan: 2,
                editor: {
                    type: 'textbox', options: {
                        editable: false, buttonText: '...', required: true, missingMessage: '请添加菜品',
                        onClickButton: function () {
                            pushRowsArrayType = 2;
                            doSearchGoods(goods_url);
                        }
                    }
                }
            },
            {field: 'goodsName', title: '名称', width: 223, align: 'left', rowspan: 2},
            {title: '上次配货', colspan: 3},
            {field: 'storeQuantity', title: '库存余量', width: 80, align: 'right', rowspan: 2},
            {title: '本次配货', colspan: 3}
        ], [
            {
                field: 'lastShippingPrice', title: '配货价', width: 80, align: 'right',
                formatter: function (val, row) {
                    return moneyFormatter2(val);
                }
            },
            {field: 'lastCycle', title: '配货天数', width: 80, align: 'right'},
            {
                field: 'lastShippingNum', title: '配货数量', width: 80, align: 'right',
                formatter: function (val, row) {
                    return numberF(val);
                }
            },
            {
                field: 'shippingPrice', title: '配货价', width: 100, align: 'right',
                editor: {
                    type: 'numberspinner', options: {
                        precision: 2, min: 0.00, max: 9999.99, required: true, missingMessage: '配货价',
                        onChange: function (newValue, oldValue) {
                        }
                    }
                },
                formatter: function (val, row) {
                    return moneyFormatter2(val);
                }
            },
            {
                field: 'cycle', title: '配货天数', width: 100, align: 'right',
                editor: {
                    type: 'numberspinner', options: {
                        precision: 0, min: 1, max: 365, required: true, missingMessage: '配货天数',
                        onChange: function (newValue, oldValue) {
                        }
                    }
                }
            },
            {
                field: 'shippingNum', title: '配货数量', width: 100, align: 'right',
                editor: {
                    type: 'numberspinner', options: {
                        precision: 2, min: 1, max: 9999.99, required: true, missingMessage: '配货数量',
                        onChange: function (newValue, oldValue) {
                        }
                    }
                },
                formatter: function (val, row) {
                    return numberF(val);
                }
            }
        ]],
        onLoadSuccess: function (data) {
            if (data.rows == 0) {
            }
        }
    });
}
/**
 * 初始化组件
 */
function initPlugins() {
    $('#shippingInitTypeDialog').dialog({
        title: "初始化配货计划",
        closed: true,
        modal: true,
        closable: true,
        top: '80px'
    });
}
function closeDialog(val) {
    if (val) {
        $('#shippingInitTypeDialog').dialog('close');
    } else {
        $('#shippingInitTypeDialog').dialog('open');
    }
}
function closeGoodsDialog() {
    $('#goodsDialog').dialog('close');
}
//var cur_goods = undefined; //当前选中的商品Id
var editIndex = undefined; //当前编辑状态的列号
var deleteIndex = undefined;
var planId = undefined;
var update_p_o = false;
var pushRowsArrayType = undefined; // 菜品回掉函数类型 : 1 - 消耗图表 2 - 计划明细
var em_res = {
    goodsId: null,
    goodsCode: null,
    goodsName: null,
    lastShippingPrice: null,
    lastCycle: null,
    lastShippingNum: null,
    storeQuantity: null,
    shippingPrice: null,
    cycle: null,
    shippingNum: null
};
var curInitSpType = undefined //当前配货计划初始化类型
/**
 * 添加商品配货计划
 * @param resList
 */
function appendRows(resList, isUpdate) {
    $.each(resList, function (index, res) {
        update_p_o = true;
        if (isUpdate != null) {
            var rowEdits = $('#shipping_detail').datagrid('getEditors', editIndex);
            rowEdits[0].target.textbox('setValue', res.goodsCode);
            rowEdits[1].target.numberspinner('setValue', 1);
            rowEdits[2].target.numberspinner('setValue', 1);
            rowEdits[3].target.numberspinner('setValue', 1);
            $('#shipping_detail').datagrid('endEdit', editIndex);
            var row = getRowByIndex(editIndex);
            row.goodsId = res.goodsId;
            row.goodsName = res.goodsName;
            row.lastShippingPrice = res.lastShippingPrice;
            row.lastCycle = res.lastCycle;
            row.lastShippingNum = res.lastShippingNum;
            row.storeQuantity = res.storeQuantity;
            row.shippingPrice = res.shippingPrice;
            row.cycle = res.cycle;
            row.shippingNum = res.shippingNum;
            $('#shipping_detail').datagrid('refreshRow', editIndex);
            $('#shipping_detail').datagrid('beginEdit', editIndex);
        } else if (endEditing()) {
            $('#shipping_detail').datagrid('insertRow', {
                row: {
                    op: add_table + del_table,
                    goodsId: res.goodsId,
                    goodsCode: res.goodsCode,
                    goodsName: res.goodsName,
                    lastShippingPrice: res.lastShippingPrice,
                    lastCycle: res.lastCycle,
                    lastShippingNum: res.lastShippingNum,
                    storeQuantity: res.storeQuantity ? res.storeQuantity : 0,
                    shippingPrice: res.shippingPrice ? res.shippingPrice : 0,
                    cycle: res.cycle ? res.cycle : 0.01,
                    shippingNum: res.shippingNum ? res.shippingNum : 1
                }
            });
            editIndex = $('#shipping_detail').datagrid('getRows').length - 1;
            $('#shipping_detail').datagrid('beginEdit', editIndex);
        }
    });
}
function endEditing() {
    if (editIndex == undefined) {
        return true
    }
    if ($('#shipping_detail').datagrid('validateRow', editIndex)) {
        $('#shipping_detail').datagrid('endEdit', editIndex);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function onClickRow(index) {
    if (deleteIndex != undefined) {
        deleteIndex = undefined;
        return false;
    }
    if (editIndex != index) {
        if (endEditing()) {
            update_p_o = true
            $('#shipping_detail').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#shipping_detail').datagrid('selectRow', editIndex);
        }
    }
}
function removeit(obj) {
    var editRow = undefined;
    deleteIndex = getRowIndex(obj);
    if (editIndex != deleteIndex) { //如果编辑行不是当前删除行，则重新计算 否至空editIndex
        editRow = getRowByIndex(editIndex);
    }
    $('#shipping_detail').datagrid('cancelEdit', deleteIndex)
        .datagrid('deleteRow', deleteIndex);
    if (editRow) { //重新计算
        var rows = $('#shipping_detail').datagrid('getRows');
        $.each(rows, function (index, row) {
            if (row.goodsId == editRow.goodsId) {
                editIndex = $('#shipping_detail').datagrid('getRowIndex', row);
                return false;
            }
        });
    } else {
        editIndex = undefined;
    }
    var exitRowNumber = $('#shipping_detail').datagrid('getRows').length;
    if (exitRowNumber <= 0) {
        $('.class_param').show();
        $('.class_add').hide();
    }
}
/**
 * 根据行号获得行数据
 * @param index
 */
function getRowByIndex(index) {
    var rows = $('#shipping_detail').datagrid('getRows');
    var resultRow = undefined;
    $.each(rows, function (x, row) {
        if ($('#shipping_detail').datagrid('getRowIndex', row) == index) {
            resultRow = row;
            return false;
        }
    });
    return resultRow;
}
function getRowIndex(target) {
    var tr = $(target).closest('tr.datagrid-row');
    return parseInt(tr.attr('datagrid-row-index'));
}
/**
 * 添加空行
 */
var isAdd = false;
function insertEmRow() {
    //appendRows([em_res], null);
    pushRowsArrayType = 2;
    doSearchGoods(goods_url);
    isAdd = true;
}
/****************计算*******************/

function shippingInit(goodId) {
    if (goodId == null) {
        $('.class_param').hide();
        $('.class_add').show();
        curInitSpType = $('input:radio[name="initSpType"]:checked').val();
    }
    var type = curInitSpType;
    type = goodId && type == 3 ? 0 : type; // 单个商品如果是空白单据则使用 自动补货计算
    if (type == 3) {
        appendRows([em_res], null);
        closeDialog(true);
    } else {
        var branchId = $('#sp_branch').combobox('getValue');
        var spDate = $('#spDate').datebox('getValue');
        var url = init_sp_url + 'branchId=' + branchId
            + '&initSpType=' + type + '&spDate=' + spDate;
        goodId ? url += '&goodsId=' + goodId.id : null;
        $.ajax({
            type: "GET",
            url: url,
            cache: false,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data.length == 0) {
                    data.push(em_res);
                }
                closeGoodsDialog();
                closeDialog(true);
                if (isAdd) {
                    appendRows(data, null);
                } else {
                    appendRows(data, goodId);
                }
            }
        });
    }
}
/**
 * 保存配货计划
 */
function savePlan(url) {
    if (endEditing()) {
        var rows = $('#shipping_detail').datagrid('getRows');
        var plan = new Object();
        var detailList = [];
        var branchId = $('#sp_branch').combobox('getValue');
        $.each(rows, function (index, row) {
            var detail = new Object();
            detail.shippingPrice = row.shippingPrice;
            detail.shippingAmount = row.shippingAmount;
            detail.shippingNum = row.shippingNum;
            detail.branchId = branchId;
            detail.goodsId = row.goodsId;
            detail.cycle = row.cycle;
            detailList.push(detail)
        })
        plan.branchId = branchId;
        plan.id = planId ? planId : null;
        plan.shippingAt = dateFormatter($('#spDate').datetimebox('getValue'));

        $.messager.confirm('系统提示', '确定保存?', function (r) {
            if (r) {
                $('.class_add').hide();
                url += '?plan=' + $.toJSON(plan) + '&detail=' + $.toJSON(detailList);
                planId ? url += '&id=' + planId : '';
                $.post(url, function (data) {
                    if (data.success == 'true') {
                        planId = data.order.id;
                        update_p_o = false;
                    }
                    $('.class_add').show();
                    $.messager.alert('系统提示', data.msg, 'info');
                }, 'json');
            }
        });
    }
}