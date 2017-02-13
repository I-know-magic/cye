/**
 * 初始化查询条件：审核人 制单人
 */
function initHUser(url) {
    url = url + '?random=' + Math.random();
    $.get(url, function (data) {
        debugger;
        $('#q_makeName').combobox('loadData', data);
        $('#q_auditName').combobox('loadData', data);
        // $('#q_makeName').combobox("select", 0);
        // $('#q_auditName').combobox("select", 0);
        doSearch_so();
    }, 'json');
    initBranch();
}
function init_eas() {
    $("#pro_memo").textbox({
        width: 200,
        prompt: '请输入备注',
        multiline: true,
        validType: 'maxLength[255]',
        invalidMessage:'长度不超过255个汉字或字符！'
    });
}
function initBranch() {
    var h_branch_type = $('#h_branch_type').val();
    if (h_branch_type != 0) {
        $('.p_branch_').hide();
    }
    $("#branch").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            $("#select_dialog").dialog({
                href: h_branch_url + '?checkBranchId=' + $('#branchMenu_r').val(),
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择门店");
        }
    });
}
function setSelectObj(id, name, isWhere) {
    if (isWhere === "2") {
        $("#branchMenu_r").val(id);
        $("#branch").textbox("setValue", name);
    }
    closeReport();
}
function closeReport() {
    $("#select_dialog").dialog("close");
}

