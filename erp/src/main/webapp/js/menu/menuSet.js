/**
 * Created by Administrator on 2015/6/24.
 */
var isClick = false;//是否点击标识
/**
 *所有类别树的setting
 */
var setting = {
    view: {
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
            name: 'catName'
        }
    },
    callback: {
        onClick: treeClick
    }
}
/**
 * 门店树的setting
 */
var branchSetting = {
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
        chkStyle: "checkbox",
        chkboxType: {"Y": "s", "N": "s"}
    }

}
function save(url) {
    isRefresh = false;
    var rowss=$('#menuGoodsTable').datagrid('getRows');
    if(!$("#menuGoodsTable").validateDataGrid()){
        return false
    }
    getChanges();
    formSave("goodsUnitOrder", url, "");

}
function myUpdate() {
    editButton();

}
var treeNodes,zTree;
function load_Branch_Tree(url,trId,setting,fn){
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
            if(fn){
                fn();
            }
        }
    })
}
/**
 * 修改时选中ztree复选框时
 */
function treeOnCheck() {
    var branchIdStr = new String();
    var branchIdArr = [];
    branchIdStr = $("input[name='branchMenu_r']").val();
    if (branchIdStr != "") {
        if (branchIdStr == "-99999") {
            //var bTreeObj=$.fn.zTree.getZTreeObj("branchTree");
            //bTreeObj.checkAllNodes(true);
        } else {
            branchIdArr = branchIdStr.split(",");
            var bTreeObj = $.fn.zTree.getZTreeObj("branchTree");
            var i = 0;
            var name;
            for (var b = 0; b < branchIdArr.length; b++) {
                var select_node = bTreeObj.getNodeByParam("id", branchIdArr[b], null);
                bTreeObj.checkNode(select_node, true, true);
                i = b + 1;
                name = select_node.name
            }
            setBranchText(i, name)
        }

    }
}

/**
 * 修改时选中ztree复选框时,不重载名字
 */
function treeOnCheckByNoReLoadName() {
    var branchIdStr = new String();
    var branchIdArr = [];
    branchIdStr = $("input[name='branchMenu_r']").val();
    if (branchIdStr != "") {
        if (branchIdStr == "-99999") {
            //var bTreeObj=$.fn.zTree.getZTreeObj("branchTree");
            //bTreeObj.checkAllNodes(true);
        } else {
            branchIdArr = branchIdStr.split(",");
            var bTreeObj = $.fn.zTree.getZTreeObj("branchTree");
            var i = 0
            var name
            for (var b = 0; b < branchIdArr.length; b++) {
                var select_node = bTreeObj.getNodeByParam("id", branchIdArr[b], null);
                bTreeObj.checkNode(select_node, true, true);
                i = b + 1;
                name = select_node.name
            }
        }

    }
}

/**
 * 选中tree复选框,点击确定时
 *待删除
 */
function okCheck_delete() {
    var checkIndex = 0;
    var ids = [];
    var name;
    var tree = $.fn.zTree.getZTreeObj("branchTree");
    var nodeAll = tree.getNodes();
    nodeAll.length;
    var nodes = tree.getCheckedNodes(true);
    if (nodes != null && nodes.length != 0) {
        for (var n = 0; n < nodes.length; n++) {
            //var pId=nodes[n].parentId
            //if(pId!=null&&pId!=0){
            //    ids.push(nodes[n].childrenId)
            //    name=nodes[n].nodeName;
            //    checkIndex++
            //}
            if (nodes[n].pId != null && nodes[n].pId != -1) { //去掉总部区域
                ids.push(nodes[n].id)
                name = nodes[n].name;
                checkIndex = checkIndex + 1;
            }
        }
        setBranchText(checkIndex, name);
        $("input[name='branchMenu_r']").val(ids);
        $("#branchDialog").dialog('close');
    } else {
        $.messager.alert("系统提示", "您还没有选择任何门店！", "info");
    }
}
function setBranchText(checkIndex, name) {
    if (checkIndex == 1) {
        $("#branchCode").textbox("setText", name);
    }
    else if (getBranchNum() == checkIndex) {
        $("#branchCode").textbox("setText", "全部门店");
    }
    else {
        $("#branchCode").textbox("setText", "已选中" + checkIndex + "个门店");
    }
}
function getBranchNum() {
    var tree = $.fn.zTree.getZTreeObj("branchTree");
    var branchNum = 0;
    $.each(tree.transformToArray(tree.getNodes()[0]), function (i, item) {
        if (item.nodeType == '1') {
            ++branchNum
        }
    });
    return branchNum
}
/**
 * 分类树点击事件
 * @param event
 * @param treeId
 * @param treeNode
 */
