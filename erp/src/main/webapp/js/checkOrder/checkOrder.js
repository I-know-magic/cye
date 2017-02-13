/**
 * 初始化查询条件：审核人 制单人
 */
function initCheckOrderUser(url) {
    url = url + '?random=' + Math.random();
    $.get(url, function (data) {
        debugger;
        $('#q_makeName_ck').combobox('loadData', data);
        $('#q_auditName_ck').combobox('loadData', data);
        // $('#q_makeName_ck').combobox("select", 0);
        // $('#q_auditName_ck').combobox("select", 0);
        doSearch_so();
    }, 'json');
    initCheckOrderBranch();
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
function initCheckOrderBranch() {
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
    $("#pro_memo").textbox({
        width: 200,
        prompt:'请输入备注',
        multiline:true,
        validType:'maxLength[225]'
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
var _oldValue_so = '0';

function newCheckOrderDataGrid(proStatus) {
    var h_op_type = $('#h_op_type').val();
    //var checkBox = (proStatus == '2' || proStatus == '') && h_op_type != '3' ?
    //    [[{field: 'id', checkbox: true}]] : '';
    $("#goodsTable_info").datagrid({
        singleSelect: false,
        pagination: false,
        fit: true,
        height: 100,
        fitColumns: false,
        idField: 'id',
        showFooter: true,
        rownumbers: true,
        onClickCell: function (index, field, value) {
                beginEdit(index);
        },
        //frozenColumns: checkBox,
        columns: [[
            {field: 'add',title: '操作', width: 80},
            {field: 'barCode', title: '商品编码', width: 255, align: 'center'
                ,
                editor: {
                    type:'textbox',
                    options:{
                        required: true,
                        missingMessage:'商品编码为必填项',
                        editable:true,
                        buttonText:"...",
                        onClickButton: function () {
                            check_addGoods()
                        },
                        onChange:function(newValue,oldValue){
                            importGoods(oldValue,newValue,queryUrl);
                            editRowIndex = getRowIndex(this);
                            $('#goodsTable_info').datagrid("endEdit", editRowIndex);
                            $('#goodsTable_info').datagrid("beginEdit", editRowIndex);
                        }
                    }
                }},
            {field: 'goodsName', title: '商品名称', width: 100, align: 'left'},
            {field: 'categoryName', title: '商品类别', width: 80, align: 'left'},
            {field: 'goodsUnitName', title: '商品单位', width: 80, align: 'center'},
            {
                field: 'salePrice', title: '售价', width: 80, align: 'right',
                formatter:function (val,row){
                return moneyFormatter2(val);
            }},
            {field: 'goodsId', title: '产品id', hidden: true},
            {
                field: 'quantity', title: '库存数量', width: 80, align: 'right',
                formatter:function(val,row){
                return numberF(val);
            }},
            {
                field: 'reallyQuantity',
                title: '实盘数量',
                align: 'right',
                width: 80,
                editor: {
                    type: 'numberbox', options: {
                        precision: 2,min: 0,  max: 999.99, required: true,missingMessage:'实盘数量为必填项',
                        onChange: function (newValue, oldValue) {
                            editRowIndex = getRowIndex(this);
                            _oldValue_so = newValue == '' ? oldValue : _oldValue_so;
                            oldValue = _oldValue_so == '0' ? oldValue : _oldValue_so;
                            if (oldValue != "" && newValue != '') {
                                amountOperation(parseFloat(newValue), oldValue);
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
                field: 'checkQuantity', title: '损益数量', width: 100, align: 'right',
                formatter: function (val, row) {
                    return numberF(val);
                }},
            {field: 'avgAmount',title:'成本价',hidden:true},
            {field:'purchasingPrice',title:'进价',hidden:true},
            {
                field: 'checkAmount',
                title: '损益金额',
                width: 120,
                align: 'right',
                hidden:true,
                formatter: function (val, row) {
                    return moneyFormatter2(val);
                }
            }
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

        //quantity: 0,
        reallyQuantity: 0,
        checkQuantity: 0,
        checkAmount: '0.00'
    }]);
    if(proStatus == ''){
        insert();
    }
}
function importGoods(oldValue,newValue,queryUrl){
    if(isRefresh &&((newValue && !oldValue) || (oldValue && newValue && newValue!=oldValue))){
        var url = queryUrl+newValue+"&isStore=1";
        $.post(url,null, function (data) {
            if(data.total == 1){
                check_pushMenuRows(data.rows,false)
            }else{
                check_addGoods(false,newValue)
            }
        },"json");
    }

}
function operator() {
    return add + d;
}
var isRefresh = true;
function appendGoodsRow() {
    isRefresh = true;
    $('#goodsTable_info').datagrid('appendRow', {
        add: operator()
    });
    beginEditAll();
}
function deleterow(target) {
    var row = $('#goodsTable_info').datagrid('getRows');
    if (row.length > 1) {
        $.messager.confirm('系统提示', '你确定删除?', function (r) {
            if (r) {
                var deleteRow = row[getRowIndex(target)];
                footerOperation('-', deleteRow.reallyQuantity, deleteRow.checkQuantity, deleteRow.checkAmount);
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
function _get_push() {
    return [];
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

function check_add_good(){
    var rows = $("#goodsTable").datagrid("getSelections");
    if (rows.length == 0) {
        $.messager.alert("系统提示", "你还没有选择任何商品!", "info");
        return;
    }
    check_pushMenuRows(rows,true);
}
function checkSelectedItem() {
    var row = $('#goodsTable_info').datagrid('getRows');
    $.each(row, function (i, item) {
        $('#goodsTable').datagrid('selectRecord', item.goodsId);
    });
}

function validateRow(i) {
    return $('#goodsTable_info').datagrid("validateRow", i);
}
function endEdit(i) {
    $('#goodsTable_info').datagrid("endEdit", i);
}
function beginEdit(i) {
    var h_id = $('#h_id').val();
    if (h_id === '' || update_p_o == true) {
        $('#goodsTable_info').datagrid("beginEdit", i);
    }
}
var is_first_store;//是否第一次出现在库存表
function amountOperation(newValue, oldValue) {
    var rows = $('#goodsTable_info').datagrid('getRows');
    $.each(rows, function (i, item) {
        if (i == editRowIndex) {
            var price;
            if(is_first_store){
                price=item.purchasingPrice;
            }else{
                price=item.avgAmount
            }
            var hj_reallyQuantity=(parseFloat(newValue) - parseFloat(oldValue)).toFixed(2);
            var hj_checkQuantity=parseFloat(newValue)- parseFloat(item.checkQuantity);

            item.checkQuantity=parseFloat(newValue)-parseFloat(item.quantity);
            item.checkAmount=((parseFloat(newValue)-parseFloat(item.quantity)) * parseFloat(price)).toFixed(2);
            var hj_checkAmount=(parseFloat(hj_checkQuantity * price)).toFixed(2);
            footerOperation('+', hj_reallyQuantity, hj_checkQuantity, hj_checkAmount);
            return;
        }
    });
    _oldValue_so = '0';
    if (editRowIndex != -1) {
        endEdit(editRowIndex);
        $('#goodsTable_info').datagrid('refreshRow', editRowIndex);
        beginEdit(editRowIndex);
    }
}
function footerOperation(op,reallyQuantity,  checkQuantity,checkAmount) {
    var rows = $('#goodsTable_info').datagrid('getFooterRows');
    if (op === '+') {
        //rows[0]['quantity'] = (parseFloat(rows[0]['quantity']) + parseFloat(quantity)).toFixed(2);
        rows[0]['reallyQuantity'] = (parseFloat(rows[0]['reallyQuantity']) + parseFloat(reallyQuantity)).toFixed(2);
        rows[0]['checkQuantity'] = (parseFloat(rows[0]['checkQuantity']) + parseFloat(checkQuantity)).toFixed(2);
        rows[0]['checkAmount'] = (parseFloat(rows[0]['checkAmount']) + parseFloat(checkAmount)).toFixed(2);
    }
    if(op === '-'){
        rows[0]['reallyQuantity'] = (parseFloat(rows[0]['reallyQuantity']) - parseFloat(reallyQuantity)).toFixed(2);
        rows[0]['checkQuantity'] = (parseFloat(rows[0]['checkQuantity']) - parseFloat(checkQuantity)).toFixed(2);
        rows[0]['checkAmount'] = (parseFloat(rows[0]['checkAmount']) - parseFloat(checkAmount)).toFixed(2);
    }
    $('#goodsTable_info').datagrid('reloadFooter');
}
//删除明细
function del_details() {
    var rows = $('#goodsTable_info').datagrid('getSelections');
    var reallyQuantity_d = parseFloat(0);
    var checkQuantity_d = parseFloat(0);
    var checkAmount_d = parseFloat(0);
    var size_ttt = rows.length;
    for (var x = 0; x < size_ttt; x++) {
        var reallyQuantity_dd = rows[x].reallyQuantity;
        var checkQuantity_dd =  rows[x].checkQuantity;
        var checkAmount_dd = rows[x].checkAmount;
        reallyQuantity_d += parseFloat(reallyQuantity_dd);
        checkQuantity_d += parseFloat(checkQuantity_dd);
        checkAmount_d += parseFloat(checkAmount_dd);
    }
    for (var x = 0; x < size_ttt; x++) {
        var a = $('#goodsTable_info').datagrid('getSelections');
        $('#goodsTable_info').datagrid('deleteRow', $('#goodsTable_info').datagrid('getRowIndex', a[0]));
    }
    $('#goodsTable_info').datagrid('clearSelections');
    footerOperation('-', reallyQuantity_d, checkQuantity_d, checkAmount_d);
}
function check_pushMenuRows(f,dialogFlag){
    var quantity;//库存数量
    var realQuantity;//实盘数量
    var checkQuantity;//损益数量
    var checkAmount;//损益金额
    var goodsId;
    var reLoadFooter = true;
    isRefresh = false;
    var oldRow = $('#goodsTable_info').datagrid('getRows');
    $('#goodsTable_info').datagrid('loadData',{total:0,rows:[]});
    //var oldRow = $('#goodsTable_info').data("_old_rows");

    if(!oldRow){
        // 如果原行数据为空则缓存行数据
        oldRow = f;
    }else{
        // 如果原行数据不为空，进行补充或者替换
        if(dialogFlag){
            debugger;
            if($('#goodsTable_info').data("_replace")){
                // 当前为弹窗时，如果为正常弹窗替换数据
                if(oldRow.length > f.length){
                    $.each(oldRow,function(index,value){
                        var isDeletes = [];
                        for(var k in f){
                            if(f[k].id == value.goodsId){
                                isDeletes.push(true)
                            }else{
                                isDeletes.push(false)
                            }
                        }
                        if($.inArray(true, isDeletes) == -1){
                            oldRow.splice(index,1);
                            footerOperation('-',value.reallyQuantity,value.checkQuantity,value.checkAmount);
                            reLoadFooter = false
                        }
                    });
                }
                for(var key in f){
                    var wating_append_row = f[key];
                    var isAppend = true;
                    for(var k in oldRow){
                        if(oldRow[k].goodsId!=undefined && wating_append_row.id!=undefined && oldRow[k].goodsId == wating_append_row.id){
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
                debugger;
                // 为模糊检索的弹窗要在原始数据中加入新的行数据
                if(oldRow.length > f.length){
                    $.each(oldRow,function(index,value){
                        var isDeletes = [];
                        for(var k in f){
                            if(f[k].id == value.goodsId){
                                isDeletes.push(true)
                            }else{
                                isDeletes.push(false)
                            }
                        }
                        if($.inArray(true, isDeletes) == -1){
                            oldRow.splice(index,1);
                            footerOperation('-',value.reallyQuantity,value.checkQuantity,value.checkAmount);
                            reLoadFooter = false
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
            if(oldRow && oldRow[0].goodsId){
            debugger;

            var isAppend = true;
            for(var key in oldRow){
                if(oldRow[key].goodsId == f[0].id){
                    isAppend = false;
                    $.messager.alert('系统提示', '商品不能重复添加！', 'warning');
                    break;
                }
            }
            if(isAppend){
                debugger;
                oldRow.push(f[0]);
            }
            }else {
                debugger;
                oldRow=f;
            }
        }
    }
    debugger;
    //$('#goodsTable_info').data("_old_rows",oldRow);
    $.each(oldRow, function (index, item) {
        if(item.quantity==null){
            is_first_store=true;
            quantity=0.00;
            realQuantity=0.00;
            checkQuantity = 0.00;
            checkAmount = 0.00;
            goodsId = item.goodsId
        }else{
            is_first_store=false;
            quantity=item.quantity;
            if(item.reallyQuantity){
                realQuantity=item.reallyQuantity;
            }else {
                realQuantity=0.00;
            }
            if(item.reallyQuantity){
                checkQuantity = item.checkQuantity;
            }else {
                checkQuantity=0.00;
            }
            if(item.reallyQuantity){
                checkQuantity = item.checkQuantity;
                checkAmount = checkQuantity * item.purchasingPrice
            }else {
                checkQuantity=0.00;
                checkAmount = 0.00;

            }

            goodsId = item.goodsId
        }
        if(item.barCode!=undefined){
            $('#goodsTable_info').datagrid('appendRow',
                {
                    add: operator(),
                    id: ii--,
                    barCode: item.barCode,
                    goodsName: item.goodsName,
                    categoryName: item.categoryName,
                    goodsUnitName: item.goodsUnitName,
                    salePrice: item.salePrice,
                    goodsId: goodsId,
                    avgAmount:item.avgAmount,
                    purchasingPrice:item.purchasingPrice,
                    quantity: quantity,
                    reallyQuantity: realQuantity,
                    checkQuantity: checkQuantity,
                    checkAmount: checkAmount
                }
            );
            if(item.quantity == null && reLoadFooter){
                footerOperation('+', realQuantity, checkQuantity,checkAmount);
            }

        }

    });
    //让所有行处于可编辑状态
    $.each(oldRow,function(index,item){
        $('#goodsTable_info').datagrid("beginEdit", index);
    });
    $('#goodsDialog').dialog('close');
    $('#goodsTable_info').datagrid('getFooterRows')
}

var insertCounts=0;
//function pushRowsArray(f,dialogFlag) {
//    var old = $('#goodsTable_info').datagrid('getRows');
//    var old_length = old.length;
//    var goodsRow = f;
//    var is_insert = true;
//    var quantity;//库存数量
//    var realQuantity;//实盘数量
//
//    $.each(goodsRow, function (index, item) {
//        is_insert = true
//        $.each(old, function (dd, ol) {
//            if (ol.goodsId == item.goodsId) {
//                is_insert = false
//                return
//            }
//        });
//        if(item.quantity==null){
//            is_first_store=true;
//            quantity=0.00;
//            realQuantity=0.00;
//        }else{
//            is_first_store=false;
//            quantity=item.quantity;
//            realQuantity=0.00;
//        }
//        if (is_insert) {
//            $('#goodsTable_info').datagrid('insertRow', {
//                row: {
//                    id: ii--,
//                    barCode: item.barCode,
//                    goodsName: item.goodsName,
//                    categoryName: item.categoryName,
//                    goodsUnitName: item.goodsUnitName,
//                    salePrice: item.salePrice,
//                    goodsId: item.goodsId,
//                    avgAmount:item.avgAmount,
//                    purchasingPrice:item.purchasingPrice,
//                    quantity: quantity.toFixed(2),
//                    reallyQuantity: realQuantity.toFixed(2),
//                    checkQuantity: 0.00.toFixed(2),
//                    checkAmount: (0 * 0).toFixed(2)
//
//                }
//            });
//            footerOperation('+', realQuantity, 0,0);
//            insertCounts=insertCounts+1
//        }
//        if(insertCounts==goodsRow.length){
//            is_insert=false
//        }
//    });
//    for (var xy = old_length; xy < old.length; xy++) {
//        $('#goodsTable_info').datagrid('selectRow', xy);
//    }
//    $('#goodsDialog').dialog('close');
//    $('#tenant_query').val('');
//    $('#goodsTable_info').datagrid('getFooterRows')
//}
function initCheckOrderPro(url) {
    var h_id = $('#h_id').val();
    var h_status = $('#h_status').val();
    var h_op_type = $('#h_op_type').val();
    if (h_id !== '') {
        doSearchProG(url);
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
            item.purchasingPrice = item.purchasePrice;
            item.avgAmount = item.purchasePrice;
            item.add = operator();
        });
        $('#goodsTable_info').datagrid('loadData',data.rows);
        $('#goodsTable_info').datagrid('reloadFooter',data.footer);
    }, 'json');
}
function PDDetailUpdate(){
    if( update_p_o){
        able('enable');
        //$('#p_audit').hide();
        $('#p_save').show();
        //$('#p_del').hide();
        $('#p_update').hide();
    }

}

function able(able) {
    $('#pro_memo').textbox(able);
    if($('#pro_memo').textbox('getValue') == ''){
        $('#pro_memo').textbox('setValue',' ');
    }
    $('#branch').textbox(able);
    if (able === 'disable') {
        $('#cp_print').hide();
        $('#cp_ok').hide();
        $('#cp_remove').hide();
        return;
    }
    $('#cp_print').show();
    $('#cp_ok').show();
    $('#cp_remove').show();
}
function audit_checkOrder(url) {
    //var changeRows = $('#goodsTable_info').datagrid('getChanges');
    //if(changeRows.length > 0){
    //    $.messager.alert('系统提示', '请先保存数据！', 'info');
    //    return
    //}
    $.messager.confirm('系统提示', '请先保存数据,确定审核?', function (r) {
        if (r) {
            var h_id = $('#h_id').val();
            $.post(url + h_id, function (data) {
                if (data.success == 'true') {
                    //location.replace(audit_ok_url + h_id);
                    location.replace(backUrl);
                }else{
                    $.messager.alert('系统提示', data.msg, 'info');
                }
            }, 'json');
        }
    });

}
var isFirst=true;
function importDetail(url){
        $.ajax({
            url:url,
            success:function(data){
                check_pushMenuRows(data,false);
                isFirst=false;
            }
        });
}
/**
 * 打印盘点单
 */
function printPdf(url){
    window.open(url + '&orderCode='+$('#code').textbox('getValue'));
}
var warningRealQuantity = [];
var warningCheckAmount = [];
var warningGoodCode = [];
function setSaveData() {
    warningRealQuantity.length = 0;
    warningCheckAmount.length = 0;
    warningGoodCode.length = 0;
    if (!$('#checkOrderForm').form('validate')) {
        return false;
    }
    $('#goodsTable_info').datagrid('checkAll');
    var isOkSave = false;
    var errorIndex = 0
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
            $.messager.alert('系统提示', '请导入账面库存！', 'info');
        } else {
            $.messager.alert('系统提示', '请正确添加第【' + errorIndex + '】行明细！', 'info');
        }
        return false;
    }
    row = $('#goodsTable_info').datagrid('getRows');
    var h_detailsStr = '';
    var j_total = 0;
    $.each(row, function (i, item) {
        h_detailsStr = h_detailsStr + item.goodsId + ',' + item.reallyQuantity  + ';';
        j_total++;
        if (parseFloat(item.checkAmount) > 99999999.99) {
            warningCheckAmount.push(i + 1);
        }
        if(parseFloat(item.reallyQuantity) > 999.99){
            warningRealQuantity.push(i + 1);
        }
        // if(item.barCode.length!=8){
        //     warningGoodCode.push(i + 1);
        // }
    });
    if (j_total === 0) {
        $.messager.alert('系统提示', '请导入账面库存！', 'info');
        return false;
    }
    h_detailsStr = h_detailsStr.substr(0, h_detailsStr.length - 1);
    $('#h_detailsStr').val(h_detailsStr);
    return isOkSave;
}
function savePro(url) {
    if (setSaveData()) {
        var msg = '';
        if (warningCheckAmount.length > 0) {
            msg = msg + '第【' + warningCheckAmount.toString() + '】行损益金额超出最大范围，请减小实盘数量！  ';
            $.messager.alert('系统提示', msg,  'error',function(){
                beginEditAll()
            });
            return
        }
        if(warningRealQuantity.length > 0){
            $.messager.alert('系统提示', '第【' + warningRealQuantity.toString() + '】行实盘数量超出最大范围，请减小实盘数量!',  'error',function(){
                beginEditAll()
            });
            return
        }
        if(warningGoodCode.length > 0){
            $.messager.alert('系统提示', '第【' + warningGoodCode.toString() + '】行商品编码格式不正确，请正确填写!',  'error',function(){
                beginEditAll()
            });
            return
        }
        $.messager.confirm('系统提示', msg + '确定保存？', function (r) {
            if (r) {
                $('#checkOrderForm').form('submit', {
                    url: url,
                    success: function (data) {
                        var data = eval('(' + data + ')');
                        //if($('#h_id').val() == ''){
                        //    location.replace(add_ok_url + data.order.id);
                        //    return;
                        //}
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
                            beginEditAll()
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