var ii = 0
var editRowIndex ;
var jj_oldValue_so = '0';
var _oldValue_so = '0';
var _purchaseAmount;
function newDataGrid( proStatus) {
    var h_op_type = $('#h_op_type').val();
    $("#goodsTable_info").datagrid({
        singleSelect: false,
        pagination: false,
        fit: true,
        height:"auto",
        fitColumns: false,
        idField: 'id',
        showFooter: true,
        rownumbers: true,
        onClickCell: function (index, field, value) {
                beginEdit(index);
        },
        columns: [[
            {field: 'add',title: '操作', width: 80},
            {field: 'barCode', title: '商品编码', width: 255, align: 'center',
                editor: {
                    type:'textbox',
                    options:{
                        required: true,
                        missingMessage:'商品编码为必填项',
                        editable:true,
                        buttonText:"...",
                        onClickButton: function () {
                            storeOrder_addGoods()
                        },
                        onChange:function(newValue,oldValue){
                            importGoods(oldValue,newValue,queryUrl);
                            editRowIndex = getRowIndex(this);
                            $('#goodsTable_info').datagrid("endEdit", editRowIndex);
                            $('#goodsTable_info').datagrid("beginEdit", editRowIndex);
                        }
                    }
                }},
            {field: 'goodsName', title: '商品名称', width: 200, align: 'left'},
            {field: 'categoryName', title: '小类', width: 100, align: 'center'},
            {field: 'goodsUnitName', title: '单位', width: 80, align: 'center'},
            {
                field: 'salePrice', title: '售价', width: 80, align: 'right',
                formatter: function (val, row) {
                    return moneyFormatter2(val);
                }
            },
            {field: 'goodsId', title: '产品id', hidden: true},
            {
                field: 'purchaseAmount',
                title: '进价',
                align: 'right',
                width: 110,
                editor: {
                    type: 'numberbox', options: {
                        precision: 2, min: 0, max: 9999.99, required: true,missingMessage:'进价为必填项',
                        onChange: function (newValue, oldValue) {
                            _purchaseAmount = newValue;
                            editRowIndex = getRowIndex(this);
                            _oldValue_so = newValue == '' ? oldValue : _oldValue_so;
                            oldValue = _oldValue_so == '0' ? oldValue : _oldValue_so;
                            if (oldValue != "" && newValue != '') {
                                amountOperation(parseFloat(newValue), oldValue, 1);
                                return false;
                            }
                        }
                    }
                },
                formatter: function (val, row) {
                    return moneyFormatter2(val);
                }
            },
            {
                field: 'quantity',
                title: order_type_quantity,
                width: 120,
                align: 'right',
                editor: {
                    type: 'numberspinner', options: {
                        precision: 2, min: 0, max: 999.99, required: true,missingMessage:order_type_quantity+'为必填项',
                        onChange: function (newValue, oldValue) {
                            editRowIndex = getRowIndex(this);
                            jj_oldValue_so = newValue == '' ? oldValue : jj_oldValue_so;
                            oldValue = jj_oldValue_so == '0' ? oldValue : jj_oldValue_so;
                            if(_purchaseAmount == undefined|| _purchaseAmount==''){
                                $.messager.alert('系统提示','请先添加商品！','warning');
                                return
                            }
                            if (oldValue != "" && newValue != '') {
                                amountOperation(newValue, oldValue, 2);
                                return false;
                            }
                        }
                    }
                },
                formatter: function (val, row) {
                    return numberF(val);
                }
            },
            {
                field: 'amount', title: order_type_amount, width: 120, align: 'right',
                formatter: function (val, row) {
                    return moneyFormatter(val);
                }
            },
        ]],
        onLoadSuccess: function (data) {
            if(proStatus == 1){
                $.each(data.rows,function(index,item){
                    $('#goodsTable_info').datagrid("endEdit", index);
                });
            }else if(proStatus == 2){
                $.each(data.rows,function(index,item){
                    $('#goodsTable_info').datagrid("beginEdit", index);
                });
            }

        }
    });
    $('#goodsTable_info').datagrid('reloadFooter', [{
        barCode: '合计：',
        purchaseAmount: '0.00',
        quantity: '0.00',
        amount: '0.00'
    }]);
    if(proStatus == ''){
        insert();
    }
}
var havedRows = [];
function importGoods(oldValue,newValue,queryUrl){
    if(isRefresh &&((newValue && !oldValue) || (oldValue && newValue && newValue!=oldValue))){
        var url = queryUrl+newValue+"&isStore=1";
        $.post(url,null, function (data) {
            if(data.total == 1){
                storeOrder_pushMenuRows(data.rows,false)
            }else{
                havedRows = [];
                havedRows = $("#goodsTable_info").datagrid('getRows');
                storeOrder_addGoods(false,newValue)
            }
        },"json");
    }

}
function operator() {
    return add + d;
}
function insert() {
    $('#goodsTable_info').datagrid('insertRow', {
        row: {
            add: operator()
        }
    });
    var row = $('#goodsTable_info').datagrid('getRows');
    if (row) {
        var num = row.length - 1;
        var index = $('#goodsTable_info').datagrid('getRowIndex', row[num]);
    } else {
        index = 0;
    }
    $('#goodsTable_info').datagrid('beginEdit', index);
}
var isRefresh = true;
function appendGoodsRow() {
    _purchaseAmount = '';
    isRefresh = true;
    $('#goodsTable_info').datagrid('appendRow', {
        add: operator()
    });
    var row = $('#goodsTable_info').datagrid('getRows');
    $.each(row,function(index,item){
        $('#goodsTable_info').datagrid('beginEdit', index);
    });
}
function deleterow(target) {
    var row = $('#goodsTable_info').datagrid('getRows');
    if (row.length > 1) {
        $.messager.confirm('系统提示', '你确定删除?', function (r) {
            if (r) {
                var deleteRow = row[getRowIndex(target)];
                footerOperation('-',deleteRow.purchaseAmount,deleteRow.quantity,deleteRow.amount);
                $('#goodsTable_info').datagrid('deleteRow', getRowIndex(target));
            }
        });
    }else{
        $.messager.alert("系统提示", "商品明细不能为空！", "warning");
    }
}
function getRowIndex(target) {
    var tr = $(target).closest('tr.datagrid-row');
    return parseInt(tr.attr('datagrid-row-index'));
}
function storeOrder_add_good(){
    var rows = $("#goodsTable").datagrid("getSelections");
    //模糊检索出多条数据
    if(havedRows.length > 0 &&  $("#queryStr").val()!=''){
        $.each(havedRows,function(index,item){
            if(item.goodsId!=undefined){
                if($.inArray(item.goodsId,selectedIds) == -1 && $.inArray(item.goodsId,unselectedIds) == -1){
                    rows.push(item)
                }
            }
        });
    }
    if (rows.length == 0) {
        $.messager.alert("系统提示", "你还没有选择任何商品!", "info");
        return;
    }
    storeOrder_pushMenuRows(rows,true);
}
function checkSelectedItem() {
        var row = $('#goodsTable_info').datagrid('getRows');
        $.each(row, function (i, item) {
            $('#goodsTable').datagrid('selectRecord', item.goodsId);
        });
}
function storeOrder_pushMenuRows(f,dialogFlag){
    var purchaseAmount;//进价
    var quantity;//出入库数量
    var goodsId;
    var reLoadFooter = true;
    isRefresh = false;
    var oldRow = $('#goodsTable_info').datagrid('getRows');
    var tempOldRow = oldRow;
    $('#goodsTable_info').datagrid('loadData',{total:0,rows:[]});
    //var oldRow = $('#goodsTable_info').data("_old_rows");
    if(!oldRow){
        // 如果原行数据为空则缓存行数据
        oldRow = f;
    }else{
        // 如果原行数据不为空，进行补充或者替换
        if(dialogFlag){
            if($('#goodsTable_info').data("_replace")){
                // 当前为弹窗时，如果为正常弹窗替换数据
                if(oldRow.length > f.length){
                    // 删除之前勾选这次没有勾选的
                    for(var n in tempOldRow){
                        var temp_row = tempOldRow[n];
                        var isDeletes = [];
                        for(var m in f){
                            if(f[m].id == temp_row.goodsId){
                                isDeletes.push(true)
                            }else{
                                isDeletes.push(false)
                            }
                        }
                        if($.inArray(true, isDeletes) == -1){
                            oldRow.splice(n,1);
                            footerOperation('-',temp_row.purchaseAmount,temp_row.quantity,temp_row.amount);
                            reLoadFooter = false
                        }
                    }
                }
                for(var key in f){
                    var wating_append_row = f[key];
                    var isAppend = true;
                    for(var k in oldRow){
                        if(oldRow[k].goodsId == wating_append_row.id){
                            isAppend = false;
                            break;
                        }
                    }
                    if(isAppend){
                        oldRow.push(wating_append_row)
                    }
                }

                //oldRow = f;
            }else{
                // 为模糊检索的弹窗要在原始数据中加入新的行数据
                if(oldRow.length  > f.length){
                    // 删除之前勾选这次没有勾选的
                    for(var n in tempOldRow){
                        var temp_row = tempOldRow[n];
                        if(temp_row.id!=undefined){
                            var isDeletes = [];
                            for(var m in f){
                                if(f[m].id == temp_row.goodsId){
                                    isDeletes.push(true)
                                }else{
                                    isDeletes.push(false)
                                }
                            }
                            if($.inArray(true, isDeletes) == -1){
                                oldRow.splice(n,1);
                                footerOperation('-',temp_row.purchaseAmount,temp_row.quantity,temp_row.amount);
                                reLoadFooter = false
                            }
                        }

                    }
                }else if(oldRow.length - 1  <= f.length){
                    //模糊查询，然后重置搜索框，查询全部，然后选择
                    var oldRowIds = [];
                    $.each(oldRow,function(index,item){
                        if(item.goodsId!=undefined){
                            oldRowIds.push(item.goodsId)
                        }
                    });
                    var fIds = [];
                    $.each(f,function(index,item){
                        fIds.push(item.id)
                    });
                    var removeIds = [];
                    $.each(oldRowIds,function(index,value){
                        if($.inArray(value,fIds)==-1){
                            removeIds.push(value)
                        }
                    });
                    $.each(removeIds,function(index,value){
                        for(var n in oldRow){
                            if(oldRow[n].goodsId == value){
                                footerOperation('-',oldRow[n].purchaseAmount,oldRow[n].quantity,oldRow[n].amount);
                                oldRow.splice(n,1);
                                //reLoadFooter = false;
                            }
                        }
                    });
                }
                for(var key in f){
                    var wating_append_row = f[key];
                    var isAppend = true;
                    for(var k in oldRow){
                        if(oldRow[k].goodsId == wating_append_row.id){
                            isAppend = false;
                            break;
                        }
                    }
                    if(isAppend){
                        oldRow.push(wating_append_row)
                    }
                }
            }
        }else{
            // 当前为检索出一条数据时，在原始数据中加入新的行数据
            var isAppend = true;
            for(var key in oldRow){
                if(oldRow[key].goodsId == f[0].id){
                    isAppend = false;
                    reLoadFooter = false;
                    $.messager.alert('系统提示', '商品不能重复添加！', 'warning');
                    break;
                }
            }
            if(isAppend){
                oldRow.push(f[0]);
            }
        }
    }
    //$('#goodsTable_info').data("_old_rows",oldRow);

    $.each(oldRow, function (index, item) {
        if(item.barCode!=undefined){
            if(item.purchaseAmount!=null){
                purchaseAmount = item.purchaseAmount
            }else if(item.purchasingPrice!=null){
                purchaseAmount = item.purchasingPrice
            }
            if(item.quantity){
                quantity = item.quantity
                goodsId = item.goodsId
            }else{
                quantity = 0;
                goodsId = item.id
            }
            $('#goodsTable_info').datagrid('appendRow',
                {
                    add: operator(),
                    id: item.id,
                    barCode: item.barCode,
                    goodsName: item.goodsName,
                    categoryName: item.categoryName,
                    goodsUnitName: item.goodsUnitName,
                    salePrice: item.salePrice,
                    goodsId: goodsId,
                    purchaseAmount: purchaseAmount,
                    quantity: quantity,
                    amount: (quantity * purchaseAmount).toFixed(2)
                }
            );
            if(item.quantity == undefined && reLoadFooter){
                footerOperation('+', purchaseAmount, quantity, quantity * purchaseAmount);
            }

        }
    });
    //让所有行处于可编辑状态
    $.each(oldRow,function(index,item){
        $('#goodsTable_info').datagrid("beginEdit", index);
    });
    $('#goodsDialog').dialog('close');
    $('#tenant_query').val('');
    $('#goodsTable_info').datagrid('getFooterRows')
}