function treeClick(event, treeId, treeNode) {
    loadGrid();
    if (isClick == true) {
        var rows = $('#menuGoodsTable').datagrid("getSelections");
        for (var i = 0; i < rows.length; i++) {
            var index = $("#menuGoodsTable").datagrid("getRowIndex", rows[i]);
            $('#menuGoodsTable').datagrid("endEdit", index);
        }
    }
    var categoryIds = [];
    if (treeNode.id == -1) {
        categoryIds = []
    } else {
        var boolean = treeNode.isParent;
        if (boolean == true) {
            var childrens = treeNode.children;
            for (var c = 0; c < childrens.length; c++) {
                categoryIds.push(childrens[c].id);
            }
            //categoryIds.push(treeNode.id);
        }
        else {
            categoryIds.push(treeNode.id);
        }
    }
    $("#categoryIds").val(categoryIds);
    doSearch();
}
function doSearch() {
    $('#menuGoodsTable').datagrid({
        queryParams: {
            goodsCodeOrName: $("#queryStr").searchbox("getValue"),
            categoryIds: $("#categoryIds").val()
        }
    });
}
/**
 * 日期控件校验方法
 **/
function loadDatebox() {
    var startDate;
    var endDate;
    $('#cronStartAt').datebox({
        required: true,
        editable: false,
        validType: 'validateStartDate',
        onSelect: function (date) {
            endDate = $("#cronEndAt").datebox('getValue');
            startDate = $("#cronStartAt").datebox('getValue');
            if (endDate) {
                if (startDate > endDate) {
                    $('#cronStartAt').datebox('setValue', '').datebox('showPanel');
                }
            }
        }
    }).datebox('calendar').calendar({
        validator: function (date) {
            var now = new Date();
            var d1 = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            return d1 <= date;
        }
    });
    $('#cronEndAt').datebox({
        required: true,
        editable: false,
        validType: 'validateEndDate',
        onSelect: function (date) {
            startDate = $("#cronStartAt").datebox('getValue');
            endDate = $("#cronEndAt").datebox('getValue');
            if (startDate) {
                if (endDate < startDate) {
                    $('#cronEndAt').datebox('setValue', '').datebox('showPanel');
                }
            }

        }
    }).datebox('calendar').calendar({
        validator: function (date) {
            var now = new Date();
            var d1 = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            return d1 <= date;
        }
    });

}

function insert(item) {
    $('#menuGoodsTable').datagrid('insertRow', {
        row: {
            add: operator()
            //,
            //goodsCode: addBtn
        }
    });
    var row = $('#menuGoodsTable').datagrid('getRows');
    if (row) {
        var num = row.length - 1;
        var index = $('#menuGoodsTable').datagrid('getRowIndex', row[num]);
    } else {
        index = 0;
    }
    $('#menuGoodsTable').datagrid('beginEdit', index);
}
var isRefresh = true;
function appendGoodsRow() {
    isRefresh = true;
    $('#menuGoodsTable').datagrid('appendRow', {
        add: operator()
    });
    var row = $('#menuGoodsTable').datagrid('getRows');
    $.each(row,function(index,item){
        $('#menuGoodsTable').datagrid('beginEdit', index);
    });
}
function operator() {
    return add + d;
}