function amountOperation(newValue, oldValue, colType) {
    var rows = $('#goodsTable_info').datagrid('getRows');
    $.each(rows, function (i, item) {
        if (i == editRowIndex) {
            if (colType == 1) {
                var oldQuantity = parseFloat(item.quantity);
                var hj_purchaseAmount = (parseFloat(newValue) - parseFloat(oldValue)).toFixed(2);
                var hj_amount = oldQuantity * parseFloat(newValue) - parseFloat(item.amount);
                footerOperation('+', hj_purchaseAmount, 0, hj_amount);
                item.amount = (oldQuantity * parseFloat(newValue)).toFixed(2);
                item.purchaseAmount = parseFloat(newValue).toFixed(2);
            } else {
                var oldPurchaseAmount = parseFloat(item.purchaseAmount);
                var hj_quantity = (parseFloat(newValue) - parseFloat(oldValue)).toFixed(2);
                var hj_amount = oldPurchaseAmount * parseFloat(newValue) - parseFloat(item.amount);
                footerOperation('+', 0, hj_quantity, hj_amount);
                item.amount = (oldPurchaseAmount * parseFloat(newValue)).toFixed(2);
                item.quantity = parseFloat(newValue).toFixed(2);
            }

            return;
        }
    });

    if (colType == 1) {
        _oldValue_so = '0';
    }
    if (colType == 2) {
        jj_oldValue_so = '0';
    }
    if (editRowIndex != -1) {
        endEdit(editRowIndex);
        $('#goodsTable_info').datagrid('refreshRow', editRowIndex);
        beginEdit(editRowIndex);
    }
    //if(newValue){$("#goodsTable_info").data("is_update",true)}
}
function footerOperation(op, purchaseAmount, quantity, amount) {
    var rows = $('#goodsTable_info').datagrid('getFooterRows');
    if (op === '+') {
        rows[0]['purchaseAmount'] = (parseFloat(rows[0]['purchaseAmount']) + parseFloat(purchaseAmount)).toFixed(2);
        rows[0]['amount'] = (parseFloat(rows[0]['amount']) + parseFloat(amount)).toFixed(2);
        rows[0]['quantity'] = (parseFloat(rows[0]['quantity']) + parseFloat(quantity)).toFixed(2);
    }
    if (op === '-') {
        rows[0]['purchaseAmount'] = (parseFloat(rows[0]['purchaseAmount']) - parseFloat(purchaseAmount)).toFixed(2);
        rows[0]['amount'] = (parseFloat(rows[0]['amount']) - parseFloat(amount)).toFixed(2);
        rows[0]['quantity'] = (parseFloat(rows[0]['quantity']) - parseFloat(quantity)).toFixed(2);
    }
    $('#goodsTable_info').datagrid('reloadFooter');
}