function deleterow(target) {
    var row = $('#menuGoodsTable').datagrid('getRows');
    if (row.length > 1) {
        $.messager.confirm('系统提示', '你确定删除?', function (r) {
            if (r) {
                $('#menuGoodsTable').datagrid('deleteRow', getRowIndex(target));
            }
        });
    }else{
        $.messager.alert("系统提示", "菜品明细不能为空！", "warning");
    }
}
function getRowIndex(target) {
    var tr = $(target).closest('tr.datagrid-row');
    return parseInt(tr.attr('datagrid-row-index'));
}

function _get_push() {
    return [];
}

function checkSelectedItem() {
    //$('#goodsTable').datagrid('clearSelections');
    var row = $('#menuGoodsTable').datagrid('getRows');
    $.each(row, function (i, item) {
        $('#goodsTable').datagrid('selectRecord', item.id);
    });
}
function menu_add_good() {
    var rows = $("#goodsTable").datagrid("getSelections");
    if (rows.length == 0) {
        $.messager.alert("系统提示", "你还没有选择任何菜品!", "info");
        return;
    }
    pushMenuRows(rows,true,$("#goodsDialog").data("orignal"));
    $("#goodsDialog").data("orignal",null)
}
function pushMenuRows(f,dialogFlag,oldValue){
    isRefresh = false;
    $('#menuGoodsTable').datagrid('loadData',{total:0,rows:[]});
    var originalRow = $('#menuGoodsTable').data("_old_rows");
    var oldRow = [];
    for(var key in originalRow){
        if(originalRow[key].goodsCode != oldValue){
            oldRow.push(originalRow[key])
        }
    }
    if(!oldRow){
        // 如果原行数据为空则缓存行数据
        oldRow = f;
    }else{
        // 如果原行数据不为空，进行补充或者替换
        if(dialogFlag){
            if($('#menuGoodsTable').data("_replace")){
                // 当前为弹窗时，如果为正常弹窗替换数据
                oldRow = f;
            }else{
                // 为模糊检索的弹窗要在原始数据中加入新的行数据
                for(var key in f){
                    var wating_append_row = f[key];
                    var isAppend = true;
                    for(var k in oldRow){
                        if(oldRow[k].id == wating_append_row.id){
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
                if(oldRow[key].id == f[0].id){
                    isAppend = false;
                    $.messager.alert('系统提示', '菜品不能重复添加！', 'warning');
                    break;
                }
            }
            if(isAppend){
                oldRow.push(f[0]);
            }
        }
    }
    $('#menuGoodsTable').data("_old_rows",oldRow);
    $.each(oldRow, function (index, item) {
            $('#menuGoodsTable').datagrid('appendRow',
                    {
                        add: operator(),
                        id: item.id,
                        goodsCode: item.goodsCode
                        //+ addBtn
                        ,
                        goodsName: item.goodsName,
                        categoryName: item.categoryName,
                        salePrice: item.salePrice,
                        vipPrice: item.vipPrice,
                        vipPrice2: item.vipPrice2
                    }
            );
    });
    //让所有行处于可编辑状态
    $.each(oldRow,function(index,item){
        $('#menuGoodsTable').datagrid("beginEdit", index);
    });
    $('#goodsDialog').dialog('close');
    isRefresh = true
}

function validateRow(i) {
    return $('#menuGoodsTable').datagrid("validateRow", i);
}

function importGoods(oldValue,newValue,queryUrl){
    if(isRefresh &&((newValue && !oldValue) || (oldValue && newValue && newValue!=oldValue))){
        var url = queryUrl+newValue;
        $.post(url,null, function (data) {
            if(data.total == 1){
                pushMenuRows(data.rows,false,oldValue)
            }else{
                addGoods(false,newValue)
            }
        },"json");
    }

}


//***********加载datagrid数据*****************//
var dataArray = [];//定义datagrid array
function newDataGrid(url) {
    $("#menuGoodsTable").datagrid({
        url: '' + url + '',
        title: "商品列表",
        singleSelect: false,
        pagination: false,
        fit: true,
        fitColumns: false,
        idField: 'id',
        rownumbers: true,
        width: 'auto',
        height: 'auto',
        nowrap: false,
        striped: true,
        border: true,
        collapsible: this.collapsible,
        checkOnSelect: false,
        frozenColumns: [[{field: 'id', checkbox: true}]],
        columns: [[
            {field: 'goodsCode', title: '菜品编码', width: 80, align: 'left'},
            {field: 'goodsName', title: '菜品名称', width: 80, align: 'center'},
            {field: 'categoryName', title: '菜品分类', width: 80, align: 'center'},
            {
                field: 'salePrice',
                title: '零售价',
                align: 'right',
                width: 80,
                align: 'right',
                editor: {type: 'numberbox', options: {precision: 2}},
                formatter: moneyFormatter
            },
            {
                field: 'vipPrice',
                title: '会员价1',
                width: 80,
                align: 'right',
                editor: {type: 'numberbox', options: {precision: 2}},
                formatter: moneyFormatter
            },
            {
                field: 'vipPrice2',
                title: '会员价2',
                width: 80,
                align: 'right',
                editor: {type: 'numberbox', options: {precision: 2}},
                formatter: moneyFormatter
            },
            {field: 'operate', title: '操作', width: 80, align: 'center', formatter: operate}
        ]],
        onLoadSuccess: function (data) {
            if (data.rows == 0) {
            }
        },
        onClickCell: function (index, field) {
            if (field == "operate") {
                if (isEdit == true) {
                    endEdit(index)
                } else {
                    editRow(index);
                }
            }
        },
        onCheck: function (index, row) {
            endEdit(index);
            if (dataArray.length > 0) {
                for (var i = 0; i < dataArray.length; i++) {
                    if (dataArray[i].goodsId == row.id) {
                        $(this).datagrid("uncheckRow", index);
                        $.messager.alert("系统提示", "此菜品已经被选择！", "info");
                        return;
                    }
                }
            }
            dataArray.push(row);
        },
        onUncheck: function (index, row) {
            if (dataArray != []) {
                for (var i = 0; i < dataArray.length; i++) {
                    if (row.id == dataArray[i].id) {
                        dataArray.splice(i, 1);
                        return;
                    }
                }
            }
        },
        onCheckAll: function (rows) {
            for (var r = 0; r < rows.length; r++) {
                if (dataArray != [] && dataArray[r] != undefined) {
                    if (rows[r].id == dataArray[r].id) {
                        dataArray.splice(r, 1);
                    }
                }
                endEdit(r);
                dataArray.push(rows[r]);
            }
        },
        onUncheckAll: function (rows) {
            if (dataArray != []) {
                for (var i = 0; i < rows.length; i++) {
                    var index = $.inArray(rows[i], dataArray);
                    dataArray.splice(index, 1);
                }
            }
        }
    })
}

/**
 * datagrid操作formatter函数
 */
function operate(value, row, index) {
    return "<a href='javascript:void(0)' class='edPrice" + index + "' style='text-decoration: none'>修改价格</a>"
}
/**
 * 对datagrid进行单行编辑
 */
var isEdit = false;
function editRow(index) {
    isEdit = true;
    $('#menuGoodsTable').datagrid("beginEdit", index);
    $(".edPrice" + index).replaceWith("<a href='javascript:void(0)' id='savePrice' style='text-decoration: none'>保存</a>")
}
/**
 * 结束datagrid行编辑
 */
function endEdit(i) {
    $('#menuGoodsTable').datagrid("endEdit", i);
}
/**
 * 批量修改行
 */
function updateRows() {
    var rows = $('#menuGoodsTable').datagrid("getSelections");
    if (rows.length == 0) {
        $.messager.alert("系统提示", "请至少选择一条数据进行编辑!", "info");
        return;
    }
    for (var i = 0; i < rows.length; i++) {
        var rowIndex = $("#menuGoodsTable").datagrid("getRowIndex", rows[i]);
        $('#menuGoodsTable').datagrid("beginEdit", rowIndex);
        $(".edPrice" + rowIndex).replaceWith("<a href='javascript:void(0)' id='savePrice' style='text-decoration: none'>保存</a>")
    }
}
/**
 * 结束批量修改行
 */
function endUpdateRows() {
    var rows = $('#menuGoodsTable').datagrid("getSelections");
    if (rows.length > 0) {
        for (var i = 0; i < rows.length; i++) {
            endEdit(i);
        }
    }

}

/**
 * 点击触发加载datagrid方法
 */
function loadDataGrid() {
    isClick = true;
    endUpdateRows();
    _init_dataGrid();
    $("#menuGoodsTable").datagrid("checkAll");
}
function _init_dataGrid() {
    $('#menuGoodsTable').datagrid({
        url: "",
        title: "已选商品",
        singleSelect: false,
        pagination: false,
        fit: true,
        fitColumns: false,
        idField: 'id',
        rownumbers: true,
        width: 'auto',
        height: 'auto',
        nowrap: false,
        striped: true,
        border: true,
        checkOnSelect: false,
        data: dataArray,
        frozenColumns: [[{field: 'id', checkbox: true}]],
        columns: [[
            {field: 'goodsCode', title: '菜品编码', width: 80, align: 'left'},
            {field: 'goodsName', title: '菜品名称', width: 80, align: 'center'},
            {field: 'categoryName', title: '菜品分类', width: 80, align: 'center'},
            {
                field: 'salePrice',
                title: '零售价',
                align: 'right',
                width: 80,
                align: 'right',
                editor: {type: 'numberbox', options: {precision: 2}},
                formatter: moneyFormatter
            },
            {
                field: 'vipPrice',
                title: '会员价1',
                width: 80,
                align: 'right',
                editor: {type: 'numberbox', options: {precision: 2}},
                formatter: moneyFormatter
            },
            {
                field: 'vipPrice2',
                title: '会员价2',
                width: 80,
                align: 'right',
                editor: {type: 'numberbox', options: {precision: 2}},
                formatter: moneyFormatter
            },
            {field: 'operate', title: '操作', width: 80, align: 'center', formatter: operate}
        ]],
        onLoadSuccess: function () {

        },
        onClickCell: function (index, field) {
            if (field == "operate") {
                editRow(index);
            }
        },
        onCheck: function (index, row) {

        },
        onUncheck: function (index, row) {
            if (dataArray != []) {
                for (var i = 0; i < dataArray.length; i++) {
                    if (row.id == dataArray[i].id) {
                        dataArray.splice(i, 1);
                        return;
                    }
                }
            }
        },
        onCheckAll: function (rows) {

        },
        onUncheckAll: function (rows) {
            if (dataArray != []) {
                for (var i = 0; i < rows.length; i++) {
                    var index = $.inArray(rows[i], dataArray);
                    dataArray.splice(index, 1);
                }
            }
        }
    })
}

/**
 * 得到表格编辑后的值
 */
function getChanges() {
    var menuGoodString = "";
    var rows = $('#menuGoodsTable').datagrid("getRows");
    //var crows = $('#menuGoodsTable').datagrid("getChanges");
    //crows.length;
    for (var i = 0; i < rows.length; i++) {
        var index = $('#menuGoodsTable').datagrid("getRowIndex", rows[i]);
        endEdit(index);
        var goodsId = rows[i].id;
        var goodsCode = rows[i].goodsCode;
        var goodsName = rows[i].goodsName;
        var salePrice = rows[i].salePrice;
        var vipPrice = rows[i].vipPrice;
        var vipPrice2 = rows[i].vipPrice2;
        menuGoodString += "" + goodsId + "##" + goodsCode + "##" + goodsName + "##" + salePrice + "##" + vipPrice + "##" + vipPrice2 + "%%";
    }
    var mainString = menuGoodString.substring(0, menuGoodString.length - 2);
    $("#checkGood").val(mainString);
}

/**
 * 点击保存时对按钮进行控制
 */
function conButton() {
    $("#add").linkbutton("disable");
    $("#update").linkbutton("enable");
    $("#copy").linkbutton("enable");
    $("#updates").linkbutton("disable");
    $("#branchCode").textbox("readonly", true);
    $("#menuName").textbox("readonly", true);
    $('#cronStartAt').datebox("readonly", true);
    $('#cronEndAt').datebox("readonly", true);
    $("#status").combobox("readonly", true);
    $("input[type='radio']").each(function () {
        $(this).attr("disabled", true);
    });
}
/**
 * 点击修改时对按钮进行控制
 */
function editButton() {
    $("#add").linkbutton("enable");
    $("#updates").linkbutton("enable");
    $("#branchCode").textbox("readonly", false);
    $("#menuName").textbox("readonly", false);
    $('#cronStartAt').datebox("readonly", false);
    $('#cronEndAt').datebox("readonly", false);
    $("input[type='radio']").each(function () {
        $(this).attr("disabled", false);
    });
    $("#status").combobox("readonly", false);
}


/**
 * form提交方法
 */
function formSave(formId, url, dialogId) {
    $("#" + formId + "").form('submit', {
        url: url,
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
            if (result.isSuccess == "false" || result.success == "false") {
                $('#sub').linkbutton('enable');
                $.messager.alert('系统提示', "保存失败！", 'error');
            } else {
                $('#sub').linkbutton('enable');
                    $.messager.alert('系统提示', "保存成功！", 'info');
                //conButton();
                $("#menuId").val(result.id);
                if (dialogId != "") {
                    $("#" + dialogId + "").window("close");
                }
                var goodsDatas =  $('#menuGoodsTable').datagrid('getRows');
                $.each(goodsDatas,function(index,item){
                    $('#menuGoodsTable').datagrid("beginEdit", index);
                });
            }
        },
        onLoadError: function () {
            $.messager.alert('系统提示', "加载数据失败，请稍后再试！", 'error');
        }
    });
}
/**
 *
 * @param url
 * @param url1
 * @param isCopy
 * @param urls 保存复制的菜牌信息
 */
function loadUpdateData(url, url1, isCopy, url2,url3,fn) {
    $.ajax({
        url: url,
        cache: false,
        dataType: 'json',
        async: true,
        success: function (data) {
            $("#goodsUnitOrder").form("load", data);
            $("input[name='branchMenu_r']").val(data.branchIds.replace(/!#/g, ','));
            if(fn){
                fn();
            }
            if (isCopy == "1") {
                getNextCode(url2,isCopy);
            }
            loadEditDataGrid(url1,url3);
        }

    })

}
/**
 * 修改时加载表格数据
 * @param url
 */
var editDatas = [];
function loadEditDataGrid(url,url3) {
    $.post(url, function (data) {
        editDatas = data.rows;
        var insertIndex = 0;
        for(var i=0;i<editDatas.length;i++){
            $('#menuGoodsTable').datagrid('appendRow', {
                add: operator()
            });
        }
        $.each(editDatas,function(index,item){
                $('#menuGoodsTable').datagrid('updateRow', {
                    index:insertIndex,
                    row: {
                        add: operator(),
                        id: item.goodsId,
                        goodsCode: item.goodsCode
                        //+ addBtn
                        ,
                        goodsName: item.goodsName,
                        categoryName: item.categoryName,
                        salePrice: item.salePrice,
                        vipPrice: item.vipPrice,
                        vipPrice2: item.vipPrice2
                    }
                });
                insertIndex++;
                $('#menuGoodsTable').datagrid("beginEdit", index);
        });
        var menuId = $("#menuId").val();
        if(menuId == "" || menuId == undefined){
            //save(url3);//复制一条菜牌信息
        }

    }, "json")
}
/**
 *复制调用方法
 * @param url
 */
function getNextCode(url,isCopy) {
    var menuId = $("#menuId").val();
    if (menuId != "" && menuId != undefined) {
        $("#menuId").val("");
    }
    $.post(url, function (data) {
        $("#menuCode").textbox("setValue", data);
        if(isCopy == undefined){
            $.messager.confirm('系统提示', '请先保存数据，确定复制?', function (r) {
                if (r) {
                    save(saveGoodsUrl);
                }
            });
        }
    });


}
/**
 * 取消调用方法
 */
function cancel() {
    $("#goodsUnitOrder").form("reset");
    $('#menuGoodsTable').datagrid("reload");
    conButton();
}