function deleteGoods() {
    var rows = $('#goodsTable_info').datagrid('getSelections');
    var size_ttt = rows.length;
    for (var x = 0; x < size_ttt; x++) {
        var a = $('#goodsTable_info').datagrid('getSelections');
        $('#goodsTable_info').datagrid('deleteRow', $('#goodsTable_info').datagrid('getRowIndex', a[0]));
    }
    $('#goodsTable_info').datagrid('clearSelections');
}
function validateRow(i) {
    return $('#goodsTable_info').datagrid("validateRow", i);
}
function endEdit(i) {
    $('#goodsTable_info').datagrid("endEdit", i);
}
function endGridEdit(rows){
    for(var key in rows){
        var rowIndex= $('#goodsTable_info').datagrid("getRowIndex",rows[key]);
        $('#goodsTable_info').datagrid("endEdit",rowIndex);
    }
}
function beginGridEdit(rows){
    for(var key in rows){
        $('#goodsTable_info').datagrid("beginEdit",key);
    }
}
function beginEdit(i) {
    var h_id = $('#h_id').val();
    if (h_id === '' || update_p_o == true) {
        $('#goodsTable_info').datagrid("beginEdit", i);
    }
}

var warningCodes = [];
var errorCodes = [];
var errorAmount = [];
var warningGoodsCode = [];
function setSaveData() {
    warningCodes.length = 0;
    errorCodes.length = 0;
    errorAmount.length = 0;
    warningGoodsCode.length = 0;
    if (!$('#storeOrderForm').form('validate')) {
        return false;
    }
    $('#goodsTable_info').datagrid('checkAll');
    var isOkSave = false;
    var errorIndex = 0;
    var row = $('#goodsTable_info').datagrid('getRows');
    $.each(row, function (i, item) {
        if (!validateRow(i)) {
            isOkSave = false
            errorIndex = i + 1;
            $('#goodsTable_info').datagrid('uncheckRow', i);
            return false;
        }
        isOkSave = true;
        endEdit(i);
    });
    if (!isOkSave) {
        if (errorIndex == 0) {
            $.messager.alert('系统提示', '请添加明细！', 'info');
        } else {
            $.messager.alert('系统提示', '请正确添加第【' + errorIndex + '】行明细！', 'info');
        }
        return false;
    }
    row = $('#goodsTable_info').datagrid('getRows');
    var h_detailsStr = '';
    var j_total = 0;
    $.each(row, function (i, item) {
        h_detailsStr = h_detailsStr + item.goodsId + ',' + item.purchaseAmount + ',' + item.quantity + ';';
        j_total++;
        if (parseFloat(item.amount) > 99999999.99) {
            errorAmount.push(i + 1);
        }
        if (parseFloat(item.purchaseAmount) == 0) {
            warningCodes.push(i + 1);
        }
        if (parseFloat(item.quantity) <= 0) {
            errorCodes.push(i + 1);
        }
        // if(item.barCode.length!=8){
        //     warningGoodsCode.push(i + 1);
        // }
    });
    if (j_total === 0) {
        $.messager.alert('系统提示', '请添加明细！', 'info');
        return false;
    }
    h_detailsStr = h_detailsStr.substr(0, h_detailsStr.length - 1);
    $('#h_detailsStr').val(h_detailsStr);
    return isOkSave;
}
function savePro(url) {
    if (setSaveData()) {
        var msg = '';
        if (errorAmount.length > 0) {
            $.messager.alert('系统提示', '第【' + errorAmount.toString() + '】行'+order_type_amount+'超出最大范围，请减小入库数量！', 'error',function(){
                beginEditAll()
            });

            return false;
        }
        if (warningCodes.length > 0) {
            msg = msg + '第【' + warningCodes.toString() + '】行进价为0，  ';
        }
        if (errorCodes.length > 0) {
            $.messager.alert('系统提示', '第【' + errorCodes.toString() + '】行'+order_type_quantity+'不能为 0！', 'error',function(){
                beginEditAll()
            });
            return false;
        }
        if(warningGoodsCode.length > 0){
            $.messager.alert('系统提示', '第【' + warningGoodsCode.toString() + '】行商品编码格式不正确，请正确填写!',  'error',function(){
                beginEditAll()
            });
            return
        }
        $.messager.confirm('系统提示', msg + '确定保存？', function (r) {
            if (r) {
                $('#storeOrderForm').form('submit', {
                    url: url,
                    //onSubmit: function () {
                    //    return setSaveData();
                    //},
                    success: function (data) {
                        var data = eval('(' + data + ')');
                        if ($('#h_id').val() == '') {
                            if (data.success == 'false') {
                                $.messager.alert('系统提示', data.msg, 'info');
                                return;
                            }else{
                                $('#h_id').val(data.order.id);
                                $.messager.confirm('审核确认', '保存成功，确定审核？', function (r) {
                                    if (r) {
                                        $.post(audit_url + data.order.id, function (data2) {
                                            if (data2.success == 'true') {
                                                //location.replace(audit_ok_url + data.order.id);
                                                location.replace(backUrl);
                                                return ;
                                            }
                                            $.messager.alert('系统提示', data.msg, 'info');
                                        }, 'json');
                                    }else{
                                        location.replace(add_ok_url + data.order.id);
                                    }
                                });
                            }
                            return;
                        }
                        $.messager.alert('系统提示', data.msg, 'info',function(){
                            //location.replace(add_ok_url + data.order.id);
                            beginEditAll();
                            //$("#goodsTable_info").data("is_update",false);
                        });
                        $('#h_id').val(data.order.id);
                        able('able');
                        $('#p_save').hide();
                        //$('#p_update').show();
                        $('#p_audit').show();
                        $('#p_del').show();
                        update_p_o = true;
                        $('#p_show_status').html('未审核');
                    }
                });
            }else{
                beginEditAll()
            }
        });
    }
}
function beginEditAll(){
    var rows = $('#goodsTable_info').datagrid('getRows');
    $.each(rows,function(i,item){
        $('#goodsTable_info').datagrid("beginEdit", i);
    });
}
//function myUpdate() {
//    able('enable');
//    $('#p_audit').hide();
//    $('#p_save').show();
//    $('#p_del').hide();
//    $('#p_update').hide();
//    update_p_o = true
//    $('#goodsTable').datagrid('uncheckAll');
//
//}
function myUpdate(){
    if( update_p_o){
        able('enable');
        //$('#p_audit').hide();
        $('#p_save').show();
        //$('#p_del').hide();
        $('#p_update').hide();
        $('#goodsTable').datagrid('uncheckAll');//一会删掉
    }
}
function initPro(url) {
    var h_id = $('#h_id').val();
    var h_status = $('#h_status').val();
    var h_op_type = $('#h_op_type').val();
    if (h_id !== '') {
        doSearchProG(url)
        able('disable');
        $('#p_save').hide();
        if (h_status === '1') {
            $('#p_audit').hide();
            $('#p_del').hide();
            $('#p_update').hide();
        }
        if (h_op_type === '-1') {
            $('#p_audit').hide();
            $('#p_del').hide();
            $('#p_update').hide();
        }
    } else {
        $('#p_audit').hide();
        $('#p_del').hide();
        $('#p_update').hide();
    }
    if ($('#h_status').val() === '2') {
        $('#p_show_status').html('未审核');
    }
    if ($('#h_status').val() === '1') {
        $('#p_show_status').html('已审核');
    }
    if ($('#h_status').val() === '') {
        $('#p_show_status').hide();
    }
}
function doSearchProG(url) {
    isRefresh = false;
    var h_id = $('#h_id').val();
    $.post(url + h_id, function (data) {
        $.each(data.rows,function(i,item){
            item.add = operator();
        });
        $('#goodsTable_info').datagrid('loadData',data.rows);
        $('#goodsTable_info').datagrid('reloadFooter',data.footer);
    }, 'json');
}
//function doSearchProG(url) {
//    var h_id = $('#h_id').val();
//    $('#goodsTable_info').datagrid({
//        url: url,
//        queryParams: {
//            storeOrderId: h_id
//        }
//    });
//}
function able(able) {
    $('#pro_memo').textbox(able);
    if ($('#pro_memo').textbox('getValue') == '') {
        $('#pro_memo').textbox('setValue', ' ');
    }
    if (able === 'disable') {
        $('#cp_remove').hide();
        $('#cp_ok').hide();
        return;
    }
    $('#cp_remove').show();
    $('#cp_ok').show();
}
function addPro() {
    doSearchGoods();
}
function storeOrder_closeGoodsDialog() {
    var rows = $('#goodsTable_info').datagrid('getRows');
    var row = rows[editRowIndex];
    if(row.goodsName== undefined){
        $('#goodsTable_info').clearGridEditorValue(editRowIndex);
    }
    $('#goodsDialog').dialog('close');
}
function _get_push() {
    return [];
}
function audit_order(url) {

    $.messager.confirm('系统提示', '请先保存数据,确定审核?', function (r) {
        if (r) {
            var h_id = $('#h_id').val();
            $.post(url + h_id, function (data) {
                if (data.success == 'true') {
                    //location.replace(audit_ok_url + h_id);
                    location.replace(backUrl);
                } else {
                    $.messager.alert('系统提示', data.msg, 'info');
                }
            }, 'json');
        }
    });
}